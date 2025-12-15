pipeline {
    agent any

    stages {
        stage('环境检查') {
            steps {
                sh 'echo "当前构建分支: ${BRANCH_NAME}"'
                sh 'gcc --version' // 检查有没有编译器
            }
        }
        
        stage('编译固件') {
            steps {
                // 模拟：这里我们依然用 gcc，但在公司里你会配置成 arm-gcc
                sh 'make all'
            }
        }

        stage('产物归档') {
            steps {
                // 把生成的 bin 文件存起来，这就叫“交付”
                archiveArtifacts artifacts: 'build/*.bin', fingerprint: true
            }
        }
    }
}