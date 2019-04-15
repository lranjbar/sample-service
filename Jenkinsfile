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
                sh 'echo lftools sigul branch v${VERSION}'
                sh 'echo lftools sigul docker v${VERSION}'
                sh 'mkdir test'
                edgeXInfraLFToolsSign(command: 'dir', directory: 'test')
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

def loadGlobalLibrary(branch = '*/add-sigul') {
    library(identifier: 'edgex-global-pipelines@add-sigul', 
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
