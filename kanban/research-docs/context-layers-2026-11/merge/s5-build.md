## How they build them and how long it took

Companies start from one of six approaches; the data foundation takes two to four years, then each use case takes weeks to months.

### Build approaches

Opus found four approaches in practice; Astra proposed five as decision rules. Metrics-first, ontology-first and catalog-first appear in both. Retrieval-first is Opus's; knowledge-graph-first and application-first are Astra's. Most agent-era programmes combine a governed metric layer with retrieval over everything else (Opus).

| Approach | Starts from | Typical tools | Strength | Weakness |
|---|---|---|---|---|
| **Metrics-first** (both): [Airbnb](https://medium.com/airbnb-engineering/how-airbnb-achieved-metric-consistency-at-scale-f23cc53dea70), [Diageo](https://www.strategy.com/software/blog/how-diageo-scales-enterprise-ai-with-a-governed-semantic-layer), [Carrefour](https://www.atscale.com/blog/carrefour-universal-semantic-layer/), [Kimberly-Clark](https://www.snowflake.com/en/customers/all-customers/case-study/kimberly-clark/), [Mercedes-Benz Korea](https://www.databricks.com/blog/unlocking-semantics-ai-how-mercedes-benz-korea-built-trusted-talk-data-scale) | A disputed commercial or financial measure and its dimensions | dbt MetricFlow, Cube, AtScale, LookML, Snowflake semantic views, Databricks metric views, Strategy Mosaic | Deterministic numbers; refuses rather than guesses | Answers only what was modelled; a glossary can record disagreement without resolving the calculation (Astra) |
| **Ontology-first** (both): [General Mills](https://www.palantir.com/assets/xrfr7uokpv1b/1aLBn65y83vdytjpXJKZcO/16989b788b34cb677f6d763d56a72349/Building_an_Intelligent_AI-Driven_Supply_Chain_at_General_Mills_-_AIPCon_March_-24_Impact_Study.pdf), [Lear](https://supplychaindive.com/news/lear-corp-palantir-technologies-ai-software-partnership-five-year/760396), [Netflix](https://www.infoq.com/news/2025/12/netflix-upper-uda-architecture), [Siemens](https://metaphactory.com/smart-manufacturing-planning-execution-at-siemens) | Business objects and decisions: order, shipment, lot, shortage | Palantir Ontology, Fabric IQ (preview), TopBraid, RDF/SHACL | Supports actions and multi-hop reasoning across domains | Needs ontologists; with Palantir, data must be integrated into the platform; risk of a model with no working source bindings (Astra) |
| **Catalog-first** (both): [Heineken](https://preview.genpact.com/content/dam/genpact/web/documents/From_outdated_to_cutting_edge_US.pdf.coredownload.inline.pdf), [Kingfisher](https://www.casestudies.com/company/collibra/case-study/collibra-improves-customer-engagement-for-european-diy-retailer-kingfisher), [Groupement Mousquetaires](https://databricks.com/blog/transforming-retail-data-governance-groupement-mousquetaires-journey-unity-catalog), [Mondelez](https://www.ataccama.com/customer-story/before-mondelez-international-could-trust-ai-it-had-to-trust-its-data) | Fragmented assets, unknown owners, a coming migration | Collibra, Atlan, Alation, Unity Catalog, Genpact PowerMe, Ataccama | Discovers and retires before migrating; usually the precursor to the others | Auto-generated descriptions get treated as approved truth (Astra); does not execute a metric |
| **Knowledge-graph-first** (Astra): [Inter IKEA](https://blog.metaphacts.com/building-explainable-trustworthy-recommendation-systems-ikea-at-kgc2023), [L'Oréal](https://neo4j.com/customer-stories/loreal-graphsummit-2026/), [Walmart Retail Graph](https://medium.com/walmartglobaltech/retail-graph-walmarts-product-knowledge-graph-6ef7357963bc) | Relationship-heavy questions or recommendations | Neo4j, Stardog, metaphactory, Timbr | Explainable paths to evidence | Importing everything before proving one useful query (Astra) |
| **Retrieval or context-graph-first** (Opus): [Uber](https://www.uber.com/blog/efficient-software-factory/), [OpenAI](https://openai.com/index/inside-our-in-house-data-agent/), [Spotify](https://engineering.atspotify.com/2026/6/encoding-your-domain-expert-the-context-layer-behind-spotifys-data-assistant), [Ramp](https://engineering.ramp.com/post/meet-ramp-research), [Block](https://answers.databricks.com/query-expert-building-rag-powered-data-agents-at-enterprise-scale-IpInyhpaXq0) | Everything an expert would consult: schemas, query history, code, documents, corrections | Vector search, OpenSearch, MCP, Glean, in-house graphs | Fast to start; covers questions nobody modelled | Usually needs a governed metric layer or curated marts underneath (Opus) |
| **Application or domain-first** (Astra): [Kinaxis](https://www.kinaxis.com/en/semantic-graph), [o9](https://o9solutions.com/news/o9-named-a-leader-in-the-nucleus-research-scp-technology-value-matrix-2025), [Crisp](https://www.gocrisp.com/our-platform) | An existing planning, merchandising, CRM or retail-data model | o9, Kinaxis, Blue Yonder, RELEX, Salesforce, Crisp | Reuses domain modelling already paid for | Creates a second inconsistent copy of the same domain model (Astra) |

EY's April 2026 advice to consumer products firms is ontology-first: start from a core CPG ontology (product, customer, order, promotion, inventory) and map it to sources "without replacing systems"; it names no client results (Opus) ([EY](https://www.ey.com/en_us/insights/consumer-products/ontologies-as-the-missing-layer-in-enterprise-ai)).

### Common build steps

The two reports describe the same order (both). Opus drew it from cases; Astra wrote it as a recommended sequence.

1. **Pick one narrow, high-value decision and persona.** LinkedIn started "with high-ROI pain points"; Mars with people analytics; Diageo with its performance-management product; Walmart with one category, Home & Garden; Heineken with the US West Coast (Opus).
2. **Standardise tables or consolidate first.** Airbnb rebuilt core tables before Minerva; Kimberly-Clark consolidated 500 lakes; PepsiCo spent about four years on its foundation (Opus).
3. **Reconcile sources and entities.** Map each source key to a governed product, customer or site with dates, pack level and confidence; keep unmatched records in an exception queue (Astra). [Nestlé USA](https://www.gocrisp.com/case-studies/nestle-usa) had to map one distributor vendor number to several Nestlé businesses (Astra).
4. **Define a small core centrally and a large periphery locally.** IKEA has hundreds of concepts and thousands of categories; P&G under 500 concepts; Kimberly-Clark 400 KPIs; Spotify 177 expert-owned clusters; Kingfisher 4,000+ terms (Opus).
5. **Store definitions as code, with owners and tests.** Git holds IKEA's ontology, Airbnb's metrics, Block's knowledge store and Snowflake's semantic views (Opus). Each definition should trace to its code, owner, source grain and test (Astra).
6. **Build evaluations from real questions, held out from retrieval.** Snowflake uses popular dashboard tiles; LinkedIn 130+ expert questions; Ramp a test framework inside dbt (Opus). [Snowflake's evaluation tooling](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst-evaluations) removes verified queries from runtime context during tests (Astra).
7. **Ship where people already work.** LinkedIn saw 5-10x adoption from embedding in its notebook tool; Carrefour moved users to Sheets (Opus).
8. **Keep it alive.** Spotify scores each cluster's health; Block takes 15-20 pull requests a week; OpenAI runs a daily enrichment pipeline (Opus).

### Using LLMs to bootstrap definitions

LLMs now draft table descriptions, metric code and question-SQL pairs, but every mature programme keeps a human gate (both). The clearest measure of the limit is Spotify: curators accepted only 12.5% of LLM-proposed pairs (Opus).

| Who | What the LLM does | Human gate or limit |
|---|---|---|
| [Spotify](https://engineering.atspotify.com/2026/6/encoding-your-domain-expert-the-context-layer-behind-spotifys-data-assistant) | Infers question-SQL pairs from query history | **12.5% accepted** by curators (Opus) |
| [OpenAI](https://openai.com/index/inside-our-in-house-data-agent/) | Codex derives each table's meaning from pipeline code, refreshed automatically | Human annotations layer; memory of corrections (Opus) |
| [Block](https://answers.databricks.com/query-expert-building-rag-powered-data-agents-at-enterprise-scale-IpInyhpaXq0) | Generates table descriptions and example queries daily | Human-verified tables boosted; GitHub pull requests (Opus) |
| [Pinterest](https://www.zenml.io/llmops-database/text-to-sql-system-with-rag-enhanced-table-selection) | Writes table and query summaries for retrieval | Only top-tier tables indexed (Opus, secondary source) |
| [Mercedes-Benz Korea](https://www.databricks.com/blog/unlocking-semantics-ai-how-mercedes-benz-korea-built-trusted-talk-data-scale) | Transpiles 500+ Power BI DAX measures into metric views | Flags measures for manual review (Opus) |
| [Snowflake](https://www.snowflake.com/en/blog/snowflake-internal-context-layer-for-ai-agents/) | Coding assistant drafts semantic views | Code review and evals (Opus) |
| [dbt benchmark](https://docs.getdbt.com/blog/semantic-layer-vs-text-to-sql-2026) | Wrote three dbt models with no hand-written code | Benchmark scoring (Opus) |
| [MotherDuck](https://motherduck.com/blog/oops-maybe-we-do-need-semantic-layers/) | Claude Opus authored and refined a hierarchical semantic layer | Works "only when it is continuously tested against an eval set"; otherwise "confident but flawed definitions" (Opus) |
| [Ciena/Alation](https://www.alation.com/customers/ciena-ai-data-catalog/) | Curated about 6,000 assets in two weeks, versus 1.5-2 years manually before | Vendor evidence; metadata work, not agreed enterprise semantics (Astra) |
| [Walmart Retail Graph](https://medium.com/walmartglobaltech/retail-graph-walmarts-product-knowledge-graph-6ef7357963bc) (2020, pre-LLM) | NLP extracts and links product entities | Triples below a confidence threshold go to human review (Opus) |

Astra adds the controls: mark generated definitions as proposals, attach source evidence, require domain-owner approval, and test mappings against real records. An LLM can suggest two fields are both product IDs; it cannot tell from names that they share pack level or hierarchy (Astra). Entity merges should keep confidence, evidence and an undo path, as [Reltio](https://www.reltio.com/products/entity-resolution/) documents (Astra).

### Team structures

Exact team sizes are almost never published (both). The only explicit small start is Airbnb's one part-time engineer (Opus).

| Company | Structure described | Source |
|---|---|---|
| Airbnb | One part-time engineer at the start, a data scientist turned PM, then partnership with reporting teams (Opus) | [Interview](https://roundup.getdbt.com/p/ep-1-robert-chang-on-scaling-metrics) |
| IKEA | Central ontologists own concepts; subject experts own categories; source systems own data (Opus) | [Kari](https://medium.com/flat-pack-tech/ikeas-knowledge-graph-and-why-it-has-three-layers-a38fca436349) |
| Ingka | Team-of-teams combining architecture, product, data and engineering (Astra) | [PlatformCon 2025](https://2025.platformcon.com/sessions/delivering-a-greenfield-data-platform-with-togetherness-at-its-heart-through-a-team-of-teams-setup) |
| Unilever | Data Product Management roles bridging business, IT and its Data Hub (Astra) | [Bridge & Co](https://www.bridgenco.com/insights/case-studies/optimizing-data-governance-at-unilever/) |
| Diageo | Cross-functional product teams replacing project teams (both) | [Strategy](https://www.strategy.com/software/blog/how-diageo-scales-enterprise-ai-with-a-governed-semantic-layer) |
| Mars | P&O Data Office with business translators and analysts, plus Tiger Analytics (Opus) | [Databricks](https://www.databricks.com/customers/mars/genie) |
| Mondelez | Stewardship moved from IT to business owners (Astra) | [Ataccama](https://www.ataccama.com/customer-story/before-mondelez-international-could-trust-ai-it-had-to-trust-its-data) |
| Colruyt | Business-unit start, then a permanent product team (Astra) | [Datashift](https://www.datashift.eu/case-studies/how-colruyt-group-built-a-stronger-data-foundation-with-collibra-and-datashift) |
| Lear | Internal ontology team under an enterprise ontology leader (Opus) | [Job post](https://app.qureos.com/jobs/enterprise-ontology-leader-idea-by-lear-1773460751303) |
| Heineken US | A "tiger team" with Palantir (Opus) | [AI notes](https://readray.ai/notes/en/palantir-aipcon-20251112/ai-driven-supply-chain-heineken-aipcon) |
| LinkedIn, Spotify, Ramp | Virtual team or domain owners (data scientists, analytics engineers) each owning a slice (Opus) | [LinkedIn summary](https://www.zenml.io/llmops-database/building-a-production-text-to-sql-assistant-with-multi-agent-architecture) |

A systems integrator or specialist partner (Tredence, Tiger, Capgemini, PwC, Accenture) appears in nearly every CPG case (Opus). Astra's estimated first-domain team is one product owner, one semantic modeller, two data engineers, one shared governance/MDM specialist, one agent engineer, fractional security support, and committed business stewards (Astra estimate, not observed).

### Timeline of named cases

Sorted roughly from the longest foundation to the fastest use case. Few rows have dates precise enough to sort by time.

| Company | What | Foundation time | Time to first use case | Team size | Source |
|---|---|---|---|---|---|
| PepsiCo | Data Foundation, Unity Catalog, 6 PB | ~4 years to mid-2024 (both) | Not stated; Salesforce roadmap runs five years from 2026 (Opus) | Not stated | [Databricks, 2024](https://www.databricks.com/blog/how-pepsico-established-enterprise-grade-data-intelligence-platform-powered-databricks-unity), [Salesforce](https://www.salesforce.com/customer-stories/pepsico-data-360/) |
| General Mills | Palantir Ontology to ELF agent | From 2019 | ~$14m/yr reported March 2024 (Opus) | Not stated | [Palantir](https://www.palantir.com/assets/xrfr7uokpv1b/1aLBn65y83vdytjpXJKZcO/16989b788b34cb677f6d763d56a72349/Building_an_Intelligent_AI-Driven_Supply_Chain_at_General_Mills_-_AIPCon_March_-24_Impact_Study.pdf) |
| Airbnb | Minerva metric platform | Mid-2017 to source of truth in 2020 (~3 years); "four-year effort" by 2021 | COVID dashboard in "a few days" once metrics existed (Opus) | One part-time engineer at start | [Interview](https://roundup.getdbt.com/p/ep-1-robert-chang-on-scaling-metrics), [Airbnb](https://medium.com/airbnb-engineering/how-airbnb-achieved-metric-consistency-at-scale-f23cc53dea70) |
| Shopify | World monorepo, then River agent | From early 2024 | River launched a couple of months before June 2026 (Astra) | Not stated | [Shopify](https://shopify.engineering/under-the-river) |
| Mars (manufacturing) | Digital twins with Accenture/Microsoft | Trials from late 2020; global deal October 2022 (Astra) | Illinois overfill pilot (Astra) | Not stated | [Accenture, 2022](https://newsroom.accenture.com/news/2022/accenture-collaborates-with-mars-to-develop-factory-of-the-future-using-ai-cloud-edge-and-digital-twins) |
| Lear | Palantir enterprise ontology | From 2023 | >$30m saved in H1 2025 (Opus) | Internal ontology team | [Supply Chain Dive](https://supplychaindive.com/news/lear-corp-palantir-technologies-ai-software-partnership-five-year/760396) |
| Kimberly-Clark | 500+ lakes to one; 400-KPI library | Two years (Opus) | Not stated | Not stated; Tredence partner | [Snowflake](https://www.snowflake.com/en/customers/all-customers/case-study/kimberly-clark/) |
| Nestlé (ERP) | SAP core upgrade, 112 countries | 2025 wave; whole group within two years (target) (Astra) | n/a | 50,000 employees affected, not team | [Nestlé AR](https://www.nestle.com/investors/annual-report/executing-strategy/accelerating-business-transformation) |
| Uber QueryGPT | Text-to-SQL with workspaces | Hackathon May 2023 | Mature after 20+ iterations by September 2024 (Opus) | Not stated | [Uber](https://www.uber.com/blog/query-gpt/) |
| LinkedIn | SQL Bot knowledge graph | Over a year before December 2024 (Opus) | Not stated | Virtual team, experts from 10 areas | [Secondary](https://www.zenml.io/llmops-database/building-a-production-text-to-sql-assistant-with-multi-agent-architecture) |
| CONA (Coca-Cola bottlers) | SAP CDC into Snowflake | Nearly a year of tool evaluation; live by mid-2022 (Opus) | Not stated | Capgemini partner | [Fivetran](https://www.fivetran.com/de/case-studies/coke-one-north-america-accelerates-real-time-sap-insights-for-35-000-users) |
| Mars (GenAI) | MAX platform to 28,000 users | Not stated | 12 months to enterprise scale (Opus) | Tredence partner | [Tredence](https://www.tredence.com/forrester-mars-casestudy) |
| Colruyt | Collibra data foundation | Go-live about 2023 (Astra inference) | Not stated | Permanent product team | [Datashift](https://www.datashift.eu/case-studies/how-colruyt-group-built-a-stronger-data-foundation-with-collibra-and-datashift) |
| Nestlé USA | Crisp retailer and distributor mapping | Adoption from summer 2023 (Astra) | Not stated | Not stated | [Crisp](https://www.gocrisp.com/case-studies/nestle-usa) |
| Groupement Mousquetaires | Unity Catalog migration | DataHub since 2019; target 100% by 2025 (Opus) | Three pilot migrations | Business squads | [Databricks](https://databricks.com/blog/transforming-retail-data-governance-groupement-mousquetaires-journey-unity-catalog) |
| Heineken US | Palantir supply chain apps | Previous Power BI programme took 3 years | 3 months (Opus, AI notes) | Tiger team | [AI notes](https://readray.ai/notes/en/palantir-aipcon-20251112/ai-driven-supply-chain-heineken-aipcon) |
| Walgreens | Palantir integration | Under 45 days | 10 stores to 4,000 in 8 months (Opus) | Not stated | [PYMNTS](https://www.pymnts.com/?p=2693145) |
| Nestlé (agent) | Agentforce consumer-service agent | Product data hub already in Snowflake | 8 weeks; each new country 8 weeks, technical deployment as little as 2 (Opus) | Not stated | [Salesforce](https://www.salesforce.com/customer-stories/nestle/agentic-consumer-service/) |
| Diageo | Strategy semantic layer | Rejects old 15-18-month project cycles (both) | Data products ~2 weeks to hours, test phase (Opus) | Product teams, no totals | [Press release](https://www.01net.it/strategy-and-diageo-show-how-a-universal-context-layer-can-simplify-data-complexity-and-accelerate-ai-readiness-at-gartner-data-analytics-summit-london-2026/) |
| Ciena (Alation) | Metadata curation | Earlier manual rollout 1.5-2 years | ~6,000 assets in two weeks (Astra) | "Small team" | [Alation](https://www.alation.com/customers/ciena-ai-data-catalog/) |
| Fortune 100 CPG (unnamed) | Digital twin over 7+ ERPs | 5 days to integrate (vendor claim) | BOM workflow in 1 week (Opus) | Not stated | [Palantir docs](https://palantir.com/docs/foundry/use-case-examples/optimizing-production-with-erp-data-across-the-supply-chain/) |
| Ritual (Crisp) | Target data via Snowflake sharing | Foundation already in place | One to two hours (Astra) | Not stated | [Crisp](https://www.gocrisp.com/case-studies/ritual) |
| Spotify | Context layer, 177 clusters | Not stated | Live since August 2025 (Opus) | Domain owners | [Spotify](https://engineering.atspotify.com/2026/6/encoding-your-domain-expert-the-context-layer-behind-spotifys-data-assistant) |
| Block | Query Expert | Not stated | Launched July 2025 (Opus) | Not stated | [Block talk](https://answers.databricks.com/query-expert-building-rag-powered-data-agents-at-enterprise-scale-IpInyhpaXq0) |
| Vercel | d0 data agent on Cube | Cube layer already documented | v1 "built over months" (Opus) | Not stated | [Vercel](https://vercel.com/blog/we-removed-80-percent-of-our-agents-tools) |

**The two clocks (Opus finding; Astra agrees that elapsed time hides prior work).** Foundation work, meaning consolidation and metric standardisation, takes two to four years (Kimberly-Clark, PepsiCo, Airbnb). Once it exists, use cases arrive in weeks to months: Nestlé in 8 weeks, Heineken in 3 months, Mars at enterprise scale in 12 months. Every fast launch sat on earlier foundation work, such as Nestlé's Snowflake product data hub and General Mills' 2019 ontology (Opus); Shopify's rapid rollout likewise built on 2024 monorepo work (Astra).

Astra's planning envelope for one domain, assuming a cloud platform and named owners already exist (Astra estimate, not a market average):

| Phase | Elapsed time (estimate) | Exit condition |
|---|---|---|
| Discovery and reconciliation | 2-4 weeks | One decision, 20-40 test questions, source owners named |
| Working pilot | A further 4-8 weeks | 10-25 measures, 2-4 sources, correct refusals on unsupported questions |
| First production domain | 3-6 months from start | Approved definitions, access tests, a real user group |
| Reuse across domains or markets | 6-18 months | Repeatable onboarding, shared entities with local exceptions |
| Extensive enterprise coverage | 18-36 months or longer | A continuing product programme |
