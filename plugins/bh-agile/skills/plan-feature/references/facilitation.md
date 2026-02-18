# Facilitate & Verify

**Active coordination, not passive waiting.** The lead's role during parallel expert work.

## During Expert Work

- **Relay contract changes**: If an expert messages the lead requesting a contract deviation, evaluate the change, update the contract, and notify all affected experts
- **Unblock**: If an expert is waiting on a decision, make the call or escalate to the user
- **Track progress**: Check TaskList periodically to monitor completion

## Pre-Completion Contract Verification

Before accepting an expert's "done" status, verify their output against contracts:

1. **Terminology check**: Do they use the same terms as defined in Shared Definitions?
2. **Interface alignment**: Does their "Contract You Produce" output match the format agreed upon?
3. **No silent deviations**: Did they change anything without requesting approval?
4. **Cross-cutting coverage**: Did they address the cross-cutting concerns assigned to them?

If mismatches are found, message the expert with specific corrections before accepting completion.

## Cross-Review

Once all experts report done, each expert reviews another's work for consistency:

| Focus | Reviewer → Reviews |
|-------|--------------------|
| **Full-stack** | UI Expert → Product Designer's flows; Domain Expert → UI Expert's components; Product Designer → Domain Expert's constraints |
| **UX/Design** | UI Expert → Product Designer's flows; Target Persona → UI Expert's components; Product Designer → Target Persona's feedback |
| **Architecture** | Domain Expert → Architect's design; Security Analyst → Domain Expert's rules; Architect → Security's threat model |
| **Backend only** | API Designer → Architect's design; Domain Expert → API Designer's contracts; Architect → Domain Expert's rules |

Instruct each expert (via SendMessage) to review the specified teammate's output and flag any contract violations or inconsistencies. Collect feedback before proceeding.

## Collect Results and Shutdown

Once all cross-reviews are clean:

1. Read each expert's final deliverables
2. Send shutdown requests to all teammates
3. Delete the team with TeamDelete

## Synthesize Expert Input

Compile the team's findings into a unified analysis:
- **Contract-aligned consensus** — Deliverables that match contracts cleanly → Core of the documentation
- **Cross-review findings** — Issues caught during review → Resolved or noted as decisions
- **Contract deviations** — Approved changes during execution → Document the rationale
- **Remaining disagreements** — Unresolved differences → Present as decision points for user
- **Risks** — Concerns raised by any expert → Mitigation strategies

Present the synthesis to the user before moving to documentation.
