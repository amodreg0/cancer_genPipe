//params.sex = 'female'


reference_genome_detector = file('Detect.py')
expandReference = file('ExpandReference.py')
retrieveReadGroupInfo = file('RetrieveReadGroupInfo.py')

contig_mappings = file('contig_mappings.txt')
filter_contig_from_genref = file('filter_contig_from_genref.py')
get_entrez_fasta = file('get_entrez_fasta.py')
reorder_fa_seqs = file('reorder_fa_seqs.py')

normal_sample_id = Channel.of(params.normalId)
tumor_sample_id = Channel.of(params.tumorId)
case_sample_id = Channel.of(params.caseId)

GDCRetrieveSex = file('GDCRetrieveSex.py')

gdc_download_tries = 10
gdctok = file( 'gdc_token.txt' )

reference_hg38_ch = Channel.value(file('GCA_000001405.15_GRCh38_no_alt_analysis_set.fna'))
reference_hg38_index_ch = Channel.value(file('GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.fai'))
reference_hg38_index_pac_ch = Channel.value(file('GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.pac'))
reference_hg38_index_ann_ch = Channel.value(file('GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.ann'))
reference_hg38_index_amb_ch = Channel.value(file('GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.amb'))
reference_hg38_index_0123_ch = Channel.value(file('GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.0123'))
reference_hg38_index_bwt_ch = Channel.value(file('GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.bwt.2bit.64'))
reference_hg38_index_dict_ch = Channel.value(file('GCA_000001405.15_GRCh38_no_alt_analysis_set.dict'))

reference_t2t_ch = Channel.value(file('/g/strcombio/fsupek_decider/amodrego/genome_files/hs1.fa'))
reference_t2t_index_ch = Channel.value(file('/g/strcombio/fsupek_decider/amodrego/genome_files/hs1.fa.fai'))
reference_t2t_index_pac_ch = Channel.value(file('/g/strcombio/fsupek_decider/amodrego/genome_files/hs1.fa.pac'))
reference_t2t_index_ann_ch = Channel.value(file('/g/strcombio/fsupek_decider/amodrego/genome_files/hs1.fa.ann'))
reference_t2t_index_amb_ch = Channel.value(file('/g/strcombio/fsupek_decider/amodrego/genome_files/hs1.fa.amb'))
reference_t2t_index_0123_ch = Channel.value(file('/g/strcombio/fsupek_decider/amodrego/genome_files/hs1.fa.0123'))
reference_t2t_index_bwt_ch = Channel.value(file('/g/strcombio/fsupek_decider/amodrego/genome_files/hs1.fa.bwt.2bit.64'))
reference_t2t_index_dict_ch = Channel.value(file('/g/strcombio/fsupek_decider/amodrego/genome_files/hs1.dict'))


callingRegions_hg38_ch = Channel.value(file('GRCh38.d1.vd1.fa.bed.gz'))
callingRegions_hg38_ch_index = Channel.value(file('GRCh38.d1.vd1.fa.bed.gz.tbi'))

callingRegions_t2t_ch = Channel.value(file('hs1.fa.d1.vd1.bed.gz'))
callingRegions_t2t_ch_index = Channel.value(file('hs1.fa.d1.vd1.bed.gz.tbi'))


dbsnp_hg38 = file('Homo_sapiens_assembly38.dbsnp138.vcf')
dbsnp_hg38_index = file('Homo_sapiens_assembly38.dbsnp138.vcf.idx')

dbsnp_t2t = file('chm13v2.0_dbSNPv155.vcf.gz')
dbsnp_t2t_index = file('chm13v2.0_dbSNPv155.vcf.gz.tbi')

normal_sample_id.into{
  gdcid_normalbam_ch;
  normal_bam_to_realigned_bam_hg38_id;
  normal_bam_to_realigned_bam_t2t_id
}

tumor_sample_id.into{
  gdcid_tumorbam_ch;
  tumor_bam_to_realigned_bam_hg38_ch;
  tumor_bam_to_realigned_bam_t2t_ch
}

callingRegions_hg38_ch.into{
  manta_somatic_calling_regions_hg38_ch;
  strelka_somatic_calling_regions_hg38_ch
}

callingRegions_hg38_ch_index.into{
  manta_somatic_calling_regions_index_hg38_ch;
  strelka_somatic_calling_regions_index_hg38_ch
}

reference_hg38_ch.into{
  normal_bam_to_realigned_bam_reference_hg38_ch;
  tumor_bam_to_realigned_bam_reference_hg38_ch;
  prepare_reference_genome_hg38_reference_ch;
  msisensor_somatic_hg38_ch
}

reference_hg38_index_ch.into{
  normal_realignment_hg38_index_ch;
  tumor_realignment_hg38_index_ch;
  msisensor_somatic_hg38_index_ch
}

reference_hg38_index_dict_ch.into{
  normal_recognition_hg38_dict_ch;
  tumor_recognition_hg38_dict_ch;
  normal_realignment_hg38_dict_ch;
  tumor_realignment_hg38_dict_ch
}

callingRegions_t2t_ch.into{
  manta_somatic_calling_regions_t2t_ch;
  strelka_somatic_calling_regions_t2t_ch
}

callingRegions_t2t_ch_index.into{
  manta_somatic_calling_regions_index_t2t_ch;
  strelka_somatic_calling_regions_index_t2t_ch
}

reference_t2t_ch.into{
  normal_bam_to_realigned_bam_reference_t2t_ch;
  tumor_bam_to_realigned_bam_reference_t2t_ch;
  prepare_reference_genome_t2t_reference_ch
}

reference_t2t_index_ch.into{
  normal_realignment_t2t_index_ch;
  tumor_realignment_t2t_index_ch
}

reference_t2t_index_dict_ch.into{
  normal_recognition_t2t_dict_ch;
  tumor_recognition_t2t_dict_ch;
  normal_realignment_t2t_dict_ch;
  tumor_realignment_t2t_dict_ch
}


process retrieve_sex {
  input:
    val case_id from case_sample_id
  output:
    env(sex) into sex_ch
  shell:
  """
    sex=`python3 !{GDCRetrieveSex} -c !{case_id}`
  """
}

process gdc_download_normal {
  container 'cassisbonbon/gdcclient:v1.0'

  input:
    val gdcid_normalbam from gdcid_normalbam_ch
  output:
    file "*.bam" into downloaded_normal_bam_ch
    file "*.bai" into downloaded_normal_bai_ch
  shell:
  """
    mkdir ./step_output_dir
    gdc-client download -n !{task.cpus*3} -t !{gdctok} -d ./step_output_dir --retry-amount !{gdc_download_tries} !{gdcid_normalbam} || exit 1
    find . -name *.bam |xargs -iz mv z .
    find . -name *.bai |xargs -iz mv z .
  """
}

// Fan out downloaded normal BAM/BAI into the recognition processes and the
// branching channels, for BOTH hg38 and t2t paths.
downloaded_normal_bam_ch.into{
  normal_reference_genome_recognition_hg38_bamFile_ch;
  normal_reference_genome_recognition_t2t_bamFile_ch;
  normal_routing_decision_bam_input_hg38;
  normal_routing_decision_bam_input_t2t
}

downloaded_normal_bai_ch.into{
  normal_routing_decision_bai_input_hg38;
  normal_routing_decision_bai_input_t2t
}

process gdc_download_tumor {
  container 'cassisbonbon/gdcclient:v1.0'

  input:
    val gdcid_tumorbam from gdcid_tumorbam_ch
  output:
    file "*.bam" into downloaded_tumor_bam_ch
    file "*.bai" into downloaded_tumor_bai_ch
  shell:
  """
    mkdir ./step_output_dir
    gdc-client download -n !{task.cpus*3} -t !{gdctok} -d ./step_output_dir --retry-amount !{gdc_download_tries} !{gdcid_tumorbam} || exit 1
    find . -name *.bam |xargs -iz mv z .
    find . -name *.bai |xargs -iz mv z .
  """
}

downloaded_tumor_bam_ch.into{
  tumor_reference_genome_recognition_hg38_bamFile_ch;
  tumor_reference_genome_recognition_t2t_bamFile_ch;
  tumor_routing_decision_bam_input_hg38;
  tumor_routing_decision_bam_input_t2t
}

downloaded_tumor_bai_ch.into{
  tumor_routing_decision_bai_input_hg38;
  tumor_routing_decision_bai_input_t2t
}


reference_hg38_index_pac_ch.set{reference_hg38_pac_ch}
reference_hg38_index_ann_ch.set{reference_hg38_ann_ch}
reference_hg38_index_amb_ch.set{reference_hg38_amb_ch}
reference_hg38_index_0123_ch.set{reference_hg38_0123_ch}
reference_hg38_index_bwt_ch.set{reference_hg38_bwt_2bit_ch}


reference_t2t_index_pac_ch.set{reference_t2t_pac_ch}
reference_t2t_index_ann_ch.set{reference_t2t_ann_ch}
reference_t2t_index_amb_ch.set{reference_t2t_amb_ch}
reference_t2t_index_0123_ch.set{reference_t2t_0123_ch}
reference_t2t_index_bwt_ch.set{reference_t2t_bwt_2bit_ch}


// HG38 REFERENCE INDEX FILES
reference_hg38_pac_ch.into{
  normal_bam_index_pac_output_hg38_ch;
  tumor_bam_index_pac_output_hg38_ch
}
reference_hg38_ann_ch.into{
  normal_bam_index_ann_output_hg38_ch;
  tumor_bam_index_ann_output_hg38_ch
}
reference_hg38_amb_ch.into{
  normal_bam_index_amb_output_hg38_ch;
  tumor_bam_index_amb_output_hg38_ch
}
reference_hg38_0123_ch.into{
  normal_bam_index_0123_output_hg38_ch;
  tumor_bam_index_0123_output_hg38_ch
}
reference_hg38_bwt_2bit_ch.into{
  normal_bam_index_bwt_2bit_output_hg38_ch;
  tumor_bam_index_bwt_2bit_output_hg38_ch
}

// T2T REFERENCE INDEX FILES
reference_t2t_pac_ch.into{
  normal_bam_index_pac_output_t2t_ch;
  tumor_bam_index_pac_output_t2t_ch
}
reference_t2t_ann_ch.into{
  normal_bam_index_ann_output_t2t_ch;
  tumor_bam_index_ann_output_t2t_ch
}
reference_t2t_amb_ch.into{
  normal_bam_index_amb_output_t2t_ch;
  tumor_bam_index_amb_output_t2t_ch
}
reference_t2t_0123_ch.into{
  normal_bam_index_0123_output_t2t_ch;
  tumor_bam_index_0123_output_t2t_ch
}
reference_t2t_bwt_2bit_ch.into{
  normal_bam_index_bwt_2bit_output_t2t_ch;
  tumor_bam_index_bwt_2bit_output_t2t_ch
}


/////////////////////////////////////////////////////
//////// HG38 RECOGNITION + ROUTING WORKFLOW ////////
/////////////////////////////////////////////////////

process normal_reference_genome_recognition_hg38 {
  container 'quay.io/biocontainers/pysam:0.15.2--py38hbab3036_7'

  input:
    file bamFile                from normal_reference_genome_recognition_hg38_bamFile_ch
    file reference_genome_dict  from normal_recognition_hg38_dict_ch
  output:
    env(isGRCh38) into normal_reference_genome_recognition_hg38_output
  shell:
  """
  isGRCh38=`python3 !{reference_genome_detector} -b !{bamFile} -d !{reference_genome_dict}`
  """
}

normal_reference_genome_recognition_hg38_output.into{
  normal_recognition_hg38_for_bam;
  normal_recognition_hg38_for_bai
}

normal_recognition_hg38_for_bam.merge(normal_routing_decision_bam_input_hg38).set{normal_decision_input_hg38}
normal_recognition_hg38_for_bai.merge(normal_routing_decision_bai_input_hg38).set{normal_index_decision_input_hg38}

normal_decision_input_hg38.branch {
    realign: it[0] != '0'
    keep:    it[0] == '0'
    problem: true
}.set { normal_result_hg38 }

normal_bam_to_realign_hg38_ch = Channel.create()
normal_bam_correctly_aligned_hg38_ch = Channel.create()

normal_result_hg38.realign.separate( normal_bam_to_realign_hg38_ch ) { a -> [a[1]] }
normal_result_hg38.keep.separate( normal_bam_correctly_aligned_hg38_ch ) { a -> [a[1]] }

normal_index_decision_input_hg38.branch {
  realign: it[0] != '0'
  keep:    it[0] == '0'
  problem: true
}.set { normal_index_result_hg38 }

normal_bai_to_realign_hg38_ch = Channel.create()
normal_bai_correctly_aligned_hg38_ch = Channel.create()

normal_index_result_hg38.realign.separate( normal_bai_to_realign_hg38_ch ) { a -> [a[1]] }
normal_index_result_hg38.keep.separate( normal_bai_correctly_aligned_hg38_ch ) { a -> [a[1]] }


process tumor_reference_genome_recognition_hg38 {
  container 'quay.io/biocontainers/pysam:0.15.2--py38hbab3036_7'

  input:
    file bamFile                from tumor_reference_genome_recognition_hg38_bamFile_ch
    file reference_genome_dict  from tumor_recognition_hg38_dict_ch
  output:
    env(isGRCh38) into tumor_reference_genome_recognition_hg38_output
  shell:
  """
  isGRCh38=`python3 !{reference_genome_detector} -b !{bamFile} -d !{reference_genome_dict}`
  """
}

tumor_reference_genome_recognition_hg38_output.into{
  tumor_recognition_hg38_for_bam;
  tumor_recognition_hg38_for_bai
}

tumor_recognition_hg38_for_bam.merge(tumor_routing_decision_bam_input_hg38).set{tumor_decision_input_hg38}
tumor_recognition_hg38_for_bai.merge(tumor_routing_decision_bai_input_hg38).set{tumor_index_decision_input_hg38}

tumor_decision_input_hg38.branch {
    realign: it[0] != '0'
    keep:    it[0] == '0'
    problem: true
}.set { tumor_result_hg38 }

tumor_bam_to_realign_hg38_ch = Channel.create()
tumor_bam_correctly_aligned_hg38_ch = Channel.create()

tumor_result_hg38.realign.separate( tumor_bam_to_realign_hg38_ch ) { a -> [a[1]] }
tumor_result_hg38.keep.separate( tumor_bam_correctly_aligned_hg38_ch ) { a -> [a[1]] }

tumor_index_decision_input_hg38.branch {
  realign: it[0] != '0'
  keep:    it[0] == '0'
  problem: true
}.set { tumor_index_result_hg38 }

tumor_bai_to_realign_hg38_ch = Channel.create()
tumor_bai_correctly_aligned_hg38_ch = Channel.create()

tumor_index_result_hg38.realign.separate( tumor_bai_to_realign_hg38_ch ) { a -> [a[1]] }
tumor_index_result_hg38.keep.separate( tumor_bai_correctly_aligned_hg38_ch ) { a -> [a[1]] }


/////////////////////////////////////////////////////
/////////// HG38 REALIGNING WORKFLOW ////////////////
/////////////////////////////////////////////////////

process normal_bam_to_realigned_bam_hg38 {
  input:
    file reference from normal_bam_to_realigned_bam_reference_hg38_ch
    file reference_pac from normal_bam_index_pac_output_hg38_ch
    file reference_ann from normal_bam_index_ann_output_hg38_ch
    file reference_amb from normal_bam_index_amb_output_hg38_ch
    file reference_0123 from normal_bam_index_0123_output_hg38_ch
    file reference_bwt_2bit from normal_bam_index_bwt_2bit_output_hg38_ch
		file reference_fai from normal_realignment_hg38_index_ch
		file reference_dict from normal_realignment_hg38_dict_ch
    file bam_file from normal_bam_to_realign_hg38_ch
    val normal_id from normal_bam_to_realigned_bam_hg38_id
  output:
    file 'normal_realigned_hg38.bam' into normal_realigned_bam_only_hg38_ch
    file 'normal_realigned_hg38.bam.bai' into normal_realigned_bam_index_hg38_ch
  shell:
  """
  tmp_dir_collate=`mktemp -d --tmpdir=.`
  tmp_dir_sort=`mktemp -d --tmpdir=.`
  tmp_dir_mark_duplicates=`mktemp -d --tmpdir=.`

	readGroupInfo=`python3 !{retrieveReadGroupInfo} !{bam_file}`
  bwa-mem2 mem -t !{task.cpus-9} !{reference} -p <(samtools fastq -@ 2 <(samtools collate -f -O !{bam_file} -@ 2 \$tmp_dir_collate)) | \
    samtools addreplacerg -r "@RG\tID:!{normal_id}\tSM:!{normal_id}\t\$readGroupInfo" - |\
    awk '{if (\$0 ~ "^@SQ") {print \$0 "\t" "AS:GRCh38.d1.vd1" "\t" "SP:Homo sapiens" }else {print \$0}}' |\
    samtools view  -Sb - | \
    samtools sort -o normal_realigned_to_recalibrate.bam -@ 5 -T \$tmp_dir_sort -
  gatk MarkDuplicates I=normal_realigned_to_recalibrate.bam O=normal_realigned_to_recalibrate_rm_duplicates.bam M=marked_dup_metrics.txt REMOVE_DUPLICATES=true TMP_DIR=\$tmp_dir_mark_duplicates
	ls !{dbsnp_hg38_index}
	gatk BaseRecalibrator -I normal_realigned_to_recalibrate_rm_duplicates.bam -R !{reference} --known-sites !{dbsnp_hg38} -O recal_data.table
  gatk ApplyBQSR -R !{reference} -I normal_realigned_to_recalibrate_rm_duplicates.bam --bqsr-recal-file recal_data.table -O normal_realigned_hg38.bam

  samtools index normal_realigned_hg38.bam

  rm -r \$tmp_dir_collate
  rm -r \$tmp_dir_sort
  rm -r \$tmp_dir_mark_duplicates
  """
}


process tumor_bam_to_realigned_bam_hg38 {
  input:
    file reference from tumor_bam_to_realigned_bam_reference_hg38_ch
    file reference_pac from tumor_bam_index_pac_output_hg38_ch
    file reference_ann from tumor_bam_index_ann_output_hg38_ch
    file reference_amb from tumor_bam_index_amb_output_hg38_ch
    file reference_0123 from tumor_bam_index_0123_output_hg38_ch
    file reference_bwt_2bit from tumor_bam_index_bwt_2bit_output_hg38_ch
		file reference_fai from tumor_realignment_hg38_index_ch
		file reference_dict from tumor_realignment_hg38_dict_ch
    file bam_file from tumor_bam_to_realign_hg38_ch
    val tumor_id from tumor_bam_to_realigned_bam_hg38_ch
  output:
    file 'tumor_realigned_hg38.bam' into tumor_realigned_bam_only_hg38_ch
    file 'tumor_realigned_hg38.bam.bai' into tumor_realigned_bam_index_hg38_ch
  shell:
  """
  tmp_dir_collate=`mktemp -d --tmpdir=.`
  tmp_dir_sort=`mktemp -d --tmpdir=.`
  tmp_dir_mark_duplicates=`mktemp -d --tmpdir=.`

	readGroupInfo=`python3 !{retrieveReadGroupInfo} !{bam_file}`
  bwa-mem2 mem -t !{task.cpus-9} !{reference} -p <(samtools fastq -@ 2 <(samtools collate -f -O !{bam_file} -@ 2 \$tmp_dir_collate)) | \
    samtools addreplacerg -r "@RG\tID:!{tumor_id}\tSM:!{tumor_id}\t\$readGroupInfo" - |\
    awk '{if (\$0 ~ "^@SQ") {print \$0 "\t" "AS:GRCh38.d1.vd1" "\t" "SP:Homo sapiens" }else {print \$0}}' |\
    samtools view  -Sb - | \
    samtools sort -o tumor_realigned_to_recalibrate.bam -@ 5 -T \$tmp_dir_sort -
  gatk MarkDuplicates I=tumor_realigned_to_recalibrate.bam O=tumor_realigned_to_recalibrate_rm_duplicates.bam M=marked_dup_metrics.txt REMOVE_DUPLICATES=true TMP_DIR=\$tmp_dir_mark_duplicates
	ls !{dbsnp_hg38_index}
  gatk BaseRecalibrator -I tumor_realigned_to_recalibrate_rm_duplicates.bam -R !{reference} --known-sites !{dbsnp_hg38} -O recal_data.table
  gatk ApplyBQSR -R !{reference} -I tumor_realigned_to_recalibrate_rm_duplicates.bam --bqsr-recal-file recal_data.table -O tumor_realigned_hg38.bam

  samtools index tumor_realigned_hg38.bam

  rm -r \$tmp_dir_collate
  rm -r \$tmp_dir_sort
  rm -r \$tmp_dir_mark_duplicates
  """
}

// Index the realigned BAMs in a separate step (mirroring the working pipeline).
normal_realigned_bam_only_hg38_ch.into{
  index_aligned_normal_bam_hg38_channel;
  realigned_normal_bam_hg38
}

tumor_realigned_bam_only_hg38_ch.into{
  index_aligned_tumor_bam_hg38_channel;
  realigned_tumor_bam_hg38
}


// Mix realigned + correctly-aligned BAMs/BAIs into the final per-sample channels.
realigned_normal_bam_hg38
  .mix(normal_bam_correctly_aligned_hg38_ch)
  .into{
    prepare_reference_genome_hg38_normal_bam;
    msisensor_somatic_bam_normal_file_hg38_ch;
    manta_somatic_normal_bam_normal_file_hg38_ch;
    strelka_somatic_normal_bam_file_hg38_ch
  }

realigned_tumor_bam_hg38
  .mix(tumor_bam_correctly_aligned_hg38_ch)
  .into{
    msisensor_somatic_bam_tumor_file_hg38_ch;
    manta_somatic_normal_bam_tumor_file_hg38_ch;
    strelka_somatic_tumor_bam_file_hg38_ch
  }

normal_bai_correctly_aligned_hg38_ch
  .mix(normal_realigned_bam_index_hg38_ch)
  .into{
    msisensor_somatic_bam_normal_file_index_hg38_ch;
    manta_somatic_normal_bam_normal_file_index_hg38_ch;
    strelka_somatic_normal_bam_file_index_hg38_ch;
    prepare_reference_genome_hg38_normal_bam_index
  }

tumor_bai_correctly_aligned_hg38_ch
  .mix(tumor_realigned_bam_index_hg38_ch)
  .into{
    msisensor_somatic_bam_tumor_file_index_hg38_ch;
    manta_somatic_normal_bam_tumor_file_index_hg38_ch;
    strelka_somatic_tumor_bam_file_index_hg38_ch
  }


/////////////////////////////////////////////////////
////////// HG38 PREPARE REFERENCE GENOME ////////////
/////////////////////////////////////////////////////
// THIS IS THE FIX. Builds a reference fasta whose @SQ list matches what
// is actually present in the BAM header (decoys, alts, EBV, etc.). Without
// this step Strelka2 segfaults (SIGSEGV / exit -11) on every genome segment
// because the BAM header references contigs that are not in the .fai.

process prepare_reference_genome_hg38 {
  container 'cassisbonbon/preparereferencegenome:v2.0'
  input:
    file normal_bam            from prepare_reference_genome_hg38_normal_bam
    file normal_bai            from prepare_reference_genome_hg38_normal_bam_index
    file base_reference_genome from prepare_reference_genome_hg38_reference_ch
  output:
    file('genref_for_bam_hg38.fa')     into reference_genome_hg38_expanded_ch
    file('genref_for_bam_hg38.fa.fai') into reference_genome_index_hg38_expanded_ch
    file('genref_for_bam_hg38.dict')   into reference_genome_dict_hg38_expanded_ch
  shell:
  """
	ls !{filter_contig_from_genref}
	ls !{get_entrez_fasta}
	ls !{reorder_fa_seqs}
  python3 !{expandReference} -b !{normal_bam} -f !{base_reference_genome} -m !{contig_mappings} -o genref_for_bam_hg38.fa
  samtools faidx genref_for_bam_hg38.fa
  gatk CreateSequenceDictionary -R genref_for_bam_hg38.fa
  """
}

reference_genome_hg38_expanded_ch.into{
  manta_somatic_single_diploid_hg38_ch;
  strelka_somatic_hg38_ch
}

reference_genome_index_hg38_expanded_ch.into{
  manta_somatic_single_diploid_hg38_index_ch;
  strelka_somatic_hg38_index_ch
}


/////////////////////////////////////////////
///////////// HG38 PROCESSES ////////////////
/////////////////////////////////////////////

process msisensor {
  publishDir "${params.basePublish}/msisensor_hg38/", mode: 'copy'

  input:
    file normal_bam_file              from msisensor_somatic_bam_normal_file_hg38_ch
    file normal_bam_file_index        from msisensor_somatic_bam_normal_file_index_hg38_ch
    file tumor_bam_file               from msisensor_somatic_bam_tumor_file_hg38_ch
    file tumor_bam_file_index         from msisensor_somatic_bam_tumor_file_index_hg38_ch
    file reference_genome             from msisensor_somatic_hg38_ch
    file reference_genome_index       from msisensor_somatic_hg38_index_ch

  output:
    file './output' into msisensor_output_ch
    file './output_dis' into msisensor_output_dis_ch
    file './output_germline' into msisensor_output_germline_ch
    file './output_somatic' into msisensor_output_somatic_ch
  shell:
  """
    source activate myenv
    msisensor scan -d !{reference_genome} -o msisensor.list 2>&1
    msisensor msi -d msisensor.list -n !{normal_bam_file} -t !{tumor_bam_file} -o output -l 1 -q 1 -b !{task.cpus} 2>&1
  """
}

process manta_calling_somatic_hg38 {
  publishDir "${params.basePublish}/manta_somatic_hg38/", mode: 'copy', saveAs: { filename -> filename.startsWith("step_output_dir/results") ? "${params.basePublish}/manta_somatic/"+filename.replaceFirst("step_output_dir/results","") : null }


  input:
    file manta_somatic_single_diploid_referenceGenome from manta_somatic_single_diploid_hg38_ch
    file manta_somatic_single_diploid_referenceGenome_index from manta_somatic_single_diploid_hg38_index_ch
    file manta_somatic_normal_bam_normal_file from manta_somatic_normal_bam_normal_file_hg38_ch
    file manta_somatic_normal_bam_normal_file_index from manta_somatic_normal_bam_normal_file_index_hg38_ch
    file manta_somatic_normal_bam_tumor_file from manta_somatic_normal_bam_tumor_file_hg38_ch
    file manta_somatic_normal_bam_tumor_file_index from manta_somatic_normal_bam_tumor_file_index_hg38_ch
    file callingRegions               from manta_somatic_calling_regions_hg38_ch
    file callingRegions_index from manta_somatic_calling_regions_index_hg38_ch
  output:
      file 'somaticSV.vcf.gz' into manta_somaticSV_hg38_ch
      file 'somaticSV.vcf.gz.tbi' into manta_somaticSV_index_hg38_ch
      file 'diploidSV.vcf.gz' into manta_diploidSV_hg38_ch
      file 'diploidSV.vcf.gz.tbi' into manta_diploidSV_index_hg38_ch
      file 'candidateSmallIndels.vcf.gz' into manta_candidateSmallIndels_hg38_ch
      file 'candidateSmallIndels.vcf.gz.tbi' into manta_candidateSmallIndels_index_hg38_ch
      file 'candidateSV.vcf.gz' into manta_candidateSV_hg38_ch
      file 'candidateSV.vcf.gz.tbi' into manta_candidateSV_index_hg38_ch
      path 'step_output_dir/results/*' into manta_calling_somatic_outputs_hg38_ch
  shell:
  """
    mkdir step_output_dir

    # Configure Manta
    configManta.py \
      --normalBam !{manta_somatic_normal_bam_normal_file} \
      --tumorBam !{manta_somatic_normal_bam_tumor_file} \
      --referenceFasta !{manta_somatic_single_diploid_referenceGenome} \
      --callRegions !{callingRegions} \
      --runDir ./step_output_dir 2>&1 || exit 1

    # Execute Manta
    ./step_output_dir/runWorkflow.py -m local -j !{task.cpus} 2>&1 || exit 1

    ln -s ./step_output_dir/results/variants/*.vcf.gz .
    ln -s ./step_output_dir/results/variants/*.vcf.gz.tbi .
  """
}

process strelka_somatic_hg38 {
  publishDir "${params.basePublish}/strelka_somatic_hg38/", mode: 'copy', saveAs: { filename -> filename.startsWith("step_output_dir/results") ? "${params.basePublish}/strelka_somatic/"+filename.replaceFirst("step_output_dir/results","") : null }

  input:
    file reference_genome             from strelka_somatic_hg38_ch
    file reference_genome_index       from strelka_somatic_hg38_index_ch
    file normal_bam_file              from strelka_somatic_normal_bam_file_hg38_ch
    file normal_bam_file_index        from strelka_somatic_normal_bam_file_index_hg38_ch
    file tumor_bam_file               from strelka_somatic_tumor_bam_file_hg38_ch
    file tumor_bam_file_index         from strelka_somatic_tumor_bam_file_index_hg38_ch
    file manta_vcf                    from manta_candidateSmallIndels_hg38_ch
    file manta_index_vcf              from manta_candidateSmallIndels_index_hg38_ch
    file callingRegions               from strelka_somatic_calling_regions_hg38_ch
    file callingRegions_index         from strelka_somatic_calling_regions_index_hg38_ch
  output:
    file '*.vcf.gz' into strelka_output_hg38_ch
    path 'step_output_dir/results/*' into strelka_calling_somatic_outputs_hg38_ch
  shell:
  """
    mkdir step_output_dir

    # Configure Strelka
    configureStrelkaSomaticWorkflow.py \
      --normalBam !{normal_bam_file}\
      --tumorBam !{tumor_bam_file}\
      --referenceFasta !{reference_genome} \
      --callRegions !{callingRegions} \
      --reportEVSFeatures \
      --indelCandidates  !{manta_vcf} --runDir ./step_output_dir 2>&1 || exit 1

    # Execute Strelka
    ./step_output_dir/runWorkflow.py -m local -j !{task.cpus} 2>&1 || exit 1

    ln -s ./step_output_dir/results/variants/*.vcf.gz .
  """
}


/////////////////////////////////////////////////////
//////// T2T RECOGNITION + ROUTING WORKFLOW /////////
/////////////////////////////////////////////////////

process normal_reference_genome_recognition_t2t {
  container 'quay.io/biocontainers/pysam:0.15.2--py38hbab3036_7'

  input:
    file bamFile                from normal_reference_genome_recognition_t2t_bamFile_ch
    file reference_genome_dict  from normal_recognition_t2t_dict_ch
  output:
    env(ist2t) into normal_reference_genome_recognition_t2t_output
  shell:
  """
  ist2t=`python3 !{reference_genome_detector} -b !{bamFile} -d !{reference_genome_dict}`
  """
}

normal_reference_genome_recognition_t2t_output.into{
  normal_recognition_t2t_for_bam;
  normal_recognition_t2t_for_bai
}

normal_recognition_t2t_for_bam.merge(normal_routing_decision_bam_input_t2t).set{normal_decision_input_t2t}
normal_recognition_t2t_for_bai.merge(normal_routing_decision_bai_input_t2t).set{normal_index_decision_input_t2t}

normal_decision_input_t2t.branch {
    realign: it[0] != '0'
    keep:    it[0] == '0'
    problem: true
}.set { normal_result_t2t }

normal_bam_to_realign_t2t_ch = Channel.create()
normal_bam_correctly_aligned_t2t_ch = Channel.create()

normal_result_t2t.realign.separate( normal_bam_to_realign_t2t_ch ) { a -> [a[1]] }
normal_result_t2t.keep.separate( normal_bam_correctly_aligned_t2t_ch ) { a -> [a[1]] }

normal_index_decision_input_t2t.branch {
  realign: it[0] != '0'
  keep:    it[0] == '0'
  problem: true
}.set { normal_index_result_t2t }

normal_bai_to_realign_t2t_ch = Channel.create()
normal_bai_correctly_aligned_t2t_ch = Channel.create()

normal_index_result_t2t.realign.separate( normal_bai_to_realign_t2t_ch ) { a -> [a[1]] }
normal_index_result_t2t.keep.separate( normal_bai_correctly_aligned_t2t_ch ) { a -> [a[1]] }


process tumor_reference_genome_recognition_t2t {
  container 'quay.io/biocontainers/pysam:0.15.2--py38hbab3036_7'

  input:
    file bamFile                from tumor_reference_genome_recognition_t2t_bamFile_ch
    file reference_genome_dict  from tumor_recognition_t2t_dict_ch
  output:
    env(ist2t) into tumor_reference_genome_recognition_t2t_output
  shell:
  """
  ist2t=`python3 !{reference_genome_detector} -b !{bamFile} -d !{reference_genome_dict}`
  """
}

tumor_reference_genome_recognition_t2t_output.into{
  tumor_recognition_t2t_for_bam;
  tumor_recognition_t2t_for_bai
}

tumor_recognition_t2t_for_bam.merge(tumor_routing_decision_bam_input_t2t).set{tumor_decision_input_t2t}
tumor_recognition_t2t_for_bai.merge(tumor_routing_decision_bai_input_t2t).set{tumor_index_decision_input_t2t}

tumor_decision_input_t2t.branch {
    realign: it[0] != '0'
    keep:    it[0] == '0'
    problem: true
}.set { tumor_result_t2t }

tumor_bam_to_realign_t2t_ch = Channel.create()
tumor_bam_correctly_aligned_t2t_ch = Channel.create()

tumor_result_t2t.realign.separate( tumor_bam_to_realign_t2t_ch ) { a -> [a[1]] }
tumor_result_t2t.keep.separate( tumor_bam_correctly_aligned_t2t_ch ) { a -> [a[1]] }

tumor_index_decision_input_t2t.branch {
  realign: it[0] != '0'
  keep:    it[0] == '0'
  problem: true
}.set { tumor_index_result_t2t }

tumor_bai_to_realign_t2t_ch = Channel.create()
tumor_bai_correctly_aligned_t2t_ch = Channel.create()

tumor_index_result_t2t.realign.separate( tumor_bai_to_realign_t2t_ch ) { a -> [a[1]] }
tumor_index_result_t2t.keep.separate( tumor_bai_correctly_aligned_t2t_ch ) { a -> [a[1]] }


/////////////////////////////////////////////////////
/////////// T2T REALIGNING WORKFLOW /////////////////
/////////////////////////////////////////////////////

process normal_bam_to_realigned_bam_t2t {
  input:
    file reference from normal_bam_to_realigned_bam_reference_t2t_ch
    file reference_pac from normal_bam_index_pac_output_t2t_ch
    file reference_ann from normal_bam_index_ann_output_t2t_ch
    file reference_amb from normal_bam_index_amb_output_t2t_ch
    file reference_0123 from normal_bam_index_0123_output_t2t_ch
    file reference_bwt_2bit from normal_bam_index_bwt_2bit_output_t2t_ch
		file reference_fai from normal_realignment_t2t_index_ch
		file reference_dict from normal_realignment_t2t_dict_ch
    file bam_file from normal_bam_to_realign_t2t_ch
    file bai_file from normal_bai_to_realign_t2t_ch
    val normal_id from normal_bam_to_realigned_bam_t2t_id
  output:
    file 'normal_realigned_t2t.bam' into normal_realigned_bam_only_t2t_ch
    file 'normal_realigned_t2t.bai' into normal_realigned_bam_index_t2t_ch
  shell:
  """
  tmp_dir_collate=`mktemp -d --tmpdir=.`
  tmp_dir_sort=`mktemp -d --tmpdir=.`
  tmp_dir_mark_duplicates=`mktemp -d --tmpdir=.`

  samtools sort -n -@ 4 -o normal_name_sorted.bam !{bam_file}

  samtools fastq -@ 4 -1 normal_R1.fastq.gz -2 normal_R2.fastq.gz -0 /dev/null -s /dev/null \
  -n -F 0x900 normal_name_sorted.bam
  rm -f normal_name_sorted.bam

	readGroupInfo=`python3 !{retrieveReadGroupInfo} !{bam_file}`
  bwa-mem2 mem -t !{task.cpus-9} !{reference} normal_R1.fastq.gz normal_R2.fastq.gz | \
    samtools addreplacerg -r "@RG\tID:!{normal_id}\tSM:!{normal_id}\t\$readGroupInfo" - |\
    awk '{if (\$0 ~ "^@SQ") {print \$0 "\t" "AS:chm13.d1.vd1" "\t" "SP:Homo sapiens" }else {print \$0}}' |\
    samtools view  -Sb - | \
    samtools sort -o normal_realigned_to_recalibrate.bam -@ 5 -T \$tmp_dir_sort -
  gatk MarkDuplicates I=normal_realigned_to_recalibrate.bam O=normal_realigned_to_recalibrate_rm_duplicates.bam M=marked_dup_metrics.txt REMOVE_DUPLICATES=true TMP_DIR=\$tmp_dir_mark_duplicates
	ls !{dbsnp_t2t_index}
  gatk BaseRecalibrator -I normal_realigned_to_recalibrate_rm_duplicates.bam -R !{reference} --known-sites !{dbsnp_t2t} -O recal_data.table
  gatk ApplyBQSR -R !{reference} -I normal_realigned_to_recalibrate_rm_duplicates.bam --bqsr-recal-file recal_data.table -O normal_realigned_t2t.bam

  samtools index normal_realigned_t2t.bam

  rm -r \$tmp_dir_collate
  rm -r \$tmp_dir_sort
  rm -r \$tmp_dir_mark_duplicates

  rm -f normal_R1.fastq.gz normal_R2.fastq.gz
  """
}


process tumor_bam_to_realigned_bam_t2t {
  input:
    file reference from tumor_bam_to_realigned_bam_reference_t2t_ch
    file reference_pac from tumor_bam_index_pac_output_t2t_ch
    file reference_ann from tumor_bam_index_ann_output_t2t_ch
    file reference_amb from tumor_bam_index_amb_output_t2t_ch
    file reference_0123 from tumor_bam_index_0123_output_t2t_ch
    file reference_bwt_2bit from tumor_bam_index_bwt_2bit_output_t2t_ch
		file reference_fai from tumor_realignment_t2t_index_ch
		file reference_dict from tumor_realignment_t2t_dict_ch
    file bam_file from tumor_bam_to_realign_t2t_ch
    file bai_file from tumor_bai_to_realign_t2t_ch
    val tumor_id from tumor_bam_to_realigned_bam_t2t_ch
  output:
    file 'tumor_realigned_t2t.bam' into tumor_realigned_bam_only_t2t_ch
    file 'tumor_realigned_t2t.bai' into tumor_realigned_bam_index_t2t_ch
  shell:
  """
  tmp_dir_collate=`mktemp -d --tmpdir=.`
  tmp_dir_sort=`mktemp -d --tmpdir=.`
  tmp_dir_mark_duplicates=`mktemp -d --tmpdir=.`

  samtools sort -n -@ 10 -m 10G -o tumor_name_sorted.bam !{bam_file}

  samtools fastq -@ 5 -1 tumor_R1.fastq.gz -2 tumor_R2.fastq.gz -0 /dev/null -s /dev/null \
  -n -F 0x900 tumor_name_sorted.bam
  rm -f tumor_name_sorted.bam

	readGroupInfo=`python3 !{retrieveReadGroupInfo} !{bam_file}`
  bwa-mem2 mem -t !{task.cpus-9} !{reference} tumor_R1.fastq.gz tumor_R2.fastq.gz | \
    samtools addreplacerg -r "@RG\tID:!{tumor_id}\tSM:!{tumor_id}\t\$readGroupInfo" - |\
    awk '{if (\$0 ~ "^@SQ") {print \$0 "\t" "AS:chm13.d1.vd1" "\t" "SP:Homo sapiens" }else {print \$0}}' |\
    samtools view  -Sb - | \
    samtools sort -o tumor_realigned_to_recalibrate.bam -@ 5 -m 10G -T \$tmp_dir_sort -
  gatk MarkDuplicates I=tumor_realigned_to_recalibrate.bam O=tumor_realigned_to_recalibrate_rm_duplicates.bam M=marked_dup_metrics.txt REMOVE_DUPLICATES=true TMP_DIR=\$tmp_dir_mark_duplicates
	ls !{dbsnp_t2t_index}
  gatk BaseRecalibrator -I tumor_realigned_to_recalibrate_rm_duplicates.bam -R !{reference} --known-sites !{dbsnp_t2t} -O recal_data.table
  gatk ApplyBQSR -R !{reference} -I tumor_realigned_to_recalibrate_rm_duplicates.bam --bqsr-recal-file recal_data.table -O tumor_realigned_t2t.bam

  samtools index tumor_realigned_t2t.bam

  rm -r \$tmp_dir_collate
  rm -r \$tmp_dir_sort
  rm -r \$tmp_dir_mark_duplicates

  rm -f tumor_R1.fastq.gz tumor_R2.fastq.gz
  """
}


// Index realigned T2T BAMs separately.
normal_realigned_bam_only_t2t_ch.into{
  index_aligned_normal_bam_t2t_channel;
  realigned_normal_bam_t2t
}

tumor_realigned_bam_only_t2t_ch.into{
  index_aligned_tumor_bam_t2t_channel;
  realigned_tumor_bam_t2t
}


// Mix realigned + correctly-aligned BAMs/BAIs for the T2T path.
realigned_normal_bam_t2t
  .mix(normal_bam_correctly_aligned_t2t_ch)
  .into{
    prepare_reference_genome_t2t_normal_bam;
    manta_somatic_normal_bam_normal_file_t2t_ch;
    strelka_somatic_normal_bam_file_t2t_ch
  }

realigned_tumor_bam_t2t
  .mix(tumor_bam_correctly_aligned_t2t_ch)
  .into{
    manta_somatic_normal_bam_tumor_file_t2t_ch;
    strelka_somatic_tumor_bam_file_t2t_ch
  }

normal_bai_correctly_aligned_t2t_ch
  .mix(normal_realigned_bam_index_t2t_ch)
  .into{
    manta_somatic_normal_bam_normal_file_index_t2t_ch;
    strelka_somatic_normal_bam_file_index_t2t_ch;
    prepare_reference_genome_t2t_normal_bam_index
  }

tumor_bai_correctly_aligned_t2t_ch
  .mix(tumor_realigned_bam_index_t2t_ch)
  .into{
    manta_somatic_normal_bam_tumor_file_index_t2t_ch;
    strelka_somatic_tumor_bam_file_index_t2t_ch
  }


/////////////////////////////////////////////////////
////////// T2T PREPARE REFERENCE GENOME /////////////
/////////////////////////////////////////////////////

process prepare_reference_genome_t2t {
  container 'cassisbonbon/preparereferencegenome:v2.0'
  input:
    file normal_bam            from prepare_reference_genome_t2t_normal_bam
    file normal_bai            from prepare_reference_genome_t2t_normal_bam_index
    file base_reference_genome from prepare_reference_genome_t2t_reference_ch
  output:
    file('genref_for_bam_t2t.fa')     into reference_genome_t2t_expanded_ch
    file('genref_for_bam_t2t.fa.fai') into reference_genome_index_t2t_expanded_ch
    file('genref_for_bam_t2t.dict')   into reference_genome_dict_t2t_expanded_ch
  shell:
  """
	ls !{filter_contig_from_genref}
	ls !{get_entrez_fasta}
	ls !{reorder_fa_seqs}
  python3 !{expandReference} -b !{normal_bam} -f !{base_reference_genome} -m !{contig_mappings} -o genref_for_bam_t2t.fa
  samtools faidx genref_for_bam_t2t.fa
  gatk CreateSequenceDictionary -R genref_for_bam_t2t.fa
  """
}

reference_genome_t2t_expanded_ch.into{
  manta_somatic_single_diploid_t2t_ch;
  strelka_somatic_t2t_ch
}

reference_genome_index_t2t_expanded_ch.into{
  manta_somatic_single_diploid_t2t_index_ch;
  strelka_somatic_t2t_index_ch
}


/////////////////////////////////////////////
///////////// T2T PROCESSES /////////////////
/////////////////////////////////////////////

process manta_calling_somatic_t2t {
  publishDir "${params.basePublish}/manta_somatic_t2t/", mode: 'copy', saveAs: { filename -> filename.startsWith("step_output_dir/results") ? "${params.basePublish}/manta_somatic/"+filename.replaceFirst("step_output_dir/results","") : null }

  input:
    file manta_somatic_single_diploid_referenceGenome from manta_somatic_single_diploid_t2t_ch
    file manta_somatic_single_diploid_referenceGenome_index from manta_somatic_single_diploid_t2t_index_ch
    file manta_somatic_normal_bam_normal_file from manta_somatic_normal_bam_normal_file_t2t_ch
    file manta_somatic_normal_bam_normal_file_index from manta_somatic_normal_bam_normal_file_index_t2t_ch
    file manta_somatic_normal_bam_tumor_file from manta_somatic_normal_bam_tumor_file_t2t_ch
    file manta_somatic_normal_bam_tumor_file_index from manta_somatic_normal_bam_tumor_file_index_t2t_ch
    file callingRegions               from manta_somatic_calling_regions_t2t_ch
    file callingRegions_index from manta_somatic_calling_regions_index_t2t_ch
  output:
      file 'somaticSV.vcf.gz' into manta_somaticSV_t2t_ch
      file 'somaticSV.vcf.gz.tbi' into manta_somaticSV_index_t2t_ch
      file 'diploidSV.vcf.gz' into manta_diploidSV_t2t_ch
      file 'diploidSV.vcf.gz.tbi' into manta_diploidSV_index_t2t_ch
      file 'candidateSmallIndels.vcf.gz' into manta_candidateSmallIndels_t2t_ch
      file 'candidateSmallIndels.vcf.gz.tbi' into manta_candidateSmallIndels_index_t2t_ch
      file 'candidateSV.vcf.gz' into manta_candidateSV_t2t_ch
      file 'candidateSV.vcf.gz.tbi' into manta_candidateSV_index_t2t_ch
      path 'step_output_dir/results/*' into manta_calling_somatic_outputs_t2t_ch
  shell:
  """
    mkdir step_output_dir

    # Configure Manta
    configManta.py \
      --normalBam !{manta_somatic_normal_bam_normal_file} \
      --tumorBam !{manta_somatic_normal_bam_tumor_file} \
      --referenceFasta !{manta_somatic_single_diploid_referenceGenome} \
      --callRegions !{callingRegions} \
      --runDir ./step_output_dir 2>&1 || exit 1

    # Execute Manta
    ./step_output_dir/runWorkflow.py -m local -j !{task.cpus} 2>&1 || exit 1

    ln -s ./step_output_dir/results/variants/*.vcf.gz .
    ln -s ./step_output_dir/results/variants/*.vcf.gz.tbi .
  """
}

process strelka_somatic_t2t {
  publishDir "${params.basePublish}/strelka_somatic_t2t/", mode: 'copy', saveAs: { filename -> filename.startsWith("step_output_dir/results") ? "${params.basePublish}/strelka_somatic_t2t/"+filename.replaceFirst("step_output_dir/results","") : null }

  input:
    file reference_genome             from strelka_somatic_t2t_ch
    file reference_genome_index       from strelka_somatic_t2t_index_ch
    file normal_bam_file              from strelka_somatic_normal_bam_file_t2t_ch
    file normal_bam_file_index        from strelka_somatic_normal_bam_file_index_t2t_ch
    file tumor_bam_file               from strelka_somatic_tumor_bam_file_t2t_ch
    file tumor_bam_file_index         from strelka_somatic_tumor_bam_file_index_t2t_ch
    file manta_vcf                    from manta_candidateSmallIndels_t2t_ch
    file manta_index_vcf              from manta_candidateSmallIndels_index_t2t_ch
    file callingRegions               from strelka_somatic_calling_regions_t2t_ch
    file callingRegions_index         from strelka_somatic_calling_regions_index_t2t_ch
  output:
    file '*snvs*.vcf.gz' into strelka_snvs_t2t_output_ch
    file '*indels*.vcf.gz' into strelka_indels_t2t_output_ch
    path 'step_output_dir/results/*' into strelka_calling_somatic_outputs_t2t_ch
  shell:
  """
    mkdir step_output_dir

    # Configure Strelka
    configureStrelkaSomaticWorkflow.py \
      --normalBam !{normal_bam_file}\
      --tumorBam !{tumor_bam_file}\
      --referenceFasta !{reference_genome} \
      --callRegions !{callingRegions} \
      --reportEVSFeatures \
      --indelCandidates  !{manta_vcf} --runDir ./step_output_dir 2>&1 || exit 1

    # Execute Strelka
    ./step_output_dir/runWorkflow.py -m local -j !{task.cpus} 2>&1 || exit 1

    ln -s ./step_output_dir/results/variants/*.vcf.gz .
  """
}
