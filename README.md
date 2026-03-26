# Benchmarking Large Language Models for Cell-Free RNA Diagnostic Biomarker Discovery

## Overview

This repository contains the complete code and data used in the study:

> **"Benchmarking large language models for cell-free RNA diagnostic biomarker discovery"**
>
> Hunter A. Gaudio, Andrew Bliss, Conor J. Loy, Daniel Eweis-LaBolle, Anne E. Gardella, Iwijn De Vlaminck
>
> Meinig School of Biomedical Engineering, Cornell University

This study evaluates whether large language models (LLMs) can identify diagnostically informative gene panels from cell-free RNA (cfRNA) data, and compares their performance against traditional differential expression approaches and machine learning classifiers. Six LLMs (OpenAI o3, OpenAI GPT-4o, Claude Opus 4, Claude 3.7 Sonnet, Gemini 2.5 Pro, Gemini 2.0 Flash) were benchmarked across three clinical cohorts: Kawasaki disease (KD) vs. multisystem inflammatory syndrome in children (MIS-C), tuberculosis (TB) vs. symptomatic controls, and myalgic encephalomyelitis/chronic fatigue syndrome (ME/CFS) vs. sedentary controls.

## System Requirements

### Software dependencies

- **R** (version 4.3.0 or higher)
- **RStudio** (recommended for running `.ipynb` notebooks via R kernel, or Jupyter with IRkernel)
- **Bioconductor** (version 3.18 or higher)

### R packages

#### CRAN packages
- magrittr, dplyr, tidyverse, tidyr, tibble, stringr, purrr, broom
- matrixStats, patchwork, tidytext, ggpubr

#### Bioconductor packages
- GSVA, GSEABase, org.Hs.eg.db, AnnotationDbi, limma, DESeq2, edgeR, ComplexHeatmap

### Operating systems

The code has been tested on:
- macOS Sonoma 14.x (Apple Silicon / M-series)
- Ubuntu 22.04 LTS

No non-standard hardware is required. All analyses run on a standard desktop or laptop computer.

## Installation Guide

### 1. Install R

Download and install R ≥ 4.3.0 from [CRAN](https://cran.r-project.org/).

### 2. Install CRAN packages

```r
install.packages(c(
  "magrittr", "dplyr", "tidyverse", "tidyr", "tibble",
  "stringr", "purrr", "broom", "matrixStats",
  "patchwork", "tidytext", "ggpubr",
  "caret", "randomForest", "extraTrees", "glmnet", "nnet"
))
```

### 3. Install Bioconductor packages

```r
install.packages("BiocManager")
BiocManager::install(c(
  "GSVA", "GSEABase", "org.Hs.eg.db", "AnnotationDbi",
  "limma", "DESeq2", "edgeR", "ComplexHeatmap"
))
```

### Typical install time

Installation of all dependencies takes approximately **10–20 minutes** on a standard desktop computer with a broadband internet connection. The Bioconductor annotation package `org.Hs.eg.db` is the largest download (~800 MB).

## Demo

### Running the analysis

1. Clone this repository:
   ```bash
   git clone https://github.com/adb258/cfrna_ai_manuscript.git
   cd cfrna_ai_manuscript
   ```

2. Open `code/fullpipeline_res.ipynb` in RStudio or Jupyter (with an R kernel) and run all cells sequentially. This notebook performs:
   - Data loading from the `data/` directory
   - Processing of gene panels (LLM-derived and DESeq2-based)
   - Machine learning model training and evaluation across 100 random seeds
   - Calculation of ROC-AUC and accuracy metrics
   - Aggregation of results
   - Generation of manuscript figures

3. Open `code/ai_figures.ipynb` to generate publication-ready figures, including model performance distributions, cross-model comparisons, and prompt-length analyses.

### Expected output

Running `fullpipeline_res.ipynb` produces:
- ROC-AUC distributions for each feature-selection method and classifier (corresponding to Figures 2, S2, and S3 in the manuscript)
- Accuracy distributions for the end-to-end LLM pipeline comparison (Figure 4B)
- Aggregated results files (`auc_data_full.csv`, `fullpipeline_all_accuracy.csv`, `master_auc.csv`) written to the `data/` directory

Running `ai_figures.ipynb` produces:
- All main-text and supplementary figures as displayed in the manuscript

### Expected run time

On a standard desktop computer (e.g., Apple M2, 16 GB RAM), the full analysis pipeline (`fullpipeline_res.ipynb`) completes in approximately **30–60 minutes**. Figure generation (`ai_figures.ipynb`) completes in under **5 minutes**.

## Instructions for Use

### Reproducing the manuscript results

To reproduce all quantitative results reported in the manuscript, run the two notebooks in order:

1. `code/fullpipeline_res.ipynb` — full analysis pipeline
2. `code/ai_figures.ipynb` — figure generation

All input data (gene panels, count matrices, LLM outputs) are included in the `data/` directory. No external data downloads are required.

### Running on your own data

To apply this benchmarking framework to a new dataset:

1. Prepare a gene-by-sample count matrix in CSV format with sample IDs as column headers and gene names as row names.
2. Generate LLM gene panels by submitting your gene list and a diagnostic prompt to an LLM (see Supplementary Tables S1–S10 in the manuscript for prompt templates).
3. Save the LLM-returned gene panels as CSV files in the `data/` directory, following the naming convention `<COHORT>_<MODEL>_<PROMPT>_<GENECOUNT>_<SEEDCOUNT>_array.csv`.
4. Modify the cohort-specific parameters in `fullpipeline_res.ipynb` (file paths, DESeq2 filtering thresholds, sample partitioning constraints) and run the notebook.

## Data

### Gene panel files

LLM-derived gene panels evaluated in downstream ML models. Naming convention: `<PROMPT_TYPE>_<GENE_COUNT>_array.csv`.

Example: `KD_MISC_3.7sonnet_long_200gene_100seed_array.csv`

### Differential expression baselines

DESeq2-derived gene panels for each cohort: `KD_MISC_DESeq2.csv`, `TB_DESeq2.csv`, `MECFS_DESeq2.csv`

### LLM-derived gene lists

Raw gene lists returned by each LLM prior to downstream evaluation (e.g., `KD_gpt_genes.csv`, `KD_gemini_genes.csv`, `KD_claude_genes.csv`).

### Aggregated results

Pre-computed results files: `auc_data.rds`, `auc_data_full.csv`, `fullpipeline_stats.csv`, `fullpipeline_all_accuracy.csv`, `master_auc.csv`.

### Prompt analysis files

Files quantifying prompt adherence: `shortvs_long_length_stats.csv`, `deviation_length_all.csv`, `badgenes_data_all.csv`.

### Additional directories

- `GSEA preranked inputs/` — inputs for pathway enrichment analysis
- `full pipeline/` — intermediate outputs from full pipeline runs
- `long prompts/` — outputs from long prompt experiments
- `short prompts/short_prompts/` — outputs from short prompt experiments

## Public Data Availability

The raw sequencing data and de-identified RNA-seq count matrices are available in the Gene Expression Omnibus under accession codes:
- [GSE255555](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?&acc=GSE255555) (KD/MIS-C)
- [GSE255071](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE255071), [GSE255073](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE255073), [GSE255074](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE255074) (TB)
- [GSE293840](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE293840) (ME/CFS)

## License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.

