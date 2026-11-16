# Context and semantic layers: architecture, store-versus-connect, and the data dictionary question

Research slice 3 of 4 (brief questions 5, 6 and 8, plus the "how they build it" part of question 2).
Date of research: 16 November 2026. Every claim carries the URL of the page it came from; each page was
opened, not cited from a search snippet. Where a page could not be opened (Gartner, the Snowflake blog and
gs1.org all returned HTTP 403 to automated fetching), I say so and do not rely on it. Vendor numbers are
labelled as vendor claims. My own estimates and syntheses are labelled as such.

---

## 0. The short version

1. **A context layer is a stack, not a product.** Every serious description of it (a16z, Cube, DataHub,
   Glean, Microsoft, SAP) breaks down into roughly the same 12-14 components: sources, ingestion, storage
   or access, catalog, glossary, ontology/graph, metric engine, entity resolution/MDM, retrieval index,
   policy, lineage, caching, interfaces and consumers. Vendors differ in which of these they own.
2. **The most useful single distinction is "executable" versus "descriptive" context.** Cube's CEO frames
   the semantic (metrics) layer as "the one part that actually executes", with catalogs, glossaries,
   ontologies and lineage as descriptive context the agent reads, and memory as a third kind
   ([Cube, July 2026](https://cube.dev/blog/the-context-layer-needs-a-semantic-layer)). Microsoft's Fabric IQ
   ontology says the same thing from the other side: it "isn't itself a general-purpose data-query engine"
   and executes against bound sources ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/ontology/overview)).
3. **Store-versus-connect is now a false choice; everyone ships both.** Every major platform offers copy
   (CDC/mirroring), federation (query pushdown) and zero-copy sharing (open table formats plus a sharing
   protocol), and recommends copying when volume and latency matter
   ([Databricks](https://docs.databricks.com/aws/en/query-federation/)). The real decisions are per source:
   SAP is pushed towards SAP's own route by licence (SAP Note 3255746), retailer and syndicated data arrive
   as shares, OT data arrives as streams, and unstructured knowledge needs an index rather than live
   federation ([Glean](https://www.glean.com/blog/from-enterprise-search-to-enterprise-context-what-ai-agents-actually-need)).
4. **"Zero-copy" is not zero-cost.** SAP's own price list charges BDC Connect 0.185 Capacity Units per GB
   for inter-region transfer and 0.055 CU per 2,500 API calls, and charges Premium Outbound Integration from
   500 CU per 20 GB block when data leaves for a non-SAP target
   ([SAP pricing deck, April 2026](https://assets.dm.ux.sap.com/sap-user-groups/pdfs/260416_breaking_down_the_sap_bdc_pricing_model.pdf)).
5. **Yes, a CPG company needs a data dictionary, but it is four artefacts, not one**: a business glossary
   (words), a data dictionary/catalog (columns), an ontology or canonical entity model (things and their
   relationships, with identifiers), and metrics-as-code (calculations that run). Most failures come from
   building one and assuming it covers the others.
6. **Identifiers matter more than definitions.** In CPG the hard translation work is crosswalks: GTIN to
   retailer item number to SAP material number, GLN or retailer store ID to ship-to/sold-to, retailer
   taxonomy to the enterprise category hierarchy, and retail week to fiscal calendar
   ([DS Stream, Nov 2026](https://www.dsstream.com/post/category-management-data-engineering-cpg)). That is
   entity resolution and MDM work, which is why SAP bought Reltio in May 2026
   ([SAP](https://news.sap.com/2026/05/sap-completes-acquisition-of-reltio/)).
7. **LLMs now draft the first version of definitions everywhere** (Snowflake Semantic View Autopilot,
   Databricks AI comments, dbt Wizard/Copilot, Atlan context agents, Fabric ontology agent), but every
   vendor's own documentation insists on human review, and none publishes accuracy figures for the drafts.
8. **Glossaries take years, not months, to reach enterprise coverage.** Named examples: one Atlan customer
   reached 400 terms in under two years ([Atlan](https://atlan.com/customers/hr-services-leader-atlan/));
   NetApp folded more than 50 data dictionaries into one glossary run by 160+ stewards over a programme that
   started in 2010 ([Collibra case study](https://www.casestudies.com/company/collibra/case-study/how-netapps-business-led-approach-to-data-governance-has-stood-the-test-of-time)).
   Thoughtworks' advice is to start with one domain
   ([Thoughtworks Radar, April 2026](https://www.thoughtworks.com/radar/techniques/semantic-layer)).

---

## 1. The components of a context / semantic layer architecture

The table is the map; the sections after it give each component's job, inputs, outputs and example
products, with sources.

| # | Component | What it does | Inputs | Outputs | Example products |
|---|---|---|---|---|---|
| 1 | Source systems | Systems of record | Business events | Tables, files, streams, documents | SAP S/4HANA/ECC, Salesforce, Oracle, Workday, retailer POS, Nielsen/Circana, Google/Meta ads, AVEVA PI, MES, PLM, WMS/TMS |
| 2 | Ingestion / CDC / connectors | Move or replicate data, or register it | Source APIs, logs, extracts | Raw/landing tables (bronze) | Fabric Mirroring, Databricks Lakeflow Connect, Google Cortex SAP/marketing pipelines, SAP Datasphere replication flows, AVEVA CONNECT |
| 3 | Storage / access | Hold data (lakehouse/warehouse) or reach it in place | Ingested data or remote sources | Queryable tables | OneLake, Delta/Iceberg lakehouses, BigQuery, Snowflake; federation (Denodo, Starburst/Trino, Lakehouse Federation, Dremio); zero-copy shares (Delta Sharing/OpenSharing, Snowflake shares, SAP BDC Connect, Salesforce Zero Copy) |
| 4 | Metadata catalog / data dictionary | Inventory of tables, columns, owners, classifications | Crawled metadata, query logs | Searchable asset graph, descriptions | Unity Catalog, Snowflake Horizon, Purview Unified Catalog, Google Knowledge Catalog/Dataplex, Atlan, Collibra, Alation, DataHub |
| 5 | Business glossary | Agreed meaning of business words | Workshops, existing definitions, LLM drafts | Approved terms linked to assets | Purview glossary, Collibra, Atlan, Alation |
| 6 | Ontology / knowledge graph | Typed entities, relationships, rules, actions bound to data | Glossary, models, source schemas | Entity graph agents can traverse and act on | Palantir Ontology, Fabric IQ ontology, SAP Knowledge Graph, Neo4j, Stardog, Cognite Data Fusion |
| 7 | Metrics / semantic engine | Executable definitions of measures, dimensions, joins | Modelled tables, metric code | Correct SQL/DAX/MDX at query time | dbt Semantic Layer/MetricFlow, Cube, AtScale, LookML, Power BI semantic models, Snowflake semantic views, Databricks metric views |
| 8 | Entity resolution / MDM | One ID per customer, product, supplier, location | Records from many systems | Match IDs, golden records, crosswalks | Reltio (SAP), Informatica, Stibo, Profisee, SAP MDG, AWS Entity Resolution |
| 9 | Vector / retrieval index | Find relevant text, documents, examples | Documents, descriptions, past queries | Ranked passages for prompts | Snowflake Cortex Search, Databricks Vector Search, Azure AI Search, Glean |
| 10 | Policy / access control | Who may see which rows/columns/actions | Identities, tags, policies | Filtered results | Snowflake row access policies, Unity Catalog ABAC, Fabric/OneLake RLS/OLS/CLS, Power BI RLS, Cube access policies |
| 11 | Lineage | Where a number came from | Job runs, SQL parsing | Column-level lineage graph | OpenLineage/Marquez, Purview, Unity Catalog, DataHub |
| 12 | Caching / aggregates | Make governed queries fast and cheap | Query patterns | Pre-computed rollups | Cube Store pre-aggregations, AtScale aggregates, Databricks metric view materialisation, dbt SL caching |
| 13 | Interfaces | How consumers ask | Requests | Results | SQL/JDBC/ODBC/ADBC, REST, GraphQL, MDX/DAX/XMLA, MCP |
| 14 | Consumers | Use the answers | Results, context | Decisions, actions | BI (Power BI, Tableau, Looker), Excel, apps, AI agents and copilots (Genie, Cortex Agents, Fabric data agents, Joule, Agentforce, Claude/ChatGPT via MCP) |

### 1.1 Source systems

For a CPG company the brief lists SAP S/4HANA and ECC, Salesforce, Oracle, Workday, retailer data (Walmart
Luminate/Scintilla), Nielsen/Circana, Google/Meta ads, historians such as AVEVA PI, PLM, and WMS/TMS. What
matters architecturally is that each class of source arrives differently:

- **ERP (SAP).** Arrives by replication, but the extraction route is constrained by licence (section 3.4).
- **CRM (Salesforce).** Can be replicated, federated (Databricks lists "Salesforce Data 360" under both query
  and catalog federation, [Databricks](https://docs.databricks.com/aws/en/query-federation/)) or shared
  zero-copy ([Snowflake docs](https://docs.snowflake.com/en/user-guide/data-integration/zero-copy/about-salesforce-datacloud)).
- **Retailer data.** Arrives through the retailer's own platform and terms. From 1 May 2026 Walmart requires
  suppliers to hold a Scintilla subscription to get Walmart data through syndicated partners, and existing
  approved suppliers must be Scintilla Charter subscribers by 31 January 2027
  ([Walmart Data Ventures](https://walmartdataventures.com/insights/update-to-walmart-named-data-policy)).
  Walmart's Scintilla Media Data Feed (28 April 2026) is an API exposing about 500 operational and retail data
  elements that advertisers can grant to agencies and ad-tech partners
  ([Walmart Connect](https://www.walmartconnect.com/resources/articles/2026/introducing-scintilla-media-data-feed)).
- **Aggregated retailer POS.** Crisp harmonises retailer POS and inventory data "using a standard model" and
  delivers it through Databricks Marketplace on Delta Sharing; it had over 40 retail partners in 2023
  ([Databricks, Oct 2023](https://databricks.com/blog/how-crisp-and-databricks-enable-retail-supplier-collaboration-through-shared-sales-and-inventory-data)).
  In February 2026 Databricks described Crisp as connecting "4,000+ CPG brands with 40+ retailers and
  distributors" ([Databricks, Feb 2026](https://www.databricks.com/blog/collaboration-advantage-how-modern-retailers-and-cpg-brands-win-together)).
- **Syndicated data.** Circana made its POS and panel data available through Snowflake sharing in the US and
  EMEA in November 2023, claiming it removed "the time-consuming and costly data transformation and loading
  process" ([Circana](https://circana.com/intelligence/press-releases/2023/circana-expands-point-of-sale-and-panel-data-access-for-clients-meeting-evolving-technology-needs-with-snowflake-integration)).
  I could not find a primary NIQ announcement of an equivalent share.
- **Media platforms.** Google Cortex Framework ships prebuilt pipelines for Google Ads, CM360, TikTok, Meta,
  LiveRamp, YouTube (with DV360), GA4 and Salesforce Marketing Cloud, alongside SAP ECC/S/4, Salesforce Sales
  Cloud and Oracle EBS ([Cortex Data Foundation README](https://github.com/GoogleCloudPlatform/cortex-data-foundation/blob/main/README.md)).
- **OT/historians.** AVEVA CONNECT "streams AVEVA PI System data directly into Databricks as trusted, usable
  open formats" and "preserves native asset hierarchies" ([AVEVA](https://discover.aveva.com/connect-databricks/)).

### 1.2 Ingestion, CDC and connectors

Three patterns dominate:

- **Change data capture into the platform.** Fabric Mirroring takes a snapshot and then uses the source's CDC
  to replicate inserts, updates and deletes, publishing changes "as fast as every 15 seconds"; replication
  compute is free and you get one free TB of mirroring storage per capacity unit (an F64 gets 64 TB)
  ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/mirroring/overview)). Note that Fabric's SAP
  mirroring source is listed with an "SAP Datasphere" tutorial, i.e. it goes through SAP's own product
  (same page). Databricks Lakeflow Connect provides managed CDC connectors for Salesforce, HubSpot, Jira,
  Workday, MySQL, PostgreSQL and SQL Server ([Databricks](https://docs.databricks.com/aws/en/ingestion/lakeflow-connect/)).
- **Prebuilt industry pipelines.** Google Cortex lands CDC logs or full batch extracts in an immutable BigQuery
  raw layer, conforms them in a "data foundation layer" and applies business rules in a "data product layer";
  the build compiles `config.yaml` and `table_settings.yaml` into Dataform code
  ([Google Cloud](https://docs.cloud.google.com/cortex/docs/overview)).
- **Metadata registration instead of movement.** Fabric "metadata mirroring" synchronises only catalog names,
  schemas and tables and uses OneLake shortcuts to reach the data in place
  ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/mirroring/overview)).

Inputs: source APIs, database logs, files. Outputs: raw (bronze) tables in Delta/Parquet/Iceberg, or catalog
entries pointing at remote data.

### 1.3 Storage versus virtualisation versus zero-copy sharing

Covered in depth in section 3. In component terms:

- **Store**: a lakehouse or warehouse (OneLake, Delta/Iceberg on object storage, BigQuery, Snowflake) organised
  in medallion layers: Bronze (raw), Silver (validated), Gold (business-ready)
  ([Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end)).
- **Virtualise/federate**: a query engine pushes "filters, joins, and calculations to the systems best suited
  to execute them" ([Denodo](https://www.denodo.com/en/data-virtualization/overview)); Starburst claims answers
  "from 50+ data sources in one query ... without building a single pipeline" ([Starburst, vendor claim](https://starburst.io/)).
- **Zero-copy share**: the provider keeps the data and grants read access through a protocol. Databricks'
  OpenSharing (the Delta Sharing protocol) "does not require data replication" within a region
  ([Databricks](https://docs.databricks.com/aws/en/delta-sharing/)); SAP BDC exposes data products to
  Databricks as "live, zero-copy access" mounted into Unity Catalog, with table and column comments synced
  across ([Databricks](https://docs.databricks.com/aws/delta-sharing/sap-bdc)).

### 1.4 Metadata catalog

Inventory of what exists, who owns it, how sensitive it is and how it is used. Purview's Unified Catalog and
Data Map consolidate metadata and lineage from scanned sources and auto-apply classification and sensitivity
labels ([Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end)).
Atlan exposes its catalog to agents through a remote MCP server; its own build guide is: pick one domain and
5-10 questions, connect the source, run "Description", "README" and "SQL Intelligence" agents to fill gaps,
have the domain owner certify the high-traffic assets, then test the questions through an MCP client
([Atlan docs](https://docs.atlan.com/agents/how-tos/build-a-context-layer)). DataHub argues semantics must be
generated continuously "from usage signals such as query logs, dbt semantic models, and BI patterns" and
reviewed by experts, with column-level lineage captured automatically
([DataHub, June 2026](https://datahub.com/?p=15016)).

Inputs: crawled schemas, query history, BI metadata, lineage events. Outputs: searchable assets with
descriptions, owners, tags, certification status.

### 1.5 Business glossary

Agreed meaning of business words ("net revenue", "case fill rate", "active outlet"), each linked to the assets
that implement it. Collibra's own lifecycle for glossary content is Import (bulk-load "thousands of assets in one
pass" as candidates) -> Improve (domain stewards refine; approval workflow) -> Publish -> Use, with issues looping
back ([Collibra University](https://cdn-university.collibra.com/wp-content/COOK/Business-Glossary-Case_360780.html)).
Purview recommends maintaining glossary terms "with the specific business terminology that users need to
understand dataset semantics" ([Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end)).
Detail on build times is in section 4.6.

### 1.6 Ontology / knowledge graph

An ontology adds typed entities, relationships, rules and (in the Palantir case) actions on top of the
glossary, and binds them to data.

- **Palantir Ontology**: object types (≈ datasets), properties (≈ columns), link types (≈ joins), action types
  (sets of changes users can apply, with side effects), functions (code-based logic), interfaces
  (polymorphism) and roles (permissions), described as "the digital twin of an organization"
  ([Palantir core concepts](https://www.palantir.com/docs/foundry/ontology/core-concepts/)); it splits into
  "semantic" elements (objects, links) and "kinetic" elements (actions, functions, dynamic security)
  ([Palantir overview](https://www.palantir.com/docs/foundry/ontology/overview/)).
- **Microsoft Fabric IQ ontology (preview)**: entity types, properties, relationships, metrics (from Power BI
  DAX measures, which the semantic model continues to own), natural-language rules, namespaces and inheritance;
  can be generated from Power BI semantic models; binds to lakehouses, warehouses, eventhouses, mirrored
  databases and OneLake shortcuts "without requiring the ontology to become a separate data store"; imports
  RDF/Turtle/OWL; respects source RLS/OLS/CLS; graph materialisation is optional
  ([Microsoft Learn, updated Oct 2026](https://learn.microsoft.com/en-us/fabric/iq/ontology/overview)).
- **SAP**: SAP describes its Business Data Cloud knowledge graph as connecting "your data, metadata, and
  business processes" ([SAP, Feb 2025](https://news.sap.com/2025/02/sap-databricks-open-bold-new-era-data-ai/)).
  At TechEd (October 2026) SAP said new Knowledge Graph capabilities to bring in "customer-specific data from SAP
  and non-SAP sources" and a BDC **Ontology Manager** beta are planned for Q1 2027
  ([ERP Today, 27 Oct 2026](https://erp.today/sap-teched-2026-whats-rolling-out-and-whats-planned-through-2027/)).
  SAP has said its Apache Polaris-based catalog (from the Dremio deal) "will form the foundation of the SAP
  Knowledge Graph" ([SAP, May 2026](https://news.sap.com/2026/05/sap-to-acquire-dremio/)).
- **RDF/virtual graph tools**: Stardog maps relational sources to RDF (SMS or R2RML) and rewrites SPARQL into
  native SQL at query time, or materialises the triples; the docs note materialised graphs are faster but must
  be re-imported to see changes ([Stardog](https://docs.stardog.com/virtual-graphs/)).
- **Industrial graphs**: Cognite builds an "industrial knowledge graph" through "a combination of machine
  learning, rules engines, and subject-matter expertise" over time series, documents and 3D/engineering data
  ([Cognite](https://www.cognite.com/en/industrial-knowledge-graph)).
- **Document graphs (GraphRAG)**: Microsoft's GraphRAG extracts entities, relationships and claims from text
  chunks, clusters the graph with Leiden, summarises each community, and offers global, local, DRIFT and basic
  search modes ([Microsoft GraphRAG](https://microsoft.github.io/graphrag/)).

Inputs: glossary, existing semantic models, source schemas, documents. Outputs: an entity graph with bindings
to data, which agents can traverse, query and (in some products) act on.

### 1.7 Metrics / semantic engine

The executable core: definitions of measures, dimensions and join paths that compile to correct SQL (or DAX/MDX)
at query time.

- **dbt Semantic Layer**: MetricFlow and the semantic interface spec are Apache 2.0; the service layer, gateway
  and the JDBC/GraphQL (and ADBC) APIs are proprietary to dbt Cloud
  ([dbt architecture](https://docs.getdbt.com/docs/use-dbt-semantic-layer/sl-architecture)). AI tools connect
  through the dbt MCP server "so their answers use your governed metrics instead of guessing at raw tables"
  ([dbt](https://docs.getdbt.com/docs/use-dbt-semantic-layer/dbt-sl)).
- **Cube**: cubes (entities with measures, dimensions, joins) and views, written in YAML or JavaScript under
  version control; pre-aggregations in Cube Store; a Postgres-compatible SQL API with a `MEASURE` function,
  REST, GraphQL, a Meta API for introspection, and an MCP server; access policies defined in code and applied
  to every consumer ([Cube docs](https://docs.cube.dev/docs/introduction)).
- **AtScale**: "BI tools speak to AtScale through SQL and MDX", AI tools through MCP, data scientists through
  Python and REST ([AtScale, July 2025](https://www.atscale.com/blog/enterprise-ai-mcp-semantic-layer/));
  reaches Power BI and Excel through XMLA; its engine runs inside Snowflake semantic views in private preview
  from June 2026 ([Atlan comparison, Sept 2026](https://atlan.com/know/ai-agent/semantic-layer/atscale-vs-context-layer/)).
- **Looker/LookML**: views, explores, dimensions and measures in Git; "The Looker SQL generator translates
  LookML into SQL" ([Google Cloud](https://docs.cloud.google.com/looker/docs/what-is-lookml)). In April 2026
  Google announced a managed, Looker-native MCP server in preview
  ([Google Cloud, Next '26](https://cloud.google.com/blog/products/business-intelligence/looker-updates-for-agentic-bi-at-next26)).
- **Power BI semantic models**: served by the Analysis Services engine over XMLA; read-only by default, so Excel,
  SSMS (DAX, MDX, XMLA queries), Tabular Editor, DAX Studio and third-party tools can query them, with RLS
  honoured ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/enterprise/powerbi/service-premium-connect-tools)).
- **Snowflake semantic views**: schema-level objects with logical tables, relationships, facts, dimensions and
  metrics, used by Cortex Analyst and Cortex Agents; created with SQL, Semantic Studio or "Semantic View
  Autopilot", which accepts YAML, Tableau or Power BI files
  ([Snowflake](https://docs.snowflake.com/en/user-guide/views-semantic/overview)).
- **Databricks metric views**: Unity Catalog objects that separate measures from dimensions, support star and
  snowflake joins, add "synonyms, display names, and formatting rules to improve agent accuracy", and can
  materialise aggregations that the engine rewrites queries to use; queried from SQL, notebooks, dashboards,
  Genie and external BI ([Databricks](https://docs.databricks.com/aws/en/metric-views/)).
- **The interchange standard**: Open Semantic Interchange (OSI), renamed **Apache Ossie (incubating)** on
  10 July 2026 to avoid acronym confusion; the coalition grew "from 17 launch partners to more than 50
  organizations" and has three working groups (Metric Language, Catalog, Ontology)
  ([Apache Ossie](https://ossie.apache.org/updates/ossie-enters-apache-incubator/)). The core spec defines a
  semantic model with datasets, fields, dimensions, metrics, relationships, an `ai_context` construct for
  synonyms and instructions, and vendor `nonportable_extensions`; first release 0.1.1 on 11 December 2025, with
  0.3.0.dev0 the current draft ([Ossie spec](https://github.com/open-semantic-interchange/OSI/blob/main/core-spec/spec.md)).
  dbt positions OSI as the interchange format and MetricFlow as the execution engine
  ([dbt, Jan 2026](https://courses.getdbt.com/blog/the-osi-spec-updates)). Reference converters exist for dbt,
  GoodData, Polaris and Salesforce ([GitHub repo](https://github.com/open-semantic-interchange/OSI)).

Inputs: modelled (Gold) tables and metric code. Outputs: correct, permission-filtered result sets through
SQL/JDBC, REST/GraphQL, MDX/DAX or MCP.

### 1.8 Entity resolution and MDM

Produces one identifier per real-world thing and the crosswalks between system IDs. AWS Entity Resolution offers
rule-based matching, a pre-configured ML model that returns match groups with a 0.0-1.0 confidence score, and
provider-led matching (licensed third-party data); it explicitly covers tracking "products that use different
codes (for example, SKU, UPC) across your stores" and offers a synchronous `GetMatchId` lookup
([AWS docs](https://docs.aws.amazon.com/entityresolution/latest/userguide/what-is-service.html)). SAP completed
its acquisition of the MDM vendor Reltio on 7 May 2026, saying it "helps customers make their SAP and non-SAP
enterprise data AI-ready" ([SAP](https://news.sap.com/2026/05/sap-completes-acquisition-of-reltio/)); BARC
reports Reltio's FY26 ARR as $185M and calls it "the layer that determines whether its entire AI portfolio
delivers", while warning that MDM "depends on clean processes, clear data ownership, and disciplined
stewardship" ([BARC](https://barc.com/barc-perspective-sap-acquires-reltio/)). SAP says the SAP Reltio
solution will bring "multidomain master data management" to BDC
([ERP Today](https://erp.today/sap-teched-2026-whats-rolling-out-and-whats-planned-through-2027/)).

Inputs: customer/product/supplier/location records from many systems. Outputs: match IDs, golden records,
cross-reference tables consumed by the ontology and the semantic layer.

### 1.9 Vector / retrieval index

Retrieves documents, descriptions, policies and example queries for the prompt. Snowflake Cortex Search
combines vector search, keyword search and semantic reranking, has a `TARGET_LAG` freshness setting, serves as
the retrieval layer for Cortex Agents, and searches "with owner's rights"
([Snowflake](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-search/cortex-search-overview)).
Glean's view is that agents need hybrid retrieval,
a knowledge graph and "permissions enforced at retrieval", and that MCP or federation "do not replace indexing,
ranking, freshness, or permissions-aware retrieval"
([Glean, Sept 2026](https://www.glean.com/blog/from-enterprise-search-to-enterprise-context-what-ai-agents-actually-need)).

### 1.10 Policy and access control

The layer that must run before an agent sees a row. Snowflake row access policies create "a dynamic secure view"
at query time and are evaluated before masking policies
([Snowflake](https://docs.snowflake.com/en/user-guide/security-row-intro)). Unity Catalog ABAC attaches policies
using governed tags at metastore, catalog, schema or table level, so "that policy takes effect automatically"
for matching objects; metastore-level policies, view support and DENY policies were still Beta
([Databricks](https://docs.databricks.com/aws/en/data-governance/unity-catalog/abac/)). Fabric ontology
authoring and querying "respect access to bound data, including OneLake security and source-enforced row-level
security" ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/ontology/overview)). Cube's design
choice is to enforce policies inside the semantic layer: "Define the rule once; it's enforced everywhere"
([Cube docs](https://docs.cube.dev/docs/introduction)). MCP itself does not enforce anything; the spec says
implementors "SHOULD" build consent and access controls and that tool descriptions "should be considered
untrusted, unless obtained from a trusted server"
([MCP spec 2025-11-25](https://modelcontextprotocol.io/specification/2025-11-25)).

### 1.11 Lineage

OpenLineage defines datasets, jobs and runs plus extensible "facets", with integrations for Airflow, Spark,
Flink, dbt, Trino and others; Marquez is the reference implementation, and the project is a Graduate project
of LF AI & Data ([OpenLineage](https://openlineage.io/docs/)). DataHub argues lineage must be automatic and
column-level, because table-level lineage "can't show where a specific reported number came from"
([DataHub](https://datahub.com/?p=15016)). Purview ingests Fabric and Power BI lineage automatically on scan
([Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end)).

### 1.12 Caching and aggregates

Cube declares rollups in the model, refreshes them in the background into Cube Store, and routes matching
queries to them ([Cube docs](https://docs.cube.dev/docs/introduction)). Databricks metric view materialisation
can "Pre-compute and incrementally refresh aggregations" with automatic query rewrite
([Databricks](https://docs.databricks.com/aws/en/metric-views/)). dbt offers "result caching and declarative
caching" and scheduled exports ([dbt](https://docs.getdbt.com/docs/use-dbt-semantic-layer/dbt-sl)). Caching is
also the practical answer to federation latency (section 3).

### 1.13 Interfaces

- **SQL/JDBC/ODBC/ADBC**: dbt (JDBC, ADBC), Cube (Postgres wire protocol), Fabric SQL endpoints (ODBC),
  Looker Open SQL Interface.
- **REST/GraphQL**: Cube REST and GraphQL; dbt GraphQL; Fabric API for GraphQL "through a single, flexible API
  endpoint" ([Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end)).
- **MDX/DAX/XMLA**: Power BI semantic models and AtScale; this is how Excel pivot tables stay on governed
  definitions ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/enterprise/powerbi/service-premium-connect-tools)).
- **MCP**: JSON-RPC 2.0 between hosts, clients and servers; servers expose resources, prompts and tools;
  clients can offer sampling, roots and elicitation ([MCP spec](https://modelcontextprotocol.io/specification/2025-11-25)).
  Every semantic and catalog vendor reviewed here now ships an MCP server (dbt, Cube, AtScale, Looker, Atlan and
  Starburst, per sources above).

### 1.14 Consumers

BI tools, Excel, operational apps and agents. The Azure reference architecture shows Fabric data agents
translating natural language into "SQL, DAX, or KQL" and being plugged into Foundry or Copilot Studio as
domain experts in multi-agent systems ([Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end)).
SAP describes its context layer for Joule agents as "a single semantical data layer" combining BDC, knowledge
graphs and the new SAP Domain Models, which encode SAP process logic such as S/4HANA Finance posting rules
([SAPinsider, May 2026](https://sapinsider.org/blogs/sap-sapphire-2026-how-sap-business-ai-platform-consolidates-sap-btp-sap-business-data-cloud-and-sap-business-ai/)).

### 1.15 Synthesis: three kinds of context (my framing, built on sources)

| Kind | What it is | Components | Failure if missing |
|---|---|---|---|
| Executable | Definitions that compute answers and enforce policy | Metric engine, policy, caching | Agent writes its own SQL; plausible wrong numbers |
| Descriptive | Meaning, relationships, provenance | Catalog, glossary, ontology, lineage, retrieval index | Agent picks the wrong table or misreads a term |
| Identity | Which records are the same thing | ER/MDM, crosswalks, standard identifiers (GTIN, GLN) | Numbers cannot be joined across SAP, retailer and media data |

The first two come from Cube's executable/descriptive split
([Cube](https://cube.dev/blog/the-context-layer-needs-a-semantic-layer)). I add identity as a separate kind
because the CPG translation problem (section 4) is mostly an identity problem, and it is invisible in most
context-layer writing, which focuses on definitions. a16z do list "canonical entities, identity resolution"
in their superset ([a16z, March 2026](https://a16z.com/your-data-agents-need-context/)).

---

## 2. How they build it

### 2.1 Four modelling starting points

| Approach | Starts from | Typical products | Strength | Weakness |
|---|---|---|---|---|
| Metrics-first | KPIs and their calculations | dbt SL, Cube, AtScale, LookML, Power BI, Snowflake semantic views, Databricks metric views | Correct numbers, testable, fast to value for BI and text-to-SQL | Thin on entities, documents, processes; one model per tool unless OSI/Ossie matures |
| Ontology-first | Business objects and their relationships/actions | Palantir, Fabric IQ ontology, SAP Knowledge Graph/Ontology Manager | Cross-system operational use, agents that act | Heavier modelling; still needs metrics (Fabric borrows them from Power BI) |
| Catalog-first | Inventory and glossary | Atlan, Collibra, Alation, DataHub, Purview | Broad coverage, ownership, lineage | Descriptive only; does not compute answers |
| Graph/retrieval-first | Documents, people, activity | Glean, GraphRAG, Neo4j | Unstructured knowledge, tribal knowledge | Weak at governed numbers |

Sources for the product placements are in section 1. In practice the platforms are converging: Microsoft
generates its ontology from Power BI semantic models
([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/ontology/overview)); Cube calls its data model
"the knowledge graph the platform — and any AI agent — uses" ([Cube docs](https://docs.cube.dev/docs/introduction));
Looker now turns metadata "into a semantic graph" through Knowledge Catalog integration
([Google Cloud](https://cloud.google.com/blog/products/business-intelligence/looker-updates-for-agentic-bi-at-next26));
and Ossie has an Ontology working group ([Apache Ossie](https://ossie.apache.org/updates/ossie-enters-apache-incubator/)).

### 2.2 The build steps most sources agree on

a16z give the cleanest public sequence ([a16z](https://a16z.com/your-data-agents-need-context/)):

1. **Access** the warehouse, operational and unstructured sources.
2. **Automated context construction** with LLMs, using high-signal inputs: query history for common tables and
   joins, dbt/LookML for metric definitions.
3. **Human refinement**, because "some of the most important context is implicit, conditional, and historically
   contingent".
4. **Agent connection** via API or MCP.
5. **Self-updating flows** as schemas, requirements and agent errors change.

Atlan's and Thoughtworks' advice adds a scoping rule: start with one domain and a short list of real questions
([Atlan](https://docs.atlan.com/agents/how-tos/build-a-context-layer);
[Thoughtworks](https://www.thoughtworks.com/radar/techniques/semantic-layer)). Thoughtworks names the main cost
as "upfront data modeling investment" and warns that broad rollouts leave legacy reports running in parallel,
"reintroducing inconsistent definitions".

### 2.3 LLM bootstrapping: what each vendor actually automates

| Vendor | Feature | Inputs | Generates | Stated limits |
|---|---|---|---|---|
| Snowflake | Semantic View Autopilot | Tables, business description, example SQL (CSV), Tableau/Power BI/YAML files, query history | Relationships, keys, verified queries, AI table/column descriptions | Extracted items presented for review; inline diffs to accept or reject ([Snowflake](https://docs.snowflake.com/en/user-guide/views-semantic/autopilot)) |
| Databricks | AI-generated comments | Table schema and column names | Table and column descriptions | "AI models are not always accurate and comments must be reviewed"; not for PII classification ([Databricks](https://docs.databricks.com/aws/en/comments/ai-comments)) |
| dbt | Wizard (preview) / Copilot | Project lineage, docs, tests, semantic definitions, prompt | Documentation, semantic models, tests, metrics | Changes shown as diffs; metered per token from 1 Sept 2026 ([dbt](https://docs.getdbt.com/docs/cloud/dbt-copilot)) |
| Atlan | Context agents | Crawled metadata, query history | Descriptions, READMEs, SQL insights; fills gaps only | Human certification step ([Atlan](https://docs.atlan.com/agents/how-tos/build-a-context-layer)) |
| Microsoft | Fabric ontology agent | Connected Fabric sources | Ontology definitions and bindings | "proposal-first model" with review ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/ontology/overview)) |
| Google | Cortex agentic tooling | SAP DDIC schemas | Data modules, validation | Packaged skills for AI coding assistants ([Google Cloud](https://docs.cloud.google.com/cortex/docs/overview)) |

Snowflake's marketing claims deployment "in minutes instead of weeks"; I found no measured benchmark behind it
(search result only; the Snowflake blog returned 403, so I do not rely on it). In schema matching research,
Magneto (NYU; arXiv, revised June 2025) uses small models for candidate retrieval and LLMs for reranking because
LLMs "often incur high computational costs" and hit context limits
([arXiv 2412.08194](https://arxiv.org/abs/2412.08194)). One CPG data foundation project (unnamed global CPG in
200+ countries) added a "GenAI-assisted modeling accelerator" to suggest tables and columns, and reports a 10%
increase in data-modelling efficiency from a modelling portal with steward approval workflows (SI claim)
([Tiger Analytics](https://www.tigeranalytics.com/perspectives/case-study/data-foundation-modernization-for-cpg/)).

### 2.4 Team structure

The pattern across sources is federated: domain owners and stewards own definitions, a central platform team owns
the tooling and global standards. Data mesh's "federated computational governance" makes identifiers a global
decision ("how to identify a 'podcast listener' is a global concern") while domains keep their own models, and
gives each domain a data product owner accountable for quality and time-to-use
([Dehghani, martinfowler.com, Dec 2020; older but still the reference](https://martinfowler.com/articles/data-mesh-principles.html)).
AWS's CPG data-products guidance implements the same split: producer domains create data products and register
them in a central governance account, with Lake Formation enforcing access for consumer domains
([AWS](https://aws.amazon.com/solutions/guidance/cpg-data-products-on-aws/)). Section 4.5 covers ownership of
the dictionary specifically.

---

## 3. Store in one place versus connect in place

### 3.1 The four access modes

| Mode | How it works | Examples | Latency | Freshness | Who pays compute | Governance |
|---|---|---|---|---|---|---|
| Copy (ETL/ELT, CDC, mirroring) | Replicate into your lakehouse | Fabric Mirroring, Lakeflow Connect, Cortex pipelines | Low at query time | Seconds to hours behind | You (ingest + store + query) | One place to govern, but a second copy to secure |
| Federate / virtualise | Push query to source at run time | Denodo, Starburst/Trino, Databricks query federation, Dremio | Depends on source and network | Live | Source and engine both | Policy at the virtual layer; source still enforces its own |
| Catalog federation / shortcuts | Read source's files directly in object storage | Databricks catalog federation, OneLake shortcuts, Fabric metadata mirroring | Near-native if same region | Live | Your engine | Depends on open formats and catalog interoperability |
| Zero-copy share | Provider grants read access to its tables | Delta Sharing/OpenSharing, Snowflake shares, SAP BDC Connect, Salesforce Zero Copy | Near-native in region | Live | Recipient (plus fees) | Provider controls the share; recipient governs use |

Databricks states the trade-off directly: query federation pushes work to the source over JDBC and suits ad hoc
reporting and proofs of concept; catalog federation reads foreign tables in object storage and suits migration or
long-term hybrid; both are read-only; and "Databricks recommends Lakeflow Connect if performance on higher data
volumes and lower latency are priorities" ([Databricks](https://docs.databricks.com/aws/en/query-federation/)).
Stardog says the same about virtual graphs: materialised graphs perform better but go stale until re-imported
([Stardog](https://docs.stardog.com/virtual-graphs/)).

### 3.2 Trade-offs

- **Latency and load.** Federation runs on the source's compute; heavy agent traffic against an ERP is the classic
  risk. Caching and aggregates (section 1.12) are the mitigation.
- **Freshness.** Federation and shares are live; CDC is near-live (Fabric: changes "as fast as every 15 seconds",
  [Microsoft Learn](https://learn.microsoft.com/en-us/fabric/mirroring/overview)); batch copies lag.
- **Cost and egress.** Within a region, sharing is free of egress on Databricks and Snowflake; across regions or
  clouds it is not. Snowflake: "Data transfers within the same region are free", cross-region and cross-cloud
  egress is charged per byte ([Snowflake](https://docs.snowflake.com/en/user-guide/cost-understanding-data-transfer)).
  Databricks: cloud vendors "may charge data egress fees when you share data across clouds or regions", and it
  recommends Cloudflare R2, "which incurs no egress fees" ([Databricks](https://docs.databricks.com/aws/en/delta-sharing/)).
  For a multi-country CPG with regional data residency, cross-region sharing fees are a design input, not a footnote.
- **"Zero-copy" has a price list.** SAP BDC Connect for Databricks/Snowflake: 0.185 CU per GB of inter-region
  transfer and 0.055 CU per 2,500 processing requests; SAP Databricks internet egress from 0.160-0.267 CU per GB
  (standard rate) ([SAP pricing deck, April 2026](https://assets.dm.ux.sap.com/sap-user-groups/pdfs/260416_breaking_down_the_sap_bdc_pricing_model.pdf)).
  Mindset Consulting's guidance to SAP buyers: BDC Connect needs a BDC subscription plus CU charges "on top of the
  existing Snowflake contract ... plan for BDC Connect to add to your total cost of ownership, not replace it"
  ([Mindset Consulting, July 2026](https://www.mindsetconsulting.com/snowflake-databricks-and-sap-business-data-cloud/)).
- **Governance.** One copy is easier to govern than many, but a copy is also a second place to secure. Shares keep
  the provider in control. Databricks discloses to SAP certain usage information, "including your organization's
  identity", when you use the SAP BDC connector, for billing
  ([Databricks](https://docs.databricks.com/aws/delta-sharing/sap-bdc)), a detail worth putting in front of
  procurement.
- **Unstructured data.** Glean's argument is that "reaching a system is not the same as retrieving well from it":
  live MCP connections to SharePoint or Slack do not give ranking, freshness or permission-aware retrieval, so
  text needs an index ([Glean](https://www.glean.com/blog/from-enterprise-search-to-enterprise-context-what-ai-agents-actually-need)).
  This is a vendor position (Glean sells an index), but it matches how Snowflake and Microsoft build retrieval.
- **Semantics travel only partly.** BDC syncs table and column comments into Unity Catalog
  ([Databricks](https://docs.databricks.com/aws/delta-sharing/sap-bdc)), and Databricks shares can include metric
  views only in the Databricks-to-Databricks flow ([Databricks](https://docs.databricks.com/aws/en/delta-sharing/)).
  In general a share moves data and some metadata, not the full semantic model; Ossie is the attempt to fix that.

### 3.3 Who does which (from sources)

- **Copy-first, lakehouse-centred**: the Azure reference architecture makes OneLake "the home for data", mirroring
  operational databases and Dataverse into it ([Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end));
  Google Cortex lands SAP, Salesforce, Oracle EBS and marketing data in BigQuery
  ([Google Cloud](https://docs.cloud.google.com/cortex/docs/overview)); the unnamed global CPG in the Tiger
  Analytics case built Bronze/Silver/Gold layers on Delta Lake with Microsoft's CPG data model template as the
  Silver layer ([Tiger Analytics](https://www.tigeranalytics.com/perspectives/case-study/data-foundation-modernization-for-cpg/)).
- **Connect-first**: Fabric IQ ontology binds to data "without requiring the ontology to become a separate data
  store" ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/ontology/overview)); Starburst and Denodo
  sell federation as the delivery layer; SAP now promises "unified access to data without moving or copying it"
  with Dremio ([ERP Today](https://erp.today/sap-teched-2026-whats-rolling-out-and-whats-planned-through-2027/)).
- **Share-first for external data**: retailer and syndicated data increasingly arrive as shares (Crisp on Delta
  Sharing, Circana on Snowflake), and OT data via AVEVA CONNECT on Delta Sharing (sources in 1.1).

### 3.4 SAP: the licensing constraint that decides the SAP leg

SAP Note 3255746 restricts the ODP (Operational Data Provisioning) RFC modules that many third-party extractors
used. Timeline from sources:

- **2022**: note published; ODP APIs described as "unsupported and intended for internal use only".
- **2 February 2024 (v4)**: "customers and third-party applications are no longer permitted to use ODP APIs to
  access SAP ABAP sources".
- **7 July 2024**: SAP recommends SAP Datasphere for replication into third-party tools.
- **9 June 2026**: security patches block unpermitted ODP-RFC calls from non-SAP applications; a temporary revert
  option "will expire on December 2026". ([Matillion](https://docs.matillion.com/metl/docs/tech-note-sap-3255746/))
- **21 April 2026**: Version 11; self-assessment tool Note 3439624 available from 13 April 2026; affects S/4HANA,
  BW and ECC, on-premises and private cloud. The restriction is on the ODP replication API via RFC, not RFC in
  general; table/CDS extraction, BAPIs and DeltaQ remain usable, and SAP points to BDC and OData
  ([SAPinsider](https://sapinsider.org/blogs/sap-note-3255746-odp-rfc-deadline-2026/)).

Most of these sources are vendors with a commercial stake (Matillion, Theobald via SAPinsider); I could not open the
note itself (SAP login required). The commercial consequence is visible in SAP's price list: replicating out of
Datasphere to a non-SAP target needs Premium Outbound Integration blocks of 20 GB, priced at 500 CU each for the
first 10 blocks, 350 for the next 15, 200 for the next 25, 100 for the next 50 and 35 thereafter
([SAP pricing deck](https://assets.dm.ux.sap.com/sap-user-groups/pdfs/260416_breaking_down_the_sap_bdc_pricing_model.pdf)),
and a replication flow to a non-SAP target "cannot be started" without them
([SAP KBA 3456481](https://userapps.support.sap.com/sap/support/knowledge/en/3456481)). The route SAP prefers is
data products shared zero-copy from BDC: to Databricks (embedded SAP Databricks or BDC Connect) or Snowflake (SAP
Snowflake or BDC Connect) ([Mindset Consulting](https://www.mindsetconsulting.com/snowflake-databricks-and-sap-business-data-cloud/)).
Microsoft's Fabric mirroring source for SAP is likewise documented through SAP Datasphere
([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/mirroring/overview)).

### 3.5 The hybrid reality (my synthesis)

For a Unilever- or Nestle-scale CPG, the realistic pattern is:

1. **Copy** high-volume, join-heavy, history-heavy data into one lakehouse per region (ERP history via SAP's
   permitted route, retailer POS, syndicated data, media spend).
2. **Share** data owned by others: SAP BDC data products, Crisp/retailer feeds, Circana/NIQ, AVEVA CONNECT.
3. **Federate** long-tail and operational systems where freshness matters and volume is small (plant MES status,
   TMS shipment status, a regional CRM).
4. **Index** unstructured knowledge (specs, contracts, SOPs, trade terms, promotion briefs) for retrieval.
5. **Put one semantic/ontology layer over all four**, so the agent and the BI tool ask the same question the same
   way, regardless of where the bytes sit.

Rules of thumb I would give a client, derived from the sources above: copy when the same data is joined across
domains more than a few times a day or needs history; share when the data's owner is outside your firm or outside
your platform; federate when the data changes faster than you could replicate it and queries are selective;
always check region boundaries before you assume a share is free.

---

## 4. The data dictionary question

### 4.1 Four artefacts that get called "the data dictionary"

| Artefact | Answers | Grain | Owner (typical) | Machine-executable? | Examples |
|---|---|---|---|---|---|
| Business glossary | "What do we mean by net revenue?" | Business term | Domain steward / business owner | No | Collibra, Purview glossary, Atlan |
| Data dictionary / catalog | "What is column `NETWR` in table `VBAP`?" | Column/table | Data owner / platform team | Partly (metadata) | Unity Catalog, Horizon, Purview Data Map, DataHub |
| Ontology / canonical model | "What is a Customer, how does it relate to Ship-to, Outlet, Order?" | Entity and relationship | Enterprise architecture / CDO office + domains | Partly (bindings, actions) | Palantir Ontology, Fabric IQ ontology, SAP One Domain Model, Microsoft CDM, ISA-95 |
| Metrics-as-code | "How exactly is net revenue calculated, at what grain, with what filters?" | Metric | Analytics engineering + finance | Yes | MetricFlow YAML, LookML, Cube YAML, Power BI DAX, Snowflake semantic views, Databricks metric views, Ossie YAML |

The point for clients: a glossary without metrics-as-code still lets two dashboards compute "net revenue"
differently; metrics-as-code without a canonical entity model still cannot join retailer sales to SAP shipments.

### 4.2 Metrics-as-code formats

- **MetricFlow YAML** (dbt): semantic models and metrics in the dbt project, Apache 2.0
  ([dbt](https://docs.getdbt.com/docs/use-dbt-semantic-layer/sl-architecture)).
- **LookML**: views/explores/dimensions/measures in Git ([Google Cloud](https://docs.cloud.google.com/looker/docs/what-is-lookml)).
- **Cube schema**: cubes and views in YAML or JavaScript ([Cube](https://docs.cube.dev/docs/introduction)).
- **Power BI semantic models (DAX)**: editable as TMSL/model metadata via XMLA read-write
  ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/enterprise/powerbi/service-premium-connect-tools)).
- **Snowflake semantic views** and **Databricks metric views**: YAML/DDL inside the warehouse (section 1.7).
- **Apache Ossie (ex-OSI)**: the interchange format. Example relationship construct from the spec:

```yaml
relationships:
  - name: orders_to_customers
    from: orders
    to: customers
    from_columns: [customer_id]
    to_columns: [id]
```

([Ossie spec](https://github.com/open-semantic-interchange/OSI/blob/main/core-spec/spec.md)). Thoughtworks
cited OSI as pointing "toward interoperability" in April 2026
([Thoughtworks](https://www.thoughtworks.com/radar/techniques/semantic-layer)). My assessment: Ossie is useful to
avoid lock-in when choosing a metric engine, but at 0.x with a draft schema it is not yet a reason to choose one.

### 4.3 Industry standard models and identifiers that matter for CPG

| Standard | What it standardises | Use in a CPG context layer | Source |
|---|---|---|---|
| GS1 GTIN | Trade item identity: GTIN-8/12/13/14; GTIN-14 indicator digit marks packaging level; every packaging configuration gets its own GTIN | The join key between SAP material, retailer item and syndicated product data | [Wikipedia](https://en.wikipedia.org/wiki/Global_Trade_Item_Number) (gs1.org returned 403) |
| GS1 GLN | 13-digit ID for parties, legal entities, functions, physical locations (factory, warehouse, store) and digital locations (EDI gateway) | Store, DC and customer-site identity across retailer and ERP data | [GS1 Canada](https://gs1ca.org/standards/global-location-number) |
| GS1 GDSN | Network of 44 certified data pools synchronising product master data, keyed on GTIN and GLN | Source of truth for product attributes shared with retailers | [Wikipedia](https://en.wikipedia.org/wiki/Global_Data_Synchronization_Network) |
| ISA-95 / IEC 62264 | Interface between Level 3 (MES/SCADA) and Level 4 (ERP); eight parts incl. object models and an alias service for mapping identifiers across domains | Canonical model for plant, line, batch, production order; Cognite ships an ISA-95/ISA-88 model pack | [ISA](https://www.isa.org/standards-and-publications/isa-standards/isa-95-standard) |
| schema.org Product | `gtin`, `gtin13`, `brand`, `sku`, `category`, `offers`, `hasGS1DigitalLink` | Product vocabulary for e-commerce and retail media content | [schema.org](https://schema.org/Product) |
| FIBO | Financial ontology in RDF/OWL, maintained by the EDM Association, reviewed quarterly | Pattern for an industry ontology; relevant to finance and treasury domains | [EDM Council](https://edmcouncil.org/frameworks/industry-models/fibo/) |
| SAP One Domain Model | SAP's shared business object model; BDC data products are aligned to a "one domain model" | Canonical model for SAP-side entities | [SAP, Feb 2025](https://news.sap.com/2025/02/sap-databricks-open-bold-new-era-data-ai/) |
| Microsoft Common Data Model | Standard entities (Account, Campaign ...), attributes, traits, relationships; underpins Dynamics 365/Dataverse | Starting template; the main page dates from 2020, so treat as legacy | [Microsoft Learn](https://learn.microsoft.com/en-us/common-data-model/) |
| OpenLineage | Lineage event model (dataset, job, run, facets) | Standard for lineage capture across tools | [OpenLineage](https://openlineage.io/docs/) |

Two notes. First, standards cover the shared core only; every firm still models its own hierarchies, KPIs and
local attributes on top (my assessment). Second, Microsoft's Fabric "Retail industry data model" overview page now
redirects to a Microsoft "what's new and deprecations" path; I could not confirm its current status, so I would not
recommend building on it without checking with Microsoft. The Tiger Analytics case used "Microsoft's CPG data model
template" as its Silver layer starting point ([Tiger Analytics](https://www.tigeranalytics.com/perspectives/case-study/data-foundation-modernization-for-cpg/)).

### 4.4 How translation is done in practice

The translation problem for a CPG combining SAP, Salesforce, retailer POS, media and MES data breaks into six
jobs. For each I give the technique and the evidence.

1. **Schema mapping (source column -> canonical attribute).** Done in the Silver/conformance layer as
   source-to-target mappings (STTM). The Tiger Analytics project built a toolkit to validate STTM compliance
   ([Tiger Analytics](https://www.tigeranalytics.com/perspectives/case-study/data-foundation-modernization-for-cpg/));
   Google Cortex encodes the mapping as `table_settings.yaml` compiled to Dataform
   ([Google Cloud](https://docs.cloud.google.com/cortex/docs/overview)). LLM-assisted matching is a research area
   (Magneto, LLMatch, Schemora) but production tools still present drafts for review (section 2.3).
2. **Identifier crosswalks (product, store, customer).** DS Stream lists "product and store identifier mapping" and
   "retailer-specific taxonomy mapping to enterprise category hierarchy" as core conformance steps, and names weak
   crosswalks ("duplicate products and missing retailer-to-manufacturer identifier links") as a common failure
   ([DS Stream, Nov 2026](https://www.dsstream.com/post/category-management-data-engineering-cpg)). GTIN is the
   natural product key because "each type of trade item is given its own GTIN"
   ([Wikipedia](https://en.wikipedia.org/wiki/Global_Trade_Item_Number)); GLN is the natural location/party key
   ([GS1 Canada](https://gs1ca.org/standards/global-location-number)). ISA-95 Part 7 is literally an "alias service
   model" for mapping equivalent identifiers across domains ([ISA](https://www.isa.org/standards-and-publications/isa-standards/isa-95-standard)).
3. **Entity resolution and golden records.** Rule-based and ML matching with confidence scores, plus licensed
   reference data for consumers ([AWS Entity Resolution](https://docs.aws.amazon.com/entityresolution/latest/userguide/what-is-service.html));
   MDM hubs (Reltio, Informatica, Stibo, Profisee, SAP MDG) maintain golden records with stewardship workflows.
   BARC's caution applies: MDM needs "clean processes, clear data ownership, and disciplined stewardship"
   ([BARC](https://barc.com/barc-perspective-sap-acquires-reltio/)).
4. **Hierarchies and calendars.** Category hierarchies change; DS Stream recommends slowly changing dimensions so
   history stays consistent, and "date and fiscal calendar alignment" plus "market-specific calendar and promotional
   logic" for multi-market firms ([DS Stream](https://www.dsstream.com/post/category-management-data-engineering-cpg)).
5. **Metric definitions as code.** Once entities line up, define "net revenue", "share of shelf", "OTIF" once in the
   metric engine and expose it everywhere (section 1.7). Microsoft's ontology keeps the DAX measure owned by the
   Power BI model and references it, so agents "recognize and use the organization's defined calculations rather
   than recreating them" ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/ontology/overview)).
6. **Ontology mapping (binding canonical entities to physical sources).** Fabric data bindings "preserve the
   mapping between business terminology and source structures" ([Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/ontology/overview));
   Palantir maps datasets to object types and links ([Palantir](https://www.palantir.com/docs/foundry/ontology/core-concepts/));
   Stardog uses R2RML/SMS mappings ([Stardog](https://docs.stardog.com/virtual-graphs/)).

Where LLMs help most today (my assessment, consistent with the vendor limits quoted in 2.3): drafting column and
table descriptions, proposing glossary definitions from existing documents, suggesting candidate schema matches
and join paths from query history, and proposing synonyms. Where they do not yet replace people: deciding which
definition is authoritative when finance and sales disagree, and identifier crosswalks where an error silently
corrupts every downstream number.

### 4.5 Who owns it

- **Domain stewards own terms and definitions**; the CDO office or a federated governance council owns the
  cross-domain standards (identifiers, shared entities). NetApp runs a federated model with "more than 160
  stewards" ([Collibra case study](https://www.casestudies.com/company/collibra/case-study/how-netapps-business-led-approach-to-data-governance-has-stood-the-test-of-time)).
  Data mesh makes identifier choices a global concern and data product owners accountable for quality
  ([martinfowler.com](https://martinfowler.com/articles/data-mesh-principles.html)).
- **Analytics engineering owns metrics-as-code**, with finance sign-off for financial metrics (my synthesis; the
  sources show code living in dbt/LookML/Cube repos under Git review, e.g. Cube's agents "propose" model edits
  "through normal git workflows, with humans reviewing" ([Cube](https://docs.cube.dev/docs/introduction))).
- **MDM/master data teams own golden records and crosswalks.**
- **Platform teams own the catalog and the policy engine.** In AWS's CPG guidance producers "define who can use
  their data, and governance is managed at the central data platform"
  ([AWS](https://aws.amazon.com/solutions/guidance/cpg-data-products-on-aws/)).
- **Product managers can be the first definition writers.** The Atlan HR-tech customer used product managers as its
  first cohort, with a quarter-long adoption programme ([Atlan](https://atlan.com/customers/hr-services-leader-atlan/)).

### 4.6 How long glossaries take

| Case | Scope | Duration | Source |
|---|---|---|---|
| HR-tech company on Atlan (unnamed) | 20 -> 250 -> ~300 (end 2022) -> 400 terms (mid-2023); 75,000 assets mapped; 500+ users | Under two years; "the first 20 terms took about as long as the next 100" | [Atlan, June 2023](https://atlan.com/customers/hr-services-leader-atlan/) |
| NetApp on Collibra | 50+ dictionaries consolidated; 160+ stewards; glossary usage up 200% after a "find a definition" widget | Programme since 2010; ongoing | [Collibra case study](https://www.casestudies.com/company/collibra/case-study/how-netapps-business-led-approach-to-data-governance-has-stood-the-test-of-time) |
| Collibra method | Starts with a "limited list of business terms" | No duration given | [Collibra University](https://cdn-university.collibra.com/wp-content/COOK/Business-Glossary-Case_360780.html) |

Search results also surfaced anonymous PeerSpot reviews citing 4-8 months for Collibra glossary rollouts and
competitor claims of 10-18 months for large Collibra deployments; I did not open those pages, so I do not rely on
them. **My estimate** for a $10-60bn CPG: a first domain glossary (say 50-150 terms for revenue growth management
or demand planning) in 3-6 months with LLM drafting; cross-domain coverage of the few hundred terms that actually
drive decisions in 18-36 months; and never "finished", because definitions change with the business. The basis is
the Atlan curve above (slow start, then acceleration), Thoughtworks' one-domain advice, and the fact that LLM
drafting shortens description writing but not agreement.

### 4.7 So, do they need one?

Yes, with three qualifications:

1. **They need the identity layer more than the prose.** The joins between SAP, retailer and media data fail on
   product, store and calendar keys, not on wording.
2. **They need the definitions to execute.** A glossary entry for "net revenue" that is not linked to a single
   metric definition used by BI and agents does not stop two numbers appearing. Looker's claim that its semantic
   layer cuts gen-AI query errors "by as much as two thirds" is a vendor figure with no stated method
   ([Google Cloud, Aug 2025](https://cloud.google.com/blog/products/data-analytics/understanding-lookers-conversational-analytics-api)),
   but the direction is consistent across every vendor and Thoughtworks' note that naive text-to-SQL fails when
   business rules sit outside the schema ([Thoughtworks](https://www.thoughtworks.com/radar/techniques/semantic-layer)).
3. **They should borrow before they build.** SAP data products already carry SAP semantics; GS1 identifiers and
   ISA-95 already define product, location and plant; Crisp and similar aggregators already harmonise POS into a
   standard model ([Databricks](https://databricks.com/blog/how-crisp-and-databricks-enable-retail-supplier-collaboration-through-shared-sales-and-inventory-data)).
   The firm-specific work is the crosswalk between these and its own hierarchies, plus its own KPIs.

---

## 5. Published reference architectures

| Publisher | Architecture | What it contributes | Source |
|---|---|---|---|
| Microsoft (Azure Architecture Center, updated Aug 2026) | Analytics end-to-end with Microsoft Fabric | OneLake as home; mirroring, shortcuts, pipelines; medallion; semantic models; data agents; Purview glossary and lineage | [Microsoft Learn](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end) |
| Microsoft | Fabric IQ ontology | Virtual semantic and context layer over bound sources | [Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/ontology/overview) |
| AWS | Guidance for CPG Data Products on AWS | Data mesh: producer domains, central governance account, Lake Formation, APIs | [AWS](https://aws.amazon.com/solutions/guidance/cpg-data-products-on-aws/) |
| Google Cloud | Cortex Framework | Prebuilt SAP/Salesforce/Oracle EBS/marketing models on BigQuery; raw -> foundation -> product layers; Knowledge Catalog semantic context | [Google Cloud](https://docs.cloud.google.com/cortex/docs/overview), [README](https://github.com/GoogleCloudPlatform/cortex-data-foundation/blob/main/README.md) |
| SAP | Business Data Cloud + Business AI Platform | Data products on one domain model; zero-copy to Databricks/Snowflake; knowledge graph; Domain Models; Reltio MDM; Dremio/Iceberg lakehouse (Q1 2027) | [SAP](https://news.sap.com/2025/02/sap-databricks-open-bold-new-era-data-ai/), [SAPinsider](https://sapinsider.org/blogs/sap-sapphire-2026-how-sap-business-ai-platform-consolidates-sap-btp-sap-business-data-cloud-and-sap-business-ai/), [ERP Today](https://erp.today/sap-teched-2026-whats-rolling-out-and-whats-planned-through-2027/) |
| a16z (March 2026) | Five-step context layer | Access -> automated construction -> human refinement -> agent connection -> self-updating | [a16z](https://a16z.com/your-data-agents-need-context/) |
| Thoughtworks (April 2026, Trial) | Semantic layer technique | One domain first; upfront modelling cost | [Thoughtworks](https://www.thoughtworks.com/radar/techniques/semantic-layer) |
| Cube (July 2026) | Executable vs descriptive context | Semantic layer as runtime; catalogs/ontologies descriptive; memory in harness | [Cube](https://cube.dev/blog/the-context-layer-needs-a-semantic-layer) |
| DataHub (June 2026) | Semantics, operational state, provenance | Continuous generation from usage; event-driven; column-level lineage | [DataHub](https://datahub.com/?p=15016) |
| Glean (Sept 2026) | Enterprise context for agents | Connectors with permissions, index, hybrid retrieval, graph, permission-aware delivery | [Glean](https://www.glean.com/blog/from-enterprise-search-to-enterprise-context-what-ai-agents-actually-need) |
| Microsoft Research | GraphRAG | Graph extraction and community summaries for document corpora | [GraphRAG](https://microsoft.github.io/graphrag/) |
| MCP (spec 2025-11-25) | Agent context protocol | Hosts/clients/servers; resources, prompts, tools | [MCP](https://modelcontextprotocol.io/specification/2025-11-25) |

Gartner: I could not open Gartner's "First Take" on Fabric IQ (HTTP 403), so I have not used Gartner material.

---

## 6. Three reference architectures, drawable as boxes and arrows

Notation: `[Box]`, `-->` data flow, `..>` metadata/context flow, `==>` query/answer flow. Products in brackets
are examples, not recommendations. These are my designs, assembled from the sourced components above.

### 6.1 Architecture A: metrics-first semantic layer on a lakehouse, for BI and AI

**When to use it**: the first priority is that every dashboard, spreadsheet and AI answer about revenue, volume,
margin, share and forecast accuracy uses one definition. This is the Thoughtworks/dbt/Cube/Looker pattern.

```
SOURCES                      INGEST                     LAKEHOUSE (one region)                 SEMANTIC                     CONSUMERS
[SAP S/4 via BDC/Datasphere]--share/replicate-->+
[Salesforce]--------------CDC (Lakeflow/Mirroring)-->+
[Oracle/Workday]----------CDC---------------->+      [Bronze: raw]
[Retailer POS (Crisp)]----Delta/Snowflake share-->+       |
[Circana/NIQ]-------------share-------------->+       v transform (dbt / Dataform / Spark)
[Google/Meta ads]---------pipelines---------->+   [Silver: conformed entities,
                                                         crosswalks, calendars]
                                                          |
                                                          v
                                                   [Gold: star schemas / data products]
                                                          |
                                                          v
                                              [METRIC ENGINE: MetricFlow | Cube | AtScale |
                                               LookML | Power BI model | SF semantic views |
                                               DBX metric views]
                                                 |  defines measures, dimensions, joins
                                                 |  + [AGGREGATE CACHE] (Cube Store / materialised metric views)
                                                 |  + [POLICY] (RLS/ABAC/access policies, enforced at compile)
                                                 |
           +-------------------+------------------+-------------------+-------------------+
           ==> SQL/JDBC/ADBC   ==> MDX/DAX/XMLA    ==> REST/GraphQL    ==> MCP server       ==> exports
           [Tableau/Sigma]     [Excel, Power BI]   [Apps, portals]     [Agents: Genie,      [Planning tools,
                                                                        Cortex Agents,       o9/Kinaxis]
                                                                        Claude/ChatGPT]
SIDE SERVICES:
[CATALOG + GLOSSARY (Unity Catalog / Horizon / Purview / Atlan)] ..> descriptions, owners, certified metrics ..> MCP
[LINEAGE (OpenLineage / platform lineage)] ..> from source column to metric
[RETRIEVAL INDEX (Cortex Search / Vector Search)] ..> verified queries, metric docs, examples for the agent
```

**Inputs**: Gold tables, metric code in Git, glossary terms, verified example queries.
**Outputs**: governed numbers through every interface; the agent never writes raw SQL against Silver/Gold, it
calls metrics (dbt's stated design: answers "use your governed metrics instead of guessing at raw tables",
[dbt](https://docs.getdbt.com/docs/use-dbt-semantic-layer/dbt-sl); Cube validates each agent query against the
model and applies policies before it reaches the warehouse, [Cube](https://docs.cube.dev/docs/introduction)).
**Strengths**: fastest route to trustworthy text-to-SQL and consistent KPIs; testable in CI.
**Limits**: weak on documents, processes and actions; cross-region and cross-platform needs one engine per
platform or a portable engine, until Ossie matures.

### 6.2 Architecture B: ontology / knowledge-graph context layer for agents across many systems

**When to use it**: agents must reason across entities and processes (customer, outlet, order, shipment,
promotion, machine, batch) and sometimes act, across systems that will not all be copied. This is the Palantir,
Fabric IQ and SAP Knowledge Graph pattern, with Glean-style retrieval for documents.

```
                         [AGENT RUNTIME / ORCHESTRATOR]  (Foundry agents, Joule, Agentforce, AIP, custom)
                                 |        ^
                    plan/tools   |        | answers + citations + proposed actions
                                 v        |
                    +------------ MCP / API gateway (auth, consent, audit) ------------+
                    |                     |                      |                     |
                    v                     v                      v                     v
           [ONTOLOGY SERVICE]     [METRIC ENGINE]        [RETRIEVAL INDEX]       [ACTION SERVICE]
           entity types,          governed measures      docs, SOPs, contracts,  writeback: create
           relationships,         (referenced by the     specs, tickets; hybrid  order, adjust forecast,
           rules, namespaces      ontology, not copied)  vector+keyword; ACLs    raise quality hold
           (Palantir / Fabric IQ  (Power BI / dbt /      synced per item         (Palantir actions /
            / SAP KG / Neo4j)      Cube)                  (Glean / Cortex Search) Fabric Activator /
                    |                     |                      |                SAP APIs)
                    | data bindings       |                      |                     |
                    v                     v                      v                     v
           +------------------- ACCESS LAYER (mixed) -----------------------------------+
           | copy: lakehouse tables | federate: Starburst/Denodo/Lakehouse Federation |
           | share: SAP BDC Connect, Salesforce Zero Copy | stream: eventhouse / PI   |
           +---------------------------------------------------------------------------+
                    |               |               |               |              |
              [SAP S/4]       [Salesforce]     [MES / PI]      [WMS/TMS]     [SharePoint,
                                                                              Teams, Jira]

CROSS-CUTTING:
[ENTITY RESOLUTION / MDM (Reltio, Informatica)] ..> one ID per customer/product/site ..> ontology instances
[POLICY ENGINE] ..> object/row/column security evaluated on bound sources (OneLake RLS/OLS/CLS, Palantir roles)
[LINEAGE + DECISION LOG (memory)] ..> provenance of answers and actions (DataHub "provenance")
[OPTIONAL GRAPH STORE] ..> materialise instances only for multi-hop / path questions (Fabric "optional graph execution")
```

**Key design choices, each sourced**: the ontology stores definitions and bindings, not the data ("Source data
remains in the system that owns it", [Microsoft Learn](https://learn.microsoft.com/en-us/fabric/iq/ontology/overview));
metrics stay owned by the semantic model (same source); graph materialisation is opt-in for path questions (same
source); actions are first-class (Palantir action types with side effects,
[Palantir](https://www.palantir.com/docs/foundry/ontology/core-concepts/)); retrieval is permission-aware at query
time ([Glean](https://www.glean.com/blog/from-enterprise-search-to-enterprise-context-what-ai-agents-actually-need)).
**Inputs**: glossary, semantic models, source schemas, MDM golden records, documents.
**Outputs**: entity-level context and tool calls for agents, with citations and audit.
**Strengths**: handles cross-system questions and actions; does not require copying everything.
**Limits**: heaviest modelling effort; federated sources set the latency floor; Fabric's ontology is still preview
(with the old experience retiring 31 January 2027) and SAP's Ontology Manager is a Q1 2027 beta (sources above), so
product maturity is uneven.

### 6.3 Architecture C: CPG enterprise blueprint

**Scope**: SAP S/4HANA and ECC, Salesforce, retailer POS and retail media, Nielsen/Circana, Google/Meta ads,
MES/historians (AVEVA PI), PLM, WMS/TMS; serving marketing, revenue growth management (RGM), supply chain and
manufacturing. This combines A and B, organised by domain data products.

```
=============================== LAYER 1: SOURCES (by owner) ===============================
 ENTERPRISE CORE         COMMERCIAL               EXTERNAL / PARTNER                  OPERATIONS
 [SAP S/4HANA]           [Salesforce Sales/       [Retailer POS + inventory:          [MES]
 [SAP ECC (legacy)]       Consumer Goods Cloud]    Walmart Scintilla, Crisp feeds]    [AVEVA PI historian]
 [SAP MDG]               [Trade promotion mgmt]   [Retail media: Walmart Connect,     [PLM (specs, BOMs)]
                          [D2C / e-commerce]        Amazon Ads, Scintilla Media Feed]  [WMS] [TMS]
                                                   [Nielsen / Circana]
                                                   [Google Ads, CM360, DV360, Meta]

=============================== LAYER 2: ACCESS (per source) ===============================
 SAP --> BDC data products (one domain model) --zero-copy--> lakehouse     [licence: no ODP-RFC to 3rd party;
         (or Datasphere replication; Premium Outbound blocks if non-SAP target)   SAP Note 3255746]
 Salesforce --> CDC connector or Zero Copy share
 Retailer POS --> Delta / Snowflake share (Crisp) or retailer API (Scintilla)    [subscription terms apply]
 Circana / NIQ --> Snowflake / Delta share
 Ads platforms --> managed pipelines (Cortex-style) daily
 AVEVA PI --> CONNECT --> Delta Sharing (asset hierarchy preserved)
 MES / WMS / TMS --> CDC for history + federation for live status
 PLM, SOPs, contracts, briefs --> document index (permission-synced)

=============================== LAYER 3: REGIONAL LAKEHOUSE (Delta/Iceberg) ================
 [Bronze: raw per source]
      --> [Silver: CONFORMED CORE]
            - Product: SAP material <-> GTIN (GS1/GDSN) <-> retailer item <-> Nielsen/Circana UPC <-> PLM spec
            - Location/Party: SAP sold-to/ship-to <-> GLN <-> retailer store ID <-> DC/plant (ISA-95 site)
            - Calendar: retailer weeks <-> fiscal periods <-> promo calendar
            - Hierarchies: retailer taxonomy -> enterprise category/brand hierarchy (SCD2)
            - Plant: ISA-95 enterprise/site/area/line/unit <-> PI asset framework
      --> [Gold: DOMAIN DATA PRODUCTS]
            Marketing: media spend & outcomes, retail media ROAS, brand health
            RGM: price/pack architecture, promo lift, trade spend, net revenue waterfall
            Supply chain: demand, forecast accuracy, inventory, OTIF, case fill
            Manufacturing: OEE, yield, quality holds, batch genealogy

  [ENTITY RESOLUTION / MDM hub (SAP Reltio, Informatica, Stibo...)] <--> Silver crosswalks
  [CATALOG + GLOSSARY] ..> every Silver/Gold asset, with owner and certification
  [LINEAGE] ..> column-level from source to metric

=============================== LAYER 4: SEMANTICS & CONTEXT ===============================
 [METRIC ENGINE]  net revenue, gross-to-net, volume, share, ROAS, iROAS, promo ROI, OTIF, OEE ...
                  one definition, CI-tested, owned by analytics engineering + finance
 [ONTOLOGY]       Product, Brand, Customer, Outlet, Order, Shipment, Promotion, Campaign,
                  Plant, Line, Batch, Supplier; relationships; rules (e.g. "use retailer POS for
                  sell-out, SAP for sell-in"); bound to Gold + federated live sources
 [RETRIEVAL]      trade terms, JBPs, promo briefs, specs, SOPs, deviation reports
 [POLICY]         market/customer row filters, cost/margin column masks, retailer-data
                  usage terms (who may see which retailer's data), clean-room rules for media

=============================== LAYER 5: INTERFACES ========================================
 SQL/JDBC | MDX/DAX/XMLA (Excel) | REST/GraphQL | MCP (one server per governed layer)

=============================== LAYER 6: CONSUMERS =========================================
 Marketing: MMM/MMX tools, media planners, retail media agents
 RGM: pricing & promo optimisation, KAM copilots, Excel
 Supply chain: planning (o9/Kinaxis/Blue Yonder/Relex), control-tower agents
 Manufacturing: OEE dashboards, quality agents, maintenance copilots
 Executive: Power BI/Looker/Tableau dashboards, Joule / Copilot / custom agents
```

**Why the conformed core is the centre**: every cross-domain question in CPG (did the promotion lift sell-out at
Walmart, and did the plant and DCs keep up?) needs product, location and calendar keys that line up across SAP,
retailer, syndicated and plant data. Those crosswalks are the techniques in section 4.4 and are where the cited
CPG practitioner guidance concentrates its controls ([DS Stream](https://www.dsstream.com/post/category-management-data-engineering-cpg)).

**Why the SAP leg is drawn through BDC**: licence and price list (section 3.4).

**Why retailer data needs its own policy**: Walmart now governs syndicated access to its data by subscription and
Scintilla Charter status ([Walmart Data Ventures](https://walmartdataventures.com/insights/update-to-walmart-named-data-policy)),
and the Media Data Feed lets advertisers grant specific data elements to specific partners
([Walmart Connect](https://www.walmartconnect.com/resources/articles/2026/introducing-scintilla-media-data-feed)).
An agent that mixes one retailer's data into an answer for another retailer's team is a contractual breach, not
just a governance lapse (my inference from those terms).

**Platform variants**: this blueprint maps to Google (BigQuery + Cortex for SAP/Salesforce/marketing, Looker
semantics, Knowledge Catalog; [Google Cloud](https://docs.cloud.google.com/cortex/docs/overview)), Microsoft
(OneLake + mirroring/shortcuts, Power BI semantic models, Fabric IQ ontology, Purview;
[Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end)),
Databricks (Unity Catalog, metric views, SAP BDC Connect, AVEVA CONNECT; sources above), Snowflake (semantic views,
Horizon, Cortex; Circana and Salesforce shares) or SAP-centred (BDC + SAP Databricks/Snowflake + Knowledge Graph +
Reltio). The structure is the same; what changes is which box is native.

---

## 7. Disagreements, gaps and things I could not verify

- **Is the context layer a superset of the semantic layer, or does the semantic layer sit inside it?** a16z say the
  context layer "should essentially become a superset" ([a16z](https://a16z.com/your-data-agents-need-context/));
  Cube says the semantic layer is the only executing part inside it
  ([Cube](https://cube.dev/blog/the-context-layer-needs-a-semantic-layer)). They describe the same picture from
  different seats.
- **Index versus federate for unstructured data.** Glean argues federation and MCP alone are insufficient
  ([Glean](https://www.glean.com/blog/from-enterprise-search-to-enterprise-context-what-ai-agents-actually-need));
  federation vendors claim the opposite for structured data ([Starburst](https://starburst.io/)). Both are vendor
  positions.
- **OSI/Ossie maturity.** Thoughtworks referred to "OSI v1.0" ([Thoughtworks](https://www.thoughtworks.com/radar/techniques/semantic-layer)),
  but the spec repository shows 0.1.1 released and 0.3.0.dev0 in draft
  ([Ossie spec](https://github.com/open-semantic-interchange/OSI/blob/main/core-spec/spec.md)). I trust the repo.
- **SAP Knowledge Graph status.** Secondary sources conflict on whether it is generally available; the TechEd
  coverage puts the cross-source capabilities and Ontology Manager in Q1 2027
  ([ERP Today](https://erp.today/sap-teched-2026-whats-rolling-out-and-whats-planned-through-2027/)).
- **SAP-Dremio closing.** SAP's announcement (4 May 2026) expected closing in Q3 2026
  ([SAP](https://news.sap.com/2026/05/sap-to-acquire-dremio/)); I did not find a primary closing announcement.
- **"Zero-copy" label.** Vendors use it to mean no persistent replica; queries still consume network and compute,
  and SAP charges for cross-region transfer and API calls (section 3.2).
- **Not found**: a primary NIQ data-sharing announcement; a public, measured accuracy figure for any LLM-drafted
  glossary or semantic model; a published CPG case that states the time and team size to build a cross-domain
  ontology; the current status of Microsoft's retail/CPG industry data models; Gartner and gs1.org primary pages
  (blocked).

---

## 8. Source list

All pages opened during this research (16 November 2026).

**Standards and protocols**
- Apache Ossie announcement: https://ossie.apache.org/updates/ossie-enters-apache-incubator/
- Ossie / OSI repository: https://github.com/open-semantic-interchange/OSI
- Ossie core spec: https://github.com/open-semantic-interchange/OSI/blob/main/core-spec/spec.md
- dbt on the OSI spec (Jan 2026): https://courses.getdbt.com/blog/the-osi-spec-updates
- MCP specification 2025-11-25: https://modelcontextprotocol.io/specification/2025-11-25
- OpenLineage: https://openlineage.io/docs/
- ISA-95: https://www.isa.org/standards-and-publications/isa-standards/isa-95-standard
- GTIN (Wikipedia): https://en.wikipedia.org/wiki/Global_Trade_Item_Number
- GLN (GS1 Canada): https://gs1ca.org/standards/global-location-number
- GDSN (Wikipedia): https://en.wikipedia.org/wiki/Global_Data_Synchronization_Network
- schema.org Product: https://schema.org/Product
- FIBO (EDM Council): https://edmcouncil.org/frameworks/industry-models/fibo/
- Microsoft Common Data Model: https://learn.microsoft.com/en-us/common-data-model/

**Semantic layer and metric engines**
- dbt Semantic Layer: https://docs.getdbt.com/docs/use-dbt-semantic-layer/dbt-sl
- dbt Semantic Layer architecture: https://docs.getdbt.com/docs/use-dbt-semantic-layer/sl-architecture
- dbt Wizard / Copilot page: https://docs.getdbt.com/docs/cloud/dbt-copilot
- Cube docs: https://docs.cube.dev/docs/introduction
- Cube, "The context layer needs a semantic layer": https://cube.dev/blog/the-context-layer-needs-a-semantic-layer
- AtScale MCP blog: https://www.atscale.com/blog/enterprise-ai-mcp-semantic-layer/
- Atlan, AtScale vs context layer: https://atlan.com/know/ai-agent/semantic-layer/atscale-vs-context-layer/
- LookML: https://docs.cloud.google.com/looker/docs/what-is-lookml
- Looker at Next '26: https://cloud.google.com/blog/products/business-intelligence/looker-updates-for-agentic-bi-at-next26
- Looker Conversational Analytics API: https://cloud.google.com/blog/products/data-analytics/understanding-lookers-conversational-analytics-api
- Power BI XMLA endpoint: https://learn.microsoft.com/en-us/fabric/enterprise/powerbi/service-premium-connect-tools
- Snowflake semantic views: https://docs.snowflake.com/en/user-guide/views-semantic/overview
- Snowflake Semantic View Autopilot: https://docs.snowflake.com/en/user-guide/views-semantic/autopilot
- Databricks metric views: https://docs.databricks.com/aws/en/metric-views/

**Ontology, graph, catalog, retrieval**
- Palantir Ontology overview: https://www.palantir.com/docs/foundry/ontology/overview/
- Palantir Ontology core concepts: https://www.palantir.com/docs/foundry/ontology/core-concepts/
- Palantir AIP overview: https://www.palantir.com/docs/foundry/aip/overview/
- Microsoft Fabric IQ ontology: https://learn.microsoft.com/en-us/fabric/iq/ontology/overview
- Stardog virtual graphs: https://docs.stardog.com/virtual-graphs/
- Cognite industrial knowledge graph: https://www.cognite.com/en/industrial-knowledge-graph
- Microsoft GraphRAG: https://microsoft.github.io/graphrag/
- Atlan, build a context layer: https://docs.atlan.com/agents/how-tos/build-a-context-layer
- DataHub, context layer components: https://datahub.com/?p=15016
- Glean, enterprise context: https://www.glean.com/blog/from-enterprise-search-to-enterprise-context-what-ai-agents-actually-need
- Glean knowledge graph: https://docs.glean.com/security/knowledge-graph
- Snowflake Cortex Search: https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-search/cortex-search-overview
- Databricks AI-generated comments: https://docs.databricks.com/aws/en/comments/ai-comments

**Access, sharing, federation, policy**
- Databricks Lakehouse Federation: https://docs.databricks.com/aws/en/query-federation/
- Databricks Delta Sharing / OpenSharing: https://docs.databricks.com/aws/en/delta-sharing/
- Databricks SAP BDC connector: https://docs.databricks.com/aws/delta-sharing/sap-bdc
- Databricks Lakeflow Connect: https://docs.databricks.com/aws/en/ingestion/lakeflow-connect/
- Databricks Unity Catalog ABAC: https://docs.databricks.com/aws/en/data-governance/unity-catalog/abac/
- Snowflake row access policies: https://docs.snowflake.com/en/user-guide/security-row-intro
- Snowflake data transfer cost: https://docs.snowflake.com/en/user-guide/cost-understanding-data-transfer
- Snowflake and Salesforce Data Cloud zero copy: https://docs.snowflake.com/en/user-guide/data-integration/zero-copy/about-salesforce-datacloud
- Salesforce Zero Copy Partner Network: https://www.salesforce.com/news/stories/what-is-zero-copy-partner-network/
- Fabric mirroring: https://learn.microsoft.com/en-us/fabric/mirroring/overview
- Denodo data virtualisation: https://www.denodo.com/en/data-virtualization/overview
- Starburst: https://starburst.io/

**Reference architectures and analyst views**
- Azure Architecture Center, Analytics end-to-end with Fabric: https://learn.microsoft.com/en-us/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end
- AWS Guidance for CPG Data Products: https://aws.amazon.com/solutions/guidance/cpg-data-products-on-aws/
- AWS Entity Resolution: https://docs.aws.amazon.com/entityresolution/latest/userguide/what-is-service.html
- Google Cortex Framework overview: https://docs.cloud.google.com/cortex/docs/overview
- Google Cortex Data Foundation README: https://github.com/GoogleCloudPlatform/cortex-data-foundation/blob/main/README.md
- a16z, "Your Data Agents Need Context": https://a16z.com/your-data-agents-need-context/
- Thoughtworks Radar, semantic layer: https://www.thoughtworks.com/radar/techniques/semantic-layer
- Dehghani, data mesh principles: https://martinfowler.com/articles/data-mesh-principles.html
- Magneto (arXiv): https://arxiv.org/abs/2412.08194

**SAP**
- SAP Business Data Cloud launch (Feb 2025): https://news.sap.com/2025/02/sap-databricks-open-bold-new-era-data-ai/
- SAP completes Reltio acquisition: https://news.sap.com/2026/05/sap-completes-acquisition-of-reltio/
- BARC on SAP-Reltio: https://barc.com/barc-perspective-sap-acquires-reltio/
- SAP to acquire Dremio: https://news.sap.com/2026/05/sap-to-acquire-dremio/
- ERP Today, SAP TechEd 2026: https://erp.today/sap-teched-2026-whats-rolling-out-and-whats-planned-through-2027/
- SAPinsider, Sapphire 2026 Business AI Platform: https://sapinsider.org/blogs/sap-sapphire-2026-how-sap-business-ai-platform-consolidates-sap-btp-sap-business-data-cloud-and-sap-business-ai/
- SAPinsider, SAP Note 3255746: https://sapinsider.org/blogs/sap-note-3255746-odp-rfc-deadline-2026/
- Matillion, SAP Note 3255746: https://docs.matillion.com/metl/docs/tech-note-sap-3255746/
- SAP BDC pricing deck (April 2026): https://assets.dm.ux.sap.com/sap-user-groups/pdfs/260416_breaking_down_the_sap_bdc_pricing_model.pdf
- SAP KBA 3456481: https://userapps.support.sap.com/sap/support/knowledge/en/3456481
- Mindset Consulting, BDC with Snowflake and Databricks: https://www.mindsetconsulting.com/snowflake-databricks-and-sap-business-data-cloud/

**CPG, retail and industrial data**
- Databricks/Crisp (Oct 2023): https://databricks.com/blog/how-crisp-and-databricks-enable-retail-supplier-collaboration-through-shared-sales-and-inventory-data
- Databricks, retailer-CPG collaboration (Feb 2026): https://www.databricks.com/blog/collaboration-advantage-how-modern-retailers-and-cpg-brands-win-together
- Circana on Snowflake (Nov 2023): https://circana.com/intelligence/press-releases/2023/circana-expands-point-of-sale-and-panel-data-access-for-clients-meeting-evolving-technology-needs-with-snowflake-integration
- Walmart Scintilla Media Data Feed: https://www.walmartconnect.com/resources/articles/2026/introducing-scintilla-media-data-feed
- Walmart named data policy: https://walmartdataventures.com/insights/update-to-walmart-named-data-policy
- Shelby Report, Scintilla (Sept 2026): https://theshelbyreport.com/2026/09/24/walmart-evolves-scintilla-into-commerce-intelligence-platform/
- AVEVA CONNECT and Databricks: https://discover.aveva.com/connect-databricks/
- Tiger Analytics CPG data foundation: https://www.tigeranalytics.com/perspectives/case-study/data-foundation-modernization-for-cpg/
- DS Stream, CPG category data engineering (Nov 2026): https://www.dsstream.com/post/category-management-data-engineering-cpg

**Glossary case studies**
- Collibra University, business glossary use case: https://cdn-university.collibra.com/wp-content/COOK/Business-Glossary-Case_360780.html
- NetApp / Collibra: https://www.casestudies.com/company/collibra/case-study/how-netapps-business-led-approach-to-data-governance-has-stood-the-test-of-time
- Atlan HR-tech customer: https://atlan.com/customers/hr-services-leader-atlan/

**Attempted but blocked (not relied on)**: Snowflake blog posts on OSI and the agent context layer (403);
Gartner First Take on Fabric IQ (403); gs1.org GTIN/GLN pages (403); SAP One Domain Model blog (403).
