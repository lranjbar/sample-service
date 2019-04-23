//
// Copyright (c) 2019 Intel Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

loadGlobalLibrary()

pipeline {
    agent {
        label 'centos7-docker-4c-2g'
    }

    options {
        timestamps()
    }

    environment {
        VERSION = 'test'
    }

    stages {
        stage('🚿 LF Prep') {
            steps {
                edgeXSetupEnvironment()
                edgeXDockerLogin(settingsFile: env.MVN_SETTINGS)
            }
        }

        stage('🖋️ Mock Sigul Signing') {
            when { expression { edgex.isReleaseStream() } }
            steps {
                sh 'mkdir test'
                edgeXInfraLFToolsSign(command: 'dir', directory: 'test')

                sh "echo 'test' > test.txt"
                sh 'git add -A'
                sh "git commit -m 'Add test commit'"
                sh 'git tag v${VERSION}'
                edgeXInfraLFToolsSign(command: 'git-tag', version: 'v${VERSION}')
            }
        }
    }

    post {
        failure {
            script {
                currentBuild.result = "FAILED"
            }
        }
        always {
            edgeXInfraPublish()
        }
    }
}

def loadGlobalLibrary(branch = '*/add-sigul-function') {
    library(identifier: 'edgex-global-pipelines@add-sigul-function', 
        retriever: legacySCM([
            $class: 'GitSCM',
            userRemoteConfigs: [[url: 'https://github.com/lranjbar/edgex-global-pipelines.git']],
            branches: [[name: branch]],
            doGenerateSubmoduleConfigurations: false,
            extensions: [[
                $class: 'SubmoduleOption',
                recursiveSubmodules: true,
            ]]]
        )
    ) _
}
