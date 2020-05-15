//  This file was automatically generated and should not be edited.

import AWSAppSync

/// Input definition to provision a phone number.
internal struct ProvisionPhoneNumberInput: GraphQLMapConvertible {
  internal var graphQLMap: GraphQLMap

  internal init(phoneNumber: String, country: String, keyRingId: String, clientRefId: Optional<String?> = nil, ownerProofs: [String]) {
    graphQLMap = ["phoneNumber": phoneNumber, "country": country, "keyRingId": keyRingId, "clientRefId": clientRefId, "ownerProofs": ownerProofs]
  }

  /// E164 formatted phone number.
  internal var phoneNumber: String {
    get {
      return graphQLMap["phoneNumber"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }

  /// ISO country code of phone number e.g. 'US' 'ZZ'.
  internal var country: String {
    get {
      return graphQLMap["country"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "country")
    }
  }

  /// Key ring ID that dictates which keys the child resources of this phone number will be encrypted with.
  internal var keyRingId: String {
    get {
      return graphQLMap["keyRingId"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "keyRingId")
    }
  }

  /// ID used for the client to subscribe to specific events.
  internal var clientRefId: Optional<String?> {
    get {
      return graphQLMap["clientRefId"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clientRefId")
    }
  }

  /// Ownership proof tokens
  internal var ownerProofs: [String] {
    get {
      return graphQLMap["ownerProofs"] as! [String]
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ownerProofs")
    }
  }
}

/// Input definition to delete a phone number.
internal struct DeprovisionPhoneNumberInput: GraphQLMapConvertible {
  internal var graphQLMap: GraphQLMap

  internal init(phoneNumber: String, expectedVersion: Int) {
    graphQLMap = ["phoneNumber": phoneNumber, "expectedVersion": expectedVersion]
  }

  /// Sudo phone number in E164 format.
  internal var phoneNumber: String {
    get {
      return graphQLMap["phoneNumber"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }

  /// Expected version of the phone number.
  internal var expectedVersion: Int {
    get {
      return graphQLMap["expectedVersion"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "expectedVersion")
    }
  }
}

internal struct PhoneNumberFilterInput: GraphQLMapConvertible {
  internal var graphQLMap: GraphQLMap

  internal init(id: Optional<IDFilterInput?> = nil, country: Optional<StringFilterInput?> = nil, sudoOwner: Optional<IDFilterInput?> = nil, state: Optional<PhoneNumberStateFilterInput?> = nil, createdAtEpochMs: Optional<FloatFilterInput?> = nil, updatedAtEpochMs: Optional<FloatFilterInput?> = nil, and: Optional<[PhoneNumberFilterInput?]?> = nil, or: Optional<[PhoneNumberFilterInput?]?> = nil, not: Optional<PhoneNumberFilterInput?> = nil) {
    graphQLMap = ["id": id, "country": country, "sudoOwner": sudoOwner, "state": state, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs, "and": and, "or": or, "not": not]
  }

  internal var id: Optional<IDFilterInput?> {
    get {
      return graphQLMap["id"] as! Optional<IDFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  internal var country: Optional<StringFilterInput?> {
    get {
      return graphQLMap["country"] as! Optional<StringFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "country")
    }
  }

  internal var sudoOwner: Optional<IDFilterInput?> {
    get {
      return graphQLMap["sudoOwner"] as! Optional<IDFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "sudoOwner")
    }
  }

  internal var state: Optional<PhoneNumberStateFilterInput?> {
    get {
      return graphQLMap["state"] as! Optional<PhoneNumberStateFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "state")
    }
  }

  internal var createdAtEpochMs: Optional<FloatFilterInput?> {
    get {
      return graphQLMap["createdAtEpochMs"] as! Optional<FloatFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAtEpochMs")
    }
  }

  internal var updatedAtEpochMs: Optional<FloatFilterInput?> {
    get {
      return graphQLMap["updatedAtEpochMs"] as! Optional<FloatFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAtEpochMs")
    }
  }

  internal var and: Optional<[PhoneNumberFilterInput?]?> {
    get {
      return graphQLMap["and"] as! Optional<[PhoneNumberFilterInput?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  internal var or: Optional<[PhoneNumberFilterInput?]?> {
    get {
      return graphQLMap["or"] as! Optional<[PhoneNumberFilterInput?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  internal var not: Optional<PhoneNumberFilterInput?> {
    get {
      return graphQLMap["not"] as! Optional<PhoneNumberFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

internal struct IDFilterInput: GraphQLMapConvertible {
  internal var graphQLMap: GraphQLMap

  internal init(ne: Optional<GraphQLID?> = nil, eq: Optional<GraphQLID?> = nil, contains: Optional<GraphQLID?> = nil, notContains: Optional<GraphQLID?> = nil, between: Optional<[GraphQLID?]?> = nil, beginsWith: Optional<GraphQLID?> = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith]
  }

  internal var ne: Optional<GraphQLID?> {
    get {
      return graphQLMap["ne"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  internal var eq: Optional<GraphQLID?> {
    get {
      return graphQLMap["eq"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  internal var contains: Optional<GraphQLID?> {
    get {
      return graphQLMap["contains"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  internal var notContains: Optional<GraphQLID?> {
    get {
      return graphQLMap["notContains"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  internal var between: Optional<[GraphQLID?]?> {
    get {
      return graphQLMap["between"] as! Optional<[GraphQLID?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  internal var beginsWith: Optional<GraphQLID?> {
    get {
      return graphQLMap["beginsWith"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }
}

internal struct StringFilterInput: GraphQLMapConvertible {
  internal var graphQLMap: GraphQLMap

  internal init(ne: Optional<String?> = nil, eq: Optional<String?> = nil, le: Optional<String?> = nil, lt: Optional<String?> = nil, ge: Optional<String?> = nil, gt: Optional<String?> = nil, contains: Optional<String?> = nil, notContains: Optional<String?> = nil, between: Optional<[String?]?> = nil, beginsWith: Optional<String?> = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith]
  }

  internal var ne: Optional<String?> {
    get {
      return graphQLMap["ne"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  internal var eq: Optional<String?> {
    get {
      return graphQLMap["eq"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  internal var le: Optional<String?> {
    get {
      return graphQLMap["le"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  internal var lt: Optional<String?> {
    get {
      return graphQLMap["lt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  internal var ge: Optional<String?> {
    get {
      return graphQLMap["ge"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  internal var gt: Optional<String?> {
    get {
      return graphQLMap["gt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  internal var contains: Optional<String?> {
    get {
      return graphQLMap["contains"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  internal var notContains: Optional<String?> {
    get {
      return graphQLMap["notContains"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  internal var between: Optional<[String?]?> {
    get {
      return graphQLMap["between"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  internal var beginsWith: Optional<String?> {
    get {
      return graphQLMap["beginsWith"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }
}

internal struct PhoneNumberStateFilterInput: GraphQLMapConvertible {
  internal var graphQLMap: GraphQLMap

  internal init(ne: Optional<PhoneNumberState?> = nil, eq: Optional<PhoneNumberState?> = nil, `in`: Optional<[PhoneNumberState?]?> = nil, notIn: Optional<[PhoneNumberState?]?> = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "in": `in`, "notIn": notIn]
  }

  internal var ne: Optional<PhoneNumberState?> {
    get {
      return graphQLMap["ne"] as! Optional<PhoneNumberState?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  internal var eq: Optional<PhoneNumberState?> {
    get {
      return graphQLMap["eq"] as! Optional<PhoneNumberState?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  internal var `in`: Optional<[PhoneNumberState?]?> {
    get {
      return graphQLMap["in"] as! Optional<[PhoneNumberState?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  internal var notIn: Optional<[PhoneNumberState?]?> {
    get {
      return graphQLMap["notIn"] as! Optional<[PhoneNumberState?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

/// Phone number provisioning states.
internal enum PhoneNumberState: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  internal typealias RawValue = String
  case provisioning
  case failed
  case complete
  case deprovisioning
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  internal init?(rawValue: RawValue) {
    switch rawValue {
      case "PROVISIONING": self = .provisioning
      case "FAILED": self = .failed
      case "COMPLETE": self = .complete
      case "DEPROVISIONING": self = .deprovisioning
      default: self = .unknown(rawValue)
    }
  }

  internal var rawValue: RawValue {
    switch self {
      case .provisioning: return "PROVISIONING"
      case .failed: return "FAILED"
      case .complete: return "COMPLETE"
      case .deprovisioning: return "DEPROVISIONING"
      case .unknown(let value): return value
    }
  }

  internal static func == (lhs: PhoneNumberState, rhs: PhoneNumberState) -> Bool {
    switch (lhs, rhs) {
      case (.provisioning, .provisioning): return true
      case (.failed, .failed): return true
      case (.complete, .complete): return true
      case (.deprovisioning, .deprovisioning): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

internal struct FloatFilterInput: GraphQLMapConvertible {
  internal var graphQLMap: GraphQLMap

  internal init(ne: Optional<Double?> = nil, eq: Optional<Double?> = nil, le: Optional<Double?> = nil, lt: Optional<Double?> = nil, ge: Optional<Double?> = nil, gt: Optional<Double?> = nil, contains: Optional<Double?> = nil, notContains: Optional<Double?> = nil, between: Optional<[Double?]?> = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between]
  }

  internal var ne: Optional<Double?> {
    get {
      return graphQLMap["ne"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  internal var eq: Optional<Double?> {
    get {
      return graphQLMap["eq"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  internal var le: Optional<Double?> {
    get {
      return graphQLMap["le"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  internal var lt: Optional<Double?> {
    get {
      return graphQLMap["lt"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  internal var ge: Optional<Double?> {
    get {
      return graphQLMap["ge"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  internal var gt: Optional<Double?> {
    get {
      return graphQLMap["gt"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  internal var contains: Optional<Double?> {
    get {
      return graphQLMap["contains"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  internal var notContains: Optional<Double?> {
    get {
      return graphQLMap["notContains"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  internal var between: Optional<[Double?]?> {
    get {
      return graphQLMap["between"] as! Optional<[Double?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }
}

/// Phone number search states.
internal enum PhoneNumberSearchState: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  internal typealias RawValue = String
  case searching
  case complete
  case failed
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  internal init?(rawValue: RawValue) {
    switch rawValue {
      case "SEARCHING": self = .searching
      case "COMPLETE": self = .complete
      case "FAILED": self = .failed
      default: self = .unknown(rawValue)
    }
  }

  internal var rawValue: RawValue {
    switch self {
      case .searching: return "SEARCHING"
      case .complete: return "COMPLETE"
      case .failed: return "FAILED"
      case .unknown(let value): return value
    }
  }

  internal static func == (lhs: PhoneNumberSearchState, rhs: PhoneNumberSearchState) -> Bool {
    switch (lhs, rhs) {
      case (.searching, .searching): return true
      case (.complete, .complete): return true
      case (.failed, .failed): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

internal struct CreatePublicKeyInput: GraphQLMapConvertible {
  internal var graphQLMap: GraphQLMap

  internal init(keyId: String, keyRingId: String, algorithm: String, publicKey: String) {
    graphQLMap = ["keyId": keyId, "keyRingId": keyRingId, "algorithm": algorithm, "publicKey": publicKey]
  }

  internal var keyId: String {
    get {
      return graphQLMap["keyId"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "keyId")
    }
  }

  internal var keyRingId: String {
    get {
      return graphQLMap["keyRingId"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "keyRingId")
    }
  }

  internal var algorithm: String {
    get {
      return graphQLMap["algorithm"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "algorithm")
    }
  }

  internal var publicKey: String {
    get {
      return graphQLMap["publicKey"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "publicKey")
    }
  }
}

internal struct DeletePublicKeyInput: GraphQLMapConvertible {
  internal var graphQLMap: GraphQLMap

  internal init(keyId: String) {
    graphQLMap = ["keyId": keyId]
  }

  internal var keyId: String {
    get {
      return graphQLMap["keyId"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "keyId")
    }
  }
}

/// Input definition to send a message.
internal struct SendMessageInput: GraphQLMapConvertible {
  internal var graphQLMap: GraphQLMap

  internal init(from: String, to: String, body: Optional<String?> = nil, media: Optional<[S3MediaObjectInput]?> = nil, clientRefId: Optional<String?> = nil) {
    graphQLMap = ["from": from, "to": to, "body": body, "media": media, "clientRefId": clientRefId]
  }

  /// Source phone number in E164 format.
  internal var from: String {
    get {
      return graphQLMap["from"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "from")
    }
  }

  /// Recipient phone number in E164 format.
  internal var to: String {
    get {
      return graphQLMap["to"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "to")
    }
  }

  /// Message body to send to recipient.
  internal var body: Optional<String?> {
    get {
      return graphQLMap["body"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "body")
    }
  }

  /// Pointer to MMS Media object posted to S3 by client.
  internal var media: Optional<[S3MediaObjectInput]?> {
    get {
      return graphQLMap["media"] as! Optional<[S3MediaObjectInput]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "media")
    }
  }

  /// ID used for the client to subscribe to specific events.
  internal var clientRefId: Optional<String?> {
    get {
      return graphQLMap["clientRefId"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clientRefId")
    }
  }
}

/// Representation of the S3 Object containing telephony media (i.e. MMS and Voicemails).
internal struct S3MediaObjectInput: GraphQLMapConvertible {
  internal var graphQLMap: GraphQLMap

  internal init(key: String, bucket: String, region: String) {
    graphQLMap = ["key": key, "bucket": bucket, "region": region]
  }

  /// Key of object in S3.
  internal var key: String {
    get {
      return graphQLMap["key"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "key")
    }
  }

  /// Name of S3 bucket.
  internal var bucket: String {
    get {
      return graphQLMap["bucket"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "bucket")
    }
  }

  /// Region S3 bucket is located in.
  internal var region: String {
    get {
      return graphQLMap["region"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "region")
    }
  }
}

internal struct MessageFilterInput: GraphQLMapConvertible {
  internal var graphQLMap: GraphQLMap

  internal init(conversation: IDFilterInput, keyId: Optional<IDFilterInput?> = nil, createdAtEpochMs: Optional<FloatFilterInput?> = nil, updatedAtEpochMs: Optional<FloatFilterInput?> = nil, and: Optional<[MessageFilterInput?]?> = nil, or: Optional<[MessageFilterInput?]?> = nil, not: Optional<MessageFilterInput?> = nil) {
    graphQLMap = ["conversation": conversation, "keyId": keyId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs, "and": and, "or": or, "not": not]
  }

  internal var conversation: IDFilterInput {
    get {
      return graphQLMap["conversation"] as! IDFilterInput
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "conversation")
    }
  }

  internal var keyId: Optional<IDFilterInput?> {
    get {
      return graphQLMap["keyId"] as! Optional<IDFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "keyId")
    }
  }

  internal var createdAtEpochMs: Optional<FloatFilterInput?> {
    get {
      return graphQLMap["createdAtEpochMs"] as! Optional<FloatFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAtEpochMs")
    }
  }

  internal var updatedAtEpochMs: Optional<FloatFilterInput?> {
    get {
      return graphQLMap["updatedAtEpochMs"] as! Optional<FloatFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAtEpochMs")
    }
  }

  internal var and: Optional<[MessageFilterInput?]?> {
    get {
      return graphQLMap["and"] as! Optional<[MessageFilterInput?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  internal var or: Optional<[MessageFilterInput?]?> {
    get {
      return graphQLMap["or"] as! Optional<[MessageFilterInput?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  internal var not: Optional<MessageFilterInput?> {
    get {
      return graphQLMap["not"] as! Optional<MessageFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

internal struct ConversationFilterInput: GraphQLMapConvertible {
  internal var graphQLMap: GraphQLMap

  internal init(sudoOwner: Optional<IDFilterInput?> = nil, phoneNumberId: Optional<IDFilterInput?> = nil, createdAtEpochMs: Optional<FloatFilterInput?> = nil, updatedAtEpochMs: Optional<FloatFilterInput?> = nil, and: Optional<[MessageFilterInput?]?> = nil, or: Optional<[MessageFilterInput?]?> = nil, not: Optional<MessageFilterInput?> = nil) {
    graphQLMap = ["sudoOwner": sudoOwner, "phoneNumberId": phoneNumberId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs, "and": and, "or": or, "not": not]
  }

  internal var sudoOwner: Optional<IDFilterInput?> {
    get {
      return graphQLMap["sudoOwner"] as! Optional<IDFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "sudoOwner")
    }
  }

  internal var phoneNumberId: Optional<IDFilterInput?> {
    get {
      return graphQLMap["phoneNumberId"] as! Optional<IDFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumberId")
    }
  }

  internal var createdAtEpochMs: Optional<FloatFilterInput?> {
    get {
      return graphQLMap["createdAtEpochMs"] as! Optional<FloatFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAtEpochMs")
    }
  }

  internal var updatedAtEpochMs: Optional<FloatFilterInput?> {
    get {
      return graphQLMap["updatedAtEpochMs"] as! Optional<FloatFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAtEpochMs")
    }
  }

  internal var and: Optional<[MessageFilterInput?]?> {
    get {
      return graphQLMap["and"] as! Optional<[MessageFilterInput?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  internal var or: Optional<[MessageFilterInput?]?> {
    get {
      return graphQLMap["or"] as! Optional<[MessageFilterInput?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  internal var not: Optional<MessageFilterInput?> {
    get {
      return graphQLMap["not"] as! Optional<MessageFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

/// Possible directions for a SMS/MMS message.
internal enum MessageDirection: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  internal typealias RawValue = String
  case inbound
  case outbound
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  internal init?(rawValue: RawValue) {
    switch rawValue {
      case "INBOUND": self = .inbound
      case "OUTBOUND": self = .outbound
      default: self = .unknown(rawValue)
    }
  }

  internal var rawValue: RawValue {
    switch self {
      case .inbound: return "INBOUND"
      case .outbound: return "OUTBOUND"
      case .unknown(let value): return value
    }
  }

  internal static func == (lhs: MessageDirection, rhs: MessageDirection) -> Bool {
    switch (lhs, rhs) {
      case (.inbound, .inbound): return true
      case (.outbound, .outbound): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

/// Possible states for a SMS/MMS message.
/// QUEUED      - Outbound message queued by telephony vendor ready for sending to carrier.
/// SENT        - Outbound message sent by telephony vendor to carrier.
/// DELIVERED   - Outbound message acknowledged as delivered by carrier.
/// UNDELIVERED - Outbound message acknowledged as undelivered by carrier.
/// FAILED      - Outbound message acknowledged as failed by carrier.
/// RECEIVED    - Inbound message stored at telephony vendor.
internal enum MessageState: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  internal typealias RawValue = String
  case queued
  case sent
  case delivered
  case undelivered
  case failed
  case received
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  internal init?(rawValue: RawValue) {
    switch rawValue {
      case "QUEUED": self = .queued
      case "SENT": self = .sent
      case "DELIVERED": self = .delivered
      case "UNDELIVERED": self = .undelivered
      case "FAILED": self = .failed
      case "RECEIVED": self = .received
      default: self = .unknown(rawValue)
    }
  }

  internal var rawValue: RawValue {
    switch self {
      case .queued: return "QUEUED"
      case .sent: return "SENT"
      case .delivered: return "DELIVERED"
      case .undelivered: return "UNDELIVERED"
      case .failed: return "FAILED"
      case .received: return "RECEIVED"
      case .unknown(let value): return value
    }
  }

  internal static func == (lhs: MessageState, rhs: MessageState) -> Bool {
    switch (lhs, rhs) {
      case (.queued, .queued): return true
      case (.sent, .sent): return true
      case (.delivered, .delivered): return true
      case (.undelivered, .undelivered): return true
      case (.failed, .failed): return true
      case (.received, .received): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

/// Indicates if this is a 1x1 SMS conversation or a group conversation.
internal enum ConversationType: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  internal typealias RawValue = String
  case individual
  case group
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  internal init?(rawValue: RawValue) {
    switch rawValue {
      case "INDIVIDUAL": self = .individual
      case "GROUP": self = .group
      default: self = .unknown(rawValue)
    }
  }

  internal var rawValue: RawValue {
    switch self {
      case .individual: return "INDIVIDUAL"
      case .group: return "GROUP"
      case .unknown(let value): return value
    }
  }

  internal static func == (lhs: ConversationType, rhs: ConversationType) -> Bool {
    switch (lhs, rhs) {
      case (.individual, .individual): return true
      case (.group, .group): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

internal final class AvailablePhoneNumbersForCountryCodeMutation: GraphQLMutation {
  internal static let operationString =
    "mutation availablePhoneNumbersForCountryCode($country: String!, $limit: Int = 10) {\n  searchPhoneNumbers(input: {country: $country, limit: $limit}) {\n    __typename\n    ...SudoAvailablePhoneNumberResult\n  }\n}"

  internal static var requestString: String { return operationString.appending(SudoAvailablePhoneNumberResult.fragmentString) }

  internal var country: String
  internal var limit: Int?

  internal init(country: String, limit: Int? = nil) {
    self.country = country
    self.limit = limit
  }

  internal var variables: GraphQLMap? {
    return ["country": country, "limit": limit]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Mutation"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("searchPhoneNumbers", arguments: ["input": ["country": GraphQLVariable("country"), "limit": GraphQLVariable("limit")]], type: .object(SearchPhoneNumber.selections)),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(searchPhoneNumbers: SearchPhoneNumber? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "searchPhoneNumbers": searchPhoneNumbers.flatMap { $0.snapshot }])
    }

    /// Search for available phone numbers for given criteria.
    internal var searchPhoneNumbers: SearchPhoneNumber? {
      get {
        return (snapshot["searchPhoneNumbers"] as? Snapshot).flatMap { SearchPhoneNumber(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "searchPhoneNumbers")
      }
    }

    internal struct SearchPhoneNumber: GraphQLSelectionSet {
      internal static let possibleTypes = ["PhoneNumberSearch"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("country", type: .nonNull(.scalar(String.self))),
        GraphQLField("gps", type: .object(Gp.selections)),
        GraphQLField("prefix", type: .scalar(String.self)),
        GraphQLField("state", type: .nonNull(.scalar(PhoneNumberSearchState.self))),
        GraphQLField("results", type: .list(.nonNull(.scalar(String.self)))),
        GraphQLField("clientRefId", type: .scalar(String.self)),
        GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
        GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(id: GraphQLID, country: String, gps: Gp? = nil, `prefix`: String? = nil, state: PhoneNumberSearchState, results: [String]? = nil, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PhoneNumberSearch", "id": id, "country": country, "gps": gps.flatMap { $0.snapshot }, "prefix": `prefix`, "state": state, "results": results, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// v4 UUID assigned to the phone number search.
      internal var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// ISO country code of phone number e.g. 'US' 'ZZ'.
      internal var country: String {
        get {
          return snapshot["country"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "country")
        }
      }

      /// GPS coordinates to scope phone number search.
      internal var gps: Gp? {
        get {
          return (snapshot["gps"] as? Snapshot).flatMap { Gp(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "gps")
        }
      }

      /// Area code of phone number e.g. 801, 555.
      internal var `prefix`: String? {
        get {
          return snapshot["prefix"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "prefix")
        }
      }

      /// Current state of phone number search request.
      internal var state: PhoneNumberSearchState {
        get {
          return snapshot["state"]! as! PhoneNumberSearchState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// Array of available phone numbers.
      internal var results: [String]? {
        get {
          return snapshot["results"] as? [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "results")
        }
      }

      /// ID used for the client to subscribe to specific events.
      internal var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      internal var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      internal var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      internal var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      internal struct Fragments {
        internal var snapshot: Snapshot

        internal var sudoAvailablePhoneNumberResult: SudoAvailablePhoneNumberResult {
          get {
            return SudoAvailablePhoneNumberResult(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      internal struct Gp: GraphQLSelectionSet {
        internal static let possibleTypes = ["GpsCoordinates"]

        internal static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("latitude", type: .nonNull(.scalar(String.self))),
          GraphQLField("longitude", type: .nonNull(.scalar(String.self))),
        ]

        internal var snapshot: Snapshot

        internal init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        internal init(latitude: String, longitude: String) {
          self.init(snapshot: ["__typename": "GpsCoordinates", "latitude": latitude, "longitude": longitude])
        }

        internal var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        internal var latitude: String {
          get {
            return snapshot["latitude"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "latitude")
          }
        }

        internal var longitude: String {
          get {
            return snapshot["longitude"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "longitude")
          }
        }
      }
    }
  }
}

internal final class AvailablePhoneNumbersForPrefixMutation: GraphQLMutation {
  internal static let operationString =
    "mutation availablePhoneNumbersForPrefix($country: String!, $prefix: String!, $limit: Int = 10) {\n  searchPhoneNumbers(input: {country: $country, prefix: $prefix, limit: $limit}) {\n    __typename\n    ...SudoAvailablePhoneNumberResult\n  }\n}"

  internal static var requestString: String { return operationString.appending(SudoAvailablePhoneNumberResult.fragmentString) }

  internal var country: String
  internal var `prefix`: String
  internal var limit: Int?

  internal init(country: String, `prefix`: String, limit: Int? = nil) {
    self.country = country
    self.prefix = `prefix`
    self.limit = limit
  }

  internal var variables: GraphQLMap? {
    return ["country": country, "prefix": `prefix`, "limit": limit]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Mutation"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("searchPhoneNumbers", arguments: ["input": ["country": GraphQLVariable("country"), "prefix": GraphQLVariable("prefix"), "limit": GraphQLVariable("limit")]], type: .object(SearchPhoneNumber.selections)),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(searchPhoneNumbers: SearchPhoneNumber? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "searchPhoneNumbers": searchPhoneNumbers.flatMap { $0.snapshot }])
    }

    /// Search for available phone numbers for given criteria.
    internal var searchPhoneNumbers: SearchPhoneNumber? {
      get {
        return (snapshot["searchPhoneNumbers"] as? Snapshot).flatMap { SearchPhoneNumber(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "searchPhoneNumbers")
      }
    }

    internal struct SearchPhoneNumber: GraphQLSelectionSet {
      internal static let possibleTypes = ["PhoneNumberSearch"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("country", type: .nonNull(.scalar(String.self))),
        GraphQLField("gps", type: .object(Gp.selections)),
        GraphQLField("prefix", type: .scalar(String.self)),
        GraphQLField("state", type: .nonNull(.scalar(PhoneNumberSearchState.self))),
        GraphQLField("results", type: .list(.nonNull(.scalar(String.self)))),
        GraphQLField("clientRefId", type: .scalar(String.self)),
        GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
        GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(id: GraphQLID, country: String, gps: Gp? = nil, `prefix`: String? = nil, state: PhoneNumberSearchState, results: [String]? = nil, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PhoneNumberSearch", "id": id, "country": country, "gps": gps.flatMap { $0.snapshot }, "prefix": `prefix`, "state": state, "results": results, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// v4 UUID assigned to the phone number search.
      internal var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// ISO country code of phone number e.g. 'US' 'ZZ'.
      internal var country: String {
        get {
          return snapshot["country"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "country")
        }
      }

      /// GPS coordinates to scope phone number search.
      internal var gps: Gp? {
        get {
          return (snapshot["gps"] as? Snapshot).flatMap { Gp(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "gps")
        }
      }

      /// Area code of phone number e.g. 801, 555.
      internal var `prefix`: String? {
        get {
          return snapshot["prefix"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "prefix")
        }
      }

      /// Current state of phone number search request.
      internal var state: PhoneNumberSearchState {
        get {
          return snapshot["state"]! as! PhoneNumberSearchState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// Array of available phone numbers.
      internal var results: [String]? {
        get {
          return snapshot["results"] as? [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "results")
        }
      }

      /// ID used for the client to subscribe to specific events.
      internal var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      internal var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      internal var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      internal var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      internal struct Fragments {
        internal var snapshot: Snapshot

        internal var sudoAvailablePhoneNumberResult: SudoAvailablePhoneNumberResult {
          get {
            return SudoAvailablePhoneNumberResult(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      internal struct Gp: GraphQLSelectionSet {
        internal static let possibleTypes = ["GpsCoordinates"]

        internal static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("latitude", type: .nonNull(.scalar(String.self))),
          GraphQLField("longitude", type: .nonNull(.scalar(String.self))),
        ]

        internal var snapshot: Snapshot

        internal init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        internal init(latitude: String, longitude: String) {
          self.init(snapshot: ["__typename": "GpsCoordinates", "latitude": latitude, "longitude": longitude])
        }

        internal var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        internal var latitude: String {
          get {
            return snapshot["latitude"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "latitude")
          }
        }

        internal var longitude: String {
          get {
            return snapshot["longitude"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "longitude")
          }
        }
      }
    }
  }
}

internal final class AvailablePhoneNumbersForGpsMutation: GraphQLMutation {
  internal static let operationString =
    "mutation availablePhoneNumbersForGPS($country: String!, $latitude: String!, $longitude: String!, $limit: Int = 10) {\n  searchPhoneNumbers(input: {country: $country, gps: {latitude: $latitude, longitude: $longitude}, limit: $limit}) {\n    __typename\n    ...SudoAvailablePhoneNumberResult\n  }\n}"

  internal static var requestString: String { return operationString.appending(SudoAvailablePhoneNumberResult.fragmentString) }

  internal var country: String
  internal var latitude: String
  internal var longitude: String
  internal var limit: Int?

  internal init(country: String, latitude: String, longitude: String, limit: Int? = nil) {
    self.country = country
    self.latitude = latitude
    self.longitude = longitude
    self.limit = limit
  }

  internal var variables: GraphQLMap? {
    return ["country": country, "latitude": latitude, "longitude": longitude, "limit": limit]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Mutation"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("searchPhoneNumbers", arguments: ["input": ["country": GraphQLVariable("country"), "gps": ["latitude": GraphQLVariable("latitude"), "longitude": GraphQLVariable("longitude")], "limit": GraphQLVariable("limit")]], type: .object(SearchPhoneNumber.selections)),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(searchPhoneNumbers: SearchPhoneNumber? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "searchPhoneNumbers": searchPhoneNumbers.flatMap { $0.snapshot }])
    }

    /// Search for available phone numbers for given criteria.
    internal var searchPhoneNumbers: SearchPhoneNumber? {
      get {
        return (snapshot["searchPhoneNumbers"] as? Snapshot).flatMap { SearchPhoneNumber(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "searchPhoneNumbers")
      }
    }

    internal struct SearchPhoneNumber: GraphQLSelectionSet {
      internal static let possibleTypes = ["PhoneNumberSearch"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("country", type: .nonNull(.scalar(String.self))),
        GraphQLField("gps", type: .object(Gp.selections)),
        GraphQLField("prefix", type: .scalar(String.self)),
        GraphQLField("state", type: .nonNull(.scalar(PhoneNumberSearchState.self))),
        GraphQLField("results", type: .list(.nonNull(.scalar(String.self)))),
        GraphQLField("clientRefId", type: .scalar(String.self)),
        GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
        GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(id: GraphQLID, country: String, gps: Gp? = nil, `prefix`: String? = nil, state: PhoneNumberSearchState, results: [String]? = nil, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PhoneNumberSearch", "id": id, "country": country, "gps": gps.flatMap { $0.snapshot }, "prefix": `prefix`, "state": state, "results": results, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// v4 UUID assigned to the phone number search.
      internal var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// ISO country code of phone number e.g. 'US' 'ZZ'.
      internal var country: String {
        get {
          return snapshot["country"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "country")
        }
      }

      /// GPS coordinates to scope phone number search.
      internal var gps: Gp? {
        get {
          return (snapshot["gps"] as? Snapshot).flatMap { Gp(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "gps")
        }
      }

      /// Area code of phone number e.g. 801, 555.
      internal var `prefix`: String? {
        get {
          return snapshot["prefix"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "prefix")
        }
      }

      /// Current state of phone number search request.
      internal var state: PhoneNumberSearchState {
        get {
          return snapshot["state"]! as! PhoneNumberSearchState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// Array of available phone numbers.
      internal var results: [String]? {
        get {
          return snapshot["results"] as? [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "results")
        }
      }

      /// ID used for the client to subscribe to specific events.
      internal var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      internal var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      internal var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      internal var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      internal struct Fragments {
        internal var snapshot: Snapshot

        internal var sudoAvailablePhoneNumberResult: SudoAvailablePhoneNumberResult {
          get {
            return SudoAvailablePhoneNumberResult(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      internal struct Gp: GraphQLSelectionSet {
        internal static let possibleTypes = ["GpsCoordinates"]

        internal static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("latitude", type: .nonNull(.scalar(String.self))),
          GraphQLField("longitude", type: .nonNull(.scalar(String.self))),
        ]

        internal var snapshot: Snapshot

        internal init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        internal init(latitude: String, longitude: String) {
          self.init(snapshot: ["__typename": "GpsCoordinates", "latitude": latitude, "longitude": longitude])
        }

        internal var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        internal var latitude: String {
          get {
            return snapshot["latitude"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "latitude")
          }
        }

        internal var longitude: String {
          get {
            return snapshot["longitude"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "longitude")
          }
        }
      }
    }
  }
}

internal final class SupportedCountriesQuery: GraphQLQuery {
  internal static let operationString =
    "query supportedCountries {\n  getPhoneNumberCountries {\n    __typename\n    countries\n  }\n}"

  internal init() {
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Query"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("getPhoneNumberCountries", type: .object(GetPhoneNumberCountry.selections)),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(getPhoneNumberCountries: GetPhoneNumberCountry? = nil) {
      self.init(snapshot: ["__typename": "Query", "getPhoneNumberCountries": getPhoneNumberCountries.flatMap { $0.snapshot }])
    }

    /// Returns an array of ISO country codes.
    internal var getPhoneNumberCountries: GetPhoneNumberCountry? {
      get {
        return (snapshot["getPhoneNumberCountries"] as? Snapshot).flatMap { GetPhoneNumberCountry(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getPhoneNumberCountries")
      }
    }

    internal struct GetPhoneNumberCountry: GraphQLSelectionSet {
      internal static let possibleTypes = ["SupportedCountries"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("countries", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(countries: [String]) {
        self.init(snapshot: ["__typename": "SupportedCountries", "countries": countries])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      internal var countries: [String] {
        get {
          return snapshot["countries"]! as! [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "countries")
        }
      }
    }
  }
}

internal final class AvailablePhoneNumberResultQuery: GraphQLQuery {
  internal static let operationString =
    "query availablePhoneNumberResult($id: ID!) {\n  getPhoneNumberSearch(id: $id) {\n    __typename\n    ...SudoAvailablePhoneNumberResult\n  }\n}"

  internal static var requestString: String { return operationString.appending(SudoAvailablePhoneNumberResult.fragmentString) }

  internal var id: GraphQLID

  internal init(id: GraphQLID) {
    self.id = id
  }

  internal var variables: GraphQLMap? {
    return ["id": id]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Query"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("getPhoneNumberSearch", arguments: ["id": GraphQLVariable("id")], type: .object(GetPhoneNumberSearch.selections)),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(getPhoneNumberSearch: GetPhoneNumberSearch? = nil) {
      self.init(snapshot: ["__typename": "Query", "getPhoneNumberSearch": getPhoneNumberSearch.flatMap { $0.snapshot }])
    }

    /// Returns a phone number search record.
    internal var getPhoneNumberSearch: GetPhoneNumberSearch? {
      get {
        return (snapshot["getPhoneNumberSearch"] as? Snapshot).flatMap { GetPhoneNumberSearch(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getPhoneNumberSearch")
      }
    }

    internal struct GetPhoneNumberSearch: GraphQLSelectionSet {
      internal static let possibleTypes = ["PhoneNumberSearch"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("country", type: .nonNull(.scalar(String.self))),
        GraphQLField("gps", type: .object(Gp.selections)),
        GraphQLField("prefix", type: .scalar(String.self)),
        GraphQLField("state", type: .nonNull(.scalar(PhoneNumberSearchState.self))),
        GraphQLField("results", type: .list(.nonNull(.scalar(String.self)))),
        GraphQLField("clientRefId", type: .scalar(String.self)),
        GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
        GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(id: GraphQLID, country: String, gps: Gp? = nil, `prefix`: String? = nil, state: PhoneNumberSearchState, results: [String]? = nil, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PhoneNumberSearch", "id": id, "country": country, "gps": gps.flatMap { $0.snapshot }, "prefix": `prefix`, "state": state, "results": results, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// v4 UUID assigned to the phone number search.
      internal var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// ISO country code of phone number e.g. 'US' 'ZZ'.
      internal var country: String {
        get {
          return snapshot["country"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "country")
        }
      }

      /// GPS coordinates to scope phone number search.
      internal var gps: Gp? {
        get {
          return (snapshot["gps"] as? Snapshot).flatMap { Gp(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "gps")
        }
      }

      /// Area code of phone number e.g. 801, 555.
      internal var `prefix`: String? {
        get {
          return snapshot["prefix"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "prefix")
        }
      }

      /// Current state of phone number search request.
      internal var state: PhoneNumberSearchState {
        get {
          return snapshot["state"]! as! PhoneNumberSearchState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// Array of available phone numbers.
      internal var results: [String]? {
        get {
          return snapshot["results"] as? [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "results")
        }
      }

      /// ID used for the client to subscribe to specific events.
      internal var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      internal var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      internal var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      internal var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      internal struct Fragments {
        internal var snapshot: Snapshot

        internal var sudoAvailablePhoneNumberResult: SudoAvailablePhoneNumberResult {
          get {
            return SudoAvailablePhoneNumberResult(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      internal struct Gp: GraphQLSelectionSet {
        internal static let possibleTypes = ["GpsCoordinates"]

        internal static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("latitude", type: .nonNull(.scalar(String.self))),
          GraphQLField("longitude", type: .nonNull(.scalar(String.self))),
        ]

        internal var snapshot: Snapshot

        internal init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        internal init(latitude: String, longitude: String) {
          self.init(snapshot: ["__typename": "GpsCoordinates", "latitude": latitude, "longitude": longitude])
        }

        internal var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        internal var latitude: String {
          get {
            return snapshot["latitude"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "latitude")
          }
        }

        internal var longitude: String {
          get {
            return snapshot["longitude"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "longitude")
          }
        }
      }
    }
  }
}

internal final class AvailablePhoneNumbersFinishedSubscription: GraphQLSubscription {
  internal static let operationString =
    "subscription availablePhoneNumbersFinished($owner: String!, $clientRefId: String!) {\n  OnSearch(owner: $owner, clientRefId: $clientRefId) {\n    __typename\n    ...SudoAvailablePhoneNumberResult\n  }\n}"

  internal static var requestString: String { return operationString.appending(SudoAvailablePhoneNumberResult.fragmentString) }

  internal var owner: String
  internal var clientRefId: String

  internal init(owner: String, clientRefId: String) {
    self.owner = owner
    self.clientRefId = clientRefId
  }

  internal var variables: GraphQLMap? {
    return ["owner": owner, "clientRefId": clientRefId]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Subscription"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("OnSearch", arguments: ["owner": GraphQLVariable("owner"), "clientRefId": GraphQLVariable("clientRefId")], type: .object(OnSearch.selections)),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(onSearch: OnSearch? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "OnSearch": onSearch.flatMap { $0.snapshot }])
    }

    /// Owner id for the current logged in user.
    /// ID used for the client to subscribe to specific search events.
    internal var onSearch: OnSearch? {
      get {
        return (snapshot["OnSearch"] as? Snapshot).flatMap { OnSearch(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "OnSearch")
      }
    }

    internal struct OnSearch: GraphQLSelectionSet {
      internal static let possibleTypes = ["PhoneNumberSearch"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("country", type: .nonNull(.scalar(String.self))),
        GraphQLField("gps", type: .object(Gp.selections)),
        GraphQLField("prefix", type: .scalar(String.self)),
        GraphQLField("state", type: .nonNull(.scalar(PhoneNumberSearchState.self))),
        GraphQLField("results", type: .list(.nonNull(.scalar(String.self)))),
        GraphQLField("clientRefId", type: .scalar(String.self)),
        GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
        GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(id: GraphQLID, country: String, gps: Gp? = nil, `prefix`: String? = nil, state: PhoneNumberSearchState, results: [String]? = nil, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PhoneNumberSearch", "id": id, "country": country, "gps": gps.flatMap { $0.snapshot }, "prefix": `prefix`, "state": state, "results": results, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// v4 UUID assigned to the phone number search.
      internal var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// ISO country code of phone number e.g. 'US' 'ZZ'.
      internal var country: String {
        get {
          return snapshot["country"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "country")
        }
      }

      /// GPS coordinates to scope phone number search.
      internal var gps: Gp? {
        get {
          return (snapshot["gps"] as? Snapshot).flatMap { Gp(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "gps")
        }
      }

      /// Area code of phone number e.g. 801, 555.
      internal var `prefix`: String? {
        get {
          return snapshot["prefix"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "prefix")
        }
      }

      /// Current state of phone number search request.
      internal var state: PhoneNumberSearchState {
        get {
          return snapshot["state"]! as! PhoneNumberSearchState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// Array of available phone numbers.
      internal var results: [String]? {
        get {
          return snapshot["results"] as? [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "results")
        }
      }

      /// ID used for the client to subscribe to specific events.
      internal var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      internal var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      internal var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      internal var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      internal struct Fragments {
        internal var snapshot: Snapshot

        internal var sudoAvailablePhoneNumberResult: SudoAvailablePhoneNumberResult {
          get {
            return SudoAvailablePhoneNumberResult(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      internal struct Gp: GraphQLSelectionSet {
        internal static let possibleTypes = ["GpsCoordinates"]

        internal static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("latitude", type: .nonNull(.scalar(String.self))),
          GraphQLField("longitude", type: .nonNull(.scalar(String.self))),
        ]

        internal var snapshot: Snapshot

        internal init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        internal init(latitude: String, longitude: String) {
          self.init(snapshot: ["__typename": "GpsCoordinates", "latitude": latitude, "longitude": longitude])
        }

        internal var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        internal var latitude: String {
          get {
            return snapshot["latitude"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "latitude")
          }
        }

        internal var longitude: String {
          get {
            return snapshot["longitude"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "longitude")
          }
        }
      }
    }
  }
}

internal final class ProvisionPhoneNumberMutation: GraphQLMutation {
  internal static let operationString =
    "mutation provisionPhoneNumber($input: ProvisionPhoneNumberInput!) {\n  provisionPhoneNumber(input: $input) {\n    __typename\n    ...SudoPhoneNumber\n  }\n}"

  internal static var requestString: String { return operationString.appending(SudoPhoneNumber.fragmentString) }

  internal var input: ProvisionPhoneNumberInput

  internal init(input: ProvisionPhoneNumberInput) {
    self.input = input
  }

  internal var variables: GraphQLMap? {
    return ["input": input]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Mutation"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("provisionPhoneNumber", arguments: ["input": GraphQLVariable("input")], type: .object(ProvisionPhoneNumber.selections)),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(provisionPhoneNumber: ProvisionPhoneNumber? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "provisionPhoneNumber": provisionPhoneNumber.flatMap { $0.snapshot }])
    }

    /// Provision phone number.
    internal var provisionPhoneNumber: ProvisionPhoneNumber? {
      get {
        return (snapshot["provisionPhoneNumber"] as? Snapshot).flatMap { ProvisionPhoneNumber(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "provisionPhoneNumber")
      }
    }

    internal struct ProvisionPhoneNumber: GraphQLSelectionSet {
      internal static let possibleTypes = ["PhoneNumber"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
        GraphQLField("country", type: .nonNull(.scalar(String.self))),
        GraphQLField("keyRingId", type: .nonNull(.scalar(String.self))),
        GraphQLField("state", type: .nonNull(.scalar(PhoneNumberState.self))),
        GraphQLField("version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("clientRefId", type: .scalar(String.self)),
        GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
        GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(id: GraphQLID, phoneNumber: String, country: String, keyRingId: String, state: PhoneNumberState, version: Int, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PhoneNumber", "id": id, "phoneNumber": phoneNumber, "country": country, "keyRingId": keyRingId, "state": state, "version": version, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// v4 UUID of phone number record.
      internal var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// E164 formatted phone number.
      internal var phoneNumber: String {
        get {
          return snapshot["phoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      /// ISO country code of phone number e.g. 'US' 'ZZ'.
      internal var country: String {
        get {
          return snapshot["country"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "country")
        }
      }

      /// Key ring ID that dictates which keys the child resources of this phone number will be encrypted with.
      internal var keyRingId: String {
        get {
          return snapshot["keyRingId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyRingId")
        }
      }

      /// State of phone number.
      internal var state: PhoneNumberState {
        get {
          return snapshot["state"]! as! PhoneNumberState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// Version of this phone number record, increments on update.
      internal var version: Int {
        get {
          return snapshot["version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "version")
        }
      }

      /// ID used for the client to subscribe to specific events.
      internal var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      internal var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      internal var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      internal var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      internal struct Fragments {
        internal var snapshot: Snapshot

        internal var sudoPhoneNumber: SudoPhoneNumber {
          get {
            return SudoPhoneNumber(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }
    }
  }
}

internal final class ProvisionPhoneNumberChangedSubscription: GraphQLSubscription {
  internal static let operationString =
    "subscription provisionPhoneNumberChanged($owner: String!, $clientRefId: String!) {\n  OnProvision(owner: $owner, clientRefId: $clientRefId) {\n    __typename\n    ...SudoPhoneNumber\n  }\n}"

  internal static var requestString: String { return operationString.appending(SudoPhoneNumber.fragmentString) }

  internal var owner: String
  internal var clientRefId: String

  internal init(owner: String, clientRefId: String) {
    self.owner = owner
    self.clientRefId = clientRefId
  }

  internal var variables: GraphQLMap? {
    return ["owner": owner, "clientRefId": clientRefId]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Subscription"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("OnProvision", arguments: ["owner": GraphQLVariable("owner"), "clientRefId": GraphQLVariable("clientRefId")], type: .object(OnProvision.selections)),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(onProvision: OnProvision? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "OnProvision": onProvision.flatMap { $0.snapshot }])
    }

    /// Owner id for the current logged in user.
    /// ID used for the client to subscribe to specific provision events.
    internal var onProvision: OnProvision? {
      get {
        return (snapshot["OnProvision"] as? Snapshot).flatMap { OnProvision(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "OnProvision")
      }
    }

    internal struct OnProvision: GraphQLSelectionSet {
      internal static let possibleTypes = ["PhoneNumber"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
        GraphQLField("country", type: .nonNull(.scalar(String.self))),
        GraphQLField("keyRingId", type: .nonNull(.scalar(String.self))),
        GraphQLField("state", type: .nonNull(.scalar(PhoneNumberState.self))),
        GraphQLField("version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("clientRefId", type: .scalar(String.self)),
        GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
        GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(id: GraphQLID, phoneNumber: String, country: String, keyRingId: String, state: PhoneNumberState, version: Int, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PhoneNumber", "id": id, "phoneNumber": phoneNumber, "country": country, "keyRingId": keyRingId, "state": state, "version": version, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// v4 UUID of phone number record.
      internal var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// E164 formatted phone number.
      internal var phoneNumber: String {
        get {
          return snapshot["phoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      /// ISO country code of phone number e.g. 'US' 'ZZ'.
      internal var country: String {
        get {
          return snapshot["country"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "country")
        }
      }

      /// Key ring ID that dictates which keys the child resources of this phone number will be encrypted with.
      internal var keyRingId: String {
        get {
          return snapshot["keyRingId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyRingId")
        }
      }

      /// State of phone number.
      internal var state: PhoneNumberState {
        get {
          return snapshot["state"]! as! PhoneNumberState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// Version of this phone number record, increments on update.
      internal var version: Int {
        get {
          return snapshot["version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "version")
        }
      }

      /// ID used for the client to subscribe to specific events.
      internal var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      internal var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      internal var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      internal var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      internal struct Fragments {
        internal var snapshot: Snapshot

        internal var sudoPhoneNumber: SudoPhoneNumber {
          get {
            return SudoPhoneNumber(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }
    }
  }
}

internal final class DeprovisionPhoneNumberMutation: GraphQLMutation {
  internal static let operationString =
    "mutation deprovisionPhoneNumber($input: DeprovisionPhoneNumberInput!) {\n  deprovisionPhoneNumber(input: $input) {\n    __typename\n    ...SudoPhoneNumber\n  }\n}"

  internal static var requestString: String { return operationString.appending(SudoPhoneNumber.fragmentString) }

  internal var input: DeprovisionPhoneNumberInput

  internal init(input: DeprovisionPhoneNumberInput) {
    self.input = input
  }

  internal var variables: GraphQLMap? {
    return ["input": input]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Mutation"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("deprovisionPhoneNumber", arguments: ["input": GraphQLVariable("input")], type: .object(DeprovisionPhoneNumber.selections)),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(deprovisionPhoneNumber: DeprovisionPhoneNumber? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deprovisionPhoneNumber": deprovisionPhoneNumber.flatMap { $0.snapshot }])
    }

    /// Deprovision phone number.
    internal var deprovisionPhoneNumber: DeprovisionPhoneNumber? {
      get {
        return (snapshot["deprovisionPhoneNumber"] as? Snapshot).flatMap { DeprovisionPhoneNumber(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deprovisionPhoneNumber")
      }
    }

    internal struct DeprovisionPhoneNumber: GraphQLSelectionSet {
      internal static let possibleTypes = ["PhoneNumber"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
        GraphQLField("country", type: .nonNull(.scalar(String.self))),
        GraphQLField("keyRingId", type: .nonNull(.scalar(String.self))),
        GraphQLField("state", type: .nonNull(.scalar(PhoneNumberState.self))),
        GraphQLField("version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("clientRefId", type: .scalar(String.self)),
        GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
        GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(id: GraphQLID, phoneNumber: String, country: String, keyRingId: String, state: PhoneNumberState, version: Int, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PhoneNumber", "id": id, "phoneNumber": phoneNumber, "country": country, "keyRingId": keyRingId, "state": state, "version": version, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// v4 UUID of phone number record.
      internal var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// E164 formatted phone number.
      internal var phoneNumber: String {
        get {
          return snapshot["phoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      /// ISO country code of phone number e.g. 'US' 'ZZ'.
      internal var country: String {
        get {
          return snapshot["country"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "country")
        }
      }

      /// Key ring ID that dictates which keys the child resources of this phone number will be encrypted with.
      internal var keyRingId: String {
        get {
          return snapshot["keyRingId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyRingId")
        }
      }

      /// State of phone number.
      internal var state: PhoneNumberState {
        get {
          return snapshot["state"]! as! PhoneNumberState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// Version of this phone number record, increments on update.
      internal var version: Int {
        get {
          return snapshot["version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "version")
        }
      }

      /// ID used for the client to subscribe to specific events.
      internal var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      internal var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      internal var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      internal var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      internal struct Fragments {
        internal var snapshot: Snapshot

        internal var sudoPhoneNumber: SudoPhoneNumber {
          get {
            return SudoPhoneNumber(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }
    }
  }
}

internal final class PhoneNumbersQuery: GraphQLQuery {
  internal static let operationString =
    "query phoneNumbers($filter: PhoneNumberFilterInput, $limit: Int, $nextToken: String) {\n  listPhoneNumbers(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      ...SudoPhoneNumber\n    }\n    nextToken\n  }\n}"

  internal static var requestString: String { return operationString.appending(SudoPhoneNumber.fragmentString) }

  internal var filter: PhoneNumberFilterInput?
  internal var limit: Int?
  internal var nextToken: String?

  internal init(filter: PhoneNumberFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  internal var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Query"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("listPhoneNumbers", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListPhoneNumber.selections)),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(listPhoneNumbers: ListPhoneNumber? = nil) {
      self.init(snapshot: ["__typename": "Query", "listPhoneNumbers": listPhoneNumbers.flatMap { $0.snapshot }])
    }

    /// Returns a list of phone numbers.
    internal var listPhoneNumbers: ListPhoneNumber? {
      get {
        return (snapshot["listPhoneNumbers"] as? Snapshot).flatMap { ListPhoneNumber(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listPhoneNumbers")
      }
    }

    internal struct ListPhoneNumber: GraphQLSelectionSet {
      internal static let possibleTypes = ["PhoneNumberConnection"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .list(.nonNull(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(items: [Item]? = nil, nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "PhoneNumberConnection", "items": items.flatMap { $0.map { $0.snapshot } }, "nextToken": nextToken])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      internal var items: [Item]? {
        get {
          return (snapshot["items"] as? [Snapshot]).flatMap { $0.map { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "items")
        }
      }

      internal var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      internal struct Item: GraphQLSelectionSet {
        internal static let possibleTypes = ["PhoneNumber"]

        internal static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
          GraphQLField("country", type: .nonNull(.scalar(String.self))),
          GraphQLField("keyRingId", type: .nonNull(.scalar(String.self))),
          GraphQLField("state", type: .nonNull(.scalar(PhoneNumberState.self))),
          GraphQLField("version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("clientRefId", type: .scalar(String.self)),
          GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
          GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
        ]

        internal var snapshot: Snapshot

        internal init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        internal init(id: GraphQLID, phoneNumber: String, country: String, keyRingId: String, state: PhoneNumberState, version: Int, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
          self.init(snapshot: ["__typename": "PhoneNumber", "id": id, "phoneNumber": phoneNumber, "country": country, "keyRingId": keyRingId, "state": state, "version": version, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
        }

        internal var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// v4 UUID of phone number record.
        internal var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        /// E164 formatted phone number.
        internal var phoneNumber: String {
          get {
            return snapshot["phoneNumber"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phoneNumber")
          }
        }

        /// ISO country code of phone number e.g. 'US' 'ZZ'.
        internal var country: String {
          get {
            return snapshot["country"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "country")
          }
        }

        /// Key ring ID that dictates which keys the child resources of this phone number will be encrypted with.
        internal var keyRingId: String {
          get {
            return snapshot["keyRingId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "keyRingId")
          }
        }

        /// State of phone number.
        internal var state: PhoneNumberState {
          get {
            return snapshot["state"]! as! PhoneNumberState
          }
          set {
            snapshot.updateValue(newValue, forKey: "state")
          }
        }

        /// Version of this phone number record, increments on update.
        internal var version: Int {
          get {
            return snapshot["version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "version")
          }
        }

        /// ID used for the client to subscribe to specific events.
        internal var clientRefId: String? {
          get {
            return snapshot["clientRefId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "clientRefId")
          }
        }

        /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
        internal var createdAtEpochMs: Double {
          get {
            return snapshot["createdAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
          }
        }

        /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
        internal var updatedAtEpochMs: Double {
          get {
            return snapshot["updatedAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
          }
        }

        internal var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        internal struct Fragments {
          internal var snapshot: Snapshot

          internal var sudoPhoneNumber: SudoPhoneNumber {
            get {
              return SudoPhoneNumber(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }
        }
      }
    }
  }
}

internal final class PhoneNumberQuery: GraphQLQuery {
  internal static let operationString =
    "query phoneNumber($id: ID!) {\n  getPhoneNumber(id: $id) {\n    __typename\n    ...SudoPhoneNumber\n  }\n}"

  internal static var requestString: String { return operationString.appending(SudoPhoneNumber.fragmentString) }

  internal var id: GraphQLID

  internal init(id: GraphQLID) {
    self.id = id
  }

  internal var variables: GraphQLMap? {
    return ["id": id]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Query"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("getPhoneNumber", arguments: ["id": GraphQLVariable("id")], type: .object(GetPhoneNumber.selections)),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(getPhoneNumber: GetPhoneNumber? = nil) {
      self.init(snapshot: ["__typename": "Query", "getPhoneNumber": getPhoneNumber.flatMap { $0.snapshot }])
    }

    /// Get a phone number record by ID.
    internal var getPhoneNumber: GetPhoneNumber? {
      get {
        return (snapshot["getPhoneNumber"] as? Snapshot).flatMap { GetPhoneNumber(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getPhoneNumber")
      }
    }

    internal struct GetPhoneNumber: GraphQLSelectionSet {
      internal static let possibleTypes = ["PhoneNumber"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
        GraphQLField("country", type: .nonNull(.scalar(String.self))),
        GraphQLField("keyRingId", type: .nonNull(.scalar(String.self))),
        GraphQLField("state", type: .nonNull(.scalar(PhoneNumberState.self))),
        GraphQLField("version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("clientRefId", type: .scalar(String.self)),
        GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
        GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(id: GraphQLID, phoneNumber: String, country: String, keyRingId: String, state: PhoneNumberState, version: Int, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PhoneNumber", "id": id, "phoneNumber": phoneNumber, "country": country, "keyRingId": keyRingId, "state": state, "version": version, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// v4 UUID of phone number record.
      internal var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// E164 formatted phone number.
      internal var phoneNumber: String {
        get {
          return snapshot["phoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      /// ISO country code of phone number e.g. 'US' 'ZZ'.
      internal var country: String {
        get {
          return snapshot["country"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "country")
        }
      }

      /// Key ring ID that dictates which keys the child resources of this phone number will be encrypted with.
      internal var keyRingId: String {
        get {
          return snapshot["keyRingId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyRingId")
        }
      }

      /// State of phone number.
      internal var state: PhoneNumberState {
        get {
          return snapshot["state"]! as! PhoneNumberState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// Version of this phone number record, increments on update.
      internal var version: Int {
        get {
          return snapshot["version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "version")
        }
      }

      /// ID used for the client to subscribe to specific events.
      internal var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      internal var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      internal var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      internal var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      internal struct Fragments {
        internal var snapshot: Snapshot

        internal var sudoPhoneNumber: SudoPhoneNumber {
          get {
            return SudoPhoneNumber(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }
    }
  }
}

internal final class CreatePublicKeyMutation: GraphQLMutation {
  internal static let operationString =
    "mutation createPublicKey($input: CreatePublicKeyInput!) {\n  createPublicKeyForTelephony(input: $input) {\n    __typename\n    ...publicKey\n  }\n}"

  internal static var requestString: String { return operationString.appending(PublicKey.fragmentString) }

  internal var input: CreatePublicKeyInput

  internal init(input: CreatePublicKeyInput) {
    self.input = input
  }

  internal var variables: GraphQLMap? {
    return ["input": input]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Mutation"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("createPublicKeyForTelephony", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.object(CreatePublicKeyForTelephony.selections))),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(createPublicKeyForTelephony: CreatePublicKeyForTelephony) {
      self.init(snapshot: ["__typename": "Mutation", "createPublicKeyForTelephony": createPublicKeyForTelephony.snapshot])
    }

    internal var createPublicKeyForTelephony: CreatePublicKeyForTelephony {
      get {
        return CreatePublicKeyForTelephony(snapshot: snapshot["createPublicKeyForTelephony"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "createPublicKeyForTelephony")
      }
    }

    internal struct CreatePublicKeyForTelephony: GraphQLSelectionSet {
      internal static let possibleTypes = ["PublicKey"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("keyId", type: .nonNull(.scalar(String.self))),
        GraphQLField("keyRingId", type: .nonNull(.scalar(String.self))),
        GraphQLField("algorithm", type: .nonNull(.scalar(String.self))),
        GraphQLField("publicKey", type: .nonNull(.scalar(String.self))),
        GraphQLField("owner", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
        GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(keyId: String, keyRingId: String, algorithm: String, publicKey: String, owner: GraphQLID, version: Int, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PublicKey", "keyId": keyId, "keyRingId": keyRingId, "algorithm": algorithm, "publicKey": publicKey, "owner": owner, "version": version, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      internal var keyId: String {
        get {
          return snapshot["keyId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyId")
        }
      }

      internal var keyRingId: String {
        get {
          return snapshot["keyRingId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyRingId")
        }
      }

      internal var algorithm: String {
        get {
          return snapshot["algorithm"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "algorithm")
        }
      }

      internal var publicKey: String {
        get {
          return snapshot["publicKey"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "publicKey")
        }
      }

      internal var owner: GraphQLID {
        get {
          return snapshot["owner"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      internal var version: Int {
        get {
          return snapshot["version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "version")
        }
      }

      internal var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      internal var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      internal var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      internal struct Fragments {
        internal var snapshot: Snapshot

        internal var publicKey: PublicKey {
          get {
            return PublicKey(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }
    }
  }
}

internal final class DeletePublicKeyMutation: GraphQLMutation {
  internal static let operationString =
    "mutation deletePublicKey($input: DeletePublicKeyInput!) {\n  deletePublicKeyForTelephony(input: $input) {\n    __typename\n    ...publicKey\n  }\n}"

  internal static var requestString: String { return operationString.appending(PublicKey.fragmentString) }

  internal var input: DeletePublicKeyInput

  internal init(input: DeletePublicKeyInput) {
    self.input = input
  }

  internal var variables: GraphQLMap? {
    return ["input": input]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Mutation"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("deletePublicKeyForTelephony", arguments: ["input": GraphQLVariable("input")], type: .object(DeletePublicKeyForTelephony.selections)),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(deletePublicKeyForTelephony: DeletePublicKeyForTelephony? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deletePublicKeyForTelephony": deletePublicKeyForTelephony.flatMap { $0.snapshot }])
    }

    internal var deletePublicKeyForTelephony: DeletePublicKeyForTelephony? {
      get {
        return (snapshot["deletePublicKeyForTelephony"] as? Snapshot).flatMap { DeletePublicKeyForTelephony(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deletePublicKeyForTelephony")
      }
    }

    internal struct DeletePublicKeyForTelephony: GraphQLSelectionSet {
      internal static let possibleTypes = ["PublicKey"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("keyId", type: .nonNull(.scalar(String.self))),
        GraphQLField("keyRingId", type: .nonNull(.scalar(String.self))),
        GraphQLField("algorithm", type: .nonNull(.scalar(String.self))),
        GraphQLField("publicKey", type: .nonNull(.scalar(String.self))),
        GraphQLField("owner", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
        GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(keyId: String, keyRingId: String, algorithm: String, publicKey: String, owner: GraphQLID, version: Int, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PublicKey", "keyId": keyId, "keyRingId": keyRingId, "algorithm": algorithm, "publicKey": publicKey, "owner": owner, "version": version, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      internal var keyId: String {
        get {
          return snapshot["keyId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyId")
        }
      }

      internal var keyRingId: String {
        get {
          return snapshot["keyRingId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyRingId")
        }
      }

      internal var algorithm: String {
        get {
          return snapshot["algorithm"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "algorithm")
        }
      }

      internal var publicKey: String {
        get {
          return snapshot["publicKey"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "publicKey")
        }
      }

      internal var owner: GraphQLID {
        get {
          return snapshot["owner"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      internal var version: Int {
        get {
          return snapshot["version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "version")
        }
      }

      internal var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      internal var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      internal var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      internal struct Fragments {
        internal var snapshot: Snapshot

        internal var publicKey: PublicKey {
          get {
            return PublicKey(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }
    }
  }
}

internal final class GetPublicKeyQuery: GraphQLQuery {
  internal static let operationString =
    "query getPublicKey($keyId: String!) {\n  getPublicKeyForTelephony(keyId: $keyId) {\n    __typename\n    ...publicKey\n  }\n}"

  internal static var requestString: String { return operationString.appending(PublicKey.fragmentString) }

  internal var keyId: String

  internal init(keyId: String) {
    self.keyId = keyId
  }

  internal var variables: GraphQLMap? {
    return ["keyId": keyId]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Query"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("getPublicKeyForTelephony", arguments: ["keyId": GraphQLVariable("keyId")], type: .object(GetPublicKeyForTelephony.selections)),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(getPublicKeyForTelephony: GetPublicKeyForTelephony? = nil) {
      self.init(snapshot: ["__typename": "Query", "getPublicKeyForTelephony": getPublicKeyForTelephony.flatMap { $0.snapshot }])
    }

    internal var getPublicKeyForTelephony: GetPublicKeyForTelephony? {
      get {
        return (snapshot["getPublicKeyForTelephony"] as? Snapshot).flatMap { GetPublicKeyForTelephony(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getPublicKeyForTelephony")
      }
    }

    internal struct GetPublicKeyForTelephony: GraphQLSelectionSet {
      internal static let possibleTypes = ["PublicKey"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("keyId", type: .nonNull(.scalar(String.self))),
        GraphQLField("keyRingId", type: .nonNull(.scalar(String.self))),
        GraphQLField("algorithm", type: .nonNull(.scalar(String.self))),
        GraphQLField("publicKey", type: .nonNull(.scalar(String.self))),
        GraphQLField("owner", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
        GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(keyId: String, keyRingId: String, algorithm: String, publicKey: String, owner: GraphQLID, version: Int, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PublicKey", "keyId": keyId, "keyRingId": keyRingId, "algorithm": algorithm, "publicKey": publicKey, "owner": owner, "version": version, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      internal var keyId: String {
        get {
          return snapshot["keyId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyId")
        }
      }

      internal var keyRingId: String {
        get {
          return snapshot["keyRingId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyRingId")
        }
      }

      internal var algorithm: String {
        get {
          return snapshot["algorithm"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "algorithm")
        }
      }

      internal var publicKey: String {
        get {
          return snapshot["publicKey"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "publicKey")
        }
      }

      internal var owner: GraphQLID {
        get {
          return snapshot["owner"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      internal var version: Int {
        get {
          return snapshot["version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "version")
        }
      }

      internal var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      internal var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      internal var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      internal struct Fragments {
        internal var snapshot: Snapshot

        internal var publicKey: PublicKey {
          get {
            return PublicKey(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }
    }
  }
}

internal final class GetPublicKeysQuery: GraphQLQuery {
  internal static let operationString =
    "query getPublicKeys($limit: Int, $nextToken: String) {\n  getPublicKeysForTelephony(limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      ...publicKey\n    }\n    nextToken\n  }\n}"

  internal static var requestString: String { return operationString.appending(PublicKey.fragmentString) }

  internal var limit: Int?
  internal var nextToken: String?

  internal init(limit: Int? = nil, nextToken: String? = nil) {
    self.limit = limit
    self.nextToken = nextToken
  }

  internal var variables: GraphQLMap? {
    return ["limit": limit, "nextToken": nextToken]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Query"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("getPublicKeysForTelephony", arguments: ["limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .nonNull(.object(GetPublicKeysForTelephony.selections))),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(getPublicKeysForTelephony: GetPublicKeysForTelephony) {
      self.init(snapshot: ["__typename": "Query", "getPublicKeysForTelephony": getPublicKeysForTelephony.snapshot])
    }

    internal var getPublicKeysForTelephony: GetPublicKeysForTelephony {
      get {
        return GetPublicKeysForTelephony(snapshot: snapshot["getPublicKeysForTelephony"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "getPublicKeysForTelephony")
      }
    }

    internal struct GetPublicKeysForTelephony: GraphQLSelectionSet {
      internal static let possibleTypes = ["PaginatedPublicKey"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(items: [Item], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "PaginatedPublicKey", "items": items.map { $0.snapshot }, "nextToken": nextToken])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      internal var items: [Item] {
        get {
          return (snapshot["items"] as! [Snapshot]).map { Item(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "items")
        }
      }

      internal var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      internal struct Item: GraphQLSelectionSet {
        internal static let possibleTypes = ["PublicKey"]

        internal static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("keyId", type: .nonNull(.scalar(String.self))),
          GraphQLField("keyRingId", type: .nonNull(.scalar(String.self))),
          GraphQLField("algorithm", type: .nonNull(.scalar(String.self))),
          GraphQLField("publicKey", type: .nonNull(.scalar(String.self))),
          GraphQLField("owner", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
          GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
        ]

        internal var snapshot: Snapshot

        internal init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        internal init(keyId: String, keyRingId: String, algorithm: String, publicKey: String, owner: GraphQLID, version: Int, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
          self.init(snapshot: ["__typename": "PublicKey", "keyId": keyId, "keyRingId": keyRingId, "algorithm": algorithm, "publicKey": publicKey, "owner": owner, "version": version, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
        }

        internal var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        internal var keyId: String {
          get {
            return snapshot["keyId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "keyId")
          }
        }

        internal var keyRingId: String {
          get {
            return snapshot["keyRingId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "keyRingId")
          }
        }

        internal var algorithm: String {
          get {
            return snapshot["algorithm"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "algorithm")
          }
        }

        internal var publicKey: String {
          get {
            return snapshot["publicKey"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "publicKey")
          }
        }

        internal var owner: GraphQLID {
          get {
            return snapshot["owner"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "owner")
          }
        }

        internal var version: Int {
          get {
            return snapshot["version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "version")
          }
        }

        internal var createdAtEpochMs: Double {
          get {
            return snapshot["createdAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
          }
        }

        internal var updatedAtEpochMs: Double {
          get {
            return snapshot["updatedAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
          }
        }

        internal var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        internal struct Fragments {
          internal var snapshot: Snapshot

          internal var publicKey: PublicKey {
            get {
              return PublicKey(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }
        }
      }
    }
  }
}

internal final class GetKeyRingQuery: GraphQLQuery {
  internal static let operationString =
    "query getKeyRing($keyRingId: String!, $limit: Int, $nextToken: String) {\n  getKeyRingForTelephony(keyRingId: $keyRingId, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      ...publicKey\n    }\n    nextToken\n  }\n}"

  internal static var requestString: String { return operationString.appending(PublicKey.fragmentString) }

  internal var keyRingId: String
  internal var limit: Int?
  internal var nextToken: String?

  internal init(keyRingId: String, limit: Int? = nil, nextToken: String? = nil) {
    self.keyRingId = keyRingId
    self.limit = limit
    self.nextToken = nextToken
  }

  internal var variables: GraphQLMap? {
    return ["keyRingId": keyRingId, "limit": limit, "nextToken": nextToken]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Query"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("getKeyRingForTelephony", arguments: ["keyRingId": GraphQLVariable("keyRingId"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .nonNull(.object(GetKeyRingForTelephony.selections))),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(getKeyRingForTelephony: GetKeyRingForTelephony) {
      self.init(snapshot: ["__typename": "Query", "getKeyRingForTelephony": getKeyRingForTelephony.snapshot])
    }

    internal var getKeyRingForTelephony: GetKeyRingForTelephony {
      get {
        return GetKeyRingForTelephony(snapshot: snapshot["getKeyRingForTelephony"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "getKeyRingForTelephony")
      }
    }

    internal struct GetKeyRingForTelephony: GraphQLSelectionSet {
      internal static let possibleTypes = ["PaginatedPublicKey"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(items: [Item], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "PaginatedPublicKey", "items": items.map { $0.snapshot }, "nextToken": nextToken])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      internal var items: [Item] {
        get {
          return (snapshot["items"] as! [Snapshot]).map { Item(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "items")
        }
      }

      internal var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      internal struct Item: GraphQLSelectionSet {
        internal static let possibleTypes = ["PublicKey"]

        internal static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("keyId", type: .nonNull(.scalar(String.self))),
          GraphQLField("keyRingId", type: .nonNull(.scalar(String.self))),
          GraphQLField("algorithm", type: .nonNull(.scalar(String.self))),
          GraphQLField("publicKey", type: .nonNull(.scalar(String.self))),
          GraphQLField("owner", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
          GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
        ]

        internal var snapshot: Snapshot

        internal init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        internal init(keyId: String, keyRingId: String, algorithm: String, publicKey: String, owner: GraphQLID, version: Int, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
          self.init(snapshot: ["__typename": "PublicKey", "keyId": keyId, "keyRingId": keyRingId, "algorithm": algorithm, "publicKey": publicKey, "owner": owner, "version": version, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
        }

        internal var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        internal var keyId: String {
          get {
            return snapshot["keyId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "keyId")
          }
        }

        internal var keyRingId: String {
          get {
            return snapshot["keyRingId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "keyRingId")
          }
        }

        internal var algorithm: String {
          get {
            return snapshot["algorithm"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "algorithm")
          }
        }

        internal var publicKey: String {
          get {
            return snapshot["publicKey"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "publicKey")
          }
        }

        internal var owner: GraphQLID {
          get {
            return snapshot["owner"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "owner")
          }
        }

        internal var version: Int {
          get {
            return snapshot["version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "version")
          }
        }

        internal var createdAtEpochMs: Double {
          get {
            return snapshot["createdAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
          }
        }

        internal var updatedAtEpochMs: Double {
          get {
            return snapshot["updatedAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
          }
        }

        internal var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        internal struct Fragments {
          internal var snapshot: Snapshot

          internal var publicKey: PublicKey {
            get {
              return PublicKey(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }
        }
      }
    }
  }
}

internal final class SendMessageMutation: GraphQLMutation {
  internal static let operationString =
    "mutation sendMessage($input: SendMessageInput!) {\n  sendMessage(input: $input)\n}"

  internal var input: SendMessageInput

  internal init(input: SendMessageInput) {
    self.input = input
  }

  internal var variables: GraphQLMap? {
    return ["input": input]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Mutation"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("sendMessage", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.scalar(GraphQLID.self))),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(sendMessage: GraphQLID) {
      self.init(snapshot: ["__typename": "Mutation", "sendMessage": sendMessage])
    }

    /// Send SMS/MMS message.
    internal var sendMessage: GraphQLID {
      get {
        return snapshot["sendMessage"]! as! GraphQLID
      }
      set {
        snapshot.updateValue(newValue, forKey: "sendMessage")
      }
    }
  }
}

internal final class GetMessageQuery: GraphQLQuery {
  internal static let operationString =
    "query getMessage($id: ID!, $keyId: String!) {\n  getMessage(id: $id, keyId: $keyId) {\n    __typename\n    ...sealedMessage\n  }\n}"

  internal static var requestString: String { return operationString.appending(SealedMessage.fragmentString).appending(S3MediaObject.fragmentString) }

  internal var id: GraphQLID
  internal var keyId: String

  internal init(id: GraphQLID, keyId: String) {
    self.id = id
    self.keyId = keyId
  }

  internal var variables: GraphQLMap? {
    return ["id": id, "keyId": keyId]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Query"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("getMessage", arguments: ["id": GraphQLVariable("id"), "keyId": GraphQLVariable("keyId")], type: .object(GetMessage.selections)),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(getMessage: GetMessage? = nil) {
      self.init(snapshot: ["__typename": "Query", "getMessage": getMessage.flatMap { $0.snapshot }])
    }

    /// Get a message record by ID.
    internal var getMessage: GetMessage? {
      get {
        return (snapshot["getMessage"] as? Snapshot).flatMap { GetMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getMessage")
      }
    }

    internal struct GetMessage: GraphQLSelectionSet {
      internal static let possibleTypes = ["SealedMessage"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("conversation", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("remotePhoneNumber", type: .nonNull(.scalar(String.self))),
        GraphQLField("localPhoneNumber", type: .nonNull(.scalar(String.self))),
        GraphQLField("body", type: .scalar(String.self)),
        GraphQLField("media", type: .list(.nonNull(.object(Medium.selections)))),
        GraphQLField("direction", type: .nonNull(.scalar(MessageDirection.self))),
        GraphQLField("seen", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("state", type: .nonNull(.scalar(MessageState.self))),
        GraphQLField("owner", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("algorithm", type: .nonNull(.scalar(String.self))),
        GraphQLField("keyId", type: .nonNull(.scalar(String.self))),
        GraphQLField("clientRefId", type: .scalar(String.self)),
        GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
        GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(id: GraphQLID, conversation: GraphQLID, remotePhoneNumber: String, localPhoneNumber: String, body: String? = nil, media: [Medium]? = nil, direction: MessageDirection, seen: Bool, state: MessageState, owner: GraphQLID, algorithm: String, keyId: String, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "SealedMessage", "id": id, "conversation": conversation, "remotePhoneNumber": remotePhoneNumber, "localPhoneNumber": localPhoneNumber, "body": body, "media": media.flatMap { $0.map { $0.snapshot } }, "direction": direction, "seen": seen, "state": state, "owner": owner, "algorithm": algorithm, "keyId": keyId, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// UNSEALED: v4 UUID assigned to message record.
      internal var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// UNSEALED: v5 UUID generated by the client, v5 UUID produces a predictable repeatable
      /// result when provided with identical inputs, a fixed namespace UUID is included to
      /// further reduce collision.  Conversation IDs should be calculated as follows:
      /// v5(owner, localPhoneNumber + remotePhoneNumber)
      internal var conversation: GraphQLID {
        get {
          return snapshot["conversation"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversation")
        }
      }

      /// SEALED: Remote phone number in E164 format.
      internal var remotePhoneNumber: String {
        get {
          return snapshot["remotePhoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "remotePhoneNumber")
        }
      }

      /// SEALED: Sudo phone number in E164 format.
      internal var localPhoneNumber: String {
        get {
          return snapshot["localPhoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "localPhoneNumber")
        }
      }

      /// SEALED: Message body, null if MMS only.
      internal var body: String? {
        get {
          return snapshot["body"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "body")
        }
      }

      /// SEALED: MMS attachments.
      internal var media: [Medium]? {
        get {
          return (snapshot["media"] as? [Snapshot]).flatMap { $0.map { Medium(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "media")
        }
      }

      /// UNSEALED: Direction of message.
      internal var direction: MessageDirection {
        get {
          return snapshot["direction"]! as! MessageDirection
        }
        set {
          snapshot.updateValue(newValue, forKey: "direction")
        }
      }

      /// UNSEALED: Has this message been marked as seen on client.
      internal var seen: Bool {
        get {
          return snapshot["seen"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "seen")
        }
      }

      /// UNSEALED: State of message record.
      internal var state: MessageState {
        get {
          return snapshot["state"]! as! MessageState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// UNSEALED: v4 UUID of user that owns the message resource.
      internal var owner: GraphQLID {
        get {
          return snapshot["owner"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      /// UNSEALED: Algorithm descriptor describing internal and symmetric key encryption, e.g RSAEncryptionOAEPSHA256AESGCM.
      internal var algorithm: String {
        get {
          return snapshot["algorithm"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "algorithm")
        }
      }

      /// UNSEALED: Client generated key ID for the internal key.
      internal var keyId: String {
        get {
          return snapshot["keyId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyId")
        }
      }

      /// UNSEALED: ID used for the client to subscribe to specific events.
      internal var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// UNSEALED: Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      internal var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// UNSEALED: Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      internal var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      internal var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      internal struct Fragments {
        internal var snapshot: Snapshot

        internal var sealedMessage: SealedMessage {
          get {
            return SealedMessage(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      internal struct Medium: GraphQLSelectionSet {
        internal static let possibleTypes = ["S3MediaObject"]

        internal static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("key", type: .nonNull(.scalar(String.self))),
          GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
          GraphQLField("region", type: .nonNull(.scalar(String.self))),
        ]

        internal var snapshot: Snapshot

        internal init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        internal init(key: String, bucket: String, region: String) {
          self.init(snapshot: ["__typename": "S3MediaObject", "key": key, "bucket": bucket, "region": region])
        }

        internal var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Key of object in S3.
        internal var key: String {
          get {
            return snapshot["key"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "key")
          }
        }

        /// Name of S3 bucket.
        internal var bucket: String {
          get {
            return snapshot["bucket"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "bucket")
          }
        }

        /// Region S3 bucket is located in.
        internal var region: String {
          get {
            return snapshot["region"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "region")
          }
        }

        internal var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        internal struct Fragments {
          internal var snapshot: Snapshot

          internal var s3MediaObject: S3MediaObject {
            get {
              return S3MediaObject(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }
        }
      }
    }
  }
}

internal final class DeleteMessageMutation: GraphQLMutation {
  internal static let operationString =
    "mutation deleteMessage($id: ID!) {\n  deleteMessage(id: $id)\n}"

  internal var id: GraphQLID

  internal init(id: GraphQLID) {
    self.id = id
  }

  internal var variables: GraphQLMap? {
    return ["id": id]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Mutation"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("deleteMessage", arguments: ["id": GraphQLVariable("id")], type: .scalar(GraphQLID.self)),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(deleteMessage: GraphQLID? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteMessage": deleteMessage])
    }

    /// Delete SMS/MMS message.
    internal var deleteMessage: GraphQLID? {
      get {
        return snapshot["deleteMessage"] as? GraphQLID
      }
      set {
        snapshot.updateValue(newValue, forKey: "deleteMessage")
      }
    }
  }
}

internal final class ListMessagesQuery: GraphQLQuery {
  internal static let operationString =
    "query listMessages($filter: MessageFilterInput!, $limit: Int, $nextToken: String) {\n  listMessages(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      ...sealedMessage\n    }\n    nextToken\n  }\n}"

  internal static var requestString: String { return operationString.appending(SealedMessage.fragmentString).appending(S3MediaObject.fragmentString) }

  internal var filter: MessageFilterInput
  internal var limit: Int?
  internal var nextToken: String?

  internal init(filter: MessageFilterInput, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  internal var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Query"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("listMessages", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListMessage.selections)),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(listMessages: ListMessage? = nil) {
      self.init(snapshot: ["__typename": "Query", "listMessages": listMessages.flatMap { $0.snapshot }])
    }

    /// Returns a list of messages.
    internal var listMessages: ListMessage? {
      get {
        return (snapshot["listMessages"] as? Snapshot).flatMap { ListMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listMessages")
      }
    }

    internal struct ListMessage: GraphQLSelectionSet {
      internal static let possibleTypes = ["MessageConnection"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .list(.nonNull(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(items: [Item]? = nil, nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "MessageConnection", "items": items.flatMap { $0.map { $0.snapshot } }, "nextToken": nextToken])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      internal var items: [Item]? {
        get {
          return (snapshot["items"] as? [Snapshot]).flatMap { $0.map { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "items")
        }
      }

      internal var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      internal struct Item: GraphQLSelectionSet {
        internal static let possibleTypes = ["SealedMessage"]

        internal static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("conversation", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("remotePhoneNumber", type: .nonNull(.scalar(String.self))),
          GraphQLField("localPhoneNumber", type: .nonNull(.scalar(String.self))),
          GraphQLField("body", type: .scalar(String.self)),
          GraphQLField("media", type: .list(.nonNull(.object(Medium.selections)))),
          GraphQLField("direction", type: .nonNull(.scalar(MessageDirection.self))),
          GraphQLField("seen", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("state", type: .nonNull(.scalar(MessageState.self))),
          GraphQLField("owner", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("algorithm", type: .nonNull(.scalar(String.self))),
          GraphQLField("keyId", type: .nonNull(.scalar(String.self))),
          GraphQLField("clientRefId", type: .scalar(String.self)),
          GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
          GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
        ]

        internal var snapshot: Snapshot

        internal init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        internal init(id: GraphQLID, conversation: GraphQLID, remotePhoneNumber: String, localPhoneNumber: String, body: String? = nil, media: [Medium]? = nil, direction: MessageDirection, seen: Bool, state: MessageState, owner: GraphQLID, algorithm: String, keyId: String, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
          self.init(snapshot: ["__typename": "SealedMessage", "id": id, "conversation": conversation, "remotePhoneNumber": remotePhoneNumber, "localPhoneNumber": localPhoneNumber, "body": body, "media": media.flatMap { $0.map { $0.snapshot } }, "direction": direction, "seen": seen, "state": state, "owner": owner, "algorithm": algorithm, "keyId": keyId, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
        }

        internal var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// UNSEALED: v4 UUID assigned to message record.
        internal var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        /// UNSEALED: v5 UUID generated by the client, v5 UUID produces a predictable repeatable
        /// result when provided with identical inputs, a fixed namespace UUID is included to
        /// further reduce collision.  Conversation IDs should be calculated as follows:
        /// v5(owner, localPhoneNumber + remotePhoneNumber)
        internal var conversation: GraphQLID {
          get {
            return snapshot["conversation"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "conversation")
          }
        }

        /// SEALED: Remote phone number in E164 format.
        internal var remotePhoneNumber: String {
          get {
            return snapshot["remotePhoneNumber"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "remotePhoneNumber")
          }
        }

        /// SEALED: Sudo phone number in E164 format.
        internal var localPhoneNumber: String {
          get {
            return snapshot["localPhoneNumber"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "localPhoneNumber")
          }
        }

        /// SEALED: Message body, null if MMS only.
        internal var body: String? {
          get {
            return snapshot["body"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "body")
          }
        }

        /// SEALED: MMS attachments.
        internal var media: [Medium]? {
          get {
            return (snapshot["media"] as? [Snapshot]).flatMap { $0.map { Medium(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "media")
          }
        }

        /// UNSEALED: Direction of message.
        internal var direction: MessageDirection {
          get {
            return snapshot["direction"]! as! MessageDirection
          }
          set {
            snapshot.updateValue(newValue, forKey: "direction")
          }
        }

        /// UNSEALED: Has this message been marked as seen on client.
        internal var seen: Bool {
          get {
            return snapshot["seen"]! as! Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "seen")
          }
        }

        /// UNSEALED: State of message record.
        internal var state: MessageState {
          get {
            return snapshot["state"]! as! MessageState
          }
          set {
            snapshot.updateValue(newValue, forKey: "state")
          }
        }

        /// UNSEALED: v4 UUID of user that owns the message resource.
        internal var owner: GraphQLID {
          get {
            return snapshot["owner"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "owner")
          }
        }

        /// UNSEALED: Algorithm descriptor describing internal and symmetric key encryption, e.g RSAEncryptionOAEPSHA256AESGCM.
        internal var algorithm: String {
          get {
            return snapshot["algorithm"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "algorithm")
          }
        }

        /// UNSEALED: Client generated key ID for the internal key.
        internal var keyId: String {
          get {
            return snapshot["keyId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "keyId")
          }
        }

        /// UNSEALED: ID used for the client to subscribe to specific events.
        internal var clientRefId: String? {
          get {
            return snapshot["clientRefId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "clientRefId")
          }
        }

        /// UNSEALED: Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
        internal var createdAtEpochMs: Double {
          get {
            return snapshot["createdAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
          }
        }

        /// UNSEALED: Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
        internal var updatedAtEpochMs: Double {
          get {
            return snapshot["updatedAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
          }
        }

        internal var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        internal struct Fragments {
          internal var snapshot: Snapshot

          internal var sealedMessage: SealedMessage {
            get {
              return SealedMessage(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }
        }

        internal struct Medium: GraphQLSelectionSet {
          internal static let possibleTypes = ["S3MediaObject"]

          internal static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("key", type: .nonNull(.scalar(String.self))),
            GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
            GraphQLField("region", type: .nonNull(.scalar(String.self))),
          ]

          internal var snapshot: Snapshot

          internal init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          internal init(key: String, bucket: String, region: String) {
            self.init(snapshot: ["__typename": "S3MediaObject", "key": key, "bucket": bucket, "region": region])
          }

          internal var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Key of object in S3.
          internal var key: String {
            get {
              return snapshot["key"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "key")
            }
          }

          /// Name of S3 bucket.
          internal var bucket: String {
            get {
              return snapshot["bucket"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "bucket")
            }
          }

          /// Region S3 bucket is located in.
          internal var region: String {
            get {
              return snapshot["region"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "region")
            }
          }

          internal var fragments: Fragments {
            get {
              return Fragments(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }

          internal struct Fragments {
            internal var snapshot: Snapshot

            internal var s3MediaObject: S3MediaObject {
              get {
                return S3MediaObject(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }
          }
        }
      }
    }
  }
}

internal final class OnMessageReceivedSubscription: GraphQLSubscription {
  internal static let operationString =
    "subscription onMessageReceived($owner: String!) {\n  OnMessage(owner: $owner) {\n    __typename\n    ...sealedMessage\n  }\n}"

  internal static var requestString: String { return operationString.appending(SealedMessage.fragmentString).appending(S3MediaObject.fragmentString) }

  internal var owner: String

  internal init(owner: String) {
    self.owner = owner
  }

  internal var variables: GraphQLMap? {
    return ["owner": owner]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Subscription"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("OnMessage", arguments: ["owner": GraphQLVariable("owner")], type: .object(OnMessage.selections)),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(onMessage: OnMessage? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "OnMessage": onMessage.flatMap { $0.snapshot }])
    }

    /// Owner id for the current logged in user.
    /// ID used for the client to subscribe to specific message events.
    internal var onMessage: OnMessage? {
      get {
        return (snapshot["OnMessage"] as? Snapshot).flatMap { OnMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "OnMessage")
      }
    }

    internal struct OnMessage: GraphQLSelectionSet {
      internal static let possibleTypes = ["SealedMessage"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("conversation", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("remotePhoneNumber", type: .nonNull(.scalar(String.self))),
        GraphQLField("localPhoneNumber", type: .nonNull(.scalar(String.self))),
        GraphQLField("body", type: .scalar(String.self)),
        GraphQLField("media", type: .list(.nonNull(.object(Medium.selections)))),
        GraphQLField("direction", type: .nonNull(.scalar(MessageDirection.self))),
        GraphQLField("seen", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("state", type: .nonNull(.scalar(MessageState.self))),
        GraphQLField("owner", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("algorithm", type: .nonNull(.scalar(String.self))),
        GraphQLField("keyId", type: .nonNull(.scalar(String.self))),
        GraphQLField("clientRefId", type: .scalar(String.self)),
        GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
        GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(id: GraphQLID, conversation: GraphQLID, remotePhoneNumber: String, localPhoneNumber: String, body: String? = nil, media: [Medium]? = nil, direction: MessageDirection, seen: Bool, state: MessageState, owner: GraphQLID, algorithm: String, keyId: String, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "SealedMessage", "id": id, "conversation": conversation, "remotePhoneNumber": remotePhoneNumber, "localPhoneNumber": localPhoneNumber, "body": body, "media": media.flatMap { $0.map { $0.snapshot } }, "direction": direction, "seen": seen, "state": state, "owner": owner, "algorithm": algorithm, "keyId": keyId, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// UNSEALED: v4 UUID assigned to message record.
      internal var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// UNSEALED: v5 UUID generated by the client, v5 UUID produces a predictable repeatable
      /// result when provided with identical inputs, a fixed namespace UUID is included to
      /// further reduce collision.  Conversation IDs should be calculated as follows:
      /// v5(owner, localPhoneNumber + remotePhoneNumber)
      internal var conversation: GraphQLID {
        get {
          return snapshot["conversation"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversation")
        }
      }

      /// SEALED: Remote phone number in E164 format.
      internal var remotePhoneNumber: String {
        get {
          return snapshot["remotePhoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "remotePhoneNumber")
        }
      }

      /// SEALED: Sudo phone number in E164 format.
      internal var localPhoneNumber: String {
        get {
          return snapshot["localPhoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "localPhoneNumber")
        }
      }

      /// SEALED: Message body, null if MMS only.
      internal var body: String? {
        get {
          return snapshot["body"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "body")
        }
      }

      /// SEALED: MMS attachments.
      internal var media: [Medium]? {
        get {
          return (snapshot["media"] as? [Snapshot]).flatMap { $0.map { Medium(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "media")
        }
      }

      /// UNSEALED: Direction of message.
      internal var direction: MessageDirection {
        get {
          return snapshot["direction"]! as! MessageDirection
        }
        set {
          snapshot.updateValue(newValue, forKey: "direction")
        }
      }

      /// UNSEALED: Has this message been marked as seen on client.
      internal var seen: Bool {
        get {
          return snapshot["seen"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "seen")
        }
      }

      /// UNSEALED: State of message record.
      internal var state: MessageState {
        get {
          return snapshot["state"]! as! MessageState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// UNSEALED: v4 UUID of user that owns the message resource.
      internal var owner: GraphQLID {
        get {
          return snapshot["owner"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      /// UNSEALED: Algorithm descriptor describing internal and symmetric key encryption, e.g RSAEncryptionOAEPSHA256AESGCM.
      internal var algorithm: String {
        get {
          return snapshot["algorithm"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "algorithm")
        }
      }

      /// UNSEALED: Client generated key ID for the internal key.
      internal var keyId: String {
        get {
          return snapshot["keyId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyId")
        }
      }

      /// UNSEALED: ID used for the client to subscribe to specific events.
      internal var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// UNSEALED: Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      internal var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// UNSEALED: Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      internal var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      internal var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      internal struct Fragments {
        internal var snapshot: Snapshot

        internal var sealedMessage: SealedMessage {
          get {
            return SealedMessage(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      internal struct Medium: GraphQLSelectionSet {
        internal static let possibleTypes = ["S3MediaObject"]

        internal static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("key", type: .nonNull(.scalar(String.self))),
          GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
          GraphQLField("region", type: .nonNull(.scalar(String.self))),
        ]

        internal var snapshot: Snapshot

        internal init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        internal init(key: String, bucket: String, region: String) {
          self.init(snapshot: ["__typename": "S3MediaObject", "key": key, "bucket": bucket, "region": region])
        }

        internal var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Key of object in S3.
        internal var key: String {
          get {
            return snapshot["key"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "key")
          }
        }

        /// Name of S3 bucket.
        internal var bucket: String {
          get {
            return snapshot["bucket"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "bucket")
          }
        }

        /// Region S3 bucket is located in.
        internal var region: String {
          get {
            return snapshot["region"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "region")
          }
        }

        internal var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        internal struct Fragments {
          internal var snapshot: Snapshot

          internal var s3MediaObject: S3MediaObject {
            get {
              return S3MediaObject(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }
        }
      }
    }
  }
}

internal final class GetConversationQuery: GraphQLQuery {
  internal static let operationString =
    "query getConversation($id: ID!) {\n  getConversation(id: $id) {\n    __typename\n    ...conversation\n  }\n}"

  internal static var requestString: String { return operationString.appending(Conversation.fragmentString) }

  internal var id: GraphQLID

  internal init(id: GraphQLID) {
    self.id = id
  }

  internal var variables: GraphQLMap? {
    return ["id": id]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Query"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("getConversation", arguments: ["id": GraphQLVariable("id")], type: .object(GetConversation.selections)),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(getConversation: GetConversation? = nil) {
      self.init(snapshot: ["__typename": "Query", "getConversation": getConversation.flatMap { $0.snapshot }])
    }

    /// Get a conversation record by ID.
    internal var getConversation: GetConversation? {
      get {
        return (snapshot["getConversation"] as? Snapshot).flatMap { GetConversation(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getConversation")
      }
    }

    internal struct GetConversation: GraphQLSelectionSet {
      internal static let possibleTypes = ["Conversation"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("owner", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(ConversationType.self))),
        GraphQLField("lastMessage", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
        GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(id: GraphQLID, owner: GraphQLID, type: ConversationType, lastMessage: GraphQLID, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "Conversation", "id": id, "owner": owner, "type": type, "lastMessage": lastMessage, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// v5 UUID generated by the client, v5 UUID produces a predictable repeatable
      /// result when provided with identical inputs, a fixed namespace UUID is included to
      /// further reduce collision.  Conversation IDs should be calculated as follows:
      /// v5(owner, localPhoneNumber + remotePhoneNumber)
      internal var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// v4 UUID of user that owns the conversation resource.
      internal var owner: GraphQLID {
        get {
          return snapshot["owner"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      /// Type for this conversation.
      internal var type: ConversationType {
        get {
          return snapshot["type"]! as! ConversationType
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      /// v4 UUID of last message, can be used to display preview in message feed.
      internal var lastMessage: GraphQLID {
        get {
          return snapshot["lastMessage"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastMessage")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      internal var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      internal var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      internal var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      internal struct Fragments {
        internal var snapshot: Snapshot

        internal var conversation: Conversation {
          get {
            return Conversation(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }
    }
  }
}

internal final class ListConversationsQuery: GraphQLQuery {
  internal static let operationString =
    "query listConversations($filter: ConversationFilterInput!, $limit: Int, $nextToken: String) {\n  listConversations(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      ...conversation\n    }\n    nextToken\n  }\n}"

  internal static var requestString: String { return operationString.appending(Conversation.fragmentString) }

  internal var filter: ConversationFilterInput
  internal var limit: Int?
  internal var nextToken: String?

  internal init(filter: ConversationFilterInput, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  internal var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  internal struct Data: GraphQLSelectionSet {
    internal static let possibleTypes = ["Query"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("listConversations", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListConversation.selections)),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(listConversations: ListConversation? = nil) {
      self.init(snapshot: ["__typename": "Query", "listConversations": listConversations.flatMap { $0.snapshot }])
    }

    /// Returns a list of message conversations.
    internal var listConversations: ListConversation? {
      get {
        return (snapshot["listConversations"] as? Snapshot).flatMap { ListConversation(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listConversations")
      }
    }

    internal struct ListConversation: GraphQLSelectionSet {
      internal static let possibleTypes = ["ConversationConnection"]

      internal static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .list(.nonNull(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      internal var snapshot: Snapshot

      internal init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      internal init(items: [Item]? = nil, nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ConversationConnection", "items": items.flatMap { $0.map { $0.snapshot } }, "nextToken": nextToken])
      }

      internal var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      internal var items: [Item]? {
        get {
          return (snapshot["items"] as? [Snapshot]).flatMap { $0.map { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "items")
        }
      }

      internal var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      internal struct Item: GraphQLSelectionSet {
        internal static let possibleTypes = ["Conversation"]

        internal static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("owner", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(ConversationType.self))),
          GraphQLField("lastMessage", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
          GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
        ]

        internal var snapshot: Snapshot

        internal init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        internal init(id: GraphQLID, owner: GraphQLID, type: ConversationType, lastMessage: GraphQLID, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
          self.init(snapshot: ["__typename": "Conversation", "id": id, "owner": owner, "type": type, "lastMessage": lastMessage, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
        }

        internal var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// v5 UUID generated by the client, v5 UUID produces a predictable repeatable
        /// result when provided with identical inputs, a fixed namespace UUID is included to
        /// further reduce collision.  Conversation IDs should be calculated as follows:
        /// v5(owner, localPhoneNumber + remotePhoneNumber)
        internal var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        /// v4 UUID of user that owns the conversation resource.
        internal var owner: GraphQLID {
          get {
            return snapshot["owner"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "owner")
          }
        }

        /// Type for this conversation.
        internal var type: ConversationType {
          get {
            return snapshot["type"]! as! ConversationType
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        /// v4 UUID of last message, can be used to display preview in message feed.
        internal var lastMessage: GraphQLID {
          get {
            return snapshot["lastMessage"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastMessage")
          }
        }

        /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
        internal var createdAtEpochMs: Double {
          get {
            return snapshot["createdAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
          }
        }

        /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
        internal var updatedAtEpochMs: Double {
          get {
            return snapshot["updatedAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
          }
        }

        internal var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        internal struct Fragments {
          internal var snapshot: Snapshot

          internal var conversation: Conversation {
            get {
              return Conversation(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }
        }
      }
    }
  }
}

internal struct SudoPhoneNumber: GraphQLFragment {
  internal static let fragmentString =
    "fragment SudoPhoneNumber on PhoneNumber {\n  __typename\n  id\n  phoneNumber\n  country\n  keyRingId\n  state\n  version\n  clientRefId\n  createdAtEpochMs\n  updatedAtEpochMs\n}"

  internal static let possibleTypes = ["PhoneNumber"]

  internal static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("phoneNumber", type: .nonNull(.scalar(String.self))),
    GraphQLField("country", type: .nonNull(.scalar(String.self))),
    GraphQLField("keyRingId", type: .nonNull(.scalar(String.self))),
    GraphQLField("state", type: .nonNull(.scalar(PhoneNumberState.self))),
    GraphQLField("version", type: .nonNull(.scalar(Int.self))),
    GraphQLField("clientRefId", type: .scalar(String.self)),
    GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
    GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
  ]

  internal var snapshot: Snapshot

  internal init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  internal init(id: GraphQLID, phoneNumber: String, country: String, keyRingId: String, state: PhoneNumberState, version: Int, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
    self.init(snapshot: ["__typename": "PhoneNumber", "id": id, "phoneNumber": phoneNumber, "country": country, "keyRingId": keyRingId, "state": state, "version": version, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
  }

  internal var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  /// v4 UUID of phone number record.
  internal var id: GraphQLID {
    get {
      return snapshot["id"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "id")
    }
  }

  /// E164 formatted phone number.
  internal var phoneNumber: String {
    get {
      return snapshot["phoneNumber"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "phoneNumber")
    }
  }

  /// ISO country code of phone number e.g. 'US' 'ZZ'.
  internal var country: String {
    get {
      return snapshot["country"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "country")
    }
  }

  /// Key ring ID that dictates which keys the child resources of this phone number will be encrypted with.
  internal var keyRingId: String {
    get {
      return snapshot["keyRingId"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "keyRingId")
    }
  }

  /// State of phone number.
  internal var state: PhoneNumberState {
    get {
      return snapshot["state"]! as! PhoneNumberState
    }
    set {
      snapshot.updateValue(newValue, forKey: "state")
    }
  }

  /// Version of this phone number record, increments on update.
  internal var version: Int {
    get {
      return snapshot["version"]! as! Int
    }
    set {
      snapshot.updateValue(newValue, forKey: "version")
    }
  }

  /// ID used for the client to subscribe to specific events.
  internal var clientRefId: String? {
    get {
      return snapshot["clientRefId"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "clientRefId")
    }
  }

  /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
  internal var createdAtEpochMs: Double {
    get {
      return snapshot["createdAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
    }
  }

  /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
  internal var updatedAtEpochMs: Double {
    get {
      return snapshot["updatedAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
    }
  }
}

internal struct SudoAvailablePhoneNumberResult: GraphQLFragment {
  internal static let fragmentString =
    "fragment SudoAvailablePhoneNumberResult on PhoneNumberSearch {\n  __typename\n  id\n  country\n  gps {\n    __typename\n    latitude\n    longitude\n  }\n  prefix\n  state\n  results\n  clientRefId\n  createdAtEpochMs\n  updatedAtEpochMs\n}"

  internal static let possibleTypes = ["PhoneNumberSearch"]

  internal static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("country", type: .nonNull(.scalar(String.self))),
    GraphQLField("gps", type: .object(Gp.selections)),
    GraphQLField("prefix", type: .scalar(String.self)),
    GraphQLField("state", type: .nonNull(.scalar(PhoneNumberSearchState.self))),
    GraphQLField("results", type: .list(.nonNull(.scalar(String.self)))),
    GraphQLField("clientRefId", type: .scalar(String.self)),
    GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
    GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
  ]

  internal var snapshot: Snapshot

  internal init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  internal init(id: GraphQLID, country: String, gps: Gp? = nil, `prefix`: String? = nil, state: PhoneNumberSearchState, results: [String]? = nil, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
    self.init(snapshot: ["__typename": "PhoneNumberSearch", "id": id, "country": country, "gps": gps.flatMap { $0.snapshot }, "prefix": `prefix`, "state": state, "results": results, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
  }

  internal var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  /// v4 UUID assigned to the phone number search.
  internal var id: GraphQLID {
    get {
      return snapshot["id"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "id")
    }
  }

  /// ISO country code of phone number e.g. 'US' 'ZZ'.
  internal var country: String {
    get {
      return snapshot["country"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "country")
    }
  }

  /// GPS coordinates to scope phone number search.
  internal var gps: Gp? {
    get {
      return (snapshot["gps"] as? Snapshot).flatMap { Gp(snapshot: $0) }
    }
    set {
      snapshot.updateValue(newValue?.snapshot, forKey: "gps")
    }
  }

  /// Area code of phone number e.g. 801, 555.
  internal var `prefix`: String? {
    get {
      return snapshot["prefix"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "prefix")
    }
  }

  /// Current state of phone number search request.
  internal var state: PhoneNumberSearchState {
    get {
      return snapshot["state"]! as! PhoneNumberSearchState
    }
    set {
      snapshot.updateValue(newValue, forKey: "state")
    }
  }

  /// Array of available phone numbers.
  internal var results: [String]? {
    get {
      return snapshot["results"] as? [String]
    }
    set {
      snapshot.updateValue(newValue, forKey: "results")
    }
  }

  /// ID used for the client to subscribe to specific events.
  internal var clientRefId: String? {
    get {
      return snapshot["clientRefId"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "clientRefId")
    }
  }

  /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
  internal var createdAtEpochMs: Double {
    get {
      return snapshot["createdAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
    }
  }

  /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
  internal var updatedAtEpochMs: Double {
    get {
      return snapshot["updatedAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
    }
  }

  internal struct Gp: GraphQLSelectionSet {
    internal static let possibleTypes = ["GpsCoordinates"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("latitude", type: .nonNull(.scalar(String.self))),
      GraphQLField("longitude", type: .nonNull(.scalar(String.self))),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(latitude: String, longitude: String) {
      self.init(snapshot: ["__typename": "GpsCoordinates", "latitude": latitude, "longitude": longitude])
    }

    internal var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    internal var latitude: String {
      get {
        return snapshot["latitude"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "latitude")
      }
    }

    internal var longitude: String {
      get {
        return snapshot["longitude"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "longitude")
      }
    }
  }
}

internal struct PublicKey: GraphQLFragment {
  internal static let fragmentString =
    "fragment publicKey on PublicKey {\n  __typename\n  keyId\n  keyRingId\n  algorithm\n  publicKey\n  owner\n  version\n  createdAtEpochMs\n  updatedAtEpochMs\n}"

  internal static let possibleTypes = ["PublicKey"]

  internal static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("keyId", type: .nonNull(.scalar(String.self))),
    GraphQLField("keyRingId", type: .nonNull(.scalar(String.self))),
    GraphQLField("algorithm", type: .nonNull(.scalar(String.self))),
    GraphQLField("publicKey", type: .nonNull(.scalar(String.self))),
    GraphQLField("owner", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("version", type: .nonNull(.scalar(Int.self))),
    GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
    GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
  ]

  internal var snapshot: Snapshot

  internal init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  internal init(keyId: String, keyRingId: String, algorithm: String, publicKey: String, owner: GraphQLID, version: Int, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
    self.init(snapshot: ["__typename": "PublicKey", "keyId": keyId, "keyRingId": keyRingId, "algorithm": algorithm, "publicKey": publicKey, "owner": owner, "version": version, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
  }

  internal var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  internal var keyId: String {
    get {
      return snapshot["keyId"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "keyId")
    }
  }

  internal var keyRingId: String {
    get {
      return snapshot["keyRingId"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "keyRingId")
    }
  }

  internal var algorithm: String {
    get {
      return snapshot["algorithm"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "algorithm")
    }
  }

  internal var publicKey: String {
    get {
      return snapshot["publicKey"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "publicKey")
    }
  }

  internal var owner: GraphQLID {
    get {
      return snapshot["owner"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "owner")
    }
  }

  internal var version: Int {
    get {
      return snapshot["version"]! as! Int
    }
    set {
      snapshot.updateValue(newValue, forKey: "version")
    }
  }

  internal var createdAtEpochMs: Double {
    get {
      return snapshot["createdAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
    }
  }

  internal var updatedAtEpochMs: Double {
    get {
      return snapshot["updatedAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
    }
  }
}

internal struct SealedMessage: GraphQLFragment {
  internal static let fragmentString =
    "fragment sealedMessage on SealedMessage {\n  __typename\n  id\n  conversation\n  remotePhoneNumber\n  localPhoneNumber\n  body\n  media {\n    __typename\n    ...s3MediaObject\n  }\n  direction\n  seen\n  state\n  owner\n  algorithm\n  keyId\n  clientRefId\n  createdAtEpochMs\n  updatedAtEpochMs\n}"

  internal static let possibleTypes = ["SealedMessage"]

  internal static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("conversation", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("remotePhoneNumber", type: .nonNull(.scalar(String.self))),
    GraphQLField("localPhoneNumber", type: .nonNull(.scalar(String.self))),
    GraphQLField("body", type: .scalar(String.self)),
    GraphQLField("media", type: .list(.nonNull(.object(Medium.selections)))),
    GraphQLField("direction", type: .nonNull(.scalar(MessageDirection.self))),
    GraphQLField("seen", type: .nonNull(.scalar(Bool.self))),
    GraphQLField("state", type: .nonNull(.scalar(MessageState.self))),
    GraphQLField("owner", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("algorithm", type: .nonNull(.scalar(String.self))),
    GraphQLField("keyId", type: .nonNull(.scalar(String.self))),
    GraphQLField("clientRefId", type: .scalar(String.self)),
    GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
    GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
  ]

  internal var snapshot: Snapshot

  internal init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  internal init(id: GraphQLID, conversation: GraphQLID, remotePhoneNumber: String, localPhoneNumber: String, body: String? = nil, media: [Medium]? = nil, direction: MessageDirection, seen: Bool, state: MessageState, owner: GraphQLID, algorithm: String, keyId: String, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
    self.init(snapshot: ["__typename": "SealedMessage", "id": id, "conversation": conversation, "remotePhoneNumber": remotePhoneNumber, "localPhoneNumber": localPhoneNumber, "body": body, "media": media.flatMap { $0.map { $0.snapshot } }, "direction": direction, "seen": seen, "state": state, "owner": owner, "algorithm": algorithm, "keyId": keyId, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
  }

  internal var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  /// UNSEALED: v4 UUID assigned to message record.
  internal var id: GraphQLID {
    get {
      return snapshot["id"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "id")
    }
  }

  /// UNSEALED: v5 UUID generated by the client, v5 UUID produces a predictable repeatable
  /// result when provided with identical inputs, a fixed namespace UUID is included to
  /// further reduce collision.  Conversation IDs should be calculated as follows:
  /// v5(owner, localPhoneNumber + remotePhoneNumber)
  internal var conversation: GraphQLID {
    get {
      return snapshot["conversation"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "conversation")
    }
  }

  /// SEALED: Remote phone number in E164 format.
  internal var remotePhoneNumber: String {
    get {
      return snapshot["remotePhoneNumber"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "remotePhoneNumber")
    }
  }

  /// SEALED: Sudo phone number in E164 format.
  internal var localPhoneNumber: String {
    get {
      return snapshot["localPhoneNumber"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "localPhoneNumber")
    }
  }

  /// SEALED: Message body, null if MMS only.
  internal var body: String? {
    get {
      return snapshot["body"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "body")
    }
  }

  /// SEALED: MMS attachments.
  internal var media: [Medium]? {
    get {
      return (snapshot["media"] as? [Snapshot]).flatMap { $0.map { Medium(snapshot: $0) } }
    }
    set {
      snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "media")
    }
  }

  /// UNSEALED: Direction of message.
  internal var direction: MessageDirection {
    get {
      return snapshot["direction"]! as! MessageDirection
    }
    set {
      snapshot.updateValue(newValue, forKey: "direction")
    }
  }

  /// UNSEALED: Has this message been marked as seen on client.
  internal var seen: Bool {
    get {
      return snapshot["seen"]! as! Bool
    }
    set {
      snapshot.updateValue(newValue, forKey: "seen")
    }
  }

  /// UNSEALED: State of message record.
  internal var state: MessageState {
    get {
      return snapshot["state"]! as! MessageState
    }
    set {
      snapshot.updateValue(newValue, forKey: "state")
    }
  }

  /// UNSEALED: v4 UUID of user that owns the message resource.
  internal var owner: GraphQLID {
    get {
      return snapshot["owner"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "owner")
    }
  }

  /// UNSEALED: Algorithm descriptor describing internal and symmetric key encryption, e.g RSAEncryptionOAEPSHA256AESGCM.
  internal var algorithm: String {
    get {
      return snapshot["algorithm"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "algorithm")
    }
  }

  /// UNSEALED: Client generated key ID for the internal key.
  internal var keyId: String {
    get {
      return snapshot["keyId"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "keyId")
    }
  }

  /// UNSEALED: ID used for the client to subscribe to specific events.
  internal var clientRefId: String? {
    get {
      return snapshot["clientRefId"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "clientRefId")
    }
  }

  /// UNSEALED: Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
  internal var createdAtEpochMs: Double {
    get {
      return snapshot["createdAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
    }
  }

  /// UNSEALED: Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
  internal var updatedAtEpochMs: Double {
    get {
      return snapshot["updatedAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
    }
  }

  internal struct Medium: GraphQLSelectionSet {
    internal static let possibleTypes = ["S3MediaObject"]

    internal static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("key", type: .nonNull(.scalar(String.self))),
      GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
      GraphQLField("region", type: .nonNull(.scalar(String.self))),
    ]

    internal var snapshot: Snapshot

    internal init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    internal init(key: String, bucket: String, region: String) {
      self.init(snapshot: ["__typename": "S3MediaObject", "key": key, "bucket": bucket, "region": region])
    }

    internal var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    /// Key of object in S3.
    internal var key: String {
      get {
        return snapshot["key"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "key")
      }
    }

    /// Name of S3 bucket.
    internal var bucket: String {
      get {
        return snapshot["bucket"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "bucket")
      }
    }

    /// Region S3 bucket is located in.
    internal var region: String {
      get {
        return snapshot["region"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "region")
      }
    }

    internal var fragments: Fragments {
      get {
        return Fragments(snapshot: snapshot)
      }
      set {
        snapshot += newValue.snapshot
      }
    }

    internal struct Fragments {
      internal var snapshot: Snapshot

      internal var s3MediaObject: S3MediaObject {
        get {
          return S3MediaObject(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }
    }
  }
}

internal struct Conversation: GraphQLFragment {
  internal static let fragmentString =
    "fragment conversation on Conversation {\n  __typename\n  id\n  owner\n  type\n  lastMessage\n  createdAtEpochMs\n  updatedAtEpochMs\n}"

  internal static let possibleTypes = ["Conversation"]

  internal static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("owner", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("type", type: .nonNull(.scalar(ConversationType.self))),
    GraphQLField("lastMessage", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
    GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
  ]

  internal var snapshot: Snapshot

  internal init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  internal init(id: GraphQLID, owner: GraphQLID, type: ConversationType, lastMessage: GraphQLID, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
    self.init(snapshot: ["__typename": "Conversation", "id": id, "owner": owner, "type": type, "lastMessage": lastMessage, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
  }

  internal var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  /// v5 UUID generated by the client, v5 UUID produces a predictable repeatable
  /// result when provided with identical inputs, a fixed namespace UUID is included to
  /// further reduce collision.  Conversation IDs should be calculated as follows:
  /// v5(owner, localPhoneNumber + remotePhoneNumber)
  internal var id: GraphQLID {
    get {
      return snapshot["id"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "id")
    }
  }

  /// v4 UUID of user that owns the conversation resource.
  internal var owner: GraphQLID {
    get {
      return snapshot["owner"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "owner")
    }
  }

  /// Type for this conversation.
  internal var type: ConversationType {
    get {
      return snapshot["type"]! as! ConversationType
    }
    set {
      snapshot.updateValue(newValue, forKey: "type")
    }
  }

  /// v4 UUID of last message, can be used to display preview in message feed.
  internal var lastMessage: GraphQLID {
    get {
      return snapshot["lastMessage"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "lastMessage")
    }
  }

  /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
  internal var createdAtEpochMs: Double {
    get {
      return snapshot["createdAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
    }
  }

  /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
  internal var updatedAtEpochMs: Double {
    get {
      return snapshot["updatedAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
    }
  }
}

internal struct S3MediaObject: GraphQLFragment {
  internal static let fragmentString =
    "fragment s3MediaObject on S3MediaObject {\n  __typename\n  key\n  bucket\n  region\n}"

  internal static let possibleTypes = ["S3MediaObject"]

  internal static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("key", type: .nonNull(.scalar(String.self))),
    GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
    GraphQLField("region", type: .nonNull(.scalar(String.self))),
  ]

  internal var snapshot: Snapshot

  internal init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  internal init(key: String, bucket: String, region: String) {
    self.init(snapshot: ["__typename": "S3MediaObject", "key": key, "bucket": bucket, "region": region])
  }

  internal var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  /// Key of object in S3.
  internal var key: String {
    get {
      return snapshot["key"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "key")
    }
  }

  /// Name of S3 bucket.
  internal var bucket: String {
    get {
      return snapshot["bucket"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "bucket")
    }
  }

  /// Region S3 bucket is located in.
  internal var region: String {
    get {
      return snapshot["region"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "region")
    }
  }
}
