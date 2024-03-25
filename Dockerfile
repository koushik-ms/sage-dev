FROM ubuntu:22.04

RUN apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y git build-essential m4 tmux python3 python3-pip curl vim && \
  rm -rf /var/lib/apt/lists/*

RUN adduser --uid 1000 --home /home/user user
USER 1000
WORKDIR /home/user

RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh" && \
  bash Miniforge3-Linux-x86_64.sh -b -p /home/user/miniforge3 && \
  /home/user/miniforge3/bin/python -m conda init bash && \
  /home/user/miniforge3/bin/python -m mamba.mamba init

