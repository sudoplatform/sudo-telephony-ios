//  This file was automatically generated and should not be edited.

import AWSAppSync

/// Input definition to provision a phone number.
public struct ProvisionPhoneNumberInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(phoneNumber: String, country: String, keyRingId: String, clientRefId: Optional<String?> = nil, ownerProofs: [String]) {
    graphQLMap = ["phoneNumber": phoneNumber, "country": country, "keyRingId": keyRingId, "clientRefId": clientRefId, "ownerProofs": ownerProofs]
  }

  /// E164 formatted phone number.
  public var phoneNumber: String {
    get {
      return graphQLMap["phoneNumber"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }

  /// ISO country code of phone number e.g. 'US' 'ZZ'.
  public var country: String {
    get {
      return graphQLMap["country"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "country")
    }
  }

  /// Key ring ID that dictates which keys the child resources of this phone number will be encrypted with.
  public var keyRingId: String {
    get {
      return graphQLMap["keyRingId"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "keyRingId")
    }
  }

  /// ID used for the client to subscribe to specific events.
  public var clientRefId: Optional<String?> {
    get {
      return graphQLMap["clientRefId"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clientRefId")
    }
  }

  /// Ownership proof tokens
  public var ownerProofs: [String] {
    get {
      return graphQLMap["ownerProofs"] as! [String]
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ownerProofs")
    }
  }
}

/// Input definition to delete a phone number.
public struct DeprovisionPhoneNumberInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(phoneNumber: String, expectedVersion: Int) {
    graphQLMap = ["phoneNumber": phoneNumber, "expectedVersion": expectedVersion]
  }

  /// Sudo phone number in E164 format.
  public var phoneNumber: String {
    get {
      return graphQLMap["phoneNumber"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneNumber")
    }
  }

  /// Expected version of the phone number.
  public var expectedVersion: Int {
    get {
      return graphQLMap["expectedVersion"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "expectedVersion")
    }
  }
}

public struct PhoneNumberFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: Optional<IDFilterInput?> = nil, country: Optional<StringFilterInput?> = nil, state: Optional<PhoneNumberStateFilterInput?> = nil, createdAtEpochMs: Optional<FloatFilterInput?> = nil, updatedAtEpochMs: Optional<FloatFilterInput?> = nil, and: Optional<[PhoneNumberFilterInput?]?> = nil, or: Optional<[PhoneNumberFilterInput?]?> = nil, not: Optional<PhoneNumberFilterInput?> = nil) {
    graphQLMap = ["id": id, "country": country, "state": state, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs, "and": and, "or": or, "not": not]
  }

  public var id: Optional<IDFilterInput?> {
    get {
      return graphQLMap["id"] as! Optional<IDFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var country: Optional<StringFilterInput?> {
    get {
      return graphQLMap["country"] as! Optional<StringFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "country")
    }
  }

  public var state: Optional<PhoneNumberStateFilterInput?> {
    get {
      return graphQLMap["state"] as! Optional<PhoneNumberStateFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "state")
    }
  }

  public var createdAtEpochMs: Optional<FloatFilterInput?> {
    get {
      return graphQLMap["createdAtEpochMs"] as! Optional<FloatFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAtEpochMs")
    }
  }

  public var updatedAtEpochMs: Optional<FloatFilterInput?> {
    get {
      return graphQLMap["updatedAtEpochMs"] as! Optional<FloatFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAtEpochMs")
    }
  }

  public var and: Optional<[PhoneNumberFilterInput?]?> {
    get {
      return graphQLMap["and"] as! Optional<[PhoneNumberFilterInput?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: Optional<[PhoneNumberFilterInput?]?> {
    get {
      return graphQLMap["or"] as! Optional<[PhoneNumberFilterInput?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: Optional<PhoneNumberFilterInput?> {
    get {
      return graphQLMap["not"] as! Optional<PhoneNumberFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct IDFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Optional<GraphQLID?> = nil, eq: Optional<GraphQLID?> = nil, contains: Optional<GraphQLID?> = nil, notContains: Optional<GraphQLID?> = nil, between: Optional<[GraphQLID?]?> = nil, beginsWith: Optional<GraphQLID?> = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith]
  }

  public var ne: Optional<GraphQLID?> {
    get {
      return graphQLMap["ne"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Optional<GraphQLID?> {
    get {
      return graphQLMap["eq"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var contains: Optional<GraphQLID?> {
    get {
      return graphQLMap["contains"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: Optional<GraphQLID?> {
    get {
      return graphQLMap["notContains"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: Optional<[GraphQLID?]?> {
    get {
      return graphQLMap["between"] as! Optional<[GraphQLID?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: Optional<GraphQLID?> {
    get {
      return graphQLMap["beginsWith"] as! Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }
}

public struct StringFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Optional<String?> = nil, eq: Optional<String?> = nil, le: Optional<String?> = nil, lt: Optional<String?> = nil, ge: Optional<String?> = nil, gt: Optional<String?> = nil, contains: Optional<String?> = nil, notContains: Optional<String?> = nil, between: Optional<[String?]?> = nil, beginsWith: Optional<String?> = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith]
  }

  public var ne: Optional<String?> {
    get {
      return graphQLMap["ne"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Optional<String?> {
    get {
      return graphQLMap["eq"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Optional<String?> {
    get {
      return graphQLMap["le"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Optional<String?> {
    get {
      return graphQLMap["lt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Optional<String?> {
    get {
      return graphQLMap["ge"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Optional<String?> {
    get {
      return graphQLMap["gt"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: Optional<String?> {
    get {
      return graphQLMap["contains"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: Optional<String?> {
    get {
      return graphQLMap["notContains"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: Optional<[String?]?> {
    get {
      return graphQLMap["between"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: Optional<String?> {
    get {
      return graphQLMap["beginsWith"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }
}

public struct PhoneNumberStateFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Optional<PhoneNumberState?> = nil, eq: Optional<PhoneNumberState?> = nil, `in`: Optional<[PhoneNumberState?]?> = nil, notIn: Optional<[PhoneNumberState?]?> = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "in": `in`, "notIn": notIn]
  }

  public var ne: Optional<PhoneNumberState?> {
    get {
      return graphQLMap["ne"] as! Optional<PhoneNumberState?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Optional<PhoneNumberState?> {
    get {
      return graphQLMap["eq"] as! Optional<PhoneNumberState?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var `in`: Optional<[PhoneNumberState?]?> {
    get {
      return graphQLMap["in"] as! Optional<[PhoneNumberState?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: Optional<[PhoneNumberState?]?> {
    get {
      return graphQLMap["notIn"] as! Optional<[PhoneNumberState?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

/// Phone number provisioning states.
public enum PhoneNumberState: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case provisioning
  case failed
  case complete
  case deprovisioning
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "PROVISIONING": self = .provisioning
      case "FAILED": self = .failed
      case "COMPLETE": self = .complete
      case "DEPROVISIONING": self = .deprovisioning
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .provisioning: return "PROVISIONING"
      case .failed: return "FAILED"
      case .complete: return "COMPLETE"
      case .deprovisioning: return "DEPROVISIONING"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: PhoneNumberState, rhs: PhoneNumberState) -> Bool {
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

public struct FloatFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Optional<Double?> = nil, eq: Optional<Double?> = nil, le: Optional<Double?> = nil, lt: Optional<Double?> = nil, ge: Optional<Double?> = nil, gt: Optional<Double?> = nil, contains: Optional<Double?> = nil, notContains: Optional<Double?> = nil, between: Optional<[Double?]?> = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between]
  }

  public var ne: Optional<Double?> {
    get {
      return graphQLMap["ne"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Optional<Double?> {
    get {
      return graphQLMap["eq"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Optional<Double?> {
    get {
      return graphQLMap["le"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Optional<Double?> {
    get {
      return graphQLMap["lt"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Optional<Double?> {
    get {
      return graphQLMap["ge"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Optional<Double?> {
    get {
      return graphQLMap["gt"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: Optional<Double?> {
    get {
      return graphQLMap["contains"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: Optional<Double?> {
    get {
      return graphQLMap["notContains"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: Optional<[Double?]?> {
    get {
      return graphQLMap["between"] as! Optional<[Double?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }
}

/// Phone number search states.
public enum PhoneNumberSearchState: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case searching
  case complete
  case failed
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "SEARCHING": self = .searching
      case "COMPLETE": self = .complete
      case "FAILED": self = .failed
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .searching: return "SEARCHING"
      case .complete: return "COMPLETE"
      case .failed: return "FAILED"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: PhoneNumberSearchState, rhs: PhoneNumberSearchState) -> Bool {
    switch (lhs, rhs) {
      case (.searching, .searching): return true
      case (.complete, .complete): return true
      case (.failed, .failed): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public struct CreatePublicKeyInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(keyId: String, keyRingId: String, algorithm: String, publicKey: String) {
    graphQLMap = ["keyId": keyId, "keyRingId": keyRingId, "algorithm": algorithm, "publicKey": publicKey]
  }

  public var keyId: String {
    get {
      return graphQLMap["keyId"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "keyId")
    }
  }

  public var keyRingId: String {
    get {
      return graphQLMap["keyRingId"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "keyRingId")
    }
  }

  public var algorithm: String {
    get {
      return graphQLMap["algorithm"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "algorithm")
    }
  }

  public var publicKey: String {
    get {
      return graphQLMap["publicKey"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "publicKey")
    }
  }
}

public struct DeletePublicKeyInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(keyId: String) {
    graphQLMap = ["keyId": keyId]
  }

  public var keyId: String {
    get {
      return graphQLMap["keyId"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "keyId")
    }
  }
}

/// Input definition to send a message.
public struct SendMessageInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(from: String, to: String, body: Optional<String?> = nil, media: Optional<[S3MediaObjectInput]?> = nil, clientRefId: Optional<String?> = nil) {
    graphQLMap = ["from": from, "to": to, "body": body, "media": media, "clientRefId": clientRefId]
  }

  /// Source phone number in E164 format.
  public var from: String {
    get {
      return graphQLMap["from"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "from")
    }
  }

  /// Recipient phone number in E164 format.
  public var to: String {
    get {
      return graphQLMap["to"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "to")
    }
  }

  /// Message body to send to recipient.
  public var body: Optional<String?> {
    get {
      return graphQLMap["body"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "body")
    }
  }

  /// Pointer to MMS Media object posted to S3 by client.
  public var media: Optional<[S3MediaObjectInput]?> {
    get {
      return graphQLMap["media"] as! Optional<[S3MediaObjectInput]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "media")
    }
  }

  /// ID used for the client to subscribe to specific events.
  public var clientRefId: Optional<String?> {
    get {
      return graphQLMap["clientRefId"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clientRefId")
    }
  }
}

/// Representation of the S3 Object containing telephony media (i.e. MMS and Voicemails).
public struct S3MediaObjectInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(key: String, bucket: String, region: String) {
    graphQLMap = ["key": key, "bucket": bucket, "region": region]
  }

  /// Key of object in S3.
  public var key: String {
    get {
      return graphQLMap["key"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "key")
    }
  }

  /// Name of S3 bucket.
  public var bucket: String {
    get {
      return graphQLMap["bucket"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "bucket")
    }
  }

  /// Region S3 bucket is located in.
  public var region: String {
    get {
      return graphQLMap["region"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "region")
    }
  }
}

public struct MessageFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(conversation: IDFilterInput, keyId: Optional<IDFilterInput?> = nil, createdAtEpochMs: Optional<FloatFilterInput?> = nil, updatedAtEpochMs: Optional<FloatFilterInput?> = nil, and: Optional<[MessageFilterInput?]?> = nil, or: Optional<[MessageFilterInput?]?> = nil, not: Optional<MessageFilterInput?> = nil) {
    graphQLMap = ["conversation": conversation, "keyId": keyId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs, "and": and, "or": or, "not": not]
  }

  public var conversation: IDFilterInput {
    get {
      return graphQLMap["conversation"] as! IDFilterInput
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "conversation")
    }
  }

  public var keyId: Optional<IDFilterInput?> {
    get {
      return graphQLMap["keyId"] as! Optional<IDFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "keyId")
    }
  }

  public var createdAtEpochMs: Optional<FloatFilterInput?> {
    get {
      return graphQLMap["createdAtEpochMs"] as! Optional<FloatFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAtEpochMs")
    }
  }

  public var updatedAtEpochMs: Optional<FloatFilterInput?> {
    get {
      return graphQLMap["updatedAtEpochMs"] as! Optional<FloatFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAtEpochMs")
    }
  }

  public var and: Optional<[MessageFilterInput?]?> {
    get {
      return graphQLMap["and"] as! Optional<[MessageFilterInput?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: Optional<[MessageFilterInput?]?> {
    get {
      return graphQLMap["or"] as! Optional<[MessageFilterInput?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: Optional<MessageFilterInput?> {
    get {
      return graphQLMap["not"] as! Optional<MessageFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ConversationFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(createdAtEpochMs: Optional<FloatFilterInput?> = nil, updatedAtEpochMs: Optional<FloatFilterInput?> = nil, and: Optional<[MessageFilterInput?]?> = nil, or: Optional<[MessageFilterInput?]?> = nil, not: Optional<MessageFilterInput?> = nil) {
    graphQLMap = ["createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs, "and": and, "or": or, "not": not]
  }

  public var createdAtEpochMs: Optional<FloatFilterInput?> {
    get {
      return graphQLMap["createdAtEpochMs"] as! Optional<FloatFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAtEpochMs")
    }
  }

  public var updatedAtEpochMs: Optional<FloatFilterInput?> {
    get {
      return graphQLMap["updatedAtEpochMs"] as! Optional<FloatFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAtEpochMs")
    }
  }

  public var and: Optional<[MessageFilterInput?]?> {
    get {
      return graphQLMap["and"] as! Optional<[MessageFilterInput?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: Optional<[MessageFilterInput?]?> {
    get {
      return graphQLMap["or"] as! Optional<[MessageFilterInput?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: Optional<MessageFilterInput?> {
    get {
      return graphQLMap["not"] as! Optional<MessageFilterInput?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

/// Possible directions for a SMS/MMS message.
public enum MessageDirection: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case inbound
  case outbound
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "INBOUND": self = .inbound
      case "OUTBOUND": self = .outbound
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .inbound: return "INBOUND"
      case .outbound: return "OUTBOUND"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: MessageDirection, rhs: MessageDirection) -> Bool {
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
public enum MessageState: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case queued
  case sent
  case delivered
  case undelivered
  case failed
  case received
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
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

  public var rawValue: RawValue {
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

  public static func == (lhs: MessageState, rhs: MessageState) -> Bool {
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
public enum ConversationType: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case individual
  case group
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "INDIVIDUAL": self = .individual
      case "GROUP": self = .group
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .individual: return "INDIVIDUAL"
      case .group: return "GROUP"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: ConversationType, rhs: ConversationType) -> Bool {
    switch (lhs, rhs) {
      case (.individual, .individual): return true
      case (.group, .group): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public final class AvailablePhoneNumbersForCountryCodeMutation: GraphQLMutation {
  public static let operationString =
    "mutation availablePhoneNumbersForCountryCode($country: String!, $limit: Int = 10) {\n  searchPhoneNumbers(input: {country: $country, limit: $limit}) {\n    __typename\n    ...SudoAvailablePhoneNumberResult\n  }\n}"

  public static var requestString: String { return operationString.appending(SudoAvailablePhoneNumberResult.fragmentString) }

  public var country: String
  public var limit: Int?

  public init(country: String, limit: Int? = nil) {
    self.country = country
    self.limit = limit
  }

  public var variables: GraphQLMap? {
    return ["country": country, "limit": limit]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("searchPhoneNumbers", arguments: ["input": ["country": GraphQLVariable("country"), "limit": GraphQLVariable("limit")]], type: .object(SearchPhoneNumber.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(searchPhoneNumbers: SearchPhoneNumber? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "searchPhoneNumbers": searchPhoneNumbers.flatMap { $0.snapshot }])
    }

    /// Search for available phone numbers for given criteria.
    public var searchPhoneNumbers: SearchPhoneNumber? {
      get {
        return (snapshot["searchPhoneNumbers"] as? Snapshot).flatMap { SearchPhoneNumber(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "searchPhoneNumbers")
      }
    }

    public struct SearchPhoneNumber: GraphQLSelectionSet {
      public static let possibleTypes = ["PhoneNumberSearch"]

      public static let selections: [GraphQLSelection] = [
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

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, country: String, gps: Gp? = nil, `prefix`: String? = nil, state: PhoneNumberSearchState, results: [String]? = nil, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PhoneNumberSearch", "id": id, "country": country, "gps": gps.flatMap { $0.snapshot }, "prefix": `prefix`, "state": state, "results": results, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// v4 UUID assigned to the phone number search.
      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// ISO country code of phone number e.g. 'US' 'ZZ'.
      public var country: String {
        get {
          return snapshot["country"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "country")
        }
      }

      /// GPS coordinates to scope phone number search.
      public var gps: Gp? {
        get {
          return (snapshot["gps"] as? Snapshot).flatMap { Gp(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "gps")
        }
      }

      /// Area code of phone number e.g. 801, 555.
      public var `prefix`: String? {
        get {
          return snapshot["prefix"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "prefix")
        }
      }

      /// Current state of phone number search request.
      public var state: PhoneNumberSearchState {
        get {
          return snapshot["state"]! as! PhoneNumberSearchState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// Array of available phone numbers.
      public var results: [String]? {
        get {
          return snapshot["results"] as? [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "results")
        }
      }

      /// ID used for the client to subscribe to specific events.
      public var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      public var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      public var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var sudoAvailablePhoneNumberResult: SudoAvailablePhoneNumberResult {
          get {
            return SudoAvailablePhoneNumberResult(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      public struct Gp: GraphQLSelectionSet {
        public static let possibleTypes = ["GpsCoordinates"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("latitude", type: .nonNull(.scalar(String.self))),
          GraphQLField("longitude", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(latitude: String, longitude: String) {
          self.init(snapshot: ["__typename": "GpsCoordinates", "latitude": latitude, "longitude": longitude])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var latitude: String {
          get {
            return snapshot["latitude"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "latitude")
          }
        }

        public var longitude: String {
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

public final class AvailablePhoneNumbersForPrefixMutation: GraphQLMutation {
  public static let operationString =
    "mutation availablePhoneNumbersForPrefix($country: String!, $prefix: String!, $limit: Int = 10) {\n  searchPhoneNumbers(input: {country: $country, prefix: $prefix, limit: $limit}) {\n    __typename\n    ...SudoAvailablePhoneNumberResult\n  }\n}"

  public static var requestString: String { return operationString.appending(SudoAvailablePhoneNumberResult.fragmentString) }

  public var country: String
  public var `prefix`: String
  public var limit: Int?

  public init(country: String, `prefix`: String, limit: Int? = nil) {
    self.country = country
    self.prefix = `prefix`
    self.limit = limit
  }

  public var variables: GraphQLMap? {
    return ["country": country, "prefix": `prefix`, "limit": limit]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("searchPhoneNumbers", arguments: ["input": ["country": GraphQLVariable("country"), "prefix": GraphQLVariable("prefix"), "limit": GraphQLVariable("limit")]], type: .object(SearchPhoneNumber.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(searchPhoneNumbers: SearchPhoneNumber? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "searchPhoneNumbers": searchPhoneNumbers.flatMap { $0.snapshot }])
    }

    /// Search for available phone numbers for given criteria.
    public var searchPhoneNumbers: SearchPhoneNumber? {
      get {
        return (snapshot["searchPhoneNumbers"] as? Snapshot).flatMap { SearchPhoneNumber(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "searchPhoneNumbers")
      }
    }

    public struct SearchPhoneNumber: GraphQLSelectionSet {
      public static let possibleTypes = ["PhoneNumberSearch"]

      public static let selections: [GraphQLSelection] = [
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

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, country: String, gps: Gp? = nil, `prefix`: String? = nil, state: PhoneNumberSearchState, results: [String]? = nil, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PhoneNumberSearch", "id": id, "country": country, "gps": gps.flatMap { $0.snapshot }, "prefix": `prefix`, "state": state, "results": results, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// v4 UUID assigned to the phone number search.
      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// ISO country code of phone number e.g. 'US' 'ZZ'.
      public var country: String {
        get {
          return snapshot["country"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "country")
        }
      }

      /// GPS coordinates to scope phone number search.
      public var gps: Gp? {
        get {
          return (snapshot["gps"] as? Snapshot).flatMap { Gp(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "gps")
        }
      }

      /// Area code of phone number e.g. 801, 555.
      public var `prefix`: String? {
        get {
          return snapshot["prefix"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "prefix")
        }
      }

      /// Current state of phone number search request.
      public var state: PhoneNumberSearchState {
        get {
          return snapshot["state"]! as! PhoneNumberSearchState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// Array of available phone numbers.
      public var results: [String]? {
        get {
          return snapshot["results"] as? [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "results")
        }
      }

      /// ID used for the client to subscribe to specific events.
      public var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      public var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      public var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var sudoAvailablePhoneNumberResult: SudoAvailablePhoneNumberResult {
          get {
            return SudoAvailablePhoneNumberResult(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      public struct Gp: GraphQLSelectionSet {
        public static let possibleTypes = ["GpsCoordinates"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("latitude", type: .nonNull(.scalar(String.self))),
          GraphQLField("longitude", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(latitude: String, longitude: String) {
          self.init(snapshot: ["__typename": "GpsCoordinates", "latitude": latitude, "longitude": longitude])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var latitude: String {
          get {
            return snapshot["latitude"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "latitude")
          }
        }

        public var longitude: String {
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

public final class AvailablePhoneNumbersForGpsMutation: GraphQLMutation {
  public static let operationString =
    "mutation availablePhoneNumbersForGPS($country: String!, $latitude: String!, $longitude: String!, $limit: Int = 10) {\n  searchPhoneNumbers(input: {country: $country, gps: {latitude: $latitude, longitude: $longitude}, limit: $limit}) {\n    __typename\n    ...SudoAvailablePhoneNumberResult\n  }\n}"

  public static var requestString: String { return operationString.appending(SudoAvailablePhoneNumberResult.fragmentString) }

  public var country: String
  public var latitude: String
  public var longitude: String
  public var limit: Int?

  public init(country: String, latitude: String, longitude: String, limit: Int? = nil) {
    self.country = country
    self.latitude = latitude
    self.longitude = longitude
    self.limit = limit
  }

  public var variables: GraphQLMap? {
    return ["country": country, "latitude": latitude, "longitude": longitude, "limit": limit]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("searchPhoneNumbers", arguments: ["input": ["country": GraphQLVariable("country"), "gps": ["latitude": GraphQLVariable("latitude"), "longitude": GraphQLVariable("longitude")], "limit": GraphQLVariable("limit")]], type: .object(SearchPhoneNumber.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(searchPhoneNumbers: SearchPhoneNumber? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "searchPhoneNumbers": searchPhoneNumbers.flatMap { $0.snapshot }])
    }

    /// Search for available phone numbers for given criteria.
    public var searchPhoneNumbers: SearchPhoneNumber? {
      get {
        return (snapshot["searchPhoneNumbers"] as? Snapshot).flatMap { SearchPhoneNumber(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "searchPhoneNumbers")
      }
    }

    public struct SearchPhoneNumber: GraphQLSelectionSet {
      public static let possibleTypes = ["PhoneNumberSearch"]

      public static let selections: [GraphQLSelection] = [
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

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, country: String, gps: Gp? = nil, `prefix`: String? = nil, state: PhoneNumberSearchState, results: [String]? = nil, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PhoneNumberSearch", "id": id, "country": country, "gps": gps.flatMap { $0.snapshot }, "prefix": `prefix`, "state": state, "results": results, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// v4 UUID assigned to the phone number search.
      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// ISO country code of phone number e.g. 'US' 'ZZ'.
      public var country: String {
        get {
          return snapshot["country"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "country")
        }
      }

      /// GPS coordinates to scope phone number search.
      public var gps: Gp? {
        get {
          return (snapshot["gps"] as? Snapshot).flatMap { Gp(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "gps")
        }
      }

      /// Area code of phone number e.g. 801, 555.
      public var `prefix`: String? {
        get {
          return snapshot["prefix"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "prefix")
        }
      }

      /// Current state of phone number search request.
      public var state: PhoneNumberSearchState {
        get {
          return snapshot["state"]! as! PhoneNumberSearchState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// Array of available phone numbers.
      public var results: [String]? {
        get {
          return snapshot["results"] as? [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "results")
        }
      }

      /// ID used for the client to subscribe to specific events.
      public var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      public var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      public var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var sudoAvailablePhoneNumberResult: SudoAvailablePhoneNumberResult {
          get {
            return SudoAvailablePhoneNumberResult(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      public struct Gp: GraphQLSelectionSet {
        public static let possibleTypes = ["GpsCoordinates"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("latitude", type: .nonNull(.scalar(String.self))),
          GraphQLField("longitude", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(latitude: String, longitude: String) {
          self.init(snapshot: ["__typename": "GpsCoordinates", "latitude": latitude, "longitude": longitude])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var latitude: String {
          get {
            return snapshot["latitude"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "latitude")
          }
        }

        public var longitude: String {
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

public final class SupportedCountriesQuery: GraphQLQuery {
  public static let operationString =
    "query supportedCountries {\n  getSupportedCountries {\n    __typename\n    countries\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getSupportedCountries", type: .object(GetSupportedCountry.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getSupportedCountries: GetSupportedCountry? = nil) {
      self.init(snapshot: ["__typename": "Query", "getSupportedCountries": getSupportedCountries.flatMap { $0.snapshot }])
    }

    /// Returns an array of ISO country codes.
    public var getSupportedCountries: GetSupportedCountry? {
      get {
        return (snapshot["getSupportedCountries"] as? Snapshot).flatMap { GetSupportedCountry(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getSupportedCountries")
      }
    }

    public struct GetSupportedCountry: GraphQLSelectionSet {
      public static let possibleTypes = ["SupportedCountries"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("countries", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(countries: [String]) {
        self.init(snapshot: ["__typename": "SupportedCountries", "countries": countries])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var countries: [String] {
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

public final class AvailablePhoneNumberResultQuery: GraphQLQuery {
  public static let operationString =
    "query availablePhoneNumberResult($id: ID!) {\n  getPhoneNumberSearch(id: $id) {\n    __typename\n    ...SudoAvailablePhoneNumberResult\n  }\n}"

  public static var requestString: String { return operationString.appending(SudoAvailablePhoneNumberResult.fragmentString) }

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getPhoneNumberSearch", arguments: ["id": GraphQLVariable("id")], type: .object(GetPhoneNumberSearch.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getPhoneNumberSearch: GetPhoneNumberSearch? = nil) {
      self.init(snapshot: ["__typename": "Query", "getPhoneNumberSearch": getPhoneNumberSearch.flatMap { $0.snapshot }])
    }

    /// Returns a phone number search record.
    public var getPhoneNumberSearch: GetPhoneNumberSearch? {
      get {
        return (snapshot["getPhoneNumberSearch"] as? Snapshot).flatMap { GetPhoneNumberSearch(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getPhoneNumberSearch")
      }
    }

    public struct GetPhoneNumberSearch: GraphQLSelectionSet {
      public static let possibleTypes = ["PhoneNumberSearch"]

      public static let selections: [GraphQLSelection] = [
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

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, country: String, gps: Gp? = nil, `prefix`: String? = nil, state: PhoneNumberSearchState, results: [String]? = nil, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PhoneNumberSearch", "id": id, "country": country, "gps": gps.flatMap { $0.snapshot }, "prefix": `prefix`, "state": state, "results": results, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// v4 UUID assigned to the phone number search.
      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// ISO country code of phone number e.g. 'US' 'ZZ'.
      public var country: String {
        get {
          return snapshot["country"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "country")
        }
      }

      /// GPS coordinates to scope phone number search.
      public var gps: Gp? {
        get {
          return (snapshot["gps"] as? Snapshot).flatMap { Gp(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "gps")
        }
      }

      /// Area code of phone number e.g. 801, 555.
      public var `prefix`: String? {
        get {
          return snapshot["prefix"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "prefix")
        }
      }

      /// Current state of phone number search request.
      public var state: PhoneNumberSearchState {
        get {
          return snapshot["state"]! as! PhoneNumberSearchState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// Array of available phone numbers.
      public var results: [String]? {
        get {
          return snapshot["results"] as? [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "results")
        }
      }

      /// ID used for the client to subscribe to specific events.
      public var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      public var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      public var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var sudoAvailablePhoneNumberResult: SudoAvailablePhoneNumberResult {
          get {
            return SudoAvailablePhoneNumberResult(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      public struct Gp: GraphQLSelectionSet {
        public static let possibleTypes = ["GpsCoordinates"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("latitude", type: .nonNull(.scalar(String.self))),
          GraphQLField("longitude", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(latitude: String, longitude: String) {
          self.init(snapshot: ["__typename": "GpsCoordinates", "latitude": latitude, "longitude": longitude])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var latitude: String {
          get {
            return snapshot["latitude"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "latitude")
          }
        }

        public var longitude: String {
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

public final class AvailablePhoneNumbersFinishedSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription availablePhoneNumbersFinished($owner: String!, $clientRefId: String!) {\n  OnSearch(owner: $owner, clientRefId: $clientRefId) {\n    __typename\n    ...SudoAvailablePhoneNumberResult\n  }\n}"

  public static var requestString: String { return operationString.appending(SudoAvailablePhoneNumberResult.fragmentString) }

  public var owner: String
  public var clientRefId: String

  public init(owner: String, clientRefId: String) {
    self.owner = owner
    self.clientRefId = clientRefId
  }

  public var variables: GraphQLMap? {
    return ["owner": owner, "clientRefId": clientRefId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("OnSearch", arguments: ["owner": GraphQLVariable("owner"), "clientRefId": GraphQLVariable("clientRefId")], type: .object(OnSearch.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onSearch: OnSearch? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "OnSearch": onSearch.flatMap { $0.snapshot }])
    }

    /// Owner id for the current logged in user.
    /// ID used for the client to subscribe to specific search events.
    public var onSearch: OnSearch? {
      get {
        return (snapshot["OnSearch"] as? Snapshot).flatMap { OnSearch(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "OnSearch")
      }
    }

    public struct OnSearch: GraphQLSelectionSet {
      public static let possibleTypes = ["PhoneNumberSearch"]

      public static let selections: [GraphQLSelection] = [
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

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, country: String, gps: Gp? = nil, `prefix`: String? = nil, state: PhoneNumberSearchState, results: [String]? = nil, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PhoneNumberSearch", "id": id, "country": country, "gps": gps.flatMap { $0.snapshot }, "prefix": `prefix`, "state": state, "results": results, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// v4 UUID assigned to the phone number search.
      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// ISO country code of phone number e.g. 'US' 'ZZ'.
      public var country: String {
        get {
          return snapshot["country"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "country")
        }
      }

      /// GPS coordinates to scope phone number search.
      public var gps: Gp? {
        get {
          return (snapshot["gps"] as? Snapshot).flatMap { Gp(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "gps")
        }
      }

      /// Area code of phone number e.g. 801, 555.
      public var `prefix`: String? {
        get {
          return snapshot["prefix"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "prefix")
        }
      }

      /// Current state of phone number search request.
      public var state: PhoneNumberSearchState {
        get {
          return snapshot["state"]! as! PhoneNumberSearchState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// Array of available phone numbers.
      public var results: [String]? {
        get {
          return snapshot["results"] as? [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "results")
        }
      }

      /// ID used for the client to subscribe to specific events.
      public var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      public var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      public var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var sudoAvailablePhoneNumberResult: SudoAvailablePhoneNumberResult {
          get {
            return SudoAvailablePhoneNumberResult(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      public struct Gp: GraphQLSelectionSet {
        public static let possibleTypes = ["GpsCoordinates"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("latitude", type: .nonNull(.scalar(String.self))),
          GraphQLField("longitude", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(latitude: String, longitude: String) {
          self.init(snapshot: ["__typename": "GpsCoordinates", "latitude": latitude, "longitude": longitude])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var latitude: String {
          get {
            return snapshot["latitude"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "latitude")
          }
        }

        public var longitude: String {
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

public final class ProvisionPhoneNumberMutation: GraphQLMutation {
  public static let operationString =
    "mutation provisionPhoneNumber($input: ProvisionPhoneNumberInput!) {\n  provisionPhoneNumber(input: $input) {\n    __typename\n    ...SudoPhoneNumber\n  }\n}"

  public static var requestString: String { return operationString.appending(SudoPhoneNumber.fragmentString) }

  public var input: ProvisionPhoneNumberInput

  public init(input: ProvisionPhoneNumberInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("provisionPhoneNumber", arguments: ["input": GraphQLVariable("input")], type: .object(ProvisionPhoneNumber.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(provisionPhoneNumber: ProvisionPhoneNumber? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "provisionPhoneNumber": provisionPhoneNumber.flatMap { $0.snapshot }])
    }

    /// Provision phone number.
    public var provisionPhoneNumber: ProvisionPhoneNumber? {
      get {
        return (snapshot["provisionPhoneNumber"] as? Snapshot).flatMap { ProvisionPhoneNumber(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "provisionPhoneNumber")
      }
    }

    public struct ProvisionPhoneNumber: GraphQLSelectionSet {
      public static let possibleTypes = ["PhoneNumber"]

      public static let selections: [GraphQLSelection] = [
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

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, phoneNumber: String, country: String, keyRingId: String, state: PhoneNumberState, version: Int, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PhoneNumber", "id": id, "phoneNumber": phoneNumber, "country": country, "keyRingId": keyRingId, "state": state, "version": version, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// v4 UUID of phone number record.
      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// E164 formatted phone number.
      public var phoneNumber: String {
        get {
          return snapshot["phoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      /// ISO country code of phone number e.g. 'US' 'ZZ'.
      public var country: String {
        get {
          return snapshot["country"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "country")
        }
      }

      /// Key ring ID that dictates which keys the child resources of this phone number will be encrypted with.
      public var keyRingId: String {
        get {
          return snapshot["keyRingId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyRingId")
        }
      }

      /// State of phone number.
      public var state: PhoneNumberState {
        get {
          return snapshot["state"]! as! PhoneNumberState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// Version of this phone number record, increments on update.
      public var version: Int {
        get {
          return snapshot["version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "version")
        }
      }

      /// ID used for the client to subscribe to specific events.
      public var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      public var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      public var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var sudoPhoneNumber: SudoPhoneNumber {
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

public final class ProvisionPhoneNumberChangedSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription provisionPhoneNumberChanged($owner: String!, $clientRefId: String!) {\n  OnProvision(owner: $owner, clientRefId: $clientRefId) {\n    __typename\n    ...SudoPhoneNumber\n  }\n}"

  public static var requestString: String { return operationString.appending(SudoPhoneNumber.fragmentString) }

  public var owner: String
  public var clientRefId: String

  public init(owner: String, clientRefId: String) {
    self.owner = owner
    self.clientRefId = clientRefId
  }

  public var variables: GraphQLMap? {
    return ["owner": owner, "clientRefId": clientRefId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("OnProvision", arguments: ["owner": GraphQLVariable("owner"), "clientRefId": GraphQLVariable("clientRefId")], type: .object(OnProvision.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onProvision: OnProvision? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "OnProvision": onProvision.flatMap { $0.snapshot }])
    }

    /// Owner id for the current logged in user.
    /// ID used for the client to subscribe to specific provision events.
    public var onProvision: OnProvision? {
      get {
        return (snapshot["OnProvision"] as? Snapshot).flatMap { OnProvision(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "OnProvision")
      }
    }

    public struct OnProvision: GraphQLSelectionSet {
      public static let possibleTypes = ["PhoneNumber"]

      public static let selections: [GraphQLSelection] = [
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

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, phoneNumber: String, country: String, keyRingId: String, state: PhoneNumberState, version: Int, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PhoneNumber", "id": id, "phoneNumber": phoneNumber, "country": country, "keyRingId": keyRingId, "state": state, "version": version, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// v4 UUID of phone number record.
      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// E164 formatted phone number.
      public var phoneNumber: String {
        get {
          return snapshot["phoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      /// ISO country code of phone number e.g. 'US' 'ZZ'.
      public var country: String {
        get {
          return snapshot["country"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "country")
        }
      }

      /// Key ring ID that dictates which keys the child resources of this phone number will be encrypted with.
      public var keyRingId: String {
        get {
          return snapshot["keyRingId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyRingId")
        }
      }

      /// State of phone number.
      public var state: PhoneNumberState {
        get {
          return snapshot["state"]! as! PhoneNumberState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// Version of this phone number record, increments on update.
      public var version: Int {
        get {
          return snapshot["version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "version")
        }
      }

      /// ID used for the client to subscribe to specific events.
      public var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      public var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      public var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var sudoPhoneNumber: SudoPhoneNumber {
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

public final class DeprovisionPhoneNumberMutation: GraphQLMutation {
  public static let operationString =
    "mutation deprovisionPhoneNumber($input: DeprovisionPhoneNumberInput!) {\n  deprovisionPhoneNumber(input: $input) {\n    __typename\n    ...SudoPhoneNumber\n  }\n}"

  public static var requestString: String { return operationString.appending(SudoPhoneNumber.fragmentString) }

  public var input: DeprovisionPhoneNumberInput

  public init(input: DeprovisionPhoneNumberInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deprovisionPhoneNumber", arguments: ["input": GraphQLVariable("input")], type: .object(DeprovisionPhoneNumber.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deprovisionPhoneNumber: DeprovisionPhoneNumber? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deprovisionPhoneNumber": deprovisionPhoneNumber.flatMap { $0.snapshot }])
    }

    /// Deprovision phone number.
    public var deprovisionPhoneNumber: DeprovisionPhoneNumber? {
      get {
        return (snapshot["deprovisionPhoneNumber"] as? Snapshot).flatMap { DeprovisionPhoneNumber(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deprovisionPhoneNumber")
      }
    }

    public struct DeprovisionPhoneNumber: GraphQLSelectionSet {
      public static let possibleTypes = ["PhoneNumber"]

      public static let selections: [GraphQLSelection] = [
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

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, phoneNumber: String, country: String, keyRingId: String, state: PhoneNumberState, version: Int, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PhoneNumber", "id": id, "phoneNumber": phoneNumber, "country": country, "keyRingId": keyRingId, "state": state, "version": version, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// v4 UUID of phone number record.
      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// E164 formatted phone number.
      public var phoneNumber: String {
        get {
          return snapshot["phoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      /// ISO country code of phone number e.g. 'US' 'ZZ'.
      public var country: String {
        get {
          return snapshot["country"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "country")
        }
      }

      /// Key ring ID that dictates which keys the child resources of this phone number will be encrypted with.
      public var keyRingId: String {
        get {
          return snapshot["keyRingId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyRingId")
        }
      }

      /// State of phone number.
      public var state: PhoneNumberState {
        get {
          return snapshot["state"]! as! PhoneNumberState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// Version of this phone number record, increments on update.
      public var version: Int {
        get {
          return snapshot["version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "version")
        }
      }

      /// ID used for the client to subscribe to specific events.
      public var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      public var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      public var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var sudoPhoneNumber: SudoPhoneNumber {
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

public final class PhoneNumbersQuery: GraphQLQuery {
  public static let operationString =
    "query phoneNumbers($filter: PhoneNumberFilterInput, $limit: Int, $nextToken: String) {\n  listPhoneNumbers(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      ...SudoPhoneNumber\n    }\n    nextToken\n  }\n}"

  public static var requestString: String { return operationString.appending(SudoPhoneNumber.fragmentString) }

  public var filter: PhoneNumberFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: PhoneNumberFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listPhoneNumbers", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListPhoneNumber.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listPhoneNumbers: ListPhoneNumber? = nil) {
      self.init(snapshot: ["__typename": "Query", "listPhoneNumbers": listPhoneNumbers.flatMap { $0.snapshot }])
    }

    /// Returns a list of phone numbers.
    public var listPhoneNumbers: ListPhoneNumber? {
      get {
        return (snapshot["listPhoneNumbers"] as? Snapshot).flatMap { ListPhoneNumber(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listPhoneNumbers")
      }
    }

    public struct ListPhoneNumber: GraphQLSelectionSet {
      public static let possibleTypes = ["PhoneNumberConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .list(.nonNull(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item]? = nil, nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "PhoneNumberConnection", "items": items.flatMap { $0.map { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item]? {
        get {
          return (snapshot["items"] as? [Snapshot]).flatMap { $0.map { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["PhoneNumber"]

        public static let selections: [GraphQLSelection] = [
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

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, phoneNumber: String, country: String, keyRingId: String, state: PhoneNumberState, version: Int, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
          self.init(snapshot: ["__typename": "PhoneNumber", "id": id, "phoneNumber": phoneNumber, "country": country, "keyRingId": keyRingId, "state": state, "version": version, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// v4 UUID of phone number record.
        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        /// E164 formatted phone number.
        public var phoneNumber: String {
          get {
            return snapshot["phoneNumber"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phoneNumber")
          }
        }

        /// ISO country code of phone number e.g. 'US' 'ZZ'.
        public var country: String {
          get {
            return snapshot["country"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "country")
          }
        }

        /// Key ring ID that dictates which keys the child resources of this phone number will be encrypted with.
        public var keyRingId: String {
          get {
            return snapshot["keyRingId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "keyRingId")
          }
        }

        /// State of phone number.
        public var state: PhoneNumberState {
          get {
            return snapshot["state"]! as! PhoneNumberState
          }
          set {
            snapshot.updateValue(newValue, forKey: "state")
          }
        }

        /// Version of this phone number record, increments on update.
        public var version: Int {
          get {
            return snapshot["version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "version")
          }
        }

        /// ID used for the client to subscribe to specific events.
        public var clientRefId: String? {
          get {
            return snapshot["clientRefId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "clientRefId")
          }
        }

        /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
        public var createdAtEpochMs: Double {
          get {
            return snapshot["createdAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
          }
        }

        /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
        public var updatedAtEpochMs: Double {
          get {
            return snapshot["updatedAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        public struct Fragments {
          public var snapshot: Snapshot

          public var sudoPhoneNumber: SudoPhoneNumber {
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

public final class PhoneNumberQuery: GraphQLQuery {
  public static let operationString =
    "query phoneNumber($id: ID!) {\n  getPhoneNumber(id: $id) {\n    __typename\n    ...SudoPhoneNumber\n  }\n}"

  public static var requestString: String { return operationString.appending(SudoPhoneNumber.fragmentString) }

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getPhoneNumber", arguments: ["id": GraphQLVariable("id")], type: .object(GetPhoneNumber.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getPhoneNumber: GetPhoneNumber? = nil) {
      self.init(snapshot: ["__typename": "Query", "getPhoneNumber": getPhoneNumber.flatMap { $0.snapshot }])
    }

    /// Get a phone number record by ID.
    public var getPhoneNumber: GetPhoneNumber? {
      get {
        return (snapshot["getPhoneNumber"] as? Snapshot).flatMap { GetPhoneNumber(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getPhoneNumber")
      }
    }

    public struct GetPhoneNumber: GraphQLSelectionSet {
      public static let possibleTypes = ["PhoneNumber"]

      public static let selections: [GraphQLSelection] = [
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

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, phoneNumber: String, country: String, keyRingId: String, state: PhoneNumberState, version: Int, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PhoneNumber", "id": id, "phoneNumber": phoneNumber, "country": country, "keyRingId": keyRingId, "state": state, "version": version, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// v4 UUID of phone number record.
      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// E164 formatted phone number.
      public var phoneNumber: String {
        get {
          return snapshot["phoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phoneNumber")
        }
      }

      /// ISO country code of phone number e.g. 'US' 'ZZ'.
      public var country: String {
        get {
          return snapshot["country"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "country")
        }
      }

      /// Key ring ID that dictates which keys the child resources of this phone number will be encrypted with.
      public var keyRingId: String {
        get {
          return snapshot["keyRingId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyRingId")
        }
      }

      /// State of phone number.
      public var state: PhoneNumberState {
        get {
          return snapshot["state"]! as! PhoneNumberState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// Version of this phone number record, increments on update.
      public var version: Int {
        get {
          return snapshot["version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "version")
        }
      }

      /// ID used for the client to subscribe to specific events.
      public var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      public var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      public var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var sudoPhoneNumber: SudoPhoneNumber {
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

public final class CreatePublicKeyMutation: GraphQLMutation {
  public static let operationString =
    "mutation createPublicKey($input: CreatePublicKeyInput!) {\n  createPublicKeyForTelephony(input: $input) {\n    __typename\n    ...publicKey\n  }\n}"

  public static var requestString: String { return operationString.appending(PublicKey.fragmentString) }

  public var input: CreatePublicKeyInput

  public init(input: CreatePublicKeyInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createPublicKeyForTelephony", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.object(CreatePublicKeyForTelephony.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createPublicKeyForTelephony: CreatePublicKeyForTelephony) {
      self.init(snapshot: ["__typename": "Mutation", "createPublicKeyForTelephony": createPublicKeyForTelephony.snapshot])
    }

    public var createPublicKeyForTelephony: CreatePublicKeyForTelephony {
      get {
        return CreatePublicKeyForTelephony(snapshot: snapshot["createPublicKeyForTelephony"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "createPublicKeyForTelephony")
      }
    }

    public struct CreatePublicKeyForTelephony: GraphQLSelectionSet {
      public static let possibleTypes = ["PublicKey"]

      public static let selections: [GraphQLSelection] = [
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

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(keyId: String, keyRingId: String, algorithm: String, publicKey: String, owner: GraphQLID, version: Int, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PublicKey", "keyId": keyId, "keyRingId": keyRingId, "algorithm": algorithm, "publicKey": publicKey, "owner": owner, "version": version, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var keyId: String {
        get {
          return snapshot["keyId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyId")
        }
      }

      public var keyRingId: String {
        get {
          return snapshot["keyRingId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyRingId")
        }
      }

      public var algorithm: String {
        get {
          return snapshot["algorithm"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "algorithm")
        }
      }

      public var publicKey: String {
        get {
          return snapshot["publicKey"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "publicKey")
        }
      }

      public var owner: GraphQLID {
        get {
          return snapshot["owner"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public var version: Int {
        get {
          return snapshot["version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "version")
        }
      }

      public var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      public var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var publicKey: PublicKey {
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

public final class DeletePublicKeyMutation: GraphQLMutation {
  public static let operationString =
    "mutation deletePublicKey($input: DeletePublicKeyInput!) {\n  deletePublicKeyForTelephony(input: $input) {\n    __typename\n    ...publicKey\n  }\n}"

  public static var requestString: String { return operationString.appending(PublicKey.fragmentString) }

  public var input: DeletePublicKeyInput

  public init(input: DeletePublicKeyInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deletePublicKeyForTelephony", arguments: ["input": GraphQLVariable("input")], type: .object(DeletePublicKeyForTelephony.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deletePublicKeyForTelephony: DeletePublicKeyForTelephony? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deletePublicKeyForTelephony": deletePublicKeyForTelephony.flatMap { $0.snapshot }])
    }

    public var deletePublicKeyForTelephony: DeletePublicKeyForTelephony? {
      get {
        return (snapshot["deletePublicKeyForTelephony"] as? Snapshot).flatMap { DeletePublicKeyForTelephony(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deletePublicKeyForTelephony")
      }
    }

    public struct DeletePublicKeyForTelephony: GraphQLSelectionSet {
      public static let possibleTypes = ["PublicKey"]

      public static let selections: [GraphQLSelection] = [
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

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(keyId: String, keyRingId: String, algorithm: String, publicKey: String, owner: GraphQLID, version: Int, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PublicKey", "keyId": keyId, "keyRingId": keyRingId, "algorithm": algorithm, "publicKey": publicKey, "owner": owner, "version": version, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var keyId: String {
        get {
          return snapshot["keyId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyId")
        }
      }

      public var keyRingId: String {
        get {
          return snapshot["keyRingId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyRingId")
        }
      }

      public var algorithm: String {
        get {
          return snapshot["algorithm"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "algorithm")
        }
      }

      public var publicKey: String {
        get {
          return snapshot["publicKey"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "publicKey")
        }
      }

      public var owner: GraphQLID {
        get {
          return snapshot["owner"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public var version: Int {
        get {
          return snapshot["version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "version")
        }
      }

      public var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      public var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var publicKey: PublicKey {
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

public final class GetPublicKeyQuery: GraphQLQuery {
  public static let operationString =
    "query getPublicKey($keyId: String!) {\n  getPublicKeyForTelephony(keyId: $keyId) {\n    __typename\n    ...publicKey\n  }\n}"

  public static var requestString: String { return operationString.appending(PublicKey.fragmentString) }

  public var keyId: String

  public init(keyId: String) {
    self.keyId = keyId
  }

  public var variables: GraphQLMap? {
    return ["keyId": keyId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getPublicKeyForTelephony", arguments: ["keyId": GraphQLVariable("keyId")], type: .object(GetPublicKeyForTelephony.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getPublicKeyForTelephony: GetPublicKeyForTelephony? = nil) {
      self.init(snapshot: ["__typename": "Query", "getPublicKeyForTelephony": getPublicKeyForTelephony.flatMap { $0.snapshot }])
    }

    public var getPublicKeyForTelephony: GetPublicKeyForTelephony? {
      get {
        return (snapshot["getPublicKeyForTelephony"] as? Snapshot).flatMap { GetPublicKeyForTelephony(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getPublicKeyForTelephony")
      }
    }

    public struct GetPublicKeyForTelephony: GraphQLSelectionSet {
      public static let possibleTypes = ["PublicKey"]

      public static let selections: [GraphQLSelection] = [
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

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(keyId: String, keyRingId: String, algorithm: String, publicKey: String, owner: GraphQLID, version: Int, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "PublicKey", "keyId": keyId, "keyRingId": keyRingId, "algorithm": algorithm, "publicKey": publicKey, "owner": owner, "version": version, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var keyId: String {
        get {
          return snapshot["keyId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyId")
        }
      }

      public var keyRingId: String {
        get {
          return snapshot["keyRingId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyRingId")
        }
      }

      public var algorithm: String {
        get {
          return snapshot["algorithm"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "algorithm")
        }
      }

      public var publicKey: String {
        get {
          return snapshot["publicKey"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "publicKey")
        }
      }

      public var owner: GraphQLID {
        get {
          return snapshot["owner"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public var version: Int {
        get {
          return snapshot["version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "version")
        }
      }

      public var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      public var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var publicKey: PublicKey {
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

public final class GetPublicKeysQuery: GraphQLQuery {
  public static let operationString =
    "query getPublicKeys($limit: Int, $nextToken: String) {\n  getPublicKeysForTelephony(limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      ...publicKey\n    }\n    nextToken\n  }\n}"

  public static var requestString: String { return operationString.appending(PublicKey.fragmentString) }

  public var limit: Int?
  public var nextToken: String?

  public init(limit: Int? = nil, nextToken: String? = nil) {
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getPublicKeysForTelephony", arguments: ["limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .nonNull(.object(GetPublicKeysForTelephony.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getPublicKeysForTelephony: GetPublicKeysForTelephony) {
      self.init(snapshot: ["__typename": "Query", "getPublicKeysForTelephony": getPublicKeysForTelephony.snapshot])
    }

    public var getPublicKeysForTelephony: GetPublicKeysForTelephony {
      get {
        return GetPublicKeysForTelephony(snapshot: snapshot["getPublicKeysForTelephony"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "getPublicKeysForTelephony")
      }
    }

    public struct GetPublicKeysForTelephony: GraphQLSelectionSet {
      public static let possibleTypes = ["PaginatedPublicKey"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "PaginatedPublicKey", "items": items.map { $0.snapshot }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item] {
        get {
          return (snapshot["items"] as! [Snapshot]).map { Item(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["PublicKey"]

        public static let selections: [GraphQLSelection] = [
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

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(keyId: String, keyRingId: String, algorithm: String, publicKey: String, owner: GraphQLID, version: Int, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
          self.init(snapshot: ["__typename": "PublicKey", "keyId": keyId, "keyRingId": keyRingId, "algorithm": algorithm, "publicKey": publicKey, "owner": owner, "version": version, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var keyId: String {
          get {
            return snapshot["keyId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "keyId")
          }
        }

        public var keyRingId: String {
          get {
            return snapshot["keyRingId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "keyRingId")
          }
        }

        public var algorithm: String {
          get {
            return snapshot["algorithm"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "algorithm")
          }
        }

        public var publicKey: String {
          get {
            return snapshot["publicKey"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "publicKey")
          }
        }

        public var owner: GraphQLID {
          get {
            return snapshot["owner"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "owner")
          }
        }

        public var version: Int {
          get {
            return snapshot["version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "version")
          }
        }

        public var createdAtEpochMs: Double {
          get {
            return snapshot["createdAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
          }
        }

        public var updatedAtEpochMs: Double {
          get {
            return snapshot["updatedAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        public struct Fragments {
          public var snapshot: Snapshot

          public var publicKey: PublicKey {
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

public final class GetKeyRingQuery: GraphQLQuery {
  public static let operationString =
    "query getKeyRing($keyRingId: String!, $limit: Int, $nextToken: String) {\n  getKeyRingForTelephony(keyRingId: $keyRingId, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      ...publicKey\n    }\n    nextToken\n  }\n}"

  public static var requestString: String { return operationString.appending(PublicKey.fragmentString) }

  public var keyRingId: String
  public var limit: Int?
  public var nextToken: String?

  public init(keyRingId: String, limit: Int? = nil, nextToken: String? = nil) {
    self.keyRingId = keyRingId
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["keyRingId": keyRingId, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getKeyRingForTelephony", arguments: ["keyRingId": GraphQLVariable("keyRingId"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .nonNull(.object(GetKeyRingForTelephony.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getKeyRingForTelephony: GetKeyRingForTelephony) {
      self.init(snapshot: ["__typename": "Query", "getKeyRingForTelephony": getKeyRingForTelephony.snapshot])
    }

    public var getKeyRingForTelephony: GetKeyRingForTelephony {
      get {
        return GetKeyRingForTelephony(snapshot: snapshot["getKeyRingForTelephony"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "getKeyRingForTelephony")
      }
    }

    public struct GetKeyRingForTelephony: GraphQLSelectionSet {
      public static let possibleTypes = ["PaginatedPublicKey"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "PaginatedPublicKey", "items": items.map { $0.snapshot }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item] {
        get {
          return (snapshot["items"] as! [Snapshot]).map { Item(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["PublicKey"]

        public static let selections: [GraphQLSelection] = [
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

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(keyId: String, keyRingId: String, algorithm: String, publicKey: String, owner: GraphQLID, version: Int, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
          self.init(snapshot: ["__typename": "PublicKey", "keyId": keyId, "keyRingId": keyRingId, "algorithm": algorithm, "publicKey": publicKey, "owner": owner, "version": version, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var keyId: String {
          get {
            return snapshot["keyId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "keyId")
          }
        }

        public var keyRingId: String {
          get {
            return snapshot["keyRingId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "keyRingId")
          }
        }

        public var algorithm: String {
          get {
            return snapshot["algorithm"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "algorithm")
          }
        }

        public var publicKey: String {
          get {
            return snapshot["publicKey"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "publicKey")
          }
        }

        public var owner: GraphQLID {
          get {
            return snapshot["owner"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "owner")
          }
        }

        public var version: Int {
          get {
            return snapshot["version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "version")
          }
        }

        public var createdAtEpochMs: Double {
          get {
            return snapshot["createdAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
          }
        }

        public var updatedAtEpochMs: Double {
          get {
            return snapshot["updatedAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        public struct Fragments {
          public var snapshot: Snapshot

          public var publicKey: PublicKey {
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

public final class SendMessageMutation: GraphQLMutation {
  public static let operationString =
    "mutation sendMessage($input: SendMessageInput!) {\n  sendMessage(input: $input)\n}"

  public var input: SendMessageInput

  public init(input: SendMessageInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("sendMessage", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.scalar(GraphQLID.self))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(sendMessage: GraphQLID) {
      self.init(snapshot: ["__typename": "Mutation", "sendMessage": sendMessage])
    }

    /// Send SMS/MMS message.
    public var sendMessage: GraphQLID {
      get {
        return snapshot["sendMessage"]! as! GraphQLID
      }
      set {
        snapshot.updateValue(newValue, forKey: "sendMessage")
      }
    }
  }
}

public final class GetMessageQuery: GraphQLQuery {
  public static let operationString =
    "query getMessage($id: ID!, $keyId: String!) {\n  getMessage(id: $id, keyId: $keyId) {\n    __typename\n    ...sealedMessage\n  }\n}"

  public static var requestString: String { return operationString.appending(SealedMessage.fragmentString).appending(S3MediaObject.fragmentString) }

  public var id: GraphQLID
  public var keyId: String

  public init(id: GraphQLID, keyId: String) {
    self.id = id
    self.keyId = keyId
  }

  public var variables: GraphQLMap? {
    return ["id": id, "keyId": keyId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getMessage", arguments: ["id": GraphQLVariable("id"), "keyId": GraphQLVariable("keyId")], type: .object(GetMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getMessage: GetMessage? = nil) {
      self.init(snapshot: ["__typename": "Query", "getMessage": getMessage.flatMap { $0.snapshot }])
    }

    /// Get a message record by ID.
    public var getMessage: GetMessage? {
      get {
        return (snapshot["getMessage"] as? Snapshot).flatMap { GetMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getMessage")
      }
    }

    public struct GetMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["SealedMessage"]

      public static let selections: [GraphQLSelection] = [
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

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, conversation: GraphQLID, remotePhoneNumber: String, localPhoneNumber: String, body: String? = nil, media: [Medium]? = nil, direction: MessageDirection, seen: Bool, state: MessageState, owner: GraphQLID, algorithm: String, keyId: String, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "SealedMessage", "id": id, "conversation": conversation, "remotePhoneNumber": remotePhoneNumber, "localPhoneNumber": localPhoneNumber, "body": body, "media": media.flatMap { $0.map { $0.snapshot } }, "direction": direction, "seen": seen, "state": state, "owner": owner, "algorithm": algorithm, "keyId": keyId, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// UNSEALED: v4 UUID assigned to message record.
      public var id: GraphQLID {
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
      public var conversation: GraphQLID {
        get {
          return snapshot["conversation"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversation")
        }
      }

      /// SEALED: Remote phone number in E164 format.
      public var remotePhoneNumber: String {
        get {
          return snapshot["remotePhoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "remotePhoneNumber")
        }
      }

      /// SEALED: Sudo phone number in E164 format.
      public var localPhoneNumber: String {
        get {
          return snapshot["localPhoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "localPhoneNumber")
        }
      }

      /// SEALED: Message body, null if MMS only.
      public var body: String? {
        get {
          return snapshot["body"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "body")
        }
      }

      /// SEALED: MMS attachments.
      public var media: [Medium]? {
        get {
          return (snapshot["media"] as? [Snapshot]).flatMap { $0.map { Medium(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "media")
        }
      }

      /// UNSEALED: Direction of message.
      public var direction: MessageDirection {
        get {
          return snapshot["direction"]! as! MessageDirection
        }
        set {
          snapshot.updateValue(newValue, forKey: "direction")
        }
      }

      /// UNSEALED: Has this message been marked as seen on client.
      public var seen: Bool {
        get {
          return snapshot["seen"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "seen")
        }
      }

      /// UNSEALED: State of message record.
      public var state: MessageState {
        get {
          return snapshot["state"]! as! MessageState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// UNSEALED: v4 UUID of user that owns the message resource.
      public var owner: GraphQLID {
        get {
          return snapshot["owner"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      /// UNSEALED: Algorithm descriptor describing public and symmetric key encryption, e.g RSAEncryptionOAEPSHA256AESGCM.
      public var algorithm: String {
        get {
          return snapshot["algorithm"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "algorithm")
        }
      }

      /// UNSEALED: Client generated key ID for the public key.
      public var keyId: String {
        get {
          return snapshot["keyId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyId")
        }
      }

      /// UNSEALED: ID used for the client to subscribe to specific events.
      public var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// UNSEALED: Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      public var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// UNSEALED: Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      public var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var sealedMessage: SealedMessage {
          get {
            return SealedMessage(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      public struct Medium: GraphQLSelectionSet {
        public static let possibleTypes = ["S3MediaObject"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("key", type: .nonNull(.scalar(String.self))),
          GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
          GraphQLField("region", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(key: String, bucket: String, region: String) {
          self.init(snapshot: ["__typename": "S3MediaObject", "key": key, "bucket": bucket, "region": region])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Key of object in S3.
        public var key: String {
          get {
            return snapshot["key"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "key")
          }
        }

        /// Name of S3 bucket.
        public var bucket: String {
          get {
            return snapshot["bucket"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "bucket")
          }
        }

        /// Region S3 bucket is located in.
        public var region: String {
          get {
            return snapshot["region"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "region")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        public struct Fragments {
          public var snapshot: Snapshot

          public var s3MediaObject: S3MediaObject {
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

public final class DeleteMessageMutation: GraphQLMutation {
  public static let operationString =
    "mutation deleteMessage($id: ID!) {\n  deleteMessage(id: $id)\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteMessage", arguments: ["id": GraphQLVariable("id")], type: .scalar(GraphQLID.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteMessage: GraphQLID? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteMessage": deleteMessage])
    }

    /// Delete SMS/MMS message.
    public var deleteMessage: GraphQLID? {
      get {
        return snapshot["deleteMessage"] as? GraphQLID
      }
      set {
        snapshot.updateValue(newValue, forKey: "deleteMessage")
      }
    }
  }
}

public final class ListMessagesQuery: GraphQLQuery {
  public static let operationString =
    "query listMessages($filter: MessageFilterInput!, $limit: Int, $nextToken: String) {\n  listMessages(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      ...sealedMessage\n    }\n    nextToken\n  }\n}"

  public static var requestString: String { return operationString.appending(SealedMessage.fragmentString).appending(S3MediaObject.fragmentString) }

  public var filter: MessageFilterInput
  public var limit: Int?
  public var nextToken: String?

  public init(filter: MessageFilterInput, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listMessages", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listMessages: ListMessage? = nil) {
      self.init(snapshot: ["__typename": "Query", "listMessages": listMessages.flatMap { $0.snapshot }])
    }

    /// Returns a list of messages.
    public var listMessages: ListMessage? {
      get {
        return (snapshot["listMessages"] as? Snapshot).flatMap { ListMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listMessages")
      }
    }

    public struct ListMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["MessageConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .list(.nonNull(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item]? = nil, nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "MessageConnection", "items": items.flatMap { $0.map { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item]? {
        get {
          return (snapshot["items"] as? [Snapshot]).flatMap { $0.map { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["SealedMessage"]

        public static let selections: [GraphQLSelection] = [
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

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, conversation: GraphQLID, remotePhoneNumber: String, localPhoneNumber: String, body: String? = nil, media: [Medium]? = nil, direction: MessageDirection, seen: Bool, state: MessageState, owner: GraphQLID, algorithm: String, keyId: String, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
          self.init(snapshot: ["__typename": "SealedMessage", "id": id, "conversation": conversation, "remotePhoneNumber": remotePhoneNumber, "localPhoneNumber": localPhoneNumber, "body": body, "media": media.flatMap { $0.map { $0.snapshot } }, "direction": direction, "seen": seen, "state": state, "owner": owner, "algorithm": algorithm, "keyId": keyId, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// UNSEALED: v4 UUID assigned to message record.
        public var id: GraphQLID {
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
        public var conversation: GraphQLID {
          get {
            return snapshot["conversation"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "conversation")
          }
        }

        /// SEALED: Remote phone number in E164 format.
        public var remotePhoneNumber: String {
          get {
            return snapshot["remotePhoneNumber"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "remotePhoneNumber")
          }
        }

        /// SEALED: Sudo phone number in E164 format.
        public var localPhoneNumber: String {
          get {
            return snapshot["localPhoneNumber"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "localPhoneNumber")
          }
        }

        /// SEALED: Message body, null if MMS only.
        public var body: String? {
          get {
            return snapshot["body"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "body")
          }
        }

        /// SEALED: MMS attachments.
        public var media: [Medium]? {
          get {
            return (snapshot["media"] as? [Snapshot]).flatMap { $0.map { Medium(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "media")
          }
        }

        /// UNSEALED: Direction of message.
        public var direction: MessageDirection {
          get {
            return snapshot["direction"]! as! MessageDirection
          }
          set {
            snapshot.updateValue(newValue, forKey: "direction")
          }
        }

        /// UNSEALED: Has this message been marked as seen on client.
        public var seen: Bool {
          get {
            return snapshot["seen"]! as! Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "seen")
          }
        }

        /// UNSEALED: State of message record.
        public var state: MessageState {
          get {
            return snapshot["state"]! as! MessageState
          }
          set {
            snapshot.updateValue(newValue, forKey: "state")
          }
        }

        /// UNSEALED: v4 UUID of user that owns the message resource.
        public var owner: GraphQLID {
          get {
            return snapshot["owner"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "owner")
          }
        }

        /// UNSEALED: Algorithm descriptor describing public and symmetric key encryption, e.g RSAEncryptionOAEPSHA256AESGCM.
        public var algorithm: String {
          get {
            return snapshot["algorithm"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "algorithm")
          }
        }

        /// UNSEALED: Client generated key ID for the public key.
        public var keyId: String {
          get {
            return snapshot["keyId"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "keyId")
          }
        }

        /// UNSEALED: ID used for the client to subscribe to specific events.
        public var clientRefId: String? {
          get {
            return snapshot["clientRefId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "clientRefId")
          }
        }

        /// UNSEALED: Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
        public var createdAtEpochMs: Double {
          get {
            return snapshot["createdAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
          }
        }

        /// UNSEALED: Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
        public var updatedAtEpochMs: Double {
          get {
            return snapshot["updatedAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        public struct Fragments {
          public var snapshot: Snapshot

          public var sealedMessage: SealedMessage {
            get {
              return SealedMessage(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }
        }

        public struct Medium: GraphQLSelectionSet {
          public static let possibleTypes = ["S3MediaObject"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("key", type: .nonNull(.scalar(String.self))),
            GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
            GraphQLField("region", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(key: String, bucket: String, region: String) {
            self.init(snapshot: ["__typename": "S3MediaObject", "key": key, "bucket": bucket, "region": region])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Key of object in S3.
          public var key: String {
            get {
              return snapshot["key"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "key")
            }
          }

          /// Name of S3 bucket.
          public var bucket: String {
            get {
              return snapshot["bucket"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "bucket")
            }
          }

          /// Region S3 bucket is located in.
          public var region: String {
            get {
              return snapshot["region"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "region")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }

          public struct Fragments {
            public var snapshot: Snapshot

            public var s3MediaObject: S3MediaObject {
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

public final class OnMessageReceivedSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription onMessageReceived($owner: String!) {\n  OnMessage(owner: $owner) {\n    __typename\n    ...sealedMessage\n  }\n}"

  public static var requestString: String { return operationString.appending(SealedMessage.fragmentString).appending(S3MediaObject.fragmentString) }

  public var owner: String

  public init(owner: String) {
    self.owner = owner
  }

  public var variables: GraphQLMap? {
    return ["owner": owner]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("OnMessage", arguments: ["owner": GraphQLVariable("owner")], type: .object(OnMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onMessage: OnMessage? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "OnMessage": onMessage.flatMap { $0.snapshot }])
    }

    /// Owner id for the current logged in user.
    /// ID used for the client to subscribe to specific message events.
    public var onMessage: OnMessage? {
      get {
        return (snapshot["OnMessage"] as? Snapshot).flatMap { OnMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "OnMessage")
      }
    }

    public struct OnMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["SealedMessage"]

      public static let selections: [GraphQLSelection] = [
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

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, conversation: GraphQLID, remotePhoneNumber: String, localPhoneNumber: String, body: String? = nil, media: [Medium]? = nil, direction: MessageDirection, seen: Bool, state: MessageState, owner: GraphQLID, algorithm: String, keyId: String, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "SealedMessage", "id": id, "conversation": conversation, "remotePhoneNumber": remotePhoneNumber, "localPhoneNumber": localPhoneNumber, "body": body, "media": media.flatMap { $0.map { $0.snapshot } }, "direction": direction, "seen": seen, "state": state, "owner": owner, "algorithm": algorithm, "keyId": keyId, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// UNSEALED: v4 UUID assigned to message record.
      public var id: GraphQLID {
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
      public var conversation: GraphQLID {
        get {
          return snapshot["conversation"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversation")
        }
      }

      /// SEALED: Remote phone number in E164 format.
      public var remotePhoneNumber: String {
        get {
          return snapshot["remotePhoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "remotePhoneNumber")
        }
      }

      /// SEALED: Sudo phone number in E164 format.
      public var localPhoneNumber: String {
        get {
          return snapshot["localPhoneNumber"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "localPhoneNumber")
        }
      }

      /// SEALED: Message body, null if MMS only.
      public var body: String? {
        get {
          return snapshot["body"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "body")
        }
      }

      /// SEALED: MMS attachments.
      public var media: [Medium]? {
        get {
          return (snapshot["media"] as? [Snapshot]).flatMap { $0.map { Medium(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "media")
        }
      }

      /// UNSEALED: Direction of message.
      public var direction: MessageDirection {
        get {
          return snapshot["direction"]! as! MessageDirection
        }
        set {
          snapshot.updateValue(newValue, forKey: "direction")
        }
      }

      /// UNSEALED: Has this message been marked as seen on client.
      public var seen: Bool {
        get {
          return snapshot["seen"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "seen")
        }
      }

      /// UNSEALED: State of message record.
      public var state: MessageState {
        get {
          return snapshot["state"]! as! MessageState
        }
        set {
          snapshot.updateValue(newValue, forKey: "state")
        }
      }

      /// UNSEALED: v4 UUID of user that owns the message resource.
      public var owner: GraphQLID {
        get {
          return snapshot["owner"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      /// UNSEALED: Algorithm descriptor describing public and symmetric key encryption, e.g RSAEncryptionOAEPSHA256AESGCM.
      public var algorithm: String {
        get {
          return snapshot["algorithm"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "algorithm")
        }
      }

      /// UNSEALED: Client generated key ID for the public key.
      public var keyId: String {
        get {
          return snapshot["keyId"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "keyId")
        }
      }

      /// UNSEALED: ID used for the client to subscribe to specific events.
      public var clientRefId: String? {
        get {
          return snapshot["clientRefId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientRefId")
        }
      }

      /// UNSEALED: Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      public var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// UNSEALED: Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      public var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var sealedMessage: SealedMessage {
          get {
            return SealedMessage(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      public struct Medium: GraphQLSelectionSet {
        public static let possibleTypes = ["S3MediaObject"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("key", type: .nonNull(.scalar(String.self))),
          GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
          GraphQLField("region", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(key: String, bucket: String, region: String) {
          self.init(snapshot: ["__typename": "S3MediaObject", "key": key, "bucket": bucket, "region": region])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Key of object in S3.
        public var key: String {
          get {
            return snapshot["key"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "key")
          }
        }

        /// Name of S3 bucket.
        public var bucket: String {
          get {
            return snapshot["bucket"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "bucket")
          }
        }

        /// Region S3 bucket is located in.
        public var region: String {
          get {
            return snapshot["region"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "region")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        public struct Fragments {
          public var snapshot: Snapshot

          public var s3MediaObject: S3MediaObject {
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

public final class GetConversationQuery: GraphQLQuery {
  public static let operationString =
    "query getConversation($id: ID!) {\n  getConversation(id: $id) {\n    __typename\n    ...conversation\n  }\n}"

  public static var requestString: String { return operationString.appending(Conversation.fragmentString) }

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getConversation", arguments: ["id": GraphQLVariable("id")], type: .object(GetConversation.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getConversation: GetConversation? = nil) {
      self.init(snapshot: ["__typename": "Query", "getConversation": getConversation.flatMap { $0.snapshot }])
    }

    /// Get a conversation record by ID.
    public var getConversation: GetConversation? {
      get {
        return (snapshot["getConversation"] as? Snapshot).flatMap { GetConversation(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getConversation")
      }
    }

    public struct GetConversation: GraphQLSelectionSet {
      public static let possibleTypes = ["Conversation"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("owner", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(ConversationType.self))),
        GraphQLField("lastMessage", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
        GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, owner: GraphQLID, type: ConversationType, lastMessage: GraphQLID, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
        self.init(snapshot: ["__typename": "Conversation", "id": id, "owner": owner, "type": type, "lastMessage": lastMessage, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
      }

      public var __typename: String {
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
      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      /// v4 UUID of user that owns the conversation resource.
      public var owner: GraphQLID {
        get {
          return snapshot["owner"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      /// Type for this conversation.
      public var type: ConversationType {
        get {
          return snapshot["type"]! as! ConversationType
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      /// v4 UUID of last message, can be used to display preview in message feed.
      public var lastMessage: GraphQLID {
        get {
          return snapshot["lastMessage"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastMessage")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
      public var createdAtEpochMs: Double {
        get {
          return snapshot["createdAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
        }
      }

      /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
      public var updatedAtEpochMs: Double {
        get {
          return snapshot["updatedAtEpochMs"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var conversation: Conversation {
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

public final class ListConversationsQuery: GraphQLQuery {
  public static let operationString =
    "query listConversations($filter: ConversationFilterInput!, $limit: Int, $nextToken: String) {\n  listConversations(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      ...conversation\n    }\n    nextToken\n  }\n}"

  public static var requestString: String { return operationString.appending(Conversation.fragmentString) }

  public var filter: ConversationFilterInput
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ConversationFilterInput, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listConversations", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListConversation.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listConversations: ListConversation? = nil) {
      self.init(snapshot: ["__typename": "Query", "listConversations": listConversations.flatMap { $0.snapshot }])
    }

    /// Returns a list of message conversations.
    public var listConversations: ListConversation? {
      get {
        return (snapshot["listConversations"] as? Snapshot).flatMap { ListConversation(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listConversations")
      }
    }

    public struct ListConversation: GraphQLSelectionSet {
      public static let possibleTypes = ["ConversationConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .list(.nonNull(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item]? = nil, nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ConversationConnection", "items": items.flatMap { $0.map { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item]? {
        get {
          return (snapshot["items"] as? [Snapshot]).flatMap { $0.map { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Conversation"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("owner", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(ConversationType.self))),
          GraphQLField("lastMessage", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
          GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, owner: GraphQLID, type: ConversationType, lastMessage: GraphQLID, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
          self.init(snapshot: ["__typename": "Conversation", "id": id, "owner": owner, "type": type, "lastMessage": lastMessage, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
        }

        public var __typename: String {
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
        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        /// v4 UUID of user that owns the conversation resource.
        public var owner: GraphQLID {
          get {
            return snapshot["owner"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "owner")
          }
        }

        /// Type for this conversation.
        public var type: ConversationType {
          get {
            return snapshot["type"]! as! ConversationType
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        /// v4 UUID of last message, can be used to display preview in message feed.
        public var lastMessage: GraphQLID {
          get {
            return snapshot["lastMessage"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastMessage")
          }
        }

        /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
        public var createdAtEpochMs: Double {
          get {
            return snapshot["createdAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
          }
        }

        /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
        public var updatedAtEpochMs: Double {
          get {
            return snapshot["updatedAtEpochMs"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        public struct Fragments {
          public var snapshot: Snapshot

          public var conversation: Conversation {
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

public struct SudoPhoneNumber: GraphQLFragment {
  public static let fragmentString =
    "fragment SudoPhoneNumber on PhoneNumber {\n  __typename\n  id\n  phoneNumber\n  country\n  keyRingId\n  state\n  version\n  clientRefId\n  createdAtEpochMs\n  updatedAtEpochMs\n}"

  public static let possibleTypes = ["PhoneNumber"]

  public static let selections: [GraphQLSelection] = [
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

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public init(id: GraphQLID, phoneNumber: String, country: String, keyRingId: String, state: PhoneNumberState, version: Int, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
    self.init(snapshot: ["__typename": "PhoneNumber", "id": id, "phoneNumber": phoneNumber, "country": country, "keyRingId": keyRingId, "state": state, "version": version, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
  }

  public var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  /// v4 UUID of phone number record.
  public var id: GraphQLID {
    get {
      return snapshot["id"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "id")
    }
  }

  /// E164 formatted phone number.
  public var phoneNumber: String {
    get {
      return snapshot["phoneNumber"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "phoneNumber")
    }
  }

  /// ISO country code of phone number e.g. 'US' 'ZZ'.
  public var country: String {
    get {
      return snapshot["country"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "country")
    }
  }

  /// Key ring ID that dictates which keys the child resources of this phone number will be encrypted with.
  public var keyRingId: String {
    get {
      return snapshot["keyRingId"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "keyRingId")
    }
  }

  /// State of phone number.
  public var state: PhoneNumberState {
    get {
      return snapshot["state"]! as! PhoneNumberState
    }
    set {
      snapshot.updateValue(newValue, forKey: "state")
    }
  }

  /// Version of this phone number record, increments on update.
  public var version: Int {
    get {
      return snapshot["version"]! as! Int
    }
    set {
      snapshot.updateValue(newValue, forKey: "version")
    }
  }

  /// ID used for the client to subscribe to specific events.
  public var clientRefId: String? {
    get {
      return snapshot["clientRefId"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "clientRefId")
    }
  }

  /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
  public var createdAtEpochMs: Double {
    get {
      return snapshot["createdAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
    }
  }

  /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
  public var updatedAtEpochMs: Double {
    get {
      return snapshot["updatedAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
    }
  }
}

public struct SudoAvailablePhoneNumberResult: GraphQLFragment {
  public static let fragmentString =
    "fragment SudoAvailablePhoneNumberResult on PhoneNumberSearch {\n  __typename\n  id\n  country\n  gps {\n    __typename\n    latitude\n    longitude\n  }\n  prefix\n  state\n  results\n  clientRefId\n  createdAtEpochMs\n  updatedAtEpochMs\n}"

  public static let possibleTypes = ["PhoneNumberSearch"]

  public static let selections: [GraphQLSelection] = [
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

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public init(id: GraphQLID, country: String, gps: Gp? = nil, `prefix`: String? = nil, state: PhoneNumberSearchState, results: [String]? = nil, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
    self.init(snapshot: ["__typename": "PhoneNumberSearch", "id": id, "country": country, "gps": gps.flatMap { $0.snapshot }, "prefix": `prefix`, "state": state, "results": results, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
  }

  public var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  /// v4 UUID assigned to the phone number search.
  public var id: GraphQLID {
    get {
      return snapshot["id"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "id")
    }
  }

  /// ISO country code of phone number e.g. 'US' 'ZZ'.
  public var country: String {
    get {
      return snapshot["country"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "country")
    }
  }

  /// GPS coordinates to scope phone number search.
  public var gps: Gp? {
    get {
      return (snapshot["gps"] as? Snapshot).flatMap { Gp(snapshot: $0) }
    }
    set {
      snapshot.updateValue(newValue?.snapshot, forKey: "gps")
    }
  }

  /// Area code of phone number e.g. 801, 555.
  public var `prefix`: String? {
    get {
      return snapshot["prefix"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "prefix")
    }
  }

  /// Current state of phone number search request.
  public var state: PhoneNumberSearchState {
    get {
      return snapshot["state"]! as! PhoneNumberSearchState
    }
    set {
      snapshot.updateValue(newValue, forKey: "state")
    }
  }

  /// Array of available phone numbers.
  public var results: [String]? {
    get {
      return snapshot["results"] as? [String]
    }
    set {
      snapshot.updateValue(newValue, forKey: "results")
    }
  }

  /// ID used for the client to subscribe to specific events.
  public var clientRefId: String? {
    get {
      return snapshot["clientRefId"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "clientRefId")
    }
  }

  /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
  public var createdAtEpochMs: Double {
    get {
      return snapshot["createdAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
    }
  }

  /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
  public var updatedAtEpochMs: Double {
    get {
      return snapshot["updatedAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
    }
  }

  public struct Gp: GraphQLSelectionSet {
    public static let possibleTypes = ["GpsCoordinates"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("latitude", type: .nonNull(.scalar(String.self))),
      GraphQLField("longitude", type: .nonNull(.scalar(String.self))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(latitude: String, longitude: String) {
      self.init(snapshot: ["__typename": "GpsCoordinates", "latitude": latitude, "longitude": longitude])
    }

    public var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    public var latitude: String {
      get {
        return snapshot["latitude"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "latitude")
      }
    }

    public var longitude: String {
      get {
        return snapshot["longitude"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "longitude")
      }
    }
  }
}

public struct PublicKey: GraphQLFragment {
  public static let fragmentString =
    "fragment publicKey on PublicKey {\n  __typename\n  keyId\n  keyRingId\n  algorithm\n  publicKey\n  owner\n  version\n  createdAtEpochMs\n  updatedAtEpochMs\n}"

  public static let possibleTypes = ["PublicKey"]

  public static let selections: [GraphQLSelection] = [
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

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public init(keyId: String, keyRingId: String, algorithm: String, publicKey: String, owner: GraphQLID, version: Int, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
    self.init(snapshot: ["__typename": "PublicKey", "keyId": keyId, "keyRingId": keyRingId, "algorithm": algorithm, "publicKey": publicKey, "owner": owner, "version": version, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
  }

  public var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  public var keyId: String {
    get {
      return snapshot["keyId"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "keyId")
    }
  }

  public var keyRingId: String {
    get {
      return snapshot["keyRingId"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "keyRingId")
    }
  }

  public var algorithm: String {
    get {
      return snapshot["algorithm"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "algorithm")
    }
  }

  public var publicKey: String {
    get {
      return snapshot["publicKey"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "publicKey")
    }
  }

  public var owner: GraphQLID {
    get {
      return snapshot["owner"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "owner")
    }
  }

  public var version: Int {
    get {
      return snapshot["version"]! as! Int
    }
    set {
      snapshot.updateValue(newValue, forKey: "version")
    }
  }

  public var createdAtEpochMs: Double {
    get {
      return snapshot["createdAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
    }
  }

  public var updatedAtEpochMs: Double {
    get {
      return snapshot["updatedAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
    }
  }
}

public struct SealedMessage: GraphQLFragment {
  public static let fragmentString =
    "fragment sealedMessage on SealedMessage {\n  __typename\n  id\n  conversation\n  remotePhoneNumber\n  localPhoneNumber\n  body\n  media {\n    __typename\n    ...s3MediaObject\n  }\n  direction\n  seen\n  state\n  owner\n  algorithm\n  keyId\n  clientRefId\n  createdAtEpochMs\n  updatedAtEpochMs\n}"

  public static let possibleTypes = ["SealedMessage"]

  public static let selections: [GraphQLSelection] = [
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

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public init(id: GraphQLID, conversation: GraphQLID, remotePhoneNumber: String, localPhoneNumber: String, body: String? = nil, media: [Medium]? = nil, direction: MessageDirection, seen: Bool, state: MessageState, owner: GraphQLID, algorithm: String, keyId: String, clientRefId: String? = nil, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
    self.init(snapshot: ["__typename": "SealedMessage", "id": id, "conversation": conversation, "remotePhoneNumber": remotePhoneNumber, "localPhoneNumber": localPhoneNumber, "body": body, "media": media.flatMap { $0.map { $0.snapshot } }, "direction": direction, "seen": seen, "state": state, "owner": owner, "algorithm": algorithm, "keyId": keyId, "clientRefId": clientRefId, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
  }

  public var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  /// UNSEALED: v4 UUID assigned to message record.
  public var id: GraphQLID {
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
  public var conversation: GraphQLID {
    get {
      return snapshot["conversation"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "conversation")
    }
  }

  /// SEALED: Remote phone number in E164 format.
  public var remotePhoneNumber: String {
    get {
      return snapshot["remotePhoneNumber"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "remotePhoneNumber")
    }
  }

  /// SEALED: Sudo phone number in E164 format.
  public var localPhoneNumber: String {
    get {
      return snapshot["localPhoneNumber"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "localPhoneNumber")
    }
  }

  /// SEALED: Message body, null if MMS only.
  public var body: String? {
    get {
      return snapshot["body"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "body")
    }
  }

  /// SEALED: MMS attachments.
  public var media: [Medium]? {
    get {
      return (snapshot["media"] as? [Snapshot]).flatMap { $0.map { Medium(snapshot: $0) } }
    }
    set {
      snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "media")
    }
  }

  /// UNSEALED: Direction of message.
  public var direction: MessageDirection {
    get {
      return snapshot["direction"]! as! MessageDirection
    }
    set {
      snapshot.updateValue(newValue, forKey: "direction")
    }
  }

  /// UNSEALED: Has this message been marked as seen on client.
  public var seen: Bool {
    get {
      return snapshot["seen"]! as! Bool
    }
    set {
      snapshot.updateValue(newValue, forKey: "seen")
    }
  }

  /// UNSEALED: State of message record.
  public var state: MessageState {
    get {
      return snapshot["state"]! as! MessageState
    }
    set {
      snapshot.updateValue(newValue, forKey: "state")
    }
  }

  /// UNSEALED: v4 UUID of user that owns the message resource.
  public var owner: GraphQLID {
    get {
      return snapshot["owner"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "owner")
    }
  }

  /// UNSEALED: Algorithm descriptor describing public and symmetric key encryption, e.g RSAEncryptionOAEPSHA256AESGCM.
  public var algorithm: String {
    get {
      return snapshot["algorithm"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "algorithm")
    }
  }

  /// UNSEALED: Client generated key ID for the public key.
  public var keyId: String {
    get {
      return snapshot["keyId"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "keyId")
    }
  }

  /// UNSEALED: ID used for the client to subscribe to specific events.
  public var clientRefId: String? {
    get {
      return snapshot["clientRefId"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "clientRefId")
    }
  }

  /// UNSEALED: Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
  public var createdAtEpochMs: Double {
    get {
      return snapshot["createdAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
    }
  }

  /// UNSEALED: Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
  public var updatedAtEpochMs: Double {
    get {
      return snapshot["updatedAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
    }
  }

  public struct Medium: GraphQLSelectionSet {
    public static let possibleTypes = ["S3MediaObject"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("key", type: .nonNull(.scalar(String.self))),
      GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
      GraphQLField("region", type: .nonNull(.scalar(String.self))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(key: String, bucket: String, region: String) {
      self.init(snapshot: ["__typename": "S3MediaObject", "key": key, "bucket": bucket, "region": region])
    }

    public var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    /// Key of object in S3.
    public var key: String {
      get {
        return snapshot["key"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "key")
      }
    }

    /// Name of S3 bucket.
    public var bucket: String {
      get {
        return snapshot["bucket"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "bucket")
      }
    }

    /// Region S3 bucket is located in.
    public var region: String {
      get {
        return snapshot["region"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "region")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(snapshot: snapshot)
      }
      set {
        snapshot += newValue.snapshot
      }
    }

    public struct Fragments {
      public var snapshot: Snapshot

      public var s3MediaObject: S3MediaObject {
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

public struct Conversation: GraphQLFragment {
  public static let fragmentString =
    "fragment conversation on Conversation {\n  __typename\n  id\n  owner\n  type\n  lastMessage\n  createdAtEpochMs\n  updatedAtEpochMs\n}"

  public static let possibleTypes = ["Conversation"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("owner", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("type", type: .nonNull(.scalar(ConversationType.self))),
    GraphQLField("lastMessage", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("createdAtEpochMs", type: .nonNull(.scalar(Double.self))),
    GraphQLField("updatedAtEpochMs", type: .nonNull(.scalar(Double.self))),
  ]

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public init(id: GraphQLID, owner: GraphQLID, type: ConversationType, lastMessage: GraphQLID, createdAtEpochMs: Double, updatedAtEpochMs: Double) {
    self.init(snapshot: ["__typename": "Conversation", "id": id, "owner": owner, "type": type, "lastMessage": lastMessage, "createdAtEpochMs": createdAtEpochMs, "updatedAtEpochMs": updatedAtEpochMs])
  }

  public var __typename: String {
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
  public var id: GraphQLID {
    get {
      return snapshot["id"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "id")
    }
  }

  /// v4 UUID of user that owns the conversation resource.
  public var owner: GraphQLID {
    get {
      return snapshot["owner"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "owner")
    }
  }

  /// Type for this conversation.
  public var type: ConversationType {
    get {
      return snapshot["type"]! as! ConversationType
    }
    set {
      snapshot.updateValue(newValue, forKey: "type")
    }
  }

  /// v4 UUID of last message, can be used to display preview in message feed.
  public var lastMessage: GraphQLID {
    get {
      return snapshot["lastMessage"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "lastMessage")
    }
  }

  /// Time in milliseconds since 1970-01-01T00:00:00Z when object was created.
  public var createdAtEpochMs: Double {
    get {
      return snapshot["createdAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "createdAtEpochMs")
    }
  }

  /// Time in milliseconds since 1970-01-01T00:00:00Z when object was last updated.
  public var updatedAtEpochMs: Double {
    get {
      return snapshot["updatedAtEpochMs"]! as! Double
    }
    set {
      snapshot.updateValue(newValue, forKey: "updatedAtEpochMs")
    }
  }
}

public struct S3MediaObject: GraphQLFragment {
  public static let fragmentString =
    "fragment s3MediaObject on S3MediaObject {\n  __typename\n  key\n  bucket\n  region\n}"

  public static let possibleTypes = ["S3MediaObject"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("key", type: .nonNull(.scalar(String.self))),
    GraphQLField("bucket", type: .nonNull(.scalar(String.self))),
    GraphQLField("region", type: .nonNull(.scalar(String.self))),
  ]

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public init(key: String, bucket: String, region: String) {
    self.init(snapshot: ["__typename": "S3MediaObject", "key": key, "bucket": bucket, "region": region])
  }

  public var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  /// Key of object in S3.
  public var key: String {
    get {
      return snapshot["key"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "key")
    }
  }

  /// Name of S3 bucket.
  public var bucket: String {
    get {
      return snapshot["bucket"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "bucket")
    }
  }

  /// Region S3 bucket is located in.
  public var region: String {
    get {
      return snapshot["region"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "region")
    }
  }
}