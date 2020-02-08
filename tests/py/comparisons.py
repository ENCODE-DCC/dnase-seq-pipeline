import pysam


def compare_bams_as_sams(bam_path1, bam_path2):
    sam1 = pysam.view(bam_path1)
    sam2 = pysam.view(bam_path2)
    return sam1 == sam2


def skip_n_lines_and_compare(file1, file2, n):
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        f1_lines = f1.readlines()[n:]
        f2_lines = f2.readlines()[n:]
    return f1_lines == f2_lines
