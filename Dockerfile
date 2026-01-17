FROM nvidia/cuda:12.8.0-devel-ubuntu22.04
LABEL maintainer="Yibo Lin <yibolin@pku.edu.cn>"

# Install system dependency (must be first for wget)
RUN apt-get update \
        && apt-get install -y --no-install-recommends \
            wget \
            flex \
            bison \
            libfl-dev \
            libcairo2-dev \
            libboost-all-dev \
            git \
            zlib1g-dev \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/*

# Install miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /miniconda.sh && \
    bash /miniconda.sh -b -p /opt/conda && \
    rm /miniconda.sh && \
    /opt/conda/bin/conda clean -afy

ENV PATH="/opt/conda/bin:${PATH}"

# Install cmake
ADD https://github.com/Kitware/CMake/releases/download/v3.25.1/cmake-3.25.1-linux-x86_64.sh /cmake-3.25.1-linux-x86_64.sh
RUN mkdir /opt/cmake \
        && sh /cmake-3.25.1-linux-x86_64.sh --prefix=/opt/cmake --skip-license \
        && ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake \
        && cmake --version

# Install PyTorch with CUDA 12.8 support
# cu128 index only has PyTorch 2.7.0+ available
RUN pip install torch==2.7.1 torchvision==0.22.1 torchaudio==2.7.1 --index-url https://download.pytorch.org/whl/cu128

# Upgrade numpy for compatibility
RUN pip install --upgrade numpy>=1.24

# install python dependency 
RUN pip install --upgrade \
        numpy>=1.24 \
        pyunpack>=0.1.2 \
        patool>=1.12 \
        matplotlib>=2.2.2 \
        cairocffi>=0.9.0 \
        pkgconfig>=1.4.0 \
        setuptools>=39.1.0 \
        scipy>=1.1.0 \
        shapely>=1.7.0 \
        torch_optimizer \
        ncg_optimizer

