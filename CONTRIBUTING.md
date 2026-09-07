# Contributing

This is a **curation, not a collection**. Prefer leaving something out over adding a weak link. Only nominate a resource you (or another contributor) can personally recommend — the [awesome list rules](https://github.com/sindresorhus/awesome/blob/main/awesome.md) apply here.

Read this file before opening a pull request. A PR should be **100% ready** when you open it. Do not open a Draft / WIP request while you figure out the format.

## What this list is for

Entries must help someone **decide** how to run agentic systems in real engineering — not collect every tool with an “agent” label.

Use these words the way the sources use them:

- **Agentic systems** include both *workflows* (LLMs and tools on predefined paths) and *agents* (the model dynamically directs its own process and tool use). See [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents).
- **MCP** is an open protocol for connecting an AI host to external systems via clients and servers. A useful MCP link explains a **contract** (tools, resources, prompts, transport) — not a product pitch. See [modelcontextprotocol.io](https://modelcontextprotocol.io).
- Prefer **simple, composable patterns** (prompt chaining, routing, orchestrator–workers, evaluator–optimizer, HITL checkpoints) over framework dumps.

If a link does not change a design or ops decision, it does not belong.

## Inclusion (fail closed)

An item must satisfy **all** of the following, and map to **at least one** criterion already listed in `README.md`:

| Gate | Passes when |
|---|---|
| Scope | The resource is about an agentic system with a clear responsibility — a workflow, an agent loop, a harness, or MCP host/client/server behavior — not “AI coding tips”. |
| Tools / MCP | Tools are contracted: documented inputs/outputs, or MCP primitives (tools, resources, prompts) with a public spec or reference implementation. |
| HITL | Risky writes (deploy, payment, prod mutate, secret access) have a human checkpoint, or the resource teaches that boundary. |
| Evidence | There are logs, evals, ADRs, a spec, or a worked example a squad can inspect. Star count is not evidence. |
| Agnostic | It is not a single-vendor sales page. Official MCP / pattern sources are fine; exclusive lock-in pitches are not. |

Also required:

- Public URL. Paywalled-only pitches are rejected.
- Maintained enough to recommend: not archived, not a placeholder README, not a dead domain.
- One sentence that states **why** a reader would use it (awesome.md: comment on why it is awesome).

## What does not belong

- Duplicate of an existing `README.md` entry (search first).
- Unmaintained, archived, or undocumented repos.
- Anything listed under **Rejected / out of scope** in `README.md` (vendor landings, “generate code faster” tutorials, infinite MCP dumps, star-count lists, paywalled pitches, prompt galleries, dead URLs). Point at a **curated catalog** instead — this list already links [punkpeye/awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers).
- Frameworks whose only value is abstraction, with no pattern, contract, or ops evidence.
- Self-promo with no public artifact a reviewer can verify.
- New categories in the same PR as a nomination. Categorization changes are a **separate** pull request.

## How to nominate a link

You need a [GitHub account](https://github.com/join). One item per pull request.

```bash
git clone https://github.com/<your-user>/awesome-agentic-ai.git
cd awesome-agentic-ai
git checkout -b add-<short-slug>
```

Edit `README.md` only. Add the entry at the **bottom of the existing section** that fits (MCP, Patterns & harness, HITL & ops, AppSec / agent security, Related). Do not invent a section in a nomination PR. Do not add rows to **Rejected / out of scope** unless you are documenting a new refuse-class (separate PR).

```markdown
- [Project Name](https://example.com/path) — One sentence: what decision this unlocks.
```

Match the current list: em dash (`—`), description starts with a capital letter, ends with a period, no marketing tagline, no trailing whitespace.

```bash
git add README.md
git commit -m "Add Project Name"
git push -u origin add-<short-slug>
```

Open a pull request against `main`. Title format:

- `Add Project Name` — one new item
- `Fix: …` — typo, dead link, or description fix (still one concern)

Not: `Update readme.md`, `Added stuff`, `Add Awesome X`.

The PR body must include the URL, the target section, the README criterion it maps to, and why it helps someone decide.

To propose a link **without** a patch, use the [Nominate a link](https://github.com/tiagovilasboas/awesome-agentic-ai/issues/new?template=nominate-link.yml) issue form. Maintainers still apply the same gates.

## Before you open the PR

- [ ] I read this file and the fail-closed table in `README.md`.
- [ ] One item only (or a single fix). Not a bundle.
- [ ] Searched `README.md` — not a duplicate.
- [ ] Public URL; I opened it; it is not paywalled-only.
- [ ] Maps to at least one criterion: scope · MCP/tools · HITL · evidence · vendor-agnostic.
- [ ] Description says *why it is on the list*, starts with a capital, ends with a period.
- [ ] Added at the bottom of an **existing** section (MCP · Patterns & harness · HITL & ops · AppSec / agent security · Related); format matches neighbors.
- [ ] Not a class already listed under **Rejected / out of scope**.
- [ ] Not a vendor pitch, not an unmaintained repo, not a tool dump.
- [ ] PR is ready (not Draft / WIP). Title follows `Add Project Name`.

## Maintainers

When merging a curated change, bump **Last curated:** `YYYY-MM-DD` near the top of `README.md`. Nomination authors should not touch that line.

## Updating your pull request

Maintainers will ask for edits when the format, criterion, or evidence is short. That is normal.

[How to update a pull request](https://github.com/RichardLitt/knowledge/blob/master/github/amending-a-commit-guide.md) (same guide used by [sindresorhus/awesome](https://github.com/sindresorhus/awesome/blob/main/contributing.md)).
