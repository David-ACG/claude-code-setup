# Context layers and semantic layers: the enterprise market at 16 November 2026

**Research scope:** very large consumer goods and retail enterprises; evidence available on or before 16 November 2026. Prices are in their original currencies, before tax unless stated. Publication dates are identified where available; undated documentation and commercial pages were accessed on 16 November 2026. Older evidence is explicitly marked. Links beside statements identify the evidence; the numbered bibliography collects every cited URL.

**Reading the evidence:** “company account” means the organisation describes its own deployment; “vendor case study” means supplier-published evidence, even when a customer is quoted. Neither is an independent causal evaluation. “Estimate”, “recommended design” and “consultant synthesis” identify this report's analysis, not an observed customer implementation. Missing implementation details are left missing. In particular, an AI partnership, lakehouse migration or cataloguing programme does not establish that a company has deployed a universal semantic layer.

The central finding is that this is several overlapping markets. Executable metric definitions, governed metadata, enterprise search, operational ontologies and agent memory solve different problems. Buying one does not automatically supply the others. This distinction follows from comparing the documented scope of [dbt's Semantic Layer](https://docs.getdbt.com/docs/use-dbt-semantic-layer/setup-sl), [Atlan's context layer](https://docs.atlan.com/agents/faq/context-layer), [Palantir's Ontology](https://www.palantir.com/docs/foundry/architecture-center/ontology-system) and [Ramp's agent memory](https://support.ramp.com/how-glass-works/).

## 1. What are companies using these layers for?

### Advertising, marketing, retail media and customer understanding

**Retail media requires product, place and time to mean the same thing in advertising and sales data.** In Crisp's undated poppi case, agency Tinuiti connects retailer sales with media activity by SKU, geography and day. The supplier reports an 80% higher in-store purchase rate in TikTok-targeted geographies and 15% for Amazon video. These are vendor case-study results: the page does not disclose enough experimental detail to establish incrementality independently. The concrete context work is linking advertised products and locations to observed retail sales, rather than letting an LLM infer that relationship. [Crisp/poppi case](https://www.gocrisp.com/case-studies/poppi).

**Retailer customer context is also commercially valuable without becoming the manufacturer's universal model.** An older Tesco Media and Insight Platform/L'Oréal campaign used Clubcard-derived audiences and propensity modelling with Meta targeting. The 2023 case study describes a 2022 campaign with a £115,000 budget and 45,000 new shoppers. The budget is advertising spend, not a semantic-layer implementation cost. This is evidence of retailer audience and product context supporting activation; it does not establish an enterprise-wide L'Oréal semantic engine. [Campaign PDF, 2023](https://www.dunnhumby.com/wp-content/uploads/2023/10/Tesco-Media-Insight-Platform-Loreal_CaseStudy.pdf).

**Media mix modelling needs definitions, but is not itself a semantic layer.** Google's older Hershey example describes separating YouTube ad formats within marketing mix analysis. Its relevance is the necessity of an agreed media taxonomy and measurement grain. It is not evidence that Hershey bought one of today's context-layer products. A contemporary client should distinguish three deliverables: harmonised inputs, a governed metric layer and a causal/statistical model. The last cannot be replaced by a product ontology or an agent's narrative. [Google/Hershey, older 2019 article](https://business.google.com/ca-en/think/marketing-strategies/marketing-mix-modeling-tutorial/).

**Product knowledge supports recommendations.** Inter IKEA's 2023 conference example combines product information, an ontology and interior-design rules in a knowledge graph. Designers contribute reusable rules for recommendations such as furnishing small spaces; the graph connects those rules with product characteristics. This is a more specific example of business knowledge than generic retrieval over product descriptions. L'Oréal's April 2026 GraphSummit customer presentation identifies Neo4j behind Beauty Genius recommendations, although the public page provides little implementation or outcome detail. [IKEA/metaphacts, older 2023](https://blog.metaphacts.com/building-explainable-trustworthy-recommendation-systems-ikea-at-kgc2023); [L'Oréal/Neo4j, 2026](https://neo4j.com/customer-stories/loreal-graphsummit-2026/).

**Customer 360 is a related integration problem.** Salesforce positions Data Cloud connectivity and zero-copy access as a way to use external enterprise data in applications and Agentforce. Reltio supplies matching, merging and survivorship for entities. These are relevant capabilities for connecting consumer, household, loyalty and business-customer records, but those entity types should not be casually collapsed. This report did not find a sufficiently detailed, current named CPG case proving a single customer definition spanning every brand, retailer and market. [Salesforce connectivity](https://www.salesforce.com/data/connectivity/zero-copy/); [Reltio entity resolution](https://www.reltio.com/products/entity-resolution/).

### Sales, commercial execution and revenue growth management

**Diageo is a direct semantic-layer example.** Strategy's April 2026 account describes common business definitions serving performance management and an embedded natural-language assistant, Autobot. Users can interrogate gross profit and underperforming brands while working from governed business measures. Its performance-management application connects sales volume, mix, price and cost. The business objective is faster, consistent commercial decisions across markets, rather than another isolated chatbot. [Strategy/Diageo, 20 April 2026](https://software.strategy.com/blog/how-diageo-scales-enterprise-ai-with-a-governed-semantic-layer).

**Nestlé USA demonstrates the mapping behind commercial analytics.** Crisp's case describes a UNFI business covering roughly 1,500 SKUs and $300 million in sales. A distributor vendor number encompassed several Nestlé businesses, so the implementation had to map external items into internal hierarchies and exclude irrelevant products. Completing store-location data then enabled distribution and stock analysis. This is a concrete example of master-data reconciliation producing usable commercial context. [Nestlé USA/Crisp, adoption began in summer 2023; page undated](https://www.gocrisp.com/case-studies/nestle-usa).

**Retail execution adds an action loop.** Walmart's February 2026 Scintilla In-Store announcement connects supplier representatives with store-level tasks and insights. It illustrates the progression from shared retailer data to guided execution. It does not by itself show that supplier ERP revenue definitions, retailer sales measures and media attribution have become one model. [Walmart, 23 February 2026](https://corporate.walmart.com/news/2026/02/23/introducing-scintilla-in-store-the-future-of-third-party-retail-execution-at-walmart).

### Supply chain and demand planning

**Unilever reports connected operational decisions at substantial scale.** Its 2026 supply-chain account describes a Forecast Engine generating weekly forecasts across a 104-week horizon for five million product/customer combinations in 40 markets. It also attributes availability above 98% in a Mexico/Walmart example to better connectivity between demand, purchasing and material sourcing. These are company-reported operating outcomes, not controlled measurements of a named semantic-layer product. [Unilever, 2026](https://www.unilever.com/news/news-search/2026/building-resilience-driving-growth-inside-unilevers-aipowered-supply-chain/).

**Planning platforms can already contain the domain model a client needs.** Kinaxis explicitly describes a semantic graph relating products, suppliers, orders, sites, constraints and dependencies. o9 describes its Enterprise Knowledge Graph as the foundation of its Digital Brain for demand, supply, integrated business planning and revenue growth management. These platforms deserve comparison with horizontal context tools when the target decision is planning, rather than being dismissed as downstream applications. Vendor descriptions establish capability and positioning, not a particular customer's realised benefit. [Kinaxis semantic graph, 2026](https://www.kinaxis.com/en/semantic-graph); [o9, 11 August 2025](https://o9solutions.com/news/o9-named-a-leader-in-the-nucleus-research-scp-technology-value-matrix-2025).

### Manufacturing, operational technology and quality

**P&G's problem is contextualising heterogeneous factory information.** Microsoft's August 2025 case describes Azure IoT Operations connecting equipment and operational data with corporate analytics. It reports up to a 90% reduction in the time needed to deploy a new model version. That is a deployment-process result, not a 90% improvement in manufacturing quality or AI-answer accuracy. The case is useful because it exposes the practical work of standardising connections across dissimilar equipment and sites. [Microsoft/P&G, 21 August 2025](https://www.microsoft.com/en/customers/story/25077-procter-and-gamble-iot-operations).

**Mars provides an older operational-context example with a timeline.** Accenture's 2022 announcement traces digital-twin trials to late 2020, including an Illinois packaging pilot intended to reduce overfilling. The approach subsequently expanded in the US before a global scaling agreement. It connects production events with a representation of manufacturing operations; the source does not establish a group-wide financial or commercial ontology. [Accenture/Mars, older 2022](https://newsroom.accenture.com/news/2022/accenture-collaborates-with-mars-to-develop-factory-of-the-future-using-ai-cloud-edge-and-digital-twins).

### Finance

**Governed measures support repeatable executive reporting.** dbt's own older 2024 case describes finance, revenue operations and analytics teams using certified measures for ARR and business-overview reporting. It claims 20 hours per month saved on OKR slides and 12 hours on ad hoc ARR requests. These are supplier self-reported productivity figures, but the mechanism is clear: agree the calculation once and reuse it across requests. Diageo supplies the more directly relevant consumer-goods example above. [dbt internal case, older 2024](https://www.getdbt.com/blog/streamlining-kpi-dashboards-dbt-semantic-layer).

### HR and employee services

**Employee context often means permission-aware documents and procedures, rather than a metric engine.** Glean's McCarthy Holdings case covers knowledge spread across SharePoint, Teams and Procore, with HR applications including benefits and training information. The company estimates approximately two hours saved per employee per week; this is not independently measured evidence. Publishing rights for agents are deliberately limited. HR headcount and attrition metrics would still require approved definitions and access rules alongside this retrieval capability. [Glean/McCarthy, undated current case](https://www.glean.com/resources/customer-stories/mccarthy-holdings-inc).

### AI agents, copilots and text-to-SQL

**Operational context can be much wider than business metrics.** Uber's September 2026 engineering account describes an AI ContextGraph with 24 million nodes and 80 million edges connecting services, teams, incidents, code changes, design material and data assets. A same-prompt example compares a correct answer in 38 seconds with an incorrect unguided response taking over 20 minutes. It is an illustrative comparison, not a representative benchmark. [Uber, September 2026](https://www.uber.com/gb/en/blog/efficient-software-factory/).

**Memory is a different asset again.** Ramp's Glass documentation distinguishes personal, space and company memory, with daily routines refreshing selected context. Company memory is constrained to 8,000 characters; pinning a file does not mean placing its full content in every prompt. Shopify's June 2026 account describes skills maintained as files within its internal engineering environment. These examples support selective retrieval and maintained organisational instructions, not indiscriminate accumulation of all conversations. [Ramp documentation](https://support.ramp.com/how-glass-works/); [Shopify, June 2026](https://shopify.engineering/under-the-river).

## 2. How are companies creating them, and what is actually in the market?

### 2.1 The useful market map

The following categorisation is consultant synthesis of the linked product documentation. Products overlap categories; the table identifies what a buyer should verify, rather than declaring interchangeable competitors. A catalog's glossary is not necessarily an executable metric engine, and an ontology product need not use the same graph language or data model as another ontology product.

| Product or family | Documented centre of gravity and modelling approach | Buying implication |
|---|---|---|
| **dbt Semantic Layer / MetricFlow** | Code-defined entities, dimensions and metrics compiled into queries; platform interfaces include JDBC and GraphQL. Its MCP server exposes models, metrics, lineage and freshness. [Setup](https://docs.getdbt.com/docs/use-dbt-semantic-layer/setup-sl), [MCP](https://docs.getdbt.com/docs/dbt-ai/about-mcp). | Strong candidate when analytics engineering already owns dbt models. Confirm service-account and end-user authorisation design; an API token is not automatic identity propagation. |
| **Cube / Cube Core** | Cube Core remains the open-source modelling, access-control and caching foundation; the commercial product has expanded into agentic BI. Its May 2026 explanation favours the PostgreSQL-compatible Semantic SQL API over the older JSON REST interface for new work. [Product distinction](https://cube.dev/blog/cube-core-and-cube). | Compare the managed application and self-operated engine separately. Owning an open-source engine still leaves operating and consumer-integration work. |
| **AtScale** | A shared semantic serving layer for existing analytical tools; its published BI compatibility matrix distinguishes SQL and MDX consumers. The matrix inspected is from 2024, so current connector behaviour needs verification. [Older support matrix](https://www.atscale.com/wp-content/uploads/2024/08/AtScale-BI-Tool-Support-Matrix.pdf). | Particularly relevant to spreadsheet and heterogeneous BI estates. Do not infer current price, latency or every connector's feature parity from this older matrix. |
| **Looker / LookML with BigQuery or other databases** | LookML defines dimensions, aggregations, calculations and joins in projects that generate SQL against a database. [LookML documentation](https://docs.cloud.google.com/looker/docs/what-is-lookml). | A concrete governed modelling system. Buying BigQuery alone does not establish that LookML definitions exist or are used by every other consumer. |
| **Power BI / Microsoft Fabric semantic models** | Analytical models can use Import, DirectQuery and Direct Lake. Direct Lake references OneLake Delta data and loads required columns into the analytical engine. [Direct Lake documentation](https://learn.microsoft.com/en-us/fabric/fundamentals/direct-lake-overview). | Existing model investment may be reusable. Distinguish the business model from its storage mode and from Fabric IQ's newer ontology capabilities. |
| **Snowflake semantic views / Cortex Analyst** | Native semantic objects describe entities, dimensions, facts, metrics and relationships, with instructions and verified queries for natural-language use. Legacy YAML files remain a separate compatibility path. [Semantic-view specification](https://docs.snowflake.com/en/user-guide/views-semantic/semantic-view-yaml-spec). | A warehouse-native option. Evaluate covered questions and permissions; a semantic view does not automatically reconcile source-system master data. |
| **Databricks metric views / Unity Catalog** | SQL/YAML metric definitions, reusable measures and joins, with support for more complex metric behaviour. Unity Catalog's semantic offering also includes domains, documentation and certification; Genie uses business context. [Metric views](https://docs.databricks.com/aws/en/uc-semantics/metric-views/), [semantic framework](https://docs.databricks.com/aws/en/uc-semantics/). | Compare executable metric reuse with catalog organisation and inferred AI context separately. A Unity Catalog customer is not automatically a metric-view customer. |
| **SAP Datasphere / Business Data Cloud** | SAP's October 2026 reference architecture combines governed data products, semantic models, business metadata and knowledge-graph/ontology capabilities. [SAP architecture](https://architecture.learning.sap.com/docs/ai-native-north-star-architecture/foundation-layer). | Attractive for retaining SAP business meaning. An architectural direction is not proof that every described capability is generally available or installed at a named customer. |
| **Kyvos** | Its 2026.9 documentation includes an MCP server that connects AI clients to governed analytical spaces and natural-language-to-SQL functionality. [MCP documentation](https://docs.support.kyvosinsights.com/wiki/spaces/KD20269/pages/1496881576/Kyvos%2BModel%2BContext%2BProtocol%2BMCP%2BServer). | Include in analytical performance evaluations; ask for a workload-specific demonstration, refresh requirements and the precise commercial bundle. |
| **GoodData** | Governed analytical definitions and logical models are exposed through MCP tools for discovery, querying and selected metadata operations. [MCP documentation](https://www.gooddata.ai/docs/cloud/ai/mcp-server/). | Relevant to embedded or multi-workspace analytics as well as internal AI. Separate read-only analytical tools from metadata-changing tools. |
| **Honeydew** | A Snowflake-oriented semantic layer extending semantic views and supporting BI consumers, including multi-fact and variable-grain use cases. [Technical positioning](https://honeydew.ai/blog/honeydew-and-snowflake-semantic-views/). | Test difficult joins and grain handling on the client's data rather than assuming a simple semantic-view demonstration covers them. |

### 2.2 Context, metadata, ontology and graph products

| Product or family | What it contributes | What still needs separate attention |
|---|---|---|
| **Palantir Ontology** | Objects, properties and links combined with logic, actions and security to model operational business behaviour. [Architecture](https://www.palantir.com/docs/foundry/architecture-center/ontology-system). | Definitions, source mappings and authority to execute business actions must still be designed. Its ontology is not automatically interchangeable with an RDF/OWL model. |
| **Atlan** | Context built from metadata, lineage, ownership, policies and business definitions, supplied through APIs/MCP and integrated workflows. [Context-layer FAQ](https://docs.atlan.com/agents/faq/context-layer). | A context source can describe a measure without being the engine that executes its calculation. Establish the authoritative executable definition. |
| **Collibra** | Governed metadata, business terms, quality, lineage and context delivery. Its October 2026 positioning centres on protecting and compiling enterprise context. [Product account](https://www.collibra.com/blog/context-is-the-new-ip-collibra-is-where-enterprises-come-to-protect-it). | Connector coverage, stewardship adoption and actual enforcement at query time matter more than a knowledge-graph label alone. |
| **Alation** | Agent Studio's hosted MCP interface exposes catalog search, context, SQL-related capabilities, lineage and quality; tool exposure can be scoped. [MCP documentation](https://alation.github.io/agent-studio-docs/integrations/mcp/using-the-mcp-server/). | Confirm which identity governs discovery versus execution, and which catalog content has been reviewed. |
| **data.world / ServiceNow** | ServiceNow reported that its acquisition closed in July 2025, adding cataloguing and governance capabilities to its agent ambitions. [Q2 2025 results](https://newsroom.servicenow.com/press-releases/details/2025/ServiceNow-Reports-Second-Quarter-2025-Financial-Results/default.aspx). | Do not assume the acquisition proves every catalog capability has been integrated into every ServiceNow agent product. Ask about current packaging and migration. |
| **Glean** | A knowledge graph connecting content, people and activity, with source permissions incorporated into enterprise search. [Security documentation](https://docs.glean.com/security/knowledge-graph). | Useful for documents and organisational context; finance-grade measure computation remains a different requirement. Crawling/indexing creates derived copies of information. |
| **Microsoft Fabric IQ** | A workload bringing together semantic models, graphs, data agents and operational context. The ontology capability is explicitly marked **preview** in the inspected documentation. [Overview](https://learn.microsoft.com/fabric/iq/overview). | Separate released analytical models from preview ontology functionality in procurement and production planning. |
| **Microsoft Work IQ** | Context and memory across Microsoft 365 and connected business systems, with MCP, REST and agent interoperability. API usage has its own billing model. [Overview](https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/work-iq/). | Work context and relationships complement, rather than automatically replace, certified finance and operational metrics. Do not assume all API usage is included in a Copilot licence. |
| **Salesforce Data Cloud / Agentforce** | Data connectivity and activation into business applications and agents, including federation with external platforms. [Zero-copy documentation](https://www.salesforce.com/data/connectivity/zero-copy/). | Customer identity, mapping and activation are distinct from a universal enterprise metric layer. Evaluate consumption costs and data rights. |
| **Snowflake Horizon Context** | **Preview announced 12 October 2026**: metadata integration from 18 external systems, including BI and data platforms, with descriptions, tags, contacts and column lineage. [Release note](https://docs.snowflake.com/en/release-notes/2026/other/2026-10-12-horizon-context-preview). | This is cross-system metadata context, not a claim that all operational rows have been ingested or all cross-platform semantics reconciled. |
| **Neo4j** | Graph storage, graph analytics, GraphRAG and agent-oriented knowledge-layer capabilities; its current offering also advertises a virtual graph. [Knowledge-layer overview](https://neo4j.com/product/knowledge-layer/). | Do not assume every deployment must copy all business facts into a graph. Verify the selected product's materialisation, freshness and access model. |
| **Stardog** | Virtual graphs translate SPARQL into source queries using declarative mappings; importing/materialising data is also possible. [Virtual-graph documentation](https://docs.stardog.com/virtual-graphs/). | The mapping and ontology need domain ownership. Query federation does not eliminate source performance constraints. |
| **TopBraid EDG** | Governed ontologies, classes, properties and constraints using standards including SHACL, with taxonomy integration. [Ontology guide](https://docs.topquadrant.com/9.0/user_guide/guidance_specific_to_asset_collection_type/working_with_ontologies/working_with_ontologies.html). | Particularly relevant to formal modelling and governance. It should not be evaluated as though it were simply a replacement BI calculation engine. |
| **Timbr** | SQL-facing ontologies and virtual knowledge graphs that translate queries against underlying sources. [Introduction](https://timbr.ai/doc/docs/getting-started/intro-timbr/). | A route to ontology-based access without wholesale primary-data relocation. Test source pushdown and the actual SQL workload. |

### 2.3 Adjacent capabilities that are often necessary

**MDM provides identity and authoritative attributes.** SAP MDG describes matching, merging, golden records and governed workflows. Reltio combines entity resolution with survivorship and contextual views. Stibo's retail proposition covers product, supplier, customer and location information. Profisee announced Fabric-native MDM, open mirroring and MCP connectivity in March 2026. These are relevant to harmonising “which product/customer/site?”; they are not substitutes for agreeing “how is net revenue calculated?”. [SAP MDG](https://www.sap.com/products/data-cloud/master-data-governance.html); [Reltio](https://www.reltio.com/products/entity-resolution/); [Stibo retail](https://www.stibosystems.com/industries/retail); [Profisee, 19 March 2026](https://profisee.com/press-release/profisee-brings-end-to-end-master-data-management-fully-into-microsoft-fabric-at-fabcon-2026-adds-fabric-open-mirroring-support-and-copilot-connectivity-via-profisee-mcp-server/).

**Federation changes where queries execute.** Denodo combines logical access, query optimisation and selective caching. Starburst's March 2026 account combines Trino/Iceberg access, federation, data products and AI-oriented interfaces. Dremio documents preparation, business and application layers implemented through its semantic organisation. These products can reduce unnecessary copying, but the buyer still needs approved identities, measures and source mappings. [Denodo](https://www.denodo.com/en/denodo-platform/denodo-platform); [Starburst, March 2026](https://www.starburst.io/blog/starburst-galaxy-ai-on-iceberg-foundations/); [Dremio semantic framework](https://docs.dremio.com/current/help-support/well-architected-framework/semantic/).

**Retail and planning platforms supply valuable pre-modelled context.** Crisp describes normalised retailer/distributor data and a retail semantic foundation. SPINS' older 2024 material describes more than 325 product attributes spanning ingredients, nutrition, dietary characteristics and claims. Circana's 2025 Liquid Supply Chain announcement describes harmonised store/item/day information. NIQ's 2026 reporting positions Connect as a large-scale data integration engine. These assets can save domain-modelling work, but their licensed taxonomies and market coverage need explicit mapping into the manufacturer's own product and customer structures. [Crisp platform](https://www.gocrisp.com/our-platform); [SPINS, older 2024 PDF](https://www.spins.com/wp-content/uploads/2024/07/SPINS-IFT-2024-Values-Oriented-PRESENTATION.pdf); [Circana, April 2025](https://www.circana.com/post/circana-s-liquid-supply-chain-solution-creates-an-inventory-command-center-for-cross-retailer-insigh); [NIQ, 2026 results](https://investors.nielseniq.com/news/news-details/2026/NIQ-Announces-Strong-Fourth-Quarter-and-Full-Year-2025-Results/default.aspx).

Blue Yonder describes a supply-chain knowledge graph and semantic layer using RelationalAI and Snowflake. RELEX describes a unified merchandising platform spanning assortment, space, inventory, pricing and promotions. Alongside o9 and Kinaxis, these are domain-oriented candidates: the procurement question is whether the existing planning model can serve the target decision and expose governed context, not whether every planning platform should be replaced by a horizontal graph. [Blue Yonder](https://blueyonder.com/why-blue-yonder/ai-and-machine-learning); [RELEX](https://www.relexsolutions.com/unified-merchandising-platform/).

**Ownership has changed during this market's formation.** Salesforce completed its Informatica acquisition in November 2025. SAP's Q3 2026 statement records Reltio closing on 7 May 2026 and Dremio on 6 July 2026. Buying decisions should therefore distinguish a currently documented standalone capability from a promised combined roadmap. An acquisition is evidence of ownership, not completed technical convergence. [Salesforce completion announcement](https://investor.salesforce.com/news/news-details/2025/Salesforce-Completes-Acquisition-of-Informatica/); [SAP Q3 2026 statement](https://www.sap.com/docs/download/investors/2026/sap-2026-q3-statement.pdf).

### 2.4 Modelling approach and team structure

The approaches below are recommended decision rules derived from the implementations and product scopes above. They are not mutually exclusive and do not imply that a client should purchase all categories.

| Starting approach | Start with | Deliver first | Principal failure to prevent |
|---|---|---|---|
| Metrics-first | A disputed commercial or financial measure and its supported dimensions | Tested definitions, permitted joins, certified query API and reconciled outputs | A glossary that documents disagreement without resolving calculations |
| Ontology-first | Objects and decisions: order, shipment, lot, asset, shortage, intervention | Explicit relationships, states, constraints and permitted actions | An elaborate enterprise model with no working source bindings |
| Catalog-first | Fragmented assets, unknown owners, unreliable discovery | Searchable assets, ownership, lineage, quality status and terms | Treating auto-generated descriptions as approved business truth |
| Knowledge-graph-first | Relationship-heavy questions or recommendations | A narrowly scoped graph and explainable paths to evidence | Importing everything before proving a useful query |
| Application/domain-first | Existing planning, merchandising, CRM or retail intelligence model | Reusable domain data products and interfaces | Creating a second inconsistent copy of the same domain model |

The case evidence favours a product operating model. Unilever's governance case describes Data Product Management roles bridging business, IT and its Data Hub. Ingka's PlatformCon 2025 talk describes a Team-of-Teams arrangement combining architecture, product, data and engineering. Colruyt's Collibra programme moved from a business-unit starting point to a permanent product team. These are organisational patterns, not publicly disclosed staffing ratios. [Unilever/Bridge & Co](https://www.bridgenco.com/insights/case-studies/optimizing-data-governance-at-unilever/); [Ingka, PlatformCon 2025](https://2025.platformcon.com/sessions/delivering-a-greenfield-data-platform-with-togetherness-at-its-heart-through-a-team-of-teams-setup); [Colruyt/Datashift](https://www.datashift.eu/case-studies/how-colruyt-group-built-a-stronger-data-foundation-with-collibra-and-datashift).

**Recommended delivery sequence:** choose one decision; identify the existing trusted report; reconcile sources and entities; agree definitions and exclusions; implement executable mappings; add business descriptions and lineage; expose a small set of APIs/tools; test against held-out questions; release to a named user group; monitor changes and extend the domain. The critical design choice is to make each definition traceable to its code, owner, source grain and test. Snowflake's evaluation tooling demonstrates that semantic models can be tested against verified queries rather than accepted because a demonstration sounds convincing. [Cortex Analyst evaluations](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst-evaluations).

### 2.5 LLM bootstrapping and interoperability

**LLMs can accelerate documentation and model proposals.** Alation's Ciena case reports curating approximately 6,000 assets in two weeks after establishing protocols and preparation, compared with an earlier manual rollout lasting 1.5–2 years across multiple groups. It also describes a small team but does not disclose its exact size. This is vendor evidence of faster metadata work, not proof that an entire enterprise's semantics can be agreed in a fortnight. [Ciena/Alation, current case](https://www.alation.com/customers/ciena-ai-data-catalog/).

Recommended controls are to mark generated definitions as proposals, attach source evidence, require domain-owner approval, and test proposed mappings against actual records and reconciliations. An LLM can suggest that two fields represent a product identifier; it cannot establish from their names alone that both use the same packaging level or historical hierarchy. Entity matching should preserve confidence, evidence and reversibility; Reltio's documentation explicitly includes matching, survivorship and unmerge-related capabilities. [Reltio entity resolution](https://www.reltio.com/products/entity-resolution/).

**OSI has evolved during 2026.** The initiative is now represented by Apache Ossie, an incubating Apache project; its site records the July 2026 transition. It defines an interchange representation for datasets, relationships, dimensions, metrics and AI-related context. This is a route to exchanging model definitions, not a universal execution engine or proof that security, time intelligence, calculation semantics and every vendor extension round-trip without loss. Buyers should require an export/import test using their difficult measures. Apache incubation should not be represented as an unconditional maturity endorsement. [Apache Ossie](https://ossie.apache.org/).

## 3. Expected long-term value, measured results and the sceptical view

### 3.1 What the business is trying to improve

The practical ambition is a reusable decision foundation: the same commercial measure in a board report, sales application and agent answer; product identities that connect demand with supply; and operational context that explains what happened and what action is permitted. Diageo's product-oriented semantic programme, IKEA's recommendation rules and Mars' manufacturing twins exemplify different parts of this ambition. They should not be treated as three deployments of one identical technology. [Diageo](https://software.strategy.com/blog/how-diageo-scales-enterprise-ai-with-a-governed-semantic-layer); [IKEA conference materials, older 2023](https://zenodo.org/records/7908305); [Mars, older 2022](https://newsroom.accenture.com/news/2022/accenture-collaborates-with-mars-to-develop-factory-of-the-future-using-ai-cloud-edge-and-digital-twins).

The long-term business case should therefore contain separate measures for decision quality, delivery speed and operating cost. Recommended examples are reconciled gross-to-net variance; time to answer a recurring sales question; forecast and replenishment outcomes; proportion of questions correctly declined; analyst hours spent resolving definitions; and time to propagate an approved metric change. These are proposed evaluation measures, not claimed customer results.

### 3.2 What the accuracy evidence actually says

**dbt's April 2026 benchmark is informative precisely because it exposes a limitation.** It used 11 insurance questions, 20 runs each and 15 underlying tables. On the original full question set, text-to-SQL scored 64.5% and the semantic approach 72.7%; some questions exceeded supported join coverage. After adding three modelling transformations, the like-for-like results on the improved data were 90.0% versus 98.2% for Sonnet 4.6, and 84.1% versus 100% for GPT-5.3-Codex. This is a vendor benchmark with a small question set. It supports modelling plus governed execution, not the assertion that adding a semantic product to arbitrary raw tables guarantees perfect answers. [dbt, 7 April 2026](https://docs.getdbt.com/blog/semantic-layer-vs-text-to-sql-2026).

**A separate April 2026 preprint reports a smaller, useful improvement.** On 100 ContosoRetail questions using ClickHouse, three models and a compact Markdown semantic document, reported accuracy rose from approximately 45.5–50.5% to 67.7–68.7%. This tests semantic documentation rather than an identical implementation to dbt's executable layer. It is a preprint and a benchmark dataset, not a measured production return for a retailer. The difference between the results is methodological, not evidence that one source has disproved the other. [Rumiantsau and Fokeev, 28 April 2026](https://arxiv.org/abs/2604.25149).

A September 2026 context-engineering preprint separates the contribution of business content from prompt scaffolding and other mechanisms. Its relevance is that “better context” must be decomposed before attributing an improvement to a vendor platform. Domain-specific information, task coverage and precompiled knowledge can dominate the result. Its benchmark findings should not be transferred directly to CPG ERP questions. [Ye, September 2026](https://arxiv.org/abs/2609.22259).

**Recommended client test:** compare raw-schema text-to-SQL, documented-schema retrieval and governed semantic execution using the same model, source snapshot and question set. Include unsupported questions, ambiguous terms, market-specific calculations, permission restrictions and follow-up questions. Record numerical correctness, unsupported-answer rate, refusal quality, latency, total query cost and traceability. Keep evaluation answers out of retrieval. Snowflake explicitly removes selected verified queries from runtime context during its evaluation and notes limitations including single-view runs and no multi-turn evaluation. [Evaluation documentation](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst-evaluations).

### 3.3 Measured or claimed business outcomes

| Organisation / evidence | Reported result | What can reasonably be concluded |
|---|---|---|
| Diageo / Strategy case | 25% faster runtimes and 96% data availability across regions. | Vendor-reported cloud/analytics operating metrics; neither is AI-answer accuracy. [Case](https://software.strategy.com/customer-stories/diageo). |
| PepsiCo / customer-authored Databricks account, older 2024 | 30% reduction in onboarding time; 1,500 active users and more than 30 digital products. | Useful evidence for governed platform reuse; does not isolate the contribution of a semantic engine. [Case](https://www.databricks.com/blog/how-pepsico-established-enterprise-grade-data-intelligence-platform-powered-databricks-unity). |
| Pizza Hut / Snowflake investment account, 2025 | Honeydew-associated claims of 50% faster insight development and 30% lower engineering costs. | Supplier/investor account, with insufficient public detail to independently reproduce attribution. [Account](https://www.snowflake.com/en/blog/investment-honeydew-business-intelligence/). |
| Ritual / Crisp, undated | More than ten hours per week saved; headline avoided pipeline/headcount cost of up to $240,000. | Supplier estimate rather than audited cash savings. A further $500,000 sales opportunity on the page is a projection, not a realised outcome. [Case](https://www.gocrisp.com/case-studies/ritual). |
| Nestlé / Microsoft, 2025 | 80% fewer critical incidents, 40% faster issue resolution and 99.97% availability. | SAP/cloud transformation results; attributing them specifically to a context or semantic layer would be unjustified. [Case](https://www.microsoft.com/en/customers/story/23963-nestle-azure). |

### 3.4 The sceptical interpretation

There is no settled industry boundary around “semantic layer”. MIT CISR's May 2026 research uses a broader enterprise meaning than a narrow BI metric-engine definition. Its evidence includes interviews across 41 organisations and a 2024 survey in which only 21% of respondents reported well-developed curation. Atlan, meanwhile, positions context as a wider AI-facing category. The useful response to this disagreement is to ask what is actually represented, executed, governed and maintained, rather than accepting a category label. [MIT CISR, May 2026](https://cisr.mit.edu/publication/2026_0501_SemanticLayer_LefebvreWixomLegnerVandermeulenBeath); [Atlan explanation](https://docs.atlan.com/agents/faq/context-layer).

Consultant assessment: the strongest evidence establishes technical feasibility and local productivity, while public evidence for enterprise-wide causal revenue gains is thin. Shared definitions can consistently reproduce a wrong accounting rule. A graph can encode stale relationships. Retrieval can return an authoritative-looking but obsolete policy. A technically correct query can still answer a commercially inappropriate question. The controls required are ownership, versioning, source freshness, reconciliation and bounded decision authority; the purchased product alone is not the control.

Three distinctions should remain visible in any investment paper: observed savings versus modelled savings; platform modernisation benefits versus semantic-layer effects; and a successful domain versus enterprise coverage. The Ritual projection, Nestlé migration metrics and dbt coverage-dependent benchmark provide concrete reasons for keeping those distinctions. [Ritual](https://www.gocrisp.com/case-studies/ritual); [Nestlé](https://www.microsoft.com/en/customers/story/23963-nestle-azure); [dbt benchmark](https://docs.getdbt.com/blog/semantic-layer-vs-text-to-sql-2026).

## 4. How long did creation take?

### 4.1 Named implementations: elapsed time is not the same as effort

| Organisation | Publicly supported timeline or phase | Team information | Boundary of the evidence |
|---|---|---|---|
| **Ciena / Alation** | Approximately 6,000 assets curated in two weeks following preparatory protocols; contrasted with an earlier 1.5–2-year manual programme. | Described as a small team; no exact FTE count. | Metadata curation, not complete source integration or agreement of all business definitions. [Case](https://www.alation.com/customers/ciena-ai-data-catalog/). |
| **Ritual / Crisp** | Target data made available through Snowflake sharing in roughly one to two hours after the relevant foundation existed. | No implementation team size disclosed. | A connection/data-delivery step, not a greenfield enterprise programme. [Case](https://www.gocrisp.com/case-studies/ritual). |
| **PepsiCo / Databricks** | The 2024 account describes a four-year platform journey, implying a start around 2020. | Global architecture and engineering involvement; exact programme FTEs undisclosed. | A broad platform programme across digital products, not the time to author one semantic model. [Older case](https://www.databricks.com/blog/how-pepsico-established-enterprise-grade-data-intelligence-platform-powered-databricks-unity). |
| **Mars / Accenture / Microsoft** | Trials began in late 2020; an October 2022 agreement followed US expansion. A new manufacturing platform over two years and further use cases over three years were forward plans at that point. | Multiple organisations; team sizes undisclosed. | Distinguish elapsed pilot history from announced future delivery. [Older 2022 announcement](https://newsroom.accenture.com/news/2022/accenture-collaborates-with-mars-to-develop-factory-of-the-future-using-ai-cloud-edge-and-digital-twins). |
| **Nestlé SAP transformation** | A 2025 core upgrade covered 112 countries and 50,000 employees in Asia, Oceania and Africa; the annual report says the whole group is to follow within two years. | Large affected population, not the implementation team. | An ERP/data foundation programme; the two-year statement is a target, not evidence of completion by November 2026. [Annual report](https://www.nestle.com/investors/annual-report/executing-strategy/accelerating-business-transformation). |
| **Shopify internal engineering context** | World monorepo foundations began in early 2024; River was launched a couple of months before the June 2026 account. | Exact build-team size not given. | The rapid agent rollout benefited from earlier repository, tooling and infrastructure work. [Engineering account](https://shopify.engineering/under-the-river). |
| **Colruyt / Collibra** | Began with a business-unit scope and expanded through a permanent product team. The case places a 2024 award one year after go-live, implying approximately 2023 go-live. | Permanent product team; number not disclosed. | Go-live year is an inference, not a disclosed project start-to-finish duration. [Case](https://www.datashift.eu/case-studies/how-colruyt-group-built-a-stronger-data-foundation-with-collibra-and-datashift). |
| **Nestlé USA / Crisp** | Adoption began in summer 2023; the story documents subsequent product and store mapping. | Exact size not disclosed. | No defensible build duration can be calculated from the page. [Case](https://www.gocrisp.com/case-studies/nestle-usa). |
| **Diageo / Strategy** | The 2026 article rejects the old 15–18-month project-delivery approach in favour of products. | Cross-functional product ownership, without staffing totals. | Those 15–18 months are not a reported semantic-layer implementation duration. [Article](https://software.strategy.com/blog/how-diageo-scales-enterprise-ai-with-a-governed-semantic-layer). |

Exact implementation team sizes are a conspicuous gap in these public sources. The report therefore does not convert user counts, country coverage, consultant participation or elapsed duration into a purported staffing benchmark. For procurement, ask each reference customer for the number of people working on source remediation, mapping and governance as well as the software configuration team; otherwise apparently comparable timelines can exclude most of the work.

### 4.2 A planning envelope, explicitly estimated

The following is a **consultant planning model**, not a market average or a promise from the named vendors. It assumes an existing cloud platform, accessible source data, named business owners and one commercially valuable starting domain. The wide spread in the cases above is the reason to budget by scope and readiness rather than by product name.

| Phase | Assumed elapsed duration | Suggested scope and exit condition |
|---|---|---|
| Discovery and reconciliation | 2–4 weeks | Choose one decision, 20–40 representative questions, source owners, known reconciliation reports and permission requirements. |
| Working pilot | A further 4–8 weeks | Approximately 10–25 measures and 2–4 primary sources; demonstrate correct joins, dates, identities and refusal on unsupported questions. |
| First production domain | Approximately 3–6 months from start | Operated pipelines, approved definitions, access tests, change management, monitoring and a real user group. |
| Reuse across domains/markets | Approximately 6–18 months | Repeatable onboarding; shared entities and local exceptions; operational ownership beyond the initial team. |
| Extensive enterprise coverage | Approximately 18–36 months or longer | A continuing product programme, especially where ERP harmonisation, acquisitions and retailer data differ by country. |

A suggested first-domain team is one product owner, one analytics/semantic modeller, two data engineers, one shared governance/MDM specialist, one application/agent engineer and fractional security/platform support, plus committed finance or commercial stewards. This is an estimated staffing design, not a discovered client headcount. If the client already has reliable domain marts, the team can focus on semantic publication. If product identifiers, permissions or financial reconciliations are unresolved, those dependencies determine the critical path.

## 5. Store everything centrally, or connect to it where it lives?

### 5.1 Five different meanings of “no copy”

The distinction is not binary. There can be central analytical facts, federated operational data, shared tables, replicated metadata, cached aggregates and copied document indexes in the same architecture. Salesforce itself notes that physical replication remains appropriate in some cases; Stardog explicitly supports both virtual access and materialisation. [Salesforce zero-copy discussion](https://www.salesforce.com/data/connectivity/zero-copy/); [Stardog virtual graphs](https://docs.stardog.com/virtual-graphs/).

| Pattern | What moves or is retained | Appropriate use and trade-off |
|---|---|---|
| **Warehouse/lakehouse consolidation** | Business records are ingested or transformed into an analytical store. | Repeated, large cross-source analysis with controlled performance and history; pays for ingestion, storage, refresh and reconciliation. Kraft Heinz describes migration from legacy Hadoop to Snowflake. [Older 2022 case](https://www.snowflake.com/en/blog/kraft-heinz-fosters-collaboration-retail-partners/). |
| **Federated query / virtual graph** | Queries and results cross the boundary; primary records may remain at source. | Useful where movement is undesirable or sources must remain independent; joins, network latency and source capacity still constrain performance. [Denodo](https://www.denodo.com/en/denodo-platform/denodo-platform), [Stardog](https://docs.stardog.com/virtual-graphs/), [Timbr](https://timbr.ai/doc/docs/getting-started/intro-timbr/). |
| **Data sharing / zero-copy access** | A consumer receives access to a provider-managed dataset or a federated interface rather than maintaining a separate ingestion pipeline. | Valuable for retailer and partner distribution; establish where the provider originally created the dataset, how access is revoked and whether consumers materialise results. [Kraft Heinz](https://www.snowflake.com/en/blog/kraft-heinz-fosters-collaboration-retail-partners/), [Salesforce](https://www.salesforce.com/data/connectivity/zero-copy/). |
| **Metadata federation** | Schemas, descriptions, lineage, ownership and policies are collected; not necessarily transaction rows. | Makes a distributed estate discoverable but does not itself execute a reconciled cross-source metric. [Horizon Context preview](https://docs.snowflake.com/en/release-notes/2026/other/2026-10-12-horizon-context-preview). |
| **Document retrieval and agent tools** | Search systems can index document text and permissions; MCP carries tool requests and results. | A connector is not proof of zero storage. Verify indexes, caches, retained conversations and permission refresh. [Glean knowledge graph](https://docs.glean.com/security/knowledge-graph), [dbt MCP](https://docs.getdbt.com/docs/dbt-ai/about-mcp). |

**Direct Lake is a useful warning against simplistic language.** Microsoft describes a mode that uses OneLake table metadata and loads required columns for analysis. It avoids a conventional full import refresh, but it is not a guarantee of zero memory use, zero processing or live federation to arbitrary ERP databases. Likewise, a shared table is not the same thing as a virtual query over a transactional API. [Microsoft Direct Lake](https://learn.microsoft.com/en-us/fabric/fundamentals/direct-lake-overview).

### 5.2 Who is doing what?

Nestlé's Microsoft case explicitly describes moving from six on-premises data centres to RISE with SAP on Azure and using a central Azure data lake. PepsiCo's platform account describes a governed Databricks environment. These are evidence for substantial central analytical/platform foundations, not proof that every source record resides in one physical location. [Nestlé, 2025](https://www.microsoft.com/en/customers/story/23963-nestle-azure); [PepsiCo, older 2024](https://www.databricks.com/blog/how-pepsico-established-enterprise-grade-data-intelligence-platform-powered-databricks-unity).

P&G illustrates an edge/cloud combination: MQTT and Kubernetes/Arc-based operational connectivity near factories, feeding wider Azure analysis. This permits local industrial connectivity and central reuse without asserting that every high-frequency equipment signal must be queried remotely. [Microsoft/P&G, 2025](https://www.microsoft.com/en/customers/story/25077-procter-and-gamble-iot-operations).

Kraft Heinz's retailer collaboration and Ritual's Snowflake delivery illustrate sharing after data has already been prepared somewhere. The consumer may avoid building a feed, but upstream collection, identity mapping and curation have not disappeared. [Kraft Heinz, older 2022](https://www.snowflake.com/en/blog/kraft-heinz-fosters-collaboration-retail-partners/); [Ritual](https://www.gocrisp.com/case-studies/ritual).

### 5.3 Recommended hybrid policy

For a multinational manufacturer, a defensible design is to centralise repeatedly joined analytical facts and historical snapshots, retain selected local operational systems, federate where freshness or organisational boundaries justify it, and cache expensive repeated results under explicit freshness rules. Maintain a common registry of meanings and ownership while permitting domain-specific execution engines. This is a design recommendation based on the available deployment modes, not a claim that all named companies use this precise pattern. [Denodo platform](https://www.denodo.com/en/denodo-platform/denodo-platform); [SAP foundation architecture](https://architecture.learning.sap.com/docs/ai-native-north-star-architecture/foundation-layer).

Procurement should ask six concrete questions: where are primary data, cached results and embeddings stored; which system computes the join; what happens when a source is unavailable; how quickly do permission changes propagate; what costs arise per query or refresh; and can historical answers be reproduced? “Zero-copy” is inadequate as the answer to any of those questions. The distinction is particularly consequential when an agent repeatedly queries an operational source or when a shared retail dataset has contractual restrictions on reuse.

## 6. Do they need a dictionary, glossary, canonical model or ontology?

### 6.1 They need explicit translation, but not necessarily one giant model

The practical answer is **yes to governed translation; not necessarily to a single comprehensive ontology built in advance**. SAP MDG's golden records, LookML's executable joins and calculations, and TopBraid's ontology constraints solve different parts of translation. None alone establishes that the same product, reporting period and measure are understood identically across every application. [SAP MDG](https://www.sap.com/products/data-cloud/master-data-governance.html); [LookML](https://docs.cloud.google.com/looker/docs/what-is-lookml); [TopBraid](https://docs.topquadrant.com/9.0/user_guide/guidance_specific_to_asset_collection_type/working_with_ontologies/working_with_ontologies.html).

The recommended minimum is a connected set of artefacts, each with an owner:

| Artefact | The question it answers | Suggested accountable role |
|---|---|---|
| Technical dictionary | What is this source field, type, key and update cadence? | Source/application owner with data engineering |
| Business glossary | What does the business term mean, including exclusions and local variants? | Relevant domain owner and steward |
| Canonical entity model | Which identifiers and attributes represent the same product, customer, site or supplier? | MDM/domain owner |
| Mapping specification | How is a source value translated into a canonical identity, unit or category? | Data product owner, implemented by engineering |
| Executable metric definition | What formula, grain, time basis, filters and permitted joins produce this measure? | Finance/commercial owner plus semantic modeller |
| Ontology or relationship model | Which entities relate, which states are valid and which actions are permitted? | Operational/domain owner with ontology/application specialists |
| Provenance and version history | Which source, rule and definition produced this answer at that time? | Platform/governance team with domain approval |

This is a proposed ownership model. It deliberately separates approval of meaning from implementation of code. Mondelez's 2026 Ataccama case provides a relevant organisational example: stewardship moved towards business owners, supported by cataloguing, quality and lineage, rather than remaining purely an IT responsibility. [Mondelez/Ataccama, 10 September 2026](https://www.ataccama.com/customer-story/before-mondelez-international-could-trust-ai-it-had-to-trust-its-data).

### 6.2 Worked translation example: a product sold, promoted and manufactured

The following is an **illustrative implementation**, not a disclosed system at a named company. It applies the identity, mapping and metric capabilities documented above to the systems in the brief.

1. **Preserve the incoming identifiers.** Retain the SAP material and sales-organisation keys, Salesforce account/product IDs, retailer item identifiers, barcode/GTIN, media catalogue ID and MES material/batch identifiers. A GTIN identifies a trade item; it should not be treated as a universal identifier for every commercial grouping or every level of packaging. GS1 distinguishes GTINs from barcode carriers and from the EAN/UPC terminology used for symbols and number formats. [GS1 explanation, older 2024](https://support.gs1.org/support/solutions/articles/43000734124-what-is-the-difference-between-a-gs1-gtin-a-barcode-an-ean-and-a-upc-).
2. **Create explicit crosswalks.** Map each source key to a governed product entity with effective dates, packaging level, unit conversion, market and mapping confidence. Keep individual units, multipacks and shipping cases distinguishable. Preserve unmatched records in an exception queue rather than assigning a plausible product silently.
3. **Resolve entities with evidence.** Combine deterministic keys, approved reference data and probabilistic/LLM-assisted suggestions. A steward approves ambiguous merges; survivorship rules choose authoritative attributes; reversibility matters when a merge is wrong. This is a use of the documented MDM pattern, not a recommendation to let an LLM invent identifiers. [Reltio entity resolution](https://www.reltio.com/products/entity-resolution/).
4. **Keep business hierarchies purpose-specific.** The finance brand hierarchy, retailer category tree, manufacturing recipe family and media audience grouping may differ legitimately. Connect them through shared entities and versioned mapping tables. Do not force one hierarchy to express every purpose.
5. **Define measures at their actual grain.** Invoice-line net revenue, store/item/day sell-out, campaign/day spend and batch-level yield are different facts. Specify conversion and aggregation rules before joining. A consumer sale is not automatically manufacturer revenue; a case shipped is not automatically a unit sold.
6. **Expose approved cross-domain questions.** For example, “Did promotion demand exceed available supply for these mapped items?” can combine retail demand, promotion dates and inventory. “Did the campaign cause incremental profit?” requires a causal measurement method and agreed margin treatment in addition to those joins.

Nestlé USA's distributor hierarchy problem shows that this translation is real implementation work, not a theoretical concern. Nestlé's annual report gives another example: recipe/specification harmonisation involving ingredient experts, material/recipe managers and procurement, with recipe specifications reduced by 50% since 2019 and 10% since 2024. These are company-reported simplification measures, not a published AI-mapping accuracy result. [Nestlé USA/Crisp](https://www.gocrisp.com/case-studies/nestle-usa); [Nestlé annual report](https://www.nestle.com/investors/annual-report/executing-strategy/accelerating-business-transformation).

### 6.3 What “one net revenue definition” should mean in practice

Recommended definition fields are: authoritative ledger/source; reporting entity; transaction grain; recognised date; treatment of returns, discounts and trade accruals; tax treatment; currency conversion policy; intercompany exclusions; reporting calendar; restatement/version rules; and responsible finance approver. Local statutory and management views may both be legitimate. The goal is controlled, named variants with reconciliations, not pretending disagreement disappears when a global glossary entry is approved.

For implementation, store the business explanation alongside the executable measure and tests. Define allowed joins and protect against double-counting when connecting invoice lines to promotion allocations or retailer listings. Distinguish additive measures from balances and ratios. Publish a version and deprecation policy so an agent can tell whether it is comparing the same calculation over time. LookML, MetricFlow and Snowflake semantic views provide different mechanisms for executable modelling; the governance design must determine which is authoritative for a particular measure. [LookML](https://docs.cloud.google.com/looker/docs/what-is-lookml); [dbt setup](https://docs.getdbt.com/docs/use-dbt-semantic-layer/setup-sl); [Snowflake specification](https://docs.snowflake.com/en/user-guide/views-semantic/semantic-view-yaml-spec).

### 6.4 Who settles conflicts and maintains the layer?

Recommended accountability is domain-led: finance settles recognised revenue and margin policy; commercial teams own customer/channel and promotion interpretations with finance approval where they affect money; supply chain owns planning units and service measures; manufacturing/quality owns equipment, batch and specification meaning; HR owns employee concepts and access; enterprise governance maintains cross-domain standards and escalation. Engineering implements and tests those decisions.

A small central semantic architecture group should maintain shared modelling conventions, identity contracts and interfaces. Domain product teams should own content and service quality. A change to a measure must trigger dependency checks across dashboards, agents and applications, while a source schema change should trigger mapping validation. Unilever's bridge roles and Mondelez's shift towards business stewardship support this allocation of responsibility, although neither source publishes this exact recommended organisation chart. [Unilever governance case](https://www.bridgenco.com/insights/case-studies/optimizing-data-governance-at-unilever/); [Mondelez case](https://www.ataccama.com/customer-story/before-mondelez-international-could-trust-ai-it-had-to-trust-its-data).

## 7. What does it cost at large-enterprise scale?

### 7.1 What can and cannot be established publicly

Public pricing is sufficient to identify charging mechanisms and some useful anchors. It is not sufficient to establish a reliable “typical Unilever-scale annual contract” for most products. The report found published self-service tariffs, marketplace entry listings and older UK public-sector price schedules. Those are not equivalent to negotiated global enterprise agreements. Vendr pages were searched, but direct access to the relevant pages was blocked; snippet-only median figures have deliberately not been used. No verified public price was found for a directly comparable Palantir, SAP BDC or enterprise-wide CPG context-layer programme.

Revenue is a poor stand-alone sizing variable. For a $10–60 billion manufacturer, the relevant procurement inputs are domains, source systems, countries, identities, data volume, refresh frequency, concurrent consumers, environments and support requirements. Walmart-scale retail adds a materially different volume profile. The budget models below use assumed resources and scope, not a percentage of company revenue.

### 7.2 Published licence and consumption anchors

| Product | Published figure or charging mechanism | Interpretation and exclusions |
|---|---|---|
| **dbt** | Starter **$100/developer/month**; includes 15,000 successful model builds and 5,000 queried metrics monthly. Enterprise tiers are quoted, with different included consumption. [Pricing](https://www.getdbt.com/pricing). | A limited starting plan, not a global enterprise quote. Warehouse processing and overage terms require separate modelling. |
| **Cube** | Starter **$40/developer/month**, Premium **$80**; Premium Explorer **$40**, Viewer **$20**. Dedicated deployment listed at **$0.60/hour** or **$1.20/hour**, with additional API/cache resources charged separately. [Pricing](https://cube.dev/pricing). | Seats plus platform resources; enterprise features and commercial terms are custom. Do not price only the developers. |
| **Looker** | Platform subscription plus user licences; Standard, Enterprise and Embed are quoted. Published packages include ten standard and two developer users, with differing API allowances. [Pricing](https://cloud.google.com/looker/pricing). | No verified universal dollar platform price on the inspected official page. Underlying database costs remain separate. |
| **Power BI / Fabric** | US displayed prices: Pro **$14/user/month**, Premium Per User **$24**, paid annually. Fabric capacity is separately sized/priced; qualifying F64-and-above capacity permits consumption by free users under the documented conditions. [Pricing](https://www.microsoft.com/en-us/microsoft-fabric/features/power-bi/pricing). | Region, existing agreements and capacity change the calculation. Authors/publishers and viewers are not necessarily priced identically. |
| **Honeydew** | Lite **$20/user/month** plus platform from **$500/month**; Standard **$30/user/month** plus platform from **$2,000/month**. Active-object bands apply; larger/enterprise deployments are quoted. [Pricing](https://honeydew.ai/pricing/). | Count consumption users and active fields/metrics, not just model developers. Snowflake compute is not established by these headline prices. |
| **GoodData** | Current commercial page presents workspace-oriented/custom pricing. No defensible current numerical enterprise tariff was established from the opened page. [Pricing](https://www.gooddata.ai/pricing/). | Request workspace, user, AI and usage assumptions in the quotation; do not reuse old internet prices as current list prices. |
| **Alation** | AWS Marketplace lists a 12-month Data Catalog subscription **starting at $60,000**. [Listing](https://aws.amazon.com/marketplace/pp/prodview-ylge6fq43dtg6). | Entry listing with insufficient scope for a global estimate; private offers may differ. |
| **Collibra** | AWS Marketplace lists **$170,000 for 12 months** for the stated cloud-platform dimension. [Listing](https://aws.amazon.com/marketplace/pp/prodview-6gqg3yc2e2rsu). | Not evidence that all modules, connectors, users and services for a multinational are included. |
| **Atlan** | **Older 2024 UK G-Cloud schedule:** Advanced from **£110,000/year**, Enterprise from **£300,000/year**. Published role prices include Insights **£1,188/year**, Member **£588**, Guest **£60**. [Public schedule](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-14/documents/703311/751541331504885-pricing-document-2024-04-30-1721.pdf). | Historical public tariff, not a verified November 2026 quote. Bundled users/connectors and optional features must be checked. |
| **Denodo** | **Older 2024 UK schedule:** Enterprise Subscription **£61,700 per four cores**, Enterprise Plus **£75,100 per four cores**, excluding VAT and professional services. [Schedule](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-14/documents/717035/434185192790796-pricing-document-2024-05-07-1219.pdf). | The brief document does not clearly establish the charge period; it should not silently be annualised. |
| **Stardog** | AWS listing shows **$5.553/hour** software charges for listed instance types. [Listing](https://aws.amazon.com/marketplace/pp/prodview-ulfm6fel7xgjq). | Infrastructure, availability architecture and negotiated enterprise terms are additional considerations. |
| **Neo4j AuraDB** | Professional starts at **$0.09/GB/hour**, minimum 1 GB instance; Business Critical at **$0.20/GB/hour**, minimum 2 GB. Dedicated-cloud pricing is quoted. [Pricing](https://neo4j.com/pricing/). | Size the database instance and availability tier; these are not per-GB prices for arbitrary object storage or a complete knowledge-graph implementation. |
| **Snowflake Cortex Analyst / Agents** | The consumption table effective **12 November 2026** lists standalone Analyst API usage at **67 Platform Credits per 1,000 messages**. Analyst invoked through Agents uses token-based AI Credit pricing instead. [Consumption table](https://www.snowflake.com/legal/creditconsumptiontable/), [pricing explanation](https://docs.snowflake.com/en/user-guide/snowflake-cortex/pricing). | Platform Credits and AI Credits are different units. Generated SQL also incurs warehouse charges. AI Credits list at $2.00 for global routing and $2.20 for regional routing; do not apply those prices to the 67-Platform-Credit tariff. |
| **Salesforce Data Cloud, current pricing page labelled Data 360** | Flex Credits **$500 per 100,000**; Profiles **$240 per 1,000 profiles/year**, Enterprise Profiles **$420**. Non-profile querying and unstructured processing still use credits. [Pricing](https://www.salesforce.com/data/pricing/). | Profile-based and consumption-based costs coexist. It is misleading to cost a large customer context estate solely by employee seats. |

### 7.3 What those tariffs imply, with transparent arithmetic

These are **illustrative list-price calculations**, not observed contracts:

- Twenty Cube Premium developers plus one continuously running dedicated deployment: `20 × $80 × 12 + $1.20 × 8,760 = $29,712/year`. Add explorers/viewers, additional workers, source compute and enterprise requirements. This example demonstrates why a small team tariff is not a multinational budget. [Cube pricing](https://cube.dev/pricing).
- One thousand Power BI Pro users at the displayed US rate: `1,000 × $14 × 12 = $168,000/year`. This is a seat-price comparison, not necessarily the least-cost or appropriate capacity arrangement. [Microsoft pricing](https://www.microsoft.com/en-us/microsoft-fabric/features/power-bi/pricing).
- Atlan's older Advanced starting platform plus 20 Insights, 100 Member and 200 Guest licences: `£110,000 + £23,760 + £58,800 + £12,000 = £204,560/year`, before additional options. This arithmetic assumes those roles are incremental to the platform bundle and must be checked in an actual quote. [2024 schedule](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-14/documents/703311/751541331504885-pricing-document-2024-04-30-1721.pdf).
- One listed Stardog software instance running continuously: `$5.553 × 8,760 = $48,644.28/year`, before infrastructure and any additional instances. [AWS listing](https://aws.amazon.com/marketplace/pp/prodview-ulfm6fel7xgjq).
- Ten million Salesforce profiles at the standard listed profile rate: `10,000 × $240 = $2.4 million/year`, before additional consumption and contractual adjustments. A broad consumer-identity programme can therefore have a very different cost shape from an employee-facing metric service. [Salesforce pricing](https://www.salesforce.com/data/pricing/).

The older Atlan schedule also publishes technical-account-management engagement levels of $30,000–$90,000. These are not quotations for a complete global implementation, but they illustrate that enablement/support services can be separately packaged. The source mixes pound-denominated licences and dollar-denominated engagements; no currency conversion is assumed here. [2024 public schedule](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-14/documents/703311/751541331504885-pricing-document-2024-04-30-1721.pdf).

### 7.4 First-domain and enterprise programme budgets

The following are **bottom-up consultant estimates**, not discovered annual contract values. Salary and day-rate assumptions are chosen modelling inputs, not asserted market medians. They include the allocated cost of staff even when staff already work for the company; incremental cash expenditure may therefore be lower. Existing cloud, BI, ERP and data licences should be credited where genuinely reusable.

| Scope and assumptions | Internal team | Software allowance | Cloud allowance | SI / specialist services | Modelled total |
|---|---:|---:|---:|---:|---:|
| **First production domain over six months**, 6–10 FTE at an assumed $180,000 loaded annual cost; 100–250 specialist days at an assumed $1,800/day | $0.54–0.90m | $0.10–0.35m | $0.05–0.15m | $0.18–0.45m | **$0.87–1.85m** through initial production, with a full first-year licence allowance |
| **Focused annual service on an existing platform**, 6–10 FTE at $180,000–220,000; 50–150 specialist days at $2,000/day | $1.08–2.20m | $0.05–0.25m | $0.05–0.20m | $0.10–0.30m | **$1.28–2.95m/year** |
| **Global multi-domain operating programme**, 20–40 FTE at $180,000–240,000; 150–500 specialist days at $2,000/day | $3.60–9.60m | $0.50–2.00m | $0.30–1.50m | $0.30–1.00m | **$4.70–14.10m/year** |

The software allowances are judgemental envelopes informed by the licence anchors, not a sum of every vendor in this report. The global scenario assumes several domain teams and shared platform, governance and identity work. The staff range is calculated by multiplying both low assumptions and both high assumptions; it is not a statistical confidence interval. The cloud allowances must be replaced by a measured workload estimate during a pilot. The first-domain and ongoing rows are alternative scope views, not amounts to add automatically.

Initial enterprise-wide remediation can add substantial services effort. For illustration only, another 500–1,500 SI days at $1,800–2,500/day produces **$0.9–3.75 million** additional implementation expenditure. This should be attached to a defined backlog—such as product crosswalks, ERP harmonisation or access-policy migration—and not charged twice if internal staff or a broader transformation already cover it. No public evidence found supports treating that range as the standard implementation price of any named product.

### 7.5 Cloud and hidden cost mechanics

Recommended cost decomposition is: source ingestion/CDC; transformation; warehouse or query-engine execution; semantic-engine resources; graph/index storage and refresh; LLM inference; evaluation; observability; networking; non-production environments; and disaster recovery. Model usage per workload, not only per employee. Repeated agent tool calls can generate several source queries per user question, while refresh and background curation can incur costs without any foreground user.

For a transparent sensitivity example, assume—not a provider quote—an effective compute rate of $8/hour. One continuously allocated resource costs `$8 × 8,760 = $70,080/year`; four cost $280,320 before storage or AI inference. An assumed 100,000 agent questions per month at $0.10–0.50 of combined variable query/inference cost produces $120,000–600,000 annually. Replace those assumptions with pilot measurements; they show why concurrency, query design and tool-call count matter more than a vague promise of cheaper AI.

Snowflake's evaluation documentation explicitly identifies warehouse, judge-inference and storage charges. Cube separately prices deployment, API instances and cache workers. These are concrete reasons to include supporting workloads rather than budgeting only the headline licence. [Snowflake evaluations](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst-evaluations); [Cube pricing](https://cube.dev/pricing).

Do not use Coca-Cola's **$1.1 billion, five-year Microsoft commitment** as a context-layer cost benchmark: its scope is broad cloud and generative AI transformation. The same caution applies to acquisition prices and total corporate technology spending. [Coca-Cola announcement, older 23 April 2024](https://www.coca-colacompany.com/media-center/the-coca-cola-company-and-microsoft-announce-five-year-strategic-partnership-to-accelerate-cloud-and-generative-ai-initiatives).

## 8. Architecture: components, inputs, outputs and system connections

### 8.1 Component contract

This is a **recommended reference decomposition**, synthesised from the product documentation cited in the table. It is not a requirement to purchase one tool for each row: a platform may supply several capabilities, and a limited use case may not need a graph or vector index at all.

| Component | Input | Output / contract | Representative implementation evidence |
|---|---|---|---|
| Sources and ingestion | Operational rows, events, files, partner feeds, documents | Timestamped records with source identifiers, refresh and deletion behaviour | Retail connectors and normalisation: [Crisp](https://www.gocrisp.com/our-platform). |
| Storage or virtualisation | Records or live source references | Queryable tables/views with explicit freshness and location | [Denodo](https://www.denodo.com/en/denodo-platform/denodo-platform), [Direct Lake](https://learn.microsoft.com/en-us/fabric/fundamentals/direct-lake-overview). |
| Catalog and metadata | Schemas, descriptions, lineage, owners, classifications | Discoverable assets and governed context | [Horizon Context preview](https://docs.snowflake.com/en/release-notes/2026/other/2026-10-12-horizon-context-preview). |
| Glossary / ontology | Approved terms, entities, relationships, rules | Machine-readable meaning and constraints | [TopBraid](https://docs.topquadrant.com/9.0/user_guide/guidance_specific_to_asset_collection_type/working_with_ontologies/working_with_ontologies.html). |
| Entity resolution / MDM | Source identifiers and candidate records | Golden identities, crosswalks, authoritative attributes and exceptions | [SAP MDG](https://www.sap.com/products/data-cloud/master-data-governance.html). |
| Semantic execution | Governed facts, measures, joins and dimensions | Reproducible analytical results with a defined grain | [Databricks metric views](https://docs.databricks.com/aws/en/uc-semantics/metric-views/). |
| Knowledge graph | Selected entities, relationships and provenance | Traversal, relationship evidence and reasoning context | [Neo4j](https://neo4j.com/product/knowledge-layer/), [Stardog](https://docs.stardog.com/virtual-graphs/). |
| Search / vector retrieval | Documents, passages, descriptions and access metadata | Relevant evidence with source references and permission checks | Enterprise retrieval context: [Glean](https://docs.glean.com/security/knowledge-graph); graph/retrieval combination: [Neo4j](https://neo4j.com/product/knowledge-layer/). |
| Policy and access | Identity, roles, classifications, purpose and source permissions | Enforced discovery, query and action permissions | [Palantir Ontology](https://www.palantir.com/docs/foundry/architecture-center/ontology-system), [Alation MCP](https://alation.github.io/agent-studio-docs/integrations/mcp/using-the-mcp-server/). |
| Lineage / quality / evaluation | Transformations, tests, query traces, reference answers | Impact analysis, quality status and evidence of answer correctness | [Mondelez/Ataccama](https://www.ataccama.com/customer-story/before-mondelez-international-could-trust-ai-it-had-to-trust-its-data), [Snowflake evaluation](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst-evaluations). |
| Serving APIs | Approved model requests and caller identity | SQL, REST, GraphQL, MDX or MCP responses, depending on product | [Cube SQL](https://cube.dev/blog/cube-core-and-cube), [dbt interfaces](https://docs.getdbt.com/docs/use-dbt-semantic-layer/setup-sl), [AtScale's older matrix](https://www.atscale.com/wp-content/uploads/2024/08/AtScale-BI-Tool-Support-Matrix.pdf). |
| Consumers and actions | Governed numbers, evidence and permitted operations | BI, spreadsheets, applications, recommendations, agents and audited changes | [GoodData MCP](https://www.gooddata.ai/docs/cloud/ai/mcp-server/), [Palantir actions](https://www.palantir.com/docs/foundry/architecture-center/ontology-system). |

### 8.2 Source-system mapping for a CPG or retail client

The following is a **discovery and design checklist**, not a claim that every listed product includes every connector. For each system, verify the actual API/export/CDC method, licensed access, supported version, deletion handling and query limits.

| Systems to connect | Context to preserve | Intended output |
|---|---|---|
| SAP ECC / S/4HANA; Oracle ERP | Material, legal entity, customer, supplier, ledger, document line, posting date, currency and organisational hierarchy | Reconciled finance, commercial and supply facts linked to business meaning. SAP's architecture emphasises preserving business semantics in data products. [SAP architecture](https://architecture.learning.sap.com/docs/ai-native-north-star-architecture/foundation-layer). |
| Salesforce and other CRM | Account identity, account hierarchy, opportunity/order stage, product and consent/access context | Customer/commercial context suitable for applications and agents. [Salesforce connectivity](https://www.salesforce.com/data/connectivity/zero-copy/). |
| Workday and HR systems | Employee/position identities, organisation, effective dates and sensitive-access boundaries | Authorised workforce metrics and employee-service context; confirm supported integration rather than assuming a generic connector suffices. Microsoft's Work IQ documents connected enterprise context and interfaces. [Work IQ](https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/work-iq/). |
| Walmart Scintilla, previously Luminate; other retailer/distributor feeds | Retailer item/store, sales/inventory grain, calendar, location and availability | Harmonised sell-out and execution data. Walmart announced the rename in 2024 for the following year. [Naming announcement, older 2024](https://corporate.walmart.com/news/2024/10/02/walmart-data-ventures-signals-growth-at-inspire-announces-new-name-for-insights-ecosystem), [Crisp](https://www.gocrisp.com/our-platform). |
| NielsenIQ / Circana / SPINS | Licensed product/category taxonomies, market definitions, panel/projection coverage and measure basis | Market context mapped to internal brands and products, with usage rights retained. [Circana](https://www.circana.com/post/circana-s-liquid-supply-chain-solution-creates-an-inventory-command-center-for-cross-retailer-insigh), [SPINS, older 2024](https://www.spins.com/wp-content/uploads/2024/07/SPINS-IFT-2024-Values-Oriented-PRESENTATION.pdf). |
| Google, Meta and retail media platforms | Campaign/ad/product identifiers, spend, exposure, geography, time and attribution definition | Comparable media inputs and links to retail outcomes; causal measurement remains separate. [Tesco/L'Oréal, older case](https://www.dunnhumby.com/wp-content/uploads/2023/10/Tesco-Media-Insight-Platform-Loreal_CaseStudy.pdf). |
| MES, historians such as OSIsoft PI / AVEVA PI, equipment gateways | Asset hierarchy, tag/unit, timestamp, batch, line state, quality and maintenance context | Traceable operating events and production context. AVEVA's infrastructure documentation describes the historian/edge/cloud combination. [AVEVA service document](https://www.aveva.com/content/dam/aveva/documents/legal/service-documents/AVEVA-PI-Data-Infrastructure.pdf). |
| PLM, WMS and TMS | Specification/version, material, lot, warehouse/bin, shipment/route, status and constraints | Product-to-production-to-delivery relationships. Planning graphs provide the relevant domain pattern; individual connectors require verification. [Kinaxis](https://www.kinaxis.com/en/semantic-graph), [o9](https://o9solutions.com/news/o9-named-a-leader-in-the-nucleus-research-scp-technology-value-matrix-2025). |

### 8.3 Three boundaries an architecture drawing must show

First, separate **business data** from **metadata and evidence**. A catalog record describing an inventory table is not current inventory. A vector match to a finance policy is not a computed margin. An agent should be able to retrieve an explanation and call the approved calculation independently, then cite both where appropriate.

Second, separate **read authority** from **action authority**. Discovering a purchase order, calculating a shortage and changing the order are different permissions. Third, separate **approved knowledge** from **agent working memory**. A conversation-derived hypothesis should not silently overwrite a corporate definition. These are recommended design controls grounded in the distinction between Palantir's secured operational actions, dbt's governed analytical tools and Ramp's scoped memory. [Palantir](https://www.palantir.com/docs/foundry/architecture-center/ontology-system); [dbt MCP](https://docs.getdbt.com/docs/dbt-ai/about-mcp); [Ramp](https://support.ramp.com/how-glass-works/).

## 9. What the named CPG and retail companies have publicly said or done

This register distinguishes direct semantic/context evidence from adjacent foundations. It consolidates the cases above without treating a cloud partnership as proof of a particular product deployment.

| Company | Defensible public statement | What remains unproven in the inspected sources |
|---|---|---|
| **Unilever** | Data-product governance roles; a five-year Google Cloud partnership announced in February 2026 covering marketing and an AI-oriented digital foundation; company-reported connected supply-chain use cases. [Google announcement](https://www.googlecloudpresscorner.com/2026-02-17-Unilever-and-Google-Cloud-Partner-to-Pioneer-Next-Generation-of-Consumer-Goods-Technologies), [governance case](https://www.bridgenco.com/insights/case-studies/optimizing-data-governance-at-unilever/). | A specific Unilever–Palantir Ontology deployment was not established. The partnership announcement does not prove enterprise LookML adoption. |
| **Nestlé** | SAP/ERP harmonisation, cloud/data foundations and a concrete Nestlé USA retailer/distributor mapping example. [Annual report](https://www.nestle.com/investors/annual-report/executing-strategy/accelerating-business-transformation), [Crisp](https://www.gocrisp.com/case-studies/nestle-usa). | Completion of one universal enterprise semantic layer, or the current SAP ontology roadmap deployed group-wide. |
| **IKEA / Ingka** | Inter IKEA product knowledge-graph recommendations, documented in 2023; Ingka's 2025 company-wide data-platform/data-mesh operating model. These are different organisational scopes. [Conference archive](https://zenodo.org/records/7908305), [Ingka talk](https://2025.platformcon.com/sessions/delivering-a-greenfield-data-platform-with-togetherness-at-its-heart-through-a-team-of-teams-setup). | One shared ontology spanning all IKEA entities, finance, retail and manufacturing; exact implementation staffing. |
| **P&G** | Factory IT/OT context and Azure IoT Operations deployment. [Microsoft case](https://www.microsoft.com/en/customers/story/25077-procter-and-gamble-iot-operations). | Enterprise-wide Fabric IQ ontology adoption or a demonstrated AI-answer accuracy result. |
| **Mars** | Manufacturing digital-twin pilots and scaling plans with Accenture/Microsoft, disclosed in 2022. [Older announcement](https://newsroom.accenture.com/news/2022/accenture-collaborates-with-mars-to-develop-factory-of-the-future-using-ai-cloud-edge-and-digital-twins). | A current universal semantic product, public licence cost or measured enterprise rollout completion. |
| **Diageo** | A governed Strategy semantic foundation serving performance management and an assistant. [2026 case](https://software.strategy.com/blog/how-diageo-scales-enterprise-ai-with-a-governed-semantic-layer). | Exact build duration, team size, total cost and controlled accuracy/ROI comparison. |
| **PepsiCo** | An enterprise Databricks/Unity Catalog platform supporting multiple digital products, documented in 2024. [Older case](https://www.databricks.com/blog/how-pepsico-established-enterprise-grade-data-intelligence-platform-powered-databricks-unity). | Deployment of every subsequently released metric-view or Genie ontology capability. |
| **Coca-Cola** | A five-year Microsoft partnership announced in 2024, including Azure and generative AI across marketing, manufacturing and supply chain. [Company announcement](https://www.coca-colacompany.com/media-center/the-coca-cola-company-and-microsoft-announce-five-year-strategic-partnership-to-accelerate-cloud-and-generative-ai-initiatives). | A disclosed enterprise semantic-model architecture or semantic-layer-specific spend. |
| **Walmart** | Its engineering account describes Element/WIBEY agent infrastructure with state, memory, context propagation and tool integration; Scintilla connects supplier insights and execution. [Engineering account](https://tech.walmart.com/content/walmart-global-tech/en_us/blog/post/wibey-announcement.html), [Scintilla In-Store](https://corporate.walmart.com/news/2026/02/23/introducing-scintilla-in-store-the-future-of-third-party-retail-execution-at-walmart). | A single public canonical metric model covering every internal and supplier agent. |
| **Tesco** | Retail-media customer/product context is visible in its L'Oréal campaign; the 2026 annual report discusses its Mistral AI relationship. [Older campaign](https://www.dunnhumby.com/wp-content/uploads/2023/10/Tesco-Media-Insight-Platform-Loreal_CaseStudy.pdf), [2026 annual report](https://www.tescoplc.com/media/gmylxjfw/tesco_ar26_interactive.pdf). | A fully specified public semantic engine or enterprise context graph inferred from the AI partnership. |
| **L'Oréal** | Beauty Genius knowledge-graph recommendations using Neo4j, publicly presented in April 2026. [Customer presentation](https://neo4j.com/customer-stories/loreal-graphsummit-2026/). | Public model size, production team, implementation duration, cost or controlled conversion uplift from the graph. |
| **Kraft Heinz** | Snowflake migration and retailer data sharing for collaboration and business planning, described in 2022. [Older case](https://www.snowflake.com/en/blog/kraft-heinz-fosters-collaboration-retail-partners/). | Cortex Analyst or a later named context-layer deployment merely because Snowflake is present. |
| **Mondelez** | Ataccama quality/catalog/lineage work and business stewardship supporting trusted AI data, described in September 2026. [Case](https://www.ataccama.com/customer-story/before-mondelez-international-could-trust-ai-it-had-to-trust-its-data). | Published causal AI accuracy improvement, enterprise implementation cost or complete cross-functional ontology. |

### Evidence gaps worth taking into client and vendor interviews

No inspected source provides a complete, independently audited package of implementation duration, exact team size, annual licence, cloud cost and business ROI for a Unilever/Nestlé-scale semantic or context layer. Named cases frequently disclose one or two of those dimensions. Ask for source-system scope, pre-existing foundations, mapping backlog, supported-question coverage and ongoing stewardship workload before using any case as a delivery benchmark.

No direct source established the suggested Unilever–Palantir example. It should remain unverified rather than be repeated as a market fact. Similarly, public AI announcements for several named companies do not disclose enough architecture to identify the semantic engine. This is an evidence limitation, not evidence that those companies have no private implementation.

Some sources use “semantic layer” for executable metrics, while others include business ontologies, metadata and relationships. Some vendors call federation “zero-copy”, while others also use the phrase for shared analytical tables. The report preserves the operational distinction rather than reconciling these different usages into a false single category. [MIT CISR](https://cisr.mit.edu/publication/2026_0501_SemanticLayer_LefebvreWixomLegnerVandermeulenBeath); [Salesforce](https://www.salesforce.com/data/connectivity/zero-copy/); [Stardog](https://docs.stardog.com/virtual-graphs/).

## Reference architectures: text boxes and arrows

These are **illustrative reference designs**, not reconstructions of a named company's private architecture and not assertions that every product listed interconnects without engineering. Product names represent alternatives. The purpose is to make the decisions, data movement and control boundaries explicit enough to draw.

### Architecture A: central analytical foundation for commercial metrics and AI

**Best suited to:** a manufacturer already consolidating analytical data, initially targeting sales, revenue growth management and finance. Foundations: [dbt Semantic Layer](https://docs.getdbt.com/docs/use-dbt-semantic-layer/setup-sl), [Snowflake semantic views](https://docs.snowflake.com/en/user-guide/views-semantic/semantic-view-yaml-spec), [LookML](https://docs.cloud.google.com/looker/docs/what-is-lookml), [Crisp retail data](https://www.gocrisp.com/our-platform).

```text
[SAP ECC/S4 + Oracle finance]   [Salesforce]   [Retail POS + media feeds]
                 \                 |                   /
                  ---> [CDC / APIs / files / partner sharing]
                                      |
                                      v
                          [Raw analytical landing zone]
                                      |
                    [Transform + quality + reconciliation]
                                      |
              [MDM product/customer/store crosswalks] --->|
                                      v
           [Curated facts at explicit grains + conformed dimensions]
                                      |
                                      v
              [ONE authoritative metric definition per use case]
                   [dbt OR Looker OR warehouse-native model]
                              /                 \
                  [BI / Excel / apps]       [SQL or metric API]
                                                  |
[Catalog + lineage + glossary] ---> [Context/tool gateway] <--- [User identity]
[Approved documents + search] ---->        |
                                          v
                                      [AI agent]
                                          |
                         [Answer + definition + evidence + timestamp]
```

Read the main downward arrows as data movement and transformation. The side arrows from MDM and metadata bind identities and meaning; they are not alternative copies of the fact tables. The agent asks the semantic service for numbers and the document service for explanatory evidence. It does not calculate net revenue by searching passages. An access check applies to metadata discovery and separately to query execution.

Recommended first product: market/customer/month gross-to-net analysis with an agreed product hierarchy and approved local variants. Keep retailer sell-out as a distinct fact from manufacturer invoicing. Add media data only after product/time/geography mapping is proven. Outputs should include the metric version, filters, grain, source freshness and supporting explanation. For performance, materialise repeatable transformations and aggregates when justified by measured load. Write-back to CRM or ERP should be a separate tool with its own authorisation.

**Drawing notes:** place identity/policy across all serving boxes; place lineage and quality below the transformation-to-output path; show query/evaluation telemetry returning to the domain product team. The storage platform is a design choice, not the semantic authority by itself. A client with a mature native model may not need a second independent metric engine.

### Architecture B: federated business context across a distributed estate

**Best suited to:** a group with substantial SAP, cloud, regional and acquired-company systems that cannot sensibly be consolidated before delivering value. Foundations: [Denodo](https://www.denodo.com/en/denodo-platform/denodo-platform), [Starburst](https://www.starburst.io/blog/starburst-galaxy-ai-on-iceberg-foundations/), [Stardog](https://docs.stardog.com/virtual-graphs/), [Timbr](https://timbr.ai/doc/docs/getting-started/intro-timbr/), [Alation MCP](https://alation.github.io/agent-studio-docs/integrations/mcp/using-the-mcp-server/).

```text
[Regional SAP] [Snowflake] [Databricks] [BigQuery] [Partner data products]
       |             |          |          |                |
       +-------- [Governed source interfaces / query pushdown] --------+
                                      |
                         [Federation / virtual graph]
                           |                    |
                  [Selective cache]     [Domain semantic services]
                           \                    /
                            [Governed query API]
                                      |
                              [BI / apps / agents]

[Source schemas + lineage + terms] ---> [Central metadata/context catalog]
[Identity crosswalks + ontology] -----> [Mapping and relationship registry]
[Policies + user identity] ----------> [Authorisation at each boundary]
                         \                 |                 /
                          --------> [Context gateway] ------+
```

The upper boxes retain primary data in multiple locations. The registry stores mappings and agreed relationships; the catalog stores metadata and approved definitions. A selected cache is explicitly a copy, with an expiry and ownership policy. A virtual graph can translate relationship questions into source queries, while an existing domain semantic service can remain authoritative for financial measures. Do not attempt to reproduce every source's business logic in the federation engine merely to make the diagram look uniform.

Recommended first product: a governed cross-market inventory and service view linking regional product/customer identifiers. Persist snapshots where historical reproducibility is required. Keep heavy analytical joins away from operational systems unless workload tests show they can tolerate them. The execution plan should identify which source processes each filter/join and where results cross organisational or cloud boundaries.

**Drawing notes:** use solid arrows for query/results and dashed arrows for metadata harvesting. Show failure behaviour: stale cache, partial response or explicit refusal. Record source-specific authorisation and the identity under which each query runs. A central catalog does not confer permission to read all catalogued data, and a shared entity name does not eliminate currency, calendar or packaging differences.

### Architecture C: operational ontology for manufacturing and supply decisions

**Best suited to:** traceability, production exceptions, shortage management or planning scenarios requiring relationships, live state and controlled actions. Foundations: [Palantir Ontology](https://www.palantir.com/docs/foundry/architecture-center/ontology-system), [Kinaxis semantic graph](https://www.kinaxis.com/en/semantic-graph), [o9](https://o9solutions.com/news/o9-named-a-leader-in-the-nucleus-research-scp-technology-value-matrix-2025), [P&G factory integration](https://www.microsoft.com/en/customers/story/25077-procter-and-gamble-iot-operations), [AVEVA PI infrastructure](https://www.aveva.com/content/dam/aveva/documents/legal/service-documents/AVEVA-PI-Data-Infrastructure.pdf).

```text
[MES + historian + equipment] ---> [Edge/event processing] ---> [Event history]
[SAP orders/materials] ----------> [Operational ingestion] ----->|
[PLM recipes/specifications] ----> [Versioned mappings] -------->|
[WMS/TMS + supplier events] -----> [Entity resolution] --------->|
                                                              v
                [Operational model: product / lot / asset / order /
                 supplier / shipment / site / constraint / state]
                         |                 |                  |
                 [Relationship       [Planning or       [Approved SOPs /
                  queries]            simulation]        retrieved evidence]
                         \                 |                  /
                          ----> [Decision agent / application]
                                           |
                    [Proposed action + rationale + affected objects]
                                           |
                         [Permission + validation + approval]
                                           |
                              [Audited command/API]
                                           |
                            [ERP / MES / planning system]
                                           |
                              [Outcome feedback/events]
```

Choose an operational platform appropriate to the use case; the diagram does not imply installing Palantir, o9, Kinaxis and a second graph together. Retain high-frequency signals where they are best operated, and connect derived events to the relevant asset, lot and order. Attach validity periods to specifications and relationships so a quality investigation can reconstruct the historical state.

Recommended first product: identify which orders are affected by a constrained production line or suspect batch, explain the path through materials and shipments, and propose an authorised mitigation. A simulation result is a scenario, not an observed outcome. An agent may recommend changing a plan, but a separate action service checks authority, current state and operating constraints before writing back.

**Drawing notes:** a certified finance/metric API supplies the financial consequences of proposed actions; it need not live in the operational graph. Keep proposed decisions and agent memory separate from approved operating rules. Audit the chosen action, source state, approvals and subsequent outcome. This provides a feedback loop without allowing successful-looking agent behaviour to redefine business policy automatically.


## Full numbered source list

All 101 sources below were opened during this research and accessed on 16 November 2026. Entries follow first-citation order. Publication dates, older-source warnings, preview status and evidence limitations appear alongside the relevant claims in the report. Undated documentation and pricing pages are current-page observations, not guarantees about historical versions or negotiated commercial terms. Redirected pages are listed at the cited destination where applicable.

1. **Administer the Semantic Layer — dbt Developer Hub**. <https://docs.getdbt.com/docs/use-dbt-semantic-layer/setup-sl>.

2. **Context layer — Atlan Documentation**. <https://docs.atlan.com/agents/faq/context-layer>.

3. **The Ontology system • Palantir**. <https://www.palantir.com/docs/foundry/architecture-center/ontology-system>.

4. **Ramp Help Center**. <https://support.ramp.com/how-glass-works/>.

5. **With Crisp and Tinuiti, poppi ties digital marketing to in-store sales lift**. <https://www.gocrisp.com/case-studies/poppi>.

6. **Tesco Media and Insight Platform.**. <https://www.dunnhumby.com/wp-content/uploads/2023/10/Tesco-Media-Insight-Platform-Loreal_CaseStudy.pdf>.

7. **Modernizing your marketing mix modeling - Think with Google**. <https://business.google.com/ca-en/think/marketing-strategies/marketing-mix-modeling-tutorial/>.

8. **Building explainable and trustworthy recommendation systems: What we learned from IKEA at KGC 2023**. <https://blog.metaphacts.com/building-explainable-trustworthy-recommendation-systems-ikea-at-kgc2023>.

9. **L’Oréal builds Beauty Genius, a personal beauty assistant, on knowledge graphs**. <https://neo4j.com/customer-stories/loreal-graphsummit-2026/>.

10. **Data Cloud – Zero Copy Connectivity — Salesforce**. <https://www.salesforce.com/data/connectivity/zero-copy/>.

11. **Real-Time, AI-Driven Entity Resolution**. <https://www.reltio.com/products/entity-resolution/>.

12. **Strategy — How Diageo Scales Enterprise AI with a Governed Semantic Layer (20 April 2026)**. <https://software.strategy.com/blog/how-diageo-scales-enterprise-ai-with-a-governed-semantic-layer>.

13. **Nestlé USA boosts visibility and efficiency with UNFI Insights™ powered by Crisp**. <https://www.gocrisp.com/case-studies/nestle-usa>.

14. **Introducing Scintilla In-Store: The Future of Third-Party Retail Execution at Walmart**. <https://corporate.walmart.com/news/2026/02/23/introducing-scintilla-in-store-the-future-of-third-party-retail-execution-at-walmart>.

15. **Inside Unilever’s AI-powered supply chain — Unilever**. <https://www.unilever.com/news/news-search/2026/building-resilience-driving-growth-inside-unilevers-aipowered-supply-chain/>.

16. **Semantic Graph — Kinaxis**. <https://www.kinaxis.com/en/semantic-graph>.

17. **o9 Named a Leader in the Nucleus Research SCP Technology Value Matrix 2025 - o9 Solutions**. <https://o9solutions.com/news/o9-named-a-leader-in-the-nucleus-research-scp-technology-value-matrix-2025>.

18. **Procter & Gamble cuts model deployment time up to 90% with Azure IoT Operations — Microsoft Customer Stories**. <https://www.microsoft.com/en/customers/story/25077-procter-and-gamble-iot-operations>.

19. **Accenture Collaborates with Mars to Develop “Factory of the Future” Using AI, Cloud, Edge and Digital Twins**. <https://newsroom.accenture.com/news/2022/accenture-collaborates-with-mars-to-develop-factory-of-the-future-using-ai-cloud-edge-and-digital-twins>.

20. **Streamlining KPI dashboards with the dbt Semantic Layer — dbt Labs**. <https://www.getdbt.com/blog/streamlining-kpi-dashboards-dbt-semantic-layer>.

21. **McCarthy Holdings, Inc. Customer Story — Glean Work AI**. <https://www.glean.com/resources/customer-stories/mccarthy-holdings-inc>.

22. **Running a Software Factory Efficiently at Uber Scale**. <https://www.uber.com/gb/en/blog/efficient-software-factory/>.

23. **Under the River (2026) - Shopify**. <https://shopify.engineering/under-the-river>.

24. **dbt — Model Context Protocol server**. <https://docs.getdbt.com/docs/dbt-ai/about-mcp>.

25. **Cube — The Future of Cube Core and Cube (14 May 2026)**. <https://cube.dev/blog/cube-core-and-cube>.

26. **Pricing Slides - GTM Motion - Pricing, Plans, Selling**. <https://www.atscale.com/wp-content/uploads/2024/08/AtScale-BI-Tool-Support-Matrix.pdf>.

27. **Introduction to LookML  —  Looker  —  Google Cloud Documentation**. <https://docs.cloud.google.com/looker/docs/what-is-lookml>.

28. **Direct Lake overview - Microsoft Fabric — Microsoft Learn**. <https://learn.microsoft.com/en-us/fabric/fundamentals/direct-lake-overview>.

29. **YAML specification for semantic views — Snowflake Documentation**. <https://docs.snowflake.com/en/user-guide/views-semantic/semantic-view-yaml-spec>.

30. **Unity Catalog metric views — Databricks on AWS**. <https://docs.databricks.com/aws/en/uc-semantics/metric-views/>.

31. **Unity Catalog semantics — Databricks on AWS**. <https://docs.databricks.com/aws/en/uc-semantics/>.

32. **Foundation Layer: AI, Data & Knowledge Graph — SAP Architecture Center**. <https://architecture.learning.sap.com/docs/ai-native-north-star-architecture/foundation-layer>.

33. **Kyvos Model Context Protocol (MCP) Server - Kyvos 2026.9 - Kyvos Documentation**. <https://docs.support.kyvosinsights.com/wiki/spaces/KD20269/pages/1496881576/Kyvos%2BModel%2BContext%2BProtocol%2BMCP%2BServer>.

34. **GoodData MCP Server — GoodData Cloud**. <https://www.gooddata.ai/docs/cloud/ai/mcp-server/>.

35. **Honeydew and Snowflake Semantic Views - Honeydew**. <https://honeydew.ai/blog/honeydew-and-snowflake-semantic-views/>.

36. **Context is the new IP: Collibra is where enterprises come to protect it — Collibra**. <https://www.collibra.com/blog/context-is-the-new-ip-collibra-is-where-enterprises-come-to-protect-it>.

37. **Using the MCP Server — Alation Agent Studio Documentation**. <https://alation.github.io/agent-studio-docs/integrations/mcp/using-the-mcp-server/>.

38. **ServiceNow Reports Second Quarter 2025 Financial Results - ServiceNow Newsroom**. <https://newsroom.servicenow.com/press-releases/details/2025/ServiceNow-Reports-Second-Quarter-2025-Financial-Results/default.aspx>.

39. **Knowledge Graph**. <https://docs.glean.com/security/knowledge-graph>.

40. **Microsoft Learn — What is Fabric IQ?**. <https://learn.microsoft.com/fabric/iq/overview>.

41. **Microsoft Learn — Work IQ overview**. <https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/work-iq/>.

42. **Oct 12, 2026: Horizon Context (*Preview*) — Snowflake Documentation**. <https://docs.snowflake.com/en/release-notes/2026/other/2026-10-12-horizon-context-preview>.

43. **Neo4j — Knowledge layer**. <https://neo4j.com/product/knowledge-layer/>.

44. **Virtual Graphs — Stardog Documentation Latest**. <https://docs.stardog.com/virtual-graphs/>.

45. **Introduction — TopBraid EDG 9.0.0 documentation**. <https://docs.topquadrant.com/9.0/user_guide/guidance_specific_to_asset_collection_type/working_with_ontologies/working_with_ontologies.html>.

46. **Introduction to Timbr — Timbr Documentation**. <https://timbr.ai/doc/docs/getting-started/intro-timbr/>.

47. **SAP — Master Data Governance**. <https://www.sap.com/products/data-cloud/master-data-governance.html>.

48. **Unlock retail success — Stibo Systems master data management**. <https://www.stibosystems.com/industries/retail>.

49. **Profisee Brings End-to-End MDM Into Microsoft Fabric**. <https://profisee.com/press-release/profisee-brings-end-to-end-master-data-management-fully-into-microsoft-fabric-at-fabcon-2026-adds-fabric-open-mirroring-support-and-copilot-connectivity-via-profisee-mcp-server/>.

50. **Denodo - The Denodo Platform**. <https://www.denodo.com/en/denodo-platform/denodo-platform>.

51. **Starburst Galaxy: AI on Iceberg Foundations — Starburst**. <https://www.starburst.io/blog/starburst-galaxy-ai-on-iceberg-foundations/>.

52. **Dremio — Self-Service Semantic Layer**. <https://docs.dremio.com/current/help-support/well-architected-framework/semantic/>.

53. **Crisp Halo Platform — AI Built to Run Retail - Crisp**. <https://www.gocrisp.com/our-platform>.

54. **ATTRIBUTE INSIGHTS: PRODUCT INTELLIGENCE**. <https://www.spins.com/wp-content/uploads/2024/07/SPINS-IFT-2024-Values-Oriented-PRESENTATION.pdf>.

55. **Circana's New Liquid Supply Chain Provides Cross-Retailer Insights — Circana**. <https://www.circana.com/post/circana-s-liquid-supply-chain-solution-creates-an-inventory-command-center-for-cross-retailer-insigh>.

56. **NIQ - NIQ Announces Strong Fourth Quarter and Full Year 2025 Results**. <https://investors.nielseniq.com/news/news-details/2026/NIQ-Announces-Strong-Fourth-Quarter-and-Full-Year-2025-Results/default.aspx>.

57. **AI Supply Chain Software — Blue Yonder**. <https://blueyonder.com/why-blue-yonder/ai-and-machine-learning>.

58. **Unified merchandising platform — RELEX Solutions**. <https://www.relexsolutions.com/unified-merchandising-platform/>.

59. **Salesforce.com, Inc. - Salesforce Completes Acquisition of Informatica**. <https://investor.salesforce.com/news/news-details/2025/Salesforce-Completes-Acquisition-of-Informatica/>.

60. **Quarterly Statement Q3 2026**. <https://www.sap.com/docs/download/investors/2026/sap-2026-q3-statement.pdf>.

61. **Optimizing Data Governance at Unilever - Bridge & Co.**. <https://www.bridgenco.com/insights/case-studies/optimizing-data-governance-at-unilever/>.

62. **Delivering a greenfield data platform with “togetherness” at its heart through a Team-of-Teams setup — PlatformCon 2025**. <https://2025.platformcon.com/sessions/delivering-a-greenfield-data-platform-with-togetherness-at-its-heart-through-a-team-of-teams-setup>.

63. **Datashift — Strengthening Data Trust: Transforming Enterprise Data Governance**. <https://www.datashift.eu/case-studies/how-colruyt-group-built-a-stronger-data-foundation-with-collibra-and-datashift>.

64. **Snowflake — Cortex Analyst evaluations**. <https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst-evaluations>.

65. **How Ciena Curated 6,000 Data Assets in Two Weeks with AI — Alation — Alation**. <https://www.alation.com/customers/ciena-ai-data-catalog/>.

66. **Home - Apache Ossie (incubating)**. <https://ossie.apache.org/>.

67. **Knowledge-Graph-enhanced Product Catalogue — Zenodo**. <https://zenodo.org/records/7908305>.

68. **Semantic Layer vs. Text-to-SQL: 2026 Benchmark Update — dbt Developer Blog**. <https://docs.getdbt.com/blog/semantic-layer-vs-text-to-sql-2026>.

69. **Semantic Layers for Reliable LLM-Powered Data Analytics: A Paired Benchmark of Accuracy and Hallucination Across Three Frontier Models**. <https://arxiv.org/abs/2604.25149>.

70. **Which Part of the Context Layer Does the Work? Separating Semantic Content from Retrieval Scaffolding in Text-to-SQL Agents**. <https://arxiv.org/abs/2609.22259>.

71. **Raising the bar with AI analytics: How Diageo drives manufacturing innovation with Strategy**. <https://software.strategy.com/customer-stories/diageo>.

72. **How PepsiCo Established an Enterprise-grade Data + AI Platform Powered by Databricks Unity Catalog — Databricks Blog**. <https://www.databricks.com/blog/how-pepsico-established-enterprise-grade-data-intelligence-platform-powered-databricks-unity>.

73. **Honeydew Revolutionizes Business Intelligence with Investment from Snowflake Ventures**. <https://www.snowflake.com/en/blog/investment-honeydew-business-intelligence/>.

74. **With Crisp and Snowflake, Ritual formulates a data solution that bypasses build costs**. <https://www.gocrisp.com/case-studies/ritual>.

75. **Nestlé innovates its SAP landscape using RISE with SAP on Azure to be future-ready — Microsoft Customer Stories**. <https://www.microsoft.com/en/customers/story/23963-nestle-azure>.

76. **The Case for a Semantic Layer — MIT CISR**. <https://cisr.mit.edu/publication/2026_0501_SemanticLayer_LefebvreWixomLegnerVandermeulenBeath>.

77. **Accelerating our business transformation — Nestlé Global**. <https://www.nestle.com/investors/annual-report/executing-strategy/accelerating-business-transformation>.

78. **Kraft Heinz Fosters Collaboration with Retail Partners**. <https://www.snowflake.com/en/blog/kraft-heinz-fosters-collaboration-retail-partners/>.

79. **Mondelēz International case study: Trusted data with Ataccama ONE — Ataccama**. <https://www.ataccama.com/customer-story/before-mondelez-international-could-trust-ai-it-had-to-trust-its-data>.

80. **What is the difference between a GTIN, barcode, EAN and UPC? : GS1 GO Customer Service Portal**. <https://support.gs1.org/support/solutions/articles/43000734124-what-is-the-difference-between-a-gs1-gtin-a-barcode-an-ean-and-a-upc->.

81. **dbt Pricing — start free, scale with your team — dbt Labs**. <https://www.getdbt.com/pricing>.

82. **Cube Pricing**. <https://cube.dev/pricing>.

83. **Looker pricing — Google Cloud**. <https://cloud.google.com/looker/pricing>.

84. **Microsoft — Power BI pricing**. <https://www.microsoft.com/en-us/microsoft-fabric/features/power-bi/pricing>.

85. **Pricing - Honeydew**. <https://honeydew.ai/pricing/>.

86. **GoodData — Pricing**. <https://www.gooddata.ai/pricing/>.

87. **The Alation Data Intelligence Platform — AWS Marketplace**. <https://aws.amazon.com/marketplace/pp/prodview-ylge6fq43dtg6>.

88. **Collibra Data Intelligence Platform — AWS Marketplace**. <https://aws.amazon.com/marketplace/pp/prodview-6gqg3yc2e2rsu>.

89. **Atlan pricing**. <https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-14/documents/703311/751541331504885-pricing-document-2024-04-30-1721.pdf>.

90. **G-Cloud 14 Denodo Software Pricing**. <https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-14/documents/717035/434185192790796-pricing-document-2024-05-07-1219.pdf>.

91. **Stardog Enterprise Knowledge Graph Platform — AWS Marketplace**. <https://aws.amazon.com/marketplace/pp/prodview-ulfm6fel7xgjq>.

92. **Neo4j — Cloud and self-hosted graph database pricing**. <https://neo4j.com/pricing/>.

93. **Snowflake — Service Consumption Table, effective 12 November 2026**. <https://www.snowflake.com/legal/creditconsumptiontable/>.

94. **Snowflake — AI pricing**. <https://docs.snowflake.com/en/user-guide/snowflake-cortex/pricing>.

95. **Data 360 Pricing — Salesforce**. <https://www.salesforce.com/data/pricing/>.

96. **The Coca‑Cola Company and Microsoft announce five-year strategic partnership to accelerate cloud and generative AI initiatives**. <https://www.coca-colacompany.com/media-center/the-coca-cola-company-and-microsoft-announce-five-year-strategic-partnership-to-accelerate-cloud-and-generative-ai-initiatives>.

97. **Walmart Data Ventures Signals Growth at Inspire, Announces New Name for Insights Ecosystem**. <https://corporate.walmart.com/news/2024/10/02/walmart-data-ventures-signals-growth-at-inspire-announces-new-name-for-insights-ecosystem>.

98. **PI Data Infrastructure**. <https://www.aveva.com/content/dam/aveva/documents/legal/service-documents/AVEVA-PI-Data-Infrastructure.pdf>.

99. **Unilever and Google Cloud Partner to Pioneer Next Generation of Consumer Goods Technologies - Feb 17, 2026**. <https://www.googlecloudpresscorner.com/2026-02-17-Unilever-and-Google-Cloud-Partner-to-Pioneer-Next-Generation-of-Consumer-Goods-Technologies>.

100. **From models to agents: A new era of intelligent systems at Walmart**. <https://tech.walmart.com/content/walmart-global-tech/en_us/blog/post/wibey-announcement.html>.

101. **Board activity continued**. <https://www.tescoplc.com/media/gmylxjfw/tesco_ar26_interactive.pdf>.
