# nextflow-template

### env

Setup
```bash
mkdir bin bin/bash bin/py bin/R conf envs logs modules notebooks
touch pipeline_main.nf bin/bash/functions.sh bin/py/functions.py bin/py/__init__.py conf/main.config
```

Create conda environment
```bash
conda create -n 'nftemp' numpy pandas papermill ipykernel ipywidgets nb-clean
conda activate nftemp
conda env export | grep -v "^prefix: " > 'envs/nftemp.yml'
```

Containerize the conda environment
```bash
source bin/bash/functions.sh
conda_to_container --yaml envs/nftemp.yml --name nftemp --outdir envs/containers
```

### main workflow
```bash
nextflow    -config conf/main.config \
            -log 'logs/nextflow.log' \
            run pipeline_main.nf  \
            -work-dir 'nfwork'
```
