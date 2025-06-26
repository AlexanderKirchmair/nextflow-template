#!/usr/bin/env nextflow

process m1_process {

    publishDir "${params.resultsdir}", mode: 'copy', overwrite: true

    input:
        val input

    output:
       path "m1_output.txt"

	"""
    #!/usr/bin/env python

    import os
    import sys
    sys.path.append("$baseDir")

    from bin.py import functions as fct
    res = fct.toupper_function("$input")
    print(res,  file=open('m1_output.txt', 'w'))
	"""
}









