node('centos7-docker-4c-2g') {
    stage('Clone') {
        checkout scm
    }

    stage('Telegraf') {
        def args = [
            '--privileged',
            '--entrypoint=telegraf',
            '-e HOST_PROC=/rootfs/proc',
            '-e HOST_SYS=/rootfs/sys',
            '-e HOST_ETC=/rootfs/etc',
            "-v ${env.WORKSPACE}/telegraf.conf:/etc/telegraf/telegraf.conf:ro",
            '-v /var/run/docker.sock:/var/run/docker.sock:ro',
            '-v /:/rootfs:ro'
        ]
        docker.build("telegraf-tester:latest").inside(args.join(' ')) {
            // run 5 minute stress test to generate info
            sh 'stress --cpu 2 --timeout 300'
        }
    }
}