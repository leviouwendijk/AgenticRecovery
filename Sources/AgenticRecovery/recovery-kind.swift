import Primitives

public extension Recovery {
    struct Kind: StringIdentifier {
        public let rawValue: String

        public init(
            rawValue: String
        ) {
            self.rawValue = rawValue
        }
    }
}

public extension Recovery.Kind {
    static let transport_transient = Self(
        rawValue: "transport_transient"
    )
    static let rate_limited = Self(
        rawValue: "rate_limited"
    )
    static let route_unavailable = Self(
        rawValue: "route_unavailable"
    )
    static let structured_output_invalid = Self(
        rawValue: "structured_output_invalid"
    )
    static let validation_failed = Self(
        rawValue: "validation_failed"
    )
    static let authorization_required = Self(
        rawValue: "authorization_required"
    )
    static let precondition_failed = Self(
        rawValue: "precondition_failed"
    )
    static let conflict = Self(
        rawValue: "conflict"
    )
    static let outcome_unknown = Self(
        rawValue: "outcome_unknown"
    )
    static let cancelled = Self(
        rawValue: "cancelled"
    )
    static let invariant_violation = Self(
        rawValue: "invariant_violation"
    )
}
