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

        stage('Bazel 单元测试与覆盖率') {
            steps {
                echo "使用 Bazel 运行测试..."
                // --test_output=errors: 只有出错时才打印日志
                // --combined_report=lcov: 生成 lcov 格式的报告
                sh 'bazel coverage //:unit_test --combined_report=lcov --test_output=errors'
            }
        }

        stage('生成报告 (LCOV)') {
            steps {
                echo "处理 Bazel 生成的覆盖率数据..."
                script {
                    // Bazel 生成的报告路径比较深，通常在 bazel-out/_coverage/_coverage_report.dat
                    // 我们把它拷出来处理
                    
                    // 1. 找到 Bazel 的输出文件 (bazel-bin 是个快捷方式)
                    sh 'cp bazel-out/_coverage/_coverage_report.dat coverage.info'
                    
                    // 2. 像之前一样过滤 (tests 和 系统库)
                    // 注意：Bazel 路径可能包含 external/，需要根据实际情况调整，这里先跑通基本的
                    sh 'lcov --remove coverage.info "/usr/*" "*/tests/*" --output-file coverage_filtered.info --ignore-errors unused'
                    
                    // 3. 生成 HTML
                    sh 'genhtml coverage_filtered.info --output-directory coverage_report'
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'coverage_report/**/*', fingerprint: true
                }
            }
        }
        
        stage('Bazel 构建固件') {
            steps {
                echo "构建最终产物..."
                sh 'bazel build //:firmware'
                
                // Bazel 的产物在这里
                sh 'ls -l bazel-bin/firmware'
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