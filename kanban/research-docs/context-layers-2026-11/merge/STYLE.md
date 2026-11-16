# Merge style rules (for every section draft)

Inputs: the four Opus reports in ../opus/ (01-vendors, 02-case-studies, 03-architecture, 04-pricing) and the Astra
report in ../astra/report.md. They were researched independently on the same brief (../BRIEF.md). Your job is to
MERGE them for your sections into doc-ready markdown. Do not do new web research, except to check a link that the
two reports contradict each other on.

The reader is a consultant to Unilever / Nestle / IKEA-scale consumer goods and retail companies. He reads on a
laptop and saves this doc. He wants depth and every link.

Rules:
- Start each section with `## <Heading>`, then ONE lead sentence that is the answer (with its number or name).
- Plain English, British spelling. Sentences under 25 words, paragraphs of at most 3 sentences. No emoji.
- Items compared on several attributes -> a pipe table (row per item, column per attribute, units in headers,
  sorted by what a reader scans for). A dated log of events -> one table, newest first. Use `###` sub-headings
  sparingly. Bullets only for parallel items.
- EVERY factual claim keeps its link exactly as the source report gave it, as `[short name](url)`. Never invent
  or alter a URL. Names of companies, products, documents taken from a source link to that source.
- Mark provenance where it matters: "(both)" when Opus and Astra independently found the same fact, "(Astra)" or
  "(Opus)" when only one did. When they DISAGREE, say so plainly in one line with both versions and links.
- Label vendor marketing figures as vendor claims. Label estimates as estimates and say whose.
- No intro, recap, "key takeaways" or methodology paragraphs. No padding. Specific names, numbers, dates.
- Do not use the characters `<?` anywhere.
- Write ONLY to the output file(s) named in your task. Then reply with the path(s), word counts, and up to 8 lines
  on where Opus and Astra agreed or disagreed most.
