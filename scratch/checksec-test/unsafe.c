#include "unsafe.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

// Уязвимость: буферное переполнение (демонстрация канареек)
void vulnerable_copy(const char *input) {
    char buffer[64];
    // strcpy без проверки длины - переполнение стека
    strcpy(buffer, input);  // FORTIFY_SOURCE перехватит
    printf("Copied: %s\n", buffer);
}

// Уязвимость: небезопасное чтение (демонстрация FORTIFY)
void vulnerable_read(const char *filename) {
    char buf[256];
    FILE *f = fopen(filename, "r");
    if (f) {
        volatile size_t size = 1024;
        size_t nread = fread(buf, 1, (size_t)size, f);  // Переполнение буфера - FORTIFY перехватит
        (void)nread;
        fclose(f);
        printf("Read %zu bytes\n", nread);
    }
}

// Безопасная версия
void safe_copy(const char *input, size_t len) {
    char buffer[64];
    if (len >= sizeof(buffer)) len = sizeof(buffer) - 1;
    strncpy(buffer, input, len);
    buffer[len] = '\0';
    printf("Safe copied: %s\n", buffer);
}
