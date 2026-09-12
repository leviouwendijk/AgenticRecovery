public extension Recovery {
    struct Attempt:
        Sendable,
        Codable,
        Hashable
    {
        /// One-based attempt number within the selected recovery step.
        public let number: UInt
        public let action: Action
        public let outcome: Outcome
        public let message: String?

        public init(
            number: UInt,
            action: Action,
            outcome: Outcome,
            message: String? = nil
        ) {
            self.number = number
            self.action = action
            self.outcome = outcome
            self.message = message
        }
    }
}
