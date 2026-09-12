public extension Recovery {
    struct Policy:
        Sendable,
        Codable,
        Hashable
    {
        public struct Rule:
            Sendable,
            Codable,
            Hashable
        {
            public let kind: Kind
            public let stage: Stage?
            public let plan: Plan

            public init(
                kind: Kind,
                stage: Stage? = nil,
                plan: Plan
            ) {
                self.kind = kind
                self.stage = stage
                self.plan = plan
            }
        }

        public let rules: [Rule]

        public init(
            rules: [Rule] = []
        ) {
            self.rules = rules
        }

        public func plan(
            for incident: Incident
        ) -> Plan? {
            if let exact = rules.first(where: {
                $0.kind == incident.kind
                    && $0.stage == incident.stage
            }) {
                return exact.plan
            }

            return rules.first(where: {
                $0.kind == incident.kind
                    && $0.stage == nil
            })?.plan
        }
    }
}
