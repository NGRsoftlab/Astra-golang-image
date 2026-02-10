package main

/*
#cgo CFLAGS: -O2
#include "unsafe.h"
#include <stdlib.h>
*/
import "C"
import (
	"fmt"
	"os"
	"unsafe"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: app <mode>")
		fmt.Println("  mode: overflow | read | safe")
		os.Exit(1)
	}

	mode := os.Args[1]

	switch mode {
	case "overflow":
		// Демонстрация переполнения стека (канарейки)
		// 100 байт в буфер 64 байта - переполнение стека
		overflowStr := C.CString(generateOverflowString(100))
		defer C.free(unsafe.Pointer(overflowStr))
		C.vulnerable_copy(overflowStr)

	case "read":
		// Демонстрация FORTIFY_SOURCE
		filename := C.CString("/etc/passwd")
		defer C.free(unsafe.Pointer(filename))
		C.vulnerable_read(filename)

	case "safe":
		// Безопасная версия
		safeStr := C.CString("Hello, World!")
		defer C.free(unsafe.Pointer(safeStr))
		C.safe_copy(safeStr, 5)

	default:
		fmt.Printf("Unknown mode: %s\n", mode)
	}
}

func generateOverflowString(n int) string {
	result := make([]byte, n)
	for i := range result {
		result[i] = 'A'
	}
	return string(result)
}
