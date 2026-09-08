# MCP host threat model

This is a **host-level** threat model for a generic multi-server MCP host — an IDE, CLI, or service that opens one [MCP client per server](https://modelcontextprotocol.io/docs/latest/learn/architecture) and lets a model call tools.

It is a design-review artifact you can copy into a PR. It is **not** a claim that this repo ran a production host, measured an incident rate, or red-teamed a specific vendor. Official attack names come from the [MCP security best practices](https://modelcontextprotocol.io/docs/latest/tutorials/security/security_best_practices). Controls map to [AISVS C09](https://github.com/OWASP/AISVS/blob/main/1.0/en/0x10-C09-Orchestration-and-Agentic-Action.md) and [C10](https://github.com/OWASP/AISVS/blob/main/1.0/en/0x10-C10-MCP-Security.md).

If you are adding a new MCP server (to a product, or as a rare nomination on this list), walk the checklist at the bottom before the tool dump lands in context.

## Protocol vintage

Pin the spec date the host speaks. The [2026-07-28 revision](https://blog.modelcontextprotocol.io/posts/2026-07-28/) retired `initialize` / `Mcp-Session-Id` and deprecated sampling, roots, protocol logging, and HTTP+SSE.

If you still speak an older revision, the session-ID and handle rows below still apply. They are not a reason to reintroduce protocol sessions on a new host. Do not adopt sampling as an orchestrator — keep model invocation in the host. Cross-call state belongs in an explicit tool handle, not a transport session (same official note).

## Assets

What the host is actually holding. If you cannot name these, you do not have a model.

| Asset | Why it matters |
|---|---|
| User and workspace secrets | OAuth grants, PATs, API keys, cookie jars. The host often sees them even when the model should not. |
| Private data the tools can read | Repos, mail, tickets, files, CRM rows. This is usually *why* the server exists. |
| Tool results in the context window | Once a result is pasted into the model, it is untrusted text with instructions inside. |
| Downstream write capabilities | `create_pr`, `send_email`, `kubectl apply`, `charge`. These are the exfil and mutate legs. |
| Host process and local filesystem | `stdio` servers run as the user. A malicious startup command is RCE, not “a plugin”. |
| Audit trail | Who approved what, with which arguments. A chat log is not this. |

The model is **inside** the host for *proposing* actions and **outside** the host for *authorizing* them. [AISVS 9.5.3](https://github.com/OWASP/AISVS/blob/main/1.0/en/0x10-C09-Orchestration-and-Agentic-Action.md): access control is application logic or a policy engine, never the model.

## Trust boundaries

```
                    ┌─ untrusted content ─────────────────────────┐
                    │  public issues · email · web · tool output  │
                    └────────────────────┬────────────────────────┘
                                         │
  user ──► host (allow-list, policy, HITL, budgets)
              │
              ├── MCP client A ──── MCP server A (local stdio)
              ├── MCP client B ──── MCP server B (remote HTTP)
              └── MCP client C ──── MCP server C (proxy / third-party API)
                                         │
                                         ▼
                              downstream APIs / data stores
```

Boundaries that actually change a review:

1. **User → host.** The user consented to *this* server, *this* command line, *these* scopes. One-click install without showing the exact command is a broken boundary ([local MCP server compromise](https://modelcontextprotocol.io/docs/latest/tutorials/security/security_best_practices)).
2. **Host → each server.** One client per server. Do not share a token across servers. Do not pass a client token through to a downstream API ([token passthrough](https://modelcontextprotocol.io/docs/latest/tutorials/security/security_best_practices) is forbidden in the spec).
3. **Server → downstream.** The server is a resource server with its own audience. Confused-deputy starts when a proxy uses one static client id for every caller.
4. **Untrusted content → model.** Anything a tool *reads* can become instructions. Schema-validate and treat tool output as data, not as a new system prompt ([AISVS 10.4.1–10.4.2](https://github.com/OWASP/AISVS/blob/main/1.0/en/0x10-C10-MCP-Security.md)).
5. **Model → write tools.** After untrusted text has entered the context, consequential tools must be impossible or paused for a human ([design patterns vs prompt injection](https://arxiv.org/abs/2506.08837): “once an LLM agent has ingested untrusted input, it must be constrained so that it is impossible for that input to trigger any consequential actions”).

If two servers share a process, a filesystem, or a token, you drew one boundary and deployed zero.

## Lethal trifecta

Simon Willison’s [lethal trifecta](https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/):

1. **Private data** — the tool can read something an attacker should not see.
2. **Untrusted content** — attacker-controlled text can reach the model (a public issue, an email, a web page, another tool’s output).
3. **Exfil channel** — the tool can talk out (HTTP, a public PR, an image URL, a “helpful” email).

MCP makes this easy because it invites mixing servers that each look harmless. The host owns the combination. **Drop any one leg.** Guardrail products that claim to “catch prompt injection” do not replace that design choice — Willison’s point, and the reason this list does not treat a vendor detector as a control.

Host rule of thumb: a read-only server plus a write/network server in the same loop *is* the trifecta unless you isolate them (separate sessions, separate tokens, or a policy that forbids cross-server flow).

## Worked toxic flow (public)

[Invariant on GitHub MCP](https://invariantlabs.ai/blog/mcp-github-vulnerability): a public issue (untrusted) steers an authorized agent to read a private repo (private data) and open a public PR (exfil). The GitHub MCP server code was not “buggy” in the usual sense. The **host** combined the three legs under one user token.

That is the review question: not “is this server popular?” but “which legs does this server add to the host we already have?”

## Attack classes the host must name

From the official MCP security doc, plus orchestration controls. Use these names in PRs so reviewers are not inventing slang.

| Class | What goes wrong at the host | First mitigation |
|---|---|---|
| Lethal trifecta / toxic flow | Three capable servers in one loop | Split sessions, shrink scopes, or drop a leg |
| Confused deputy | Proxy uses one static OAuth client id; consent cookie is reused | Per-client consent *before* the third-party hop; exact `redirect_uri` match |
| Token passthrough | Host or server forwards a token that was not issued for it | Reject wrong audience; mint server-specific tokens ([AISVS 10.2.7](https://github.com/OWASP/AISVS/blob/main/1.0/en/0x10-C10-MCP-Security.md)) |
| SSRF via OAuth metadata | Client fetches `resource_metadata` / auth endpoints the server chose | HTTPS-only, block link-local/private ranges, do not follow redirects blindly |
| State-handle hijacking | Guessable cart/workflow id treated as auth | Bind handles to the verified user; possession ≠ authentication |
| Local server compromise | Malicious `npx` / startup command, or open localhost HTTP | Show the full command; sandbox; prefer `stdio`; Origin/Host checks on HTTP ([AISVS 10.3.3](https://github.com/OWASP/AISVS/blob/main/1.0/en/0x10-C10-MCP-Security.md)) |
| Auth URL injection | `javascript:` or shell-open of a server-supplied authorize URL | Allow `https` (and loopback `http`) only; never `system(open $url)` |
| Tool-list drift / rug pull | Server changes a tool schema after install | Snapshot definitions; re-consent on change ([AISVS 10.4.8](https://github.com/OWASP/AISVS/blob/main/1.0/en/0x10-C10-MCP-Security.md), level 3) |
| Excessive agency | Model chooses a high-impact write | HITL with full canonical args ([AISVS 9.2](https://github.com/OWASP/AISVS/blob/main/1.0/en/0x10-C09-Orchestration-and-Agentic-Action.md)); elicitation belongs in the [protocol](https://modelcontextprotocol.io/specification/latest/client/elicitation) |
| Cross-server bleed | Untrusted output from server A becomes args to server B | Isolate untrusted processors from write tools ([AISVS 9.3.5](https://github.com/OWASP/AISVS/blob/main/1.0/en/0x10-C09-Orchestration-and-Agentic-Action.md)) |
| Deprecated sampling-as-orchestrator | Server asks the host LLM to think; untrusted tool text becomes a nested agent | Do not adopt on 2026-07-28+; keep model invocation in the host |

Deeper checklists: [OWASP MCP Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/MCP_Security_Cheat_Sheet.html), [OWASP Top 10 for Agentic Applications (2026)](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/).

## What the host owns (minimum bar)

You can argue about level-3 AISVS items. You should not ship without these:

- **Allow-listed servers** with a published identity ([registry](https://registry.modelcontextprotocol.io/) or a pin you can explain). Random gists are out. ([AISVS 10.1.2](https://github.com/OWASP/AISVS/blob/main/1.0/en/0x10-C10-MCP-Security.md))
- **Least privilege per server.** Repo A’s token does not see repo B. Mail read is not mail send.
- **No token passthrough.** Downstream APIs see a token minted for them.
- **Schema in, schema out.** Validate `tools/list` and `tools/call` against the declared contract before the model sees them. Reject oversized or unknown fields.
- **HITL on risky writes.** Show the full command, diff, recipient, amount — not a truncated summary. Pause is not optional if you cannot reverse the action.
- **Budgets.** Time, tokens, tool calls, egress. A loop without a kill switch is not operable ([AISVS 9.1](https://github.com/OWASP/AISVS/blob/main/1.0/en/0x10-C09-Orchestration-and-Agentic-Action.md)).
- **Traces you can export.** Prefer [OTel GenAI](https://opentelemetry.io/docs/specs/semconv/gen-ai/) / [agent spans](https://opentelemetry.io/docs/specs/semconv/gen-ai/gen-ai-agent-spans/) over a private span schema. This repo does not have a production trace dump to show you; that is why those links exist in the README.

Debug the contract with [MCP Inspector](https://modelcontextprotocol.io/docs/latest/tools/inspector) before you argue about prompts.

## PR checklist for a new MCP server

Copy into the PR. Fail closed: an unchecked box is a no-merge, not a “follow-up”.

### Identity and supply chain

- [ ] Server has a public contract (spec page, schema, or reference impl) — not a landing page.
- [ ] Install pin is explicit (image digest, git SHA, or registry identity). `npx latest` is not a pin.
- [ ] Startup command is shown in full, including args. Reviewer can see network and filesystem reach.

### Legs this server adds

- [ ] **Private data:** what can it read? Name the stores.
- [ ] **Untrusted content:** what attacker-controlled text can it pull into context?
- [ ] **Exfil / write:** what can it send or mutate?
- [ ] Combined with servers already on this host, the trifecta is **absent** — or we dropped a leg (separate token, separate session, or removed a write).

### Authn / authz

- [ ] Tokens are issued **to this server** (audience). No passthrough.
- [ ] Scopes are least privilege; `tools/list` will not advertise tools the token cannot call.
- [ ] Remote HTTP: TLS, Origin **and** Host validated. Local HTTP on `0.0.0.0` is a bug.
- [ ] State handles (if any) are bound to the authenticated user and are not guessable.

### Host policy

- [ ] Write/high-impact tools go through HITL with canonical arguments (or the server is read-only).
- [ ] Tool results are schema-validated before they enter the model context.
- [ ] A budget exists (max calls / tokens / time). There is a human kill switch.
- [ ] Cross-server flow is either forbidden or written down (which server may feed which).

### Evidence in the PR (inspectable, not a vibe)

- [ ] Inspector (or equivalent) session: list tools, call one read, show the error shape.
- [ ] One paragraph threat note: assets, legs, what we dropped. This file is the template.
- [ ] No production-success metric unless the PR also adds the eval, log, or ADR that backs it.

A single server that cannot pass this list does not belong in a host, and it does not belong as a one-off row on this awesome list. Point at a [catalog](https://github.com/punkpeye/awesome-mcp-servers) instead.

## Sources (public)

- [MCP architecture](https://modelcontextprotocol.io/docs/latest/learn/architecture) — host / client / server.
- [Transports](https://modelcontextprotocol.io/specification/latest/basic/transports) · [Streamable HTTP](https://modelcontextprotocol.io/specification/latest/basic/transports/streamable-http) — stdio vs per-request POST; Origin / localhost.
- [The 2026-07-28 specification](https://blog.modelcontextprotocol.io/posts/2026-07-28/) — stateless core; sampling / HTTP+SSE deprecated.
- [MCP security best practices](https://modelcontextprotocol.io/docs/latest/tutorials/security/security_best_practices) — confused deputy, passthrough, SSRF, handles, local compromise.
- [MCP authorization](https://modelcontextprotocol.io/specification/latest/basic/authorization) — OAuth 2.1 resource server.
- [The lethal trifecta](https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/) — Willison.
- [GitHub MCP exploited](https://invariantlabs.ai/blog/mcp-github-vulnerability) — worked toxic flow.
- [AISVS C09](https://github.com/OWASP/AISVS/blob/main/1.0/en/0x10-C09-Orchestration-and-Agentic-Action.md) · [AISVS C10](https://github.com/OWASP/AISVS/blob/main/1.0/en/0x10-C10-MCP-Security.md).
- [OWASP MCP Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/MCP_Security_Cheat_Sheet.html).
- [Design Patterns for Securing LLM Agents against Prompt Injections](https://arxiv.org/abs/2506.08837).
