node('centos7-docker-4c-2g') {
    stage('Clone') {
        def vars = checkout scm

        vars.each { k, v ->
            env.setProperty(k, v)
            if(k == 'GIT_BRANCH') {
                env.setProperty('GIT_BRANCH_CLEAN', v.replaceAll('/', '_'))
            }
        }
    }

    stage('Telegraf') {
        sh 'env | sort'
        docker.image('telegraf:latest')
          .inside("-u 0:0 --privileged --entrypoint='' -e HOST_PROC=/host/proc -v /proc:/host/proc:ro -v ${env.WORKSPACE}/telegraf.conf:/etc/telegraf/telegraf.conf:ro") {
              sh 'telegraf'
          }
    }
}