#include <stdio.h>
#include <stdint.h>

int clz_iteration(uint32_t x);
int clz_byte_shift(uint32_t x);
int clz_binary_search(uint32_t x);
int clz_recursive(uint32_t x,uint32_t shift,uint32_t mask);
int clz_harley(uint32_t x);
