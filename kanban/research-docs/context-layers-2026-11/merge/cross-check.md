## Cross-check: what Astra adds to or contradicts in the three Opus-only sections

Astra yields 32 insertable points for these three sections, and four of them contradict Opus.

Each item gives its type, the section and sub-part it belongs in, then the text ready to paste. Section names: **S1** "Store it all in one place, or connect where it lives?" (Opus 03 section 3); **S2** "Do they need a data dictionary?" (Opus 03 section 4); **S3** "Architecture: components, inputs, outputs and connected systems" (Opus 03 section 1).

### Contradictions at a glance

| # | Topic | Opus says | Astra says | Section |
|---|---|---|---|---|
| 1 | Top of the hybrid stack | "Put one semantic/ontology layer over all four" access modes | One registry of meanings and ownership, with domain-specific execution engines allowed ([Denodo](https://www.denodo.com/en/denodo-platform/denodo-platform); [SAP architecture](https://architecture.learning.sap.com/docs/ai-native-north-star-architecture/foundation-layer)) | S1 |
| 2 | GTIN | "The natural product key" and the join key across SAP, retailer and syndicated data ([Wikipedia](https://en.wikipedia.org/wiki/Global_Trade_Item_Number)) | A GTIN identifies a trade item; it is not a universal ID for every grouping or packaging level ([GS1](https://support.gs1.org/support/solutions/articles/43000734124-what-is-the-difference-between-a-gs1-gtin-a-barcode-an-ean-and-a-upc-)) | S2 |
| 3 | Cube interfaces | REST, GraphQL and Postgres-compatible SQL listed as equals ([Cube docs](https://docs.cube.dev/docs/introduction)) | Cube's May 2026 guidance favours the Semantic SQL API over the older JSON REST interface for new work ([Cube](https://cube.dev/blog/cube-core-and-cube)) | S3 |
| 4 | SAP-Dremio closing | No primary closing announcement found ([SAP](https://news.sap.com/2026/05/sap-to-acquire-dremio/)) | Closed 6 July 2026 per SAP's Q3 statement ([SAP Q3 2026](https://www.sap.com/docs/download/investors/2026/sap-2026-q3-statement.pdf)); Opus's vendor report agrees ([SAP](https://news.sap.com/2026/07/sap-completes-dremio-acquisition/)) | S1 |

---

### S1. Store it all in one place, or connect where it lives?

**S1-1. Adds: two more "no copy" patterns.** Goes after the four-access-modes table (Opus 3.1).

- Two more patterns sit beside the four access modes (Astra). **Metadata federation** collects schemas, descriptions, lineage, owners and policies, not rows: Snowflake Horizon Context (preview, 12 October 2026) pulls metadata from 18 external systems ([Horizon Context preview](https://docs.snowflake.com/en/release-notes/2026/other/2026-10-12-horizon-context-preview)). **Document retrieval and agent tools** index text and permissions, and "a connector is not proof of zero storage", so check indexes, caches and retained conversations ([Glean knowledge graph](https://docs.glean.com/security/knowledge-graph); [dbt MCP](https://docs.getdbt.com/docs/dbt-ai/about-mcp)). Astra notes that Glean-style crawling and indexing create derived copies of the content.

**S1-2. Adds: Direct Lake is not federation.** Goes in Trade-offs (Opus 3.2), after "Zero-copy has a price list".

- Microsoft's Direct Lake reads OneLake Delta metadata and loads only the columns a query needs, avoiding a full import refresh (Astra). It is not zero memory, zero processing or live federation to an ERP ([Microsoft Direct Lake](https://learn.microsoft.com/en-us/fabric/fundamentals/direct-lake-overview)). A shared table is also not the same thing as a virtual query over a transactional API.

**S1-3. Adds: "zero-copy" means different things to different vendors.** Goes in Trade-offs (Opus 3.2), next to the price-list bullet.

- Some vendors call federation "zero-copy", while others use the phrase for shared analytical tables (Astra) ([Salesforce](https://www.salesforce.com/data/connectivity/zero-copy/); [Stardog](https://docs.stardog.com/virtual-graphs/)). Salesforce itself says physical replication remains appropriate in some cases ([Salesforce zero-copy](https://www.salesforce.com/data/connectivity/zero-copy/)).

**S1-4. Adds: sharing does not remove upstream work.** Goes in Trade-offs (Opus 3.2), Governance bullet.

- A share saves the consumer a feed, but upstream collection, identity mapping and curation still happen somewhere (Astra). Kraft Heinz's retailer collaboration and Ritual's Snowflake delivery both show sharing after the data was prepared ([Kraft Heinz, 2022](https://www.snowflake.com/en/blog/kraft-heinz-fosters-collaboration-retail-partners/); [Ritual](https://www.gocrisp.com/case-studies/ritual)).

**S1-5. Adds: named CPG evidence for who stores and who connects.** Goes in "Who does which" (Opus 3.3), as a new "CPG companies" bullet group. Opus 3.3 names platforms only.

- **Nestlé** moved from six on-premises data centres to RISE with SAP on Azure and a central Azure data lake ([Nestlé, 2025](https://www.microsoft.com/en/customers/story/23963-nestle-azure)) (Astra).
- **PepsiCo** runs a governed Databricks and Unity Catalog platform; this shows a central foundation, not that every record sits in one place ([PepsiCo, 2024](https://www.databricks.com/blog/how-pepsico-established-enterprise-grade-data-intelligence-platform-powered-databricks-unity)) (both).
- **P&G** combines edge and cloud: MQTT and Kubernetes/Arc connectivity near factories feeds wider Azure analysis ([Microsoft/P&G, 2025](https://www.microsoft.com/en/customers/story/25077-procter-and-gamble-iot-operations)) (Astra).
- **Kraft Heinz** migrated from legacy Hadoop to Snowflake and shares data with retail partners ([Kraft Heinz, 2022](https://www.snowflake.com/en/blog/kraft-heinz-fosters-collaboration-retail-partners/)) (Astra).
- **Ritual** received target data through Snowflake sharing in one to two hours, once Crisp's foundation existed (vendor case study) ([Ritual](https://www.gocrisp.com/case-studies/ritual)) (Astra).

**S1-6. Resolves an Opus gap: SAP closed Dremio.** Goes in "Who does which" (Opus 3.3), connect-first bullet, after the ERP Today Dremio sentence.

- SAP completed the Dremio acquisition on 6 July 2026 ([SAP Q3 2026 statement](https://www.sap.com/docs/download/investors/2026/sap-2026-q3-statement.pdf)) (both; Opus's vendor report cites [SAP](https://news.sap.com/2026/07/sap-completes-dremio-acquisition/)). This replaces Opus 03's "no primary closing announcement found".

**S1-7. Contradicts: one semantic layer, or a registry plus domain engines?** Goes in "The hybrid reality" (Opus 3.5), directly after step 5.

- The reports disagree on the top layer. Opus recommends one semantic/ontology layer over every access mode; Astra recommends one registry of meanings and ownership, with domain-specific execution engines allowed ([Denodo platform](https://www.denodo.com/en/denodo-platform/denodo-platform); [SAP foundation architecture](https://architecture.learning.sap.com/docs/ai-native-north-star-architecture/foundation-layer)). In Astra's federated design "an existing domain semantic service can remain authoritative for financial measures" (Astra).

**S1-8. Agrees: the hybrid policy itself.** Goes in "The hybrid reality" (Opus 3.5), as the provenance line under the list.

- Both reports independently reach the same hybrid: centralise repeatedly joined facts and history, federate where freshness or organisational boundaries justify it, and cache under explicit freshness rules (both) ([Denodo platform](https://www.denodo.com/en/denodo-platform/denodo-platform)).

**S1-9. Adds: six procurement questions.** Goes at the end of S1, after the rules of thumb.

- Ask every vendor six questions; "zero-copy" answers none of them (Astra):
  1. Where are primary data, cached results and embeddings stored?
  2. Which system computes the join?
  3. What happens when a source is unavailable?
  4. How quickly do permission changes propagate?
  5. What does each query or refresh cost?
  6. Can a historical answer be reproduced?

---

### S2. Do they need a data dictionary?

**S2-1. Adds: two more artefacts.** Goes in "Four artefacts that get called the data dictionary" (Opus 4.1), as two extra table rows in Opus's column order.

| Artefact | Answers | Grain | Owner (typical) | Machine-executable? | Examples |
|---|---|---|---|---|---|
| Mapping specification (Astra) | "How is this source value translated into a canonical identity, unit or category?" | Source value to canonical value | Data product owner, implemented by engineering | Yes, as versioned mapping tables | Effective-dated crosswalks with packaging level, unit conversion, market and confidence (Astra 6.2) |
| Provenance and version history (Astra) | "Which source, rule and definition produced this answer at that time?" | Answer and definition version | Platform/governance team with domain approval | Partly | Metric version and deprecation policy published so agents compare like with like (Astra 6.3) |

Astra lists seven artefacts: it splits the canonical entity model from the ontology and adds these two (Astra). It deliberately separates approval of meaning from implementation of code.

**S2-2. Adds nuance: governed translation, not one giant model.** Goes in "So, do they need one?" (Opus 4.7), after "Yes, with three qualifications".

- Astra's answer is "yes to governed translation; not necessarily to a single comprehensive ontology built in advance". Golden records, executable joins and ontology constraints each solve a different part ([SAP MDG](https://www.sap.com/products/data-cloud/master-data-governance.html); [LookML](https://docs.cloud.google.com/looker/docs/what-is-lookml); [TopBraid](https://docs.topquadrant.com/9.0/user_guide/guidance_specific_to_asset_collection_type/working_with_ontologies/working_with_ontologies.html)) (Astra).

**S2-3. Contradicts in emphasis: GTIN is a key only at the right packaging level.** Goes in "Industry standard models and identifiers" (Opus 4.3), under the table's notes, and in step 2 of 4.4.

- The reports differ on GTIN. Opus calls it "the natural product key" ([Wikipedia](https://en.wikipedia.org/wiki/Global_Trade_Item_Number)); Astra warns it identifies a trade item, not every commercial grouping or packaging level ([GS1](https://support.gs1.org/support/solutions/articles/43000734124-what-is-the-difference-between-a-gs1-gtin-a-barcode-an-ean-and-a-upc-)). Both hold if crosswalks keep units, multipacks and shipping cases distinct.

**S2-4. Adds: controls missing from the six translation jobs.** Goes in "How translation is done in practice" (Opus 4.4), after job 3.

- Astra's worked example adds four controls (Astra, illustrative design):
  - **Keep every incoming identifier**: SAP material and sales-organisation keys, Salesforce IDs, retailer item, GTIN, media catalogue ID and MES batch.
  - **Queue the unmatched**: send unmatched records to an exception queue instead of assigning a plausible product silently.
  - **Make merges reversible**: a steward approves ambiguous merges, and unmerge must be possible ([Reltio](https://www.reltio.com/products/entity-resolution/)).
  - **Keep hierarchies purpose-specific**: finance brand, retailer category, recipe family and media audience trees can differ legitimately; join them through versioned mapping tables.
- Define measures at their real grain: a consumer sale is not manufacturer revenue, and a case shipped is not a unit sold (Astra).

**S2-5. Adds: LLM limits on identifier matching.** Goes in the "Where LLMs help most" paragraph (Opus 4.4).

- An LLM can suggest that two fields are product identifiers, but cannot tell from names alone that both use the same packaging level or hierarchy (Astra). Astra's controls: mark drafts as proposals, attach source evidence, require domain-owner approval and test mappings against real records ([Reltio](https://www.reltio.com/products/entity-resolution/)).

**S2-6. Adds: what "one net revenue definition" must specify.** Goes as a new short sub-part after "Metrics-as-code formats" (Opus 4.2).

- A usable definition names 11 fields, in three groups (Astra):
  - **Source:** authoritative ledger, reporting entity, transaction grain, recognised date.
  - **Treatment:** returns, discounts and trade accruals; tax; currency conversion; intercompany exclusions.
  - **Control:** reporting calendar, restatement and version rules, responsible finance approver.
- The goal is named variants with reconciliations, not one entry that hides disagreement. Publish a version and deprecation policy so agents compare the same calculation over time ([LookML](https://docs.cloud.google.com/looker/docs/what-is-lookml); [dbt setup](https://docs.getdbt.com/docs/use-dbt-semantic-layer/setup-sl); [Snowflake specification](https://docs.snowflake.com/en/user-guide/views-semantic/semantic-view-yaml-spec)).

**S2-7. Adds: who settles which conflicts.** Goes in "Who owns it" (Opus 4.5), as a new first bullet.

- Astra's recommended split of who settles what (Astra):
  - **Finance:** recognised revenue and margin policy.
  - **Commercial:** customer, channel and promotion meanings, with finance approval where money moves.
  - **Supply chain:** planning units and service measures.
  - **Manufacturing and quality:** equipment, batch and specification meaning.
  - **HR:** employee concepts and access.
- A small central group keeps conventions, identity contracts and interfaces. A measure change triggers dependency checks across dashboards, agents and apps.

**S2-8. Adds: CPG evidence for business-led stewardship.** Goes in "Who owns it" (Opus 4.5), after the NetApp bullet.

- **Mondelez** moved stewardship towards business owners, supported by Ataccama cataloguing, quality and lineage ([Mondelez/Ataccama, 10 Sept 2026](https://www.ataccama.com/customer-story/before-mondelez-international-could-trust-ai-it-had-to-trust-its-data)) (Astra).
- **Unilever** uses Data Product Management roles bridging business, IT and its Data Hub ([Unilever/Bridge & Co](https://www.bridgenco.com/insights/case-studies/optimizing-data-governance-at-unilever/)) (Astra).
- **Colruyt** moved its Collibra programme from a business-unit start to a permanent product team ([Colruyt/Datashift](https://www.datashift.eu/case-studies/how-colruyt-group-built-a-stronger-data-foundation-with-collibra-and-datashift)) (Astra).

**S2-9. Adds: Nestlé mapping evidence.** Goes in "How translation is done in practice" (Opus 4.4), after job 2.

- Nestlé USA's UNFI business covers about 1,500 SKUs and $300 million in sales (vendor case study). One distributor vendor number spanned several Nestlé businesses, so external items had to be mapped into internal hierarchies ([Nestlé USA/Crisp](https://www.gocrisp.com/case-studies/nestle-usa)) (Astra). Nestlé also reports cutting recipe specifications by 50% since 2019 through harmonisation (company-reported) ([Nestlé annual report](https://www.nestle.com/investors/annual-report/executing-strategy/accelerating-business-transformation)) (Astra).

**S2-10. Adds a row: Ciena glossary speed.** Goes in "How long glossaries take" (Opus 4.6), as a table row.

| Case | Scope | Duration | Source |
|---|---|---|---|
| Ciena on Alation (Astra; vendor claim) | About 6,000 assets curated after preparatory protocols; small team, size undisclosed | Two weeks, against an earlier 1.5-2-year manual rollout; metadata curation, not agreed definitions | [Alation](https://www.alation.com/customers/ciena-ai-data-catalog/) |

**S2-11. Agrees: the build-time estimate.** Goes in "How long glossaries take" (Opus 4.6), after "My estimate".

- The two estimates match (both). Opus: 3-6 months for a first domain glossary, 18-36 months for cross-domain coverage. Astra: 3-6 months to a first production domain, 18-36 months or longer for extensive coverage. Astra adds the steps: 2-4 weeks discovery, a further 4-8 weeks pilot with 10-25 measures and 2-4 sources, then 6-18 months to reuse across domains (consultant estimate).
- Astra also proposes a first-domain team (estimate): one product owner, one semantic modeller, two data engineers, one shared governance/MDM specialist, one agent engineer, fractional security support, plus committed finance or commercial stewards.

**S2-12. Adds: better accuracy evidence for "definitions must execute".** Goes in "So, do they need one?" (Opus 4.7), qualification 2, after the Looker sentence.

- dbt's April 2026 benchmark used 11 insurance questions, 20 runs each: text-to-SQL scored 64.5% and the semantic layer 72.7% on the full set ([dbt, 7 Apr 2026](https://docs.getdbt.com/blog/semantic-layer-vs-text-to-sql-2026)) (both). After three modelling fixes, text-to-SQL reached 90.0% and 84.1% on two models, and the semantic layer 98.2% and 100% (both). This is a small vendor benchmark.
- A separate April 2026 preprint on 100 retail questions found a compact Markdown semantic document lifted accuracy from about 45.5-50.5% to 67.7-68.7% ([Rumiantsau and Fokeev](https://arxiv.org/abs/2604.25149)) (Astra). It tests documentation, not an executing layer.

**S2-13. Adds: licensed taxonomies to map, not adopt.** Goes in "So, do they need one?" (Opus 4.7), qualification 3, after the Crisp sentence.

- Data providers bring their own models: SPINS describes more than 325 product attributes ([SPINS, 2024](https://www.spins.com/wp-content/uploads/2024/07/SPINS-IFT-2024-Values-Oriented-PRESENTATION.pdf)), and Circana harmonises store/item/day data ([Circana, Apr 2025](https://www.circana.com/post/circana-s-liquid-supply-chain-solution-creates-an-inventory-command-center-for-cross-retailer-insigh)) (Astra). Their licensed taxonomies must be mapped explicitly into the manufacturer's own structures, with usage rights kept (Astra).

---

### S3. Architecture: components, inputs, outputs and connected systems

**S3-1. Adds a component: evaluation.** Goes in the component table (Opus section 1), as row 15, with a short sub-part after 1.14.

| # | Component | What it does | Inputs | Outputs | Example products |
|---|---|---|---|---|---|
| 15 | Evaluation (Astra) | Tests answers against held-out reference questions before and after release | Verified queries, question sets, query traces | Accuracy, unsupported-answer rate, refusal quality, latency, cost | [Snowflake Cortex Analyst evaluations](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst-evaluations) |

- Snowflake's evaluation tool removes selected verified queries from runtime context while testing, and lists limits: single-view runs and no multi-turn evaluation ([Cortex Analyst evaluations](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst-evaluations)) (Astra). It also charges for warehouse, judge inference and storage.
- Astra's client test compares raw-schema text-to-SQL, documented-schema retrieval and governed semantic execution on the same model, data snapshot and questions (Astra). Include unsupported, ambiguous, market-specific, permission-restricted and follow-up questions, and keep the answers out of retrieval.

**S3-2. Adds: three boundaries every drawing must show.** Goes as a new sub-part after "Three kinds of context" (Opus 1.15).

- Astra names three boundaries (Astra) ([Palantir](https://www.palantir.com/docs/foundry/architecture-center/ontology-system); [dbt MCP](https://docs.getdbt.com/docs/dbt-ai/about-mcp); [Ramp](https://support.ramp.com/how-glass-works/)):
  - **Business data versus metadata and evidence.** A catalog record about an inventory table is not current inventory, and a policy passage is not a computed margin.
  - **Read authority versus action authority.** Finding a purchase order, calculating a shortage and changing the order are three different permissions.
  - **Approved knowledge versus agent working memory.** A hypothesis from a conversation must not silently overwrite a corporate definition.

**S3-3. Adds: actions as a component.** Goes in "Consumers" (Opus 1.14).

- Astra treats consumers as "consumers and actions": governed numbers, evidence and permitted operations, ending in audited changes ([GoodData MCP](https://www.gooddata.ai/docs/cloud/ai/mcp-server/); [Palantir actions](https://www.palantir.com/docs/foundry/architecture-center/ontology-system)) (Astra). Write-back to CRM or ERP should be a separate tool with its own authorisation (Astra). Astra advises keeping GoodData's read-only analytical tools apart from its metadata-changing ones.

**S3-4. Adds: identity checks at each boundary.** Goes in "Policy and access control" (Opus 1.10), after the MCP sentence.

- For dbt, "an API token is not automatic identity propagation", so confirm service-account versus end-user authorisation ([dbt setup](https://docs.getdbt.com/docs/use-dbt-semantic-layer/setup-sl)) (Astra). Alation's MCP tool exposure can be scoped; confirm which identity governs discovery and which governs execution ([Alation MCP](https://alation.github.io/agent-studio-docs/integrations/mcp/using-the-mcp-server/)) (Astra). A central catalog does not confer permission to read all catalogued data.

**S3-5. Adds: what context each source must keep.** Goes in "Source systems" (Opus 1.1), as a table after the bullets. Opus covers how sources arrive; Astra covers what must survive the trip.

| Source | Context to preserve (Astra) | Source |
|---|---|---|
| SAP ECC/S/4HANA, Oracle ERP | Material, legal entity, customer, supplier, ledger, document line, posting date, currency, organisational hierarchy | [SAP architecture](https://architecture.learning.sap.com/docs/ai-native-north-star-architecture/foundation-layer) |
| Salesforce and other CRM | Account identity and hierarchy, opportunity/order stage, product, consent and access context | [Salesforce](https://www.salesforce.com/data/connectivity/zero-copy/) |
| Workday and HR | Employee and position identity, organisation, effective dates, sensitive-access boundaries | [Work IQ](https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/work-iq/) |
| Walmart Scintilla (formerly Luminate), other retailer feeds | Retailer item and store, sales/inventory grain, calendar, availability | [Walmart rename, 2024](https://corporate.walmart.com/news/2024/10/02/walmart-data-ventures-signals-growth-at-inspire-announces-new-name-for-insights-ecosystem) |
| NielsenIQ, Circana, SPINS | Licensed taxonomies, market definitions, panel/projection coverage, measure basis, usage rights | [Circana](https://www.circana.com/post/circana-s-liquid-supply-chain-solution-creates-an-inventory-command-center-for-cross-retailer-insigh) |
| Google, Meta, retail media | Campaign, ad and product IDs, spend, exposure, geography, time, attribution definition | [Tesco/L'Oreal case](https://www.dunnhumby.com/wp-content/uploads/2023/10/Tesco-Media-Insight-Platform-Loreal_CaseStudy.pdf) |
| MES, AVEVA PI historians | Asset hierarchy, tag and unit, timestamp, batch, line state, quality, maintenance | [AVEVA PI](https://www.aveva.com/content/dam/aveva/documents/legal/service-documents/AVEVA-PI-Data-Infrastructure.pdf) |
| PLM, WMS, TMS | Specification version, material, lot, warehouse bin, shipment route, status, constraints | [Kinaxis](https://www.kinaxis.com/en/semantic-graph) |

**S3-6. Adds: products missing from the "Example products" column.** Goes in the component table (Opus section 1).

- Metrics engine (row 7): [Kyvos](https://docs.support.kyvosinsights.com/wiki/spaces/KD20269/pages/1496881576/Kyvos%2BModel%2BContext%2BProtocol%2BMCP%2BServer), [GoodData](https://www.gooddata.ai/docs/cloud/ai/mcp-server/), [Honeydew](https://honeydew.ai/blog/honeydew-and-snowflake-semantic-views/) (Astra).
- Ontology/knowledge graph (row 6): [TopBraid EDG](https://docs.topquadrant.com/9.0/user_guide/guidance_specific_to_asset_collection_type/working_with_ontologies/working_with_ontologies.html), [Timbr](https://timbr.ai/doc/docs/getting-started/intro-timbr/), [Neo4j knowledge layer](https://neo4j.com/product/knowledge-layer/) with a virtual graph option (Astra).
- Catalog (row 4): [Snowflake Horizon Context](https://docs.snowflake.com/en/release-notes/2026/other/2026-10-12-horizon-context-preview) (preview), [Databricks Unity Catalog semantics](https://docs.databricks.com/aws/en/uc-semantics/) with domains and certification (Astra).
- Federation (row 3): [Dremio semantic layers](https://docs.dremio.com/current/help-support/well-architected-framework/semantic/) (Astra).
- Memory/work context (new): [Microsoft Work IQ](https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/work-iq/), with API usage billed separately from Copilot (Astra).
- Domain planning models: [Kinaxis semantic graph](https://www.kinaxis.com/en/semantic-graph), [o9 Enterprise Knowledge Graph](https://o9solutions.com/news/o9-named-a-leader-in-the-nucleus-research-scp-technology-value-matrix-2025), [Blue Yonder](https://blueyonder.com/why-blue-yonder/ai-and-machine-learning) (RelationalAI on Snowflake), [RELEX](https://www.relexsolutions.com/unified-merchandising-platform/) (Astra). Compare these with horizontal tools when the decision is planning.

**S3-7. Contradicts: Cube's preferred interface.** Goes in "Metrics / semantic engine" (Opus 1.7), Cube bullet.

- Cube's May 2026 guidance favours its Postgres-compatible Semantic SQL API over the older JSON REST interface for new work ([Cube](https://cube.dev/blog/cube-core-and-cube)) (Astra). Compare open-source Cube Core and the managed product separately; owning the engine still leaves operating work.

**S3-8. Adds: a fifth modelling starting point.** Goes next to the component table, or wherever Opus 2.1's four approaches land.

- Astra adds **application/domain-first**: start from an existing planning, merchandising, CRM or retail-intelligence model, deliver reusable domain data products, and prevent a second inconsistent copy of the same domain model (Astra).

**S3-9. Adds: ownership changes for the MDM and catalog rows.** Goes in "Entity resolution and MDM" (Opus 1.8).

- Informatica is now Salesforce-owned; the acquisition completed in November 2025 ([Salesforce](https://investor.salesforce.com/news/news-details/2025/Salesforce-Completes-Acquisition-of-Informatica/)) (both). SAP's Q3 2026 statement confirms Reltio closed on 7 May 2026, matching Opus ([SAP Q3 2026](https://www.sap.com/docs/download/investors/2026/sap-2026-q3-statement.pdf)) (both). An acquisition is evidence of ownership, not of finished technical integration (Astra).

**S3-10. Adds: SAP's own reference architecture.** Goes in "Ontology / knowledge graph" (Opus 1.6), SAP bullet.

- SAP's October 2026 Architecture Center combines governed data products, semantic models, business metadata and knowledge-graph/ontology capabilities ([SAP architecture](https://architecture.learning.sap.com/docs/ai-native-north-star-architecture/foundation-layer)) (Astra). It is a direction, not proof that each capability is generally available (Astra).

---

### Astra's reference architectures, extracted

Astra labels these "illustrative reference designs", not reconstructions of any named company.

**Architecture A: central analytical foundation for commercial metrics and AI.** Best suited to a manufacturer already consolidating analytical data, starting with sales, revenue growth management and finance ([dbt Semantic Layer](https://docs.getdbt.com/docs/use-dbt-semantic-layer/setup-sl); [Snowflake semantic views](https://docs.snowflake.com/en/user-guide/views-semantic/semantic-view-yaml-spec); [LookML](https://docs.cloud.google.com/looker/docs/what-is-lookml); [Crisp](https://www.gocrisp.com/our-platform)). First product: market/customer/month gross-to-net.

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

**Architecture B: federated business context across a distributed estate.** Best suited to a group with SAP, cloud, regional and acquired systems that cannot be consolidated first ([Denodo](https://www.denodo.com/en/denodo-platform/denodo-platform); [Starburst](https://www.starburst.io/blog/starburst-galaxy-ai-on-iceberg-foundations/); [Stardog](https://docs.stardog.com/virtual-graphs/); [Timbr](https://timbr.ai/doc/docs/getting-started/intro-timbr/); [Alation MCP](https://alation.github.io/agent-studio-docs/integrations/mcp/using-the-mcp-server/)). First product: a cross-market inventory and service view.

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

**Architecture C: operational ontology for manufacturing and supply decisions.** Best suited to traceability, production exceptions, shortages or planning scenarios needing live state and controlled actions ([Palantir Ontology](https://www.palantir.com/docs/foundry/architecture-center/ontology-system); [Kinaxis](https://www.kinaxis.com/en/semantic-graph); [o9](https://o9solutions.com/news/o9-named-a-leader-in-the-nucleus-research-scp-technology-value-matrix-2025); [P&G](https://www.microsoft.com/en/customers/story/25077-procter-and-gamble-iot-operations); [AVEVA PI](https://www.aveva.com/content/dam/aveva/documents/legal/service-documents/AVEVA-PI-Data-Infrastructure.pdf)). First product: find orders hit by a constrained line or suspect batch, explain the path and propose an authorised fix.

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

### How Astra's three differ from Opus's three

1. Opus organises by modelling approach (A metrics-first, B ontology for agents) plus one combined CPG blueprint (C); Astra organises by client situation: consolidated, distributed, operational.
2. Astra A matches Opus A closely, but adds a context/tool gateway carrying user identity and an answer that returns definition, evidence and timestamp.
3. Astra A says a client with a mature native model may not need a second metric engine; Opus A assumes one metric engine as the hub.
4. Astra B is federation-first with selective caching and domain semantic services; Opus has no federation-first design, and Opus B mixes copy, federate, share and stream.
5. Astra B separates a metadata catalog from a mapping and relationship registry; Opus B puts entities, rules and bindings in one ontology service.
6. Astra B asks the drawing to show failure behaviour: stale cache, partial response or explicit refusal. Opus does not draw failure modes.
7. Astra C is domain-scoped to manufacturing and supply; Opus C is enterprise-wide across marketing, RGM, supply chain and manufacturing.
8. Astra C draws a full action loop with approval, audited command and outcome feedback; Opus B has an action service but no approval or feedback path.
9. Opus is source- and contract-specific: SAP Note 3255746, BDC pricing, Walmart data terms, GS1 crosswalks. Astra names none of these.
10. Astra is control-specific: identity at every boundary, separate read and action rights, and approved knowledge kept apart from agent memory.
