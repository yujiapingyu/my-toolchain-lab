#include "engine.h"
#include <stdlib.h>

// 模拟一个简单的引擎控制逻辑
// 如果温度 > 100，转速限制在 1000；否则转速 2000
int calculate_rpm(int temperature) {

    // 【静态检查能发现】: 申请了内存没释放 (内存泄露)
    void *p = malloc(100);

    if (temperature > 100) {
        return 1000; // 过热保护
    } else if (temperature < -50) { // <--- 新增这个分支
        return 0; // 极寒模式，停机
    } else {
        return 2000; // 正常行驶
    }
}