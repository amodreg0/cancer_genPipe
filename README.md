# cancer_genPipe

A Nextflow (DSL1) pipeline for somatic variant calling in cancer whole-genome sequencing data. Starting from GDC BAM IDs, the pipeline downloads tumor/normal pairs, realigns them to both **GRCh38** and **T2T-CHM13v2** reference genomes, and runs somatic SNV, indel, SV, and MSI callers in parallel on both assemblies.

---

## Pipeline overview

```
GDC download (tumor + normal BAM)
        │
        ▼
Reference genome detection (Detect.py)
        │
   ┌────┴────┐
already    needs
aligned  realignment
   │         │
   │    bwa-mem2 → MarkDuplicates → BQSR
   │         │
   └────┬────┘
        │
        ▼
Prepare custom reference (ExpandReference.py)
   [matches BAM contig list to avoid Strelka2 SIGSEGV]
        │
   ┌────┴──────────────────────┐
   ▼                           ▼
MSIsensor                  Manta (SV calling)
                               │
                               ▼
                           Strelka2 (SNV + indel calling)
```

Both the **hg38** and **T2T** paths run in parallel with identical logic.

---

## Requirements

### Software
- [Nextflow](https://www.nextflow.io/) ≥ 21.x (DSL1)
- [Docker](https://www.docker.com/) or [Singularity](https://sylabs.io/) (containers used per process)
- `bwa-mem2`
- `samtools`
- `GATK4`

Variant callers and other tools are pulled automatically via the containers specified in `nextflow.config`.

### Reference files

These must be downloaded separately and placed in the pipeline working directory (or paths adjusted in the `.nf` file). They are excluded from the repository due to size.

#### GRCh38
| File | Source |
|------|--------|
| `GCA_000001405.15_GRCh38_no_alt_analysis_set.fna` + indices (`.fai`, `.pac`, `.ann`, `.amb`, `.0123`, `.bwt.2bit.64`, `.dict`) | [NCBI / GDC reference files](https://gdc.cancer.gov/about-data/gdc-data-processing/gdc-reference-files) |
| `Homo_sapiens_assembly38.dbsnp138.vcf` + `.idx` | [GATK resource bundle](https://gatk.broadinstitute.org/hc/en-us/articles/360035890811) |
| `GRCh38.d1.vd1.fa.bed.gz` + `.tbi` | [GDC reference files](https://gdc.cancer.gov/about-data/gdc-data-processing/gdc-reference-files) |

#### T2T-CHM13v2
| File | Source |
|------|--------|
| `hs1.fa` + indices (placed at `/g/strcombio/fsupek_decider/amodrego/genome_files/`) | [UCSC T2T-CHM13v2](https://hgdownload.soe.ucsc.edu/goldenPath/hs1/bigZips/) |
| `chm13v2.0_dbSNPv155.vcf.gz` + `.tbi` | [NCBI dbSNP / T2T](https://ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606/VCF/) |
| `hs1.fa.bed.gz` + `.tbi` | Generated from T2T FASTA with `bedtools` |

#### Helper scripts (included in repo)
| File | Purpose |
|------|---------|
| `Detect.py` | Identifies the reference genome a BAM was aligned to |
| `ExpandReference.py` | Builds a custom reference FASTA matching the BAM's contig list |
| `RetrieveReadGroupInfo.py` | Extracts read group metadata from BAM header |
| `GDCRetrieveSex.py` | Queries GDC API for patient sex |
| `contig_mappings.txt` | Contig name translation table (UCSC ↔ Ensembl ↔ NCBI) |
| `filter_contig_from_genref.py` | Filters contigs from reference |
| `get_entrez_fasta.py` | Fetches FASTA sequences via Entrez |
| `reorder_fa_seqs.py` | Reorders FASTA sequences to match BAM header |

---

## Usage

### Parameters

| Parameter | Description |
|-----------|-------------|
| `--normalId` | GDC file UUID for the normal BAM |
| `--tumorId` | GDC file UUID for the tumor BAM |
| `--caseId` | GDC case UUID (used to retrieve patient sex) |
| `--basePublish` | Output directory for results |

### GDC token

Place a valid GDC access token in `gdc_token.txt` in the working directory. This file is excluded from git (never commit credentials).

### Run

```bash
nextflow run NextflowPipeline2.nf \
  --normalId  <GDC_normal_bam_uuid> \
  --tumorId   <GDC_tumor_bam_uuid> \
  --caseId    <GDC_case_uuid> \
  --basePublish /path/to/output \
  -c nextflow.config \
  -profile <your_profile>
```

---

## Outputs

Results are published under `--basePublish` organised by tool and reference:

```
<basePublish>/
├── msisensor_hg38/          # MSIsensor microsatellite instability scores
├── manta_somatic_hg38/      # Manta somatic SVs (GRCh38)
├── strelka_somatic_hg38/    # Strelka2 somatic SNVs + indels (GRCh38)
├── manta_somatic_t2t/       # Manta somatic SVs (T2T-CHM13v2)
└── strelka_somatic_t2t/     # Strelka2 somatic SNVs + indels (T2T-CHM13v2)
```

---

## Pipeline details

### Reference genome detection and routing

Each downloaded BAM is inspected by `Detect.py` against the target reference dictionary. If the BAM is already aligned to the correct assembly (flag `0`), it is passed directly to the callers. Otherwise it is realigned with `bwa-mem2`.

### Realignment

1. **Sort by name** → extract FASTQ pairs with `samtools fastq`
2. **Align** with `bwa-mem2 mem`
3. **Mark duplicates** with `GATK MarkDuplicates`
4. **Base quality score recalibration** with `GATK BaseRecalibrator` + `ApplyBQSR` using dbSNP as known sites

### Custom reference preparation (`prepare_reference_genome`)

Strelka2 requires the reference FASTA `@SQ` list to exactly match the BAM header. `ExpandReference.py` builds a per-BAM reference by fetching any missing contigs from Entrez and reordering sequences to match the BAM header, preventing `SIGSEGV` crashes on non-standard contigs (decoys, alts, EBV, etc.).

### Variant calling

| Tool | Variant types | Notes |
|------|--------------|-------|
| [MSIsensor](https://github.com/ding-lab/msisensor) | Microsatellite instability | hg38 only |
| [Manta](https://github.com/Illumina/manta) | Structural variants | Provides indel candidates to Strelka2 |
| [Strelka2](https://github.com/Illumina/strelka) | SNVs, small indels | Uses Manta candidate indels |

---

## Notes

- T2T reference FASTA files are stored at an absolute path on the cluster (`/g/strcombio/fsupek_decider/amodrego/genome_files/`) and are not downloaded by the pipeline. Adjust this path in `NextflowPipeline2.nf` if running on a different system.
- `gdc_token.txt` is required for GDC downloads but must never be committed to version control.
- This pipeline uses **Nextflow DSL1**. It is not compatible with DSL2 without refactoring.
