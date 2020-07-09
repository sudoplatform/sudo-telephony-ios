//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

public protocol IncomingCallNotificationDelegate: class {

    /// Called when an incoming call is recieved.  This is called before reporting the call to callkit so the correct
    /// display name can be provided.
    ///
    /// In your implementation of this function you should set the `displayName` property of the incoming call that should be displayed by callKit.
    ///
    /// You should also set the `delegate` of the incoming call.  When the call is answered, `incomingCallAnswered(_ call: ActiveVoiceCall)` will be called
    /// and future call related events will be delivered to the delegate.
    func incomingCallReceived(_ call: IncomingCall) -> Void

    /// Indicates that the incoming call was canceled.
    /// - Parameter call: The incoming call
    /// - Parameter error: The error that occured, if any.
    func incomingCall(_ call: IncomingCall, cancelledWithError error: Error?)


    /// An incoming call was answered through CallKit and is in the process of connecting.
    /// No more updates on the incoming call will be provided to this delegate.
    /// Future call updates will be provided to the delegate set on the incoming call delegate in `incomingCallReceived(_ call: IncomingCall) -> Void`.
    func incomingCallAnswered(_ call: ActiveVoiceCall)
}
