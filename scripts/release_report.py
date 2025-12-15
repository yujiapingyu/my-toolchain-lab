import os
import datetime

def generate_report():
    # 获取当前时间
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # 模拟：获取最近一次 git commit 的信息
    # 在真实环境会用 git log 命令，这里简单模拟
    commit_msg = "Fix: 修复了引擎启动时的抖动问题"
    builder = "Jenkins-Bot"
    
    report_content = f"""
    =============================
       固件发布报告 (Build Report)
    =============================
    构建时间: {now}
    构建者: {builder}
    
    本次变更:
    - {commit_msg}
    
    状态: 编译成功
    =============================
    """
    
    # 写入文件
    with open("build/release_note.txt", "w") as f:
        f.write(report_content)
    
    print("报告已生成: build/release_note.txt")

if __name__ == "__main__":
    generate_report()