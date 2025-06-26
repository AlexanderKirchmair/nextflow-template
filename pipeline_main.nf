#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Parameters
params.input = 'test'
params.resultsdir = 'results'


// Modules
include { m1_process } from "./modules/module_1.nf"
include { m2_process } from "./modules/module_2.nf"
include { m3_process } from "./modules/module_3.nf"


// Workflow
workflow {
    input = Channel.of("${params.input}")
    res_1 = m1_process(input)
    res_2 = m2_process(res_1)
    m3_process(res_2.out)
}





