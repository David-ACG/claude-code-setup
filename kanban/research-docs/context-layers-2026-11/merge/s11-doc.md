## What it costs at Unilever, IKEA or Nestle scale

Over three years, Opus estimates $11m-$30m for a lean semantic layer, $27m-$68m for catalog plus knowledge graph, and $32m-$112m for a Palantir-style ontology.

<?claude block tco?>

These are estimates (Opus), built from the list prices, marketplace listings and Vendr medians below. Astra did not total the options over three years; it gave annual programme envelopes, compared in the costed estimate below. People, not software, are 55-70% of the cost in the first two options (Opus).

### Published and disclosed prices by product

Rows run in stack order: semantic layer and BI, platform AI, catalog, graph, federation, MDM, customer and search, ontology platform. "Vendr" means anonymised buyer transactions, mostly mid-market deals.

| Product | Pricing model | Published or disclosed price | Typical large-enterprise annual spend | Source type |
|---|---|---|---|---|
| [dbt Platform incl. Semantic Layer](https://www.getdbt.com/pricing) | Developer seats plus usage (model builds, queried metrics) | Starter $100/developer/month with 5,000 queried metrics a month (both); Astra adds 15,000 model builds. Enterprise is quoted, with 20,000 queried metrics and the Semantic Layer included (Opus). | Vendr median $27,930 (range $14,560-$102,800, n=156); 25-100+ seats $100k-$400k+ ([Vendr](https://www.vendr.com/marketplace/dbt-cloud), Opus). Opus estimate for 100-200 seats: $0.2m-$0.6m. | List price; Vendr median; estimate |
| [Cube Cloud](https://cube.dev/pricing) | Developer and user seats plus hourly deployments | Starter $40/developer/month, Premium $80, Explorer $40, Viewer $20 (both). Dedicated deployment $1.20/hour (Opus); Astra reads $0.60 or $1.20/hour. | Vendr median $37,200 (range $16,679-$91,800, n=35); enterprise cloud $10k-$25k+/month; self-hosted $25k-$100k+ ([Vendr](https://www.vendr.com/marketplace/cube-dev), Opus). 20 Premium developers plus one deployment = $29,712/yr at list (Astra). | List price; Vendr median |
| [AtScale](https://www.atscale.com/?p=23750) | Deployed semantic objects (DSO) per month | "As little as $2,500 per month"; an average model is ~250 objects (June 2024 blog, Opus). | Not on Vendr. Opus estimate for an AtScale, Cube or Kyvos engine across 10+ domains: $0.2m-$0.8m. | List price (older); estimate |
| [Kyvos](https://www.kyvosinsights.com/pricing/) | Core-hour or annual subscription | $0.41/core-hour in your cloud, $0.61 managed; annual subscription "starts at $48K" (Opus). | Not found | List price |
| [Honeydew](https://honeydew.ai/pricing/) | User seats plus platform fee plus active-object bands | Lite $20/user/month plus platform from $500/month; Standard $30/user/month plus from $2,000/month (Astra). | Not found; enterprise is quoted (Astra) | List price |
| [GoodData](https://www.gooddata.ai/pricing/) | Platform plus workspaces; Enterprise custom | No figures published (both). | Vendr median $223,000 (range $65,310-$243,887) ([Vendr](https://www.vendr.com/marketplace/gooddata), Opus) | Vendr median |
| [Looker](https://cloud.google.com/looker/pricing) | Platform edition plus Developer, Standard and Viewer licences | Every edition quoted; each includes 10 Standard and 2 Developer users (both). Gemini overage $3.00 / $20.00 per 1M input / output tokens (Opus). | Not found | No list price exists |
| [Power BI](https://www.microsoft.com/en-us/power-platform/products/power-bi/pricing) / Microsoft Fabric | Per user (Pro, PPU) or capacity (F SKU, capacity units) | Pro $14/user/month, PPU $24 (both; Astra via [Microsoft](https://www.microsoft.com/en-us/microsoft-fabric/features/power-bi/pricing)). Fabric reserved 1-year $1,146/CU/yr West Europe, $938 East US, $1,094 UK South; PAYG $0.18-$0.22/CU-hour ([Azure Retail Prices API](https://prices.azure.com/api/retail/prices?$filter=serviceName%20eq%20%27Microsoft%20Fabric%27%20and%20armRegionName%20eq%20%27westeurope%27), Opus). | F512 reserved West Europe $586,752/yr; F2048 $2,347,008/yr (Opus, derived). 30,000 Pro users at list = $5.04m/yr, often already held through Microsoft 365 E5 (Opus, not verified for any named company). | List price; official API; estimate |
| [Snowflake Cortex Analyst](https://www.snowflake.com/legal-files/CreditConsumptionTable.pdf) and semantic views | Credits (compute), AI credits, storage per TB | 67 credits per 1,000 Analyst messages, table effective 12 Nov 2026 (both; Astra via [consumption table](https://www.snowflake.com/legal/creditconsumptiontable/)). Enterprise credit $3.00 US East, $3.90 EU, $4.00 London; storage $23/TB/month, $13.80 at $40m+ ACV (Opus). AI credits $2.00 global (both), $2.20 regional (Astra), $1.88 at $40m+ ACV (Opus). | Vendr median $100,000 (range $20,000-$600,000, n=741) ([Vendr](https://www.vendr.com/marketplace/snowflake), Opus). Global 2000 average ~$2.55m/yr from filings (Opus, derived). 5,000 users asking 20 questions a month = ~$314k/yr at EU list (Opus, derived). | List price; Vendr median; earnings; estimate |
| [Databricks Genie](https://www.databricks.com/product/pricing/genie), Unity Catalog, metric views | DBUs by workload plus cloud infrastructure | Azure Premium West Europe: Serverless SQL $0.91/DBU, SQL Pro $0.72, Jobs $0.30, All-purpose $0.55 ([Azure Retail Prices API](https://prices.azure.com/api/retail/prices?$filter=serviceName%20eq%20%27Azure%20Databricks%27%20and%20armRegionName%20eq%20%27westeurope%27%20and%20type%20eq%20%27Consumption%27), Opus). Genie LLM usage free; Genie compute billed separately (Opus). | Vendr median $340,500 (range $31,050-$2,116,400, n=211) ([Vendr](https://www.vendr.com/marketplace/databricks), Opus). Over 100 customers above $10m run-rate (press). | List price; Vendr median; earnings (press) |
| [SAP Datasphere / Business Data Cloud](https://assets.dm.ux.sap.com/sap-user-groups/pdfs/260416_breaking_down_the_sap_bdc_pricing_model.pdf) | Capacity Units (CU) in monthly blocks | No CU price published. Foundation tenant 0.926 CU/hour; customer-managed data products need a 640 CU BDC Core minimum (SAP user-group deck, 16 Apr 2026, Opus). | Not found. Vendr "SAP" median $29,293 is not product-specific ([Vendr](https://www.vendr.com/marketplace/sap), Opus). | Consumption rates only |
| [Collibra](https://aws.amazon.com/marketplace/pp/prodview-6gqg3yc2e2rsu) | Platform subscription plus modules | $170,000 per 12 months on AWS Marketplace (both). | Vendr median $197,142 (range $174,740-$225,360) ([Vendr](https://www.vendr.com/marketplace/collibra), Opus). US ICE order ~$660k/yr (Opus, derived). | Marketplace; Vendr median; public contract |
| [Alation](https://aws.amazon.com/marketplace/pp/prodview-ylge6fq43dtg6) | Platform plus users plus connectors | Data Catalog from $60,000 per 12 months on AWS Marketplace (both). | Vendr median $141,394 (range $77,526-$302,223) ([Vendr](https://www.vendr.com/marketplace/alation), Opus) | Marketplace; Vendr median |
| [Atlan](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-15/documents/703311/504408645525601-pricing-document-2026-01-21-1203.pdf) | Platform tier plus role licences | Advanced £110,000/yr, Enterprise £300,000/yr (both). Opus read the InterWorks G-Cloud 15 sheet dated 20 Feb 2025; Astra the [2024 G-Cloud 14 schedule](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-14/documents/703311/751541331504885-pricing-document-2024-04-30-1721.pdf). Roles: Insights £1,188, Member £588, Guest £60 a year (Astra). | Vendr median $50,420 (range $30,078-$177,847, n=44); 75+ users $1,000-$1,800/user/yr; enterprise often above $150k ([Vendr](https://www.vendr.com/marketplace/atlan), Opus). Advanced plus 320 role licences = £204,560/yr (Astra). | Public framework list; Vendr median |
| data.world (ServiceNow) | Not published | Nothing found (Opus); not priced by Astra. | Vendr page has no figures (Opus) | Not found |
| [Neo4j AuraDB](https://neo4j.com/pricing/) | GB-hour in cloud; per core self-managed | Professional from $0.09/GB/hour, Business Critical from $0.20/GB/hour (both). | Vendr median $277,500 (range $66,400-$912,000); self-managed $3,000-$6,000/core list ([Vendr](https://www.vendr.com/marketplace/neo4j), Opus). Business Critical at 256-512 GB = $0.45m-$0.90m/yr (Opus, derived). | List price; Vendr median |
| [Stardog](https://aws.amazon.com/marketplace/pp/prodview-ulfm6fel7xgjq) | Quote; hourly on AWS | AWS listing $5.553/hour software charge (Astra). No prices on [stardog.com](https://www.stardog.com/pricing/) (Opus). | One instance running all year = $48,644/yr before infrastructure (Astra) | Marketplace |
| [Denodo](https://aws.amazon.com/marketplace/pp/prodview-l4ka25qk7iktk) | Per CPU core | **Disagree.** Opus: AWS (Carahsoft private offer) Enterprise Plus $71,550 and Enterprise $61,250 per core per year. Astra: [2024 G-Cloud 14 schedule](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-14/documents/717035/434185192790796-pricing-document-2024-05-07-1219.pdf) Enterprise £61,700 and Enterprise Plus £75,100 per four cores, charge period unclear. | Vendr median $107,200 (range $101,560-$119,284) ([Vendr](https://www.vendr.com/marketplace/denodo), Opus). 16 cores Enterprise Plus at AWS list = $1.14m/yr (Opus, derived). | Marketplace; public framework list; Vendr median |
| [Starburst](https://www.starburst.io/pricing/) | Credits | Galaxy Pro $0.50, Enterprise $0.75, Mission-Critical $1.00 per credit, "starting at" (Opus). | Vendr median $43,962 (range $27,370-$57,888) ([Vendr](https://www.vendr.com/marketplace/starburst-data), Opus) | List price; Vendr median |
| [Informatica IDMC](https://aws.amazon.com/marketplace/pp/B08HG79CJ9) (MDM, catalog) | Informatica Processing Units (IPU) | 120 IPU/month for $131,760 per 12 months = $1,098 per IPU-year (Opus). | Vendr median $56,250 (range $10,753-$252,657, n=36) ([Vendr](https://www.vendr.com/marketplace/informatica), Opus) | Marketplace; Vendr median |
| [Reltio](https://aws.amazon.com/marketplace/pp/B08CMWJ1XL) (MDM) | Per edition or profiles | $15,600/month per industry edition, 1-month contract (Opus). | Vendr median $393,333 (range $300,244-$690,233) ([Vendr](https://www.vendr.com/marketplace/reltio), Opus). Opus estimate for MDM across customer, product and supplier: $1.0m-$3.0m/yr. | Marketplace; Vendr median; estimate |
| [Stibo Systems](https://www.vendr.com/marketplace/stibo-systems) (MDM/PIM) | Not published | Nothing found (Opus). | Vendr median $97,391 (range $26,213-$99,832) (Opus) | Vendr median |
| [Salesforce Data Cloud (Data 360)](https://www.salesforce.com/data/pricing/) | Flex Credits or profiles | $500 per 100,000 Flex Credits; Profiles $240 per 1,000 a year; Enterprise Profiles $420; ingestion free (both). | 10 million profiles = $2.4m/yr at list (Astra) | List price |
| [Glean](https://www.vendr.com/marketplace/glean) | Per user per year plus FlexCredits for agents | No public price (Opus). Third-party estimate $45-$50/seat plus $15 for AI; 100-seat minimum unconfirmed ([activepieces](https://www.activepieces.com/blog/glean-pricing-in-2026-cost-seats-and-minimums)). | Vendr median $99,080 (range $30,240-$209,265, n=175) (Opus). Opus estimate for 5,000 users: $2.7m-$3.9m/yr. | Vendr median; third-party; estimate |
| [Palantir Foundry / AIP](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-15/documents/92736/580753378939715-pricing-document-2026-01-29-1207.pdf) | Platform plus capability licences; engineers per quarter | G-Cloud 15 list (Jan 2026): Platform £3,428,840/yr; Capability S/M/L £1,863,500 / £3,727,000 / £5,590,500 a year; engineering £175,000 per person per quarter (Opus). Astra found no verified public Palantir price. | Adviser claim: opens at $4m a year for 600 users, $2.6m-$3.2m in year one after scoping ([Redress Compliance](https://redresscompliance.com/palantir-aip-foundry-negotiation)). Top 20 customers average $146m/yr (Opus). | Public framework list; adviser claim; earnings |

Snowflake caution (Astra): Cortex Analyst called through Cortex Agents is billed in AI Credits by token, not at 67 Platform Credits ([pricing explanation](https://docs.snowflake.com/en/user-guide/snowflake-cortex/pricing)). Evaluations add warehouse, judge-inference and storage charges ([Snowflake evaluations](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst-evaluations)).

Vendr disagreement: Opus used Vendr medians throughout. Astra says its access to the Vendr pages was blocked and it deliberately used no snippet medians. Opus warns Vendr is a floor: its Atlan commentary describes typical deals of 10-75 users.

### Contracts and disclosures that reveal real spend

No published contract value was found for Unilever, Nestle or Ingka with any of these vendors (both).

| Date | Buyer or company | Supplier or product | Figure | What it reveals | Source |
|---|---|---|---|---|---|
| 30 Sep 2026 | Palantir (10-Q) | Foundry / AIP | Top 20 customers average **$146m** a year (TTM), up 76% from $83m; 1,090 customers; Q3 revenue $2,313.4m, commercial $1,167.9m; RPO $4.9bn | The largest Palantir customers spend far above any list-price build-up (Opus) | [Palantir 10-Q Q3 2026](https://www.sec.gov/Archives/edgar/data/0001321655/000132165526000048/pltr-20260930.htm) |
| 24 Sep 2026 | Unnamed mid-size buyer | Palantir | Opens at $4m a year for 600 users; $2.6m-$3.2m in year one after scoping; comparable deals differ 2-3x | List and negotiated price can differ 2-3x. The adviser sells negotiation services, so the example is not neutral (Opus). | [Redress Compliance](https://redresscompliance.com/palantir-aip-foundry-negotiation) |
| 14 Aug 2026 | Databricks | Lakehouse platform | Run-rate above $7bn; over 1,000 customers above $1m; **over 100 above $10m** | A Unilever-scale lakehouse customer plausibly sits in the $10m+ group (Opus estimate). Press report, not a Databricks release. | [ITBrief UK](https://itbrief.co.uk/story/databricks-tops-usd-7-billion-run-rate-after-funding) |
| 31 Jul 2026 | Snowflake (Q2 FY27) | Data cloud | 828 customers above $1m TTM product revenue, up 27%; 829 Forbes Global 2000 customers | Seven-figure platform bills are routine at this size (Opus) | [SaaStr](https://www.saastr.com/5-interesting-learnings-from-snowflake-at-6-billion-in-revenue-37-growth-and-accelerating-126-nrr-and-a-gross-margin-guided-down-to-pay-for-ai/); [press release mirror](https://www.01net.it/snowflake-reports-financial-results-for-the-second-quarter-of-fiscal-2027/) |
| May 2026 | US ICE (DHS) | Collibra via GovSmart | $612.3k obligated; up to $3.31m over 5 years to May 2031 | ~$660k a year for one large agency, 3x the Vendr median (Opus, derived) | [HigherGov](https://www.highergov.com/contract/NNG15SD11B-70CTD026FR0000023/) |
| FY to 31 Jan 2026 | Snowflake (10-K) | Data cloud | 790 Global 2000 customers = ~43% of $4,683.9m revenue | **~$2.55m a year** average per Global 2000 customer: 0.43 x $4,683.9m / 790 (Opus, derived) | [Snowflake 10-K FY26](https://www.sec.gov/Archives/edgar/data/1640147/000164014726000008/snow-20260131.htm); [Q4 FY26 release](https://investors.snowflake.com/news/news-details/2026/Snowflake-Reports-Financial-Results-for-the-Fourth-Quarter-and-Full-Year-of-Fiscal-2026/default.aspx) |
| 29 Jan 2026 | UK public sector (framework) | Palantir Platform, G-Cloud 15 | Platform licence £3.43m a year; engineers £175k per person per quarter; discovery £50k-£250k; pilot licences £50k-£500k | The only official Palantir list prices found (Opus) | [G-Cloud pricing document](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-15/documents/92736/580753378939715-pricing-document-2026-01-29-1207.pdf); [Cloud Support pricing](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-15/documents/92736/548190771584049-pricing-document-2026-01-29-1233.pdf) |
| 1 Aug 2025 | US Army | Palantir Enterprise Agreement | Ceiling up to $10bn over 10 years; replaces 75 contracts | A ceiling, not committed spend; big buyers consolidate into one discounted agreement (Opus) | [The Register](https://www.theregister.com/2025/08/01/palantir_us_army_contract/) |
| 23 Apr 2024 | Coca-Cola | Microsoft cloud and generative AI | $1.1bn over five years | Not a context-layer benchmark: the scope is broad cloud and AI transformation (Astra) | [Coca-Cola announcement](https://www.coca-colacompany.com/media-center/the-coca-cola-company-and-microsoft-announce-five-year-strategic-partnership-to-accelerate-cloud-and-generative-ai-initiatives) |
| 22 Nov 2023 | NHS England | Palantir-led consortium (Accenture, PwC, NECS, Carnall Farrar), Federated Data Platform | £330m over 7 years; £25.6m in year one; tender capped at £480m | ~£47m a year for a national, multi-organisation ontology platform with services (Opus, derived). Press differs on whether £330m is committed or a ceiling. | [The Register](https://www.theregister.com/2023/11/22/palantir_wins_nhs_contract/) |

Opus reads these together as a platform bill of $3m-$15m a year before any semantic or context layer (estimate). That bill is excluded from the totals below.

### Systems-integrator day rates and internal salaries

UK framework maximum day rates, ex VAT, January 2026 unless stated (Opus). Lining up role names, civil-service grades and SFIA levels in one row is Opus's own mapping.

| Role | [Accenture](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-15/documents/92191/803363878013083-pricing-document-2026-01-27-0141.pdf) onshore / offshore | [Deloitte](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-15/documents/92485/529273508070625-pricing-document-2026-01-21-1421.pdf) standard / specialist | [Capgemini](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-14/documents/92224/577322578103483-pricing-document-2024-04-22-1124.pdf) onshore / offshore (Nov 2024) |
|---|---|---|---|
| Data engineer / SFIA 3 | £900 / £275 | SEO: £1,275 / £1,405 | £742 / £220 |
| Senior data engineer / SFIA 4 | £1,350 / £375 | SEO-G7: £1,480 / £1,630 | £1,006 / £311 |
| Lead data engineer / SFIA 5 | £1,850 / £495 | G7: £1,530 / £1,685 | £1,186 / £383 |
| Data architect: senior / chief | £1,850 / £2,500 (offshore £495 / £595) | G6: £1,950 / £2,145 | SFIA 5-6: £1,750-£2,040 |
| Head of data governance / SFIA 7 | £2,500 / £595 | SCS: £2,125 / £2,340 | £2,300 / £703 |
| Offshore range | £150-£650 | £355-£665 | £87-£703 |

US federal ceiling rates for data, architect, engineer and scientist categories, queried 16 Nov 2026 ([GSA CALC API](https://api.gsa.gov/acquisition/calc/v3/api/ceilingrates/?keyword=accenture), Opus):

| Firm | Median $/hour | p10-p90 $/hour | ~$/day (8 hours) |
|---|---|---|---|
| Deloitte | $293 | $248-$372 | $2,344 |
| Cognizant | $243 | $141-$373 | $1,946 |
| TCS | $228 | $181-$269 | $1,826 |
| Accenture Federal | $209 | $133-$310 | $1,674 |
| Infosys Public Services | $171 | $124-$216 | $1,364 |
| Capgemini Government (6 rows) | $133 | $84-$257 | $1,066 |

Other reference rates (Opus):

- Palantir engineers: £175,000 per person per quarter, or about $910k a person-year ([G-Cloud](https://assets.applytosupply.digitalmarketplace.service.gov.uk/g-cloud-15/documents/92736/548190771584049-pricing-document-2026-01-29-1233.pdf)). That is about 2x an Accenture lead engineer billed full time onshore.
- UK contractors: data architect median £625/day, data engineer £500/day ([ITJobsWatch architect](https://www.itjobswatch.co.uk/contracts/uk/data%20architect.do), [ITJobsWatch engineer](https://www.itjobswatch.co.uk/contracts/uk/data%20engineer.do)). About half the big-firm onshore rate.

Internal salaries, sourced (Opus):

| Role | UK median (p10-p90), adverts to 16 Nov 2026 | Netherlands, Michael Page 2026 | US, BLS OEWS May 2025 |
|---|---|---|---|
| Data / analytics engineer | [£70,000](https://www.itjobswatch.co.uk/jobs/uk/data%20engineer.do) (£45,000-£100,000) | €70k-€90k; senior €90k+ | - |
| Data / semantic architect | [£90,000](https://www.itjobswatch.co.uk/jobs/uk/data%20architect.do) (£63,744-£112,500) | €90k-€110k; senior €110k+ | Database architects [$139,500](https://api.bls.gov/publicAPI/v1/timeseries/data/OEUN000000000000015124313) (p10 $86,240, p90 $204,000) |
| Adverts naming "semantic layer" | [£75,000](https://www.itjobswatch.co.uk/jobs/uk/semantic%20layer.do) (£51,500-£112,500) | - | - |
| Data governance manager | [£68,658](https://www.itjobswatch.co.uk/jobs/uk/data%20governance%20manager.do) (£40,000-£110,000) | MDM €65k-€80k; senior €80k+ | - |
| Data scientist / ML engineer | - | €80k-€100k; €100k+ | [$120,230](https://api.bls.gov/publicAPI/v1/timeseries/data/OEUN000000000000015205113) |
| Platform lead / data director | - | Head of IT €120k+ | IS managers [$175,140](https://api.bls.gov/publicAPI/v1/timeseries/data/OEUN000000000000011302113) |

Netherlands source: [Michael Page Netherlands Salary Guide 2026](https://static.ie.edu/CMC/Career%20Education/Career%20Website/MARKET%20OVERVIEW/Salary%20guides%202026/Netherlands%20Salary%20Guide%202026%20-%20Michael%20Page.pdf), p.11.

The two models use very different people rates. Both sets are assumptions, not market medians.

| Model input | Opus | Astra |
|---|---|---|
| SI day rate | $653-$871 blended: 30% onshore at ~£1,300, 70% offshore at ~£400, 25% negotiated discount in the low case | $1,800/day (first domain), $2,000/day (ongoing), $1,800-$2,500/day (remediation) |
| Loaded internal cost per FTE | $130k-$180k (salary x 1.3; part of team in a lower-cost centre) | $180k-$240k |

### Costed estimate: 40,000 data users, 100+ countries

Opus scenario: 40,000 data consumers, ~5,000 active AI users, 10-15 domains, several SAP instances. Year 1 is a pilot plus 2-3 domains, year 2 most domains, year 3 run and extend.

**Lean semantic layer on the existing lakehouse** (estimate, Opus)

| Line | Low | High | Working |
|---|---|---|---|
| Licences per year | $0.6m | $2.0m | dbt Enterprise $0.2m-$0.6m; semantic engine $0.2m-$0.8m; Cortex Analyst or Genie $0.2m-$0.6m; catalog already owned |
| Cloud compute per year | $0.5m | $1.5m | 10-15% uplift on a $5m-$10m platform bill |
| SI implementation (3 years) | $3.3m | $8.6m | 10, 8, 5 FTE at $653/day to 20, 15, 10 FTE at $871/day; 220 days a year |
| Internal team per year | $1.6m | $3.6m | 12 FTE at $130k to 20 FTE at $180k |
| **3-year total** | **$11.3m** | **$29.9m** | 3 x (licences + compute + team) + SI |

**Full catalog + semantic layer + knowledge graph** (estimate, Opus)

| Line | Low | High | Working |
|---|---|---|---|
| Licences per year | $1.7m | $5.5m | Catalog $0.8m-$2.5m (4-10x entry list); semantic layer and AI $0.6m-$2.0m; graph $0.3m-$1.0m |
| Cloud compute per year | $0.8m | $2.5m | Lean compute plus catalog crawling, graph hosting, embeddings and vector index |
| SI implementation (3 years) | $7.5m | $17.2m | 25, 15, 12 FTE at $653/day to 40, 30, 20 FTE at $871/day |
| Internal team per year | $3.9m | $9.0m | 30 FTE at $130k to 50 FTE at $180k |
| **3-year total** | **$26.7m** | **$68.2m** | Add $3m-$9m for MDM and $8.1m-$11.7m for Glean-class document search if bought |

**Palantir-style ontology platform** (estimate, Opus)

| Line | Low | High | Working |
|---|---|---|---|
| Licences per year | $4m | $19m | Low: adviser-reported deal growing with domains. High: G-Cloud list Platform plus 2 Large Capability = £14.6m, undiscounted. |
| Cloud compute per year | $1m | $4m | Legacy usage sold in £250k-£2.5m blocks; bundling in new licences not public |
| SI implementation (3 years) | $10.7m | $26.8m | Palantir engineers $7.3m-$18.2m (4, 2, 2 to 10, 6, 4 people at ~$910k) plus partner SI $3.4m-$8.6m |
| Internal team per year | $2.0m | $5.4m | 15 FTE at $130k to 30 FTE at $180k |
| **3-year total** | **$31.6m** | **$112.0m** | Use-case maintenance could add ~$2.3m a year for 10 medium use cases |

Where the money goes, at the mid-points (Opus, derived):

| Option | 3-year mid-point | Licences | Compute | SI | Internal team | Per data user per year |
|---|---|---|---|---|---|---|
| Lean semantic layer | $20.6m | 19% | 15% | 29% | 38% | $95-$250 |
| Full catalog + graph | $47.5m | 23% | 10% | 26% | 41% | $220-$570 |
| Palantir-style ontology | $71.8m | 48% | 10% | 26% | 15% | $260-$930 |

**Astra's estimate, side by side.** Astra costs one "global multi-domain operating programme" per year, not three options over three years. The 3-year line below multiplies Astra's annual figure by three; that arithmetic is this merge's, not Astra's.

| Line | Opus lean semantic layer | Astra global multi-domain programme | Opus full catalog + graph |
|---|---|---|---|
| Licences / software per year | $0.6m-$2.0m | $0.50m-$2.00m | $1.7m-$5.5m |
| Cloud per year | $0.5m-$1.5m | $0.30m-$1.50m | $0.8m-$2.5m |
| SI implementation | $3.3m-$8.6m over 3 years | $0.30m-$1.00m a year (150-500 days at $2,000); optional remediation $0.9m-$3.75m | $7.5m-$17.2m over 3 years |
| Internal team per year | $1.6m-$3.6m (12-20 FTE) | $3.60m-$9.60m (20-40 FTE) | $3.9m-$9.0m (30-50 FTE) |
| Annual total | - | $4.70m-$14.10m | - |
| 3-year total | $11.3m-$29.9m | $14.1m-$42.3m; $15.0m-$46.1m with remediation | $26.7m-$68.2m |

Astra's smaller scopes (estimates, Astra): a first production domain costs $0.87m-$1.85m over six months. A focused annual service on an existing platform costs $1.28m-$2.95m a year.

Why the two differ:

- **Scope.** Astra models one programme and has no Palantir-style or knowledge-graph option. It treats its first-domain and annual rows as alternatives, not additions.
- **Internal team.** Astra puts 20-40 FTE at $180k-$240k, so people cost $3.6m-$9.6m a year. Opus uses $130k-$180k, assuming part of the team sits offshore.
- **SI.** Astra buys 150-500 onshore specialist days a year at $2,000. Opus buys 1,100-8,800 blended days a year at $653-$871, front-loaded into year 1.
- **Software.** Astra calls its allowance "judgemental" and used no Vendr data. Opus anchored on Vendr and list prices. Both still land at $0.5m-$2.0m a year for the lean stack.
- **Net effect.** Astra spends more on staff and less on SI. Its 3-year total overlaps the top of Opus's lean option and the bottom of the full option.

### Assumptions and gaps

Opus converts at £1 = $1.30 and €1 = $1.13 (assumption, not sourced); Astra keeps original currencies and converts nothing.
Neither model counts the existing lakehouse bill ($3m-$15m a year, Opus estimate) or BI licences; Opus's low cases assume discounts, its high cases near list.

Not found by either report, or flagged as missing:

- Any programme budget or vendor contract value disclosed by Unilever, Nestle or Ingka (both).
- Any EU TED award naming Atlan, Alation, dbt Labs, Cube, AtScale or Neo4j with a value (Opus).
- A verified public price for an enterprise-wide CPG context-layer programme (Astra) or a Global 2000-only Vendr median (Opus).
- Looker edition prices and GoodData figures (both); data.world prices and AtScale's per-DSO rate (Opus).
- SAP's price per Capacity Unit; third-party CU prices conflicted by more than 10x, so Opus used none.
- Databricks' Genie free allowance, dbt overage rates and Salesforce credit multipliers (Opus).
- TCS and Infosys UK framework rates, and typical discounts off framework maxima; Opus assumed 25% (Opus).
- Glean's own seat price; third-party estimates run from $10 to $75 per user per month (Opus).
