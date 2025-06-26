# nextflow-template

### env
conda create -n 'nftemp' numpy pandas papermill ipykernel ipywidgets
conda activate nftemp
conda env export | grep -v "^prefix: " > 'envs/nftemp.yml'

### main workflow
nextflow    -config conf/main.config \
            -log 'logs/nextflow.log' \
            run pipeline_main.nf  \
            -work-dir 'nfwork'
