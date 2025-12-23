# scRNA-seq Workflows

Reproducible **end-to-end scRNA-seq workflows** — from **raw FASTQs** to **annotated cell types** and **biological interpretation-ready outputs**.

**Scope (what you’ll find here):**
- **Processing:** Cell Ranger → CellBender → QC → integration → annotation
- **Biological analysis:** downstream interpretation templates (markers, DE, scores, summaries)
- **Utilities:** reusable helper scripts for large files, metadata handling, HPC runs

> Philosophy: keep it **clean, reproducible, and explainable**. If it can’t be re-run, it didn’t happen. 🙂

---

## Requirements

- Linux recommended
- Conda/Mamba (or equivalent)
- Cell Ranger installed and available on `PATH` (if using the Cell Ranger workflow)
- Python environment for downstream steps (Scanpy/scverse ecosystem)

---

## Quick start

### 1) Create environment with **Conda/Mamba**

```bash
mamba env create -f envs/scrna-workflows.yml
mamba activate scrna-workflows
python -m ipykernel install --user --name scrna-workflows --display-name "scrna-workflows"
```
---

## External steps (command-line runners)

### 1) Cell Ranger (FASTQ → matrix)
```bash
bash scripts/bash/run_cellranger_count.sh \
  --fastq_dir /path/to/fastqs \
  --sample SAMPLE_ID \
  --transcriptome /path/to/refdata \
  --outdir /path/to/out/cellranger
```

### 2) CellBender (ambient RNA removal)
```bash
bash scripts/bash/run_cellbender.sh \
  --input_h5 /path/to/out/cellranger/SAMPLE_ID/outs/raw_feature_bc_matrix.h5 \
  --out_h5 /path/to/out/cellbender/SAMPLE_ID/cellbender_filtered.h5 \
  --cuda \
  --fpr 0.01 \
  --learning_rate 0.00005
```

After running these steps, `notebooks/00_setup.ipynb` should point to the resulting files (e.g., `*.h5`, `*.h5ad`) for downstream analysis.
