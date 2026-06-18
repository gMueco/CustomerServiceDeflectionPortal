# Customer Service Deflection Portal
AI-Assisted Development Project For Learning

A self-service returns and claims portal for a fictional retailer, built on Salesforce.
The portal lets customers resolve common service requests on their own — checking
order status, confirming return eligibility, and submitting a return — while an
Agentforce agent handles natural-language questions and hands off to a human when
a request falls outside what should be automated.

This project is as much about the **design decisions** as the code. Each significant
architectural choice is documented as an [Architecture Decision Record](./docs/adr)
explaining the options considered, the tradeoffs, and the reasoning behind the pick.

---

## The Problem

Retail customer service teams spend a large share of their time on a small set of
repetitive, low-complexity requests: "Where is my order?", "Can I return this?",
"What's your return window?". These are well-suited to self-service and AI
deflection — but only some of them. A question like *"is this item still within its
return window?"* is a good fit for a grounded AI agent. The act of *submitting* a
return, by contrast, has real consequences (it creates records, may trigger refunds)
and should run through deterministic, validated UI rather than a generative model.

The core design problem this project explores is therefore: **where is the line
between what an AI agent should handle and what should be handled by deterministic
UI and backend logic — and how do you hand off cleanly between them?**

---

## Architecture Overview

The solution is split into three layers, divided deliberately by responsibility:

**1. Agentforce agent (tier-1 questions).**
An Agentforce agent answers natural-language customer questions — order status,
return eligibility, policy lookups — using custom **Apex-backed agent actions**.
The agent is grounded in the org's actual data and policies so it reports real
order and eligibility information rather than generating plausible-sounding answers.

**2. Lightning Web Components (deterministic actions).**
The parts of the experience that change data or require validated, step-by-step
input are built as LWCs rather than left to the agent:
- an **order detail view** showing real-time status,
- a **guided return wizard** that walks the customer through submitting a return,
- an **escalation handoff** that creates a Case and passes the conversation context
  to a human agent when needed.

**3. Data model.**
Orders, Return Requests, and eligibility rules, with the relationships and fields
that the agent actions query and the LWCs display. See the
[ERD](./docs/data-model.md).

The guiding principle: **the agent informs and routes; deterministic UI and backend
logic execute anything with consequences.**

---

## Key Design Decisions

These are documented in full as ADRs. Highlights:

- **Agent action vs. Flow for backend logic** — when custom Apex actions are the
  right tool versus declarative automation.
- **LWC vs. screen flow for the return wizard** — why the guided flow is built as a
  component rather than a screen flow.
- **Grounding the agent** — how the agent is kept tied to real data and policy to
  prevent hallucinated return rules.
- **Escalation boundary** — the explicit rules for when the agent stops and hands
  off to a human, and how conversation context is preserved.

See [`/docs/adr`](./docs/adr) for the full records.

---

## Tech Stack

- **Agentforce** — agent and custom agent actions
- **Apex** — agent action backend, business logic, test coverage
- **Lightning Web Components** — customer-facing deterministic UI
- **Salesforce data model** — custom objects and relationships
- Developed in **VS Code** with the **Salesforce CLI**, version-controlled in **Git**

---

## Status & Roadmap

This project is built iteratively and in the open. Current state and planned work:

- [ ] Data model: Orders, Return Requests, eligibility rules
- [ ] ADR: agent vs. deterministic UI boundary
- [ ] Apex agent action: order status lookup
- [ ] Apex agent action: return eligibility check
- [ ] LWC: order detail view
- [ ] LWC: guided return wizard
- [ ] Escalation handoff to Case with conversation context
- [ ] Apex test coverage across actions and logic

Checkboxes are updated as work lands. Early commits favor establishing the data
model and the design records before building features on top of them.

---

## About This Project

I'm building this to demonstrate end-to-end Salesforce solution design — not just
working code, but the reasoning behind where each responsibility lives. Feedback is
welcome.
