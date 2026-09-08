# Agent notes

This repo is a **curated short list**, not a runtime. Humans: [CONTRIBUTING.md](CONTRIBUTING.md). Judgment: [docs/how-we-curate.md](docs/how-we-curate.md). Host checklist: [docs/mcp-host-threat-model.md](docs/mcp-host-threat-model.md).

## Layout

```text
README.md                      curated list + fail-closed table
docs/how-we-curate.md          why a popular repo still gets a no
docs/mcp-host-threat-model.md  host-level design-review template
CONTRIBUTING.md                nomination gates
```

## Do

- Nominate one URL per PR into an existing section.
- Map the URL to a fail-closed criterion (scope · tools/MCP · HITL · evidence · agnostic).
- Prefer leaving a weak link out.

## Don't

- Do not dump MCP servers or invent a section.
- Do not add first-party prod numbers this repo did not measure.
- Do not treat Related siblings as proof this list ran those systems.
- Do not commit to `main`; open a PR.
