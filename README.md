# Awesome Agentic AI [![Awesome](https://awesome.re/badge.svg)](https://awesome.re)

Most “awesome agent” pages are a dump. This is the short list I would actually send a teammate when we are deciding whether to add an MCP server, pick a harness, or put a human in the loop.

An entry earns a place by changing a decision, not by star count. MCP, harnesses, HITL/ops, agent security.

**Last curated:** 2026-09-07

Maintainer: [Tiago Montanha](https://github.com/tiagovilasboas) · Staff · Agentic AI · AppSec · Observability

## Contents

- [Criteria (fail closed)](#criteria-fail-closed)
- [How we curate](#how-we-curate)
- [MCP host threat model](#mcp-host-threat-model)
- [MCP](#mcp)
- [Patterns & harness](#patterns--harness)
- [HITL & ops](#hitl--ops)
- [Cost / latency / evidence](#cost--latency--evidence)
- [AppSec / agent security](#appsec--agent-security)
- [Rejected / out of scope](#rejected--out-of-scope)
- [Related (this org)](#related-this-org)
- [Contributing](#contributing)
- [License](#license)

## Criteria (fail closed)

| Critério | PT | EN |
|---|---|---|
| Escopo | Agent com responsabilidade clara | Clear agent scope |
| Tools | MCP / tools com contrato | Contracted tools / MCP |
| HITL | Writes de risco com humano | Risky writes need HITL |
| Evidência | Logs, evals ou ADR | Logs, evals, or ADRs |
| Agnóstico | Não é pitch de um vendor | Not a single-vendor pitch |

## How we curate

The fail-closed table is the gate. [How we curate](docs/how-we-curate.md) is the social contract: why a popular repo still gets a no, and how to read **Rejected** as classes rather than a dunk list. If you would not send the link to a teammate on a Thursday, do not nominate it.

## MCP host threat model

Adding a server is a host decision, not a catalog decision. [MCP host threat model](docs/mcp-host-threat-model.md) names assets, trust boundaries, the [lethal trifecta](https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/), and a PR checklist. It is a design-review template — not a production incident report from this repo.

## MCP

Open protocol for connecting an AI host to tools, resources, and prompts. Prefer a **contract** over a server dump.

- [Model Context Protocol](https://modelcontextprotocol.io) — Canonical intro: USB-C-style contract between hosts, clients, and servers.
- [MCP specification (latest)](https://modelcontextprotocol.io/specification/latest) — Normative, versioned protocol; pin what you implement against this, not a blog.
- [Architecture overview](https://modelcontextprotocol.io/docs/latest/learn/architecture) — Host / client / server split so you can place trust boundaries before adding tools.
- [Tools](https://modelcontextprotocol.io/specification/latest/server/tools) — JSON-schema tool contract: names, arguments, and error shapes the model actually calls.
- [Authorization](https://modelcontextprotocol.io/specification/latest/basic/authorization) — OAuth 2.1 resource-server rules; do not invent a custom token scheme.
- [Security best practices](https://modelcontextprotocol.io/docs/latest/tutorials/security/security_best_practices) — Official attack-surface list (confused deputy, token passthrough, session IDs).
- [Client best practices](https://modelcontextprotocol.io/docs/latest/develop/clients/client-best-practices) — How a host scales across many servers without a tool-soup context window.
- [MCP Inspector](https://modelcontextprotocol.io/docs/latest/tools/inspector) — Reference debugger (web / CLI / TUI) for contract and OAuth checks before production.
- [Reference servers](https://github.com/modelcontextprotocol/servers) — Official implementations to copy contracts from, not an infinite catalog.
- [Official MCP Registry](https://registry.modelcontextprotocol.io/) — Discovery with a published server identity, not a random gist.
- [punkpeye/awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers) — Highest-signal community catalog; use it instead of pasting every server here.
- [wong2/awesome-mcp-servers](https://github.com/wong2/awesome-mcp-servers) — Compact catalog format useful as a second curation pass.
- [mcpHQ/awesome-mcp-servers](https://github.com/mcpHQ/awesome-mcp-servers) — Tagged landscape when you need to compare categories, not vendors.
- [Elicitation](https://modelcontextprotocol.io/specification/latest/client/elicitation) — Protocol-level request for structured human input; HITL belongs in the contract.

## Patterns & harness

Simple composable patterns first. A harness is the runtime around the model (loop, tools, context, sandbox, policy) — it changes the score more than the model card.

- [Building effective agents (Anthropic)](https://www.anthropic.com/engineering/building-effective-agents) — Workflow vs agent, plus chaining, routing, parallelization, orchestrator–workers, evaluator–optimizer, HITL.
- [claude-cookbooks / patterns/agents](https://github.com/anthropics/claude-cookbooks/tree/main/patterns/agents) — Minimal implementations of those patterns you can read in one sitting.
- [How we built our multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system) — Production lessons: when multi-agent pays off and where coordination cost dominates.
- [12-Factor Agents](https://github.com/humanlayer/12-factor-agents) — Own prompts, context, control flow, and pause/resume; treat HITL as a tool call.
- [A practical guide to building agents (OpenAI)](https://cdn.openai.com/business-guides-and-resources/a-practical-guide-to-building-agents.pdf) — When *not* to build an agent, plus guardrails and human escalation as design, not SDK lock-in.
- [AGENTS.md](https://agents.md/) — Open convention for repo-level agent instructions; put scope in-tree, not only in a chat.
- [Winder: AI agent harness comparison](https://winder.ai/ai-agent-harness-comparison/) — Side-by-side harness trade-offs (governance, sandbox, lock-in) so the runtime is a decision.
- [Harness Engineering (arXiv:2609.00006)](https://arxiv.org/abs/2609.00006) — Source-code anatomy of eleven coding harnesses; use it to name subsystems, not to pick a brand.
- [SWE-agent](https://github.com/SWE-agent/SWE-agent) — Agent–computer interface: tool schema design moves SWE-bench more than prompt poetry.
- [OpenHands](https://github.com/OpenHands/OpenHands) — Self-hosted coding harness with an explicit sandbox; compare against editor-native agents.
- [goose](https://github.com/aaif-goose/goose) — Local-first, provider-agnostic harness under foundation governance (not a lab CLI).
- [rinadelph/Agent-MCP](https://github.com/rinadelph/Agent-MCP) — Multi-agent loop with shared memory over MCP; inspect the contract, not the demo.
- [LangGraph](https://github.com/langchain-ai/langgraph) — Low-level graph for durable, interruptible control flow you can own (read the runtime, skip the pitch).
- [A2A Protocol](https://a2a-protocol.org/latest/) — Open inter-agent discovery and messaging; use when agents must collaborate across stacks.

## HITL & ops

Risky writes pause for a human. If you cannot resume, trace, or eval the loop, it is not operable.

- [LangGraph interrupts](https://docs.langchain.com/oss/python/langgraph/interrupts) — Canonical pause/resume: persist state, wait, then `Command(resume=…)` with the same thread.
- [LangGraph persistence](https://docs.langchain.com/oss/python/langgraph/persistence) — Checkpoints so a multi-hour agent survives process death instead of restarting the plan.
- [Temporal — AI](https://docs.temporal.io/ai) — Durable execution for agent steps that must wait days (approval, webhook) without burning a loop.
- [OpenTelemetry GenAI semantic conventions](https://opentelemetry.io/docs/specs/semconv/gen-ai/) — Vendor-neutral span names/attributes so traces are portable across Phoenix, Langfuse, and homemade backends.
- [GenAI agent spans](https://opentelemetry.io/docs/specs/semconv/gen-ai/gen-ai-agent-spans/) — How to record agent, tool, and graph-node spans (not just chat completions).
- [Arize Phoenix](https://github.com/Arize-ai/phoenix) — Open tracing/eval UI you can self-host; evidence for “it worked in staging”.
- [Langfuse](https://github.com/langfuse/langfuse) — Open-source traces, scores, and prompt versions with an export path (not a black-box SaaS-only log).
- [OpenLLMetry](https://github.com/traceloop/openllmetry) — OTel instrumentation for common agent stacks so you do not invent a private span schema.
- [Promptfoo](https://www.promptfoo.dev/) — CI-shaped evals and red-team assertions you can fail a build on.
- [Inspect](https://inspect.aisi.org.uk/) — UK AISI eval framework for agent trajectories; treat evals as evidence, not a slide.
- [DeepEval](https://github.com/confident-ai/deepeval) — Unit-test style metrics (including agent/tool paths) that belong next to pytest, not a dashboard demo.
- [Ragas](https://github.com/vibrantlabsai/ragas) — Reference-and-reference-free metrics when the agent’s job is retrieval + grounded answers.
- [OpenAI Evals](https://github.com/openai/evals) — Registry + harness for repeatable LLM/system evals you can fork without buying a platform.

## Cost / latency / evidence

This repo does not publish first-party production numbers. If you cannot trace or eval the loop, you cannot operate it — and you cannot tell whether a multi-agent design is worth the token bill.

Use sources **already in this list** (no new dump):

- **When multi-agent is even worth it** — [How we built our multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system) (under Patterns & harness). Anthropic’s public write-up: token use dominates the score, and their published figures are ~4× tokens vs chat for agents and ~15× for multi-agent. Those are *theirs*, not a measurement from this repo. Coordination cost is the decision.
- **Portable traces** — [OpenTelemetry GenAI semantic conventions](https://opentelemetry.io/docs/specs/semconv/gen-ai/), [GenAI agent spans](https://opentelemetry.io/docs/specs/semconv/gen-ai/gen-ai-agent-spans/), [OpenLLMetry](https://github.com/traceloop/openllmetry). Prefer these over a private span schema.
- **Inspectable UIs** — [Arize Phoenix](https://github.com/Arize-ai/phoenix), [Langfuse](https://github.com/langfuse/langfuse). Evidence that “it worked in staging” is a trace you can export, not a screenshot.
- **Fail the build** — [Promptfoo](https://www.promptfoo.dev/), [Inspect](https://inspect.aisi.org.uk/), [DeepEval](https://github.com/confident-ai/deepeval), [Ragas](https://github.com/vibrantlabsai/ragas), [OpenAI Evals](https://github.com/openai/evals).
- **Budgets are a control** — [AISVS C09](https://github.com/OWASP/AISVS/blob/main/1.0/en/0x10-C09-Orchestration-and-Agentic-Action.md) (execution budgets, loop control, kill switch). A dashboard without a cap is not ops.

A vendor latency graph with no method is Rejected. Nominate eval/trace *artifacts*, not vibes.

## AppSec / agent security

Fail closed: if the agent can read private data, see untrusted content, *and* talk to the network, treat that as a design bug.

- [OWASP AISVS](https://owasp.org/www-project-artificial-intelligence-security-verification-standard-aisvs-docs/) — Testable requirements (levels 1–3), including agentic orchestration and MCP chapters.
- [AISVS C09 — Orchestration & agentic action](https://github.com/OWASP/AISVS/blob/main/1.0/en/0x10-C09-Orchestration-and-Agentic-Action.md) — Controls for tool misuse, privilege, and cascading agent actions.
- [AISVS C10 — MCP security](https://github.com/OWASP/AISVS/blob/main/1.0/en/0x10-C10-MCP-Security.md) — Verification items specific to MCP identity, schema, and supply chain.
- [OWASP Top 10 for LLM Applications](https://owasp.org/www-project-top-10-for-large-language-model-applications/) — Shared language for prompt injection, excessive agency, and insecure output handling.
- [OWASP Top 10 for Agentic Applications (2026)](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/) — ASI01–ASI10 (goal hijack, tool misuse, identity abuse, MCP/A2A supply chain).
- [Agentic AI Threats and Mitigations](https://genai.owasp.org/resource/agentic-ai-threats-and-mitigations/) — Taxonomy to threat-model a loop before you write tools.
- [The lethal trifecta (Simon Willison)](https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/) — Private data + untrusted content + exfil channel; drop any one leg.
- [Design Patterns for Securing LLM Agents against Prompt Injections](https://arxiv.org/abs/2506.08837) — Action-selector, plan-then-execute, dual-LLM, and related patterns with utility/security trade-offs.
- [Defeating Prompt Injections by Design (CaMeL)](https://arxiv.org/abs/2503.18813) — Capability-based control so untrusted text cannot choose consequential tools.
- [GitHub MCP exploited (Invariant)](https://invariantlabs.ai/blog/mcp-github-vulnerability) — Worked toxic flow: public issue → private-repo leak via an authorized tool chain.
- [NIST AI Risk Management Framework](https://www.nist.gov/itl/ai-risk-management-framework) — Govern / Map / Measure / Manage vocabulary for agent risk, not a product checklist.
- [NIST AI 600-1 — Generative AI Profile](https://www.nist.gov/publications/artificial-intelligence-risk-management-framework-generative-artificial-intelligence) — Cross-sector GenAI actions (including human–AI configuration and information security).
- [Google SAIF](https://saif.google/) — Secure AI Framework principles (asset inventory, detection, response) you can map to an agent host.

## Rejected / out of scope

Examples of what we refuse, and why. Nominate none of these.

| We refuse | Why (fail closed) |
|---|---|
| Infinite MCP server lists pasted into this README | Catalogs already exist (`punkpeye`, `wong2`, `mcpHQ`). A single server needs a contract, auth story, and threat model. |
| Vendor “agent platform” landing pages | Agnostic gate. If the only artifact is a pricing page, it does not help a squad decide. |
| “Generate code faster” tutorials | Scope gate. Speed-of-codegen is not agent responsibility, HITL, or evidence. |
| Star-count leaderboards with no criterion | Evidence gate. Stars are not logs, evals, or an ADR. |
| “Architecture” that is one IDE | Scope + agnostic. A harness comparison or a spec belongs; a single editor does not. |
| Paywalled-only pitch decks | Public URL required. Reviewers must open the artifact. |
| Prompt galleries with no eval or ADR | Evidence gate. A prompt without a score or decision record is spam. |
| Self-promo with no inspectable artifact | Same as vendor pitch. Ship a spec, eval, or worked threat model first. |
| Dead, archived, or unverified URLs | Fail closed on fetch. If we cannot open it, it does not ship. |
| New categories bundled with a nomination | Process. Recategorization is a separate PR so the list stays reviewable. |
| Cost/latency screenshots with no method or eval | Evidence gate. A dashboard PNG is not Inspect, OTel spans, or an ADR. |
| “We ran this in prod” with no inspectable artifact | Evidence gate. This list does not take production claims on faith. |

## Related (this org)

- [jarvis-architecture](https://github.com/tiagovilasboas/jarvis-architecture) — Brain · workers · ops.
- [agent-measurement](https://github.com/tiagovilasboas/agent-measurement) — Measure, do not train.
- [agentic-code-review](https://github.com/tiagovilasboas/agentic-code-review) — Skills · runbooks · guardrails.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). One item per pull request. Map the URL to a criterion above. Prefer leaving a weak link out.

## License

[CC0](https://creativecommons.org/publicdomain/zero/1.0/)
