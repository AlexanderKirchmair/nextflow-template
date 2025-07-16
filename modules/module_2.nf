#!/usr/bin/env nextflow

process m2_process {
 
    // publishDir "${params.resultsdir}", mode: 'copy', overwrite: true

    input:
        path(input)

    output:
        path "analysis_rendered.ipynb", emit: notebook
        path "m2_output.txt", emit: out

	script:
	"""
    cp "$baseDir/notebooks/analysis.ipynb" "analysis.ipynb"
    nb-clean clean "analysis.ipynb" --preserve-cell-metadata "tags"
    papermill "analysis.ipynb" "analysis_rendered.ipynb" -k nftemp -p resultsdir './' -p infile "$input" -p prjdir "$baseDir" -p njobs ${task.cpus}
    
	"""
}

