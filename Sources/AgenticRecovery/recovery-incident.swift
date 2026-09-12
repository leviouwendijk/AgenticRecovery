public extension Recovery {
    struct Incident:
        Sendable,
        Codable,
        Hashable
    {
        public let kind: Kind
        public let stage: Stage
        public let effectState: EffectState
        public let retrySafety: RetrySafety
        public let scope: Scope
        public let message: String
        public let metadata: [String: String]

        public init(
            kind: Kind,
            stage: Stage,
            effectState: EffectState,
            retrySafety: RetrySafety,
            scope: Scope,
            message: String,
            metadata: [String: String] = [:]
        ) {
            self.kind = kind
            self.stage = stage
            self.effectState = effectState
            self.retrySafety = retrySafety
            self.scope = scope
            self.message = message
            self.metadata = metadata
        }
    }
}
