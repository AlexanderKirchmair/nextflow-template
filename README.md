# nextflow-template

### env

Create conda environment
```bash
conda create -n 'nftemp' numpy pandas papermill ipykernel ipywidgets
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
