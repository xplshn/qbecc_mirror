// https://c9x.me/compile/doc/il-v1.2.html#Variadic
//
// However, it is possible to conservatively use the maximum size and alignment
// required by all the targets.
//
//	type :valist = align 8 { 24 }  # For amd64_sysv
//	type :valist = align 8 { 32 }  # For arm64
//	type :valist = align 8 { 8 }   # For rv64
#define __GNUC_VA_LIST

#if defined(__amd64__) || defined(__x86_64__) || defined(_M_X64)
typedef long long int __builtin_va_list[3];
#elif defined(__aarch64__) || defined(_M_ARM64) || defined(__ARM_ARCH_ISA_A64)
typedef long long int __builtin_va_list[4];
#elif (defined(__riscv) && __riscv_xlen == 64) || defined(__riscv64)
typedef long long int __builtin_va_list[1];
#endif

typedef __builtin_va_list __gnuc_va_list;

#ifndef __builtin_va_arg
#define __builtin_va_arg __builtin_va_arg
#define __builtin_va_arg(va, type) (*(type*)__builtin_va_arg(va))
#endif

#ifndef __builtin_types_compatible_p
#define __builtin_types_compatible_p(t1, t2) __builtin_types_compatible_p((t1){}, (t2){})
#endif

#ifndef __builtin_offsetof
#define __builtin_offsetof(type, member) ((__SIZE_TYPE__)&(((type*)0)->member))
#endif
