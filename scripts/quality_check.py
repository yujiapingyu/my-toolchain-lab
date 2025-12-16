import sys
import re

def check_warnings(log_file_path):
    print(f"--- [Python Script] 正在审查日志: {log_file_path} ---")
    
    warning_count = 0
    
    try:
        # 打开日志文件
        with open(log_file_path, 'r', encoding='utf-8', errors='ignore') as f:
            for line in f:
                # 检查是否包含 'warning:' (GCC 的标准警告格式)
                if "warning:" in line.lower():
                    print(f"发现警告: {line.strip()}")
                    warning_count += 1
    except FileNotFoundError:
        print("错误: 找不到日志文件！")
        sys.exit(1) # 返回 1，让 Jenkins 报错

    print(f"--- 审查结束。总共发现 {warning_count} 个警告 ---")

    if warning_count > 0:
        print("❌ 质量门禁失败：代码中包含警告，不允许发布！")
        sys.exit(1) # 【关键】返回非 0 值，Jenkins 会认为这步失败了
    else:
        print("✅ 质量门禁通过：代码很干净。")
        sys.exit(0) # 返回 0，Jenkins 认为成功

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("用法: python3 quality_check.py <log_file>")
        sys.exit(1)
    
    check_warnings(sys.argv[1])