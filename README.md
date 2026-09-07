# Awesome Agentic AI

## Purpose / Propósito

**PT:** Ser a **lista viva com critério Staff** para quem opera agents em engenharia de verdade — multi-agent, MCP, harness, HITL e ops. Cada link entra porque **ajuda a decidir**, não porque tem estrela.

**EN:** A **living, Staff-criteria list** for people who run agents in real engineering — multi-agent, MCP, harness, HITL, and ops. Links earn a place by helping you **decide**, not by star count.

**Não é / Not:** dump de tools, marketing de vendor, tutorial “gera código mais rápido”.

Maintainer: [Tiago Montanha](https://github.com/tiagovilasboas) · Staff · Agentic AI · AppSec · Observability

---

## Critério / Criteria (fail closed)

| Critério | PT | EN |
|---|---|---|
| Escopo | Agent com responsabilidade clara | Clear agent scope |
| Tools | MCP / tools com contrato | Contracted tools / MCP |
| HITL | Writes de risco com humano | Risky writes need HITL |
| Evidência | Logs, evals ou ADR | Logs, evals, or ADRs |
| Agnóstico | Não é pitch de um vendor | Not a single-vendor pitch |

---

## Standards & foundations

- [Model Context Protocol](https://modelcontextprotocol.io) — contrato aberto de tools/contexto
- [MCP specification (org)](https://github.com/modelcontextprotocol) — spec + SDKs + registry
- [MCP reference servers](https://github.com/modelcontextprotocol/servers) — implementações de referência
- [AGENTS.md](https://agents.md/) — convenção aberta de instruções de projeto
- [OWASP AISVS](https://owasp.org/www-project-artificial-intelligence-security-verification-standard-aisvs-docs/) — requisitos testáveis (agentic + MCP)

## Design patterns

- [Building effective agents (Anthropic)](https://www.anthropic.com/engineering/building-effective-agents) — chaining, routing, orchestrator-workers, evaluator-optimizer, HITL
- [claude-cookbooks / patterns/agents](https://github.com/anthropics/claude-cookbooks/tree/main/patterns/agents) — exemplos mínimos dos padrões

## MCP catalogs (curated, not infinite)

- [wong2/awesome-mcp-servers](https://github.com/wong2/awesome-mcp-servers) — formato de curadoria MCP
- [mcpHQ/awesome-mcp-servers](https://github.com/mcpHQ/awesome-mcp-servers) — catálogo com tags/landscape

## Multi-agent & harness

- [rinadelph/Agent-MCP](https://github.com/rinadelph/Agent-MCP) — multi-agent + MCP + memória compartilhada
- [Winder: agent harness comparison](https://winder.ai/ai-agent-harness-comparison/) — harness muda o score (ops)

## Related (this org)

- [jarvis-architecture](https://github.com/tiagovilasboas/jarvis-architecture) — brain · workers · ops
- [agent-measurement](https://github.com/tiagovilasboas/agent-measurement) — medir, não treinar
- [agentic-code-review](https://github.com/tiagovilasboas/agentic-code-review) — skills · runbooks · guardrails

---

## Inspired by / Anti-patterns

**Inspired by:** listas oficiais MCP + padrões Anthropic + AISVS como filtro de qualidade.

**Avoid:** awesome com 300 links sem critério; “arquitetura” = um único IDE.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to nominate a link (one item per pull request).

## License

[CC0](https://creativecommons.org/publicdomain/zero/1.0/)
