# How we curate

This is the social contract for the list. [CONTRIBUTING.md](../CONTRIBUTING.md) is the gate checklist (one item, public URL, fail-closed criteria). This page is the judgment call — why a popular repo still gets a no, and how to read the **Rejected / out of scope** table without treating it as a dunk list.

Tone check: if a sentence here sounds like a vendor pitch or a “thought leadership” manifesto, it does not belong. We are trying to keep a short list honest.

## The contract

I will not add a link I would not send a teammate on a Thursday when they have a real decision: add this MCP server or not, pick this harness or not, pause this write or not.

That implies:

- **Small is the feature.** A 300-link awesome page is a search index. This is a recommendation.
- **Stars are not a criterion.** They are a popularity contest. The README already says evidence is logs, evals, or an ADR.
- **Leaving something out is the job.** “But everyone links it” is not an argument. If it does not change a design or ops decision, it stays out.
- **No borrowed glory.** Related repos under the same GitHub user are pointers, not proof that *this* list ran those systems in production.
- **No invented numbers.** If this repo did not add an eval, a trace export, or an ADR, we do not quote a latency, a cost, or a “we saw this in prod” rate.

If you nominate, you are asking the maintainer to put the list’s reputation on that URL. Make that cheap to verify.

## What “helps someone decide” means

A yes looks like: a spec you can pin, a pattern you can implement, a control you can test, a comparison that names trade-offs, an eval you can fail a build on.

A no looks like: a hero GIF, a pricing page, a prompt pack, a server dump, a “we 10x’d velocity” post with no method.

Two questions I actually ask:

1. **After I read this, what do I do differently on Monday?** If the answer is “star the repo”, it is out.
2. **Can a reviewer open the artifact without a login wall or a sales call?** If not, it is out.

## How to use the Rejected table

The table in the README is **classes**, not a hit list of named projects.

- Use it as a **pre-filter**. If your nomination matches a row, do not open the PR to argue taste. The row already named the failed gate.
- **Do not add a project name** to Rejected because you dislike it. Add a *class* when a new refuse-pattern keeps showing up (separate PR, as CONTRIBUTING says).
- **Do not treat Rejected as a backlog.** We are not going to “reconsider” a landing page when it adds a blog. Ship a spec, an eval, or a worked threat model first — then nominate that artifact.
- **Catalogs exist on purpose.** Infinite MCP server lists are rejected *here* because [punkpeye](https://github.com/punkpeye/awesome-mcp-servers), [wong2](https://github.com/wong2/awesome-mcp-servers), and [mcpHQ](https://github.com/mcpHQ/awesome-mcp-servers) already do that job. A single server needs a contract, an auth story, and a host threat note — see [mcp-host-threat-model.md](mcp-host-threat-model.md).
- **Keep the wording sharp.** Each row should name the refuse-class and the gate (scope, tools/MCP, HITL, evidence, agnostic, or process). Soften the joke, not the gate.

If you want a new row, write it so a tired reviewer can apply it at 6pm: one class, one why, no novel.

## What I will push back on (even when the URL is fine)

- **Framework-only abstraction.** If the only value is a wrapper around a pattern the Anthropic [effective agents](https://www.anthropic.com/engineering/building-effective-agents) post already named, link the pattern, not the wrapper.
- **Harness as brand.** A harness comparison that is a feature matrix with no sandbox, cost, or ops story is a catalog. We already have [Winder](https://winder.ai/ai-agent-harness-comparison/) for the matrix; we need evidence for the rest.
- **Security theater.** A “guardrail” that does not change tool reach, token audience, or HITL is not a control. Point at AISVS / trifecta / the host model instead.
- **Deprecated MCP as current.** HTTP+SSE and sampling-as-orchestrator posts still circulate. Point at the dated spec and the [2026-07-28 note](https://blog.modelcontextprotocol.io/posts/2026-07-28/), not a 2025 tutorial.
- **Cost and latency as vibes.** A dashboard screenshot is not [Inspect](https://inspect.aisi.org.uk/) or an OTel span. See the README **Cost / latency / evidence** section — it points at links we already curate. It is not a new dumping ground.
- **Context as a dump.** Pasting the wiki, every MCP schema, or last week’s transcript into the window is not engineering. The decision is the smallest high-signal set ([Anthropic](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)) plus a fail-closed assembly. Leave the rest out.

## Process that keeps the list reviewable

One item per PR. Existing section only. Description starts with a capital letter, ends with a period, states the decision — same as CONTRIBUTING.

New sections and new Rejected classes are **separate** PRs. That is not bureaucracy. Mixed PRs are how a list turns into a junk drawer.

Maintainers bump **Last curated** when the *list* changes. Nomination authors should not touch that line.

## If you are unsure

Open a [Nominate a link](https://github.com/tiagovilasboas/awesome-agentic-ai/issues/new?template=nominate-link.yml) issue instead of a speculative PR. Same gates. Prefer a short “I am leaving this out because …” comment over a polite maybe.

The failure mode I care about is not “we missed a cool repo”. It is “we taught someone that star count is a Staff criterion”.
