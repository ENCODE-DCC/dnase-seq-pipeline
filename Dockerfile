############
# Build base
from ubuntu:18.04 as build-base
RUN apt-get update
RUN apt-get install -y \
      build-essential \
      git \
      wget \
      zlib1g-dev


###########
# Build BWA
from build-base as build-bwa
RUN apt-get install -y \
      build-essential \
      git \
      g++ \
      gcc \
      git \
      openjdk-8-jre \
      perl \
      python \
      zlib1g-dev
# Install BWA - do some magicks so it compiles with musl.c
RUN   git clone https://github.com/lh3/bwa.git \
      && cd bwa \
      && git checkout 0.7.12 \
      && make

# ################
# # Build Kallisto
# from alpine:3.7 as build-kallisto
# RUN apk add --no-cache build-base
#
# RUN apk add --no-cache \
#   build-base \
#   curl
#
# RUN curl https://support.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.10.1.tar.bz2 --output hdf5-1.10.1.tar.bz2 \
#       && tar xf hdf5-1.10.1.tar.bz2 \
#       && cd  hdf5-1.10.1 \
#       && ./configure --prefix / \
#       && make install
#
# RUN apk add --no-cache \
#   cmake \
#   zlib-dev
#
# RUN wget --quiet https://github.com/pachterlab/kallisto/archive/v0.44.0.tar.gz \
#       && tar xf v0.44.0.tar.gz \
#       && cd kallisto-0.44.0 \
#       && mkdir build \
#       && cd build \
#       && cmake .. \
#       && make install
#

################
# Build samtools
FROM build-base as build-samtools
RUN apt-get install -y \
    build-essential \
    autoconf \
    g++ \
    git \
    libbz2-dev \
    liblzma-dev \
    make \
    ncurses-dev \
    wget \
    zlib1g-dev
RUN wget --quiet https://github.com/samtools/samtools/releases/download/1.7/samtools-1.7.tar.bz2 \
      && tar xf samtools-1.7.tar.bz2 \
      && cd samtools-1.7 \
      && make install

#####################
# Build trim-adapters
FROM build-base as build-trim-adapters
RUN apt-get install -y \
      build-essential \
      libboost-dev \
      git \
      zlib1g-dev
RUN git clone https://bitbucket.org/jvierstra/bio-tools.git \
      && cd bio-tools \
      && git checkout 6fe54fa5a3 \
      && make

########
# Picard
from build-base as get-picard
RUN wget --quiet https://github.com/broadinstitute/picard/releases/download/2.8.1/picard.jar

########
# Bedops
from build-base as build-bedops
RUN apt-get install -y \
      build-essential \
      git \
      libbz2-dev
RUN git clone https://github.com/bedops/bedops.git \
      && cd bedops \
      && git checkout v2.4.35 \
      && make \
      && make install

##########
# Hotspot1
from build-base as build-hotspot1
RUN apt-get install -y \
      build-essential \
      git \
      libgsl-dev \
      wget
RUN git clone https://github.com/StamLab/hotspot.git \
      && cd hotspot \
      && git checkout v4.1.1 \
      && cd hotspot-distr/hotspot-deploy \
      && make

###########
# Kentutils
from build-base as build-kentutils
RUN apt-get install -y \
      build-essential \
      git \
      libmysqlclient-dev \
      libpng-dev \
      libssh-dev \
      wget \
      zlib1g-dev
RUN wget --quiet https://github.com/ENCODE-DCC/kentUtils/archive/v302.0.0.tar.gz \
      && tar xf v302.0.0.tar.gz \
      && cd kentUtils-302.0.0 \
      && make

##########
# Bedtools
from build-base as build-bedtools
RUN apt-get install -y \
      python
RUN wget --quiet https://github.com/arq5x/bedtools2/releases/download/v2.25.0/bedtools-2.25.0.tar.gz \
      && tar xf bedtools-2.25.0.tar.gz \
      && cd bedtools2 \
      && make

########
# Preseq
from build-base as build-preseq
RUN apt-get install -y \
      libgsl-dev
RUN git clone --recurse-submodules https://github.com/smithlabcode/preseq.git \
   && cd preseq \
   && git checkout v2.0.1 \
   && make


#############
# Final image
from ubuntu:18.04 as stampipes

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y \
      bash \
      bc \
      bowtie \
      build-essential \
      libboost-dev \
      coreutils \
      libgsl-dev \
      littler \
      openjdk-8-jre \
      python-dev \
      python-pip \
      python3 \
      python3-pip \
      tabix \
      wget \
      zlib1g-dev

COPY ./requirements.pip.txt /stampipes/
RUN pip install -r /stampipes/requirements.pip.txt
RUN pip3 install -r /stampipes/requirements.pip.txt

COPY ./scripts /stampipes/scripts
COPY ./processes /stampipes/processes
COPY ./makefiles /stampipes/makefiles
COPY ./awk /stampipes/awk
ENV STAMPIPES=/stampipes

# Copy in dependencies
COPY --from=build-bwa /bwa/bwa /usr/local/bin/
COPY --from=build-trim-adapters /bio-tools/apps/trim-adapters-illumina/trim-adapters-illumina /usr/local/bin/
COPY --from=build-samtools /usr/local/bin/samtools /usr/local/bin
COPY --from=build-bedops /bedops/bin /usr/local/bin
ENV HOTSPOT_DIR /hotspot
COPY --from=build-hotspot1 /hotspot/hotspot-distr/ $HOTSPOT_DIR
COPY --from=build-kentutils /kentUtils-302.0.0/bin/ /usr/local/bin/
COPY --from=build-bedtools /bedtools2/bin/ /usr/local/bin/
COPY --from=build-preseq /preseq/preseq /usr/local/bin/
COPY --from=get-picard /picard.jar /usr/local/lib/picard.jar

# Make alias for picard
RUN echo -e '#!/bin/bash\njava -jar /usr/local/lib/picard.jar $@' \
      > /usr/local/bin/picard \
      && chmod +x /usr/local/bin/picard

RUN pip install cython && pip3 install cython
RUN pip install numpy>=1.10 scipy>=0.17 pysam>=0.8.2 pyfaidx>=0.4.2 statsmodels \
    multiprocessing matplotlib git+https://github.com/jvierstra/genome-tools@5e3cc51 \
    git+https://github.com/jvierstra/footprint-tools@914923e

ENTRYPOINT ["/bin/bash","-c"]
