#include "engine.h"

// 模拟一个简单的引擎控制逻辑
// 如果温度 > 100，转速限制在 1000；否则转速 2000
int calculate_rpm(int temperature) {
    if (temperature > 100) {
        return 1000; // 过热保护
    } else {
        return 2000; // 正常行驶
    }
}