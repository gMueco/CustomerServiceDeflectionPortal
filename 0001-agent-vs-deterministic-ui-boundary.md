# ADR 0001: Boundary Between the AI Agent and Deterministic UI

**Status:** Accepted

**Date:** 2026-06-22

---

## Context

The portal needs to handle a range of customer service interactions for returns and
order questions. Some of these are open-ended natural-language questions ("where's
my order?", "can I still return this?", "what's your return policy?"). Others are
concrete actions with real consequences ("submit a return for this item", which
creates records and may trigger a refund).

Agentforce makes it tempting to route *everything* through the AI agent — it can
hold a conversation, look things up, and feel like a single seamless interface. The
question this decision settles is: **which interactions should the AI agent handle,
and which should be handled by deterministic UI (LWC) and backend logic?**

Getting this boundary wrong in either direction is costly:

- Too much through the agent: a generative model performing consequential actions
  (creating returns, issuing refunds) introduces risk of incorrect or hallucinated
  behavior on operations that must be exact and auditable.
- Too little through the agent: forcing customers through rigid forms for simple
  questions wastes the deflection value the agent is meant to provide.

## Options Considered

### Option A — Agent handles everything, including actions
The agent answers questions *and* executes returns, refunds, and record changes
directly through its actions.

- **Pro:** Single conversational interface; minimal UI to build.
- **Con:** Consequential, irreversible operations depend on a generative model
  interpreting intent correctly. Harder to validate input, enforce business rules,
  and produce a clean audit trail. A misinterpreted request could create wrong
  records or trigger an unwarranted refund.

### Option B — Deterministic UI handles everything, agent is cosmetic
Customers use forms and components for everything; the agent is a thin wrapper or
omitted.

- **Pro:** Full control, validation, and auditability on every operation.
- **Con:** Throws away the deflection value. Customers must navigate forms even for
  simple questions, which is the friction self-service is meant to remove.

### Option C — Split by consequence (chosen)
The agent handles **information and routing**; deterministic UI and backend logic
handle **anything that changes data or has consequences**.

- The agent answers questions, looks up real order/eligibility data via grounded
  Apex actions, and *routes* the customer to the right deterministic flow.
- Consequential actions (submitting a return, anything that writes records or
  affects money) run through validated LWC flows and Apex with explicit business
  rules.
- **Pro:** Deflection value for the high-volume simple cases; safety, validation,
  and auditability for the consequential ones.
- **Con:** More moving parts — two surfaces to build and a handoff between them to
  design carefully.

## Decision

Adopt **Option C**. The governing principle:

> **The agent informs and routes; deterministic UI and backend logic execute
> anything with consequences.**

Concretely:

| Interaction | Handled by | Why |
|---|---|---|
| "Where is my order?" | Agent (grounded Apex action) | Read-only lookup, no consequence |
| "Can I still return this?" | Agent (grounded eligibility check) | Read-only computed answer |
| "What's the return policy?" | Agent (grounded in policy data) | Informational |
| Submitting a return | LWC return wizard + Apex | Writes records, has consequences |
| Escalating to a human | LWC handoff → Case with context | Requires reliable record creation |

The dividing test for any future interaction: **does it change data or carry a
consequence?** If yes, it belongs in deterministic UI/logic. If it is read-only
information or routing, the agent may handle it.

## Consequences

**Positive:**
- Customers get fast, conversational answers for the common read-only questions
  (the bulk of service volume), preserving the deflection goal.
- Consequential operations remain validated, rule-enforced, and auditable, with no
  dependence on generative interpretation.
- The boundary gives a clear, repeatable rule for deciding where any new feature
  belongs, rather than case-by-case guesswork.

**Negative / costs:**
- Two surfaces (agent and LWC) must be built and maintained.
- The handoff between agent and deterministic UI must be designed deliberately so
  the transition feels seamless to the customer and preserves context. This handoff
  is itself the subject of a later ADR.

**Follow-on decisions this creates:**
- How the agent is grounded to prevent hallucinated answers (separate ADR).
- How conversation context is preserved across the agent-to-LWC and
  agent-to-human handoffs (separate ADR).
