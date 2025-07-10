conda_to_container() {
    # ---- Parse arguments ----
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --yaml) YAML_FILE="$2"; shift ;;
            --name) ENV_NAME="$2"; shift ;;
            --outdir) OUTDIR="$2"; shift ;;
            -h|--help)
                echo "Usage: conda_to_container --yaml env.yml --name envname --outdir output_dir"
                return 0
                ;;
            *) echo "Unknown parameter passed: $1"; return 1 ;;
        esac
        shift
    done

    # ---- Validate input ----
    if [[ -z "$YAML_FILE" || -z "$ENV_NAME" || -z "$OUTDIR" ]]; then
        echo "Missing required arguments."
        echo "Usage: conda_to_container --yaml env.yml --name envname --outdir output_dir"
        return 1
    fi

    if [[ ! -f "$YAML_FILE" ]]; then
        echo "YAML file does not exist: $YAML_FILE"
        return 1
    fi

    # ---- Check for apptainer ----
    if ! command -v apptainer &> /dev/null; then
        echo "Apptainer is not installed or not in PATH"
        return 1
    fi

    # ---- Set paths ----
    mkdir -p "$OUTDIR"
    OUTDIR="${OUTDIR}/${ENV_NAME}"
    mkdir -p "$OUTDIR"
    DEF_FILE="${OUTDIR}/Apptainer.${ENV_NAME}"
    SANDBOX_DIR="${OUTDIR}/${ENV_NAME}_sandbox"
    FINAL_SIF="${OUTDIR}/${ENV_NAME}.sif"

    echo "Creating apptainer definition file: $DEF_FILE"
    cat > "$DEF_FILE" <<EOF
Bootstrap: docker
From: mambaorg/micromamba

%environment
    export LANG=C.UTF-8 LC_ALL=C.UTF-8
    export PATH=/opt/conda/bin:\$PATH
    export MAMBA_ROOT_PREFIX=/opt/conda
    export ENV_NAME="$ENV_NAME"
    export NUMBA_CACHE_DIR=/tmp/numba_cache
    export MPLCONFIGDIR=/tmp/matplotlib_cache
    export IPYTHONDIR=/tmp/ipython_cache
    eval "\$(micromamba shell hook -s posix)"
    micromamba activate "$ENV_NAME"


%files
    $YAML_FILE /env.yml

%post
    export LANG=C.UTF-8 LC_ALL=C.UTF-8
    export PATH=/opt/conda/bin:\$PATH
    export MAMBA_ROOT_PREFIX=/opt/conda
    eval "\$(micromamba shell hook -s posix)"
    micromamba create --name "$ENV_NAME" --file /env.yml
    micromamba clean --all --yes
    micromamba run -n "$ENV_NAME" python -m ipykernel install --name "$ENV_NAME" --display-name "$ENV_NAME" --prefix=/opt/conda/envs/"$ENV_NAME"
    rm -rf /env.yml /var/lib/{apt,dpkg,cache,log} 

%test
    if command -v papermill >/dev/null 2>&1; then
        echo "papermill is installed"
    else
        echo "papermill is NOT installed"
        exit 1
    fi

EOF

    # ---- Build container ----
    echo "Building apptainer container: $FINAL_SIF"
    apptainer build --notest "$FINAL_SIF" "$DEF_FILE"

    # ---- Run tests ----
    echo "Running tests:"
    apptainer test "$FINAL_SIF"

}

