#include <stdio.h>
#include "engine.h"

int main() {
    int temp = 90;
    int rpm = calculate_rpm(temp);
    printf("Current Temp: %d, RPM: %d\n", temp, rpm);
    return 0;
}