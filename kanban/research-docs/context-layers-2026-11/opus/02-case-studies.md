# Context layers and semantic layers: real company case studies (November 2026)

*Research slice 2 of 4: brief questions 1 (what for), 2 (how built), 3 (long-run value and measured results), 4 (time taken) and 9 (CPG and retail specifics). Written 16 November 2026. British spelling.*

---

## 0. How to read this report

**Source labels.** Every claim carries its URL inline. Each source also carries one of these labels, because the quality of evidence varies a great deal:

| Label | Meaning |
|---|---|
| **[Company]** | Written by the company itself (engineering blog, corporate newsroom, paper by its staff) |
| **[Vendor]** | Written or published by the supplier who sold the product. Numbers are marketing claims unless stated otherwise |
| **[Press]** | Independent trade or business press |
| **[Academic]** | Peer-reviewed paper or arXiv preprint |
| **[Secondary]** | Somebody else's summary of a primary source I could not open myself (noted each time) |
| **[AI notes]** | A machine-generated summary of a conference video. Lowest confidence; used only where nothing better exists |

**Access notes.** Several primary pages blocked automated fetching (Medium, OpenAI, Snowflake, Strategy, Gartner). I read those through a text-rendering proxy (r.jina.ai) and cite the original URL. Where even that failed I say so and either use a labelled secondary source or leave the claim out. Some Databricks Data + AI Summit session pages show a 2027 event header while their URLs and copyright say 2026; I give the year as "2026 (page dates inconsistent)".

**What "time taken" means here.** Very few companies publish an honest timeline. Where one is given I quote it exactly and say what phase it covers (pilot, first domain, enterprise). Where it is missing I say "not stated".

---

## 1. Headline findings

1. **The most detailed, best-measured examples are still from technology companies** (Uber, OpenAI, Spotify, LinkedIn, Airbnb, Netflix, Ramp, Block, Vercel, Pinterest, Snowflake itself). They publish architecture, adoption and sometimes accuracy. CPG and retail companies mostly appear in **vendor** case studies with outcome claims but little method.

2. **In CPG, the clearest named semantic-layer programmes in 2025-26 are Diageo (Strategy Mosaic), Kimberly-Clark (Snowflake, 400-KPI library), Mars (Databricks Genie over an HR common data model), Carrefour (AtScale), Nestlé (Salesforce Tableau Semantics over Snowflake, zero-copy) and PepsiCo (Databricks Unity Catalog plus Salesforce Data 360 zero-copy).** The clearest ontology programmes are General Mills, Heineken, Lear and Wendy's on Palantir, plus IKEA's in-house knowledge graph. I found **no public semantic-layer or ontology case** for Tesco, Target, Kroger, Mondelez, Kraft Heinz, Danone, Reckitt, Colgate-Palmolive or The Coca-Cola Company itself.

3. **Three building styles dominate.** *Metrics-first* (define KPIs once as code: Airbnb Minerva, Diageo, Carrefour, Kimberly-Clark, Mercedes-Benz Korea). *Ontology-first* (model the business objects and their relationships: Palantir customers, Netflix UDA, IKEA, Siemens, Bosch). *Context-graph or retrieval-first* for agents (index metadata, query history, code and documents, then let the agent search: Uber, OpenAI, Spotify, LinkedIn, Ramp, Block, Pinterest). The agent-era programmes almost all **combine** a governed metric layer with a retrieval layer over everything else.

4. **LLMs are now used to bootstrap context, but humans still gate it.** OpenAI uses Codex to derive table meaning from pipeline code; Pinterest and Block use LLMs to write table summaries; Mercedes-Benz Korea auto-converted 500+ Power BI DAX measures; dbt's 2026 benchmark used LLM-written models. But Spotify's curators **accepted only 12.5% of LLM-proposed question-and-SQL pairs** ([Spotify](https://engineering.atspotify.com/2026/6/encoding-your-domain-expert-the-context-layer-behind-spotifys-data-assistant)), and every mature programme keeps domain owners in the loop.

5. **Measured value: the direction is consistent, the size is not independently verified.** Published with-versus-without comparisons all favour adding semantics: 16% to 54% (data.world, knowledge graph, 2023), 20% to 92.5% (AtScale, vendor, 2024), 64.5% to 72.7% overall but ~50-65% to ~100% on in-scope questions (dbt, vendor, 2026), 57% to 78% (Snowflake on BIRD, vendor), "up to two-thirds fewer errors" (Google Looker, vendor, no method), 17-23 points (Cube, vendor). **Every one of these except the 2023 academic paper comes from a company selling a semantic layer.** No independent, multi-company benchmark exists.

6. **The strongest gains in the latest benchmarks come from data modelling, not from the semantic layer product.** In dbt's own 2026 run, adding three LLM-generated models lifted plain text-to-SQL from 64.5% to 90.0% before any semantic layer was involved ([dbt](https://docs.getdbt.com/blog/semantic-layer-vs-text-to-sql-2026)). The semantic layer's distinctive value is that it **refuses** rather than returns a plausible wrong number.

7. **Timelines that are published:** Airbnb Minerva took about **three years** from start (mid-2017) to company-wide source of truth (2020), starting with **one engineer**. Kimberly-Clark went from **500+ data lakes to one in two years**. PepsiCo's Unity Catalog data foundation was a **~four-year** programme by mid-2024. Mars built its GenAI platform in **12 months**. Nestlé launched its first agent in **eight weeks**; each new country takes eight weeks. General Mills' Palantir foundation began in **2019** and its supply chain agent was saving **$14m a year** by 2024 on part of the network. Palantir's anonymised Fortune 100 CPG integrated **7+ ERPs in five days**. LinkedIn's SQL Bot took **over a year** before its 2024 write-up. Heineken's US team built in **three months** what an earlier programme had taken three years to build.

8. **Agent-era results are mostly about speed and adoption, not accuracy.** Uber: correct answer in 38 seconds with the context graph versus a wrong answer after 20 minutes without it (one example). OpenAI: 22 minutes to 1 minute 22 seconds with memory. Ramp: 1,476 questions answered by the agent versus 66 in the human help channel over four weeks. Spotify: 2,100+ users, a quarter of whom had never written SQL. Few publish accuracy; LinkedIn is the honest exception at **53% correct or close** on an expert-reviewed benchmark.

9. **The sceptical case is real and comes from practitioners.** A semantic layer "gives your agent a ceiling" (Zenlytic's CTO); it answers only what was modelled (dbt's own data shows 0% on unmodelled multi-hop questions); it only helps if the underlying data is already well documented (Vercel); metric standardisation is slow and "not easily replicable" (Airbnb's Minerva PM). Gartner, meanwhile, predicts organisations that prioritise semantics will raise agentic AI accuracy by up to 80% and cut costs by up to 60% by 2027.

10. **Store versus connect, as seen in the cases:** most CPGs **consolidate first** (Kimberly-Clark, PepsiCo, CONA, Diageo's data hub, L'Oréal, Mars) and then put semantics and agents on top. **Zero-copy or federation** appears at the edges: Salesforce Data 360 reading Snowflake/Databricks in place at Nestlé and PepsiCo, BigQuery Omni at L'Oréal, virtual knowledge graphs at Bosch, federation in Siemens' knowledge graph, and IKEA's option to virtualise its data layer.

---

## 2. Summary table

"Store/connect": **Store** = copy into a central warehouse/lakehouse; **Connect** = query in place (federation, zero-copy, virtual graph); **Hybrid** = both. "Time" = what the source states. Labels as in section 0.

| # | Company | Sector | What they built | Tools | Store / connect | Time taken (as stated) | Result (as stated) | Source |
|---|---|---|---|---|---|---|---|---|
| 1 | Unilever | CPG | Reusable data products; graph AI lab; order-handling agent "Nova" feeding SAP; supply chain app | Databricks + Unity Catalog (Azure), moving to Google Cloud; Microsoft agents; Sigma | Store (consolidating to one Google Cloud environment) | Five-year Google Cloud deal; no semantic-layer timeline | Digital twin +10% capacity at Raeford plant; regression model across ~$52.4bn turnover; up to half a day saved per day in supply chain analysis | [Press](https://ciodive.com/news/unilever-tailors-ai-focus-business-outcomes/832799), [Press](https://consumergoods.com/how-cgs-unilever-pg-coca-cola-colgate-palmolive-establish-strong-foundations-scalable-ai), [Vendor](https://www.databricks.com/dataaisummit/session/sponsored-sigma-how-unilever-optimizes-supply-chain-inventory-sigma-and) |
| 2 | Diageo | CPG (spirits) | Universal semantic/"context" layer: one NSV definition across Power BI, Qlik, Excel and AI agents; conversational "Autobot" in BPM product | Strategy Mosaic over Databricks, Snowflake, BigQuery | Hybrid (central data hub + virtual semantic layer) | Test phase; avoided "15 to 18 months" project cycles | New data products in hours instead of ~2 weeks (test phase); ~400 users of BPM AI | [Vendor](https://www.01net.it/strategy-and-diageo-show-how-a-universal-context-layer-can-simplify-data-complexity-and-accelerate-ai-readiness-at-gartner-data-analytics-summit-london-2026/), [Vendor](https://www.strategy.com/software/blog/how-diageo-scales-enterprise-ai-with-a-governed-semantic-layer) |
| 3 | Kimberly-Clark | CPG | One enterprise data lake; 400-KPI library; natural-language query; agent orchestration layer | Snowflake, Tredence | Store | 500+ data lakes to one **in two years** | 28,000 reports removed; 70% faster ingestion; cost benchmarking that took 30,000 hours now "a click"; data backs >$800m of a $3bn savings goal | [Vendor](https://www.snowflake.com/en/customers/all-customers/case-study/kimberly-clark/) |
| 4 | Mars | CPG | HR common data model + Genie agents with semantic views and business context ("associate 360"); separate GenAI platform | Azure Databricks, Unity Catalog, Genie; Tiger Analytics; Tredence | Store | GenAI platform built in **12 months**; HR model not dated | 200 to 28,000 AI users in 12 months; $0.15/query; HR answers without waiting days | [Vendor](https://www.databricks.com/customers/mars/genie), [Press](https://www.cdomagazine.tech/data-analytics/why-a-common-data-model-became-vital-to-mars-analytics-evolution), [Vendor](https://www.tredence.com/forrester-mars-casestudy) |
| 5 | PepsiCo | CPG | Global Data Foundation with catalog/lineage; demand forecasting with Genie; retailer "single business profile" in CRM | Azure Databricks, Unity Catalog, Genie; Salesforce Data 360 + Agentforce; Snowflake | Hybrid (central lakehouse + zero-copy federation into Salesforce) | Data foundation **~4 years** to mid-2024; 5-year Salesforce/PwC roadmap | 6 PB, 1,500 users, 30+ product teams; onboarding −30%; forecasting 80%+ accuracy, −60% compute | [Company/Vendor](https://www.databricks.com/blog/how-pepsico-established-enterprise-grade-data-intelligence-platform-powered-databricks-unity), [Vendor](https://www.salesforce.com/customer-stories/pepsico-data-360/), [Vendor](https://www.databricks.com/dataaisummit/session/game-day-global-scale-how-pepsico-foods-uses-ai-feed-world-cup) |
| 6 | Nestlé | CPG | Consumer-service agent grounded via zero-copy product data hub and Tableau Semantics KPIs; marketing CDP with golden records | Salesforce Agentforce, Data 360, Tableau Semantics, Snowflake; Treasure Data | Connect (zero-copy) for agent; Store for CDP | First agent **in 8 weeks**; each new country 8 weeks | 40% autonomous resolution (pilot); CSAT 4.8/5; Mexico CTR +71%, cost per lead −49% | [Vendor](https://www.salesforce.com/customer-stories/nestle/agentic-consumer-service/), [Vendor](https://www.treasure.ai/customers/nestle-global-cpg) |
| 7 | General Mills | CPG | Palantir Ontology over 200 master/operational tables; "ELF" logistics agent | Palantir Foundry, AIP | Store (integrated into Foundry) | Partnership **from 2019**; results reported March 2024 | >70% of recommendations accepted; ~$40k/day, ~$14m/yr on part of network | [Vendor](https://www.palantir.com/assets/xrfr7uokpv1b/1aLBn65y83vdytjpXJKZcO/16989b788b34cb677f6d763d56a72349/Building_an_Intelligent_AI-Driven_Supply_Chain_at_General_Mills_-_AIPCon_March_-24_Impact_Study.pdf) |
| 8 | Heineken | CPG (beer) | Enterprise metadata catalog across 100+ opcos; US supply chain apps on Palantir | Genpact PowerMe; Palantir Foundry | Connect (catalog of metadata) + Store (Foundry) | US Palantir build **3 months** vs 3 years previously | Catalog of 6.7m tables, 95m columns, 42,800 BI reports; Palantir results not quantified | [Vendor](https://preview.genpact.com/content/dam/genpact/web/documents/From_outdated_to_cutting_edge_US.pdf.coredownload.inline.pdf), [AI notes](https://readray.ai/notes/en/palantir-aipcon-20251112/ai-driven-supply-chain-heineken-aipcon) |
| 9 | Fortune 100 CPG (unnamed) | CPG | Supply chain digital twin across 7+ ERPs | Palantir Foundry | Store | 7+ ERPs integrated **in 5 days**; BOM workflow in 1 week | "Up to $100m" estimated annual saving | [Vendor](https://palantir.com/docs/foundry/use-case-examples/optimizing-production-with-erp-data-across-the-supply-chain/) |
| 10 | AB InBev | CPG (beer) | Materials master data governance; "semantic digital twins" of materials across 11 ERPs | Creactives | Hybrid | Not stated | −40% new material requests year 1; 15% duplicates found; €100m+ excess inventory identified | [Vendor](https://www.creactives.com/?p=5523) |
| 11 | Coke One North America (11 Coca-Cola bottlers) | CPG (bottling) | Shared SAP-fed data products; experimenting with semantic layers and LLM interfaces | Fivetran SAP CDC, Snowflake on Azure | Store (load once, share to bottlers) | ~1-year tool evaluation; full CDC by mid-2022 | 35,000 users on near-real-time SAP data | [Vendor](https://www.fivetran.com/de/case-studies/coke-one-north-america-accelerates-real-time-sap-insights-for-35-000-users) |
| 12 | Coca-Cola Bottling Co. United | CPG (bottling) | Persona-mapped GenAI BI assistant over warehouses | Decision Point "Beagle" | Store | Pilot (Jan 2025) | None reported | [Press](https://consumergoods.com/coca-cola-united-testing-generative-ai-tool-streamline-data-access) |
| 13 | P&G | CPG | R&D ontology (<500 core concepts) and materials-management ontology; AI Factory; data from 100+ plants to Azure | Semantic Arts; Microsoft Azure IIoT | Store (plants to Azure) | AI Factory from ~2021; ontology undated | Ontology became basis for replacing many systems with one | [Vendor](https://www.semanticarts.com/case-study-proctor-and-gamble), [Press](https://www.cdomagazine.tech/aiml/inside-pgs-ai-factory-how-the-global-consumer-goods-giant-balances-ai-scale-with-local-business-relevance), [Press](https://erp.today/pg-and-microsoft-co-innovate-to-build-the-future-of-digital-manufacturing/) |
| 14 | L'Oréal | CPG (beauty) | Beauty Tech Data Platform; "data products as a service"; cross-cloud query | Google BigQuery, BigQuery Omni | Hybrid (central BigQuery + Omni to avoid moving data) | Not stated (2022 post) | 100 TB, 8,000+ governed datasets, ~5,000 users | [Company](https://cloud.google.com/blog/products/serverless/loreal-combines-google-cloud-serverless-and-data-offerings) |
| 15 | Walmart | Retail | Semantic layer under "Wally" merchant assistant; Retail Graph product knowledge graph | In-house; Azure Cosmos DB (Gremlin), Hadoop | Store | Retail Graph built category by category from Home & Garden | No figures published | [Company](https://corporate.walmart.com/news/2025/03/18/walmart-develops-genai-powered-assistant-for-walmart-merchants), [Company](https://medium.com/walmartglobaltech/retail-graph-walmarts-product-knowledge-graph-6ef7357963bc) |
| 16 | IKEA | Retail | IKEA Knowledge Graph: hundreds of concepts, thousands of categories, automated data layer | W3C semantic stack, git, OpenAPI services | Hybrid (data layer persisted or virtualised) | Not stated; strategy moved centralised to decentralised by 2025 | Powers product recommendations; planned Digital Product Passports | [Company](https://medium.com/flat-pack-tech/ikeas-knowledge-graph-and-why-it-has-three-layers-a38fca436349), [Conference](https://backend.henrystewartconferences.com/session/events-semantic-data-europe-2025-bridging-physical-and-digital-ikea-knowledge-graph) |
| 17 | Carrefour | Retail | Migrated ~3,000 KPIs from a BI-tool semantic layer to a universal one; Sheets plus conversational analytics | AtScale; Google Sheets connector | Connect (virtual semantic layer) | Hard deadline; dates not stated | Same governed metrics in Sheets; chatbots planned on same layer | [Vendor](https://www.atscale.com/blog/carrefour-universal-semantic-layer/) |
| 18 | Kingfisher | Retail (DIY) | Merged 40 glossaries into one with 4,000+ KPIs and terms | Collibra on Azure | Connect (catalog) | Not stated | 750 analysts using it | [Vendor](https://www.casestudies.com/company/collibra/case-study/collibra-improves-customer-engagement-for-european-diy-retailer-kingfisher) |
| 19 | Groupement Mousquetaires | Retail (grocery) | Governed data products and naming standards across ~700 workspaces | Databricks Unity Catalog | Store | DataHub since 2019; 3 pilot migrations; target 100% by 2025 | Qualitative only | [Vendor](https://databricks.com/blog/transforming-retail-data-governance-groupement-mousquetaires-journey-unity-catalog) |
| 20 | Grupo Casas Bahia | Retail | Natural-language analytics in Portuguese via Teams | Databricks AI/BI Genie | Store | Not stated | Analysis from hours to 2 minutes | [Vendor](https://www.casestudies.com/company/databricks/case-study/transforming-retail-strategies-with-advanced-consumer-insights) |
| 21 | US grocer (unnamed) | Retail (grocery) | Semantic layer over 100+ sources and 1,000+ customer attributes, used by BI, ML and agents | Coginiti | Hybrid | Not stated | Campaign launch 3+ days to 4 hours; $5m+/yr | [Vendor](https://coginiti.co/customers/major-grocery-retailer/) |
| 22 | Wendy's supply chain co-op | Restaurant supply chain | Real-time supply chain twin over 6,450 restaurants | Palantir | Store | Not stated | Syrup shortage solved in 5 minutes vs 15 people for a day | [Press](https://www.pymnts.com/?p=2693145) |
| 23 | Lear | Manufacturing (auto parts) | Enterprise ontology across manufacturing, supply chain, quality, finance | Palantir Foundry, AIP, Warp Speed | Store | Since **2023**; 5-year expansion Sept 2025 | >$30m saved H1 2025 (IDEA programme) | [Press](https://supplychaindive.com/news/lear-corp-palantir-technologies-ai-software-partnership-five-year/760396), [Job post](https://app.qureos.com/jobs/enterprise-ontology-leader-idea-by-lear-1773460751303) |
| 24 | Siemens | Manufacturing | Manufacturing knowledge graph for production planning/execution | metaphactory, Ephedra federation, Teamcenter, MES | Hybrid (triple store + federation) | Feasibility study, then plant integration | Plans to review fell from ~1,400 to 40 | [Vendor](https://metaphactory.com/smart-manufacturing-planning-execution-at-siemens) |
| 25 | Bosch | Manufacturing | Ontology-based virtual knowledge graph over plant data (SMT lines) | OWL 2 QL ontology, VKG mappings | Connect (virtual) | Paper 2020 | "Promising" expressivity and performance | [Academic](https://www.inf.unibz.it/~calvanese/papers-html/ISWC-2020-bosch.html) |
| 26 | Mercedes-Benz Korea | Manufacturing/auto sales | 500+ KPIs as metric views auto-converted from Power BI DAX; persona agents | Databricks metric views, Genie, Agent Bricks | Store | Pilot ("beginning of journey") | "Hundreds of hours" saved on migration; target 100% match to Power BI | [Vendor](https://www.databricks.com/blog/unlocking-semantics-ai-how-mercedes-benz-korea-built-trusted-talk-data-scale) |
| 27 | Uber | Tech | Context graph for coding/data agents (24m nodes, 80m edges, 30+ systems) | In-house; MCP gateway | Store (integrated graph) | Not stated | 38 s correct vs 20 min wrong (one example) | [Company](https://www.uber.com/blog/efficient-software-factory/) |
| 28 | Uber (QueryGPT) | Tech | Text-to-SQL with domain "workspaces" and agents | In-house, GPT-4 Turbo, vector search | Store | Hackathon May 2023, 20+ iterations to Sept 2024 | 10 min to ~3 min per query; 300 DAU; 78% say time saved | [Company](https://www.uber.com/blog/query-gpt/) |
| 29 | Uber (Finch) | Tech/finance | Finance agent on single-table marts + alias index | OpenSearch, LangGraph, Slack | Store | Not stated | No accuracy published | [Company](https://www.uber.com/us/en/blog/unlocking-financial-insights-with-finch/) |
| 30 | OpenAI | Tech | Data agent with six context layers incl. Codex-derived table meaning and memory | GPT-5.2, Codex, embeddings, MCP | Store (offline enrichment) + live queries | Not stated | 22 min to 1 min 22 s with memory (one example) | [Company](https://openai.com/index/inside-our-in-house-data-agent/) |
| 31 | Spotify | Tech | Context layer: 177 expert-owned domain clusters of datasets, Q-SQL pairs and docs | In-house, MCP, Slack | Store | Live since Aug 2025 | 2,100+ users, 13,000+ conversations; 12.5% of LLM-proposed pairs accepted | [Company](https://engineering.atspotify.com/2026/6/encoding-your-domain-expert-the-context-layer-behind-spotifys-data-assistant) |
| 32 | LinkedIn | Tech | SQL Bot with knowledge graph of tables, fields, query logs, jargon | DataHub, in-house | Store | **Over a year** before Dec 2024 | 53% correct or close (expert review); 95% users rate "passes" | [Academic](https://arxiv.org/abs/2507.14372), [Secondary](https://www.zenml.io/llmops-database/building-a-production-text-to-sql-assistant-with-multi-agent-architecture) |
| 33 | Airbnb | Tech | Minerva metric platform: 12,000 metrics, 4,000 dimensions | Airflow, Hive, Spark, Presto, Druid | Store (pre-computed) | Mid-2017 start, one engineer; source of truth by 2020 | Company-wide SSOT; COVID exec dashboard in "a few days" | [Company](https://medium.com/airbnb-engineering/how-airbnb-achieved-metric-consistency-at-scale-f23cc53dea70), [Interview](https://roundup.getdbt.com/p/ep-1-robert-chang-on-scaling-metrics) |
| 34 | Netflix | Tech | Unified Data Architecture: knowledge graph linking concepts to schemas; "model once, represent everywhere" | RDF, SHACL, named graphs | Hybrid (maps to existing containers) | Not stated | Less manual reconciliation in ads; auto-generated queries | [Press](https://www.infoq.com/news/2025/12/netflix-upper-uda-architecture) |
| 35 | Ramp | Fintech | "Ramp Research" Slack analyst agent on indexed dbt/Looker/Snowflake metadata + expert docs | dbt, Looker, Snowflake | Store | Launched early August (year not on page) | 1,476 agent answers vs 66 human-channel answers in 4 weeks; question volume 10-20x | [Company](https://engineering.ramp.com/post/meet-ramp-research) |
| 36 | Block | Fintech | "Query Expert" MCP agent: table, query and business-knowledge indexes | Databricks Vector Search, GitHub | Store | Launched July 2025 | ~3,500 monthly users; analysis days to hours | [Company talk](https://answers.databricks.com/query-expert-building-rag-powered-data-agents-at-enterprise-scale-IpInyhpaXq0) |
| 37 | Vercel | Tech | d0 data agent reading a Cube semantic layer as files | Cube, Claude, bash tool | Store | v1 "built over months" | 80% to 100% success; 3.5x faster; 37% fewer tokens (5 queries) | [Company](https://vercel.com/blog/we-removed-80-percent-of-our-agents-tools) |
| 38 | Pinterest | Tech | Text-to-SQL with LLM table summaries in a vector index | OpenSearch, Querybook | Store | Not stated | Table retrieval 40% to 90% with docs; 35% faster task completion | [Secondary](https://www.zenml.io/llmops-database/text-to-sql-system-with-rag-enhanced-table-selection) |
| 39 | Snowflake (internal) | Tech | Internal semantic views as a "golden layer" for BI and agents | Snowflake semantic views, Cortex Agents, dbt | Store | Not stated | July 2025: 5,600+ staff ran 320,000+ queries via the semantic layer | [Company/Vendor](https://www.snowflake.com/en/blog/snowflake-internal-context-layer-for-ai-agents/) |
| 40 | Brex | Fintech | Embedded AI finance analyst on a semantic layer + certified queries | Cube Cloud | Store | Not stated | Insight relevance high-50s% to ~90% | [Vendor](https://cube.dev/case-studies/brex-embedded-ai-financial-analyst) |

---

## 3. CPG case studies in detail (brief question 9 first)

### 3.1 Unilever

**What is public.** Unilever has not published a description of a semantic layer or ontology. What it has said:

- **Data products as the base for AI.** Unilever North America's CDIO Allen Bates told CIO Dive (13 October 2026) that the company has built reusable data products "so teams don't have to start from scratch as AI scales", and that codified knowledge is shared across markets. His framing: "AI loves context, context loves data, that's where we start." [Press](https://ciodive.com/news/unilever-tailors-ai-focus-business-outcomes/832799)
- **Platform move.** Unilever plans to move enterprise applications and its data platform to Google Cloud under a five-year partnership, using Vertex AI and Gemini for "an enterprise-wide intelligence system", to create "one connected environment for scaling AI". [Press](https://p2pi.com/unilever-links-marketing-data-and-ai-prepare-agentic-commerce-era), [Press](https://ciodive.com/news/unilever-tailors-ai-focus-business-outcomes/832799)
- **Current stack is Azure Databricks.** Databricks' customer page says Unilever uses Azure Databricks with Unity Catalog for governance and lineage, and near-real-time retail data for inventory and forecasting [Vendor](https://www.databricks.com/customers/unilever). A Data + AI Summit session (2026, page dates inconsistent) by Unilever's Phillip Nelson describes a supply chain "command center" built with Sigma on Databricks that cuts manual inventory-gap analysis by up to half a day [Vendor](https://www.databricks.com/dataaisummit/session/sponsored-sigma-how-unilever-optimizes-supply-chain-inventory-sigma-and). **Note the tension:** the Databricks material describes Azure, the 2026 announcement describes moving the data platform to Google Cloud. I found nothing explaining how the two fit.
- **Agents.** Unilever is building agents with Microsoft [Press](https://ciodive.com/news/unilever-tailors-ai-focus-business-outcomes/832799). At a Consumer Goods Technology event (August 2026) its head of customer operations, Graham Sommer, described an agent called **Nova** that processes 23 million orders and emails before data enters the SAP backbone, plus "eight other global agents", with Microsoft, Capgemini and Genpact as partners; a regression model "is now running across about [$52.4 billion] of our turnover". [Press](https://consumergoods.com/how-cgs-unilever-pg-coca-cola-colgate-palmolive-establish-strong-foundations-scalable-ai)
- **Graph technology.** In November 2023 Unilever opened Horizon3 Labs in Toronto, its first global AI lab, focused initially on forecasting and "modeling data relationships with graph technology"; the head of data science for North America described graph use for recommendation engines. No results were reported. [Press](https://consumergoods.com/unilever-accelerating-ai-graph-technology-new-global-lab)
- **Results quoted.** An AI digital twin raised capacity 10% at the Raeford, North Carolina plant; the Beauty AI Studio produced assets up to 30% faster [Press](https://ciodive.com/news/unilever-tailors-ai-focus-business-outcomes/832799).

**Not found.** No Unilever-Palantir case; no Unilever semantic-layer vendor; no timeline for its data products. A job advert for a "workforce digital twin" knowledge layer appeared in search results but had expired when I tried to open it, so I do not rely on it.

### 3.2 Diageo

The best-documented CPG **semantic layer for AI** I found, but every source is the vendor.

- **Problem.** Despite investments in Databricks, Snowflake and Google BigQuery, business teams "waited weeks for trusted data", Finance, Sales and regional teams "were not always working from the same numbers", and data engineers spent their time maintaining pipelines. [Vendor press release, 9 June 2026](https://www.01net.it/strategy-and-diageo-show-how-a-universal-context-layer-can-simplify-data-complexity-and-accelerate-ai-readiness-at-gartner-data-analytics-summit-london-2026/)
- **What was built.** Strategy Mosaic, sold as a "Universal Context Layer", sits between the data platforms and Power BI, Qlik, Excel and AI agents; business definitions are created once and governed centrally, including **one Net Sales Value (NSV) definition across tools and teams**. Data still lands in "the Diageo data hub, a centralized data warehouse". [Vendor](https://www.01net.it/strategy-and-diageo-show-how-a-universal-context-layer-can-simplify-data-complexity-and-accelerate-ai-readiness-at-gartner-data-analytics-summit-london-2026/), [Vendor blog, 20 April 2026](https://www.strategy.com/software/blog/how-diageo-scales-enterprise-ai-with-a-governed-semantic-layer)
- **Operating model.** Diageo moved from project delivery to a product-driven model because it "can no longer afford to spend 15 to 18 months building a solution before seeing results" [Vendor](https://www.strategy.com/software/blog/how-diageo-scales-enterprise-ai-with-a-governed-semantic-layer). Its joint deck shows a 14-step data product lifecycle from use-case value definition through certification to "Deploy into Marketplace" [Vendor deck](https://assets.contentstack.io/v3/assets/bltb564490bc5201f31/bltc17d84cf7c5a888e/The%20AI%20Cocktail%20with%20Strategy%20and%20Diageo.pdf).
- **First AI use.** An "Autobot" embedded in the Global Business Performance Management product (P&L, daily sales, volume/mix/price/cost drivers) answers questions such as "what is driving gross profit"; adoption rose across "roughly 400 users" [Vendor](https://www.strategy.com/software/blog/how-diageo-scales-enterprise-ai-with-a-governed-semantic-layer). The deck shows answers in 175 s (novice), 75 s (expert) and 20 s (with agents) [Vendor deck](https://assets.contentstack.io/v3/assets/bltb564490bc5201f31/bltc17d84cf7c5a888e/The%20AI%20Cocktail%20with%20Strategy%20and%20Diageo.pdf).
- **Results and caveat.** New data products that took about two weeks "now take hours". The release's own footnote says the results are "based on Diageo's test phase with Strategy" [Vendor](https://www.01net.it/strategy-and-diageo-show-how-a-universal-context-layer-can-simplify-data-complexity-and-accelerate-ai-readiness-at-gartner-data-analytics-summit-london-2026/). Diageo's spokesperson was Előd Fejér, Head of Finance and Legal DA&I. Function served: **finance and commercial performance management**.

### 3.3 Kimberly-Clark

The clearest CPG example of the **consolidate, then define KPIs once, then add natural language and agents** sequence, with a stated timeline. Vendor source.

- Before: 500 "shadow" data lakes and more than 30,000 reports; "People were spending time creating metrics that they couldn't agree on" (Global CTO Ray Bajaj). Benchmarking diaper manufacturing cost took 40 people, 30,000 hours and six months. [Vendor](https://www.snowflake.com/en/customers/all-customers/case-study/kimberly-clark/)
- Built with Tredence on Snowflake: "We went from more than 500 data lakes to one enterprise data lake **in two years**." A **library of 400 KPIs** was established and about 28,000 unnecessary reports eliminated, leaving close to 2,000. Ingestion time to value fell 70%. [Vendor](https://www.snowflake.com/en/customers/all-customers/case-study/kimberly-clark/)
- Uses: supply chain cost analysis across 18,000 SKUs "with a click", revenue growth management (pricing, promotion, retailers), R&D (60 years of data in one place), digital marketing. A natural-language interface answers questions such as "the market share for Huggies in the Northeast U.S."; next is "a consistent orchestration layer through agents". [Vendor](https://www.snowflake.com/en/customers/all-customers/case-study/kimberly-clark/)
- Long-run goal: data initiatives back more than $800m of a four-year, $3bn supply chain savings target. The "$1 billion" in the page title comes from the partner Tredence's executive, not from Kimberly-Clark. [Vendor](https://www.snowflake.com/en/customers/all-customers/case-study/kimberly-clark/)

### 3.4 Mars

Two separate programmes, both partner-built.

- **People analytics on a common data model.** Mars' People & Organisation data office built a common data model across recruiting, performance, compensation, core HR and learning ("associate 360", "hire to retire"), then Databricks Genie agents per persona, with "semantic views and business context so that Genie would understand Mars terminology" and a day-level link table that Genie checks first, which "improved accuracy and performance and reduced hallucinations". Partner: Tiger Analytics. The public demo used synthetic data and no dates are given. [Vendor](https://www.databricks.com/customers/mars/genie)
- **Why the context layer.** Mars' HR Data Officer Rachel Belino names the **context layer** as one of three foundations for "AI for BI", alongside prompt visibility and persona-driven orchestration. The team deliberately **built the front end while the back end caught up**, because starting from data requests "led to low adoption" and proving front-end value makes it easier to justify costly foundation work. [Press (CDO Magazine, 12 March 2026)](https://www.cdomagazine.tech/data-analytics/why-a-common-data-model-became-vital-to-mars-analytics-evolution)
- **GenAI platform.** Mars' MAX platform, built with Tredence over **12 months** across Google, Microsoft and AWS, grew from 200 to 28,000 users with 2.5 million queries at an average $0.15 per query. Next steps include "deeper data integration". [Vendor](https://www.tredence.com/forrester-mars-casestudy)

### 3.5 PepsiCo

- **Data foundation (catalog-first).** Written by two PepsiCo data leaders on Databricks' blog (6 June 2024): the PepsiCo Data Foundation consolidates **over 6 PB**, serves 1,500+ active users and 30+ digital product teams; the effort began **about four years** earlier; Unity Catalog gives lineage over 7,000 bronze and 1,000 silver tables from 150 sources, and row/column security on 50+ restricted finance, HR and R&D tables; onboarding time fell 30%. No business glossary is described. [Company/Vendor](https://www.databricks.com/blog/how-pepsico-established-enterprise-grade-data-intelligence-platform-powered-databricks-unity)
- **Demand planning with an AI interface.** PepsiCo Foods runs about 125 million weekly forecast combinations on Databricks with "80%+ DSD accuracy", 60% lower compute after leaving on-premises, and uses **Genie to query demand drivers**, with plans for agentic root-cause analysis. Speaker: Michael Cleavinger, VP Global Data Science. [Vendor (DAIS 2026, page dates inconsistent)](https://www.databricks.com/dataaisummit/session/game-day-global-scale-how-pepsico-foods-uses-ai-feed-world-cup)
- **Sales and marketing (connect, not copy).** Salesforce Data 360 reads receipt, product and Experian data held in Snowflake and processed in Databricks through a **zero-copy file federation connection**, and harmonises it into a single business profile per store across snacks and beverages ("One PepsiCo"). Agentforce covers trade promotion management, retailer service and field service. A five-year roadmap with PwC; **no measured outcomes** yet (January 2026). [Vendor](https://www.salesforce.com/customer-stories/pepsico-data-360/)

### 3.6 Nestlé

- **Consumer service agent (connect).** Nestlé's Agentforce agent reads ingredients data from the product data hub in Snowflake through a **zero-copy connector** "without duplicating or moving it", crawls brand websites, and uses **Tableau Semantics** to give the agent governed definitions of NPS, first-time resolution and average handling time. First agent launched **in eight weeks**; each new country takes eight weeks, with technical deployment "as little as two weeks". Pilot result: 40% autonomous case resolution and 4.8/5 CSAT. Covers 2,000+ brands, 185 countries. (23 October 2026) [Vendor](https://www.salesforce.com/customer-stories/nestle/agentic-consumer-service/)
- **Marketing data (golden record).** With Treasure Data, Nestlé Mexico built a "golden record" per customer with deduplication, linked to Meta, DV360, TikTok, Amazon and Salesforce; Brazil consolidated 16 of 18 business units. Claimed: $4.9m saved in paid media and CRM, CTR +71%, cost per lead −49% (Mexico); $5m incremental revenue in 2025 (Brazil). Customer since 2022. [Vendor](https://www.treasure.ai/customers/nestle-global-cpg)
- **Not found.** Any Nestlé statement on SAP Business Data Cloud, an enterprise semantic layer or a knowledge graph.

### 3.7 Procter & Gamble

- **Ontologies (older).** Semantic Arts built P&G an R&D ontology with **fewer than 500 core concepts** covering all of R&D (10,000+ staff), extended per discipline and turned into a semantic wiki, partly to capture knowledge from retiring scientists; and a materials-management ontology (starting in Product Safety and Regulatory) that "became the basis for a project to replace many existing systems with one semantic-driven system". Undated; treat as historical. [Vendor](https://www.semanticarts.com/case-study-proctor-and-gamble)
- **AI Factory.** P&G launched its "AI Factory" around 2021 to standardise model deployment; business teams fund much of the work [Press](https://www.cdomagazine.tech/aiml/inside-pgs-ai-factory-how-the-global-consumer-goods-giant-balances-ai-scale-with-local-business-relevance). CIO Seth Cohen in 2026: "data discipline isn't glamorous, but it's the difference between AI theatre and AI as a competitive advantage" [Press](https://consumergoods.com/how-cgs-unilever-pg-coca-cola-colgate-palmolive-establish-strong-foundations-scalable-ai).
- **Manufacturing data.** The June 2022 Microsoft partnership digitises and integrates data from **more than 100 manufacturing sites** on Azure (IIoT, edge, digital twins) for predictive quality, predictive maintenance and controlled release [Press](https://erp.today/pg-and-microsoft-co-innovate-to-build-the-future-of-digital-manufacturing/).
- **Not found.** A current P&G semantic layer, metric layer or enterprise knowledge graph.

### 3.8 Heineken

- **Catalog-first.** Genpact's PowerMe active-metadata platform gives Heineken a single catalog across **100+ operating companies: 6.7 million tables and views, 95 million columns, 42,800 BI reports**, with automated connectors to SAP and Azure and lineage. Its first purpose was to prioritise assets for cloud migration by usage. Undated. [Vendor](https://preview.genpact.com/content/dam/genpact/web/documents/From_outdated_to_cutting_edge_US.pdf.coredownload.inline.pdf)
- **Ontology-first in US supply chain.** At an AIPCon event (video published around April 2025), Heineken's operations chief (named in the automated transcript as "Lawrence Vro"; I could not confirm the spelling) described joining Palantir after attending AIPCon in September 2024, then building apps that flag stock-outs, prioritise containers to avoid demurrage, and swap shipments between destinations two days before loading. Data: brewery, warehouse and customer inventory and sales plus satellite ocean-freight tracking (about 33,000 containers a year into nine US demand points, 66,000 trucks to ~450 customers). A tiger team built **in three months** what an earlier Power BI programme took three years to build. Not yet in production at the time. [AI notes](https://readray.ai/notes/en/palantir-aipcon-20251112/ai-driven-supply-chain-heineken-aipcon). Treat as low confidence.

### 3.9 General Mills

Palantir's own impact study (AIPCon, March 2024): when General Mills and Palantir began in **2019** they built "a connected data foundation on the Palantir Ontology by integrating **200 master and operational data tables**" as a single source of truth. Project ELF, on AIP, reads constraints, capacity and network cost in real time across 4,000 suppliers and 200+ plants; **over 70% of its recommendations are accepted** by a human; "about $40k dollars a day, which is about $14M annually – and it's really only deployed to part of our network" (Dave Jackett, Sr Director Supply Chain Digital Transformation). Function: **supply chain/logistics**. [Vendor](https://www.palantir.com/assets/xrfr7uokpv1b/1aLBn65y83vdytjpXJKZcO/16989b788b34cb677f6d763d56a72349/Building_an_Intelligent_AI-Driven_Supply_Chain_at_General_Mills_-_AIPCon_March_-24_Impact_Study.pdf)

### 3.10 Coca-Cola system

- **Coke One North America (CONA)**, the IT shared-service for 11 bottlers (>$35bn revenue): Snowflake on Azure, fed by Fivetran SAP change-data-capture (chosen after nearly a year's evaluation with Capgemini, full CDC by mid-2022), loaded once and shared to bottlers with partner-level row security. ~35,000 users. Bottlers "are beginning to experiment with semantic layers and LLM-driven interfaces." [Vendor](https://www.fivetran.com/de/case-studies/coke-one-north-america-accelerates-real-time-sap-insights-for-35-000-users)
- **Coca-Cola Bottling Co. United** piloted Decision Point's "Beagle" GenAI BI assistant (January 2025), with use cases (sales performance, cooler placement, delivery execution) mapped to personas and access levels; no results. [Press](https://consumergoods.com/coca-cola-united-testing-generative-ai-tool-streamline-data-access)
- **The Coca-Cola Company** itself: its CFO spoke in 2026 of "data consolidation challenges due to its network complexity" [Press](https://consumergoods.com/how-cgs-unilever-pg-coca-cola-colgate-palmolive-establish-strong-foundations-scalable-ai). No semantic-layer case found.

### 3.11 AB InBev

Creactives (vendor) describes master data governance across **11 ERPs, 3.25 million materials and 200+ plants**, using "AI combined with Knowledge Engineering" to build "Semantic Digital Twins" of materials in six languages. Claimed: 40% fewer new material master requests in year one, 15% duplicates found, €100m+ excess inventory identified. No dates. [Vendor](https://www.creactives.com/?p=5523). This is the clearest CPG example of **MDM plus a taxonomy as the translation layer** between ERPs.

### 3.12 L'Oréal

L'Oréal's enterprise architect wrote (March 2022) that its Beauty Tech Data Platform on Google Cloud holds 100 TB in BigQuery, more than 8,000 governed datasets, about two million tables and 8,500 flows used by about 5,000 people; it ingests from SAP, Salesforce, Microsoft and Google Ads; delivers "data products as a service"; and uses **BigQuery Omni** to query across clouds without moving sensitive data, which was "expensive... and sometimes prohibited by local regulations". [Company](https://cloud.google.com/blog/products/serverless/loreal-combines-google-cloud-serverless-and-data-offerings). Search results showed L'Oréal job adverts for a "Universal Semantic Layer" modeller and a "Business Knowledge Graph" architect (Collibra, TIBCO EBX, BigQuery), but both links returned 404 when opened, so I record this only as an unverified signal.

### 3.13 CPG and retail companies where I found nothing usable

Tesco, Target, Kroger/84.51°, Mondelez, Kraft Heinz, Danone, Reckitt, Colgate-Palmolive (beyond LLM training figures), The Coca-Cola Company, Henkel (an SAP page about a HANA Cloud knowledge graph pilot blocked access), and Ingka specifically (IKEA sources do not say which IKEA entity runs the knowledge graph). Consumer Goods Technology quotes BCG's Peri Edelstein that **more than half of CPG companies do not track AI ROI** [Press](https://consumergoods.com/how-cgs-unilever-pg-coca-cola-colgate-palmolive-establish-strong-foundations-scalable-ai), which helps explain the thin evidence.

---

## 4. Retail, restaurant and manufacturing case studies

### 4.1 Walmart

- **Wally (March 2025).** Walmart's merchant assistant handles data analysis, root-cause analysis of product performance and calculations. Walmart "created a semantic layer" so Wally can interpret proprietary data that public-trained models handle badly. No figures; no named spokesperson. [Company](https://corporate.walmart.com/news/2025/03/18/walmart-develops-genai-powered-assistant-for-walmart-merchants)
- **Retail Graph (March 2020, older).** A product knowledge graph linking SKUs to abstract entities ("farmhouse style", "kid-friendly") and concrete ones (colour), plus substitute/complement relationships from text and image embeddings. Entities are extracted with NLP and heuristics, linked by context ("cherry" is a scent for candles, a finish for furniture), and **triples below a confidence threshold go to human validation**. Stored as a labelled property graph in Azure Cosmos DB (Gremlin), built on Hadoop. Built **one category at a time, starting with Home & Garden**. [Company](https://medium.com/walmartglobaltech/retail-graph-walmarts-product-knowledge-graph-6ef7357963bc)

### 4.2 IKEA

Katariina Kari (IKEA, August 2022) described the IKEA Knowledge Graph in three layers: **concepts** ("in the number of hundreds", authored centrally by ontologists, "something one can take home... over the weekend and learn by heart"), **categories** (a controlled vocabulary "in the number of thousands", authored by subject-matter experts across the business), and **data** (all products, generated automatically and test-driven, with ownership remaining at the source "as also stated by the data mesh idea"). Concepts and categories live in **git** with releases and automated QA. The data layer can be **persisted or virtualised**, and she warns that persisting without clear ownership creates "multiple deferring copies". [Company](https://medium.com/flat-pack-tech/ikeas-knowledge-graph-and-why-it-has-three-layers-a38fca436349). By June 2025 IKEA's lead ontologist Christelle Maignan described "a shift from a centralised to a decentralised strategy", with metadata defining roles "from ontologies to named graphs, down to individual attributes", product recommendations live and Digital Product Passports (EU ESPR) planned [Conference](https://backend.henrystewartconferences.com/session/events-semantic-data-europe-2025-bridging-physical-and-digital-ikea-knowledge-graph). A separate talk's summary: "a little semantics goes a long way" [Conference](https://watch.knowledgegraph.tech/videos/knowledge-graph-enhanced-product-catalogue).

### 4.3 Carrefour

Carrefour's Head of Enterprise Analytics, Nicolas Treanton, presented at the 2026 Semantic Layer Summit a migration of **26 models, about 3,000 KPIs and 1,000+ users** from a semantic layer bundled with a BI vendor's portal ("The semantic layer's only goal was to provide self-service BI") to AtScale's tool-independent layer, under a hard deadline. AtScale and Carrefour co-developed a Google Sheets connector, which became the main interface; conversational analytics routed through the same layer is in progress. No start or end dates. [Vendor, 23 June 2026](https://www.atscale.com/blog/carrefour-universal-semantic-layer/)

### 4.4 Kingfisher, Groupement Mousquetaires, Grupo Casas Bahia, an unnamed US grocer

- **Kingfisher** (1,900+ stores, eight countries) merged **forty siloed glossaries into one business glossary of 4,000+ KPIs, terms and definitions** in Collibra on Azure; 750 analysts use it. [Vendor](https://www.casestudies.com/company/collibra/case-study/collibra-improves-customer-engagement-for-european-diy-retailer-kingfisher)
- **Groupement Mousquetaires** (4,300+ stores) moved ~700 Databricks workspaces to Unity Catalog with naming standards, three pilot migrations and a playbook; business squads migrated their own data products and dropped those due to be retired within six months; target 100% by 2025. [Vendor, May 2025](https://databricks.com/blog/transforming-retail-data-governance-groupement-mousquetaires-journey-unity-catalog)
- **Grupo Casas Bahia** (Brazil) uses Genie in Portuguese through Teams; "analysis time dropped from hours to just 2 minutes". [Vendor](https://www.casestudies.com/company/databricks/case-study/transforming-retail-strategies-with-advanced-consumer-insights)
- **A US grocer** with thousands of stores in 30+ states (unnamed) defined customers, transactions, products, stores and promotions once across 100+ sources and 28 divisions, resolving 1,000+ inconsistently defined customer attributes; BI, ML and agents share it. Claimed: campaign launch from 3+ days to 4 hours, $5m+ a year. [Vendor](https://coginiti.co/customers/major-grocery-retailer/)

### 4.5 Wendy's and Walgreens (Palantir)

Palantir built a real-time twin of Wendy's Quality Supply Chain Co-op network (6,450 restaurants, 34 distribution centres, 250+ shipping points) replacing Excel. In a syrup shortage it found 8,300 of 10,200 needed cases elsewhere in the network and computed 3,500 to order; resolution took five minutes versus "15 people a full day" (co-op CEO Pete Suerken). The same article reports that Walgreens' data was integrated in **under 45 days** and scaled from a 10-store pilot to 4,000 stores in **eight months**. [Press, 29 April 2025](https://www.pymnts.com/?p=2693145)

### 4.6 Manufacturing: Siemens, Bosch, Lear, Mercedes-Benz Korea

- **Siemens.** Its Corporate Technology "Semantics and Reasoning" group built a manufacturing knowledge graph combining Teamcenter bill-of-materials and bill-of-process data with MES, using metaphactory and its Ephedra **federation** engine over a triple store and external sources. In the planning use case, plans needing human review fell from **about 1,400 to 40** for new orders; the stack was integrated into a running automation plant. Framed as a feasibility study. [Vendor](https://metaphactory.com/smart-manufacturing-planning-execution-at-siemens)
- **Bosch.** The "SIB" framework (ISWC 2020) maps an OWL 2 QL ontology for surface-mount technology lines onto plant data as a **virtual knowledge graph**, so quality analyses written as SPARQL queries run without copying data into a graph store. [Academic](https://www.inf.unibz.it/~calvanese/papers-html/ISWC-2020-bosch.html)
- **Lear.** Working with Palantir since 2023; in September 2025 a five-year expansion across quality, supply chain, procurement, manufacturing, finance and design; the IDEA programme saved over $30m in H1 2025 [Press](https://supplychaindive.com/news/lear-corp-palantir-technologies-ai-software-partnership-five-year/760396). A Lear job advert for an "Enterprise Ontology Leader" describes a unified Foundry/AIP ontology spanning Seating, E-Systems, Manufacturing, Supply Chain, Quality, Engineering, Finance and Commercial, with governance, versioning and approval workflows, and an internal ontology team [Job post](https://app.qureos.com/jobs/enterprise-ontology-leader-idea-by-lear-1773460751303).
- **Mercedes-Benz Korea.** A "Talk to Data" pilot put **500+ KPI definitions** into Databricks metric views, generated by an automated **DAX-to-metric-view transpiler** from existing Power BI models (flagging measures for manual review), so BI and AI share one semantic layer; persona agents (CFO, Sales VP) sit under a supervisor. Target: 100% match between Genie answers and Power BI for every in-scope KPI; whether this was met is not stated. [Vendor, June 2026](https://www.databricks.com/blog/unlocking-semantics-ai-how-mercedes-benz-korea-built-trusted-talk-data-scale)

---

## 5. Technology company case studies

### 5.1 Uber: three layers of context

- **Context graph (August 2026).** For its coding and data agents Uber built a context graph of **24 million nodes, 80 million edges, 86 node types and 117 edge types**, integrating 30+ internal systems (services, teams, incidents, pull requests, design docs, deployments, datasets, historical table-usage queries), queryable in natural language. In the one comparison published, with the graph an agent found the right table (used by 50+ analysts) in **38 seconds**; without it, the same prompt and model ran **20 minutes 9 seconds**, spawned two sub-agents, hit three errors and wrongly concluded the data was unqueryable. No aggregate accuracy, token or cost figures. [Company](https://www.uber.com/blog/efficient-software-factory/)
- **QueryGPT (September 2024).** From a May 2023 hackathon through 20+ iterations. Uber runs ~1.2 million interactive queries a month. Curated **workspaces** (12 system workspaces such as Mobility, Ads) narrow retrieval; agents classify intent, pick tables and prune columns. Manual query ~10 minutes versus ~3 with QueryGPT; ~300 daily active users in a limited release; 78% reported time saved. Lesson: hallucinated tables and columns remain unsolved. [Company](https://www.uber.com/blog/query-gpt/)
- **Finch (July 2025).** A finance agent in Slack runs on **curated single-table data marts** plus an OpenSearch index of column names, values and natural-language aliases ("US&C", "GBs"). Evaluated against golden queries by result; no accuracy published. [Company](https://www.uber.com/us/en/blog/unlocking-financial-insights-with-finch/)

### 5.2 OpenAI (January 2026)

OpenAI's internal data agent serves 3,500+ users over **600 PB and 70,000 datasets** and is used by Engineering, Data Science, Go-To-Market, Finance and Research. It has **six context layers**: table usage (schemas, lineage, historical queries); human annotations; **Codex enrichment** (deriving each table's meaning from the pipeline code, refreshed automatically); institutional knowledge from Slack, Google Docs and Notion (embedded with permissions, including "canonical definitions and computation logic for key metrics"); **memory** of user corrections; and runtime queries. A daily offline pipeline merges the first three into one normalised representation, embedded for retrieval. [Company](https://openai.com/index/inside-our-in-house-data-agent/). On one question the agent took over 22 minutes without memory and 1 minute 22 seconds with it [Press](https://the-decoder.com/openai-develops-six-layer-context-system-to-help-employees-navigate-600-petabytes-of-data/).

### 5.3 Spotify (June 2026)

Spotify's data assistant spans **70,000+ datasets** organised into **177 domain clusters**, each owned by data scientists and analytics engineers and containing datasets (schemas, profiling, sample values), vetted question-and-SQL pairs, and documents (terminology, team-specific definitions, columns to avoid). Since August 2025, **2,100+ users**, 13,000+ conversations; over a quarter of users had never written SQL. When the team used an LLM to generate pairs from query history, **curators accepted only 12.5%**, so expert review stayed mandatory. Each cluster has a monitored health score. No accuracy figures. [Company](https://engineering.atspotify.com/2026/6/encoding-your-domain-expert-the-context-layer-behind-spotifys-data-assistant)

### 5.4 LinkedIn (2024-2025)

SQL Bot's knowledge graph holds users, table clusters, tables and fields, built from DataHub metadata, query logs, certified notebooks and user-submitted domain knowledge. It took **over a year** before the December 2024 write-up, with a virtual team and experts from 10 product areas defining 130+ benchmark questions; integration into the existing notebook tool raised adoption 5-10x; 95% of surveyed users rated accuracy "Passes" or above [Secondary](https://www.zenml.io/llmops-database/building-a-production-text-to-sql-assistant-with-multi-agent-architecture). The July 2025 paper reports 300+ weekly users and that **53% of responses were correct or close to correct** on expert review, adding "it is not yet easy to build a working enterprise solution" [Academic](https://arxiv.org/abs/2507.14372). **Note the gap** between user satisfaction (95%) and expert-judged correctness (53%).

### 5.5 Airbnb Minerva (2017-2021)

Minerva is Airbnb's metric platform and "single source of truth for analytics, reporting, and experimentation": **12,000+ metrics, 4,000+ dimensions, 200+ data producers**; definitions in a central GitHub repository with code review; built on Airflow, Hive, Spark, Presto and Druid; it pre-computes denormalised aggregates. During COVID the central analytics team built an executive dashboard "in just under a few days" because the metrics already existed. [Company, April 2021](https://medium.com/airbnb-engineering/how-airbnb-achieved-metric-consistency-at-scale-f23cc53dea70). Timeline from its PM Robert Chang: started **mid-2017** with **one engineer, not full time**; alpha/beta users in 2018; API in 2019; company-recognised source of truth in 2020; "a four-year effort, still ongoing". His lessons: standardise tables first ("table standardization can last years"), hire strong data modellers, and he does not believe Airbnb's success is "easily replicable". [Interview, July 2021](https://roundup.getdbt.com/p/ep-1-robert-chang-on-scaling-metrics)

### 5.6 Netflix UDA (2025)

Netflix's Unified Data Architecture is a knowledge graph connecting business concepts to schemas and data containers, built on an in-house metamodel, **Upper**, on W3C RDF and SHACL. Each domain model is owned by a team as a named graph; one concept definition is projected to GraphQL, Avro, Iceberg, SQL and Java ("model once, represent everywhere"). Early adopters: Primary Data Management, Operational Reporting, Content Production, and **Advertising and Personalisation**, which aligned campaign, promotion and targeting definitions and reduced manual reconciliation. No quantitative results. [Press, December 2025](https://www.infoq.com/news/2025/12/netflix-upper-uda-architecture)

### 5.7 Ramp, Block, Vercel, Pinterest, Snowflake, Brex, BetterUp, JetBlue

- **Ramp Research.** A Slack analyst agent over thousands of tables; Ramp "aggregated and indexed" metadata from dbt, Looker and Snowflake, and domain owners wrote documentation organised as a file system the agent reads. Since an early-August launch: 1,800+ questions, 300 users; in four weeks 1,476 questions answered by the agent versus 66 in the human #help-data channel. Evaluation is a Python mini-framework inside the dbt project that checks tool calls, tables and query shape; no accuracy figure. The page carries no year. (I did not find the "memory pipeline" named in the brief on Ramp's blog.) [Company](https://engineering.ramp.com/post/meet-ramp-research)
- **Block Query Expert.** Launched July 2025; about 3,500 monthly users across five business units; ~20,000 tables documented out of an estimated 200 million objects, with descriptions generated by an LLM job in Databricks and human-verified tables boosted; a "business knowledge store" (demographics, benchmarks, strategy definitions, terminology) kept in **GitHub as source of truth**, receiving 15-20 pull requests a week from bots and humans; analysis turnaround "days to hours". No accuracy metrics. [Company talk](https://answers.databricks.com/query-expert-building-rag-powered-data-agents-at-enterprise-scale-IpInyhpaXq0)
- **Vercel d0.** Replacing 17 specialised tools with a bash tool that reads the **Cube semantic layer stored as YAML/Markdown files** moved success from 4/5 to 5/5 queries, average time 274.8 s to 77.4 s, tokens −37%. Caveat in their words: it worked only because the semantic layer was already well documented; messy naming and undocumented joins would just produce faster bad queries. [Company, December 2025](https://vercel.com/blog/we-removed-80-percent-of-our-agents-tools)
- **Pinterest.** LLM-generated table summaries (from schema plus recent queries) indexed in OpenSearch; table-retrieval hit rate was 40% without documentation and rose roughly linearly to 90% with it; first-shot acceptance rose from 20% to over 40%; 35% faster SQL task completion (not controlled for difficulty). [Secondary summary of Pinterest's 2024 post, which I could not open](https://www.zenml.io/llmops-database/text-to-sql-system-with-rag-enhanced-table-selection)
- **Snowflake (internal).** Snowflake runs its own semantic views as "a single trusted API for our data"; in July 2025 more than 5,600 employees and agents ran over 320,000 queries through the semantic layer across sales, HR and support. Practices: version and CI/CD the semantic layer via dbt, use popular dashboard tiles as the eval set, materialise slices for speed. [Company/Vendor, August 2026](https://www.snowflake.com/en/blog/snowflake-internal-context-layer-for-ai-agents/)
- **Brex.** An AI finance workspace for 35,000+ customers on Cube Cloud with a domain semantic layer, analyst-certified queries and about 10 agent rules that replaced 3,000+ lines of prompts; insight relevance from "high 50s to nearly 90%". [Vendor](https://cube.dev/case-studies/brex-embedded-ai-financial-analyst)
- **BetterUp.** Dashboards, Cube's agent, Claude (via MCP) and the customer reporting app read one set of metrics. [Vendor](https://cube.dev/case-studies/betterup-governed-ai-analytics)
- **JetBlue (2023, older).** BlueBot, an LLM over corporate data on Databricks with role-based access (finance sees SAP, operations sees maintenance). No semantic layer mentioned. [Press](https://www.constellationr.com/insights/news/how-jetblue-leveraging-ai-llms-be-most-data-driven-airline-world)
- **Shopify, Stripe.** I found no primary Shopify or Stripe engineering post describing an internal semantic or context layer (Shopify's enterprise blog only recommends one in general terms).

---

## 6. Question 1: what are companies using these layers FOR?

| Function | Named examples (sections above) | What the layer does |
|---|---|---|
| **Supply chain and demand planning** | General Mills (ELF), Heineken US, Wendy's, Fortune 100 CPG, Kimberly-Clark, PepsiCo forecasting, Unilever command centre, Lear, AB InBev materials | Joins orders, inventory, capacity, freight and cost into one model so recommendations or alerts can be computed across the network |
| **Finance and performance management** | Diageo BPM (NSV, gross profit drivers), Uber Finch, Kimberly-Clark cost of sales, Snowflake, Brex | One definition of revenue/NSV/cost across BI tools and agents |
| **Sales, revenue growth management, trade** | Kimberly-Clark RGM, PepsiCo trade promotion and store profiles, CCBCU sales performance, Walmart Wally (merchants), Diageo commercial | Shared metrics for pricing, promotion and retailer performance; natural-language queries for sales teams |
| **Marketing, advertising, customer 360** | Nestlé golden record CDP, PepsiCo Data 360, Netflix ads and personalisation definitions, US grocer customer attributes, Carrefour | Identity resolution and consistent campaign/targeting definitions; audiences fed to media platforms |
| **Manufacturing, OT, quality, R&D** | Siemens planning, Bosch SMT quality, P&G plants and R&D ontology, Unilever Raeford twin, Lear shop floor, Kimberly-Clark R&D | Ontologies that tie machines, bills of material and quality data to products |
| **HR / people** | Mars associate 360, PepsiCo restricted HR tables, Snowflake HR queries | Cross-domain people questions answered without analyst queues |
| **Product catalogue and customer experience** | IKEA (recommendations, Digital Product Passports), Walmart Retail Graph, Nestlé consumer service agent | Product knowledge graphs and governed product data for customer-facing AI |
| **AI agents / text-to-SQL for all staff** | Uber, OpenAI, Spotify, LinkedIn, Ramp, Block, Vercel, Pinterest, Casas Bahia, Mercedes-Benz Korea | Context retrieval and governed metrics so agents pick the right table and definition |
| **Data estate rationalisation** | Heineken catalog, Kingfisher glossary, Groupement Mousquetaires, Kimberly-Clark (28,000 reports removed) | Discover, deduplicate and retire before migrating or adding AI |

---

## 7. Question 2: HOW are they building them?

### 7.1 Four approaches seen in practice

1. **Metrics-first.** Define metrics and dimensions as code, version-controlled, and serve them to every tool. Airbnb (GitHub, code review, 2017-2020), Snowflake internal (dbt CI/CD), Diageo (Strategy Mosaic), Carrefour (AtScale), Kimberly-Clark (400-KPI library), Mercedes-Benz Korea (500+ metric views), Vercel and Brex (Cube). Strength: deterministic numbers. Weakness: answers only what was modelled.
2. **Ontology-first.** Model business objects (plant, SKU, customer, order, container) and their links, then build applications and agents on top. Palantir customers (General Mills, Heineken, Lear, Wendy's, Fortune 100 CPG), Netflix UDA, IKEA, P&G, Siemens, Bosch. Strength: supports actions and multi-hop reasoning across domains. Weakness: needs ontologists and, with Palantir, data integrated into the platform. EY's April 2026 advice to consumer products firms follows this route: start from a reusable "core consumer products ontology" (product, customer, order, promotion, inventory), formalise glossaries and rules into it, then map it to existing sources "without replacing systems"; it names no client results ([Consultancy](https://www.ey.com/en_us/insights/consumer-products/ontologies-as-the-missing-layer-in-enterprise-ai)).
3. **Catalog-first.** Inventory and govern what exists, often to prepare a migration, then add glossary and lineage. Heineken (6.7m tables), Kingfisher (40 glossaries into 1), PepsiCo and Groupement Mousquetaires (Unity Catalog), CONA. Often the precursor to the other two.
4. **Context-graph or retrieval-first (agent era).** Index everything an expert would consult (schemas, query history, pipeline code, documents, Slack, corrections) and let the agent retrieve. Uber, OpenAI, Spotify, LinkedIn, Ramp, Block, Pinterest. These almost always sit **on top of** a governed metric layer or curated marts (Uber Finch's marts, Ramp's dbt/Looker, Spotify's vetted pairs).

### 7.2 Recurring steps

Across the cases that describe their process, the order is broadly:

1. **Pick a narrow, high-value domain and persona.** LinkedIn: "start with high-ROI pain points"; Uber: target the right initial personas; Mars: start with people analytics; Diageo: start with the BPM product; Walmart: one category (Home & Garden); Heineken: US West Coast.
2. **Standardise tables or consolidate first.** Airbnb rebuilt core tables before Minerva; Kimberly-Clark consolidated 500 lakes; PepsiCo built its foundation over four years.
3. **Define the shared vocabulary.** A small core authored centrally (IKEA: hundreds of concepts; P&G: <500 concepts; Kimberly-Clark: 400 KPIs) and a larger periphery authored by domain experts (IKEA: thousands of categories; Spotify: 177 expert-owned clusters; Kingfisher: 4,000+ terms).
4. **Store definitions as code.** Git for IKEA's ontology, Airbnb's metrics, Block's knowledge store, Snowflake's semantic views.
5. **Build evals from real questions.** Snowflake uses popular dashboard tiles; LinkedIn's 130+ expert questions; Uber's golden set; Ramp's dbt test framework; Spotify's health scores.
6. **Ship to where people already work** (Slack, Teams, Sheets, the notebook tool). LinkedIn saw 5-10x adoption from embedding; Carrefour moved users to Sheets.
7. **Keep it alive.** Spotify's health scores, Block's 15-20 pull requests a week, OpenAI's daily enrichment pipeline.

### 7.3 Use of LLMs to bootstrap definitions

| Who | What the LLM does | Human gate |
|---|---|---|
| OpenAI | Codex derives each table's meaning from pipeline code; refreshed automatically | Human annotations layer; memory of corrections ([Company](https://openai.com/index/inside-our-in-house-data-agent/)) |
| Pinterest | Writes table and query summaries for retrieval | Only top-tier tables indexed ([Secondary](https://www.zenml.io/llmops-database/text-to-sql-system-with-rag-enhanced-table-selection)) |
| Block | Generates table descriptions and example queries daily | Verified tables boosted; GitHub PRs ([Company talk](https://answers.databricks.com/query-expert-building-rag-powered-data-agents-at-enterprise-scale-IpInyhpaXq0)) |
| Spotify | Infers question-SQL pairs from query history | **12.5% accepted** by curators ([Company](https://engineering.atspotify.com/2026/6/encoding-your-domain-expert-the-context-layer-behind-spotifys-data-assistant)) |
| Mercedes-Benz Korea | Transpiles 500+ DAX measures into metric views | Flags measures for manual review ([Vendor](https://www.databricks.com/blog/unlocking-semantics-ai-how-mercedes-benz-korea-built-trusted-talk-data-scale)) |
| dbt benchmark | LLM wrote three dbt models with no hand-written code | Benchmark scoring ([Vendor](https://docs.getdbt.com/blog/semantic-layer-vs-text-to-sql-2026)) |
| MotherDuck experiment | Claude Opus authored and refined a hierarchical semantic layer | "Only when it is continuously tested against an eval set" ([Vendor](https://motherduck.com/blog/oops-maybe-we-do-need-semantic-layers/)) |
| Snowflake | Its coding assistant drafts semantic views | Code review, evals ([Company/Vendor](https://www.snowflake.com/en/blog/snowflake-internal-context-layer-for-ai-agents/)) |
| Walmart Retail Graph (2020, pre-LLM) | NLP extracts and links entities | Triples below a confidence threshold reviewed by humans ([Company](https://medium.com/walmartglobaltech/retail-graph-walmarts-product-knowledge-graph-6ef7357963bc)) |

### 7.4 Team structures that are described

- **Airbnb:** one part-time engineer at the start, a data scientist turned PM, then partnership with company reporting teams ([Interview](https://roundup.getdbt.com/p/ep-1-robert-chang-on-scaling-metrics)).
- **IKEA:** a central team of ontologists owns concepts; subject-matter experts own categories; source systems own data ([Company](https://medium.com/flat-pack-tech/ikeas-knowledge-graph-and-why-it-has-three-layers-a38fca436349)).
- **LinkedIn:** a virtual team with domain experts from priority product areas ([Secondary](https://www.zenml.io/llmops-database/building-a-production-text-to-sql-assistant-with-multi-agent-architecture)).
- **Spotify, Ramp:** domain owners (data scientists, analytics engineers) own their slice of context.
- **Diageo:** cross-functional product teams replacing temporary project teams ([Vendor](https://www.strategy.com/software/blog/how-diageo-scales-enterprise-ai-with-a-governed-semantic-layer)).
- **Mars:** P&O Data Office with business translators and analysts, plus Tiger Analytics.
- **Heineken US:** a "tiger team" with Palantir.
- **Lear:** an internal ontology team under an enterprise ontology leader.
- **Kimberly-Clark, Mars, PepsiCo (forecasting), CONA:** a systems integrator or specialist partner (Tredence, Tiger, Capgemini, PwC) in nearly every CPG case.

---

## 8. Question 3: long-run goals, measured results and the sceptical view

### 8.1 Stated long-run goals

- **One number everywhere**, in every tool including agents: Diageo ("trusted metrics can be defined once, governed centrally, and delivered into AI"), Carrefour, Snowflake ("golden layer"), Airbnb ("define once, use everywhere"), Netflix ("model once, represent everywhere").
- **Speed of delivery**: Diageo's data products in hours; Kimberly-Clark's 70% faster ingestion; Mars proving value before foundation spend.
- **Cost and savings targets**: Kimberly-Clark's $3bn supply chain goal; General Mills' $14m/yr; Lear's $30m in six months.
- **Agents that act, not just answer**: Walmart's plan for Wally to take tactical actions "within configurable guardrails" ([Company](https://corporate.walmart.com/news/2025/03/18/walmart-develops-genai-powered-assistant-for-walmart-merchants)); Kimberly-Clark's agent orchestration layer; PepsiCo's agentic root-cause analysis; Unilever's "assistant to teammate".
- **Regulation and product data**: IKEA's Digital Product Passports under the EU ESPR.
- **Analyst framing**: Gartner (May/June 2026, Rita Sallam) predicts that by 2027 organisations prioritising semantics in AI-ready data will raise agentic AI accuracy by up to 80% and cut costs by up to 60%, and advises building "a context layer as a core part" of data and analytics infrastructure ([Press](https://idm.net.au/node/15619)). Gartner's February 2025 prediction: 60% of AI projects lacking AI-ready data will be abandoned through 2026; 63% of organisations lacked confidence in their data management for AI ([Press](https://www.freevacy.com/news/gartner/gartner-reveals-60-of-ai-projects-with-data-issues-will-fail/6155)). These are predictions, not measurements.

### 8.2 Benchmarks: LLM answer accuracy with versus without semantics

| Study | Who ran it | Setup | Without | With | Notes |
|---|---|---|---|---|---|
| Sequeda, Allemang, Jacob (Nov 2023) | data.world (now ServiceNow) | Insurance schema; GPT-4 zero-shot; questions over SQL vs over a knowledge graph | 16% | 54% | The only academic, pre-product benchmark; same group sells KG tools ([Academic](https://arxiv.org/abs/2311.07509)) |
| Allemang, Sequeda (May 2024) | data.world | Adds ontology-based query check plus LLM repair | (54%) | 72% | Plus 8% "I don't know", 20% error ([Academic](https://arxiv.org/abs/2405.11706)) |
| AtScale (Aug 2024) | AtScale | 40 questions on TPC-DS; Gemini 1.5 Pro; few-shot on raw schema vs semantic layer + engine | 20% | 92.5% | 100% on easier questions; errors only on the most complex ([Press](https://www.hpcwire.com/bigdatawire/2024/08/15/atscale-claims-text-to-sql-breakthrough-with-semantic-layer/)); open benchmark repo ([Vendor](https://www.atscale.com/blog/public-leaderboard-text-to-sql-tasks/)) |
| dbt Labs (Apr 2026) | dbt Labs | Sequeda's insurance dataset; 11 questions × 20 runs; Sonnet 4.6, GPT-5.3 Codex etc. | 64.5% (all Qs, raw schema) | 72.7% (all Qs); ~100% on in-scope Qs | On modelled schema: text-to-SQL 90.0% / 84.1%, semantic layer 98.2% / 100%. 2023 GPT-4: 32.7% vs 60.5% ([Vendor](https://docs.getdbt.com/blog/semantic-layer-vs-text-to-sql-2026)) |
| Snowflake (2024-25) | Snowflake | Internal 150-question BI set | GPT-4o single prompt: 51% | Cortex Analyst "90%+", "nearly 2x" GPT-4o | Joins >90% ([Vendor](https://www.snowflake.com/en/engineering-blog/cortex-analyst-text-to-sql-accuracy-bi/), [Vendor](https://www.snowflake.com/en/engineering-blog/cortex-analyst-joins-star-snowflake-schemas/)) |
| Snowflake on BIRD (2025) | Snowflake, via Atlan | Claude 3.5 Sonnet vanilla vs with semantic model, 4 datasets | 57% | 78% | Reported by Atlan; I could not open the Snowflake original ([Secondary](https://atlan.com/know/snowflake/cortex-analyst-vs-text-to-sql/)) |
| Google Looker (May 2025) | Google | "Internal testing" | n/a | Up to two-thirds fewer errors | No method published ([Vendor](https://cloud.google.com/blog/products/business-intelligence/how-lookers-semantic-layer-enhances-gen-ai-trustworthiness)) |
| Cube (2026) | Cube | "Paired LLM benchmark across three frontier models" | n/a | +17 to +23 points | No method on page ([Vendor](https://cube.dev/case-studies/betterup-governed-ai-analytics)) |
| MotherDuck (2026) | MotherDuck | DABStep payments benchmark, 440 Qs | Vector retrieval ~88%; knowledge baked into warehouse ~93% | Hierarchical semantic layer 100% | Layer authored by an LLM under eval ([Vendor](https://motherduck.com/blog/oops-maybe-we-do-need-semantic-layers/)) |
| Spider 2.0 (Nov 2024, rev. Mar 2025) | Academic | 632 real enterprise workflows | o1-preview agent: 21.3% (vs 91.2% Spider 1.0, 73.0% BIRD) | n/a | Shows why raw text-to-SQL on enterprise schemas fails ([Academic](https://arxiv.org/abs/2411.07763)) |

**Company-measured effects (not controlled benchmarks):** LinkedIn 53% correct-or-close; Pinterest table retrieval 40% to 90% with documentation; Vercel 80% to 100% on five queries; Brex relevance high-50s to ~90% (vendor); Uber 38 s correct vs 20 min wrong; OpenAI 22 min to 1 min 22 s.

**What the numbers say, read carefully.**
- Every benchmark favours adding business semantics, and the effect is largest on **complex, multi-join** questions over **normalised** schemas.
- The gap is **narrowing** as models improve: dbt's text-to-SQL accuracy on the same dataset doubled from 32.7% (GPT-4, 2023) to 64.5% (2026), and to 90% once the data was modelled.
- The semantic layer's characteristic win is **no wrong numbers inside its scope**; its characteristic loss is **no answer outside it** (0% on dbt's "too many hops" questions, in 2023 and 2026).
- **Almost every figure is vendor-run, on small question sets** (11 to 150 questions, one dataset). I found no independent, multi-company study.

### 8.3 Business results reported (as claimed)

- Time: Diageo two weeks to hours (test phase); Casas Bahia hours to 2 minutes; US grocer 3+ days to 4 hours; Wendy's a day to 5 minutes; Uber 10 to 3 minutes per query; Kimberly-Clark 30,000-hour analysis to "a click"; Block days to hours; Unilever up to half a day a day.
- Money: General Mills ~$14m/yr; Lear >$30m in H1 2025; Fortune 100 CPG "up to $100m" (estimate); AB InBev €100m+ inventory identified; US grocer $5m+/yr; Nestlé Mexico $4.9m media savings; Kimberly-Clark data backing >$800m of savings target.
- Adoption: Mars 28,000 GenAI users; Spotify 2,100+; Block ~3,500/month; Ramp 300 users and 10-20x question volume; Snowflake internal 320,000 queries in a month.
- Rationalisation: Kimberly-Clark 30,000+ reports to ~2,000; Kingfisher 40 glossaries to 1.

### 8.4 The sceptical view

- **"A ceiling, not accuracy."** Zenlytic's CTO Paul Blankley, an early advocate, now argues a semantic layer "doesn't give your agent accuracy. It gives your agent a ceiling", because it requires anticipating every question; agents should gather and create context dynamically while preserving governance ([Conference](https://www.aicouncil.com/talks/agents-are-eating-the-semantic-layer)). Zenlytic sells an alternative, so this is also a commercial position.
- **Coverage.** dbt's own data: the semantic layer scored 0% on questions requiring entity hops it did not model ([Vendor](https://docs.getdbt.com/blog/semantic-layer-vs-text-to-sql-2026)).
- **Modelling matters more than the layer.** In the same study, three extra LLM-written models lifted plain text-to-SQL by about 25 points (64.5% to 90.0%), more than the semantic layer added on top ([dbt table](https://docs.getdbt.com/blog/semantic-layer-vs-text-to-sql-2026)).
- **Garbage in, faster garbage out.** Vercel: the simple architecture worked only because the semantic layer was already well documented ([Company](https://vercel.com/blog/we-removed-80-percent-of-our-agents-tools)).
- **Model coupling and drift.** MotherDuck found its layer was tuned to the specific model, raising consistency problems when users choose different models or hosted models change; and an LLM-written layer "produces confident but flawed definitions" without evals ([Vendor](https://motherduck.com/blog/oops-maybe-we-do-need-semantic-layers/)).
- **Slow and hard to copy.** Airbnb's Minerva PM: table standardisation "can last years" and success is not "easily replicable" ([Interview](https://roundup.getdbt.com/p/ep-1-robert-chang-on-scaling-metrics)). LinkedIn: "not yet easy to build a working enterprise solution" ([Academic](https://arxiv.org/abs/2507.14372)). Mars builds the front end first because foundation work is costly ([Press](https://www.cdomagazine.tech/data-analytics/why-a-common-data-model-became-vital-to-mars-analytics-evolution)).
- **Satisfaction is not correctness.** LinkedIn's 95% user rating versus 53% expert-judged correctness.
- **Thin ROI tracking.** More than half of CPG companies do not track AI ROI (BCG, via [Press](https://consumergoods.com/how-cgs-unilever-pg-coca-cola-colgate-palmolive-establish-strong-foundations-scalable-ai)).
- **Vendor-heavy evidence.** Of the 40 cases in the table, roughly half of the CPG and retail ones rest only on a vendor page, often with a "test phase", "pilot", "estimated" or "up to" qualifier.

---

## 9. Question 4: how long did it take?

| Company | Phase | Duration (as stated) | Source |
|---|---|---|---|
| Airbnb Minerva | Start to company-wide source of truth | Mid-2017 to 2020 (~3 years), "four-year effort" by 2021; began with one part-time engineer | [Interview](https://roundup.getdbt.com/p/ep-1-robert-chang-on-scaling-metrics) |
| Kimberly-Clark | 500+ lakes to one enterprise lake, 400-KPI library | Two years | [Vendor](https://www.snowflake.com/en/customers/all-customers/case-study/kimberly-clark/) |
| PepsiCo | Data Foundation with Unity Catalog | ~4 years to mid-2024 | [Company/Vendor](https://www.databricks.com/blog/how-pepsico-established-enterprise-grade-data-intelligence-platform-powered-databricks-unity) |
| PepsiCo | Salesforce Data 360 / Agentforce | Five-year roadmap (from 2026) | [Vendor](https://www.salesforce.com/customer-stories/pepsico-data-360/) |
| General Mills | Ontology foundation to production agent | 2019 start; $14m/yr reported March 2024, on part of network | [Vendor](https://www.palantir.com/assets/xrfr7uokpv1b/1aLBn65y83vdytjpXJKZcO/16989b788b34cb677f6d763d56a72349/Building_an_Intelligent_AI-Driven_Supply_Chain_at_General_Mills_-_AIPCon_March_-24_Impact_Study.pdf) |
| Fortune 100 CPG | 7+ ERPs into a digital twin | 5 days; BOM workflow 1 week | [Vendor](https://palantir.com/docs/foundry/use-case-examples/optimizing-production-with-erp-data-across-the-supply-chain/) |
| Walgreens | Data integration; pilot to scale | <45 days; 10 stores to 4,000 in 8 months | [Press](https://www.pymnts.com/?p=2693145) |
| Heineken US | Palantir supply chain apps | 3 months (vs 3 years for previous programme) | [AI notes](https://readray.ai/notes/en/palantir-aipcon-20251112/ai-driven-supply-chain-heineken-aipcon) |
| Lear | Palantir from start to $30m half-year saving | 2023 to H1 2025 | [Press](https://supplychaindive.com/news/lear-corp-palantir-technologies-ai-software-partnership-five-year/760396) |
| Mars | GenAI platform to 28,000 users | 12 months | [Vendor](https://www.tredence.com/forrester-mars-casestudy) |
| Nestlé | First consumer-service agent; each new country | 8 weeks; 8 weeks (technical deployment as little as 2) | [Vendor](https://www.salesforce.com/customer-stories/nestle/agentic-consumer-service/) |
| Diageo | Data product delivery after semantic layer | ~2 weeks to hours (test phase); aim to avoid 15-18-month projects | [Vendor](https://www.01net.it/strategy-and-diageo-show-how-a-universal-context-layer-can-simplify-data-complexity-and-accelerate-ai-readiness-at-gartner-data-analytics-summit-london-2026/) |
| CONA (Coca-Cola bottlers) | Tool evaluation; full CDC replication | Nearly a year; live by mid-2022 | [Vendor](https://www.fivetran.com/de/case-studies/coke-one-north-america-accelerates-real-time-sap-insights-for-35-000-users) |
| Groupement Mousquetaires | Unity Catalog migration | 3 pilots, phased rollout, target end-2025 (DataHub since 2019) | [Vendor](https://databricks.com/blog/transforming-retail-data-governance-groupement-mousquetaires-journey-unity-catalog) |
| LinkedIn SQL Bot | Build before write-up | Over a year | [Secondary](https://www.zenml.io/llmops-database/building-a-production-text-to-sql-assistant-with-multi-agent-architecture) |
| Uber QueryGPT | Hackathon to mature product | May 2023 to Sept 2024, 20+ iterations | [Company](https://www.uber.com/blog/query-gpt/) |
| Vercel d0 | v1 advanced agent | "Built over months" | [Company](https://vercel.com/blog/we-removed-80-percent-of-our-agents-tools) |
| Spotify | Live use | Since August 2025 (to June 2026 write-up) | [Company](https://engineering.atspotify.com/2026/6/encoding-your-domain-expert-the-context-layer-behind-spotifys-data-assistant) |
| Block Query Expert | Launch to ~3,500 monthly users | Launched July 2025 | [Company talk](https://answers.databricks.com/query-expert-building-rag-powered-data-agents-at-enterprise-scale-IpInyhpaXq0) |
| Walmart Retail Graph | Build pattern | One category at a time, starting with Home & Garden; no duration | [Company](https://medium.com/walmartglobaltech/retail-graph-walmarts-product-knowledge-graph-6ef7357963bc) |

**Pattern.** Two very different clocks run in parallel:
- **Foundation clock: years.** Consolidation and metric standardisation take two to four years (Kimberly-Clark, PepsiCo, Airbnb), and the companies that report fast agent launches had already done this (Nestlé's product data hub in Snowflake; General Mills' 2019 ontology; Uber and OpenAI's mature warehouses).
- **Use-case clock: weeks to months** once the foundation exists: Nestlé 8 weeks, Heineken 3 months, Mars 12 months to enterprise scale, Palantir integrations in days to weeks (vendor claims).
- **Team size** is rarely given. The only explicit small-start figure is Airbnb's single part-time engineer. Most CPG programmes involve an external partner.

---

## 10. Store or connect: what the case studies show

(Detailed treatment is in another slice; here only what these cases reveal.)

- **Store (consolidate first) dominates in CPG:** Kimberly-Clark (500 lakes into Snowflake), PepsiCo (6 PB Data Foundation), CONA (SAP into Snowflake, shared to bottlers), Diageo (central data hub, then a virtual semantic layer on top), Mars (Azure Databricks), Unilever (moving everything to one Google Cloud environment), General Mills and other Palantir users (data integrated into Foundry).
- **Connect (zero-copy, federation, virtual) appears for specific reasons:** to feed SaaS front-ends without copying (Salesforce Data 360 reading Snowflake/Databricks at Nestlé and PepsiCo); to respect data-residency law (L'Oréal's BigQuery Omni); to avoid duplicating plant data (Bosch's virtual knowledge graph, Siemens' federation engine); and in metadata catalogs that never move the data (Heineken, Kingfisher).
- **Semantic layers themselves are usually "virtual"** (AtScale, Strategy, Cube, dbt, Snowflake semantic views): they store definitions, not data, and push queries to the warehouse, with caching or materialisation for speed (Snowflake's semantic view materialisations; Diageo's "automatic caching of repeated queries").
- **IKEA states the trade-off explicitly:** persist for performance, virtualise to keep data at source; persisting without enforced ownership leads to inconsistent copies.

---

## 11. Disagreements and inconsistencies between sources

- **Unilever's platform:** Azure Databricks in vendor material versus a 2026 plan to move the data platform to Google Cloud.
- **LinkedIn accuracy:** 95% of users rate it "Passes" or better versus 53% correct or close on expert review.
- **Uber context graph size:** secondary sources quote 40 million entries and 150 types; Uber's own post says 24m nodes, 80m edges, 86 node and 117 edge types. I use Uber's figures.
- **OpenAI dataset count:** OpenAI says 70k datasets; one secondary (ByteByteGo) says 90,000 tables.
- **Kimberly-Clark "$1 billion":** in the page title and from Tredence's executive, not Kimberly-Clark; the company figure is >$800m of a $3bn target backed by data.
- **Diageo:** results come from a "test phase" per the press release footnote, while the blog presents the semantic layer as operational in its BPM product.
- **Heineken's speaker name:** rendered differently by different automated summaries.
- **Databricks summit pages:** 2027 headers on 2026 sessions.
- **Gartner's 2027 prediction** is phrased as "agentic AI accuracy" in the press release coverage and as "GenAI model accuracy" in some outlets.

---

## 12. What I could not find

- Any **independent** (non-vendor, multi-company) benchmark of agent accuracy with and without a semantic layer.
- A named semantic-layer, ontology or knowledge-graph case for **Tesco, Target, Kroger, Mondelez, Kraft Heinz, Danone, Reckitt, Colgate-Palmolive, The Coca-Cola Company, Nestlé-with-SAP, or Unilever-with-Palantir**.
- Confirmation of **which IKEA entity** (Inter IKEA or Ingka) runs the IKEA Knowledge Graph.
- Primary posts from **Shopify** or **Stripe** on an internal semantic or context layer; the "Ramp memory pipeline" named in the brief.
- **Team sizes and budgets** for almost every case.
- Gartner and Snowflake original pages for some figures (blocked); I used the text proxy or labelled secondaries.

---

## 13. Full source list

### CPG
- Unilever: CIO Dive, 13 Oct 2026. https://ciodive.com/news/unilever-tailors-ai-focus-business-outcomes/832799
- Unilever and Google Cloud: P2PI. https://p2pi.com/unilever-links-marketing-data-and-ai-prepare-agentic-commerce-era
- Unilever Horizon3 Labs: Consumer Goods Technology, 21 Nov 2023. https://consumergoods.com/unilever-accelerating-ai-graph-technology-new-global-lab
- Unilever, P&G, Coca-Cola, Colgate foundations: Consumer Goods Technology, 31 Aug 2026. https://consumergoods.com/how-cgs-unilever-pg-coca-cola-colgate-palmolive-establish-strong-foundations-scalable-ai
- Unilever on Databricks [Vendor]. https://www.databricks.com/customers/unilever
- Unilever supply chain app, DAIS session [Vendor]. https://www.databricks.com/dataaisummit/session/sponsored-sigma-how-unilever-optimizes-supply-chain-inventory-sigma-and
- Diageo press release, 9 Jun 2026 [Vendor] (copy). https://www.01net.it/strategy-and-diageo-show-how-a-universal-context-layer-can-simplify-data-complexity-and-accelerate-ai-readiness-at-gartner-data-analytics-summit-london-2026/
- Diageo, Strategy blog, 20 Apr 2026 [Vendor]. https://www.strategy.com/software/blog/how-diageo-scales-enterprise-ai-with-a-governed-semantic-layer
- Diageo and Strategy deck [Vendor]. https://assets.contentstack.io/v3/assets/bltb564490bc5201f31/bltc17d84cf7c5a888e/The%20AI%20Cocktail%20with%20Strategy%20and%20Diageo.pdf
- Kimberly-Clark, Snowflake case study [Vendor]. https://www.snowflake.com/en/customers/all-customers/case-study/kimberly-clark/
- Mars Genie [Vendor]. https://www.databricks.com/customers/mars/genie
- Mars common data model, CDO Magazine, 12 Mar 2026. https://www.cdomagazine.tech/data-analytics/why-a-common-data-model-became-vital-to-mars-analytics-evolution
- Mars MAX platform, Tredence/Forrester [Vendor]. https://www.tredence.com/forrester-mars-casestudy
- PepsiCo Unity Catalog, Databricks blog, 6 Jun 2024. https://www.databricks.com/blog/how-pepsico-established-enterprise-grade-data-intelligence-platform-powered-databricks-unity
- PepsiCo Data 360, Salesforce, 27 Jan 2026 [Vendor]. https://www.salesforce.com/customer-stories/pepsico-data-360/
- PepsiCo Foods forecasting, DAIS session [Vendor]. https://www.databricks.com/dataaisummit/session/game-day-global-scale-how-pepsico-foods-uses-ai-feed-world-cup
- Nestlé agentic consumer service, Salesforce, 23 Oct 2026 [Vendor]. https://www.salesforce.com/customer-stories/nestle/agentic-consumer-service/
- Nestlé CDP, Treasure Data [Vendor]. https://www.treasure.ai/customers/nestle-global-cpg
- General Mills AIPCon impact study, Palantir, Mar 2024 [Vendor]. https://www.palantir.com/assets/xrfr7uokpv1b/1aLBn65y83vdytjpXJKZcO/16989b788b34cb677f6d763d56a72349/Building_an_Intelligent_AI-Driven_Supply_Chain_at_General_Mills_-_AIPCon_March_-24_Impact_Study.pdf
- Fortune 100 CPG, Palantir docs [Vendor]. https://palantir.com/docs/foundry/use-case-examples/optimizing-production-with-erp-data-across-the-supply-chain/
- Heineken PowerMe, Genpact [Vendor]. https://preview.genpact.com/content/dam/genpact/web/documents/From_outdated_to_cutting_edge_US.pdf.coredownload.inline.pdf
- Heineken AIPCon talk, machine-generated notes [AI notes]. https://readray.ai/notes/en/palantir-aipcon-20251112/ai-driven-supply-chain-heineken-aipcon
- AB InBev master data, Creactives [Vendor]. https://www.creactives.com/?p=5523
- Coke One North America, Fivetran [Vendor]. https://www.fivetran.com/de/case-studies/coke-one-north-america-accelerates-real-time-sap-insights-for-35-000-users
- Coca-Cola Bottling Co. United, Consumer Goods Technology, 2 Jan 2025. https://consumergoods.com/coca-cola-united-testing-generative-ai-tool-streamline-data-access
- P&G ontologies, Semantic Arts [Vendor]. https://www.semanticarts.com/case-study-proctor-and-gamble
- P&G AI Factory, CDO Magazine, May 2026. https://www.cdomagazine.tech/aiml/inside-pgs-ai-factory-how-the-global-consumer-goods-giant-balances-ai-scale-with-local-business-relevance
- P&G and Microsoft, ERP Today, 10 Jun 2022. https://erp.today/pg-and-microsoft-co-innovate-to-build-the-future-of-digital-manufacturing/
- L'Oréal Beauty Tech Data Platform, Google Cloud blog, 10 Mar 2022. https://cloud.google.com/blog/products/serverless/loreal-combines-google-cloud-serverless-and-data-offerings
- EY, ontologies in consumer products, 29 Apr 2026. https://www.ey.com/en_us/insights/consumer-products/ontologies-as-the-missing-layer-in-enterprise-ai

### Retail, restaurant, manufacturing
- Walmart Wally, 18 Mar 2025. https://corporate.walmart.com/news/2025/03/18/walmart-develops-genai-powered-assistant-for-walmart-merchants
- Walmart Retail Graph, 13 Mar 2020. https://medium.com/walmartglobaltech/retail-graph-walmarts-product-knowledge-graph-6ef7357963bc
- IKEA Knowledge Graph, Katariina Kari, 24 Aug 2022. https://medium.com/flat-pack-tech/ikeas-knowledge-graph-and-why-it-has-three-layers-a38fca436349
- IKEA, Semantic Data Europe 2025 session. https://backend.henrystewartconferences.com/session/events-semantic-data-europe-2025-bridging-physical-and-digital-ikea-knowledge-graph
- IKEA, KGC talk page. https://watch.knowledgegraph.tech/videos/knowledge-graph-enhanced-product-catalogue
- Carrefour, AtScale, 23 Jun 2026 [Vendor]. https://www.atscale.com/blog/carrefour-universal-semantic-layer/
- Kingfisher, Collibra [Vendor]. https://www.casestudies.com/company/collibra/case-study/collibra-improves-customer-engagement-for-european-diy-retailer-kingfisher
- Groupement Mousquetaires, Databricks, 5 May 2025 [Vendor]. https://databricks.com/blog/transforming-retail-data-governance-groupement-mousquetaires-journey-unity-catalog
- Grupo Casas Bahia, Databricks [Vendor]. https://www.casestudies.com/company/databricks/case-study/transforming-retail-strategies-with-advanced-consumer-insights
- US grocer, Coginiti [Vendor]. https://coginiti.co/customers/major-grocery-retailer/
- Wendy's and Walgreens, PYMNTS, 29 Apr 2025. https://www.pymnts.com/?p=2693145
- Siemens, metaphactory [Vendor]. https://metaphactory.com/smart-manufacturing-planning-execution-at-siemens
- Bosch SIB, ISWC 2020. https://www.inf.unibz.it/~calvanese/papers-html/ISWC-2020-bosch.html
- Lear and Palantir, Supply Chain Dive, 23 Sep 2025. https://supplychaindive.com/news/lear-corp-palantir-technologies-ai-software-partnership-five-year/760396
- Lear enterprise ontology job advert. https://app.qureos.com/jobs/enterprise-ontology-leader-idea-by-lear-1773460751303
- Mercedes-Benz Korea, Databricks, 11 Jun 2026 [Vendor]. https://www.databricks.com/blog/unlocking-semantics-ai-how-mercedes-benz-korea-built-trusted-talk-data-scale

### Technology companies
- Uber software factory and context graph, 27 Aug 2026. https://www.uber.com/blog/efficient-software-factory/
- Uber QueryGPT, 19 Sep 2024. https://www.uber.com/blog/query-gpt/
- Uber Finch, 17 Jul 2025. https://www.uber.com/us/en/blog/unlocking-financial-insights-with-finch/
- OpenAI data agent, 29 Jan 2026. https://openai.com/index/inside-our-in-house-data-agent/
- The Decoder on OpenAI, 30 Jan 2026. https://the-decoder.com/openai-develops-six-layer-context-system-to-help-employees-navigate-600-petabytes-of-data/
- Spotify data assistant, 10 Jun 2026. https://engineering.atspotify.com/2026/6/encoding-your-domain-expert-the-context-layer-behind-spotifys-data-assistant
- LinkedIn SQL Bot paper, Jul 2025. https://arxiv.org/abs/2507.14372
- LinkedIn SQL Bot summary [Secondary]. https://www.zenml.io/llmops-database/building-a-production-text-to-sql-assistant-with-multi-agent-architecture
- Airbnb Minerva, 30 Apr 2021. https://medium.com/airbnb-engineering/how-airbnb-achieved-metric-consistency-at-scale-f23cc53dea70
- Robert Chang interview, 1 Jul 2021. https://roundup.getdbt.com/p/ep-1-robert-chang-on-scaling-metrics
- Netflix UDA, InfoQ, 12 Dec 2025. https://www.infoq.com/news/2025/12/netflix-upper-uda-architecture
- Ramp Research. https://engineering.ramp.com/post/meet-ramp-research
- Block Query Expert talk. https://answers.databricks.com/query-expert-building-rag-powered-data-agents-at-enterprise-scale-IpInyhpaXq0
- Vercel d0, 22 Dec 2025. https://vercel.com/blog/we-removed-80-percent-of-our-agents-tools
- Pinterest text-to-SQL summary [Secondary]. https://www.zenml.io/llmops-database/text-to-sql-system-with-rag-enhanced-table-selection
- Snowflake internal context layer, 17 Aug 2026. https://www.snowflake.com/en/blog/snowflake-internal-context-layer-for-ai-agents/
- Brex, Cube [Vendor]. https://cube.dev/case-studies/brex-embedded-ai-financial-analyst
- BetterUp, Cube [Vendor]. https://cube.dev/case-studies/betterup-governed-ai-analytics
- JetBlue, Constellation Research, 29 Jun 2023. https://www.constellationr.com/insights/news/how-jetblue-leveraging-ai-llms-be-most-data-driven-airline-world

### Benchmarks, analysts and sceptics
- Sequeda, Allemang, Jacob, Nov 2023. https://arxiv.org/abs/2311.07509
- Allemang, Sequeda, May 2024. https://arxiv.org/abs/2405.11706
- dbt Labs 2026 benchmark, 7 Apr 2026 [Vendor]. https://docs.getdbt.com/blog/semantic-layer-vs-text-to-sql-2026
- AtScale benchmark coverage, BigDATAwire, 15 Aug 2024. https://www.hpcwire.com/bigdatawire/2024/08/15/atscale-claims-text-to-sql-breakthrough-with-semantic-layer/
- AtScale public leaderboard, 6 Nov 2024 [Vendor]. https://www.atscale.com/blog/public-leaderboard-text-to-sql-tasks/
- Snowflake Cortex Analyst accuracy [Vendor]. https://www.snowflake.com/en/engineering-blog/cortex-analyst-text-to-sql-accuracy-bi/
- Snowflake Cortex Analyst joins [Vendor]. https://www.snowflake.com/en/engineering-blog/cortex-analyst-joins-star-snowflake-schemas/
- Atlan on Cortex Analyst [Secondary/Vendor]. https://atlan.com/know/snowflake/cortex-analyst-vs-text-to-sql/
- Google Looker semantic layer, 8 May 2025 [Vendor]. https://cloud.google.com/blog/products/business-intelligence/how-lookers-semantic-layer-enhances-gen-ai-trustworthiness
- MotherDuck semantic layer experiment [Vendor]. https://motherduck.com/blog/oops-maybe-we-do-need-semantic-layers/
- Spider 2.0. https://arxiv.org/abs/2411.07763
- "Agents are eating the semantic layer", AI Council. https://www.aicouncil.com/talks/agents-are-eating-the-semantic-layer
- Gartner semantics prediction, coverage, 4 Jun 2026. https://idm.net.au/node/15619
- Gartner AI-ready data prediction, coverage, 26 Feb 2025. https://www.freevacy.com/news/gartner/gartner-reveals-60-of-ai-projects-with-data-issues-will-fail/6155
