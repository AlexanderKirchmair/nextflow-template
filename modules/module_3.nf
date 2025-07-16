#!/usr/bin/env nextflow

process m3_process {

    // publishDir "${params.resultsdir}", mode: 'copy', overwrite: true

    input:
        path(input_file)

    output:
        path "m3_output.txt"

	script:
	"""
    cp ${input_file} m3_output.txt
	"""
}