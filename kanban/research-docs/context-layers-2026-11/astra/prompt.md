# Research brief: context layers and semantic layers (as of November 2026)

You are doing deep, independent market research for a consultant who advises very large consumer goods and
retail companies (think Unilever, IKEA, Nestle, P&G, Mars, Diageo, Walmart) on AI and data. He wants to
understand EXACTLY what is in the market for "context layers" and "semantic layers", so he can advise
clients. Be as deep and specific as you can. Today is 2026-11-16; prefer 2025-2026 sources and say when a
source is older.

## Terms in scope
- **Semantic layer**: a governed layer of business definitions (metrics, dimensions, entities, joins) that
  sits between data and the tools/people/AI that use it, so "net revenue" means one thing everywhere.
  E.g. dbt Semantic Layer / MetricFlow, Cube, AtScale, Looker LookML, Power BI / Microsoft Fabric semantic
  models, Snowflake semantic views / Cortex Analyst, Databricks metric views / Unity Catalog, SAP Datasphere /
  SAP Business Data Cloud, Google Looker / BigQuery, Kyvos, GoodData, Honeydew, the Open Semantic Interchange
  (OSI) initiative, etc.
- **Context layer** (newer, AI-agent era term): the layer that gives AI agents the business context they need
  (definitions, lineage, ownership, documents, policies, decisions, memory, permissions), often via MCP, a
  knowledge graph, an ontology, a catalog, or a "context graph". E.g. Palantir Ontology, Atlan, Collibra,
  Alation, data.world (ServiceNow), Glean, Microsoft Fabric IQ / Work IQ, Salesforce Data Cloud / Agentforce,
  Snowflake Horizon, Neo4j, Stardog, TopBraid, Timbr, enterprise "context engineering", plus company-built ones
  (Uber's context graph, Ramp's memory pipeline, Shopify's agent monorepo, etc.).
- Also adjacent: knowledge graphs/ontologies, data catalogs and business glossaries, MDM (master data
  management, e.g. Reltio, Informatica, Stibo, Profisee, SAP MDG), data virtualisation / federation (Denodo,
  Starburst/Trino, Dremio), data products/data mesh, retail and CPG data platforms (e.g. Crisp, SPINS, NielsenIQ
  connect, Circana Liquid Data, o9, Kinaxis, Blue Yonder, Relex) where they provide a semantic/context model.

## Questions to answer (answer every one)
1. What are companies using context layers / semantic layers FOR? Break down by function: advertising and
   marketing (media mix, retail media, customer 360), sales / revenue growth management, supply chain and demand
   planning, manufacturing / OT / quality, finance, HR, and AI agents / copilots / text-to-SQL. Name real
   companies with real examples.
2. HOW are they creating them? Tools, team structure, steps, modelling approach (metrics-first vs ontology-first
   vs catalog-first vs knowledge-graph-first), use of LLMs to bootstrap definitions.
3. How do they think it will improve their business in the long run? Stated goals, measured results (accuracy of
   AI answers with vs without a semantic layer, time saved, cost saved, revenue), and the sceptical view.
4. How much TIME did it take to create? Find named case studies with timelines, team sizes, phases (pilot ->
   first domain -> enterprise).
5. Do they STORE all the data in one place (copy into a lakehouse/warehouse) or CONNECT to it where it lives
   (virtualisation, federation, zero-copy sharing, MCP connectors)? Who does which, trade-offs, and the hybrid
   reality.
6. Do they need a DATA DICTIONARY / business glossary / canonical model / ontology to translate data from many
   systems (SAP, Salesforce, retailer POS feeds, media platforms, MES) into one definition used across
   advertising, marketing, supply chain, manufacturing? How is that translation done in practice (mapping,
   entity resolution, MDM golden records, metric definitions as code, ontology mapping, LLM-assisted mapping)?
   Who owns it?
7. COST for large enterprises (Unilever / IKEA / Nestle scale, $10bn-$60bn revenue, many countries): licence
   pricing models and published list prices where they exist, typical annual contract values (from Vendr,
   AWS/Azure/GCP marketplace listings, analyst reports, public contracts, earnings calls, case studies),
   implementation/SI costs, internal team costs, cloud compute. Give ranges and say how you estimated them.
8. ARCHITECTURE: what components are needed (sources, ingestion/connectors, storage or virtualisation,
   catalog/metadata, glossary/ontology, metric/semantic engine, entity resolution/MDM, knowledge graph, vector
   index / retrieval, policy and access control, lineage, APIs: SQL/REST/GraphQL/MDX/MCP, consumers: BI, apps,
   AI agents), what are the inputs and outputs, and what systems they typically connect to (SAP S/4HANA, ECC,
   Salesforce, Oracle, Workday, retailer data like Walmart Luminate/Scintilla, Nielsen/Circana, Google/Meta
   ads, MES/historians like OSIsoft PI/AVEVA, PLM, WMS/TMS). Describe 2-3 reference architectures in enough
   detail to draw (boxes and arrows, in text).
9. CPG / retail specifics: what have Unilever, Nestle, IKEA (Ingka), P&G, Mars, Diageo, PepsiCo, Coca-Cola,
   Walmart, Tesco, L'Oreal, Kraft Heinz, Mondelez etc. publicly said or done on semantic layers, knowledge
   graphs, ontologies, data products, or context for AI? (e.g. Unilever and Palantir? Nestle and SAP? IKEA's
   data platform? P&G and Microsoft?) Only what you can source.

## Rules
- **Every claim needs a link** to the page you got it from. Open the page; do not cite from a search snippet.
  Put the URL inline next to the claim AND in a full source list at the end.
- Label vendor marketing numbers as vendor claims. Say when something is your estimate and how you made it.
- Note disagreements between sources. Note what you could not find.
- No padding, no generic definitions beyond what is needed. Specific names, numbers, dates.
- Write in plain English, British spelling.


## Your output
Write your full report as markdown to /home/david/projects/claude-code-setup/kanban/research-docs/context-layers-2026-11/astra/report.md (create the file; overwrite if present). Aim for depth: 8,000-15,000 words, organised by the 9 questions, then the reference architectures as text box-and-arrow descriptions, then a full numbered source list with every URL. Use live web search extensively (many dozens of searches and page opens). When done, reply with only the path and a 5-line summary.
