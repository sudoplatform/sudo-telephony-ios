//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import CallKit
import UIKit

/// A CallProviderConfiguration object controls the native call UI for incoming and outgoing calls, including a localized name for the provider, the ringtone to be played for incoming calls, and the icon to be displayed during calls.
public struct CallProviderConfiguration {
    /// The localized name of the provider.
    public let localizedName: String

    /// The icon image to be displayed for the provider.
    ///
    /// The icon image should be a square with side length of 40 points. The alpha channel of the image is used to create a white image mask, which is used in the system native in-call UI for the button which takes the user from this system UI to the 3rd-party app.
    public let iconTemplate: UIImage?

    /// The name of the sound resource in the app bundle to be used for the provider ringtone.
    public let ringtoneSound: String?

    /// Whether or not calls from this provider should be included in the iOS Recents list.
    public let includesCallsInRecents: Bool

    /// Instantiates a CallProviderConfiguration
    public init(
        localizedName: String,
        iconTemplate: UIImage?,
        ringtoneSound: String?,
        includesCallsInRecents: Bool
    ) {
        self.localizedName = localizedName
        self.iconTemplate = iconTemplate
        self.ringtoneSound = ringtoneSound
        self.includesCallsInRecents = includesCallsInRecents
    }

    internal func cxProviderConfiguration() -> CXProviderConfiguration {
        let configuration = CXProviderConfiguration(localizedName: localizedName)
        configuration.ringtoneSound = ringtoneSound
        configuration.includesCallsInRecents = includesCallsInRecents
        configuration.iconTemplateImageData = iconTemplate?.pngData()
        return configuration
    }
}
