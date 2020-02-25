FROM ubuntu@sha256:2695d3e10e69cc500a16eae6d6629c803c43ab075fa5ce60813a0fc49c47e859
MAINTAINER Otto Jolanki

RUN apt-get update && apt-get install -y \ 
    bc \
    gcc \
    g++ \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libcrypto++-dev \
    libgsl-dev \
    wget \
    make \
    autoconf \
    ncurses-dev \
    build-essential \
    git \
    openjdk-8-jre \
    pigz \
    python \
    python3 \
    tabix \
    libboost-dev \
    python-pip \
    python3-pip 

RUN mkdir /software
WORKDIR /software
ENV PATH="/software:${PATH}"

RUN wget --quiet https://github.com/samtools/htslib/releases/download/1.10.2/htslib-1.10.2.tar.bz2 \
    && tar xf htslib-1.10.2.tar.bz2 \
    && cd htslib-1.10.2 \
    && ./configure \
    && make \
    && make install

RUN wget --quiet https://github.com/smithlabcode/preseq/releases/download/v2.0.3/preseq_v2.0.3.tar.bz2 \
    && tar xf preseq_v2.0.3.tar.bz2 \
    && cd preseq \
    && make HAVE_HTSLIB=1 all

ENV PATH="/software/preseq:${PATH}"

RUN wget --quiet https://github.com/samtools/samtools/releases/download/1.10/samtools-1.10.tar.bz2 \
    && tar xf samtools-1.10.tar.bz2 \
    && cd samtools-1.10 \
    && ./configure --with-htslib=../htslib-1.10.2 \
    && make \
    && make install
 
# Install BWA - do some magicks so it compiles with musl.c
RUN git clone https://github.com/lh3/bwa.git \
    && cd bwa \
    && git checkout 0.7.12 \
    && make

ENV PATH="/software/bwa:${PATH}"

# Get picard and make alias
RUN wget --quiet https://github.com/broadinstitute/picard/releases/download/2.8.1/picard.jar
RUN chmod 755 picard.jar

# Install bedops
RUN git clone https://github.com/bedops/bedops.git \
    && cd bedops \
    && git checkout v2.4.35 \
    && make \
    && make install

ENV PATH="/software/bedops/bin:${PATH}"

# Install bedtools
RUN wget --quiet https://github.com/arq5x/bedtools2/releases/download/v2.25.0/bedtools-2.25.0.tar.gz \
      && tar xf bedtools-2.25.0.tar.gz \
      && cd bedtools2 \
      && make

ENV PATH="/software/bedtools2/bin/:${PATH}"

# Install trim-adapters-illumina
RUN git clone https://bitbucket.org/jvierstra/bio-tools.git \
      && cd bio-tools \
      && git checkout 6fe54fa5a3 \
      && make

ENV PATH="/software/bio-tools/apps/trim-adapters-illumina:${PATH}"

# Install Hotspot1
RUN git clone https://github.com/StamLab/hotspot.git \
    && cd hotspot \
    && git checkout v4.1.1 \
    && cd hotspot-distr/hotspot-deploy \
    && make

ENV PATH="/software/hotspot/hotspot-distr/ScriptTokenizer/src:${PATH}"
ENV PATH="/software/hotspot/hotspot-distr/hotspot-deploy/bin:${PATH}"
ENV HOTSPOT_DIRECTORY="/software/hotspot/hotspot-distr"

# Get BedGraphToBigWig v385 for hotspots2
RUN git clone https://github.com/ENCODE-DCC/kentutils_v385_bin_bulkrna.git \
    && rm kentutils_v385_bin_bulkrna/bedSort 

ENV PATH="/software/kentutils_v385_bin_bulkrna:${PATH}"

# Install modwt for hotspot2
RUN git clone https://github.com/StamLab/modwt.git \
    && cd modwt \
    && git checkout 28e9f479c737836ffc870199f2468e30659ab38d \
    && make

ENV PATH="/software/modwt/bin:${PATH}"

# Install hotspots2 v2.1
RUN git clone -b 'v2.1' --single-branch --depth 1 https://github.com/Altius/hotspot2.git \
     && cd hotspot2 \
     && make

ENV PATH="/software/hotspot2/bin:${PATH}"
ENV PATH="/software/hotspot2/scripts:${PATH}"

# Pull bwa_2.6.0-rc tag of stampipes
RUN git clone -b 'bwa_2.6.0-rc' --single-branch --depth 1 https://github.com/StamLab/stampipes.git

ENV STAMPIPES="/software/stampipes"

# Install stampipes requirements
RUN pip install cython numpy scipy
RUN pip3 install biopython==1.76 pysam==0.15.0 numpy==1.18.1 scipy==1.4.1 scikit-learn==0.22.1

RUN pip install biopython pysam scikit-learn statsmodels multiprocessing matplotlib git+https://github.com/jvierstra/genome-tools@5e3cc51 git+https://github.com/jvierstra/footprint-tools@914923e

RUN apt-get install -y bowtie

#make scripts findable by which
RUN chmod 755 /software/stampipes/scripts/bwa/bamcounts.py
RUN chmod 755 /software/stampipes/scripts/bwa/aggregate/basic/sparse_motifs.py 
RUN chmod 755 /software/stampipes/scripts/bam/random_sample.sh
RUN chmod 755 /software/stampipes/scripts/SPOT/runhotspot.bash
RUN chmod 755 /software/stampipes/scripts/utility/picard_inserts_process.py
RUN chmod 755 /software/stampipes/scripts/utility/preseq_targets.sh
RUN chmod 755 /software/stampipes/awk/*.awk

# Add required stampipe locations to PATH to enable locating scripts with which
ENV PATH="/software/stampipes/scripts/umi:${PATH}"
ENV PATH="/software/stampipes/scripts/bwa:${PATH}"
ENV PATH="/software/stampipes/scripts/bam:${PATH}"
ENV PATH="/software/stampipes/scripts/SPOT:${PATH}"
ENV PATH="/software/stampipes/scripts/bwa/aggregate/basic:${PATH}"
ENV PATH="/software/stampipes/scripts/utility:${PATH}"
ENV PATH="/software/stampipes/awk:${PATH}"

