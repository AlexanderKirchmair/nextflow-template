#!/usr/bin/env nextflow
nextflow.enable.dsl=2
nextflow.preview.output = true

// Parameters
params.input = 'test'
params.resultsdir = 'results'
params.outputDir = 'results'

// Modules
include { m1_process } from "./modules/module_1.nf"
include { m2_process } from "./modules/module_2.nf"
include { m3_process } from "./modules/module_3.nf"


// Workflow
workflow {
    main:
    input = Channel.of("${params.input}")
    res_1 = m1_process(input)
    res_2 = m2_process(res_1)
    res_3 = m3_process(res_2.out)

    publish:
    res_1 >> 'm1'
    res_2.out >> 'm2'
    res_2.notebook >> 'm2_nb'
    res_3 >> 'm3'
}

// Output
output {
    m1 {path '.'}
    m2 {path '.'}
    m2_nb {path 'notebooks'}
    m3 {path '.'}
}



