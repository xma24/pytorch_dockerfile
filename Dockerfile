FROM nvidia/cuda:11.1.1-base-ubuntu20.04

# Install some basic utilities
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
   curl \
   ca-certificates \
   sudo \
   git \
   bzip2 \
   libx11-6 \
   python3-dev \
   wget \ 
   libxext6 \
   ffmpeg \
   libsm6 \
   && rm -rf /var/lib/apt/lists/*

# Create a working directory
WORKDIR /home

# Create a non-root user and switch to it
RUN adduser --disabled-password --gecos '' --shell /bin/bash user \
   && chown -R user:user /home
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-user
USER user

# All users can use /home/user as their home directory
ENV HOME=/home/user
RUN chmod 777 /home/user

# Install Miniconda and Python 3.8
ENV CONDA_AUTO_UPDATE_CONDA=false
ENV PATH=/home/user/miniconda/bin:$PATH
RUN curl -sLo ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-py38_4.8.3-Linux-x86_64.sh \
   && chmod +x ~/miniconda.sh \
   && ~/miniconda.sh -b -p ~/miniconda \
   && rm ~/miniconda.sh \
   && conda install -y python==3.8.3 \
   && conda install -y scikit-learn \
   && conda install -y -c conda-forge matplotlib \
   #  && conda install -y vissl \
   && conda install -y networkx \
   && pip install --no-cache-dir albumentations \
   && pip install --no-cache-dir neptune-client \
   && pip install --no-cache-dir pytorch-lightning \
   && pip install --no-cache-dir rich \
   && pip install --no-cache-dir pandas==1.1.5 \
   && pip install --no-cache-dir pynndescent \
   && pip install --no-cache-dir munkres \
   && pip install --no-cache-dir lightning-bolts \
   && pip --no-cache-dir install easydict \
   && pip --no-cache-dir install termcolor \
   && pip --no-cache-dir install umap-learn \ 
   && pip --no-cache-dir install faiss-gpu \
   && pip --no-cache-dir install tensorflow \
   && pip --no-cache-dir install pretrainedmodels \
   && pip --no-cache-dir install pydicom \
   #  && pip --no-cache-dir install nnunet \
   && pip --no-cache-dir install opencv-contrib-python-headless \
   && pip --no-cache-dir install antspyx \
   && pip --no-cache-dir install fiftyone \
   && pip --no-cache-dir install --upgrade kaggle \
   && pip --no-cache-dir install lightning-flash \
   && pip --no-cache-dir install 'lightning-flash[image]' \
   && pip --no-cache-dir install 'lightning-flash[video]' \
   && pip --no-cache-dir install labelbox \
   #  && pip --no-cache-dir install segmentation-models-pytorch \
   && pip --no-cache-dir install hiddenlayer \
   && conda clean -ya

# CUDA 11.1-specific steps
RUN conda install -y -c conda-forge cudatoolkit=11.1.1 \
   && conda install -y -c pytorch \
   "pytorch=1.8.1=py3.8_cuda11.1_cudnn8.0.5_0" \
   "torchvision=0.9.1=py38_cu111" \
   && conda clean -ya

# Set the default command to python3
CMD ["python3"]
