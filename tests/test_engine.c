#include <stdio.h>
#include <assert.h> // 核心库：如果条件为假，程序直接崩溃报错
#include "../src/engine.h"

void test_normal_temperature() {
    // 场景1：温度 90 度，预期转速 2000
    int result = calculate_rpm(90);
    assert(result == 2000); 
    printf("[PASS] Normal Temperature Test\n");
}

void test_overheat_protection() {
    // 场景2：温度 110 度，预期转速 1000 (触发保护)
    int result = calculate_rpm(110);
    assert(result == 1000);
    printf("[PASS] Overheat Protection Test\n");
}

int main() {
    printf("Running Unit Tests...\n");
    
    test_normal_temperature();
    test_overheat_protection();
    
    printf("All Tests Passed!\n");
    return 0; // 返回 0 代表测试通过，Jenkins 看到 0 才会开心
}