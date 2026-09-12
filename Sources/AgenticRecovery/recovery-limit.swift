public extension Recovery {
    struct Limit:
        Sendable,
        Codable,
        Hashable
    {
        public let maximumAttempts: UInt

        public init(
            maximumAttempts: UInt
        ) {
            self.maximumAttempts = maximumAttempts
        }

        public func allows(
            attemptNumber: UInt
        ) -> Bool {
            attemptNumber > 0
                && attemptNumber <= maximumAttempts
        }

        public static let once = Self(
            maximumAttempts: 1
        )
    }
}
