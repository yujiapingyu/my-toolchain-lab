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
	@echo "编译测试程序 (开启覆盖率)..."
	# 【关键】加入 --coverage 参数 (等同于 -fprofile-arcs -ftest-coverage)
	gcc --coverage $(TEST_SRC) -o $(BUILD_DIR)/run_tests
	
	@echo "运行单元测试..."
	./$(BUILD_DIR)/run_tests
	
	@echo "生成覆盖率报告..."
	# 1. 收集数据 (生成 .info 文件)
	# --capture: 抓取数据
	# --directory: 数据在哪？(在当前目录)
	# --output-file: 输出到哪里？
	lcov --capture --directory . --output-file $(BUILD_DIR)/coverage.info
	
	# 2. 过滤系统库 (我们不关心 stdio.h 的覆盖率，只关心我们自己的 src)
	lcov --remove $(BUILD_DIR)/coverage.info '/usr/*' --output-file $(BUILD_DIR)/coverage_filtered.info --ignore-errors unused
	
	# 3. 生成 HTML 网页报告
	genhtml $(BUILD_DIR)/coverage_filtered.info --output-directory $(BUILD_DIR)/coverage_report

# 修改 clean，把生成的临时文件 (*.gcda, *.gcno) 也删掉
clean:
	rm -rf $(BUILD_DIR) *.gcda *.gcno src/*.gcda src/*.gcno tests/*.gcda tests/*.gcno