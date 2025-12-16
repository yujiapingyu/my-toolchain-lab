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

        stage('静态代码分析') {
            parallel { // 【亮点】并行执行，节省时间
                stage('Cppcheck (逻辑/安全)') {
                    steps {
                        echo "运行 Cppcheck..."
                        // 检查 src 文件夹
                        sh 'cppcheck src/ --enable=all --error-exitcode=1 --suppress=missingIncludeSystem'
                    }
                }
                stage('Python Lint (代码风格)') {
                    steps {
                        echo "运行风格检查..."
                        sh 'python3 scripts/lint_style.py'
                    }
                }
            }
        }

        stage('单元测试') {
            steps {
                echo "正在进行单元测试..."
                // 这一步如果失败（assert 报错），Pipeline 会直接变红停止
                sh 'make test'
            }
            post {
                always {
                    // (可选) 如果你装了 HTML Publisher 插件，可以用这句：
                    publishHTML (target: [
                        allowMissing: false,
                        alwaysLinkToLastBuild: true,
                        keepAll: true,
                        reportDir: 'build/coverage_report',
                        reportFiles: 'index.html',
                        reportName: 'Coverage Report'
                    ])
                    
                    // 暂时先归档成文件，让你能下载看
                    archiveArtifacts artifacts: 'build/coverage_report/**/*', fingerprint: true
                }
            }
        }

        
        
        stage('编译与质量检查') {
            steps {
                echo "开始编译并记录日志..."
                
                // 1. 编译，并把输出重定向到 build.log 文件
                // 2>&1 意思是把错误信息(stderr)也写进文件里
                sh 'mkdir -p build'
                sh 'make > build.log 2>&1'
                
                // 打印日志给 Jenkins 看一眼 (可选)
                sh 'cat build.log'

                echo "运行 Python 脚本进行质量门禁..."
                // 2. 【Python 实战】调用脚本检查刚才生成的 build.log
                sh 'python3 scripts/quality_check.py build.log'
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