# base on ubuntu 18.04
FROM ubuntu@sha256:2695d3e10e69cc500a16eae6d6629c803c43ab075fa5ce60813a0fc49c47e859
MAINTAINER Otto Jolanki

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    g++ \
    gcc \
    openjdk-8-jre \
    perl \
    python \
    zlib1g-dev \
# above are for bwa
    autoconf \
    libbz2-dev \
    liblzma-dev \
    ncurses-dev \
# above are for samtools
    tabix \
    libboost-dev
# libboost-dev is trim-adapters-illumina dependency


RUN mkdir /software
WORKDIR /software
ENV PATH="/software:${PATH}"

# Install BWA - do some magicks so it compiles with musl.c
RUN git clone https://github.com/lh3/bwa.git \
    && cd bwa \
    && git checkout 0.7.12 \
    && make

ENV PATH="/software/bwa:${PATH}"

# Install Samtools 1.7
RUN wget --quiet https://github.com/samtools/samtools/releases/download/1.7/samtools-1.7.tar.bz2 \
      && tar xf samtools-1.7.tar.bz2 \
      && cd samtools-1.7 \
      && make install 
RUN rm samtools-1.7.tar.bz2

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
