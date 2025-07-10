#!/usr/bin/env nextflow

process m2_process {
 
    publishDir "${params.resultsdir}", mode: 'copy', overwrite: true

    input:
        path(input)

    output:
        path "analysis_rendered.ipynb"
        path "m2_output.txt", emit: out

	script:
	"""
    papermill "$baseDir/notebooks/analysis.ipynb" "analysis_rendered.ipynb" -k nftemp -p resultsdir './' -p infile "$input" -p prjdir "$baseDir"
    
	"""
}

