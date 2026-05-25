Semantic Bridging for Strategic Recommendation Systems
Anonymous Artifact Repository for Double-Blind Review

Repository URL:
https://anonymous.4open.science/r/semantic_bridging-A4EA/

====================================================================
1. PURPOSE
====================================================================

This anonymous repository contains all artifacts required to reproduce
the experiments reported in the submitted paper:

"Ontology Unpacking and Semantic Alignment for Recommendation Systems"

The repository includes:

- Raw transactional and recommendation datasets
- Semantic onboarding outputs
- Ontological unpacking rules
- Semantic bridging reasoning rules
- Evaluation protocols
- Experimental outputs
- Scalability datasets
- Reproducibility materials

The goal is to ensure full transparency and reproducibility during the
double-blind review process.

====================================================================
2. REPOSITORY ORGANIZATION
====================================================================

datasets/raw/
    Original input datasets used in the experiments:
    - entities_metadata.csv
    - triples.csv
    - user_needs.txt

datasets/semantic_onboarding/
    Formal knowledge representations generated through semantic onboarding:
    - entities.pl
    - triples.pl

ontology_unpacking/
    Business intent formalization artifacts:
    - rules.pl
    - business rule descriptions
    - ontological unpacking examples

evaluation/
    Experimental evaluation materials:
    - competency questions
    - Logical Soundness definition
    - expert assessment protocol
    - baseline prompt configuration

evaluation/outputs/
    Experimental outputs:
    - recommendation examples
    - evaluation results
    - scalability measurements

datasets/synthetic_scalability/
    Synthetic datasets used for scalability experiments:
    8k, 40k, 80k, 200k, and 400k fact configurations

src/
    Source code modules for semantic onboarding, reasoning, evaluation,
    and explanation generation

====================================================================
3. EXPERIMENTAL PIPELINE
====================================================================

The proposed methodology consists of three main phases:

(1) Semantic Onboarding
    Raw transactional data are transformed into executable Prolog facts
    grounded in ontological constructs.

(2) Ontological Unpacking
    Natural-language business intent is translated into formal logical
    recommendation rules.

(3) Semantic Bridging
    The formal business intent model is aligned with onboarded business
    evidence through executable inference.

====================================================================
4. REPRODUCING THE EXPERIMENTS
====================================================================

Requirements:
- Python 3.10+
- SWI-Prolog
- Jupyter Notebook
- Required Python dependencies listed in requirements.txt

Basic steps:

1. Install dependencies
   pip install -r requirements.txt

2. Generate or load datasets
   Use experiments/notebook/generate_dataset.ipynb

3. Load Prolog knowledge base
   datasets/semantic_onboarding/entities.pl
   datasets/semantic_onboarding/triples.pl
   ontology_unpacking/rules.pl

4. Execute competency questions:
   CQ1: Personalized recommendation
   CQ2: Discount prioritization
   CQ3: Bundle recommendation

5. Compare outputs with baseline artifacts

====================================================================
5. EVALUATION METRICS
====================================================================

Logical Soundness (LS)
    Measures the percentage of formal business and ontological
    conditions satisfied by each generated recommendation.

Expert Rating (ER)
    Qualitative evaluation based on:
    - strategic relevance
    - commercial actionability
    - explanation clarity

Scalability
    Measures loading time and inference runtime under increasing
    knowledge base sizes.

====================================================================
6. NOTES FOR REVIEWERS
====================================================================

This repository is anonymized for double-blind review.

No identifying author or institutional information is intentionally
included.

All experiments reported in the paper can be independently inspected
through the provided artifacts.

====================================================================
7. CONTACT
====================================================================

Omitted for anonymous review.
