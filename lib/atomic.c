//go:build ignore

#include <stdbool.h>
#include <stdint.h>

#define load(N, T) static void __atomic_load ## N (T *ptr, T *ret, int memorder) { \
	__atomic_load(ptr, ret,memorder); \
}

load(Uint16, uint16_t)
load(Uint32, uint32_t)
load(Uint64, uint64_t)
load(Uint8, uint8_t)

#define store(N, T) static void __atomic_store ## N (T *ptr, T *ret, int memorder) { \
	__atomic_store(ptr, ret,memorder); \
}

store(Uint16, uint16_t)
store(Uint32, uint32_t)
store(Uint64, uint64_t)
store(Uint8, uint8_t)

#define fetch_op(op, N, T) static T __atomic_fetch_ ## op ## N (T *ptr, T val, int memorder)	{ \
	return __atomic_fetch_ ## op(ptr, val, memorder); \
}

#define fetch(op) \
fetch_op(op, Uint16, uint16_t) \
fetch_op(op, Uint32, uint32_t) \
fetch_op(op, Uint64, uint64_t) \
fetch_op(op, Uint8, uint8_t)

fetch(add)
fetch(and)
fetch(or)
fetch(sub)
fetch(xor)

#define exchange(N, T) static void __atomic_exchange ## N (T *ptr, T *val, T *ret, int memorder) { \
	__atomic_exchange(ptr, val, ret, memorder); \
}

exchange(Uint16, uint16_t)
exchange(Uint32, uint32_t)
exchange(Uint64, uint64_t)
exchange(Uint8, uint8_t)

#define compare_exchange(N, T) static bool __atomic_compare_exchange ## N \
	(T *ptr, T *expected, T *desired, bool weak, int success_memorder, int failure_memorder) { \
	return __atomic_compare_exchange(ptr, expected, desired, weak, success_memorder, failure_memorder); \
}

compare_exchange(Uint16, uint16_t)
compare_exchange(Uint32, uint32_t)
compare_exchange(Uint64, uint64_t)
compare_exchange(Uint8, uint8_t)
