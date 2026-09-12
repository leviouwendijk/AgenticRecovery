import AgenticRecovery
import Foundation
import TestFlows

let recoverySemanticFlows: [TestFlow] = [
    TestFlow(
        "recovery-incident-semantics",
        tags: [
            "agentic-recovery",
            "incident",
            "effects",
            "retry-safety",
        ]
    ) {
        let safe = Recovery.Incident(
            kind: .transport_transient,
            stage: .execution,
            effectState: .not_applied,
            retrySafety: .safe,
            scope: .init(
                kind: .inference,
                identifier: "classify-intent"
            ),
            message: "transport ended before a response was received",
            metadata: [
                "provider": "fixture",
            ]
        )

        let uncertain = Recovery.Incident(
            kind: .transport_transient,
            stage: .execution,
            effectState: .unknown,
            retrySafety: .requires_reconciliation,
            scope: .init(
                kind: .tool,
                identifier: "mutation-call"
            ),
            message: "transport ended after dispatch"
        )

        try Expect.equal(
            safe.effectState,
            .not_applied,
            "definitely unapplied work preserves effect certainty"
        )
        try Expect.equal(
            safe.retrySafety,
            .safe,
            "definitely unapplied work may be marked safe to retry"
        )
        try Expect.equal(
            safe.scope.kind,
            .inference,
            "recovery scopes remain generic but typed"
        )
        try Expect.equal(
            uncertain.effectState,
            .unknown,
            "uncertain mutation effects remain explicit"
        )
        try Expect.equal(
            uncertain.retrySafety,
            .requires_reconciliation,
            "unknown mutation effects can require reconciliation"
        )

        return [
            .field(
                "safe_effect",
                safe.effectState.rawValue
            ),
            .field(
                "uncertain_effect",
                uncertain.effectState.rawValue
            ),
            .field(
                "uncertain_retry",
                uncertain.retrySafety.rawValue
            ),
        ]
    },
    TestFlow(
        "recovery-policy-resolution",
        tags: [
            "agentic-recovery",
            "policy",
            "plan",
            "limits",
        ]
    ) {
        let genericPlan = Recovery.Plan(
            steps: [
                .init(
                    action: .propagate,
                    limit: .once
                ),
            ]
        )
        let decodingPlan = Recovery.Plan(
            steps: [
                .init(
                    action: .repair_output,
                    limit: .init(
                        maximumAttempts: 2
                    )
                ),
                .init(
                    action: .propagate,
                    limit: .once
                ),
            ]
        )
        let policy = Recovery.Policy(
            rules: [
                .init(
                    match: .init(
                        kind: .structured_output_invalid
                    ),
                    plan: genericPlan
                ),
                .init(
                    match: .init(
                        kind: .structured_output_invalid,
                        stage: .decoding
                    ),
                    plan: decodingPlan
                ),
            ]
        )
        let incident = Recovery.Incident(
            kind: .structured_output_invalid,
            stage: .decoding,
            effectState: .none,
            retrySafety: .safe,
            scope: .init(
                kind: .inference,
                identifier: "structured-probe"
            ),
            message: "model output did not decode"
        )

        let selected = try Expect.notNil(
            policy.plan(
                for: incident
            ),
            "stage-specific recovery rule resolves before generic rule"
        )
        let first = try Expect.notNil(
            selected.steps.first,
            "resolved plan retains its first recovery step"
        )

        try Expect.equal(
            first.action,
            .repair_output,
            "decoding failures select output repair"
        )
        try Expect.equal(
            first.limit.maximumAttempts,
            2,
            "recovery attempts remain independently bounded"
        )
        try Expect.equal(
            first.limit.allows(
                attemptNumber: 2
            ),
            true,
            "limit accepts its final permitted attempt"
        )
        try Expect.equal(
            first.limit.allows(
                attemptNumber: 3
            ),
            false,
            "limit rejects attempts beyond its bound"
        )

        return [
            .field(
                "action",
                first.action.rawValue
            ),
            .field(
                "maximum_attempts",
                String(first.limit.maximumAttempts)
            ),
        ]
    },
    TestFlow(
        "recovery-record-codable",
        tags: [
            "agentic-recovery",
            "record",
            "attempt",
            "codable",
        ]
    ) {
        let incident = Recovery.Incident(
            kind: .rate_limited,
            stage: .execution,
            effectState: .none,
            retrySafety: .safe,
            scope: .init(
                kind: .adapter,
                identifier: "fixture-model"
            ),
            message: "provider requested retry"
        )
        let plan = Recovery.Plan(
            steps: [
                .init(
                    action: .wait_then_retry,
                    limit: .init(
                        maximumAttempts: 2
                    )
                ),
            ]
        )
        let record = Recovery.Record(
            incident: incident,
            plan: plan,
            attempts: [
                .init(
                    number: 1,
                    action: .wait_then_retry,
                    outcome: .failed,
                    message: "provider remained rate limited"
                ),
                .init(
                    number: 2,
                    action: .wait_then_retry,
                    outcome: .recovered
                ),
            ],
            outcome: .recovered
        )

        let persisted = try JSONDecoder().decode(
            Recovery.Record.self,
            from: JSONEncoder().encode(
                record
            )
        )

        try Expect.equal(
            persisted,
            record,
            "recovery records round-trip as durable semantic values"
        )
        try Expect.equal(
            persisted.attempts.count,
            2,
            "recovery attempts remain separate from semantic operation attempts"
        )

        return [
            .field(
                "kind",
                persisted.incident.kind.rawValue
            ),
            .field(
                "attempts",
                String(persisted.attempts.count)
            ),
            .field(
                "outcome",
                persisted.outcome.rawValue
            ),
        ]
    },
]
