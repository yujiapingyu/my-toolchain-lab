CC ?= gcc
BUILD_DIR = build

# 生产代码的源文件
SRC = src/main.c src/engine.c
# 测试代码的源文件 (注意：不包含 src/main.c，避免两个 main 函数冲突)
TEST_SRC = tests/test_engine.c src/engine.c

all: clean directory build_firmware

directory:
	mkdir -p $(BUILD_DIR)

# 1. 编译固件 (给车用的)
build_firmware:
	@echo "构建固件..."
	# 这里如果是交叉编译，外面会传入 CC=arm-linux-gnueabi-gcc
	$(CC) $(SRC) -o $(BUILD_DIR)/firmware.bin

# 2. 运行测试 (给 CI 用的)
test: directory
	@echo "编译测试程序..."
	# 强制用宿主机 GCC 编译测试程序，因为要在 Jenkins 容器里跑
	gcc $(TEST_SRC) -o $(BUILD_DIR)/run_tests
	@echo "开始运行单元测试..."
	./$(BUILD_DIR)/run_tests

clean:
	rm -rf $(BUILD_DIR)