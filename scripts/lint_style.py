import os
import sys

def check_style(directory):
    print(f"--- 正在检查代码风格 (禁止 Tab 缩进) ---")
    failed = False

    # 遍历 src 目录下的所有 .c 和 .h 文件
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith((".c", ".h")):
                path = os.path.join(root, file)
                with open(path, 'r', encoding='utf-8') as f:
                    line_num = 0
                    for line in f:
                        line_num += 1
                        if '\t' in line:
                            print(f"❌ 风格违规: {path} 第 {line_num} 行包含了 Tab 字符！请改为 4 个空格。")
                            failed = True

    if failed:
        sys.exit(1)
    else:
        print("✅ 风格检查通过。")
        sys.exit(0)

if __name__ == "__main__":
    check_style("src")