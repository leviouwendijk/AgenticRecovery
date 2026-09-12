public extension Recovery {
    struct Record:
        Sendable,
        Codable,
        Hashable
    {
        public let incident: Incident
        public let plan: Plan?
        public let attempts: [Attempt]
        public let outcome: Outcome

        public init(
            incident: Incident,
            plan: Plan?,
            attempts: [Attempt],
            outcome: Outcome
        ) {
            self.incident = incident
            self.plan = plan
            self.attempts = attempts
            self.outcome = outcome
        }
    }
}
