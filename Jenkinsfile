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

loadGlobalLibrary('add-codecov')

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

        stage('🛠️ Multi-Arch Build') {
            // fan out
            parallel {
                stage('💉 Test amd64') {
                    agent {
                        dockerfile {
                            filename 'docker/Dockerfile'
                            label 'centos7-docker-4c-2g'
                            args '-u 0:0' // needed for go mod cache
                        }
                    }
                    steps {
                        sh 'make test'
                        edgeXCodecov('sample-service-codecov-token')
                    }
                }
                stage('💉Test arm64') {
                    agent {
                        dockerfile {
                            filename 'docker/Dockerfile'
                            label 'ubuntu18.04-docker-arm64-4c-2g'
                            // additionalBuildArgs '--platform linux/arm64' //only works with experimental on
                            args '-u 0:0' // needed for go mod cache
                        }
                    }
                    steps {
                        sh 'make test'
                        edgeXCodecov('sample-service-codecov-token')
                    }
                }
            }
        }

        stage('🎬 Semver Init') {
            when { expression { edgex.isReleaseStream() } }
            steps {
                edgeXSemver 'init'
                script {
                    def semverVersion = edgeXSemver()
                    env.setProperty('VERSION', semverVersion)
                }
            }
        }

        stage('🏷️ Semver Tag') {
            when { expression { edgex.isReleaseStream() } }
            steps {
                edgeXSemver('tag')
            }
        }

        stage('🖋️ Mock Sigul Signing') {
            when { expression { edgex.isReleaseStream() } }
            steps {
                sh 'echo lftools sigul branch v${VERSION}'
                sh 'echo lftools sigul docker v${VERSION}'
            }
        }

        stage('📦 Mock Push Docker Image') {
            when { expression { edgex.isReleaseStream() } }
            steps {
                sh 'echo docker tag edgexfoundry/device-sdk-go:${VERSION}'
                sh 'echo docker push edgexfoundry/device-sdk-go:${VERSION}'
            }
        }

        stage('⬆️ Semver Bump Patch Version') {
            when { expression { edgex.isReleaseStream() } }
            steps {
                edgeXSemver('bump patch')
                edgeXSemver('-push')
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

def loadGlobalLibrary(branch = '*/master') {
    library(identifier: 'edgex-global-pipelines@master', 
        retriever: legacySCM([
            $class: 'GitSCM',
            userRemoteConfigs: [[url: 'https://github.com/tmpowers/edgex-global-pipelines.git']],
            branches: [[name: branch]],
            doGenerateSubmoduleConfigurations: false,
            extensions: [[
                $class: 'SubmoduleOption',
                recursiveSubmodules: true,
            ]]]
        )
    ) _
}
