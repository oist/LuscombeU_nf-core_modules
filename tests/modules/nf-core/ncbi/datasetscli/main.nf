#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { NCBI_DATASETSCLI } from '../../../../../modules/nf-core/ncbi/datasetscli/main.nf'

workflow test_ncbi_datasetscli {
    
    input = [
        [ id:'test', single_end:false, accession:'MT192765.1' ]
    ]

    NCBI_DATASETSCLI ( input, "virus", "genome", "accession" )
}
