#ifndef UNSAFE_H
#define UNSAFE_H

#include <stddef.h>

// Уязвимая функция: буферное переполнение
void vulnerable_copy(const char *input);

// Уязвимая функция: небезопасное чтение
void vulnerable_read(const char *filename);

// Безопасная альтернатива (для сравнения)
void safe_copy(const char *input, size_t len);

#endif
