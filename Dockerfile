# Use nvidia/cuda image
FROM nvidia/cuda:11.3.0-runtime-ubuntu20.04

# set bash as current shell
RUN chsh -s /bin/bash
SHELL ["/bin/bash", "-c"]

# install anaconda
RUN apt-get update
ENV TZ=Asia/Ho_Chi_Minh
RUN apt-get update --fix-missing && DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes --no-install-recommends \
   build-essential
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh -O ~/anaconda.sh && \
        /bin/bash ~/anaconda.sh -b -p /opt/conda && \
        rm ~/anaconda.sh && \
        ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
        echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
        find /opt/conda/ -follow -type f -name '*.a' -delete && \
        find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
        /opt/conda/bin/conda clean -afy

# set path to conda
ENV PATH /opt/conda/bin:$PATH


# setup conda virtual environment
COPY ./environment.yaml /tmp/environment.yaml
RUN conda update conda \
    && conda env create -f /tmp/environment.yaml

RUN echo "conda activate control" >> ~/.bashrc
ENV PATH /opt/conda/envs/control/bin:$PATH
ENV CONDA_DEFAULT_ENV $control