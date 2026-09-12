import Primitives

public extension Recovery {
    struct Action: StringIdentifier {
        public let rawValue: String

        public init(
            rawValue: String
        ) {
            self.rawValue = rawValue
        }
    }
}

public extension Recovery.Action {
    static let retry_same_operation = Self(
        rawValue: "retry_same_operation"
    )
    static let wait_then_retry = Self(
        rawValue: "wait_then_retry"
    )
    static let fallback_equivalent = Self(
        rawValue: "fallback_equivalent"
    )
    static let repair_output = Self(
        rawValue: "repair_output"
    )
    static let reconcile = Self(
        rawValue: "reconcile"
    )
    static let suspend = Self(
        rawValue: "suspend"
    )
    static let invoke_authored_handler = Self(
        rawValue: "invoke_authored_handler"
    )
    static let propagate = Self(
        rawValue: "propagate"
    )
    static let abort = Self(
        rawValue: "abort"
    )
}
