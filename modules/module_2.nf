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
    # execution dir and results dir need both to be the local nextflow dir
    # infile is the locally staged input file
    # prjdir is the basedir that contains python libraries etc.

    papermill "$baseDir/notebooks/analysis.ipynb" "analysis_rendered.ipynb" -p resultsdir './' -p infile "$input" -p prjdir "$baseDir"

	"""
}