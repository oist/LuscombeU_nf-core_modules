process NCBI_DATASETSCLI {
    tag "$meta.id"
    label 'process_single'

    conda "ncbi-datasets-cli"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/ncbi-datasets-cli:14.26.0':
        'biocontainers/ncbi-datasets-cli:14.26.0' }"

    input:
    val(meta)
    val(command)
    val(subcommand)
    val(by)

    output:
    tuple val(meta), path("*.zip"), emit: zip
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def by_id = meta[0][by]
    """
    [ -e /usr/local/ssl/cacert.pem ] && export SSL_CERT_FILE=/usr/local/ssl/cacert.pem
    datasets \\
        download \\
        $command $subcommand \\
        $by $by_id \\
        $args \\

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ncbi: \$(echo \$(datasets --version 2>&1) | sed 's/datasets version://' ))
    END_VERSIONS
    """
}
