# 默认编译器是 gcc，但在工具链中，我们可以替换成 arm-linux-gcc
CC ?= gcc
# 输出目录
BUILD_DIR = build

all: clean directory build_firmware

directory:
	mkdir -p $(BUILD_DIR)

build_firmware:
	@echo "正在使用编译器: $(CC) 进行构建..."
	$(CC) src/main.c -o $(BUILD_DIR)/firmware.bin

clean:
	rm -rf $(BUILD_DIR)