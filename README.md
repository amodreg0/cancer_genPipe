# Somatic Variant Calling Pipeline

A [Nextflow](https://www.nextflow.io/) (DSL1) pipeline for somatic variant calling from GDC-hosted tumor/normal BAM pairs. The pipeline supports **two reference genomes in parallel**: GRCh38 (hg38) and T2T-CHM13v2 (t2t), automatically detecting whether input BAMs need realignment and running the full preprocessing + calling stack for each genome.

---

## Overview

```
GDC Download (normal + tumor BAM)
        │
        ├──────────────────────────────┐
        ▼                              ▼
  [hg38 path]                   [t2t path]
        │                              │
  Reference recognition          Reference recognition
  (already aligned? → keep)     (already aligned? → keep)
        │                              │
  Realignment (bwa-mem2)         Realignment (bwa-mem2)
  MarkDuplicates (GATK)          MarkDuplicates (GATK)
  BQSR (GATK)                    BQSR (GATK)
        │                              │
  Prepare reference genome       Prepare reference genome
  (expand to match BAM contigs)  (expand to match BAM contigs)
        │                              │
  ┌─────┼──────┐               ┌──────┼──────┐
  ▼     ▼      ▼               ▼      ▼
MSIsensor  Manta  Strelka2    Manta  Strelka2
```

---

## Key Features

- **Dual-genome support**: runs hg38 and T2T paths simultaneously on the same samples.
- **Smart routing**: detects the reference genome of each downloaded BAM via `Detect.py`; only realigns if needed, otherwise passes the BAM through directly.
- **Full preprocessing**: collate → fastq → bwa-mem2 alignment → MarkDuplicates → BQSR.
- **Reference expansion**: builds a per-sample reference FASTA whose `@SQ` list exactly matches the BAM header (prevents Strelka2 SIGSEGV on mismatched contigs).
- **Three callers**: MSIsensor (microsatellite instability, hg38 only), Manta (structural variants), and Strelka2 (SNVs + indels). Manta candidate indels are fed into Strelka2.
- **Sex inference**: queries GDC metadata for the case to determine biological sex (currently commented out but wired in via `GDCRetrieveSex.py`).

---

## Requirements

### Software / Containers

| Tool | Version / Container |
|---|---|
| Nextflow | DSL1 |
| GDC client | `cassisbonbon/gdcclient:v1.0` |
| pysam | `quay.io/biocontainers/pysam:0.15.2--py38hbab3036_7` |
| bwa-mem2 | available in the execution environment |
| samtools | available in the execution environment |
| GATK 4 | available in the execution environment |
| Manta | available in the execution environment |
| Strelka2 | available in the execution environment |
| MSIsensor | available in the execution environment (`myenv` conda env) |
| Prepare-reference container | `cassisbonbon/preparereferencegenome:v2.0` |

### Reference Files (hg38)

| File | Description |
|---|---|
| `GCA_000001405.15_GRCh38_no_alt_analysis_set.fna` + index files | GRCh38 reference FASTA and BWA-MEM2 indices |
| `GRCh38.d1.vd1.fa.bed.gz` + `.tbi` | Callable regions BED |
| `Homo_sapiens_assembly38.dbsnp138.vcf` + `.idx` | dbSNP for BQSR |

### Reference Files (T2T)

| File | Description |
|---|---|
| `hs1.fa` + index files | T2T-CHM13v2 reference FASTA and BWA-MEM2 indices |
| `hs1.fa.d1.vd1.bed.gz` + `.tbi` | Callable regions BED |
| `chm13v2.0_dbSNPv155.vcf.gz` + `.tbi` | dbSNP for BQSR |

### GDC Token

A valid GDC data access token must be present at `gdc_token.txt` in the working directory.

### Helper Scripts

All of the following Python scripts must be present in the working directory:

| Script | Purpose |
|---|---|
| `Detect.py` | Determines whether a BAM is aligned to a given reference |
| `ExpandReference.py` | Expands a base FASTA to include all contigs present in the BAM header |
| `RetrieveReadGroupInfo.py` | Extracts read-group metadata from a BAM |
| `GDCRetrieveSex.py` | Queries GDC API for biological sex of a case |
| `contig_mappings.txt` | Contig name mapping table used by `ExpandReference.py` |
| `filter_contig_from_genref.py` | Filters contigs from a genome reference |
| `get_entrez_fasta.py` | Fetches FASTA sequences from Entrez |
| `reorder_fa_seqs.py` | Reorders FASTA sequences |

---

## Parameters

| Parameter | Description |
|---|---|
| `params.normalId` | GDC UUID of the normal sample BAM |
| `params.tumorId` | GDC UUID of the tumor sample BAM |
| `params.caseId` | GDC case UUID (used for sex inference) |
| `params.basePublish` | Base output directory for published results |

Example invocation:

```bash
nextflow run main.nf \
  --normalId  <GDC_NORMAL_UUID> \
  --tumorId   <GDC_TUMOR_UUID> \
  --caseId    <GDC_CASE_UUID> \
  --basePublish /path/to/results
```

---

## Outputs

Results are published under `params.basePublish`:

| Directory | Contents |
|---|---|
| `msisensor_hg38/` | MSIsensor output files (`output`, `output_somatic`, `output_dis`, `output_germline`) |
| `manta_somatic_hg38/` | Manta VCFs for hg38 (`somaticSV`, `diploidSV`, `candidateSV`, `candidateSmallIndels`) |
| `strelka_somatic_hg38/` | Strelka2 VCFs for hg38 (SNVs and indels) |
| `manta_somatic_t2t/` | Manta VCFs for T2T |
| `strelka_somatic_t2t/` | Strelka2 VCFs for T2T (SNVs and indels) |

---

## Pipeline Steps in Detail

### 1. GDC Download
Downloads normal and tumor BAMs from the GDC portal using `gdc-client`. Retries up to 10 times on failure.

### 2. Reference Genome Recognition
Runs `Detect.py` (via pysam) against both the hg38 and T2T sequence dictionaries. Returns `0` if the BAM is already aligned to that reference, or a non-zero value otherwise. This determines the routing decision for each sample.

### 3. Routing
BAMs are split into two branches:
- **`keep`** (`isGRCh38 == '0'`): already aligned → passed directly to downstream processes.
- **`realign`** (`isGRCh38 != '0'`): needs realignment → sent to the realignment process.

### 4. Realignment
For BAMs that need realignment:
1. `samtools collate` + `samtools fastq` to extract reads (hg38 uses streaming collate; T2T uses `samtools sort -n` then fastq to handle paired-end extraction more robustly).
2. `bwa-mem2 mem` alignment with read-group tags injected via `samtools addreplacerg`.
3. `awk` adds assembly (`AS:`) and species (`SP:`) tags to `@SQ` lines.
4. `gatk MarkDuplicates` removes PCR duplicates.
5. `gatk BaseRecalibrator` + `gatk ApplyBQSR` for base quality score recalibration.
6. `samtools index` to produce the `.bai` index.

### 5. Prepare Reference Genome
Runs `ExpandReference.py` to build a sample-specific reference FASTA that includes every contig named in the BAM header (fetching missing sequences via Entrez if needed). This is critical: without it, Strelka2 crashes with a segfault (`SIGSEGV`) when the BAM header references contigs absent from the `.fai`.

### 6. MSIsensor (hg38 only)
Scans the reference for microsatellite sites, then scores microsatellite instability from the normal/tumor BAM pair.

### 7. Manta
Calls somatic structural variants. Configured with `--callRegions` to restrict to callable regions. Outputs candidate small indels that are passed to Strelka2.

### 8. Strelka2
Calls somatic SNVs and small indels, using Manta's candidate indels to improve sensitivity. Configured with `--reportEVSFeatures` for empirical variant scoring.

---

## Notes

- The pipeline is written in **Nextflow DSL1**. It is not compatible with DSL2 syntax without refactoring.
- The `params.sex` parameter exists in the code (commented out) but sex is currently inferred dynamically via GDC metadata.
- The T2T realignment processes include the BAI file as an explicit input (unlike hg38), since some tools require it to be co-located with the BAM.
- Temporary directories for collate, sort, and MarkDuplicates are created locally within the task work directory and cleaned up at the end of each realignment process.
