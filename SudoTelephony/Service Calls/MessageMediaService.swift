//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import AWSAppSync
import AWSS3
import Foundation
import MobileCoreServices
import SudoLogging
import SudoUser

/// Handles media upload/download functionality for messages.
/// Downloaded data is sealed and must be decrypted.
protocol MessageMediaServices {
    /// Uploads message media
    /// - Parameters:
    ///   - url: url of the file to be uploaded
    ///   - completion: Handler called with upload results.  On success returns the metadata
    ///   of the file upload so it can be referenced in other parts of the SDK.
    func uploadFile(url: URL, completion: @escaping ClientCompletion<MediaObject>)

    /// Downloads sealed message media data
    /// - Parameters:
    ///   - media: the media object to download
    ///   - completion: handler called when complete. Downloaded media is sealed and must be decrypted.
    func downloadSealedData(for media: MediaObject, completion: @escaping ClientCompletion<SealedData>)
}

class MessageMediaService: MessageMediaServices {
    // MARK: Properties

    // S3 Transfer utility to facilitate transfers with AWS
    var s3TransferUtility: TransferUtility

    // UserClient providing user identity information for file naming.
    var userClient: SudoUserClient

    // Logger
    var logger: Logger

    /// Transient S3 bucket used by directory service for storing large objects.
    /// Objects in this bucket have a short TTL
    let transientBucket: String

    /// The AWS region of the S3 bucket
    let region: String

    // MARK: Lifecycle

    internal init(s3TransferUtility: TransferUtility,
                  userClient: SudoUserClient,
                  transientBucket: String,
                  region: String,
                  logger: Logger)
    {
        self.logger = logger
        self.s3TransferUtility = s3TransferUtility
        self.userClient = userClient
        self.transientBucket = transientBucket
        self.region = region
    }

    // MARK: Upload

    /// Uploads a file to S3.
    /// - Parameters:
    ///   - url: url of the file to be uploaded
    ///   - completion: Handler called with upload results.  On success returns the metadata
    ///   of the file upload so it can be referenced in other parts of the SDK.
    func uploadFile(url: URL, completion: @escaping ClientCompletion<MediaObject>) {
        // Create an s3 keypath where the file will be uploaded
        guard let s3KeyPath = self.s3KeyPath(s3Key: UUID().uuidString) else {
            // Creating an s3 keypath will fail if it's unable to get the identity id from SudoUserClient.
            completion(.failure(SudoTelephonyClientError.notSignedIn))
            return
        }

        self.uploadFile(localUrl: url, s3KeyPath: s3KeyPath, s3Bucket: self.transientBucket, completion: completion)
    }

    private func uploadFile(localUrl: URL, s3KeyPath: String, s3Bucket: String, completion: @escaping ClientCompletion<MediaObject>) {
        self.logger.info("Uploading \(localUrl.lastPathComponent) to S3")

        let fileManager = FileManager()
        guard fileManager.fileExists(atPath: localUrl.path) else {
            completion(.failure(SudoTelephonyClientError.fileNotFound))
            return
        }

        let fileExtension = localUrl.pathExtension
        if fileExtension.count < 1 {
            completion(.failure(SudoTelephonyClientError.invalidFileFormat))
            return
        }
        guard let extUti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension as CFString, nil)?.takeRetainedValue() else {
            completion(.failure(SudoTelephonyClientError.invalidFileFormat))
            return
        }
        guard let mimeType = UTTypeCopyPreferredTagWithClass(extUti, kUTTagClassMIMEType)?.takeRetainedValue() as String? else {
            completion(.failure(SudoTelephonyClientError.invalidFileFormat))
            return
        }

        guard mimeType == "image/jpeg" || mimeType == "image/png" || mimeType == "image/gif" else {
            completion(.failure(SudoTelephonyClientError.unsupportedMediaContentType))
            return
        }

        guard let fileData = fileManager.contents(atPath: localUrl.path) else {
            completion(.failure(SudoTelephonyClientError.fileNotFound))
            return
        }

        self.s3TransferUtility.uploadData(fileData, bucket: s3Bucket, key: s3KeyPath, contentType: mimeType, expression: nil) { task, error in
            // https://github.com/aws-amplify/aws-sdk-ios/issues/2053
            task.setCompletionHandler { _, _ in }

            guard error == nil else {
                self.logger.error(error?.localizedDescription)
                let taskResult = task.response.debugDescription
                self.logger.error(taskResult)
                completion(.failure(SudoTelephonyClientError.fileUploadFailed))
                return
            }

            self.logger.info("File \(localUrl) successfully uploaded")

            let media = MediaObject(key: s3KeyPath,
                                    bucket: s3Bucket,
                                    region: self.region)

            completion(.success(media))
        }
    }

    private func s3KeyPath(s3Key: String) -> String? {
        guard let identityId = self.userClient.getIdentityId() else { return nil }
        return identityId + "/telephony/media/" + s3Key
    }

    // MARK: Download

    /// Downloads sealed data from S3
    /// - Parameters:
    ///   - media: the media object to download
    ///   - completion: handler called when complete. Downloaded media is sealed and must be decrypted.
    func downloadSealedData(for media: MediaObject, completion: @escaping ClientCompletion<SealedData>) {
        let s3Key = media.key
        self.logger.info("Downloading data \(s3Key)")

        self.s3TransferUtility.downloadData(fromBucket: media.bucket, key: s3Key, expression: nil) { task, _, data, error in
            // https://github.com/aws-amplify/aws-sdk-ios/issues/2053
            task.setCompletionHandler { _, _, _, _ in }

            guard error == nil, let downloadedData = data else {
                if let e = error { self.logger.error(e.localizedDescription) }
                let taskResult = task.response.debugDescription
                self.logger.error(taskResult)
                completion(.failure(SudoTelephonyClientError.fileDownloadFailed))
                return
            }

            self.logger.info("Data \(s3Key) successfully downloaded")
            completion(.success(SealedData(data: downloadedData)))
        }
    }
}

// Represents sealed data that must be decrypted.
struct SealedData {
    let data: Data
}
