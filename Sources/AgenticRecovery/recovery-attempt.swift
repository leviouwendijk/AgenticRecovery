import Errors

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
        public let report: ErrorReport?

        public init(
            number: UInt,
            action: Action,
            outcome: Outcome,
            message: String? = nil,
            report: ErrorReport? = nil
        ) {
            self.number = number
            self.action = action
            self.outcome = outcome
            self.message = message
            self.report = report
        }

        public init(
            capturing error: any Error,
            number: UInt,
            action: Action,
            outcome: Outcome = .failed,
            message: String? = nil
        ) {
            let report = error.report

            self.init(
                number: number,
                action: action,
                outcome: outcome,
                message: message
                    ?? report.presentation.message,
                report: report
            )
        }
    }
}
