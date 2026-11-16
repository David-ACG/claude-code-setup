# Context layers and semantic layers: the vendor and standards landscape

*Research slice 1 of 4 (vendors and standards). Covers brief questions 1, 2 and 5 from the vendor side.*
*Prepared 16 November 2026. Sources are 2025-2026 unless marked otherwise.*

---

## How to read this report

- **Every factual claim carries the URL it came from.** Pages were opened and read; nothing is cited from a search-result snippet. Where a fact was only visible in search results and the page itself could not be opened, it is either left out or explicitly flagged as **unverified**.
- **Vendor claims are labelled as vendor claims.** Most of the material in this market comes from vendors' own press releases. Accuracy, speed and "hallucination-free" numbers in particular are marketing until someone independent reproduces them.
- **Several primary sites refused automated reading** (HTTP 403): snowflake.com blog and press pages, businesswire.com, gartner.com document abstracts, blog.fabric.microsoft.com and community.fabric.microsoft.com. For those, the report uses the vendor's documentation site, investor-relations site, or a named secondary source instead, and says so.
- **"Store" versus "query in place"** in each profile answers brief question 5 for that vendor: does the product copy data into its own store, or leave data where it lives and query it (federation, virtualisation, zero-copy sharing, MCP calls)?
- My own judgements are marked **(my assessment)**.

---

## 1. The twelve things that matter most

1. **The open standard now has nearly everyone except Google, AWS and SAP.** The Open Semantic Interchange (OSI) was launched by Snowflake on 23-24 September 2025 with four co-leads (Salesforce, BlackRock, dbt Labs, RelationalAI) and twelve supporters ([OpenSourceForU](https://www.opensourceforu.com/2025/09/snowflake-salesforce-dbt-labs-blackrock-introduce-open-semantic-interchange/)). In July 2026 it entered the Apache Incubator and was renamed **Apache Ossie**; it grew "from 17 launch partners to more than 50 organizations" ([Apache Ossie](https://ossie.apache.org/updates/ossie-enters-apache-incubator/)). The project's ecosystem page now lists Databricks, Microsoft, Oracle, ServiceNow, Informatica, Qlik, Starburst, Dremio, Denodo, Collibra, Alation, Atlan, AtScale, Kyvos, Cube, GoodData, Strategy, Celonis, Blue Yonder, NVIDIA and Mistral AI among roughly 90 organisations. **Google, AWS, SAP, Palantir, Neo4j and IBM are not on it** ([Ossie ecosystem](https://ossie.apache.org/ecosystem/)).
2. **The spec is still early.** It is YAML, Apache 2.0, and defines semantic models, datasets, fields, metrics, dimensions and relationships ([Apache Ossie home](https://ossie.apache.org/)). The version on the project's own example file is `0.3.0.dev0`, which is pre-1.0. Working groups exist for Metric Language, Catalog and **Ontology** ([Apache Ossie](https://ossie.apache.org/updates/ossie-enters-apache-incubator/)), so the standard is reaching from metrics towards ontologies.
3. **The warehouse platforms have each built a native semantic layer and are pulling the independents into partner roles.** Snowflake semantic views (definition GA June 2025) ([Snowflake docs](https://docs.snowflake.com/en/release-notes/2025/june-summit)), Databricks Unity Catalog metric views (Business Semantics GA 2 April 2026) ([Databricks](https://www.databricks.com/blog/redefining-semantics-data-layer-future-bi-and-ai)), Microsoft Power BI semantic models plus the Fabric IQ ontology ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/overview)), Google's LookML now pulled into Knowledge Catalog ([Google Cloud](https://cloud.google.com/blog/products/data-analytics/introducing-the-google-cloud-knowledge-catalog)), Salesforce's Tableau Semantics in Data 360 ([Info-Tech](https://www.softwarereviews.com/vendor-technology-notes/dreamforce-2026-data-360-tableau-informatica)), and SAP's Datasphere plus Knowledge Graph in Business Data Cloud ([SAP](https://news.sap.com/2026/05/sap-sapphire-sap-unveils-autonomous-enterprise/)).
4. **2026 was the year everyone renamed their catalog or graph a "context" product.** Snowflake Horizon Context (June 2026) ([Constellation](https://constellationr.com/insights/news/snowflake-summit-2026-context-custom-model-training-iceberg-v3)), Databricks Genie Ontology "a continuously learned enterprise context layer" (June 2026) ([Databricks](https://databricks.com/blog/whats-new-unity-catalog-data-ai-summit-2026)), Google Knowledge Catalog "universal context engine" (April 2026) ([Google Cloud](https://cloud.google.com/blog/products/data-analytics/introducing-the-google-cloud-knowledge-catalog)), AWS Context (announced June 2026, "coming soon") ([AWS](https://aws.amazon.com/blogs/machine-learning/context-intelligence-for-your-data-and-ai-agents-at-scale/)), ServiceNow Context Engine (May 2026) ([ServiceNow](https://newsroom.servicenow.com/press-releases/details/2026/ServiceNow-launches-the-real-time-data-foundation-that-puts-autonomous-AI-to-work-across-the-enterprise/default.aspx)), Salesforce Agent Context Engine (GA "December") ([Info-Tech](https://www.softwarereviews.com/vendor-technology-notes/dreamforce-2026-data-360-tableau-informatica)), Neo4j Context Engine (October 2026, private preview) ([Neo4j](https://neo4j.com/press-releases/neo4j-context-engine/)), Atlan Context Lakehouse (April 2026) ([Atlan](https://atlan.com/know/context-layer-stopped-being-theoretical-activate-2026/)).
5. **Gartner has made "AI context platforms" a named market.** Its *Market Overview for AI Context Platforms* is dated 13 August 2026; one listed vendor reports the report sizes the market at **$28bn in 2026 rising to $78bn by 2030** (29.5% CAGR) and names AWS, Databricks, Google, IBM, Microsoft and Snowflake as representative vendors ([Graphwise, reporting Gartner](https://graphwise.ai/?p=254087); figure not verifiable against Gartner directly).
6. **SAP has been the most aggressive acquirer.** It agreed to buy MDM vendor **Reltio** on 27 March 2026 ([SAP](https://news.sap.com/2026/03/sap-to-acquire-reltio)), completed by 12 May ([ITdaily](https://itdaily.com/news/business/sap-reltio-afronding/)); agreed to buy lakehouse/federation vendor **Dremio** on 4 May and completed on 6 July 2026 ([SAP](https://news.sap.com/2026/07/sap-completes-dremio-acquisition/)); and committed €1bn over four years to tabular-model lab Prior Labs ([Futurum](https://futurumgroup.com/insights/can-sap-finally-kill-the-etl-monster-the-dremio-and-prior-labs-acquisition-explained/)). For a CPG client running SAP, that changes the MDM and "non-SAP data" conversation.
7. **The catalog market consolidated into platforms.** ServiceNow agreed to buy data.world (May 2025) ([Techzine](https://www.techzine.eu/news/data-management/131208/servicenow-acquires-data-world-to-make-data-ai-ready)); Salesforce closed Informatica (18 November 2025, roughly $8bn) ([Salesforce](https://www.salesforce.com/news/press-releases/2025/11/18/salesforce-completes-acquisition-of-informatica/); price per [TechTarget](https://www.techtarget.com/searchITOperations/news/366636012/Atlassians-Secoda-acquisition-adds-data-catalog-for-Rovo-AI)); Snowflake agreed to buy Select Star (November 2025) ([Techzine](https://www.techzine.eu/news/analytics/136690/snowflake-acquires-select-star-for-broader-data-context/)); Atlassian bought Secoda (December 2025) ([TechTarget](https://www.techtarget.com/searchITOperations/news/366636012/Atlassians-Secoda-acquisition-adds-data-catalog-for-Rovo-AI)). The independents left standing at scale are Atlan, Collibra and Alation.
8. **dbt Labs merged with Fivetran.** All-stock, announced 13 October 2025, completed 1 June 2026; George Fraser CEO, Tristan Handy President ([dbt Labs](https://www.getdbt.com/blog/fivetran-dbt-labs-complete-merger-to-create-the-data-infrastructure-for-trusted-ai-agents)). Earlier, MetricFlow (the dbt Semantic Layer engine) was relicensed Apache 2.0 on 14 October 2025 explicitly to serve OSI ([dbt Labs](https://www.getdbt.com/blog/dbt-labs-affirms-commitment-to-open-semantic-interchange-by-open-sourcing-metricflow)).
9. **MCP is now table stakes, not a differentiator.** Every major vendor profiled here ships or has announced a Model Context Protocol server. Gartner's AI context platforms report reportedly calls protocol-based access such as MCP "baseline requirements rather than differentiators" ([Graphwise, reporting Gartner](https://graphwise.ai/?p=254087)). The real difference is **what the MCP server exposes**: governed metrics that generate deterministic SQL (Looker, Cube, AtScale, dbt, Snowflake semantic views), ontology objects and actions (Palantir, Fabric IQ), or catalog metadata (Atlan, Collibra, Alation, Google, IBM).
10. **The independent semantic layers are being financed by the platforms.** Snowflake Ventures led AtScale's largest-ever round (December 2025) ([01net/Business Wire](https://www.01net.it/atscale-announces-equity-financing-led-by-snowflake/)); Cube's last round (2024) was led by Databricks Ventures (older; not re-verified). The platforms want the independents' BI-tool connectors (DAX, MDX, Excel) while keeping the definitions inside the platform.
11. **CPG and retail data providers are exposing their data to agents directly.** Circana connects Liquid AI to Copilot, Claude, Gemini and ChatGPT over MCP and A2A ([Circana](https://www.circana.com/post/ai-access-vs-ai-intelligence-a-cto-guide)); NIQ's Optiq agent is "accessible within NIQ tools and frontier LLMs" ([NIQ](https://nielseniq.com/global/en/news-center/2026/niq-launches-ask-arthur-chat-to-expand-access-to-consumer-insights-through-ai/)); RELEX Open accepts external agents over MCP ([RELEX](https://www.relexsolutions.com/news/relex-launches-relex-open-giving-customers-three-ways-to-accelerate-ai-adoption/)); SPINS launched a Product Knowledge Graph-powered "Agentic Discovery" product ([Shelby Report](https://theshelbyreport.com/2026/09/23/spins-launches-agentic-discovery-for-ai-powered-commerce/)). Each brings its **own** semantic model of products, stores and measures, which a CPG company must reconcile with its own.
12. **Almost no vendor publishes a named CPG customer for its semantic or context layer.** Unilever appears in ThoughtSpot's customer boilerplate ([ThoughtSpot](https://www.thoughtspot.com/press-releases/thoughtspot-introduces-spotter-semantics-to-bring-trust-and-context-to-enterprise-ai)); Tyson and General Mills are named Palantir customers without detail ([AgNavigator](https://www.agnavigator.com/Article/2025/11/04/palantir-uses-ai-to-help-agrifood-businesses-releases-q3-results)); Home Depot (retail) is AtScale's showcase ([AtScale](https://www.atscale.com/?p=27063)). Most CPG evidence will have to come from the CPG companies' own statements (slice 4 of this research), not vendors.

---

## 2. A map of the market

### 2.1 Seven categories

| Category | What it holds | Typical modelling approach | Examples |
|---|---|---|---|
| **Platform-native semantic layer** | Metrics, dimensions, joins defined inside a warehouse or lakehouse | Metrics-first | Snowflake semantic views, Databricks metric views, Power BI semantic models, LookML, SAP Datasphere analytic models, Tableau Semantics |
| **Universal (independent) semantic layer** | Same, but sits across several platforms and serves many BI tools | Metrics-first | dbt Semantic Layer/MetricFlow, Cube, AtScale, Kyvos, GoodData, Honeydew, Strategy Mosaic, ThoughtSpot Spotter Semantics |
| **Ontology / knowledge graph** | Business entities, relationships, rules, actions | Ontology-first or graph-first | Palantir Ontology, Fabric IQ ontology, SAP Knowledge Graph, Timbr, Neo4j, Stardog, Graphwise, TopQuadrant, RelationalAI |
| **Catalog / glossary turned context layer** | Metadata, lineage, ownership, glossary, policies, quality | Catalog-first | Atlan, Collibra, Alation, Informatica, ServiceNow Data Catalog (data.world), Google Knowledge Catalog, AWS Context, IBM watsonx.data intelligence |
| **MDM** | Golden records for customer, product, supplier, location | Entity-resolution-first | Reltio (SAP), Informatica MDM (Salesforce), Stibo, Profisee, Semarchy |
| **Virtualisation / federation** | Query layer over data where it lives, often with its own semantic views | Logical-model-first | Denodo, Starburst, Dremio (SAP) |
| **CPG/retail-specific** | Harmonised retailer POS, syndicated panel, product attributes, planning models | Domain model embedded in product | Crisp, Circana, NIQ, SPINS, Walmart Scintilla, o9, Blue Yonder, Kinaxis, RELEX |

### 2.2 The "store versus connect" axis, vendor side

**(my assessment, built from the profiles below)** Vendors fall into three groups:

- **Definitions only, data stays put.** The semantic layer stores YAML or SQL definitions and compiles queries that run in the customer's warehouse: dbt/MetricFlow ([dbt Labs](https://www.getdbt.com/blog/dbt-labs-affirms-commitment-to-open-semantic-interchange-by-open-sourcing-metricflow)), Snowflake semantic views, Databricks metric views, LookML, Honeydew, Ossie itself. Catalogs (Atlan, Collibra, Alation) store metadata, not data.
- **Query in place but cache or pre-aggregate.** AtScale ("in-memory aggregates", "no data duplication" for Power BI) ([AtScale](https://www.atscale.com/?p=27063)), Kyvos (pre-aggregated semantic models marketed for "billion-scale data") ([Kyvos](https://www.kyvosinsights.com/kyvos-mcp-server/)), Databricks metric view materialisation (preview) ([Databricks](https://www.databricks.com/blog/redefining-semantics-data-layer-future-bi-and-ai)), Denodo/Starburst/Dremio federation with caching, Timbr ("virtualized access to distributed sources with no data movement") ([Timbr](https://www.timbr.ai/platform)), Stardog ("virtualize or materialize") ([Stardog](https://www.stardog.com/product/)).
- **Copy into a governed store, then share zero-copy.** SAP Business Data Cloud (managed SAP data products, zero-copy sharing out to Databricks, Snowflake, Athena) ([SAP](https://news.sap.com/2025/02/sap-databricks-open-bold-new-era-data-ai/)); Palantir Foundry (integrates data into its platform; Ontology objects back it); Microsoft OneLake (mirroring copies, shortcuts reference in place) ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/overview)); MDM hubs (golden records are stored); CPG data providers (Crisp, Circana, NIQ hold and harmonise their own datasets).

The platforms are converging on the same pitch: **one governed copy, many engines** via Apache Iceberg and catalog federation. Snowflake's June 2026 framing is "a single, live, governed copy of their data wherever it resides" ([Snowflake IR](https://investors.snowflake.com/news/news-details/2026/Snowflake-Pioneers-New-Open-Framework-for-Interoperable-Enterprise-Data-and-AI/default.aspx)); AWS publishes AWS Context metadata into S3 Tables in Iceberg format ([AWS](https://aws.amazon.com/blogs/machine-learning/context-intelligence-for-your-data-and-ai-agents-at-scale/)); SAP bought Dremio for its Iceberg/Polaris-native federation ([Futurum](https://futurumgroup.com/insights/can-sap-finally-kill-the-etl-monster-the-dremio-and-prior-labs-acquisition-explained/)).

---

## 3. The 2025-2026 market moves, in date order

| Date | Event | Source |
|---|---|---|
| 5 Feb 2025 (approx.) | SAP launches Business Data Cloud (Datasphere + Analytics Cloud + BW) with SAP Databricks as first-party service | [SAP](https://news.sap.com/2025/02/sap-databricks-open-bold-new-era-data-ai/) |
| 7 May 2025 | ServiceNow agrees to buy data.world (terms undisclosed; data.world valued about $350m in 2022) | [Techzine](https://www.techzine.eu/news/data-management/131208/servicenow-acquires-data-world-to-make-data-ai-ready) |
| 29 May 2025 | AtScale open-sources its Semantic Modeling Language (SML); Home Depot showcase | [AtScale](https://www.atscale.com/?p=27063) |
| 2 Jun 2025 | Cube launches D3 "agentic analytics" with AI Data Analyst and AI Data Engineer agents | [SiliconANGLE](https://siliconangle.com/2025/06/02/semantic-data-layer-startup-cube-automates-analytics-ai-agents) |
| Jun 2025 | Snowflake semantic views: defining GA, querying preview | [Snowflake docs](https://docs.snowflake.com/en/release-notes/2025/june-summit) |
| 24 Jul 2025 | Collibra acquires Deasy Labs (unstructured data governance) | [TechTarget](https://www.techtarget.com/data-technologies/news/366627998/Collibras-acquisition-of-Deasy-targets-unstructured-data) |
| 23-24 Sep 2025 | Open Semantic Interchange launched by Snowflake with 16 partners | [OpenSourceForU](https://www.opensourceforu.com/2025/09/snowflake-salesforce-dbt-labs-blackrock-introduce-open-semantic-interchange/) |
| 3 Oct 2025 | Neo4j commits $100m to product and startups; Aura Agent and MCP server due Q4 2025; reports $200m+ revenue in 2024 | [Intelligent CIO](https://www.intelligentcio.com/north-america/2025/10/03/neo4j-invests-us-100m-in-genai-launches-new-agentic-ai-offerings/) |
| 13-14 Oct 2025 | Fivetran-dbt merger announced; MetricFlow relicensed Apache 2.0 | [dbt Labs](https://www.getdbt.com/blog/fivetran-dbt-labs-complete-merger-to-create-the-data-infrastructure-for-trusted-ai-agents), [dbt Labs](https://www.getdbt.com/blog/dbt-labs-affirms-commitment-to-open-semantic-interchange-by-open-sourcing-metricflow) |
| 4 Nov 2025 | Snowflake-managed MCP server GA; SAP and Snowflake announce zero-copy SAP Snowflake and BDC Connect | [Snowflake docs](https://docs.snowflake.com/release-notes/2025/other/2025-11-04-cortex-agents-mcp), [SAP](https://news.sap.com/2025/11/sap-snowflake-data-enterprise-ai-business-data-fabric/) |
| 18 Nov 2025 | Salesforce completes Informatica acquisition | [Salesforce](https://www.salesforce.com/news/press-releases/2025/11/18/salesforce-completes-acquisition-of-informatica/) |
| 24-25 Nov 2025 | Snowflake agrees to buy Select Star for Horizon Catalog | [Techzine](https://www.techzine.eu/news/analytics/136690/snowflake-acquires-select-star-for-broader-data-context/) |
| 5 Dec 2025 | Atlassian discloses Secoda acquisition for Rovo | [TechTarget](https://www.techtarget.com/searchITOperations/news/366636012/Atlassians-Secoda-acquisition-adds-data-catalog-for-Rovo-AI) |
| Dec 2025 | Crisp raises $26m Series B1 (total $127m) | [AlleyWatch](https://alleywatch.com/2025/12/crisp-vertical-ai-platform-cpg-retail-data-infrastructure-supply-chain-automation-analytics-are-traasdahl/) |
| 18 Dec 2025 | AtScale's largest equity round, led by Snowflake Ventures | [01net/Business Wire](https://www.01net.it/atscale-announces-equity-financing-led-by-snowflake/) |
| Jan 2026 | Gartner MQ for Data & Analytics Governance Platforms (second edition); 15 vendors | [Atlan](https://atlan.com/atlan-named-leader-in-gartner-da-governance-magic-quadrant/) |
| 12 Mar 2026 | ThoughtSpot Spotter Semantics | [ThoughtSpot](https://www.thoughtspot.com/press-releases/thoughtspot-introduces-spotter-semantics-to-bring-trust-and-context-to-enterprise-ai) |
| 19 Mar 2026 | Profisee Fabric-native MDM GA plus MCP server | [Profisee](https://profisee.com/press-release/profisee-brings-end-to-end-master-data-management-fully-into-microsoft-fabric-at-fabcon-2026-adds-fabric-open-mirroring-support-and-copilot-connectivity-via-profisee-mcp-server/) |
| 24 Mar 2026 | Denodo joins OSI | [Denodo](https://denodo.com/en/press-release/2026-03-24/denodo-joins-snowflake-and-industry-leaders-advance-data-and-ai-interoperability-through-open) |
| 27 Mar 2026 | SAP agrees to buy Reltio | [SAP](https://news.sap.com/2026/03/sap-to-acquire-reltio) |
| 2 Apr 2026 | Databricks Unity Catalog Business Semantics (metric views) GA; open-sourcing into Apache Spark | [Databricks](https://www.databricks.com/blog/redefining-semantics-data-layer-future-bi-and-ai) |
| Apr 2026 | Gartner MQ for MDM returns after five years; Reltio, Profisee, Stibo among Leaders | [Reltio](https://www.reltio.com/resources/blog/2026-gartner-magic-quadrant-mdm), [Profisee](https://profisee.com/press-release/profisee-brings-end-to-end-master-data-management-fully-into-microsoft-fabric-at-fabcon-2026-adds-fabric-open-mirroring-support-and-copilot-connectivity-via-profisee-mcp-server/), [Stibo](https://www.stibosystems.com/press-releases/stibo-systems-launches-mcp-server-to-connect-enterprise-master-data-to-ai-agents-at-scale) |
| 22 Apr 2026 | Google renames Dataplex to Knowledge Catalog; Looker managed MCP server (preview) | [Google Cloud](https://cloud.google.com/blog/products/data-analytics/introducing-the-google-cloud-knowledge-catalog), [Google Cloud](https://cloud.google.com/blog/products/business-intelligence/looker-updates-for-agentic-bi-at-next26) |
| 29 Apr 2026 | Atlan Activate: Context Lakehouse, Context Agents, Context Repos | [Atlan](https://atlan.com/know/context-layer-stopped-being-theoretical-activate-2026/) |
| 4 May 2026 | SAP agrees to buy Dremio and invest €1bn in Prior Labs | [Futurum](https://futurumgroup.com/insights/can-sap-finally-kill-the-etl-monster-the-dremio-and-prior-labs-acquisition-explained/) |
| 6 May 2026 | ServiceNow Context Engine and Data Catalog; Collibra AI Command Center | [ServiceNow](https://newsroom.servicenow.com/press-releases/details/2026/ServiceNow-launches-the-real-time-data-foundation-that-puts-autonomous-AI-to-work-across-the-enterprise/default.aspx), [Collibra](https://www.collibra.com/company/newsroom/press-releases/collibra-launches-ai-command-center-to-scale-agentic-ai) |
| 7 May 2026 | RELEX Open with MCP | [RELEX](https://www.relexsolutions.com/news/relex-launches-relex-open-giving-customers-three-ways-to-accelerate-ai-adoption/) |
| 12 May 2026 | SAP Sapphire: SAP Business AI Platform with SAP Knowledge Graph at its core | [SAP](https://news.sap.com/2026/05/sap-sapphire-sap-unveils-autonomous-enterprise/) |
| 20 May 2026 | Informatica (Salesforce) "headless" data management: MCP servers on AWS | [Salesforce](https://www.salesforce.com/news/press-releases/2026/05/20/informatica-announces-headless-data-management-aws/) |
| 1 Jun 2026 | Fivetran + dbt Labs merger completes | [dbt Labs](https://www.getdbt.com/blog/fivetran-dbt-labs-complete-merger-to-create-the-data-infrastructure-for-trusted-ai-agents) |
| 2 Jun 2026 | Snowflake Summit: Horizon Context, Semantic Studio; Microsoft Build: Fabric IQ workload GA (ontology still preview) | [Constellation](https://constellationr.com/insights/news/snowflake-summit-2026-context-custom-model-training-iceberg-v3), [Let's Data Science](https://letsdatascience.com/news/microsoft-expands-fabric-iq-as-a-context-layer-for-ai-agents-e9a90bd8) |
| 16 Jun 2026 | Databricks Unity Catalog Semantics and Genie Ontology | [Databricks](https://databricks.com/blog/whats-new-unity-catalog-data-ai-summit-2026) |
| 17 Jun 2026 | AWS Context announced ("coming soon") | [AWS](https://aws.amazon.com/blogs/machine-learning/context-intelligence-for-your-data-and-ai-agents-at-scale/) |
| 29 Jun 2026 | Stibo MCP server | [Stibo](https://www.stibosystems.com/press-releases/stibo-systems-launches-mcp-server-to-connect-enterprise-master-data-to-ai-agents-at-scale) |
| 6 Jul 2026 | SAP completes Dremio | [SAP](https://news.sap.com/2026/07/sap-completes-dremio-acquisition/) |
| 10 Jul 2026 | OSI enters Apache Incubator as Apache Ossie | [Apache Ossie](https://ossie.apache.org/updates/ossie-enters-apache-incubator/) |
| 14 Jul 2026 | Alation AIOS | [Alation](https://www.alation.com/news-and-press/alation-launches-aios-intelligence-operating-system/) |
| 13 Aug 2026 | Gartner Market Overview for AI Context Platforms | [Neo4j citing Gartner](https://neo4j.com/press-releases/neo4j-context-engine/), [Graphwise](https://graphwise.ai/?p=254087) |
| 28 Aug 2026 | Snowflake recommends moving from Cortex Analyst to Cortex Agents | [Snowflake docs](https://docs.snowflake.com/release-notes/2026/other/2026-08-28-cortex-analyst-transition-cortex-agents) |
| Sep 2026 | Dreamforce: Headless Data 360 MCP GA; Agent Context Engine GA "December" | [Info-Tech](https://www.softwarereviews.com/vendor-technology-notes/dreamforce-2026-data-360-tableau-informatica) |
| 5 Oct 2026 | Collibra acquires trail ML (AI governance) | [Unite.AI](https://unite.ai/collibra-buys-trail-ml-adding-agent-powered-ai-governance-automation) |
| 6 Oct 2026 | Forrester: Microsoft repositioning Fabric as "a governed context layer for enterprise AI" | [Forrester](https://www.forrester.com/blogs/microsoft-fabcon-2026-enterprise-ai-needs-a-governed-context-layer-not-just-data/) |
| 7 Oct 2026 | Circana Liquid AI exposed over MCP and A2A | [Circana](https://www.circana.com/post/ai-access-vs-ai-intelligence-a-cto-guide) |
| 20 Oct 2026 | Neo4j Context Engine (private preview) | [Neo4j](https://neo4j.com/press-releases/neo4j-context-engine/) |

---

## 4. The standards picture: OSI / Apache Ossie

**What it is.** A vendor-neutral YAML specification for exchanging semantic models (datasets, fields, metrics, dimensions, relationships, plus an `ai_context` block with instructions for agents), Apache 2.0 licensed, with compliance tests that "verify consistent query results, not just matching model structure" ([Apache Ossie home](https://ossie.apache.org/)).

**Who started it.** Snowflake announced it on 23 September 2025. Co-leads: Snowflake, Salesforce, BlackRock, dbt Labs, RelationalAI. Supporting partners: Alation, Atlan, Blue Yonder, Cube, Elementum AI, Hex, Honeydew, Mistral AI, Omni, Select Star, Sigma, ThoughtSpot ([OpenSourceForU](https://www.opensourceforu.com/2025/09/snowflake-salesforce-dbt-labs-blackrock-introduce-open-semantic-interchange/)). Seventeen in total, which matches Ossie's "17 launch partners" ([Apache Ossie](https://ossie.apache.org/updates/ossie-enters-apache-incubator/)). Note Blue Yonder, a supply chain planner widely used in CPG, was in the launch group.

**Who joined later (opened sources).** AtScale (listed in the ecosystem; a January 2026 joining date was seen only in search results), Collate, Denodo (24 March 2026) ([Denodo](https://denodo.com/en/press-release/2026-03-24/denodo-joins-snowflake-and-industry-leaders-advance-data-and-ai-interoperability-through-open)), Collibra (member by June 2026) ([Collibra](https://www3.collibra.com/company/newsroom/press-releases/snowflake-and-collibra-expand-partnership-to-bring-governed-business-context-and-semantics)), Databricks (by April 2026) ([Databricks](https://www.databricks.com/blog/redefining-semantics-data-layer-future-bi-and-ai)). The current ecosystem page lists, among others: Actian, Alation, Alteryx, Anomalo, App Orchid, Ataccama, Atlan, AtScale, Bigeye, BlackRock, Blue Yonder, CARTO, Celonis, Cloudera, Coalesce, Collate, Collibra, Count, Credible, Cube, Dataiku, Databricks, DataHub, Denodo, dbt Labs, Dremio, Domo, Firebolt, GoodData, Hex, Holistics, Honeydew, Informatica, Instacart, JetBrains, Kyvos, Lightdash, Metabase, **Microsoft**, Mistral AI, NVIDIA, Omni, **Oracle**, Preset, PuppyGraph, Qlik, RelationalAI, Salesforce, Select Star, **ServiceNow**, Sigma, Snowflake, SqlDBM, Starburst, Strategy, Tabular Editor, ThoughtSpot, Veezoo, Witboost, Zeta Global ([Ossie ecosystem](https://ossie.apache.org/ecosystem/)).

**Converters that actually exist.** Ossie-to-dbt MetricFlow and Apache Polaris converters are merged ([Apache Ossie](https://ossie.apache.org/updates/ossie-enters-apache-incubator/)); Databricks maintains metric view to/from Ossie converters; Snowflake, Honeydew, Holistics, Strategy and SqlDBM list import/export; Iqea built a DuckDB extension that executes Ossie models and serves them over MCP; NeverBlink converts LinkML ontologies to Ossie ([Ossie ecosystem](https://ossie.apache.org/ecosystem/)). Collibra can publish governed models into Snowflake "as OSI documents or Snowflake Semantic Views" (preview, broader availability planned Q3 2026) ([Collibra](https://www3.collibra.com/company/newsroom/press-releases/snowflake-and-collibra-expand-partnership-to-bring-governed-business-context-and-semantics)).

**Who is missing, and why it matters (my assessment).** Google (Looker/LookML), AWS, SAP, Palantir, Neo4j and IBM are not listed. For a CPG company, the SAP absence matters most: SAP Datasphere and the SAP Knowledge Graph hold the business semantics of the ERP, and SAP's own route to other platforms is zero-copy data products rather than an exchangeable semantic spec. Google's absence matters for anyone using Looker. Forrester explicitly recommends favouring "RDF ontologies and Apache Ossie" to avoid hyperscaler lock-in ([Forrester](https://www.forrester.com/blogs/microsoft-fabcon-2026-enterprise-ai-needs-a-governed-context-layer-not-just-data/)).

**Caveat.** ASF incubation "does not guarantee graduation"; the project describes itself as "yet to be fully endorsed by the ASF" ([Ossie ecosystem page footer](https://ossie.apache.org/ecosystem/)). The spec has no standard semantic *query* language yet; that is on the roadmap ([Apache Ossie](https://ossie.apache.org/updates/ossie-enters-apache-incubator/)).

---

## 5. Analyst views (what is public)

**Gartner.**
- *Market Overview for AI Context Platforms*, 13 August 2026, by Kjell Carlsson, Afraz Jaffri, Christopher Long and Radu Miclaus ([Neo4j press release citing it](https://neo4j.com/press-releases/neo4j-context-engine/)). As reported by Graphwise: definition "software that enables data and AI engineering teams to construct, govern and deliver semantically organized knowledge" to agents at runtime; market $28bn (2026) to $78bn (2030); planning assumption that by 2027 organisations prioritising semantics could raise agentic AI accuracy "by up to 80%" and cut costs "by up to 60%"; representative vendors include AWS, Databricks, Google, IBM, Microsoft, Snowflake and Graphwise ([Graphwise](https://graphwise.ai/?p=254087)). **Unverified against Gartner** (abstract page returned HTTP 403). The $28bn figure is surprisingly large for a category this new; it presumably includes parts of existing catalog, graph and search markets **(my assessment)**.
- *Magic Quadrant for Data & Analytics Governance Platforms*, January 2026, 15 vendors evaluated; Atlan moved from Visionary to Leader ([Atlan](https://atlan.com/atlan-named-leader-in-gartner-da-governance-magic-quadrant/)); Collibra calls itself "2x Gartner Magic Quadrant Leader" ([Collibra](https://www3.collibra.com/company/newsroom/press-releases/snowflake-and-collibra-expand-partnership-to-bring-governed-business-context-and-semantics)). Informatica's Leader placement was seen only in search results (not opened).
- *Magic Quadrant for MDM Solutions*, April 2026, the first in about five years: Reltio Leader "positioned furthest for Completeness of Vision" ([Reltio](https://www.reltio.com/resources/blog/2026-gartner-magic-quadrant-mdm)); Profisee Leader ([Profisee](https://profisee.com/press-release/profisee-brings-end-to-end-master-data-management-fully-into-microsoft-fabric-at-fabcon-2026-adds-fabric-open-mirroring-support-and-copilot-connectivity-via-profisee-mcp-server/)); Stibo Leader in both MDM and PIM MQs ([Stibo](https://www.stibosystems.com/press-releases/stibo-systems-launches-mcp-server-to-connect-enterprise-master-data-to-ai-agents-at-scale)). Informatica and Semarchy also claim Leader (search results only).
- *Market Guide for Agentic Analytics*, February 2026, cited by Cube and GoodData ([GoodData](https://www.gooddata.ai/press-releases/gooddata-kicks-off-2026-with-mcp-server-launch-and-major-enterprise-wins/)).

**Forrester.**
- On Microsoft (6 October 2026, Indranil Bandyopadhyay): Microsoft is repositioning Fabric as "a governed context layer for enterprise AI"; "Context cannot be defined by data and technology teams alone"; define the logical architecture before choosing a platform; "Use the first implementation to test whether shared definitions improve answers, decisions, or execution"; favour standards (RDF ontologies, Apache Ossie) because hyperscalers are building separate context graphs ([Forrester](https://www.forrester.com/blogs/microsoft-fabcon-2026-enterprise-ai-needs-a-governed-context-layer-not-just-data/)).
- On Databricks (7 July 2026): context is one of four Databricks priorities, delivered via Genie Ontology; "Customers should ensure that Databricks meets requirements for each workload" ([Forrester](https://www.forrester.com/blogs/databricks-unleashes-the-genie-the-power-of-the-four-cs/)).
- On Atlassian/Secoda, Charles Betz: Secoda adds "a customer-specific corporate ontology" to Atlassian's Teamwork graph; Jira is "an absolute gold mine of semantic information" ([TechTarget](https://www.techtarget.com/searchITOperations/news/366636012/Atlassians-Secoda-acquisition-adds-data-catalog-for-Rovo-AI)).
- A June 2026 Forrester report titled *Make Data AI Ready Via Semantic Layer Platforms* exists (distributed by Strategy), but the page could not be opened; no Forrester Wave dedicated to semantic layers was found.

**BARC.** On SAP/Reltio: the deal adds the "context layer" SAP needed; "Without such a context layer, AI working across fragmented enterprise data produces results that cannot be trusted"; risk of "a SAP-bound master data layer"; Reltio may "complement or even replace" SAP MDG; "Getting MDM done is more about the process, than the technology" ([BARC](https://barc.com/barc-perspective-sap-acquires-reltio/)). No BARC survey dedicated to semantic layers was found.

**IDC.** Stewart Bond, in Alation's AIOS launch: "What's missing isn't another AI platform; it's an operating system that keeps data, context, and agents in sync" ([Alation](https://www.alation.com/news-and-press/alation-launches-aios-intelligence-operating-system/)). No IDC MarketScape on semantic layers was found.

**GigaOm.** 2025 Radar for Semantic Layers and Metrics Stores: Cube "Leader and Outperformer" ([Cube](https://cube.dev/blog/cube-cloud-named-leader-and-outperformer-in-2025-gigaom-radar-for-semantic)); AtScale "Leader and Fast Mover" ([01net/Business Wire](https://www.01net.it/atscale-announces-equity-financing-led-by-snowflake/)). Microsoft also claims Leader (Microsoft post not opened).

**Other analysts and commentators.**
- Info-Tech on Salesforce: strategy "coherent", principal risk execution; open question whether Tableau Semantics can become "a genuinely open enterprise semantic layer" ([Info-Tech](https://www.softwarereviews.com/vendor-technology-notes/dreamforce-2026-data-360-tableau-informatica)).
- Constellation on Snowflake: "Snowflake is preparing for a world where it no longer needs to own the data format to own the customer relationship" ([Constellation](https://constellationr.com/insights/news/snowflake-summit-2026-context-custom-model-training-iceberg-v3)).
- Everest Group on consolidation: "If context cannot move across clouds, enterprises will end up with smarter platforms but a more fragmented ecosystem"; the future of "catalog-of-catalogs" tools is "less certain" ([Everest](https://www.everestgrp.com/blogs/snowflakes-select-star-move-when-data-finally-meets-its-context/)).
- Futurum on SAP/Dremio: "no enterprise is 100% SAP"; the real test is how fast Dremio's federation becomes native in Datasphere and BDC ([Futurum](https://futurumgroup.com/insights/can-sap-finally-kill-the-etl-monster-the-dremio-and-prior-labs-acquisition-explained/)).
- William McKnight (TechTarget) on Neo4j: Context Engine "must move beyond read-only retrieval"; no native CDC connectors, no write-back; warns of "graph sprawl" ([TechTarget](https://www.techtarget.com/data-technologies/news/366652383/Neo4j-joins-the-context-cavalcade-with-suite-for-informing-AI-agents)).
- **The sceptic's view.** Joe Reis (11 March 2026, satirical) on Gartner's "Year of Context": new terms like "context fabric" look like data fabric and data mesh with a new name and a higher price, though he concedes organisations really are poor at managing context ([Joe Reis](https://joereis.substack.com/p/gartner-declares-2026-the-year-of)). Runtime's Snowflake coverage notes the "context is king" pitch comes almost entirely from Snowflake executives with no availability dates for Horizon Context ([Runtime](https://www.runtime.news/snowflake-thinks-context-is-king/)).

---

## 6. Vendor profiles

### 6A. Data platforms with native semantic and context layers

#### Snowflake (semantic views, Cortex Analyst/Agents, Horizon Catalog and Horizon Context)
- **Category:** platform-native semantic layer plus catalog/context layer.
- **What it does:** Semantic views are schema-level objects holding a semantic model; Cortex Analyst uses them to generate SQL ([Snowflake docs](https://docs.snowflake.com/en/release-notes/2025/june-summit)). Horizon Context (June 2026) adds "a context layer for AI and business intelligence to deliver one version of the truth"; Semantic Studio defines shared logic without SQL; Semantic View Autopilot auto-refines semantic views ([Constellation](https://constellationr.com/insights/news/snowflake-summit-2026-context-custom-model-training-iceberg-v3)).
- **Store or query:** Stores data in Snowflake or Iceberg; definitions live alongside. Zero-copy access to SAP data products (GA), Salesforce (GA soon), Workday (private preview), with AVEVA and IBM partnerships "without replication" ([Snowflake IR](https://investors.snowflake.com/news/news-details/2026/Snowflake-Pioneers-New-Open-Framework-for-Interoperable-Enterprise-Data-and-AI/default.aspx)). AVEVA matters for manufacturing/OT data.
- **Interfaces:** SQL; Cortex Analyst REST API (still available); Cortex Agents; Snowflake-managed MCP server (GA 4 November 2025) serving Cortex Analyst and Cortex Search as tools with OAuth and RBAC ([Snowflake docs](https://docs.snowflake.com/release-notes/2025/other/2025-11-04-cortex-agents-mcp)).
- **Agent features 2025-26:** From April 2026 agents using semantic views generate SQL directly rather than delegating to Cortex Analyst ([Snowflake docs](https://docs.snowflake.com/release-notes/2026/other/2026-04-13-cortex-agents-agentic-analyst)). On 28 August 2026 Snowflake recommended moving from Cortex Analyst to Cortex Agents; "semantic views carry over unchanged" and verified queries continue to apply ([Snowflake docs](https://docs.snowflake.com/release-notes/2026/other/2026-08-28-cortex-analyst-transition-cortex-agents)). Snowflake Intelligence was rebranded CoWork; Cortex Sense assembles "data, business definitions and operational knowledge for AI agents" ([Constellation](https://constellationr.com/insights/news/snowflake-summit-2026-context-custom-model-training-iceberg-v3)).
- **Status caveat:** Horizon Context availability is unclear; Constellation describes the additions as a mix of preview, coming-soon and GA without assigning each ([Constellation](https://constellationr.com/insights/news/snowflake-summit-2026-context-custom-model-training-iceberg-v3)).
- **Customers named (2026 releases):** Affirm, Indeed, NTT DOCOMO, Samsung Ads; 13,900+ customers ([Snowflake IR](https://investors.snowflake.com/news/news-details/2026/Snowflake-Pioneers-New-Open-Framework-for-Interoperable-Enterprise-Data-and-AI/default.aspx)); AstraZeneca for SAP zero-copy ([SAP](https://news.sap.com/2025/11/sap-snowflake-data-enterprise-ai-business-data-fabric/)).
- **Moves:** OSI founder; Select Star acquisition; Snowflake Ventures led AtScale's round. CEO Sridhar Ramaswamy says CoWork and CoCo are "seeing the fastest adoption of any new products in our history" (vendor claim) ([Constellation](https://constellationr.com/insights/news/snowflake-summit-2026-context-custom-model-training-iceberg-v3)).

#### Databricks (Unity Catalog metric views, Unity Catalog Semantics, Genie and Genie Ontology)
- **Category:** platform-native semantic layer plus catalog/context layer.
- **What it does:** Metric views define "data mappings, measures, and dimensions centrally in SQL", stored in Unity Catalog with synonyms and display metadata; Business Semantics went GA on 2 April 2026, with UI authoring in public preview and materialisation in preview ([Databricks](https://www.databricks.com/blog/redefining-semantics-data-layer-future-bi-and-ai)). In June 2026 Databricks added Unity Catalog Semantics: a Glossary (preview "coming soon", with Genie Code drafting pages and flagging definitions that drift from data usage), Domains (public preview), and metric import from Power BI and Tableau (beta) ([Databricks](https://databricks.com/blog/whats-new-unity-catalog-data-ai-summit-2026)). **Genie Ontology** is "a continuously learned enterprise context layer", fed by Unity Catalog semantics and a column-popularity signal from query history ([Databricks](https://databricks.com/blog/whats-new-unity-catalog-data-ai-summit-2026)).
- **Store or query:** Lakehouse storage (Delta/Iceberg); Delta Sharing and "OpenSharing" for zero-copy sharing; external lineage GA ([Databricks](https://databricks.com/blog/whats-new-unity-catalog-data-ai-summit-2026)).
- **Interfaces:** SQL, APIs, MCP ("semantics are accessible to agents through MCPs"); managed MCP services for Google Drive, Jira, Slack, GitHub; Unity Gateway governs "models, agents, tools, and MCPs under one runtime governance layer" ([Databricks](https://databricks.com/blog/whats-new-unity-catalog-data-ai-summit-2026)).
- **Open source:** core metric view implementation being contributed to Apache Spark (SPARK-54119); joined Apache Ossie ([Databricks](https://www.databricks.com/blog/redefining-semantics-data-layer-future-bi-and-ai)).
- **Partners consuming metric views:** Tableau (delegated semantics expected late 2026), Sigma, ThoughtSpot, Hex, Omni, Atlan, Collibra, Monte Carlo, Domo, Anomalo ([Databricks](https://www.databricks.com/blog/redefining-semantics-data-layer-future-bi-and-ai)).
- **Customers named:** iFood ("Queries are significantly faster, in some cases up to 10x"), Zalando ([Databricks](https://www.databricks.com/blog/redefining-semantics-data-layer-future-bi-and-ai)). More than 14,000 organisations use Unity Catalog ([Databricks](https://databricks.com/blog/whats-new-unity-catalog-data-ai-summit-2026)).

#### Microsoft (Power BI / Fabric semantic models, Fabric IQ, Microsoft IQ)
- **Category:** platform-native semantic layer plus ontology/context layer.
- **What it does:** Fabric IQ is part of **Microsoft IQ** alongside Work IQ (how employees work), Foundry IQ (policies and documents) and Web IQ; Fabric IQ "provides context on business entities and data". It has two core items: **semantic model** (Power BI measures, hierarchies, dimensions) and **ontology (preview)**, which "defines entity types, properties, relationships, rules, and metrics, and binds them to live enterprise data" ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/overview)).
- **How ontologies are built (brief question 2):** "from scratch or generate them from existing Power BI semantic models", carrying DAX measures across as metrics; an ontology agent drafts definitions and data bindings under a "proposal-first model"; import from RDF or OWL ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/overview)). Forrester adds an "agentic experience for building ontologies from semantic models and documents" ([Forrester](https://www.forrester.com/blogs/microsoft-fabcon-2026-enterprise-ai-needs-a-governed-context-layer-not-just-data/)).
- **Store or query:** OneLake mirroring copies; **shortcuts reference external data in place "without copying or building ETL pipelines"** ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/overview)). At FabCon 2026: BigQuery mirroring, bidirectional Salesforce Data 360 integration, and "IQ sharing" (preview) of governed tables, agent instructions and RDF ontologies ([Forrester](https://www.forrester.com/blogs/microsoft-fabcon-2026-enterprise-ai-needs-a-governed-context-layer-not-just-data/)).
- **Interfaces:** DAX measures (Power BI), GraphQL (generated APIs in Fabric Apps, preview), MCP. Microsoft's documentation positions **Fabric IQ** as the consumption route for agents and the **Power BI Authoring MCP server** (local GA, hosted preview) for building models; an older Power BI consumption MCP is "still documented for existing integrations" ([Microsoft Learn](https://learn.microsoft.com/en-us/power-bi/developer/mcp/mcp-servers-overview)).
- **Status:** Fabric IQ workload reported GA on 2 June 2026 at Build, with ontologies "expected to reach general availability later" ([Let's Data Science](https://letsdatascience.com/news/microsoft-expands-fabric-iq-as-a-context-layer-for-ai-agents-e9a90bd8)). Microsoft Learn still labels ontology "(preview)" as of this research ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/overview)). Operations agents GA since June 2026 ([Forrester](https://www.forrester.com/blogs/microsoft-fabcon-2026-enterprise-ai-needs-a-governed-context-layer-not-just-data/)).
- **Customers named:** none found in the Fabric IQ material.
- **Moves:** in the Ossie ecosystem ([Ossie ecosystem](https://ossie.apache.org/ecosystem/)). Profisee and Stibo have both built MDM integrations into Fabric/Copilot ([Profisee](https://profisee.com/press-release/profisee-brings-end-to-end-master-data-management-fully-into-microsoft-fabric-at-fabcon-2026-adds-fabric-open-mirroring-support-and-copilot-connectivity-via-profisee-mcp-server/), [Stibo](https://www.stibosystems.com/press-releases/stibo-systems-launches-mcp-server-to-connect-enterprise-master-data-to-ai-agents-at-scale)).

#### Google Cloud (Looker/LookML, BigQuery, Knowledge Catalog)
- **Category:** platform-native semantic layer (LookML) plus catalog/context layer.
- **What it does:** Looker's LookML is the longest-established semantic layer in this list. At Next '26 (22 April 2026): a managed Looker MCP server (preview) alongside the open-source MCP Toolbox route; Conversational Analytics agent GA with upgrades in preview; embedded conversational analytics GA; CI/CD GA; and "With Knowledge Catalog, Looker transforms metadata into a semantic graph" (preview) ([Google Cloud](https://cloud.google.com/blog/products/business-intelligence/looker-updates-for-agentic-bi-at-next26)). **Knowledge Catalog** is Dataplex renamed, "the universal context engine for your enterprise", which pulls "BigQuery measures and LookML together into a single, governed semantic foundation" ([Google Cloud](https://cloud.google.com/blog/products/data-analytics/introducing-the-google-cloud-knowledge-catalog)); documentation lists local and remote MCP servers and an upgrade path from Dataplex ([Google docs](https://docs.cloud.google.com/dataplex/docs/overview)).
- **Store or query:** BigQuery storage; Knowledge Catalog harvests metadata from third-party catalogs (Atlan, Collibra, DataHub, Ab Initio, Anomalo) and, in preview, enterprise systems (Palantir, Salesforce Data360, **SAP**, ServiceNow, Workday) ([Google Cloud](https://cloud.google.com/blog/products/data-analytics/introducing-the-google-cloud-knowledge-catalog)).
- **Status:** GA for metadata aggregation, data products and semantic search; preview for Looker metadata harvesting, BigQuery measures, verified queries and semantic guardrails ([Google Cloud](https://cloud.google.com/blog/products/data-analytics/introducing-the-google-cloud-knowledge-catalog)).
- **Design point worth noting (my assessment):** Looker's MCP approach keeps SQL generation out of the LLM; the agent asks for governed fields and Looker writes the SQL. Same principle as Cube, AtScale, ThoughtSpot ("deterministic... not text-to-SQL powered by LLMs") ([ThoughtSpot](https://www.thoughtspot.com/press-releases/thoughtspot-introduces-spotter-semantics-to-bring-trust-and-context-to-enterprise-ai)).
- **Customers named:** YouTube, Promevo ([Google Cloud](https://cloud.google.com/blog/products/business-intelligence/looker-updates-for-agentic-bi-at-next26)); Bloomberg Media launched a "Data Access AI Agent" on Knowledge Catalog ([Google Cloud](https://cloud.google.com/blog/products/data-analytics/introducing-the-google-cloud-knowledge-catalog)).
- **Moves:** Not in Ossie.

#### AWS (AWS Context, Glue Data Catalog, SageMaker Catalog, Amazon Quick)
- **Category:** catalog/context layer with knowledge graph.
- **What it does:** AWS Context "automatically maps the relationships across your existing data into a knowledge graph", extending the graph behind Amazon Quick to an organisation-wide context layer that learns join paths from agent usage ([AWS](https://aws.amazon.com/blogs/machine-learning/context-intelligence-for-your-data-and-ai-agents-at-scale/)).
- **Store or query:** metadata only; inherits IAM and Lake Formation permissions; key metadata published to S3 Tables in Iceberg so Athena, Redshift or Spark can query it; third-party catalogs can connect ([AWS](https://aws.amazon.com/blogs/machine-learning/context-intelligence-for-your-data-and-ai-agents-at-scale/)).
- **Interfaces:** agentic search APIs and MCP tools, usable from Bedrock AgentCore, EKS or any MCP framework ([AWS](https://aws.amazon.com/blogs/machine-learning/context-intelligence-for-your-data-and-ai-agents-at-scale/)).
- **Status:** "Coming soon" (17 June 2026); Glue Data Catalog business context and semantic search in preview ([AWS](https://aws.amazon.com/blogs/machine-learning/context-intelligence-for-your-data-and-ai-agents-at-scale/)). No customers named.
- **Moves:** Not in Ossie. SAP announced zero-copy integration between BDC and Amazon Athena ([SAP](https://news.sap.com/2026/05/sap-sapphire-sap-unveils-autonomous-enterprise/)); Informatica's MCP servers are on AWS Agent Registry (preview) ([Salesforce](https://www.salesforce.com/news/press-releases/2026/05/20/informatica-announces-headless-data-management-aws/)).

#### SAP (Business Data Cloud, Datasphere, SAP Knowledge Graph, Reltio, Dremio)
- **Category:** platform-native semantic layer, knowledge graph, MDM and federation, all now in one portfolio.
- **What it does:** BDC (February 2025) unifies Datasphere, SAP Analytics Cloud and BW, and delivers "fully managed SAP data products" aligned to a "one domain model", "maintaining their original business context and semantics"; Datasphere is used to "build a powerful knowledge graph of all your data, preserving its business metadata and semantics" ([SAP](https://news.sap.com/2025/02/sap-databricks-open-bold-new-era-data-ai/)). At Sapphire (12 May 2026), the **SAP Business AI Platform** unifies BTP, BDC and Business AI with the **SAP Knowledge Graph** at its core, which "gives AI agents a structured map of business entities, processes and relationships across a customer's SAP landscape"; 50+ Joule Assistants orchestrate 200+ agents ([SAP](https://news.sap.com/2026/05/sap-sapphire-sap-unveils-autonomous-enterprise/)).
- **Store or query:** a hybrid. SAP data products are managed copies inside BDC; **zero-copy** sharing out: Databricks via Delta Sharing ([SAP](https://news.sap.com/2025/02/sap-databricks-open-bold-new-era-data-ai/)), Snowflake bidirectionally (SAP Snowflake planned GA Q1 2026; BDC Connect for Snowflake H1 2026) ([SAP](https://news.sap.com/2025/11/sap-snowflake-data-enterprise-ai-business-data-fabric/)), Amazon Athena ([SAP](https://news.sap.com/2026/05/sap-sapphire-sap-unveils-autonomous-enterprise/)). Dremio adds Iceberg-native federation over non-SAP data "without the costly, complex data movement" ([Futurum](https://futurumgroup.com/insights/can-sap-finally-kill-the-etl-monster-the-dremio-and-prior-labs-acquisition-explained/)).
- **MDM:** Reltio (completed by May 2026) becomes "a core capability within SAP BDC", remains sold standalone, and supplies "golden record" entity resolution across SAP and non-SAP sources ([SAP](https://news.sap.com/2026/03/sap-to-acquire-reltio)). BARC reports Reltio at **$185m ARR (FY ending January 2026), 40% bookings growth, 200+ large enterprise customers** ([BARC](https://barc.com/barc-perspective-sap-acquires-reltio/)).
- **Interfaces:** Datasphere SQL/OData (not re-verified here); Joule agents; agent-to-agent interoperability with Google and Microsoft frameworks ([SAP](https://news.sap.com/2026/05/sap-sapphire-sap-unveils-autonomous-enterprise/)). Reltio supports MCP ([ITdaily](https://itdaily.com/news/business/sap-reltio-afronding/)). The Sapphire release does not mention MCP.
- **Customers named:** AstraZeneca (Snowflake zero-copy) ([SAP](https://news.sap.com/2025/11/sap-snowflake-data-enterprise-ai-business-data-fabric/)); RWE (Industry AI) ([SAP](https://news.sap.com/2026/05/sap-sapphire-sap-unveils-autonomous-enterprise/)). No CPG names in the opened releases.
- **Moves:** Not in Ossie. **For CPG clients (my assessment):** most large CPG companies run SAP; SAP now owns the MDM vendor with the furthest "vision" placement in Gartner's MDM MQ and a federation engine. Expect SAP to argue that the semantic and context layer should be anchored in BDC; expect Snowflake and Databricks to argue the opposite via zero-copy.

#### Salesforce (Data 360, Tableau Semantics, Agentforce, Informatica)
- **Category:** platform-native semantic layer (customer domain) plus catalog, MDM and context layer via Informatica.
- **What it does:** Data 360 has been repositioned "from a customer data platform into a governed context service for any authorized agent"; Headless Data 360's MCP server is GA with "nearly 200 APIs"; Tableau Semantics and its Auto Knowledge Graph supply governed metrics and definitions to agents; Agent Context Engine GA "December"; zero-copy to BigQuery in both directions ([Info-Tech](https://www.softwarereviews.com/vendor-technology-notes/dreamforce-2026-data-360-tableau-informatica)). Informatica brings "data catalog, integration, governance, quality and privacy, metadata management, and Master Data Management" ([Salesforce](https://www.salesforce.com/news/press-releases/2025/11/18/salesforce-completes-acquisition-of-informatica/)). Informatica's MCP servers (Metadata Explorer, MDM, data quality) are on AWS Agent Registry (preview) and Amazon Quick (GA in US regions) ([Salesforce](https://www.salesforce.com/news/press-releases/2026/05/20/informatica-announces-headless-data-management-aws/)); Informatica also offers a plugin for Claude Code and Claude Cowork; MDM agents claim to cut mastering "from months to hours" (Info-Tech calls this directional) ([Info-Tech](https://www.softwarereviews.com/vendor-technology-notes/dreamforce-2026-data-360-tableau-informatica)).
- **Store or query:** Data 360 stores unified profiles but uses zero-copy to Snowflake, Databricks, BigQuery; Informatica catalogs in place and masters into a hub.
- **Analyst caveat:** Data 360 "does not by itself provide the enterprise-wide integration, quality, catalog, lineage" capabilities of Informatica; AI Control Plane rolls out from early fiscal 2028 ([Info-Tech](https://www.softwarereviews.com/vendor-technology-notes/dreamforce-2026-data-360-tableau-informatica)).
- **Moves:** OSI co-lead; Informatica closed 18 November 2025 ([Salesforce](https://www.salesforce.com/news/press-releases/2025/11/18/salesforce-completes-acquisition-of-informatica/)).

#### ServiceNow (Workflow Data Fabric, Context Engine, Data Catalog from data.world)
- **Category:** catalog/context layer tied to workflow.
- **What it does:** Context Engine "maps every person, role, asset, service, and policy across a business in real time"; Data Catalog (available now) gives "end-to-end visibility" with discovery, lineage and a shared business glossary; Workflow Data Fabric plus Live Connect offers access "without pipelines, data copies, or latency"; MCP Registry available via Innovation Lab ([ServiceNow](https://newsroom.servicenow.com/press-releases/details/2026/ServiceNow-launches-the-real-time-data-foundation-that-puts-autonomous-AI-to-work-across-the-enterprise/default.aspx)). The release does not mention data.world by name; the catalog is the most likely successor to the May 2025 acquisition **(my inference)**.
- **Customers named:** PayPal, Zespri ([ServiceNow](https://newsroom.servicenow.com/press-releases/details/2026/ServiceNow-launches-the-real-time-data-foundation-that-puts-autonomous-AI-to-work-across-the-enterprise/default.aspx)).
- **Moves:** In the Ossie ecosystem ([Ossie ecosystem](https://ossie.apache.org/ecosystem/)).

### 6B. Independent ("universal") semantic layers

#### dbt Labs / Fivetran (dbt Semantic Layer, MetricFlow)
- **What it does:** MetricFlow compiles metric definitions in YAML into multi-dialect SQL; relicensed Apache 2.0 on 14 October 2025, and "MetricFlow will be a central component in realizing the vision of the OSI initiative" ([dbt Labs](https://www.getdbt.com/blog/dbt-labs-affirms-commitment-to-open-semantic-interchange-by-open-sourcing-metricflow)). Merger completed 1 June 2026, launching dbt Core v2.0 (alpha, Fusion runtime under Apache 2.0), dbt State (preview, claimed 30%+ infrastructure saving, vendor claim), dbt Wizard (beta) and **Agents Schema**, "an open source standard for agentic context" stored as SQL tables ([dbt Labs](https://www.getdbt.com/blog/fivetran-dbt-labs-complete-merger-to-create-the-data-infrastructure-for-trusted-ai-agents)).
- **Store or query:** definitions only; queries run in the customer's warehouse.
- **Interfaces:** the merger release does not restate Semantic Layer APIs; a remote dbt MCP server reached GA at Coalesce 2025 (seen in dbt's own blog title in search results; not opened, treat as **unverified**).
- **Scale:** 100,000+ data teams use dbt; Fivetran customers include OpenAI, Zendesk, Coupa, HubSpot ([dbt Labs](https://www.getdbt.com/blog/fivetran-dbt-labs-complete-merger-to-create-the-data-infrastructure-for-trusted-ai-agents)).

#### Cube
- **What it does:** open-source and cloud semantic layer turned "agentic analytics" platform. D3 (June 2025) added an AI Data Analyst (generates "semantic SQL") and an AI Data Engineer (builds and changes semantic models under human supervision); "What was taking weeks or months now can be done in a matter of days" (vendor claim) ([SiliconANGLE](https://siliconangle.com/2025/06/02/semantic-data-layer-startup-cube-automates-analytics-ai-agents)). Embedded Agentic Analytics (11 June 2026): Analytics Chat API with agent-to-agent calls, iframes, Creator Mode; "in agentic analytics, the semantic layer is a product feature" ([Cube](https://cube.dev/blog/announcing-embedded-agentic-analytics)).
- **Store or query:** queries in place with pre-aggregation caching (Cube's long-standing design; not re-verified in an opened 2026 page).
- **Interfaces:** MCP, SQL, JSON and GraphQL Core Data APIs ([Cube](https://cube.dev/blog/announcing-embedded-agentic-analytics)).
- **Customers named:** Brex ("Spaces" financial reporting) ([Cube](https://cube.dev/blog/announcing-embedded-agentic-analytics)). "Thousands of companies" use Cube's APIs (vendor claim).
- **Moves:** OSI launch partner; GigaOm 2025 Leader ([Cube](https://cube.dev/blog/cube-cloud-named-leader-and-outperformer-in-2025-gigaom-radar-for-semantic)).

#### AtScale
- **What it does:** universal semantic layer with the broadest BI-protocol coverage: **SQL, DAX, MDX and MCP** ([01net/Business Wire](https://www.01net.it/atscale-announces-equity-financing-led-by-snowflake/)); native Power BI DAX/Tabular "with live connectivity and no data duplication"; Postgres wire protocol; in-memory aggregates; **One-Click Modeling** in which "AI scans source data to find metrics, dimensions, and relationships"; open-source SML ([AtScale](https://www.atscale.com/?p=27063)).
- **Store or query:** queries in place with aggregates/caching.
- **Customers named:** **Home Depot** (semantic layer on BigQuery, enterprise-wide self-service in Excel, "sub-second performance on a 20TB cube"), TELUS, Vodafone Portugal, Bluemercury, HSBC ([AtScale](https://www.atscale.com/?p=27063)); Fidelity and Home Depot connect "BI tools and AI agents to governed metrics" ([01net/Business Wire](https://www.01net.it/atscale-announces-equity-financing-led-by-snowflake/)).
- **Moves:** largest equity round, led by Snowflake Ventures, 18 December 2025 (amount undisclosed); joined OSI January 2026 ([Ossie ecosystem](https://ossie.apache.org/ecosystem/)).

#### Kyvos
- **What it does:** semantic layer with pre-aggregated models for very large data; MCP server (local or remote, stdio or HTTPS, OAuth 2.0) giving agents "a consistent, modeled interface, with no manual mapping or duplication" ([Kyvos](https://www.kyvosinsights.com/kyvos-mcp-server/)).
- **Store or query:** pre-aggregates (marketing: "sub-second analytics across massive datasets").
- **Claims:** "100% AI accuracy", ">50% AI savings", "1500x faster"; retail example "24B records analyzed across products, stores, 40M customers"; supply chain "240M+ SKUs, 20K suppliers, 9.5K stores" (all unnamed, all **vendor claims**) ([Kyvos](https://www.kyvosinsights.com/kyvos-mcp-server/)).
- **Moves:** in Ossie ecosystem ([Ossie ecosystem](https://ossie.apache.org/ecosystem/)).

#### GoodData (renamed GoodData.AI in April 2026)
- **What it does:** headless BI with semantic layer; MCP server (January 2026) lets agents "build, update, and operate analytics end-to-end within a governed framework"; Context Management layer; "AI-Driven BI Modernization" extracts business logic from legacy BI into the semantic layer ([GoodData](https://www.gooddata.ai/press-releases/gooddata-kicks-off-2026-with-mcp-server-launch-and-major-enterprise-wins/)).
- **Claims:** 10-50x faster time to value; 123,000+ companies served (boilerplate, vendor claims). Unnamed asset manager and payments customers ([GoodData](https://www.gooddata.ai/press-releases/gooddata-kicks-off-2026-with-mcp-server-launch-and-major-enterprise-wins/)).
- **Moves:** Ossie contributor ([Apache Ossie](https://ossie.apache.org/updates/ossie-enters-apache-incubator/)).

#### Honeydew
- **What it does:** "YAML-based and git-native" semantic layer that "converts bidirectionally with Ossie" ([Ossie ecosystem](https://ossie.apache.org/ecosystem/)). Named as an Ossie contributor ([Apache Ossie](https://ossie.apache.org/updates/ossie-enters-apache-incubator/)) and an OSI launch partner ([OpenSourceForU](https://www.opensourceforu.com/2025/09/snowflake-salesforce-dbt-labs-blackrock-introduce-open-semantic-interchange/)).
- **Funding:** a Snowflake Ventures investment was announced on Snowflake's blog in 2025; that page refused automated access, so the amount and date are **unverified**.

#### Timbr
- **What it does:** "ontology-based semantic layer... built on SQL ontologies"; models concepts, relationships, hierarchies and measures; models can be built from schemas with AI assistance, from SQL DDL, by "LLM-assisted ERD translation", or by OWL import ([Timbr](https://www.timbr.ai/platform)).
- **Store or query:** "Virtualized access to distributed sources with no data movement"; pushdown execution ([Timbr](https://www.timbr.ai/platform)).
- **Interfaces:** SQL, JDBC, ODBC, SQLAlchemy, REST/OpenAPI, BI tools, LangChain/LangGraph ([Timbr](https://www.timbr.ai/platform)). No named customers on the page.

#### Strategy (formerly MicroStrategy) Mosaic
- **What it does:** "universal intelligence layer" (GA June 2025, per Strategy press materials not opened here); the Ossie ecosystem lists Mosaic import from and export to Ossie YAML ([Ossie ecosystem](https://ossie.apache.org/ecosystem/)).

#### ThoughtSpot (Spotter Semantics)
- **What it does:** "agentic semantic layer" (12 March 2026) with a Metrics Catalog, next-generation search tokens for "deterministic SQL generation", aggregate awareness and an MCP server; "this deterministic approach relies on our patented search tokens, not text-to-SQL powered by LLMs" ([ThoughtSpot](https://www.thoughtspot.com/press-releases/thoughtspot-introduces-spotter-semantics-to-bring-trust-and-context-to-enterprise-ai)).
- **Customers named:** Sephora; boilerplate names **Unilever**, Lyft, Comcast, Roche, Schneider Electric, Huel, HubSpot ([ThoughtSpot](https://www.thoughtspot.com/press-releases/thoughtspot-introduces-spotter-semantics-to-bring-trust-and-context-to-enterprise-ai)).
- **Moves:** OSI founding member; integrates with Snowflake, Databricks and dbt models.

### 6C. Catalogs and governance platforms repositioned as context layers

#### Atlan
- **What it does:** active metadata platform now marketed as "the context layer". At Activate (29 April 2026): **Context Agents** (nine agents generating documentation), **Context Engineering Studio** (builds agents and turns dashboards and SQL history into test suites), **Context Repos** ("version-controlled, certified, portable units of business context"), **Context Lakehouse** (Iceberg-native; "any execution engine can read context via MCP, API, or SQL") ([Atlan](https://atlan.com/know/context-layer-stopped-being-theoretical-activate-2026/)).
- **LLM bootstrapping (brief question 2):** 50 teams generated "over one million AI-generated descriptions in two weeks", versus 25,000 human-written descriptions across all customers in 2025; a "9-12 month project reduced to 30 days" (vendor claims) ([Atlan](https://atlan.com/know/context-layer-stopped-being-theoretical-activate-2026/)).
- **Store or query:** stores metadata only.
- **Customers named:** Engine, Elastic (finance "talk-to-your-data": "Any team, any tool, same answer") ([Atlan](https://atlan.com/know/context-layer-stopped-being-theoretical-activate-2026/)); Fox, Workday ([Atlan about](https://atlan.com/about.md)). An unnamed "global lifestyle brand" was still testing a customer-service analytics chatbot after six weeks ([Atlan](https://atlan.com/know/context-layer-stopped-being-theoretical-activate-2026/)).
- **Funding/analysts:** over $200m raised, $105m Series C led by GIC and Meritech; Gartner Leader in D&A governance and metadata management; Forrester Wave Leader ([Atlan about](https://atlan.com/about.md)).
- **Integrity note:** Atlan's own article repeats Promethium's claim of "10-20% accuracy for schema-only grounding and 94-99% for full context" while noting Promethium publishes no methodology ([Atlan](https://atlan.com/know/context-layer-stopped-being-theoretical-activate-2026/)). Treat both numbers as unproven.

#### Collibra
- **What it does:** describes itself as "the enterprise AI control plane" ([Unite.AI](https://unite.ai/collibra-buys-trail-ml-adding-agent-powered-ai-governance-automation)). 2026 releases include: **semantic mapping and model generation** (GA March 2026, "Automatically generate a semantic layer that connects physical data with business terms"); **governed context compiler** (preview July 2026) delivering "semantic models, metrics, business terms, policies" to agents in formats such as Snowflake Semantic Views and Databricks Metric Views; MCP for lineage (GA August 2026) and data quality (GA September 2026); Guardian Agents and Agent Contracts (preview October 2026) ([Collibra](https://www.collibra.com/products/innovations)). AI Command Center launched 6 May 2026 with 40+ enterprises in preview ([Collibra](https://www.collibra.com/company/newsroom/press-releases/collibra-launches-ai-command-center-to-scale-agentic-ai)).
- **MCP adoption:** "more than 100" customers on the MCP server out of 700+ customers ([Collibra](https://www.collibra.com/company/newsroom/press-releases/collibra-launches-ai-command-center-to-scale-agentic-ai)); 78 of the Fortune 500 ([Collibra](https://www3.collibra.com/company/newsroom/press-releases/snowflake-and-collibra-expand-partnership-to-bring-governed-business-context-and-semantics)).
- **Store or query:** metadata only; bidirectional sync with Snowflake Horizon ([Collibra](https://www3.collibra.com/company/newsroom/press-releases/snowflake-and-collibra-expand-partnership-to-bring-governed-business-context-and-semantics)).
- **Acquisitions:** Deasy Labs (July 2025) ([TechTarget](https://www.techtarget.com/data-technologies/news/366627998/Collibras-acquisition-of-Deasy-targets-unstructured-data)); trail ML (5 October 2026) ([Unite.AI](https://unite.ai/collibra-buys-trail-ml-adding-agent-powered-ai-governance-automation)); Raito (June 2025, seen in search results only).

#### Alation
- **What it does:** AIOS (14 July 2026) bundles Agent Studio, Agentic Compliance, Agentic Data Governance, Conversational Analytics and AI Governance on top of the catalog ([Alation](https://www.alation.com/news-and-press/alation-launches-aios-intelligence-operating-system/)).
- **Interfaces:** Python Agent SDK with an MCP server, including a remote server at `https://<your_instance>/ai/mcp` that lists tools dynamically per user permissions ([PyPI](https://pypi.org/project/alation-ai-agent-mcp/)).
- **Customers named:** none in the AIOS release.

#### Informatica (Salesforce)
Covered under Salesforce above. Key point for CPG: it is simultaneously a catalog (CLAIRE, Metadata Explorer), an MDM hub and a data-quality engine, each now exposed as an MCP server ([Salesforce](https://www.salesforce.com/news/press-releases/2026/05/20/informatica-announces-headless-data-management-aws/)).

#### IBM (watsonx.data intelligence, formerly IBM Knowledge Catalog)
- **What it does:** Agentic Data Intelligence (self-managed availability 17 June 2026) gives agents governed access to "business definitions", lineage, ownership, policies and quality signals via an MCP server (open-source repo `IBM/data-intelligence-mcp-server`) and Agent Skills for data product creation, cataloguing and lineage analysis ([IBM](https://www.ibm.com/new/announcements/agentic-data-intelligence-is-now-available-in-ibm-watsonx-data-intelligence-software)). No customers named. Not in Ossie.

#### Select Star (Snowflake) and Secoda (Atlassian)
- Select Star's connectors to PostgreSQL, MySQL, Tableau, Power BI, dbt and Airflow extend Snowflake Horizon Catalog beyond Snowflake ([Techzine](https://www.techzine.eu/news/analytics/136690/snowflake-acquires-select-star-for-broader-data-context/)).
- Secoda adds structured-data context to Atlassian's Teamwork Graph for Rovo agents ([TechTarget](https://www.techtarget.com/searchITOperations/news/366636012/Atlassians-Secoda-acquisition-adds-data-catalog-for-Rovo-AI)).

### 6D. Ontology and knowledge-graph platforms

#### Palantir (Foundry Ontology, AIP)
- **Category:** ontology-first operational platform.
- **What it does:** the Ontology maps data to business objects, links and actions; AIP runs agents over it. On the Q1 2026 call Shyam Sankar called the ontology "the body to the AI brains", with "Full provenance, so every ontology mutation traces back to the agent and reasoning chain that produced it" ([Motley Fool transcript](https://fool.com/earnings/call-transcripts/2026/05/04/palantir-pltr-q1-2026-earnings-transcript)).
- **Interfaces:** Ontology SDK; **Ontology MCP** lets external agents "read objects, execute predefined actions, and query data", with writes only through defined actions; Palantir warns that enabling it with LLMs hosted outside AIP "makes data in your Palantir environment available to an external MCP client" ([Palantir docs](https://palantir.com/docs/foundry/ontology-mcp/overview/)).
- **Store or query:** integrates data into Foundry (with virtual tables also possible, not re-verified here).
- **Scale:** Q1 2026 revenue $1.633bn (+85%), US commercial $595m (+133%), 1,007 customers ([Motley Fool transcript](https://fool.com/earnings/call-transcripts/2026/05/04/palantir-pltr-q1-2026-earnings-transcript)).
- **Customers named:** GE Aerospace, AIG, Thomas Cavanagh Construction ([Motley Fool transcript](https://fool.com/earnings/call-transcripts/2026/05/04/palantir-pltr-q1-2026-earnings-transcript)); **Tyson, General Mills, Wendy's** (food; no use cases given) ([AgNavigator](https://www.agnavigator.com/Article/2025/11/04/palantir-uses-ai-to-help-agrifood-businesses-releases-q3-results)).
- **Moves:** Not in Ossie. Google's Knowledge Catalog harvests Palantir metadata (preview) ([Google Cloud](https://cloud.google.com/blog/products/data-analytics/introducing-the-google-cloud-knowledge-catalog)).

#### Neo4j
- **What it does:** property-graph database; Context Engine (20 October 2026, **private preview**) adds a predefined **six-layer Business Ontology**, Context Build and Runtime (builds the ontology from platforms such as Databricks and Snowflake), Context Studio (governance, agent and MCP set-up) and graph-native memory ([Neo4j](https://neo4j.com/press-releases/neo4j-context-engine/); [TechTarget](https://www.techtarget.com/data-technologies/news/366652383/Neo4j-joins-the-context-cavalcade-with-suite-for-informing-AI-agents)). Neo4j's Sudhir Hasbe says customers struggled with terms such as "account" and "supplier" meaning different things in different systems ([TechTarget](https://www.techtarget.com/data-technologies/news/366652383/Neo4j-joins-the-context-cavalcade-with-suite-for-informing-AI-agents)), which is exactly the CPG translation problem.
- **Store or query:** stores the graph (data copied into Neo4j).
- **Scale:** $200m+ revenue in 2024; 84 of the Fortune 100 ([Intelligent CIO](https://www.intelligentcio.com/north-america/2025/10/03/neo4j-invests-us-100m-in-genai-launches-new-agentic-ai-offerings/)); MCP server fully supported from Q4 2025 (same source).

#### Stardog
- **What it does:** RDF knowledge graph with "Virtual Graphs": "Data Federation means your data remains in place"; or materialise up to "1 trillion triples"; Voicebox LLM agent writes queries from plain language ([Stardog](https://www.stardog.com/product/)).
- **Interfaces:** SPARQL, GraphQL, SQL, Python, REST, Java, Spark ([Stardog](https://www.stardog.com/product/)); MCP not mentioned on that page.
- **Customers named:** NASA, Boehringer Ingelheim, **Bosch**, Verkor, NIH, Morgan Stanley, RTX, Carnegie Mellon ([Stardog](https://www.stardog.com/product/)).

#### Graphwise (Ontotext GraphDB + Semantic Web Company PoolParty, merged October 2024)
- **What it does:** taxonomy/ontology management (Graph Modeling), GraphDB, GraphRAG, knowledge-graph pipelines; named a representative vendor in Gartner's AI context platforms overview ([Graphwise](https://graphwise.ai/?p=254087)). Merger date is older (2024; not re-verified here).

#### TopQuadrant (TopBraid EDG)
- Ontology-based governance (SHACL/RDF). No 2025-26 acquisition found; TopBraid EDG 8.3/8.4 releases in 2025 added AI-agent automation and a Neo4j integration (seen in search results; vendor pages not opened, **unverified**).

#### RelationalAI
- OSI co-lead ([OpenSourceForU](https://www.opensourceforu.com/2025/09/snowflake-salesforce-dbt-labs-blackrock-introduce-open-semantic-interchange/)); runs as a Snowflake Native App so knowledge graphs are built over Snowflake tables without moving data (from RelationalAI's architecture materials, not opened here). Blue Yonder built its supply chain knowledge graph with Snowflake and RelationalAI (ICON 2025 release seen in search; the Blue Yonder page returned 404, so **unverified**).

#### Glean (enterprise search graph)
- **What it does:** "permissions-aware knowledge graph" over SaaS applications; MCP as both server and host, coordinating Canva, Box and Agentforce "without ingesting them into the knowledge graph" ([Futurum](https://futurumgroup.com/insights/glean-doubles-arr-to-200m-can-its-knowledge-graph-beat-copilot/)).
- **Store or query:** indexes content (copies into its index), plus live MCP calls.
- **Scale:** $200m ARR (April 2026), $7.2bn valuation after a $150m Series F (June 2025) ([Futurum](https://futurumgroup.com/insights/glean-doubles-arr-to-200m-can-its-knowledge-graph-beat-copilot/)). Later reports of ~$300m ARR were seen only on aggregator sites (**unverified**).
- **Analyst view:** success "depends on whether its knowledge graph depth can hold off an improving and natively integrated Microsoft 365 Copilot" ([Futurum](https://futurumgroup.com/insights/glean-doubles-arr-to-200m-can-its-knowledge-graph-beat-copilot/)).

#### Celonis (Process Intelligence Graph, Context Model)
- **What it does:** process mining "digital twin"; at Celonis:Next 2026 launched a **Context Model** on the Process Intelligence Graph (process data, business knowledge, decision intelligence), extended its MCP Agent Toolkit for Copilot Studio and Bedrock agents, and claims zero-copy transformations "up to 10 times faster" (vendor claim) ([Celonis](https://www.celonis.com/news/article/finally-enterprise-ai-gets-the-context-it-needs-to-succeed-celonis-next-2026)). Relevant to CPG order-to-cash and procure-to-pay; no CPG names in the release. In Ossie ecosystem ([Ossie ecosystem](https://ossie.apache.org/ecosystem/)).

### 6E. Master data management

| Vendor | 2026 agent features | Store or query | Notes | Sources |
|---|---|---|---|---|
| **Reltio (SAP)** | AgentFlow agents; MCP support; "golden record" entity resolution | Stores golden records | $185m ARR, 200+ large enterprise customers; Gartner MDM Leader, furthest on vision | [SAP](https://news.sap.com/2026/03/sap-to-acquire-reltio), [BARC](https://barc.com/barc-perspective-sap-acquires-reltio/), [Reltio](https://www.reltio.com/resources/blog/2026-gartner-magic-quadrant-mdm), [ITdaily](https://itdaily.com/news/business/sap-reltio-afronding/) |
| **Informatica MDM (Salesforce)** | MDM MCP server; MDM agents | Stores golden records | Part of Salesforce since Nov 2025 | [Salesforce](https://www.salesforce.com/news/press-releases/2026/05/20/informatica-announces-headless-data-management-aws/) |
| **Stibo Systems** | MCP server (29 Jun 2026) built on STEP's "semantic data graph modelling" | Stores product/master data | Leader in 2026 Gartner MDM and PIM MQs; product-data heavy, relevant to CPG product attributes | [Stibo](https://www.stibosystems.com/press-releases/stibo-systems-launches-mcp-server-to-connect-enterprise-master-data-to-ai-agents-at-scale) |
| **Profisee** | MCP server, two-way, with write-back where authorised; Fabric-native MDM GA (19 Mar 2026) | Stores golden records in Fabric/lakehouse | Gartner MDM Leader | [Profisee](https://profisee.com/press-release/profisee-brings-end-to-end-master-data-management-fully-into-microsoft-fabric-at-fabcon-2026-adds-fabric-open-mirroring-support-and-copilot-connectivity-via-profisee-mcp-server/) |
| **SAP MDG** | BARC says Reltio may "complement or even replace" it | Stores in S/4 or hub | Strategic attention shifting to Reltio | [BARC](https://barc.com/barc-perspective-sap-acquires-reltio/) |

Semarchy also claims a 2026 MDM MQ Leader position (search results only, not opened).

### 6F. Virtualisation and federation

#### Denodo
- Logical data management (virtualisation) with its own semantic layer; joined OSI on 24 March 2026 to "enable interoperability between our semantic layer" and others ([Denodo](https://denodo.com/en/press-release/2026-03-24/denodo-joins-snowflake-and-industry-leaders-advance-data-and-ai-interoperability-through-open)). Its AI SDK includes an MCP server and DeepQuery research capability was announced in July 2025 (Denodo pages seen in search, not opened; **unverified**).
- **Store or query:** query in place with caching.

#### Starburst (Trino)
- Federated query engine; April 2026 AI Data Assistant (AIDA) and a May 2026 "Enterprise Intelligence Platform" with an "enterprise context layer built on AI-Ready Data Products" (reported by Futurum and Business Wire; Business Wire refused automated access and the Futurum page was not opened, so **unverified**). Listed in the Ossie ecosystem as "Starburst Data" ([Ossie ecosystem](https://ossie.apache.org/ecosystem/)).

#### Dremio (SAP since July 2026)
- Iceberg-native lakehouse and federation engine with an "AI Semantic Layer" and hosted MCP server; Ossie contributor ([Apache Ossie](https://ossie.apache.org/updates/ossie-enters-apache-incubator/)). SAP completed the acquisition on 6 July 2026 ([SAP](https://news.sap.com/2026/07/sap-completes-dremio-acquisition/)). Futurum: Dremio lets third-party data "stay in its original cloud storage while Dremio makes it appear native to SAP" ([Futurum](https://futurumgroup.com/insights/can-sap-finally-kill-the-etl-monster-the-dremio-and-prior-labs-acquisition-explained/)).

### 6G. CPG- and retail-specific platforms

These matter because each one brings a **pre-built semantic model of the CPG world** (products, stores, retailers, measures like velocity, ACV, share) that has to be mapped to the company's own.

| Vendor | Semantic/context model | Agent access 2025-26 | Store or query | Sources |
|---|---|---|---|---|
| **Crisp** | "cleanses, models, and interprets retail data from 40+ retailers and distributors" | AI Agent Studio (2025), flagship Crisp AI Agent | Stores and harmonises; distributes "regardless of source or destination" | [AlleyWatch](https://alleywatch.com/2025/12/crisp-vertical-ai-platform-cpg-retail-data-infrastructure-supply-chain-automation-analytics-are-traasdahl/) |
| **Circana** (Liquid Data, Liquid AI) | Answers grounded in "governed Circana data, business rules, and analytical logic"; item coding across every product | **MCP** to Copilot, Claude, Gemini, ChatGPT; **A2A** to enterprise agents | Stores syndicated data | [Circana](https://www.circana.com/post/ai-access-vs-ai-intelligence-a-cto-guide) |
| **NIQ** (Discover, Ask Arthur, Optiq) | Licensed NIQ intelligence | Optiq "accessible within NIQ tools and frontier LLMs" | Stores syndicated data | [NIQ](https://nielseniq.com/global/en/news-center/2026/niq-launches-ask-arthur-chat-to-expand-access-to-consumer-insights-through-ai/) |
| **SPINS** | **Product Knowledge Graph** of "structured, context-rich product intelligence" | Agentic Discovery (Sept 2026) measures how products appear in AI shopping recommendations | Stores | [Shelby Report](https://theshelbyreport.com/2026/09/23/spins-launches-agentic-discovery-for-ai-powered-commerce/) |
| **Walmart Scintilla** (formerly Luminate) | Walmart first-party data | Assistant "Marty" to become "conversational AI grounded in Walmart's first-party data"; 2,000+ suppliers at Inspire 2026; no MCP mentioned | Retailer-hosted | [Shelby Report](https://theshelbyreport.com/2026/09/24/walmart-evolves-scintilla-into-commerce-intelligence-platform/) |
| **o9 Solutions** | Patented **Enterprise Knowledge Graph (EKG)** connecting "islands of data and tribal knowledge"; used in 30+ industries | Specialised AI agents GA June 2025 (the "3Ws" questions) | Stores in o9 platform | [o9](https://o9solutions.com/news/o9-is-raising-the-bar-for-enterprise-planning-and-execution) |
| **Blue Yonder** | Rebuilt on Snowflake with "a common data model and a supply chain knowledge graph"; $2.5bn Panasonic-backed R&D | Expanded agents across planning, transport, warehouse, retail (Mar 2026); OSI launch partner | On Snowflake | [diginomica](https://diginomica.com/blue-yonder-expands-its-agentic-ai-footprint-warehouse-floors-microsoft-teams), [OpenSourceForU](https://www.opensourceforu.com/2025/09/snowflake-salesforce-dbt-labs-blackrock-introduce-open-semantic-interchange/) |
| **RELEX** | "shared data foundation shaped by more than 700 customers" | RELEX Open: external agents connect via **MCP**, two-way | Stores in RELEX | [RELEX](https://www.relexsolutions.com/news/relex-launches-relex-open-giving-customers-three-ways-to-accelerate-ai-adoption/) |
| **Kinaxis** | Maestro "Supply Chain Data Fabric"; Maestro Agent Studio (Feb 2026) | An MCP server reportedly built by Genpact on Bedrock AgentCore (ARC Advisory, page not opened; **unverified**) | Stores | not verified |

---

## 7. What vendors say customers use these layers for (brief question 1, vendor evidence)

Evidence from named customers in opened vendor material, by function. Thin for CPG; see section 1, point 12.

- **AI agents / text-to-SQL / natural-language BI (the dominant 2026 use case):** PayPal and YouTube on Looker conversational analytics ([Google Cloud](https://cloud.google.com/blog/products/business-intelligence/looker-updates-for-agentic-bi-at-next26)); Bloomberg Media's Data Access AI Agent ([Google Cloud](https://cloud.google.com/blog/products/data-analytics/introducing-the-google-cloud-knowledge-catalog)); Elastic finance "talk-to-your-data" ([Atlan](https://atlan.com/know/context-layer-stopped-being-theoretical-activate-2026/)); Brex embedded financial reporting agent ([Cube](https://cube.dev/blog/announcing-embedded-agentic-analytics)).
- **Self-service BI at retail scale:** Home Depot on AtScale/BigQuery in Excel, 20TB cube ([AtScale](https://www.atscale.com/?p=27063)); iFood and Zalando on Databricks metric views ([Databricks](https://www.databricks.com/blog/redefining-semantics-data-layer-future-bi-and-ai)).
- **Finance:** SAP's Autonomous Close Assistant aims to "compress the financial close process from weeks to days" ([SAP](https://news.sap.com/2026/05/sap-sapphire-sap-unveils-autonomous-enterprise/)).
- **Supply chain and planning:** o9 EKG agents (excess inventory, risk) ([o9](https://o9solutions.com/news/o9-is-raising-the-bar-for-enterprise-planning-and-execution)); Blue Yonder knowledge graph agents for manufacturing planning and transport ([diginomica](https://diginomica.com/blue-yonder-expands-its-agentic-ai-footprint-warehouse-floors-microsoft-teams)); GE Aerospace with Palantir AIP across its production system and supply chain ([Motley Fool transcript](https://fool.com/earnings/call-transcripts/2026/05/04/palantir-pltr-q1-2026-earnings-transcript)).
- **Manufacturing / OT:** Snowflake partnership with AVEVA for access "without replication" ([Snowflake IR](https://investors.snowflake.com/news/news-details/2026/Snowflake-Pioneers-New-Open-Framework-for-Interoperable-Enterprise-Data-and-AI/default.aspx)); Microsoft's own Fabric IQ example chain is "Order > Shipment > Temperature Sensor > Cold Chain Breach" ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/overview)); Bosch and Schneider Electric are Stardog/ThoughtSpot customers ([Stardog](https://www.stardog.com/product/), [ThoughtSpot](https://www.thoughtspot.com/press-releases/thoughtspot-introduces-spotter-semantics-to-bring-trust-and-context-to-enterprise-ai)).
- **Marketing / commerce / retail media:** Walmart Scintilla Insights Activation connects to Walmart Connect for media campaigns ([Shelby Report](https://theshelbyreport.com/2026/09/24/walmart-evolves-scintilla-into-commerce-intelligence-platform/)); SPINS on visibility in AI shopping agents ([Shelby Report](https://theshelbyreport.com/2026/09/23/spins-launches-agentic-discovery-for-ai-powered-commerce/)); Stibo's retail personal-shopper agent example on Microsoft ([Stibo](https://www.stibosystems.com/press-releases/stibo-systems-launches-mcp-server-to-connect-enterprise-master-data-to-ai-agents-at-scale)).
- **Customer 360 / CRM:** Salesforce Data 360 as the agent context service ([Info-Tech](https://www.softwarereviews.com/vendor-technology-notes/dreamforce-2026-data-360-tableau-informatica)).
- **Data operations:** PayPal and Zespri on ServiceNow Workflow Data Fabric ([ServiceNow](https://newsroom.servicenow.com/press-releases/details/2026/ServiceNow-launches-the-real-time-data-foundation-that-puts-autonomous-AI-to-work-across-the-enterprise/default.aspx)).
- **HR:** none found with a named customer in opened sources (SAP lists HR among Joule domains ([SAP](https://news.sap.com/2026/05/sap-sapphire-sap-unveils-autonomous-enterprise/))).

---

## 8. How vendors say the layers get built (brief question 2, vendor evidence)

**Modelling approaches vendors push:**
- **Metrics-first:** dbt/MetricFlow, Cube, AtScale, Snowflake semantic views, Databricks metric views, LookML, Ossie. Start with the KPIs that already exist in BI tools and make them reusable.
- **Ontology-first:** Palantir, Fabric IQ ontology, SAP Knowledge Graph, Neo4j Business Ontology, Timbr, Stardog, Graphwise. Start with entities (customer, product, plant, shipment) and relationships, then attach metrics. Neo4j ships a **predefined six-layer ontology** ([Neo4j](https://neo4j.com/press-releases/neo4j-context-engine/)).
- **Catalog-first:** Atlan, Collibra, Alation, Google Knowledge Catalog, AWS Context, IBM. Start by harvesting metadata, lineage and glossary from everything, then generate semantics.
- **Convergence:** each camp is adding the others. Microsoft generates ontologies **from** Power BI semantic models ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/overview)); Collibra generates semantic layers **from** its glossary and compiles them **into** Snowflake and Databricks formats ([Collibra](https://www.collibra.com/products/innovations)); Ossie added an Ontology working group ([Apache Ossie](https://ossie.apache.org/updates/ossie-enters-apache-incubator/)).

**LLM bootstrapping (now universal in vendor pitches; every result is a vendor claim):**
- Learning from query history and BI assets: Snowflake Semantic View Autopilot and Cortex Sense ([Constellation](https://constellationr.com/insights/news/snowflake-summit-2026-context-custom-model-training-iceberg-v3)); Databricks Genie Ontology uses column popularity from query reads and Genie Code drafts glossary pages ([Databricks](https://databricks.com/blog/whats-new-unity-catalog-data-ai-summit-2026)); AWS Context ranks sources by usage ([AWS](https://aws.amazon.com/blogs/machine-learning/context-intelligence-for-your-data-and-ai-agents-at-scale/)).
- Importing logic from existing BI: Databricks metric import from Power BI and Tableau (beta) ([Databricks](https://databricks.com/blog/whats-new-unity-catalog-data-ai-summit-2026)); GoodData "BI Modernization" ([GoodData](https://www.gooddata.ai/press-releases/gooddata-kicks-off-2026-with-mcp-server-launch-and-major-enterprise-wins/)); Fabric ontology from DAX measures ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/overview)).
- Generating models from source schemas: AtScale One-Click Modeling ([AtScale](https://www.atscale.com/?p=27063)); Timbr LLM-assisted ERD translation ([Timbr](https://www.timbr.ai/platform)); Cube AI Data Engineer ([SiliconANGLE](https://siliconangle.com/2025/06/02/semantic-data-layer-startup-cube-automates-analytics-ai-agents)); Datus Agent "builds Apache Ossie YAML from your existing SQL, dashboards, ETL pipelines" ([Ossie ecosystem](https://ossie.apache.org/ecosystem/)).
- Generating documentation at volume: Atlan Context Agents, one million descriptions in two weeks ([Atlan](https://atlan.com/know/context-layer-stopped-being-theoretical-activate-2026/)).
- **Human review stays in the loop in every design:** Fabric's "proposal-first model" ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/overview)), Databricks curation via suggestions and comments ([Databricks](https://databricks.com/blog/whats-new-unity-catalog-data-ai-summit-2026)), Upsolve sending agent changes back "as a pull request for the data team to review" ([Ossie ecosystem](https://ossie.apache.org/ecosystem/)).

**Who owns it:** Forrester's advice is that business meaning must be defined "jointly with domain experts, not leave it to data and technology teams" ([Forrester](https://www.forrester.com/blogs/microsoft-fabcon-2026-enterprise-ai-needs-a-governed-context-layer-not-just-data/)); BARC says MDM is "more about the process, than the technology" ([BARC](https://barc.com/barc-perspective-sap-acquires-reltio/)).

---

## 9. Store or connect: the vendor-side answer (brief question 5)

**What vendors now say, almost in unison:** keep one governed copy in open table formats, share it zero-copy, and federate the rest. **What they actually do** varies:

| Pattern | Who | Trade-off |
|---|---|---|
| **Centralise, then share zero-copy** | SAP BDC (data products, Delta Sharing to Databricks, bidirectional to Snowflake, Athena) ([SAP](https://news.sap.com/2025/02/sap-databricks-open-bold-new-era-data-ai/), [SAP](https://news.sap.com/2025/11/sap-snowflake-data-enterprise-ai-business-data-fabric/)); Snowflake and Databricks lakehouses; Microsoft OneLake mirroring | Fast and governed, but the semantic model is anchored in one platform; switching cost rises (BARC's warning on SAP ([BARC](https://barc.com/barc-perspective-sap-acquires-reltio/))) |
| **Reference in place** | OneLake shortcuts ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/overview)); Snowflake Horizon Context over external lakes ([Snowflake IR](https://investors.snowflake.com/news/news-details/2026/Snowflake-Pioneers-New-Open-Framework-for-Interoperable-Enterprise-Data-and-AI/default.aspx)); ServiceNow Live Connect ([ServiceNow](https://newsroom.servicenow.com/press-releases/details/2026/ServiceNow-launches-the-real-time-data-foundation-that-puts-autonomous-AI-to-work-across-the-enterprise/default.aspx)); Celonis zero-copy ([Celonis](https://www.celonis.com/news/article/finally-enterprise-ai-gets-the-context-it-needs-to-succeed-celonis-next-2026)) | Avoids pipelines; performance and cost depend on the source; governance has to be propagated |
| **Federate/virtualise** | Denodo, Starburst, Dremio (SAP), Timbr, Stardog virtual graphs | Most flexible; query latency and source load are the classic problems; usually adds caching |
| **Definitions only** | dbt/MetricFlow, Honeydew, Ossie, catalogs | No data movement at all, but depends on a warehouse already holding the data |
| **Live tool calls via MCP** | Circana, NIQ, RELEX, Informatica, Profisee, Stibo, Palantir Ontology MCP | The agent fetches context from each system at run time; no copy, but no cross-source joins unless something else does them |

**(my assessment)** For a $10-60bn CPG company the realistic answer is all five at once: SAP data via BDC data products or zero-copy into the chosen lakehouse; syndicated data (Circana/NIQ) and retailer data (Crisp, Scintilla) either landed or reached via MCP; MES/historian data via partnerships like Snowflake-AVEVA; master data from an MDM hub; and one semantic layer (ideally exportable as Ossie) sitting over the lakehouse. The vendor fight is over **which platform hosts the definitions**, not where the bytes sit.

---

## 10. What I could not find

- **Vendor-published CPG case studies** for semantic or context layers with timelines and results. Only Unilever (ThoughtSpot boilerplate), Tyson/General Mills (Palantir, no detail) and Home Depot (retail, AtScale) appeared in opened sources.
- **A Gartner, Forrester or IDC evaluation dedicated to semantic layers.** Only GigaOm runs one (2025). Forrester's June 2026 semantic-layer report could not be opened.
- **List prices.** Only one pricing detail surfaced: Collibra MCP is "free to use" but some tools consume billable Collibra Units (search result citing Collibra documentation; not opened). Cost is covered by another slice.
- **Confirmed GA status** for Microsoft's Fabric IQ ontology (Microsoft Learn still says preview), Snowflake Horizon Context, Databricks Genie Ontology and AWS Context.
- **The exact closing date of SAP/Reltio** (completed by 12 May 2026 per ITdaily) and of ServiceNow/data.world.
- **Primary pages** on snowflake.com, businesswire.com, gartner.com and the Microsoft Fabric blog refused automated access; facts from those were taken from documentation, investor-relations or named secondary sources.
- **SAP BDC customer counts** (none disclosed in opened sources).

---

## 11. Vendor comparison table

Legend: **Store** = copies data into its own store; **Query** = leaves data in place (federation, pushdown, zero-copy); **Meta** = stores metadata/definitions only; **Hybrid** = both.

| # | Vendor | Category | Store/Query | Main interfaces | 2025-26 agent features | Notable named customers | 2025-26 market move |
|---|---|---|---|---|---|---|---|
| 1 | Snowflake | Platform semantic + context | Store + zero-copy | SQL, REST (Cortex Analyst), MCP (GA Nov 2025) | Semantic views; Cortex Agents; Horizon Context; Autopilot | Affirm, Indeed, NTT DOCOMO, AstraZeneca (SAP) | Founded OSI; bought Select Star; led AtScale round |
| 2 | Databricks | Platform semantic + context | Store + Delta Sharing | SQL, APIs, MCP | Metric views GA Apr 2026; UC Semantics; Genie Ontology | iFood, Zalando | Joined Ossie; open-sourcing metric views into Spark |
| 3 | Microsoft | Platform semantic + ontology | Hybrid (mirroring + shortcuts) | DAX/XMLA, SQL, GraphQL, MCP | Fabric IQ (GA Jun 2026); ontology (preview); Authoring MCP | none named for Fabric IQ | In Ossie ecosystem |
| 4 | Google | Platform semantic + catalog | Store (BigQuery) + metadata harvest | LookML/SQL, APIs, MCP (managed preview) | Knowledge Catalog; conversational analytics GA | YouTube, Bloomberg Media | Dataplex renamed; not in Ossie |
| 5 | AWS | Catalog/context graph | Meta | APIs, MCP | AWS Context ("coming soon") | none named | Not in Ossie |
| 6 | SAP | Platform semantic + KG + MDM + federation | Hybrid | SQL/OData, Joule, A2A | Knowledge Graph; Joule agents; Reltio MCP | AstraZeneca, RWE | Bought Reltio, Dremio; €1bn Prior Labs; not in Ossie |
| 7 | Salesforce (Data 360, Tableau) | Platform semantic + context | Hybrid (zero-copy) | MCP (~200 APIs), APIs | Agent Context Engine; Tableau Semantics | (none in opened sources) | OSI co-lead; closed Informatica |
| 8 | Informatica | Catalog + MDM + DQ | Hybrid | MCP servers, APIs | Headless IDMC; CLAIRE agents | (none in opened sources) | Now Salesforce |
| 9 | ServiceNow | Catalog/context | Query (Live Connect) | MCP Registry, SQL API | Context Engine; Data Catalog | PayPal, Zespri | Bought data.world; in Ossie |
| 10 | dbt Labs / Fivetran | Universal semantic | Meta | SQL; MCP (reported) | Agents Schema; dbt Wizard | 100,000+ teams | Merged 1 Jun 2026; MetricFlow Apache 2.0 |
| 11 | Cube | Universal semantic | Query + cache | SQL, JSON, GraphQL, MCP | Agentic analytics; embedded chat API | Brex | GigaOm Leader; OSI launch partner |
| 12 | AtScale | Universal semantic | Query + aggregates | SQL, DAX, MDX, MCP | One-Click Modeling; Databricks MCP marketplace | Home Depot, Fidelity, TELUS | Snowflake-led round Dec 2025; joined OSI |
| 13 | Kyvos | Universal semantic | Pre-aggregate | MDX/DAX/SQL, MCP | MCP server; Claude integration (reported) | unnamed | In Ossie |
| 14 | GoodData.AI | Headless BI semantic | Query | APIs, MCP (read/write) | MCP server; Agent Builder | unnamed | Rebranded Apr 2026; Ossie contributor |
| 15 | Honeydew | Universal semantic | Meta | SQL, YAML/git | Ossie converter | (none in opened sources) | Snowflake Ventures (unverified) |
| 16 | Timbr | Ontology semantic layer | Query (virtual) | SQL, JDBC/ODBC, REST, LangChain | LLM-assisted modelling | (none named) | n/a |
| 17 | ThoughtSpot | BI + semantic | Query | SQL, MCP | Spotter Semantics | Sephora, Unilever (boilerplate) | OSI founding member |
| 18 | Strategy Mosaic | Universal semantic | Query | SQL, BI | Ossie import/export | (none in opened sources) | Joined OSI |
| 19 | Atlan | Catalog/context | Meta | MCP, API, SQL (Iceberg) | Context Lakehouse; Context Agents | Elastic, Engine, Fox, Workday | Gartner D&A governance Leader 2026 |
| 20 | Collibra | Catalog/governance/context | Meta | MCP, APIs | Context compiler; AI Command Center | 700+ customers; 100+ on MCP | Bought Deasy, trail ML |
| 21 | Alation | Catalog/context | Meta | MCP (remote), SDK | AIOS | (none named) | In Ossie |
| 22 | IBM watsonx.data intelligence | Catalog/context | Meta | MCP, Agent Skills | Agentic Data Intelligence | (none named) | Not in Ossie |
| 23 | Palantir | Ontology platform | Store | OSDK, Ontology MCP | AIP agents; ontology actions | GE Aerospace, AIG, Tyson, General Mills | Not in Ossie |
| 24 | Neo4j | Knowledge graph | Store | Cypher, MCP | Context Engine (private preview) | 84 of Fortune 100 | $100m product commitment |
| 25 | Stardog | Knowledge graph | Hybrid (virtual graphs) | SPARQL, GraphQL, SQL | Voicebox | NASA, Bosch, Boehringer | n/a |
| 26 | Graphwise | KG/ontology | Store | SPARQL, GraphRAG | Graph AI suite | (none in opened sources) | Gartner AI context representative vendor |
| 27 | RelationalAI | KG on Snowflake | Query (native app) | Python, SQL | KG coprocessor | Blue Yonder (unverified) | OSI co-lead |
| 28 | Glean | Enterprise search graph | Store (index) + MCP | MCP server/host, APIs | Agents | (none in opened sources) | $200m ARR; $7.2bn valuation |
| 29 | Celonis | Process graph | Hybrid (zero-copy) | MCP | Context Model | Conrad, TD Synnex | In Ossie |
| 30 | Reltio (SAP) | MDM | Store | APIs, MCP | AgentFlow | 200+ large enterprises | Acquired by SAP |
| 31 | Stibo Systems | MDM/PIM | Store | MCP | AgentWorkx (reported), MCP | (Bonduelle in blog, unverified) | MDM + PIM MQ Leader |
| 32 | Profisee | MDM | Store (Fabric) | MCP (two-way) | Fabric-native MDM | (none named) | MDM MQ Leader |
| 33 | Denodo | Virtualisation | Query | SQL, MCP (reported) | AI SDK | (none in opened sources) | Joined OSI Mar 2026 |
| 34 | Starburst | Federation | Query | SQL, MCP (reported) | AIDA (reported) | (none in opened sources) | In Ossie |
| 35 | Dremio (SAP) | Lakehouse/federation | Query | SQL, MCP | AI Semantic Layer | (none in opened sources) | Acquired by SAP Jul 2026 |
| 36 | Crisp | CPG retail data | Store | APIs, agents | AI Agent Studio | 40+ retailers connected | $26m B1 (total $127m) |
| 37 | Circana | CPG syndicated data | Store | MCP, A2A | Liquid AI | unnamed Australian retailer | Agent access Oct 2026 |
| 38 | NIQ | CPG syndicated data | Store | LLM bridge | Optiq, Ask Arthur | (none named) | n/a |
| 39 | SPINS | CPG product data | Store | n/a | Agentic Discovery | (none named) | Product Knowledge Graph |
| 40 | Walmart Scintilla | Retailer data | Retailer-hosted | APIs | Marty assistant | 2,000+ suppliers attending | Commerce intelligence push |
| 41 | o9 | Planning + EKG | Store | Platform APIs | Planning agents | 30+ industries | n/a |
| 42 | Blue Yonder | Planning + KG | Store (Snowflake) | Platform APIs | Supply chain agents | (none named) | OSI launch partner |
| 43 | RELEX | Retail/supply planning | Store | MCP | RELEX Open | 700+ customers | n/a |

---

## 12. Full source list (every URL cited)

Standards and OSI / Apache Ossie
- https://ossie.apache.org/
- https://ossie.apache.org/ecosystem/
- https://ossie.apache.org/updates/ossie-enters-apache-incubator/
- https://www.opensourceforu.com/2025/09/snowflake-salesforce-dbt-labs-blackrock-introduce-open-semantic-interchange/
- https://denodo.com/en/press-release/2026-03-24/denodo-joins-snowflake-and-industry-leaders-advance-data-and-ai-interoperability-through-open

Snowflake
- https://docs.snowflake.com/en/release-notes/2025/june-summit
- https://docs.snowflake.com/release-notes/2025/other/2025-11-04-cortex-agents-mcp
- https://docs.snowflake.com/release-notes/2026/other/2026-04-13-cortex-agents-agentic-analyst
- https://docs.snowflake.com/release-notes/2026/other/2026-08-28-cortex-analyst-transition-cortex-agents
- https://investors.snowflake.com/news/news-details/2026/Snowflake-Pioneers-New-Open-Framework-for-Interoperable-Enterprise-Data-and-AI/default.aspx
- https://constellationr.com/insights/news/snowflake-summit-2026-context-custom-model-training-iceberg-v3
- https://www.runtime.news/snowflake-thinks-context-is-king/
- https://www.techzine.eu/news/analytics/136690/snowflake-acquires-select-star-for-broader-data-context/
- https://www.everestgrp.com/blogs/snowflakes-select-star-move-when-data-finally-meets-its-context/

Databricks
- https://www.databricks.com/blog/redefining-semantics-data-layer-future-bi-and-ai
- https://databricks.com/blog/whats-new-unity-catalog-data-ai-summit-2026
- https://www.forrester.com/blogs/databricks-unleashes-the-genie-the-power-of-the-four-cs/

Microsoft
- https://learn.microsoft.com/en-us/fabric/iq/overview
- https://learn.microsoft.com/en-us/power-bi/developer/mcp/mcp-servers-overview
- https://www.forrester.com/blogs/microsoft-fabcon-2026-enterprise-ai-needs-a-governed-context-layer-not-just-data/
- https://letsdatascience.com/news/microsoft-expands-fabric-iq-as-a-context-layer-for-ai-agents-e9a90bd8

Google
- https://cloud.google.com/blog/products/business-intelligence/looker-updates-for-agentic-bi-at-next26
- https://cloud.google.com/blog/products/data-analytics/introducing-the-google-cloud-knowledge-catalog
- https://docs.cloud.google.com/dataplex/docs/overview

AWS
- https://aws.amazon.com/blogs/machine-learning/context-intelligence-for-your-data-and-ai-agents-at-scale/

SAP (including Reltio and Dremio)
- https://news.sap.com/2025/02/sap-databricks-open-bold-new-era-data-ai/
- https://news.sap.com/2025/11/sap-snowflake-data-enterprise-ai-business-data-fabric/
- https://news.sap.com/2026/03/sap-to-acquire-reltio
- https://news.sap.com/2026/05/sap-sapphire-sap-unveils-autonomous-enterprise/
- https://news.sap.com/2026/07/sap-completes-dremio-acquisition/
- https://itdaily.com/news/business/sap-reltio-afronding/
- https://barc.com/barc-perspective-sap-acquires-reltio/
- https://futurumgroup.com/insights/can-sap-finally-kill-the-etl-monster-the-dremio-and-prior-labs-acquisition-explained/
- https://www.reltio.com/resources/blog/2026-gartner-magic-quadrant-mdm

Salesforce and Informatica
- https://www.salesforce.com/news/press-releases/2025/11/18/salesforce-completes-acquisition-of-informatica/
- https://www.salesforce.com/news/press-releases/2026/05/20/informatica-announces-headless-data-management-aws/
- https://www.softwarereviews.com/vendor-technology-notes/dreamforce-2026-data-360-tableau-informatica

ServiceNow
- https://www.techzine.eu/news/data-management/131208/servicenow-acquires-data-world-to-make-data-ai-ready
- https://newsroom.servicenow.com/press-releases/details/2026/ServiceNow-launches-the-real-time-data-foundation-that-puts-autonomous-AI-to-work-across-the-enterprise/default.aspx

Independent semantic layers
- https://www.getdbt.com/blog/fivetran-dbt-labs-complete-merger-to-create-the-data-infrastructure-for-trusted-ai-agents
- https://www.getdbt.com/blog/dbt-labs-affirms-commitment-to-open-semantic-interchange-by-open-sourcing-metricflow
- https://siliconangle.com/2025/06/02/semantic-data-layer-startup-cube-automates-analytics-ai-agents
- https://cube.dev/blog/announcing-embedded-agentic-analytics
- https://cube.dev/blog/cube-cloud-named-leader-and-outperformer-in-2025-gigaom-radar-for-semantic
- https://www.01net.it/atscale-announces-equity-financing-led-by-snowflake/
- https://www.atscale.com/?p=27063
- https://www.kyvosinsights.com/kyvos-mcp-server/
- https://www.gooddata.ai/press-releases/gooddata-kicks-off-2026-with-mcp-server-launch-and-major-enterprise-wins/
- https://www.timbr.ai/platform
- https://www.thoughtspot.com/press-releases/thoughtspot-introduces-spotter-semantics-to-bring-trust-and-context-to-enterprise-ai

Catalogs and governance
- https://atlan.com/know/context-layer-stopped-being-theoretical-activate-2026/
- https://atlan.com/about.md
- https://atlan.com/atlan-named-leader-in-gartner-da-governance-magic-quadrant/
- https://www.collibra.com/products/innovations
- https://www.collibra.com/company/newsroom/press-releases/collibra-launches-ai-command-center-to-scale-agentic-ai
- https://www3.collibra.com/company/newsroom/press-releases/snowflake-and-collibra-expand-partnership-to-bring-governed-business-context-and-semantics
- https://unite.ai/collibra-buys-trail-ml-adding-agent-powered-ai-governance-automation
- https://www.techtarget.com/data-technologies/news/366627998/Collibras-acquisition-of-Deasy-targets-unstructured-data
- https://www.alation.com/news-and-press/alation-launches-aios-intelligence-operating-system/
- https://pypi.org/project/alation-ai-agent-mcp/
- https://www.ibm.com/new/announcements/agentic-data-intelligence-is-now-available-in-ibm-watsonx-data-intelligence-software
- https://www.techtarget.com/searchITOperations/news/366636012/Atlassians-Secoda-acquisition-adds-data-catalog-for-Rovo-AI

Knowledge graphs, ontologies, search and process graphs
- https://fool.com/earnings/call-transcripts/2026/05/04/palantir-pltr-q1-2026-earnings-transcript
- https://palantir.com/docs/foundry/ontology-mcp/overview/
- https://www.agnavigator.com/Article/2025/11/04/palantir-uses-ai-to-help-agrifood-businesses-releases-q3-results
- https://neo4j.com/press-releases/neo4j-context-engine/
- https://www.techtarget.com/data-technologies/news/366652383/Neo4j-joins-the-context-cavalcade-with-suite-for-informing-AI-agents
- https://www.intelligentcio.com/north-america/2025/10/03/neo4j-invests-us-100m-in-genai-launches-new-agentic-ai-offerings/
- https://www.stardog.com/product/
- https://graphwise.ai/?p=254087
- https://futurumgroup.com/insights/glean-doubles-arr-to-200m-can-its-knowledge-graph-beat-copilot/
- https://www.celonis.com/news/article/finally-enterprise-ai-gets-the-context-it-needs-to-succeed-celonis-next-2026

MDM
- https://www.stibosystems.com/press-releases/stibo-systems-launches-mcp-server-to-connect-enterprise-master-data-to-ai-agents-at-scale
- https://profisee.com/press-release/profisee-brings-end-to-end-master-data-management-fully-into-microsoft-fabric-at-fabcon-2026-adds-fabric-open-mirroring-support-and-copilot-connectivity-via-profisee-mcp-server/

CPG and retail platforms
- https://alleywatch.com/2025/12/crisp-vertical-ai-platform-cpg-retail-data-infrastructure-supply-chain-automation-analytics-are-traasdahl/
- https://www.circana.com/post/ai-access-vs-ai-intelligence-a-cto-guide
- https://nielseniq.com/global/en/news-center/2026/niq-launches-ask-arthur-chat-to-expand-access-to-consumer-insights-through-ai/
- https://theshelbyreport.com/2026/09/23/spins-launches-agentic-discovery-for-ai-powered-commerce/
- https://theshelbyreport.com/2026/09/24/walmart-evolves-scintilla-into-commerce-intelligence-platform/
- https://o9solutions.com/news/o9-is-raising-the-bar-for-enterprise-planning-and-execution
- https://diginomica.com/blue-yonder-expands-its-agentic-ai-footprint-warehouse-floors-microsoft-teams
- https://www.relexsolutions.com/news/relex-launches-relex-open-giving-customers-three-ways-to-accelerate-ai-adoption/

Commentary and sceptics
- https://joereis.substack.com/p/gartner-declares-2026-the-year-of
