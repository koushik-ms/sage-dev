# Sage Development setup

## Using docker (persist env across runs)

This setup allows source to be on the host and sets up docker to run and test
sage. Clone this repo:

```bash
git clone --origin upstream git@github.com/koushik-ms/sage-dev.git
cd sage-dev
```

Run the commands below from the same directory where this README.md is
present. This is the default after running the step above. Clone sage sources
on the host:

```bash
git clone --origin upstream git@github.com:sagemath/sage.git
```

Build the sage-dev image: `docker build -t sage-dev:latest .`

Run a dev container:

```bash
docker run -it --rm --name sage-dev --hostname sage-dev \
  --mount source=sage_env,target=/home/user/miniforge3/envs \
  --mount type=bind,source=${PWD},target=/home/user/src \
  sage-dev:latest
```

This should drop you in a shell prompt within the container with the conda base
environment activated. Setup dependencies using mamba

```bash
export SAGE_NUM_THREADS=16
cd ~/src/sage
mamba env create --file src/environment-dev-3.11-linux.yml --name sage-dev
conda activate sage-dev
./bootstrap
pip install --no-build-isolation -v -v --editable ./pkgs/sage-conf_conda \
  ./pkgs/sage-setup
pip install --no-build-isolation --config-settings editable_mode=compat -v \
  -v --editable ./src
which sage
sage -c 'print(version())'
```

Now the env is ready for development. Use your favourite editor on the host to
make changes and re-run sage as explained in the [sage
docs](https://doc.sagemath.org/html/en/developer/walkthrough.html#chapter-walkthrough).

When done working with sage, just quit the docker container by exiting sage and
the shell (with `exit`)

### Re-using persisted environment

To resume development, re-run the container:

```bash
docker run -it --rm --name sage-dev --hostname sage-dev \
  --mount source=sage_env,target=/home/user/miniforge3/envs \
  --mount type=bind,source=${PWD},target=/home/user/src \
  sage-dev:latest
```
This once again drops you in a shell within the container. Activate the conda
environment with: `conda activate sage-dev`

This will restore the env from the previous session. Rebuild/ run sage as
usual.

## Ephemeral docker container (fresh build every time)

Start the container:

```bash
  docker run --rm --name sage-builder -it ubuntu:22.04
```

Setup pre-requisities

```bash
apt update
apt -y upgrade
apt install -y git build-essential m4 tmux
# apt install -y binutils make m4 perl python3 tar bc gcc g++ ca-certificates
apt install -y python3 python3-pip curl

```

Setup mamba

```bash
curl -L -O \
  "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh
```

The last step requires user interaction to accept user agreement.

Restart tmux session for the bashrc changes to take effect.

```bash
tmux
```

Clone source code

```bash
mkdir -p ~/src/
cd ~/src
git clone --origin upstream https://github.com/sagemath/sage.git
cd sage
git checkout develop
```

Setup dependencies using mamba

```bash
mamba env create --file src/environment-dev-3.11-linux.yml --name sage-dev
conda activate sage-dev
./bootstrap
pip install --no-build-isolation -v -v --editable ./pkgs/sage-conf_conda \
  ./pkgs/sage-setup
pip install --no-build-isolation --config-settings editable_mode=compat -v \
  -v --editable ./src
which sage
sage -c 'print(version())'
```

## Using WSL

This setup allows sage to be setup using WSL. The steps below can be run inside
a folder on the Windows file-system (e.g., `C:\Users\me\`) or in a directory
within the WSL file-system. If the files are on Windows file-system then it may
be easier to edit them using IDEs installed on Windows. However, this is
experimental and may result in problems due to the way Windows and Linux treat
files.

Either way, start a bash-shell within WSL and change to the directory where you
want to work with sage.

```bash
mkdir -p sage-dev
cd sage-dev
```

Setup the source code repository and the virtual env:

```bash
git clone --origin upstream git@github.com:sagemath/sage.git
sudo apt-get update && \
  sudo apt-get -y upgrade && \
  sudo apt-get install -y git build-essential m4 tmux python3 python3-pip curl vim

curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh" && \
  bash Miniforge3-Linux-x86_64.sh -b -p ${HOME}/miniforge3 && \
  ${HOME}/miniforge3/bin/python -m conda init bash && \
  ${HOME}/miniforge3/bin/python -m mamba.mamba init
```

Bootstrap and build sage from sources:

```bash
export SAGE_NUM_THREADS=16  # Adjust to a value equal to number of cores on your system
cd sage
mamba env create --file src/environment-dev-3.11-linux.yml --name sage-dev
conda activate sage-dev
./bootstrap
pip install --no-build-isolation -v -v --editable ./pkgs/sage-conf_conda \
  ./pkgs/sage-setup
pip install --no-build-isolation --config-settings editable_mode=compat -v \
  -v --editable ./src
which sage
sage -c 'print(version())'
```

Now the env is ready for development. Use your favourite editor on the host to
make changes and re-run sage as explained in the [sage
docs](https://doc.sagemath.org/html/en/developer/walkthrough.html#chapter-walkthrough).

