//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoNotification
import SudoTelephonyCommon

/// A notification metadata field a telephony filter rule can match a single ID on.
private enum TelephonyNotificationFilterField: String {
    case conversationId
    case phoneNumberId
    case sudoId

    /// The JsonLogic variable naming the field, e.g. `meta.sudoId`.
    var variable: String { "meta.\(rawValue)" }
}

public extension NotificationConfiguration {

    // MARK: - Properties

    /// JsonLogic rule matching telephony notification types the SDK doesn't recognise. The Android SDK
    /// writes the same string, and it's compared exactly, so keep the two in step. The argument of `!` is
    /// wrapped in an array so the notification service finds the `var` when it validates the rule.
    private static let telephonyDefaultFirstRuleString = """
    {"!":[{"in":[{"var":"meta.type"},["\(TelephonyServiceNotificationType.messageReceived.rawValue)"]]}]}
    """

    /// JsonLogic rule that always matches. Compared exactly, like `telephonyDefaultFirstRuleString`.
    private static let telephonyDefaultLastRuleString = """
    {"==":[1,1]}
    """

    /// Rule disabling telephony notification types the SDK doesn't recognise.
    private static let telephonyDefaultFirstRule = NotificationFilterItem(
        name: SudoTelephonyCommon.Constants.serviceName,
        status: false,
        rules: telephonyDefaultFirstRuleString
    )

    /// Catch-all rule enabling every telephony notification no earlier rule disabled.
    private static let telephonyDefaultLastRule = NotificationFilterItem(
        name: SudoTelephonyCommon.Constants.serviceName,
        status: true,
        rules: telephonyDefaultLastRuleString
    )

    // MARK: - Methods

    /// Return a copy of this configuration set up to receive telephony service notifications.
    ///
    /// The returned configuration keeps every other service's rules first, in their current order. They are
    /// followed by a rule that disables telephony notification types the SDK doesn't recognise, then any
    /// existing telephony rules in their current order, then a catch-all rule that enables every other
    /// telephony notification. Calling it again on its own result returns an equal configuration.
    ///
    /// Once every Sudo Platform SDK has updated the configuration, pass it to
    /// `SudoNotificationClient.setNotificationConfiguration` to apply it.
    ///
    /// - Returns: A new configuration with the telephony default rules in place.
    func initTelephonyNotifications() -> NotificationConfiguration {
        replacingTelephonyRules(with: telephonyRulesExcludingDefaults())
    }

    /// Return a copy of this configuration with telephony service notifications enabled or disabled for one
    /// phone number.
    ///
    /// Any existing rule for this phone number ID is removed. When `enabled` is `false`, a rule disabling
    /// notifications for the phone number is added after the other telephony rules and before the catch-all
    /// rule that enables everything else. Other services' rules, and telephony rules for other IDs, are kept
    /// in their current order, and the telephony default rules are put in place as by
    /// `initTelephonyNotifications()`. Enabling a phone number that isn't disabled changes nothing.
    ///
    /// Once every Sudo Platform SDK has updated the configuration, pass it to
    /// `SudoNotificationClient.setNotificationConfiguration` to apply it.
    ///
    /// - Parameters:
    ///   - phoneNumberId: The ID of the phone number to enable or disable notifications for.
    ///   - enabled: Whether notifications for the phone number are enabled.
    /// - Returns: A new configuration with the updated rules.
    func setTelephonyNotifications(forPhoneNumberId phoneNumberId: String, enabled: Bool) -> NotificationConfiguration {
        settingTelephonyNotifications(for: TelephonyNotificationFilterField.phoneNumberId, value: phoneNumberId, enabled: enabled)
    }

    /// Return a copy of this configuration with telephony service notifications enabled or disabled for every
    /// phone number one Sudo owns.
    ///
    /// Any existing rule for this Sudo ID is removed. When `enabled` is `false`, a rule disabling
    /// notifications for the Sudo is added after the other telephony rules and before the catch-all rule that
    /// enables everything else. Other services' rules, and telephony rules for other IDs, are kept in their
    /// current order, and the telephony default rules are put in place as by `initTelephonyNotifications()`.
    /// Enabling a Sudo that isn't disabled changes nothing.
    ///
    /// Once every Sudo Platform SDK has updated the configuration, pass it to
    /// `SudoNotificationClient.setNotificationConfiguration` to apply it.
    ///
    /// - Parameters:
    ///   - sudoId: The ID of the Sudo to enable or disable notifications for.
    ///   - enabled: Whether notifications for the Sudo are enabled.
    /// - Returns: A new configuration with the updated rules.
    func setTelephonyNotifications(forSudoId sudoId: String, enabled: Bool) -> NotificationConfiguration {
        settingTelephonyNotifications(for: TelephonyNotificationFilterField.sudoId, value: sudoId, enabled: enabled)
    }

    /// Return a copy of this configuration with telephony service notifications enabled or disabled for one
    /// conversation.
    ///
    /// Any existing rule for this conversation ID is removed. When `enabled` is `false`, a rule disabling
    /// notifications for the conversation is added after the other telephony rules and before the catch-all
    /// rule that enables everything else. Other services' rules, and telephony rules for other IDs, are kept
    /// in their current order, and the telephony default rules are put in place as by
    /// `initTelephonyNotifications()`. Enabling a conversation that isn't disabled changes nothing.
    ///
    /// Once every Sudo Platform SDK has updated the configuration, pass it to
    /// `SudoNotificationClient.setNotificationConfiguration` to apply it.
    ///
    /// - Parameters:
    ///   - conversationId: The ID of the conversation to enable or disable notifications for.
    ///   - enabled: Whether notifications for the conversation are enabled.
    /// - Returns: A new configuration with the updated rules.
    func setTelephonyNotifications(forConversationId conversationId: String, enabled: Bool) -> NotificationConfiguration {
        settingTelephonyNotifications(for: TelephonyNotificationFilterField.conversationId, value: conversationId, enabled: enabled)
    }

    /// Whether telephony service notifications are enabled for a phone number.
    ///
    /// - Parameter phoneNumberId: The ID of the phone number to check.
    /// - Returns: `false` if the configuration has a telephony rule disabling notifications for the phone
    ///   number, otherwise `true`.
    func areTelephonyNotificationsEnabled(forPhoneNumberWithId phoneNumberId: String) -> Bool {
        !hasTelephonyDisablingRule(for: TelephonyNotificationFilterField.phoneNumberId, value: phoneNumberId)
    }

    /// Whether telephony service notifications are enabled for a Sudo.
    ///
    /// - Parameter sudoId: The ID of the Sudo to check.
    /// - Returns: `false` if the configuration has a telephony rule disabling notifications for the Sudo,
    ///   otherwise `true`.
    func areTelephonyNotificationsEnabled(forSudoWithId sudoId: String) -> Bool {
        !hasTelephonyDisablingRule(for: TelephonyNotificationFilterField.sudoId, value: sudoId)
    }

    /// Whether telephony service notifications are enabled for a conversation.
    ///
    /// - Parameter conversationId: The ID of the conversation to check.
    /// - Returns: `false` if the configuration has a telephony rule disabling notifications for the
    ///   conversation, otherwise `true`.
    func areTelephonyNotificationsEnabled(forConversationWithId conversationId: String) -> Bool {
        !hasTelephonyDisablingRule(for: TelephonyNotificationFilterField.conversationId, value: conversationId)
    }

    // MARK: - Helpers

    /// Replace any rule for one field and ID, adding a disabling rule for it when `enabled` is `false`.
    ///
    /// - Parameters:
    ///   - field: The metadata field the rule matches on.
    ///   - value: The ID the rule matches.
    ///   - enabled: Whether notifications matching the ID are enabled.
    /// - Returns: A new configuration with the telephony default rules around the updated telephony rules.
    private func settingTelephonyNotifications(
        for field: TelephonyNotificationFilterField,
        value: String,
        enabled: Bool
    ) -> NotificationConfiguration {
        var telephonyRules = telephonyRulesExcludingDefaults()
            .filter { !Self.isTelephonyRule($0.rules, matching: field, value: value) }

        if !enabled {
            let disablingRule = """
            {"==":[{"var":"\(field.variable)"},\(Self.jsonStringLiteral(value))]}
            """
            telephonyRules.append(
                NotificationFilterItem(name: SudoTelephonyCommon.Constants.serviceName, status: false, rules: disablingRule)
            )
        }

        return replacingTelephonyRules(with: telephonyRules)
    }

    /// The telephony rules in this configuration, in order, without the telephony default rules.
    ///
    /// SudoNotification's own default rule string is also dropped: a filter item created with empty rules gets
    /// it, and left in place ahead of the per-ID rules it would stop them from ever applying.
    ///
    /// - Returns: The telephony service's rules other than the default first and last rules.
    private func telephonyRulesExcludingDefaults() -> [NotificationFilterItem] {
        let defaultRuleStrings: Set<String> = [
            Self.telephonyDefaultFirstRuleString,
            Self.telephonyDefaultLastRuleString,
            NotificationConfiguration.defaultRuleString
        ]
        return configs
            .filter { $0.name == SudoTelephonyCommon.Constants.serviceName }
            .filter { !defaultRuleStrings.contains($0.rules) }
    }

    /// Build a configuration of the other services' rules, followed by the given telephony rules between the
    /// telephony default rules.
    ///
    /// - Parameter telephonyRules: The telephony rules to place between the default rules, in order.
    /// - Returns: A new configuration.
    private func replacingTelephonyRules(with telephonyRules: [NotificationFilterItem]) -> NotificationConfiguration {
        let otherServicesRules = configs.filter { $0.name != SudoTelephonyCommon.Constants.serviceName }
        return NotificationConfiguration(
            configs: otherServicesRules + [Self.telephonyDefaultFirstRule] + telephonyRules + [Self.telephonyDefaultLastRule]
        )
    }

    /// Whether the configuration has a telephony rule disabling notifications for one field and ID.
    ///
    /// - Parameters:
    ///   - field: The metadata field to check.
    ///   - value: The ID to check.
    /// - Returns: `true` if a disabling telephony rule matches the field and ID.
    private func hasTelephonyDisablingRule(for field: TelephonyNotificationFilterField, value: String) -> Bool {
        configs.contains {
            $0.name == SudoTelephonyCommon.Constants.serviceName
                && $0.status == NotificationConfiguration.disabledStatus
                && Self.isTelephonyRule($0.rules, matching: field, value: value)
        }
    }

    /// Whether a JsonLogic rule is an equality test of one metadata field against one ID, with the operands in
    /// either order. A rule that isn't valid JSON doesn't match.
    ///
    /// - Parameters:
    ///   - rule: The JsonLogic rule string.
    ///   - field: The metadata field the rule must test.
    ///   - value: The ID the rule must test the field against.
    /// - Returns: `true` if the rule is `{"==":[{"var":"meta.<field>"},"<value>"]}` or its reverse.
    private static func isTelephonyRule(_ rule: String, matching field: TelephonyNotificationFilterField, value: String) -> Bool {
        guard
            let json = try? JSONSerialization.jsonObject(with: Data(rule.utf8)) as? [String: Any],
            let operands = json["=="] as? [Any],
            operands.count == 2
        else {
            return false
        }

        let isVariableFirst = isVariable(operands[0], for: field) && operands[1] as? String == value
        let isVariableSecond = isVariable(operands[1], for: field) && operands[0] as? String == value
        return isVariableFirst || isVariableSecond
    }

    /// Whether a JsonLogic operand is `{"var":"meta.<field>"}`.
    ///
    /// - Parameters:
    ///   - operand: The decoded operand.
    ///   - field: The metadata field the operand must name.
    /// - Returns: `true` if the operand is a variable naming the field.
    private static func isVariable(_ operand: Any, for field: TelephonyNotificationFilterField) -> Bool {
        (operand as? [String: Any])?["var"] as? String == field.variable
    }

    /// Encode a string as a JSON string literal, quotes included, so any ID produces a valid rule.
    ///
    /// - Parameter value: The string to encode.
    /// - Returns: The JSON string literal, e.g. `"abc"`. Plain IDs are only wrapped in quotes.
    private static func jsonStringLiteral(_ value: String) -> String {
        guard
            let data = try? JSONSerialization.data(withJSONObject: value, options: [.fragmentsAllowed, .withoutEscapingSlashes]),
            let literal = String(bytes: data, encoding: .utf8)
        else {
            // Serialising a String can't fail; this keeps the rule well-formed if it ever does.
            return "\"\""
        }
        return literal
    }
}
