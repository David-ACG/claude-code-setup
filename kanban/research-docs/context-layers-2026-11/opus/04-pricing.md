# 04 - What a semantic / context layer costs at Unilever, Nestle or IKEA scale

Research slice: brief question 7 (cost). Researched 2026-11-16. Scope: companies with roughly $25bn-$100bn
revenue, 100+ countries, tens of thousands of data users.

**How to read the numbers.** Every figure is tagged:

- **[S]** sourced: I opened the page (or queried the official API) and the URL is next to it.
- **[D]** derived: simple arithmetic on sourced numbers; the sum is shown.
- **[E]** my estimate: the method is stated. Estimates are deliberately given as ranges.

**Currency.** Conversions use an assumed £1 = $1.30 and €1 = $1.13 **[E, assumption, not sourced]**. Change
these and the dollar totals move proportionally.

**Biggest caveat.** Vendr medians below come mostly from mid-market buyers (Vendr itself describes the
typical Atlan deal as 10-75 users). A Global 2000 consumer goods company buys far more seats, connectors and
modules, so its licence lines sit well above those medians; it also gets larger percentage discounts. Treat
Vendr as a floor and a discount signal, not as the answer.

---

## 1. Headline answer

| Option (what you buy) | Licences / yr | Extra cloud compute / yr | SI implementation (3 yrs) | Internal team / yr | **3-year TCO** |
|---|---|---|---|---|---|
| **A. Lean semantic layer on the existing lakehouse** (metrics as code + BI/AI-facing semantic engine + Cortex Analyst / Genie; catalog = Unity Catalog / Horizon you already own) | $0.6m-$2.0m | $0.5m-$1.5m | $3.3m-$8.6m | $1.6m-$3.6m (12-20 FTE) | **$11m-$30m** |
| **B. Full catalog + semantic layer + knowledge graph** (Collibra/Alation/Atlan class catalog, A's semantic layer, a graph database) | $1.7m-$5.5m | $0.8m-$2.5m | $7.5m-$17.2m | $3.9m-$9.0m (30-50 FTE) | **$27m-$68m** (plus optional MDM $3m-$9m and enterprise search $8m-$12m) |
| **C. Palantir-style ontology platform** (Foundry/AIP licence, Palantir engineers, a partner SI) | $4m-$19m | $1m-$4m | $10.7m-$26.8m | $2.0m-$5.4m (15-30 FTE) | **$32m-$112m** |

All rows are **[E]**, built in section 7 from the sourced unit prices in sections 2-6. Per data user (40,000
users assumed), that is roughly $95-$250 a user a year for A, $220-$570 for B and $260-$930 for C **[D]**.

Three things drive the spread more than the product choice:

1. **Whether the platform bill is already paid.** Option A is cheap only because the warehouse/lakehouse
   (Snowflake, Databricks, Fabric, BigQuery) already exists. The average Snowflake Global 2000 customer
   already spends about $2.55m a year on Snowflake alone **[D, section 4]**.
2. **People, not software.** In A and B the SI and internal team are 55-70% of the 3-year cost **[D]**.
   Only in C does the licence dominate.
3. **Negotiation.** Palantir's own UK list price for one platform licence is £3.43m a year **[S]**, while a
   negotiation adviser reports a mid-size Palantir deal landing at $2.6m-$3.2m in year one after scoping
   **[S, vendor-adviser claim]**. The same software can be a 2-3x price difference.

---

## 2. Price table by product

"List / published" means a vendor page, a cloud marketplace listing, a UK G-Cloud pricing document or a
vendor legal price table. "Reported contract" means Vendr (anonymised buyer transactions) unless stated.

| Product | Pricing model | Published / list price | Reported contract values | Source quality |
|---|---|---|---|---|
| **dbt Platform (dbt Cloud) incl. Semantic Layer** | Per developer seat + usage (models built, queried metrics) | Starter $100/seat/month, 5 seats, 5,000 queried metrics/month; Enterprise custom with 20,000 queried metrics/month and Semantic Layer included **[S]** [getdbt.com/pricing](https://www.getdbt.com/pricing) | Vendr median $27,930/yr (range $14,560-$102,800, n=156); Enterprise seats $200-$400/month, large teams (25-100+ seats) $100k-$400k+/yr **[S]** [vendr.com/marketplace/dbt-cloud](https://www.vendr.com/marketplace/dbt-cloud) | Good |
| **Cube Cloud** | Per developer/user seat + hourly deployments | Starter $40/dev/month; Premium $80/dev/month, Explorer $40, Viewer $20, dedicated deployment $1.20/hr, multi-cluster $1.20/hr/cluster; Enterprise custom **[S]** [cube.dev/pricing](https://cube.dev/pricing) | Vendr median $37,200/yr (range $16,679-$91,800, n=35); enterprise cloud $10k-$25k+/month; self-hosted enterprise $25k-$100k+/yr **[S]** [vendr.com/marketplace/cube-dev](https://www.vendr.com/marketplace/cube-dev) | Good |
| **AtScale** | Deployed semantic objects (DSO) per month; not users, data or queries | "as little as $2,500 per month"; average model ~250 objects, so a 12-month deal = 3,000 DSO; volume discounts (June 2024) **[S]** [atscale.com blog](https://www.atscale.com/?p=23750) | Not on Vendr; no marketplace price found | Weak (older, no unit price) |
| **Kyvos** | Per core-hour or annual subscription | Marketplace $0.41/core-hour (your cloud); managed $0.61/core-hour; customer-environment annual subscription "starts at $48K" **[S]** [kyvosinsights.com/pricing](https://www.kyvosinsights.com/pricing/) | Not on Vendr | Good for entry price |
| **Looker (Google Cloud core)** | Platform edition + per-user licences (Developer, Standard, Viewer) | Every edition "Call sales"; each platform includes 10 Standard + 2 Developer users; Gemini overage $3.00 / $20.00 per 1M input/output data tokens **[S]** [cloud.google.com/looker/pricing](https://cloud.google.com/looker/pricing) | Not found on Vendr | No list price exists |
| **Power BI / Microsoft Fabric** | Per user (Pro, PPU) or capacity (F SKU, capacity units) | Pro $14/user/month, PPU $24/user/month; F64+ lets viewers consume without a paid licence only in "App Owns Data" embedding; Pro still needed to publish **[S]** [microsoft.com Power BI pricing](https://www.microsoft.com/en-us/power-platform/products/power-bi/pricing). Fabric capacity: $0.18/CU-hour PAYG East US, $0.22 West Europe; reserved 1-yr $938/CU/yr East US, $1,146 West Europe, $1,094 UK South **[S]** [Azure Retail Prices API](https://prices.azure.com/api/retail/prices?$filter=serviceName%20eq%20%27Microsoft%20Fabric%27%20and%20armRegionName%20eq%20%27westeurope%27) | F512 reserved West Europe = $586,752/yr; F1024 = $1,173,504/yr; F2048 = $2,347,008/yr **[D]** (CU x $1,146) | Excellent (official API) |
| **Snowflake (incl. Cortex Analyst, semantic views)** | Credits (compute), TB/month (storage), AI credits | On-demand credit: Enterprise $3.00 (AWS US East), $3.90 (EU Dublin/Frankfurt), $4.00 (London); Business Critical $4.00 / $5.20 / $5.40. Storage $23/TB/month on demand, falling to $13.80 at $40m+ ACV. **Cortex Analyst = 67 credits per 1,000 messages** (API). AI credits $2.00 global on demand, $1.88 at $40m+ ACV. Table effective 12 Nov 2026 **[S]** [Snowflake Service Consumption Table PDF](https://www.snowflake.com/legal-files/CreditConsumptionTable.pdf) | Vendr median $100,000/yr (range $20,000-$600,000, n=741) **[S]** [vendr.com/marketplace/snowflake](https://www.vendr.com/marketplace/snowflake) | Excellent |
| **Databricks (Unity Catalog, metric views, Genie)** | DBUs by workload + cloud infra | Azure Databricks Premium, West Europe: Serverless SQL $0.91/DBU, SQL Pro $0.72, Jobs $0.30, All-purpose $0.55, Serverless Jobs $0.50, Model Serving $0.084 **[S]** [Azure Retail Prices API](https://prices.azure.com/api/retail/prices?$filter=serviceName%20eq%20%27Azure%20Databricks%27%20and%20armRegionName%20eq%20%27westeurope%27%20and%20type%20eq%20%27Consumption%27). Genie: "Free usage applies to Genie LLM usage only; Genie compute (e.g., SQL Serverless) is billed separately" **[S]** [databricks.com/product/pricing/genie](https://www.databricks.com/product/pricing/genie) | Vendr median $340,500/yr (range $31,050-$2,116,400, n=211) **[S]** [vendr.com/marketplace/databricks](https://www.vendr.com/marketplace/databricks) | Good |
| **SAP Datasphere / Business Data Cloud** | Capacity Units (CU), bought in monthly blocks | No CU price published ("price upon request"). Consumption rates: Datasphere foundation tenant 0.926 CU/hour; memory-optimised compute 0.570 CU per 16 GB/hour; object store 0.103 CU per TB/hour; "Customer-Managed Data Products" needs a minimum 640 CU BDC Core attach (SAP deck, 16 Apr 2026) **[S]** [SAP user group deck](https://assets.dm.ux.sap.com/sap-user-groups/pdfs/260416_breaking_down_the_sap_bdc_pricing_model.pdf) | Vendr "SAP" overall median $29,293 (not product-specific) **[S]** [vendr.com/marketplace/sap](https://www.vendr.com/marketplace/sap) | Weak (no CU price) |
| **Palantir Foundry / AIP** | Annual platform + capability licences; legacy usage blocks; engineers per quarter | UK G-Cloud 15 publisher list (Jan 2026): Platform licence **£3,428,840/yr**; Capability licence S/M/L £1,863,500 / £3,727,000 / £5,590,500 per yr; Sustain S/M/L £1,304,450 / £2,608,900 / £3,913,350; Discovery packages £50k / £125k / £250k (up to 3 months); Pilot licences £50k-£500k; **Implementation & Engineering £175,000 per person per quarter**; use-case maintenance £22,362 / £44,724 / £67,086 per quarter; trial £1 **[S]** [Palantir Platform pricing document](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-15/documents/92736/580753378939715-pricing-document-2026-01-29-1207.pdf); same engineer and maintenance rates in [Palantir Cloud Support pricing](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-15/documents/92736/548190771584049-pricing-document-2026-01-29-1233.pdf) | Adviser example: Palantir "opens at $4,000,000 a year for 600 users", year one after scoping $2.6m-$3.2m; fees for comparable deployments differ by 2-3x (Redress Compliance, updated 24 Sep 2026) **[S, adviser claim]** [redresscompliance.com](https://redresscompliance.com/palantir-aip-foundry-negotiation) | Excellent for list; contract values thin |
| **Atlan** | Per user per year, tiered | Via reseller InterWorks on G-Cloud: Advanced £110,000/yr, Enterprise £300,000/yr (sheet dated 20 Feb 2025) **[S]** [InterWorks Atlan pricing sheet](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-15/documents/703311/504408645525601-pricing-document-2026-01-21-1203.pdf) | Vendr median $50,420/yr (range $30,078-$177,847, n=44); 75+ users $1,000-$1,800/user/yr; enterprise often >$150k **[S]** [vendr.com/marketplace/atlan](https://www.vendr.com/marketplace/atlan) | Good |
| **Collibra** | Platform subscription + modules | AWS Marketplace: "Collibra Cloud Platform" $170,000 per 12 months **[S]** [AWS listing](https://aws.amazon.com/marketplace/pp/prodview-6gqg3yc2e2rsu) | Vendr median $197,142/yr (range $174,740-$225,360) **[S]** [vendr.com/marketplace/collibra](https://www.vendr.com/marketplace/collibra). US ICE order (May 2026): $612.3k obligated, up to $3.31m over 5 years **[S]** [HigherGov](https://www.highergov.com/contract/NNG15SD11B-70CTD026FR0000023/) | Good |
| **Alation** | Platform + users + connectors | AWS Marketplace: Data Catalog subscription "starting at" $60,000 per 12 months **[S]** [AWS listing](https://aws.amazon.com/marketplace/pp/prodview-ylge6fq43dtg6) | Vendr median $141,394/yr (range $77,526-$302,223) **[S]** [vendr.com/marketplace/alation](https://www.vendr.com/marketplace/alation) | Good |
| **data.world (ServiceNow)** | Not published | Nothing found | Vendr page has no figures | Not found |
| **Glean** | Per user per year + FlexCredits for agents | No public price | Vendr median $99,080/yr (range $30,240-$209,265, n=175) **[S]** [vendr.com/marketplace/glean](https://www.vendr.com/marketplace/glean). Third-party estimate $45-$50/seat + $15 for AI, possible 100-seat minimum (unconfirmed) **[S, third-party]** [activepieces.com](https://www.activepieces.com/blog/glean-pricing-in-2026-cost-seats-and-minimums) | Weak for per-seat |
| **Salesforce Data Cloud (Data 360)** | Flex Credits or Profiles | $500 per 100k Flex Credits; Profiles $240 per 1k profiles/yr; Enterprise Profiles $420 per 1k/yr; ingestion free **[S]** [salesforce.com/data/pricing](https://www.salesforce.com/data/pricing/) | Not found | Good (multipliers in a PDF not parsed) |
| **Neo4j** | AuraDB per GB-hour; self-managed per core | AuraDB Professional from $0.09/GB/hour; Business Critical from $0.20/GB/hour **[S]** [neo4j.com/pricing](https://neo4j.com/pricing/) | Vendr median $277,500/yr (range $66,400-$912,000); self-managed Enterprise $3,000-$6,000/core list **[S]** [vendr.com/marketplace/neo4j](https://www.vendr.com/marketplace/neo4j) | Good |
| **Stardog** | Quote only | No prices on page **[S]** [stardog.com/pricing](https://www.stardog.com/pricing/) | Not found | Not found |
| **Denodo** | Per CPU core per year, or hourly | AWS Marketplace (Carahsoft, private offer): Enterprise Plus $71,550 per core per year; Enterprise $61,250 **[S]** [AWS listing](https://aws.amazon.com/marketplace/pp/prodview-l4ka25qk7iktk) | Vendr median $107,200/yr (range $101,560-$119,284) **[S]** [vendr.com/marketplace/denodo](https://www.vendr.com/marketplace/denodo) | Good |
| **Starburst** | Credits | Galaxy Pro $0.50, Enterprise $0.75, Mission-Critical $1.00 per credit ("starting at") **[S]** [starburst.io/pricing](https://www.starburst.io/pricing/) | Vendr median $43,962/yr (range $27,370-$57,888) **[S]** [vendr.com/marketplace/starburst-data](https://www.vendr.com/marketplace/starburst-data) | Good |
| **Informatica IDMC (incl. MDM, catalog)** | Informatica Processing Units (IPU) | AWS Marketplace: 120 IPU/month for $131,760 per 12 months (= $1,098 per IPU-year) **[S]** [AWS listing](https://aws.amazon.com/marketplace/pp/B08HG79CJ9) | Vendr median $56,250/yr (range $10,753-$252,657, n=36) **[S]** [vendr.com/marketplace/informatica](https://www.vendr.com/marketplace/informatica) | Good |
| **Reltio (MDM)** | Per edition / profiles | AWS Marketplace: $15,600/month per industry edition (1-month contract) **[S]** [AWS listing](https://aws.amazon.com/marketplace/pp/B08CMWJ1XL) | Vendr median $393,333/yr (range $300,244-$690,233) **[S]** [vendr.com/marketplace/reltio](https://www.vendr.com/marketplace/reltio) | Good |
| **Stibo Systems (MDM/PIM)** | Not published | Nothing found | Vendr median $97,391/yr (range $26,213-$99,832) **[S]** [vendr.com/marketplace/stibo-systems](https://www.vendr.com/marketplace/stibo-systems) | Medium |
| **GoodData** | Platform fee + workspaces (Professional); custom (Enterprise) | No figures published; Enterprise lists MCP server, ontology extraction, knowledge graphs, 30 AI queries/user/day fair use **[S]** [gooddata.ai/pricing](https://www.gooddata.ai/pricing/) | Vendr median $223,000/yr (range $65,310-$243,887) **[S]** [vendr.com/marketplace/gooddata](https://www.vendr.com/marketplace/gooddata) | Medium |

Useful unit costs derived from the table **[D]**:

- **Cortex Analyst** costs 67 credits per 1,000 messages, so at $3.90 per credit (EU, Enterprise, on demand)
  one question costs about **$0.26**, before the warehouse compute that runs the generated SQL. 5,000 users
  asking 20 questions a month = 1.2m messages = 80,400 credits = **$313,560 a year**; 20,000 users = $1.25m.
- **Power BI Pro** for 30,000 report authors and viewers at list = $5.04m a year; 50,000 = $8.4m. Large
  companies often already hold Pro through Microsoft 365 E5, so this is usually a sunk cost (not verified for
  any named company).
- **Neo4j AuraDB Business Critical** at $0.20/GB-hour: 64 GB = $112k a year; 256 GB = $449k; 512 GB = $897k.
- **Denodo Enterprise Plus** at $71,550 per core: 16 cores = $1.14m a year; 32 cores = $2.29m (list).

---

## 3. Public-sector awards that reveal real prices

| Buyer | Supplier / product | Value | What it tells you | Source |
|---|---|---|---|---|
| NHS England | Palantir-led consortium (Accenture, PwC, NECS, Carnall Farrar), Federated Data Platform | £330m over 7 years; £25.6m in year one; original tender capped at £480m | ~£47m/yr average **[D]**: an enterprise-wide, multi-organisation ontology platform, licences plus services, at national scale | [The Register, 22 Nov 2023](https://www.theregister.com/2023/11/22/palantir_wins_nhs_contract/) (older source) **[S]** |
| US Army | Palantir Enterprise Agreement | Ceiling up to $10bn over 10 years; replaces 75 contracts | A ceiling, not committed spend; shows how big buyers consolidate Palantir into one volume-discounted agreement | [The Register, 1 Aug 2025](https://www.theregister.com/2025/08/01/palantir_us_army_contract/) **[S]** |
| US ICE (DHS) | Collibra via GovSmart | $612.3k obligated; up to $3.31m over 5 years (May 2026-May 2031) | ~$660k/yr **[D]** for a large single-agency Collibra deployment, 3x the Vendr median | [HigherGov](https://www.highergov.com/contract/NNG15SD11B-70CTD026FR0000023/) **[S]** |
| UK public sector (framework list) | Palantir Platform, G-Cloud 15 | Platform licence £3.43m/yr; engineers £175k/person/quarter | The only official Palantir list prices I found | [G-Cloud pricing doc](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-15/documents/92736/580753378939715-pricing-document-2026-01-29-1207.pdf) **[S]** |

Not found: any EU TED award naming Atlan, Alation, dbt Labs, Cube, AtScale or Neo4j with a value; any
published contract value for Unilever, Nestle or Ingka with any of these vendors.

---

## 4. What earnings disclosures say about spend at the top end

| Company | Disclosure | Figure | Source |
|---|---|---|---|
| Palantir | Customers (trailing 12 months), 30 Sep 2026 | 1,090 (911 a year earlier) | [Palantir 10-Q Q3 2026](https://www.sec.gov/Archives/edgar/data/0001321655/000132165526000048/pltr-20260930.htm) **[S]** |
| Palantir | Average revenue from top 20 customers, TTM | **$146m**, up 76% from $83m | same **[S]** |
| Palantir | Q3 2026 revenue / commercial revenue | $2,313.4m / $1,167.9m; RPO $4.9bn | same **[S]** |
| Snowflake | Customers with >$1m TTM product revenue, 31 Jul 2026 | 828 (up 27%); 829 Forbes Global 2000 customers | [SaaStr on Q2 FY27](https://www.saastr.com/5-interesting-learnings-from-snowflake-at-6-billion-in-revenue-37-growth-and-accelerating-126-nrr-and-a-gross-margin-guided-down-to-pay-for-ai/); [press release mirror](https://www.01net.it/snowflake-reports-financial-results-for-the-second-quarter-of-fiscal-2027/) **[S]** |
| Snowflake | Global 2000 share of revenue, FY26 | 790 G2K customers = ~43% of revenue; FY26 revenue $4,683.9m | [Snowflake 10-K FY26](https://www.sec.gov/Archives/edgar/data/1640147/000164014726000008/snow-20260131.htm); [Q4 FY26 release](https://investors.snowflake.com/news/news-details/2026/Snowflake-Reports-Financial-Results-for-the-Fourth-Quarter-and-Full-Year-of-Fiscal-2026/default.aspx) **[S]** |
| Snowflake | **Average spend per Global 2000 customer** | 0.43 x $4,683.9m / 790 = **~$2.55m a year** | **[D]** |
| Databricks | Run-rate, Aug 2026 | >$7bn, >80% growth; >1,000 customers above $1m run-rate; >100 above $10m | [ITBrief UK, 14 Aug 2026](https://itbrief.co.uk/story/databricks-tops-usd-7-billion-run-rate-after-funding) **[S]** (press, not a Databricks release) |

What this means for a Unilever/Nestle/IKEA estimate **[E]**: a company of that size is likely to be at or
above the Snowflake G2K average ($2.55m) and plausibly in Databricks' ">$10m" group if the lakehouse is its
main platform. So the platform bill is typically $3m-$15m a year before any semantic or context layer. I use
that baseline to size incremental compute in section 7.

---

## 5. Systems integrator rates

### UK, official framework rate cards (maximum day rates, ex VAT, 8-hour day)

| Role | Accenture onshore / offshore **[S]** | Deloitte (by civil-service grade) **[S]** | Capgemini SFIA, solution development, onshore / offshore **[S]** |
|---|---|---|---|
| Data engineer / SFIA 3 | £900 / £275 | SEO: £1,275 standard, £1,405 specialist | £742 / £220 |
| Senior data engineer / SFIA 4 | £1,350 / £375 | SEO-G7: £1,480 / £1,630 | £1,006 / £311 |
| Lead data engineer / SFIA 5 | £1,850 / £495 | G7: £1,530 / £1,685 | £1,186 / £383 |
| Data architect / senior / chief | £1,350 / £1,850 / £2,500 (offshore £375 / £495 / £595) | G6: £1,950 / £2,145 | Strategy & architecture SFIA 5-6: £1,750-£2,040 |
| Head of data governance | £2,500 / £595 | SCS: £2,125 / £2,340 | SFIA 7: £2,300 / £703 |
| Delivery manager / programme delivery manager | £1,250 / £1,750 | - | - |
| Offshore range | £150-£650 | £355-£665 | £87-£703 |

The rates are sourced; lining up Accenture role names, Deloitte civil-service grades and Capgemini SFIA levels
in one row is my own mapping **[E]**.

Sources: [Accenture G-Cloud 15 pricing, Jan 2026](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-15/documents/92191/803363878013083-pricing-document-2026-01-27-0141.pdf);
[Deloitte G-Cloud 15 standard rate card, Jan 2026](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-15/documents/92485/529273508070625-pricing-document-2026-01-21-1421.pdf);
[Capgemini G-Cloud 14 SFIA rate card, Nov 2024](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-14/documents/92224/577322578103483-pricing-document-2024-04-22-1124.pdf)
(older; the Capgemini G-Cloud 15 listing I opened had no pricing document).

Palantir's own engineers: **£175,000 per person per quarter = £700k (~$910k) per person-year** **[S/D]**, roughly
2x an Accenture lead data engineer billed full time onshore (£1,850 x 220 days = £407k) **[D]**.

### US, GSA schedule ceiling rates (federal; hourly; queried 16 Nov 2026)

Median ceiling rate for labour categories containing "data", "architect", "engineer" or "scien" **[S/D]**,
from the [GSA CALC API](https://api.gsa.gov/acquisition/calc/v3/api/ceilingrates/?keyword=accenture):

| Firm (federal entity) | Rows | Median $/hr | p10-p90 $/hr | Approx $/day (x8) |
|---|---|---|---|---|
| Accenture Federal Services | 328 | $209 | $133-$310 | $1,674 |
| Deloitte (Consulting, D&T, FAS) | 57 | $293 | $248-$372 | $2,344 |
| Cognizant Government Solutions | 80 | $243 | $141-$373 | $1,946 |
| Tata America International (TCS) | 34 | $228 | $181-$269 | $1,826 |
| Infosys Public Services | 13 | $171 | $124-$216 | $1,364 |
| Capgemini Government Solutions | 6 | $133 | $84-$257 | $1,066 (small sample) |

These are federal ceilings for onshore staff; commercial onshore US rates for the same firms are usually not
lower. Offshore India rates do not appear on GSA.

### Independent contractors (UK benchmark)

UK contract adverts, 6 months to 16 Nov 2026: data architect median **£625/day** (p10 £463), data engineer
median **£500/day** (p10 £370) **[S]** [ITJobsWatch data architect](https://www.itjobswatch.co.uk/contracts/uk/data%20architect.do), [ITJobsWatch data engineer](https://www.itjobswatch.co.uk/contracts/uk/data%20engineer.do).
That is about half the big-four onshore rate.

### Blended rate used in the model **[E]**

- Mix: 30% onshore at ~£1,300/day (between Accenture senior and Deloitte SEO, above Capgemini SFIA 4-5) and
  70% offshore at ~£400/day (Accenture senior offshore £375 to lead £495; Capgemini SFIA 4-5 £311-£383).
- Blended maximum = £670/day = **$871/day**. Applying a 25% negotiated discount off framework maxima gives
  **$653/day**. Both rates are used (low and high cases). 220 billable days per FTE-year.
- No published source gives typical discounts off these framework maxima; 25% is my assumption, in line with
  Vendr's "20-30% below initial proposals" for software deals ([Vendr Atlan](https://www.vendr.com/marketplace/atlan)).

---

## 6. Internal team: roles and salary bands

| Role | UK (median; p10-p90), permanent adverts, 6 months to 16 Nov 2026 **[S]** | Netherlands (Michael Page 2026, gross incl. holiday pay) **[S]** | US (BLS OEWS May 2025, national) **[S]** |
|---|---|---|---|
| Data / analytics engineer | £70,000 (£45,000-£100,000) | €70k-€90k medior; €90k+ senior | - |
| Data / semantic architect | £90,000 (£63,744-£112,500); outside London £80,000 | €90k-€110k medior; €110k+ senior | Database architects median $139,500 (p10 $86,240; p90 $204,000) |
| Adverts mentioning "semantic layer" | £75,000 (£51,500-£112,500) | - | - |
| Data governance manager / steward lead | £68,658 (£40,000-£110,000) | MDM €65k-€80k; €80k+ senior | - |
| Data scientist / ML engineer | - | €80k-€100k; €100k+ | Data scientists median $120,230 (p10 $67,240; p90 $199,130) |
| Enterprise architect | - | €100k-€120k; €120k+ | - |
| Platform lead / data director | - | Programme manager €110k+; Head of IT €120k+ | Computer & IS managers median $175,140 |

Sources: [ITJobsWatch data architect](https://www.itjobswatch.co.uk/jobs/uk/data%20architect.do),
[data engineer](https://www.itjobswatch.co.uk/jobs/uk/data%20engineer.do),
[semantic layer](https://www.itjobswatch.co.uk/jobs/uk/semantic%20layer.do),
[data governance manager](https://www.itjobswatch.co.uk/jobs/uk/data%20governance%20manager.do);
[Michael Page Netherlands Salary Guide 2026](https://static.ie.edu/CMC/Career%20Education/Career%20Website/MARKET%20OVERVIEW/Salary%20guides%202026/Netherlands%20Salary%20Guide%202026%20-%20Michael%20Page.pdf) (p.11);
BLS OEWS via the official API, e.g. [database architects median](https://api.bls.gov/publicAPI/v1/timeseries/data/OEUN000000000000015124313),
[10th pct](https://api.bls.gov/publicAPI/v1/timeseries/data/OEUN000000000000015124311),
[90th pct](https://api.bls.gov/publicAPI/v1/timeseries/data/OEUN000000000000015124315),
[data scientists median](https://api.bls.gov/publicAPI/v1/timeseries/data/OEUN000000000000015205113),
[IS managers median](https://api.bls.gov/publicAPI/v1/timeseries/data/OEUN000000000000011302113)
(series pages on bls.gov did not render; the API values are the official OEWS figures).

**Loaded cost per FTE used in the model [E]:** salary x 1.3 for employer social charges, pension, benefits
and bonus (assumption). UK senior £90k -> ~$152k; NL senior €100k -> ~$147k; US architect $139.5k -> ~$181k.
Blended **$130k-$180k per FTE-year**; the low end assumes part of the team sits in a lower-cost global
capability centre (not sourced for any named company).

**Typical team shapes [E]** (from the roles the vendor and SI rate cards price, not from a named case study):

- Option A, 12-20 FTE: product owner, 2 semantic/analytics architects, 6-10 analytics engineers, 1-2 platform
  engineers, 2-4 domain metric owners (part-time business leads not counted).
- Option B, 30-50 FTE: A plus catalog/governance office (4-6), domain data stewards (8-15), ontologist /
  knowledge-graph engineers (2-4), MDM analysts (2-4), AI/agent engineers (3-5).
- Option C, 15-30 FTE: ontology/product owners per domain, Foundry developers learning from Palantir FDEs,
  data integration engineers; smaller because Palantir and the partner do more of the build.

---

## 7. Costed estimate for a Unilever / Nestle / IKEA-scale programme

### Scenario assumptions **[E]**

- 40,000 data consumers, ~5,000 active AI/analyst users, 300-800 data and analytics engineers already
  employed; 10-15 business domains (sales/RGM, marketing and media, supply chain, manufacturing, finance, HR,
  sustainability...); several SAP ERP instances plus Salesforce, retailer feeds and media platforms.
- An existing lakehouse/warehouse (Databricks, Snowflake, Fabric or BigQuery) with a platform bill of
  $3m-$15m a year (section 4). That bill is **not** counted below; only the increment is.
- Existing BI licences (Power BI, Tableau, Looker) are **not** counted.
- Three-year programme: year 1 pilot + 2-3 domains; year 2 most domains; year 3 run and extend.

### Option A - lean semantic layer on the existing lakehouse

| Line | Per year | Working |
|---|---|---|
| Metrics-as-code (dbt Enterprise) | $0.2m-$0.6m | 100-200 developer seats at Vendr's large-team $150-$250/seat/month = $180k-$600k **[D from S]** |
| BI/Excel-facing semantic engine (AtScale / Cube / Kyvos) | $0.2m-$0.8m | Vendr Cube enterprise cloud $10k-$25k+/month and self-hosted $25k-$100k+ per production environment; scaled x3-5 for 10+ domains and multi-region **[E]** |
| AI question answering (Cortex Analyst or Genie compute) | $0.2m-$0.6m | 5,000 users x 20 questions/month = $314k at EU list for Cortex Analyst messages alone **[D]**; up to 2x for SQL execution and heavier use **[E]** |
| Catalog / lineage | $0 | Unity Catalog / Snowflake Horizon assumed already licensed **[E]** |
| **Licences subtotal** | **$0.6m-$2.0m** | |
| Incremental compute (semantic caching, metric queries, agent traffic) | $0.5m-$1.5m | ~10-15% uplift on a $5m-$10m baseline platform bill **[E]**; cross-check: an F512 Fabric capacity reserved in West Europe is $0.59m/yr **[D]** |
| SI | $3.3m-$8.6m over 3 years | Low: 10, 8, 5 FTE x 220 days x $653. High: 20, 15, 10 FTE x 220 x $871 **[E]** |
| Internal team | $1.6m-$3.6m | 12 FTE x $130k to 20 FTE x $180k **[E]** |
| **3-year TCO** | **$11.3m-$29.9m** | 3 x licences + 3 x compute + SI + 3 x internal **[D]** |

### Option B - full catalog + semantic layer + knowledge graph

| Line | Per year | Working |
|---|---|---|
| Enterprise catalog / governance (Collibra, Alation, Atlan) | $0.8m-$2.5m | Entry list: Collibra $170k, Alation $60k + connectors at $30k-$60k each, Atlan Enterprise £300k (~$390k) **[S]**; US ICE Collibra ~$660k/yr **[D]**. For 40,000 users, 100+ sources, quality and privacy modules: 4-10x entry **[E]** |
| Semantic layer + AI (as Option A) | $0.6m-$2.0m | as above |
| Knowledge graph (Neo4j, Stardog, or a cloud graph) | $0.3m-$1.0m | Neo4j Vendr median $277.5k, high $912k **[S]**; AuraDB BC 256-512 GB = $0.45m-$0.90m **[D]** |
| **Licences subtotal (core)** | **$1.7m-$5.5m** | |
| Optional: MDM golden records (Reltio, Informatica, Stibo) | +$1.0m-$3.0m | Reltio Vendr median $393k, high $690k **[S]**, scaled x2-4 for customer + product + supplier domains across regions **[E]**. Many CPG firms already run SAP MDG, which would replace this line. |
| Optional: enterprise document context (Glean-class) for 5,000 users | +$2.7m-$3.9m | 5,000 x $45-$65/user/month **[E from third-party estimate]** |
| Incremental compute | $0.8m-$2.5m | A's compute plus catalog crawling, graph hosting, embeddings and vector index **[E]** |
| SI | $7.5m-$17.2m over 3 years | Low: 25, 15, 12 FTE at $653/day. High: 40, 30, 20 FTE at $871/day **[E]** |
| Internal team | $3.9m-$9.0m | 30 x $130k to 50 x $180k **[E]** |
| **3-year TCO (core)** | **$26.7m-$68.2m** | **[D]**; add $3m-$9m for MDM and $8.1m-$11.7m for document context if bought |

### Option C - Palantir-style ontology platform

| Line | Per year | Working |
|---|---|---|
| Platform + capability licences | $4m-$19m | Low: adviser-reported mid-size deal ($2.6m-$3.2m year one, 600 users) growing with domains **[S adviser + E]**. High: G-Cloud list Platform £3.43m + 2 x Large Capability £5.59m = £14.6m = ~$19.0m, undiscounted **[D]**. Cross-check: NHS FDP averages ~£47m/yr including services for a national estate **[D]** |
| Compute / usage | $1m-$4m | Palantir sells legacy usage in £250k-£2.5m blocks **[S]**; whether usage is bundled in new-model licences is not stated publicly **[E]** |
| Palantir engineers | $7.3m-$18.2m over 3 years | 4, 2, 2 people (low) to 10, 6, 4 (high) at £700k (~$910k) per person-year **[D from S]** |
| Partner SI (Accenture, PwC, Kainos and others list Palantir services on G-Cloud) | $3.4m-$8.6m over 3 years | 10, 8, 6 FTE at $653 to 20, 15, 10 FTE at $871 **[E]** |
| Internal team | $2.0m-$5.4m | 15 x $130k to 30 x $180k **[E]** |
| **3-year TCO** | **$31.6m-$112.0m** | **[D]**. Use-case maintenance (from £22k to £67k per use case per quarter **[S]**) would add ~$2.3m/yr for 10 medium use cases if bought separately **[D]** |

### Where the money goes (mid-points, 3 years) **[D]**

- A ($20.6m mid): licences 19%, compute 15%, SI 29%, internal 38%.
- B ($47.5m mid): licences 23%, compute 10%, SI 26%, internal 41%.
- C ($71.8m mid): licences 48%, compute 10%, Palantir engineers + SI 26%, internal 15%.

---

## 8. Disagreements, gaps and cautions

- **Vendr medians versus enterprise reality.** Vendr's Atlan, Collibra and Alation commentary describes
  deals for 10-100 users. At 40,000 users, per-user prices fall (Vendr: $1,000-$1,800 per Atlan user at 75+
  users) but totals rise a lot. Neither Vendr nor anyone else publishes a G2K-only median.
- **Palantir.** List price (G-Cloud) and reported deal sizes differ by 2-3x, and Redress Compliance sells
  negotiation services, so its example is not neutral. The NHS FDP figure is a 2023 source and press coverage
  differs on whether £330m is committed or a forecast ceiling (the 2023 tender cap was £480m). The US Army
  $10bn is a ceiling only.
- **Glean.** Seat price estimates in third-party blogs run from $10 to $75 per user per month; none is from
  Glean. The 100-seat minimum is unconfirmed.
- **SAP.** SAP publishes consumption rates per service but not a price per Capacity Unit; third-party CU
  prices I saw in search results conflicted by more than 10x, so I used none.
- **Not published anywhere I could find:** Looker edition prices, Stardog, data.world, GoodData figures,
  AtScale per-DSO rate, dbt overage rates, Databricks' Genie free allowance size, Salesforce credit multipliers
  (in a PDF I could not parse), TCS and Infosys UK framework rates (US GSA rates used instead), and any
  programme budget disclosed by Unilever, Nestle or Ingka for this kind of work.
- **Discounts.** Large enterprises routinely get 20-50% off list on committed multi-year deals; Snowflake's
  own table shows storage falling from $23 to $13.80/TB and AI credits from $2.00 to $1.88 at $40m+ ACV.
  The low ends above assume discounts; the high ends assume near-list prices.
- **Salaries.** UK figures are advertised salaries, not paid; Netherlands figures are a recruiter's bands;
  US figures are government survey medians across all industries. None is CPG-specific.

---

## 9. Full source list

Vendor pricing pages and price tables
- dbt pricing: https://www.getdbt.com/pricing
- Cube pricing: https://cube.dev/pricing
- AtScale pricing blog (12 Jun 2024): https://www.atscale.com/?p=23750
- Kyvos pricing: https://www.kyvosinsights.com/pricing/
- Looker pricing: https://cloud.google.com/looker/pricing
- Power BI pricing: https://www.microsoft.com/en-us/power-platform/products/power-bi/pricing
- Microsoft Fabric pricing page (prices did not render): https://azure.microsoft.com/en-us/pricing/details/microsoft-fabric/
- Azure Retail Prices API, Fabric: https://prices.azure.com/api/retail/prices?$filter=serviceName%20eq%20%27Microsoft%20Fabric%27%20and%20armRegionName%20eq%20%27westeurope%27
- Azure Retail Prices API, Azure Databricks: https://prices.azure.com/api/retail/prices?$filter=serviceName%20eq%20%27Azure%20Databricks%27%20and%20armRegionName%20eq%20%27westeurope%27%20and%20type%20eq%20%27Consumption%27
- Snowflake Service Consumption Table (effective 12 Nov 2026): https://www.snowflake.com/legal-files/CreditConsumptionTable.pdf
- Databricks pricing: https://www.databricks.com/product/pricing ; SQL: https://www.databricks.com/product/pricing/databricks-sql ; Genie: https://www.databricks.com/product/pricing/genie
- SAP BDC pricing deck (16 Apr 2026): https://assets.dm.ux.sap.com/sap-user-groups/pdfs/260416_breaking_down_the_sap_bdc_pricing_model.pdf
- SAP Datasphere pricing page: https://www.sap.com/products/data-cloud/datasphere/pricing.html
- Salesforce Data 360 pricing: https://www.salesforce.com/data/pricing/
- Neo4j pricing: https://neo4j.com/pricing/
- Starburst pricing: https://www.starburst.io/pricing/
- GoodData pricing: https://www.gooddata.ai/pricing/
- Stardog pricing: https://www.stardog.com/pricing/

Cloud marketplace listings
- Collibra (AWS): https://aws.amazon.com/marketplace/pp/prodview-6gqg3yc2e2rsu
- Alation (AWS): https://aws.amazon.com/marketplace/pp/prodview-ylge6fq43dtg6
- Denodo via Carahsoft (AWS): https://aws.amazon.com/marketplace/pp/prodview-l4ka25qk7iktk
- Informatica IDMC (AWS): https://aws.amazon.com/marketplace/pp/B08HG79CJ9
- Reltio Data Cloud (AWS): https://aws.amazon.com/marketplace/pp/B08CMWJ1XL

UK G-Cloud pricing documents
- Palantir Platform (G-Cloud 15): https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-15/documents/92736/580753378939715-pricing-document-2026-01-29-1207.pdf
- Palantir Cloud Support Services (G-Cloud 15): https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-15/documents/92736/548190771584049-pricing-document-2026-01-29-1233.pdf
- Atlan via InterWorks (G-Cloud 15): https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-15/documents/703311/504408645525601-pricing-document-2026-01-21-1203.pdf
- Accenture (G-Cloud 15): https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-15/documents/92191/803363878013083-pricing-document-2026-01-27-0141.pdf
- Deloitte (G-Cloud 15): https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-15/documents/92485/529273508070625-pricing-document-2026-01-21-1421.pdf
- Capgemini SFIA rate card (G-Cloud 14, Nov 2024): https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-14/documents/92224/577322578103483-pricing-document-2024-04-22-1124.pdf

Vendr (anonymised transaction data)
- https://www.vendr.com/marketplace/dbt-cloud
- https://www.vendr.com/marketplace/cube-dev
- https://www.vendr.com/marketplace/snowflake
- https://www.vendr.com/marketplace/databricks
- https://www.vendr.com/marketplace/atlan
- https://www.vendr.com/marketplace/collibra
- https://www.vendr.com/marketplace/alation
- https://www.vendr.com/marketplace/glean
- https://www.vendr.com/marketplace/neo4j
- https://www.vendr.com/marketplace/denodo
- https://www.vendr.com/marketplace/starburst-data
- https://www.vendr.com/marketplace/informatica
- https://www.vendr.com/marketplace/reltio
- https://www.vendr.com/marketplace/stibo-systems
- https://www.vendr.com/marketplace/gooddata
- https://www.vendr.com/marketplace/sap

Public contracts
- NHS FDP / Palantir (The Register, 2023): https://www.theregister.com/2023/11/22/palantir_wins_nhs_contract/
- US Army / Palantir EA (The Register, 2025): https://www.theregister.com/2025/08/01/palantir_us_army_contract/
- ICE / Collibra (HigherGov): https://www.highergov.com/contract/NNG15SD11B-70CTD026FR0000023/
- GSA CALC ceiling rates API: https://api.gsa.gov/acquisition/calc/v3/api/ceilingrates/?keyword=accenture (also keyword=deloitte, capgemini, infosys, tata, cognizant)

Earnings and filings
- Palantir 10-Q Q3 2026: https://www.sec.gov/Archives/edgar/data/0001321655/000132165526000048/pltr-20260930.htm
- Snowflake Q2 FY27 (SaaStr): https://www.saastr.com/5-interesting-learnings-from-snowflake-at-6-billion-in-revenue-37-growth-and-accelerating-126-nrr-and-a-gross-margin-guided-down-to-pay-for-ai/
- Snowflake Q2 FY27 press release mirror: https://www.01net.it/snowflake-reports-financial-results-for-the-second-quarter-of-fiscal-2027/
- Snowflake 10-K FY26: https://www.sec.gov/Archives/edgar/data/1640147/000164014726000008/snow-20260131.htm
- Snowflake Q4 FY26 release: https://investors.snowflake.com/news/news-details/2026/Snowflake-Reports-Financial-Results-for-the-Fourth-Quarter-and-Full-Year-of-Fiscal-2026/default.aspx
- Databricks run-rate (ITBrief UK): https://itbrief.co.uk/story/databricks-tops-usd-7-billion-run-rate-after-funding

Analyst / adviser / third-party
- Redress Compliance on Palantir negotiation: https://redresscompliance.com/palantir-aip-foundry-negotiation
- Activepieces on Glean pricing: https://www.activepieces.com/blog/glean-pricing-in-2026-cost-seats-and-minimums

Salaries
- ITJobsWatch (UK): https://www.itjobswatch.co.uk/jobs/uk/data%20architect.do ; https://www.itjobswatch.co.uk/jobs/uk/data%20engineer.do ; https://www.itjobswatch.co.uk/jobs/uk/semantic%20layer.do ; https://www.itjobswatch.co.uk/jobs/uk/data%20governance%20manager.do ; contracts: https://www.itjobswatch.co.uk/contracts/uk/data%20architect.do ; https://www.itjobswatch.co.uk/contracts/uk/data%20engineer.do
- Michael Page Netherlands Salary Guide 2026: https://static.ie.edu/CMC/Career%20Education/Career%20Website/MARKET%20OVERVIEW/Salary%20guides%202026/Netherlands%20Salary%20Guide%202026%20-%20Michael%20Page.pdf
- BLS OEWS May 2025 (API): https://api.bls.gov/publicAPI/v1/timeseries/data/OEUN000000000000015124313 (and series ...15124311, ...15124315, ...15205113, ...15205111, ...15205115, ...11302113); occupation page: https://www.bls.gov/oes/current/oes151243.htm
