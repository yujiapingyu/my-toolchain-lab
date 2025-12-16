pipeline {
    agent any

    stages {

        stage('初始化') {
            steps {
                // 【Groovy 实战】
                // script 块允许你写复杂的 Groovy 代码
                script {
                    // 获取 Git 的 commit message (简短版)
                    def commitMsg = sh(script: "git log -1 --pretty=%s", returnStdout: true).trim()
                    
                    // 修改 Jenkins 界面上的构建名称
                    // 效果： #12 (main) - Test Fail
                    currentBuild.displayName = "#${env.BUILD_NUMBER} (${env.BRANCH_NAME}) - ${commitMsg}"
                    
                    echo "构建名称已更新，看起来更专业了！"
                }
            }
        }

        stage('环境检查') {
            steps {
                sh 'echo "当前构建分支: ${BRANCH_NAME}"'
                sh 'gcc --version' // 检查有没有编译器
            }
        }

        stage('单元测试') {
            steps {
                echo "正在进行单元测试..."
                // 这一步如果失败（assert 报错），Pipeline 会直接变红停止
                sh 'make test'
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