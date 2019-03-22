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
        sh 'ls -al'
    }
}