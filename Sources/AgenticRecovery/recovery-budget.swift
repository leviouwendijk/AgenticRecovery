public extension Recovery {
    struct Budget:
        Sendable,
        Codable,
        Hashable
    {
        public struct Usage:
            Sendable,
            Codable,
            Hashable
        {
            public let incidentAttempts: UInt
            public let scopeAttempts: UInt
            public let totalAttempts: UInt

            public init(
                incidentAttempts: UInt,
                scopeAttempts: UInt,
                totalAttempts: UInt
            ) {
                self.incidentAttempts = incidentAttempts
                self.scopeAttempts = scopeAttempts
                self.totalAttempts = totalAttempts
            }
        }

        public let perIncident: UInt?
        public let perScope: UInt?
        public let total: UInt?

        public init(
            perIncident: UInt? = nil,
            perScope: UInt? = nil,
            total: UInt? = nil
        ) {
            self.perIncident = perIncident
            self.perScope = perScope
            self.total = total
        }

        /// Returns whether another recovery attempt may be consumed.
        ///
        /// Usage represents attempts already consumed at each level.
        public func allowsNextAttempt(
            after usage: Usage
        ) -> Bool {
            if let perIncident,
               usage.incidentAttempts >= perIncident
            {
                return false
            }

            if let perScope,
               usage.scopeAttempts >= perScope
            {
                return false
            }

            if let total,
               usage.totalAttempts >= total
            {
                return false
            }

            return true
        }

        public static let unlimited = Self()
    }
}
