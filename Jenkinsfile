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

        stage('生成报告') {
            steps {
                // 调用 Python 脚本
                // 注意：Jenkins 容器里可能需要安装 python3，如果报错 'python3 not found'
                // 这就是面试题：如何维护构建环境？(答案：把 Python 装进 Docker 镜像里)
                sh 'python3 scripts/release_report.py' 
            }
        }
    }

}