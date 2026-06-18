# Semantic Bridging Artifact Repository

This repository contains the artifacts used in the evaluation of the Semantic Bridging methodology. The repository is organized according to the three main stages of the proposed approach: Semantic Onboarding, Ontological Unpacking, and Recommendation Evaluation.

## Repository Structure

semantic_bridging/
|
+-- datasets/
|   |
|   +-- raw/
|   |   |
|   |   +-- entities_metadata.csv
|   |   +-- triples.csv
|   |
|   +-- semantic_onboarding/
|       |
|       +-- entities.pl
|       +-- triples.pl
|
+-- ontology_unpacking/
|   |
|   +-- KOA_ontological_unpacking.ipynb
|   +-- business_intent.docx
|   +-- rules.pl
|
+-- evaluation/
|   |
|   +-- KOA_generate_recommendations.ipynb
|   +-- KOA_generate_recommendations_with_inference.ipynb
|
+-- README.txt

## Folder Descriptions

1. datasets/raw/

Contains the original structured data used during the evaluation.

* entities_metadata.csv
  Metadata describing products, categories, brands, and other domain entities.

* triples.csv
  Relationship dataset containing graph-based associations such as purchases, views, and other behavioral connections used during recommendation generation.

2. datasets/semantic_onboarding/

Contains the output of the Semantic Onboarding phase.

* entities.pl
  Prolog representation of domain entities generated from the structured input data.

* triples.pl
  Prolog representation of graph relationships generated from the original dataset.

Together, these files constitute the executable knowledge base produced during the Semantic Onboarding stage.

3. ontology_unpacking/

Contains the artifacts associated with the Ontological Unpacking phase.

* business_intent.docx
  Natural-language business specification provided by a domain analyst. This document describes the organizational objectives and recommendation criteria without requiring knowledge of ontologies, logic programming, or implementation details.

* KOA_ontological_unpacking.ipynb
  Notebook demonstrating how the business specification is transformed into executable semantic rules. The notebook documents the ontology-guided interpretation process and the generation of the final rule set.

* rules.pl
  Executable Prolog rules generated from the business intent specification. These rules materialize semantic relations, recommendation criteria, category prioritization logic, and bundle discount strategies.

4. evaluation/

Contains the artifacts used to generate recommendations and reproduce the evaluation results reported in the paper.

* KOA_generate_recommendations.ipynb
  Original evaluation notebook used to generate the results reported in the paper, including recommendation generation, Logical Soundness (LS) evaluation, Expert Rating (ER) assessment support, and scalability measurements.

* KOA_generate_recommendations_with_inference.ipynb
  Reviewer-oriented version of the evaluation notebook. In addition to generating recommendations, this notebook exposes symbolic inference traces and recommendation explanations derived from the executable semantic model, allowing inspection of how recommendations are supported by explicit predicates and logical rules.

## Execution Workflow

The repository follows the same sequence described in the paper:

1. Raw data is transformed into executable Prolog facts through the Semantic Onboarding process.

2. Business requirements are interpreted through Ontological Unpacking, producing the executable semantic rules contained in rules.pl.

3. KOA_generate_recommendations.ipynb combines the generated facts and rules to reproduce the experimental results reported in the paper, including recommendation generation, Logical Soundness evaluation, and scalability measurements.

4. KOA_generate_recommendations_with_inference.ipynb provides an extended reviewer-oriented view of the reasoning process by exposing symbolic inference traces and recommendation explanations generated from the executable semantic model.

## Reproducibility Notes

The notebooks are designed to be executed independently and include explanatory comments describing each processing step.

The generated recommendations are derived through symbolic reasoning over the executable semantic model. The accompanying inference traces allow reviewers to inspect how the final recommendations are supported by explicit predicates and logical rules.

The Ontological Unpacking artifact demonstrates how natural-language business requirements are transformed into executable recommendation rules. The resulting semantic structures are subsequently used by the recommendation engine and therefore participate directly in recommendation generation, logical evaluation, and explanation production.
