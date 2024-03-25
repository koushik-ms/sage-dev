# Sage Development setup

## Using docker

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

## Ephemeral docker container

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
