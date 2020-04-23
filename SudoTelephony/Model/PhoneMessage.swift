//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// A Message that has been either received or sent by the user.
public struct PhoneMessage {
    
    /// Enum that represents the direction of the message.
    public enum Direction {
        case inbound
        case outbound
        case unknown
        
        init(internalDirection: MessageDirection) {
            switch internalDirection {
            case .inbound:
                self = .inbound
            case .outbound:
                self = .outbound
            case .unknown:
                self = .unknown
            }
        }
    }
    
    /// The state of the message
    public enum State {
        case queued
        case sent
        case delivered
        case undelivered
        case failed
        case received
        case unknown
        
        init(internalState: MessageState) {
            switch internalState {
            case .queued:
                self = .queued
            case .sent:
                self = .sent
            case .delivered:
                self = .delivered
            case .undelivered:
                self = .undelivered
            case .failed:
                self = .failed
            case .received:
                self = .received
            case .unknown:
                self = .unknown
            }
        }
    }
    
    /// Unique ID of the message
    public let id: String
    /// The ID of the owner of the message
    public let owner: String
    /// The conversation ID that this message belongs to
    public let conversation: String
    /// Timestamp that represents the last time the message got updated
    public let updated: Date
    /// Timestamp that represents the time the message got created
    public let created: Date
    /// The E164Number of the local phone number
    public let localPhoneNumber: String
    /// The E164Number of the remote phone number
    public let remotePhoneNumber: String
    /// The body of the message
    public let body: String
    /// The direction of the message. Either `outbound` or `inbound`
    public let direction: Direction
    /// The state of the sending of the message.
    public let state: State
    /// Media Attachments
    public let media: [S3MediaObject]
}


