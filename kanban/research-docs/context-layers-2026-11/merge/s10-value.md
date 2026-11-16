## Long-term business value: what they expect and what is proven

Every published with-versus-without test favours adding semantics, but most are vendor-run on 11 to 150 questions; no independent multi-company study exists (both).

### Stated long-term goals

- **One number everywhere, including in agents.** Diageo: trusted metrics "defined once, governed centrally, and delivered into AI" ([Strategy](https://www.strategy.com/software/blog/how-diageo-scales-enterprise-ai-with-a-governed-semantic-layer)) (both). Airbnb: "define once, use everywhere"; Netflix: "model once, represent everywhere" ([InfoQ](https://www.infoq.com/news/2025/12/netflix-upper-uda-architecture)) (Opus).
- **A reusable decision foundation.** The same measure in a board report, a sales app and an agent; product identities that link demand to supply (Astra). Astra treats Diageo, IKEA and Mars as three different parts of this aim, not three copies of one technology.
- **Faster delivery.** Diageo's data products in hours; Kimberly-Clark's 70% faster ingestion ([Snowflake](https://www.snowflake.com/en/customers/all-customers/case-study/kimberly-clark/)) (Opus).
- **Savings targets.** Kimberly-Clark's data backs over $800m of a four-year, $3bn supply chain savings goal ([Snowflake](https://www.snowflake.com/en/customers/all-customers/case-study/kimberly-clark/)) (Opus).
- **Agents that act, not just answer.** Walmart plans for Wally to take tactical actions "within configurable guardrails" ([Walmart](https://corporate.walmart.com/news/2025/03/18/walmart-develops-genai-powered-assistant-for-walmart-merchants)); Kimberly-Clark plans an agent orchestration layer; PepsiCo plans agentic root-cause analysis (Opus).
- **Regulated product data.** IKEA plans Digital Product Passports under EU ESPR on its knowledge graph ([Semantic Data Europe 2025](https://backend.henrystewartconferences.com/session/events-semantic-data-europe-2025-bridging-physical-and-digital-ikea-knowledge-graph)) (Opus).
- **Analyst predictions, not measurements.** Gartner (June 2026) predicts firms prioritising semantics will raise agentic AI accuracy by up to 80% and cut costs by up to 60% by 2027 ([IDM](https://idm.net.au/node/15619)) (Opus). Gartner (February 2025): 60% of AI projects lacking AI-ready data will be abandoned through 2026 ([Freevacy](https://www.freevacy.com/news/gartner/gartner-reveals-60-of-ai-projects-with-data-issues-will-fail/6155)) (Opus).

Astra proposes six measures for a business case: reconciled gross-to-net variance, time to answer a recurring sales question, forecast and replenishment outcomes, share of questions correctly declined, analyst hours spent on definitions, and time to roll out a metric change (Astra proposal, not observed results).

### Measured results and benchmarks

**Accuracy benchmarks.** Newest first. "Vendor" means the organisation that ran it sells a semantic layer or related product.

| Who | What was measured | Without layer | With layer | Who ran it | Source |
|---|---|---|---|---|---|
| Ye (Sep 2026) | Separates business content from prompt scaffolding in "better context" | n/a | Domain content can dominate the gain | Academic preprint (Astra) | [arXiv](https://arxiv.org/abs/2609.22259) |
| Rumiantsau and Fokeev (Apr 2026) | 100 ContosoRetail questions, ClickHouse, three models, compact Markdown semantic document | ~45.5-50.5% | 67.7-68.7% | Academic preprint (Astra) | [arXiv](https://arxiv.org/abs/2604.25149) |
| dbt Labs (Apr 2026) | 11 insurance questions × 20 runs, 15 tables, all questions on raw schema | 64.5% | 72.7%; ~100% on in-scope questions | **Vendor** (both) | [dbt](https://docs.getdbt.com/blog/semantic-layer-vs-text-to-sql-2026) |
| dbt Labs (Apr 2026) | Same, after three LLM-written models (Sonnet 4.6 / GPT-5.3-Codex) | 90.0% / 84.1% | 98.2% / 100% | **Vendor** (both) | [dbt](https://docs.getdbt.com/blog/semantic-layer-vs-text-to-sql-2026) |
| MotherDuck (2026) | DABStep payments benchmark, 440 questions | Vector retrieval ~88%; knowledge in warehouse ~93% | 100% (LLM-authored layer under eval) | **Vendor** (Opus) | [MotherDuck](https://motherduck.com/blog/oops-maybe-we-do-need-semantic-layers/) |
| Cube (2026) | "Paired LLM benchmark across three frontier models" | n/a | +17 to +23 points; no method on page | **Vendor** (Opus) | [Cube](https://cube.dev/case-studies/betterup-governed-ai-analytics) |
| Snowflake on BIRD (2025) | Claude 3.5 Sonnet, four datasets | 57% | 78% | **Vendor**, reported by Atlan (Opus) | [Atlan](https://atlan.com/know/snowflake/cortex-analyst-vs-text-to-sql/) |
| Google Looker (May 2025) | "Internal testing" | n/a | Up to two-thirds fewer errors; no method | **Vendor** (Opus) | [Google](https://cloud.google.com/blog/products/business-intelligence/how-lookers-semantic-layer-enhances-gen-ai-trustworthiness) |
| Snowflake (2024-25) | Internal 150-question BI set | GPT-4o single prompt 51% | Cortex Analyst "90%+" | **Vendor** (Opus) | [Snowflake](https://www.snowflake.com/en/engineering-blog/cortex-analyst-text-to-sql-accuracy-bi/) |
| Spider 2.0 (Nov 2024) | 632 real enterprise workflows, raw text-to-SQL | o1-preview agent 21.3% (vs 91.2% on Spider 1.0) | n/a | Academic (Opus) | [arXiv](https://arxiv.org/abs/2411.07763) |
| AtScale (Aug 2024) | 40 TPC-DS questions, Gemini 1.5 Pro | 20% | 92.5% | **Vendor** (Opus) | [BigDATAwire](https://www.hpcwire.com/bigdatawire/2024/08/15/atscale-claims-text-to-sql-breakthrough-with-semantic-layer/) |
| Allemang, Sequeda (May 2024) | Adds ontology-based query check and LLM repair | 54% | 72% (plus 8% "I don't know") | data.world, sells KG tools (Opus) | [arXiv](https://arxiv.org/abs/2405.11706) |
| Sequeda, Allemang, Jacob (Nov 2023) | Insurance schema, GPT-4 zero-shot, SQL versus knowledge graph | 16% | 54% | data.world, sells KG tools (Opus) | [arXiv](https://arxiv.org/abs/2311.07509) |

**Company-measured results.** These are not controlled experiments. Sorted by function: data and AI first, then business outcomes.

| Who | What was measured | Without layer | With layer | Who ran it | Source |
|---|---|---|---|---|---|
| LinkedIn | Expert-judged SQL Bot answers | n/a | 53% correct or close; 95% of users rate it "Passes" | Company paper (Opus) | [arXiv](https://arxiv.org/abs/2507.14372) |
| Pinterest | Table-retrieval hit rate | 40% | 90% with documentation | Company, via secondary (Opus) | [ZenML](https://www.zenml.io/llmops-database/text-to-sql-system-with-rag-enhanced-table-selection) |
| Vercel | d0 agent on five queries, Cube files instead of 17 tools | 4/5, 274.8 s | 5/5, 77.4 s, −37% tokens | Company (Opus) | [Vercel](https://vercel.com/blog/we-removed-80-percent-of-our-agents-tools) |
| Uber | One prompt, context graph versus none | 20 min 9 s, wrong | 38 s, correct | Company, one example (both) | [Uber](https://www.uber.com/blog/efficient-software-factory/) |
| OpenAI | One question, memory versus none | 22+ min | 1 min 22 s | Company, one example (Opus) | [The Decoder](https://the-decoder.com/openai-develops-six-layer-context-system-to-help-employees-navigate-600-petabytes-of-data/) |
| Ramp | Questions answered in four weeks | 66 in human help channel | 1,476 by agent | Company (Opus) | [Ramp](https://engineering.ramp.com/post/meet-ramp-research) |
| Brex | Insight relevance | High 50s% | ~90% | **Vendor** (Cube) (Opus) | [Cube](https://cube.dev/case-studies/brex-embedded-ai-financial-analyst) |
| Diageo | New data product delivery | ~2 weeks | Hours ("test phase") | **Vendor** (Opus) | [Press release](https://www.01net.it/strategy-and-diageo-show-how-a-universal-context-layer-can-simplify-data-complexity-and-accelerate-ai-readiness-at-gartner-data-analytics-summit-london-2026/) |
| Diageo | Runtimes and data availability | n/a | 25% faster; 96% availability; not AI accuracy | **Vendor** (Astra) | [Strategy case](https://software.strategy.com/customer-stories/diageo) |
| Kimberly-Clark | Reports; diaper cost benchmarking | 30,000+ reports; 30,000 hours | ~2,000 reports; "a click" | **Vendor** (Opus) | [Snowflake](https://www.snowflake.com/en/customers/all-customers/case-study/kimberly-clark/) |
| PepsiCo | Onboarding time on governed platform | n/a | −30% | Company on vendor blog (both) | [Databricks](https://www.databricks.com/blog/how-pepsico-established-enterprise-grade-data-intelligence-platform-powered-databricks-unity) |
| General Mills | Logistics recommendations | n/a | >70% accepted; ~$14m/yr on part of network | **Vendor** (Opus) | [Palantir](https://www.palantir.com/assets/xrfr7uokpv1b/1aLBn65y83vdytjpXJKZcO/16989b788b34cb677f6d763d56a72349/Building_an_Intelligent_AI-Driven_Supply_Chain_at_General_Mills_-_AIPCon_March_-24_Impact_Study.pdf) |
| Lear | IDEA programme savings | n/a | >$30m in H1 2025 | Press (Opus) | [Supply Chain Dive](https://supplychaindive.com/news/lear-corp-palantir-technologies-ai-software-partnership-five-year/760396) |
| Siemens | Production plans needing human review | ~1,400 | 40 | **Vendor**, feasibility study (Opus) | [metaphactory](https://metaphactory.com/smart-manufacturing-planning-execution-at-siemens) |
| Wendy's co-op | Syrup shortage resolution | 15 people a full day | 5 minutes | Press (Opus) | [PYMNTS](https://www.pymnts.com/?p=2693145) |
| Nestlé | Consumer-service agent pilot | n/a | 40% autonomous resolution; CSAT 4.8/5 | **Vendor** (Opus) | [Salesforce](https://www.salesforce.com/customer-stories/nestle/agentic-consumer-service/) |
| US grocer (unnamed) | Campaign launch time | 3+ days | 4 hours; $5m+/yr | **Vendor** (Opus) | [Coginiti](https://coginiti.co/customers/major-grocery-retailer/) |
| Grupo Casas Bahia | Analysis time | Hours | 2 minutes | **Vendor** (Opus) | [Databricks case](https://www.casestudies.com/company/databricks/case-study/transforming-retail-strategies-with-advanced-consumer-insights) |
| Pizza Hut | Insight development; engineering cost | n/a | 50% faster; −30% | **Vendor**/investor (Astra) | [Snowflake](https://www.snowflake.com/en/blog/investment-honeydew-business-intelligence/) |
| Ritual | Hours saved; avoided cost | n/a | 10+ hours a week; up to $240,000 (estimate) | **Vendor** (Astra) | [Crisp](https://www.gocrisp.com/case-studies/ritual) |
| Fortune 100 CPG (unnamed) | Annual saving | n/a | "Up to $100m" (estimate) | **Vendor** (Opus) | [Palantir docs](https://palantir.com/docs/foundry/use-case-examples/optimizing-production-with-erp-data-across-the-supply-chain/) |
| Nestlé (SAP on Azure) | Incidents, resolution, availability | n/a | −80% critical incidents; 40% faster; 99.97% | **Vendor**; ERP migration, not a semantic layer (Astra) | [Microsoft](https://www.microsoft.com/en/customers/story/23963-nestle-azure) |
| P&G | Time to deploy a new model version | n/a | Up to −90%; a deployment metric, not quality | **Vendor** (Astra) | [Microsoft](https://www.microsoft.com/en/customers/story/25077-procter-and-gamble-iot-operations) |

**How to read the benchmarks.** The gain is largest on complex, multi-join questions over normalised schemas (Opus). The gap is narrowing: dbt's raw text-to-SQL on the same dataset rose from 32.7% with GPT-4 in 2023 to 64.5% in 2026 (Opus). The layer's typical win is no wrong numbers inside its scope; its typical loss is no answer outside it (both).

**Disagreement in reading, not in numbers.** Both reports quote the same dbt figures. Opus concludes data modelling added more than the semantic layer (+25.5 points versus +8.2). Astra reads the same table as support for "modelling plus governed execution" together, and says the preprint and dbt results differ by method, not contradiction.

### The sceptical view and risks

- **"A ceiling, not accuracy."** Zenlytic's CTO says a semantic layer "gives your agent a ceiling" because every question must be anticipated ([AI Council](https://www.aicouncil.com/talks/agents-are-eating-the-semantic-layer)). Zenlytic sells an alternative (Opus).
- **Coverage gaps.** The dbt semantic layer scored 0% on questions needing entity hops it did not model, in both 2023 and 2026 ([dbt](https://docs.getdbt.com/blog/semantic-layer-vs-text-to-sql-2026)) (both).
- **Garbage in, faster garbage out.** Vercel's simple agent worked only because the semantic layer was already well documented ([Vercel](https://vercel.com/blog/we-removed-80-percent-of-our-agents-tools)) (Opus).
- **Model coupling and drift.** MotherDuck's layer was tuned to one model; without evals an LLM-written layer "produces confident but flawed definitions" ([MotherDuck](https://motherduck.com/blog/oops-maybe-we-do-need-semantic-layers/)) (Opus).
- **Slow and hard to copy.** Airbnb's Minerva PM says table standardisation "can last years" and success is not "easily replicable" ([interview](https://roundup.getdbt.com/p/ep-1-robert-chang-on-scaling-metrics)). LinkedIn: "not yet easy to build a working enterprise solution" ([arXiv](https://arxiv.org/abs/2507.14372)) (Opus).
- **Satisfaction is not correctness.** LinkedIn's users rated 95% "Passes" while experts judged 53% correct or close (Opus).
- **No agreed definition.** MIT CISR (May 2026, 41 organisations) uses a broader meaning than a BI metric engine; only 21% of 2024 survey respondents reported well-developed curation ([MIT CISR](https://cisr.mit.edu/publication/2026_0501_SemanticLayer_LefebvreWixomLegnerVandermeulenBeath)) (Astra).
- **Consistent can still be wrong.** Shared definitions can reproduce a wrong accounting rule; a graph can hold stale links; retrieval can return an obsolete policy (Astra assessment). The controls are ownership, versioning, freshness, reconciliation and bounded decision authority, not the product (Astra).
- **Mixed-up benefits.** Keep three lines apart: observed versus modelled savings; platform modernisation versus semantic-layer effects; one domain versus enterprise coverage (Astra). Ritual's projection, Nestlé's migration metrics and dbt's coverage-dependent scores are the examples.
- **Thin ROI tracking.** BCG says more than half of CPG companies do not track AI ROI ([Consumer Goods Technology](https://consumergoods.com/how-cgs-unilever-pg-coca-cola-colgate-palmolive-establish-strong-foundations-scalable-ai)) (Opus).
- **Vendor-heavy evidence.** About half of the CPG and retail cases rest only on a vendor page, often with "test phase", "pilot", "estimated" or "up to" (Opus). No source gives a full audited package of duration, team, licence, cloud cost and ROI at Unilever or Nestlé scale (Astra).
