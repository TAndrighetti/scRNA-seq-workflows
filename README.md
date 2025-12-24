## Code structure and execution philosophy

This repository collects my **current scRNA-seq analysis workflows**, reflecting how I routinely work with single-cell data in practice. The focus is on **code structure, reproducibility, and analytical logic**, rather than on providing a step-by-step tutorial or discussing biological results in depth.

---

## High-level organization

### Preprocessing (server-side, command line)

The initial preprocessing steps — **Cell Ranger** and **CellBender** — are designed to be executed in a **server or HPC environment**, using **shell / Bash scripts**.  
These steps are computationally intensive and therefore not intended for interactive execution.

They operate directly on raw sequencing data and produce gene–barcode matrices that are later consumed by downstream Python workflows.

---

### Downstream analysis (Python notebooks)

All subsequent steps are implemented in **Python**, primarily using **Jupyter notebooks**, covering:

- Quality control (QC)
- Data integration
- Clustering
- Cell type annotation
- Downstream biological analyses
- Visualization and result summarization

---

### Differential expression (Python + R)

Differential expression analyses are orchestrated from Python notebooks but internally rely on **R (MAST)**.  
This allows combining the flexibility of Python-based workflows with well-established statistical models implemented in R, within a single reproducible pipeline.

---

## Notebook design pattern

Most notebooks follow a consistent internal structure:

1. **Functions and configuration**  
   Definition of reusable functions, parameters, and global settings.
2. **Execution**  
   Application of the functions to the data.
3. **Results**  
   Outputs mainly in the form of **tables and figures** (QC plots, UMAPs, heatmaps, volcano plots, etc.).

This structure supports modularity, readability, and iterative analysis.

---

## Scope and intent of the repository

This repository is intended to **present how I work with scRNA-seq data from a computational perspective**.

- The repository contains **code only**.
- The underlying datasets are **not publicly available yet**.
- For this reason:
  - biological interpretations are not discussed in detail,
  - extensive dataset-specific descriptions are intentionally omitted.

At this stage, the repository is **not designed as a tutorial**, but rather as a transparent presentation of my working workflows and coding practices.

These workflows represent my **current working state** and are **continuously evolving** as methods and best practices improve.

---

## Conda environment and reproducibility

To ensure reproducibility, this repository provides **Conda environment definitions**.

Users are strongly encouraged to create a **dedicated Conda (or Mamba) environment** using the files available in the `envs/` directory for using the codes.  
This environment contains:

- the Python ecosystem used throughout the notebooks (Scanpy / scverse),
- visualization libraries,
- utilities for large data handling,
- dependencies required for Python–R interoperability (e.g. MAST-based DE analysis).

### Bash / Command line – environment setup

```bash
### Create the environment
mamba env create -f envs/scrna-workflows.yml

### Activate the environment
mamba activate scrna-workflows

### Register the environment as a Jupyter kernel
python -m ipykernel install --user --name scrna-workflows --display-name "scrna-workflows"
```
---

## Computational environment

- **Cell Ranger** and **CellBender** were executed on a **server environment** suitable for heavy preprocessing.
- All **Jupyter notebooks** were also run in a local system with the following configurations:

- OS: Ubuntu 22.04 LTS (64-bit)
- CPU: 12th Gen Intel® Core™ i5-12600KF
- RAM: 128 GB
- GPU: NVIDIA
- Storage: ~1.5 TB

---

## From raw data to analysis-ready objects

In typical scRNA-seq projects:

1. **Raw data:** Data are delivered as **raw FASTQ files**.
2. **Cell Ranger:** For **10x Genomics platforms**, one FASTQ set per sample is processed with **Cell Ranger**, where raw gene–barcode matrices are generated (for other platforms, alternative preprocessing software is used.)
3. **CellBender:** The raw matrix (commonly named `raw_feature_bc_matrix.h5`) is submitted to **CellBender** for ambient RNA correction.
4. CellBender outputs a corrected matrix, which becomes the input for the **quality control notebook**.
The QC step:
- generates diagnostic plots for parameter tuning,
- exports a QC summary table,
- and produces an **AnnData (`.h5ad`) object** containing a filtered data layer.

All downstream notebooks:
- take the `.h5ad` output from the previous step as input,
- perform the next analysis stage,
- and return a new `.h5ad` object together with analysis figures.

---

## Methodological references

The main methodological references guiding these workflows are:

- Scanpy documentation: https://scanpy.readthedocs.io/en/stable/
- Single-cell best practices: https://www.sc-best-practices.org/preamble.html
- Decoupler (pathway and TF activity inference):  
  https://decoupler.readthedocs.io/en/latest/notebooks/scell/index.html
