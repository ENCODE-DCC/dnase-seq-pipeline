FROM ubuntu@sha256:2695d3e10e69cc500a16eae6d6629c803c43ab075fa5ce60813a0fc49c47e859
MAINTAINER Otto Jolanki

RUN apt-get update && apt-get install -y \ 
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
    python \
    tabix \
    libboost-dev 

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
RUN echo 'alias picard="java -jar /software/picard.jar"' >> ~/.bashrc

# Install bedops
RUN git clone https://github.com/bedops/bedops.git \
      && cd bedops \
      && git checkout v2.4.35 \
      && make \
      && make install

ENV PATH="/software/bedops/bin:${PATH}"

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

# Get BedGraphToBigWig v385 for hotspots2
RUN git clone https://github.com/ENCODE-DCC/kentutils_v385_bin_bulkrna.git \
	&& rm kentutils_v385_bin_bulkrna/bedSort 

ENV PATH="/software/kentutils_v385_bin_bulkrna:${PATH}"

