import pysam


def compare_bams_as_sams(bam_path1, bam_path2):
    sam1 = pysam.view(bam_path1)
    sam2 = pysam.view(bam_path2)
    return sam1 == sam2
