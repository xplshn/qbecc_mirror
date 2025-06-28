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

#if sizeof(double) == sizeof(long double)
#define __builtin_huge_vall(x) __builtin_huge_val(x)
#endif

__SIZE_TYPE__ __builtin_object_size(void *p, int i);
__SIZE_TYPE__ __builtin_strcspn(const char *s, const char *reject);
__SIZE_TYPE__ __builtin_strlen(const char *s);
__SIZE_TYPE__ __builtin_strspn(const char *s, const char *accept);
__UINT16_TYPE__ __builtin_bswap16 (__UINT16_TYPE__ x);
__UINT32_TYPE__ __builtin_bswap32 (__UINT32_TYPE__ x);
__UINT64_TYPE__ __builtin_bswap64 (__UINT64_TYPE__ x);
char *__builtin___strcpy_chk(char *dest, const char *src, __SIZE_TYPE__ n);
char *__builtin_strcasestr(const char *haystack, const char *needle);
char *__builtin_strcat(char *dest, const char *src);
char *__builtin_strcat_chk(char *dest, const char *src, __SIZE_TYPE__ n);
char *__builtin_strchr(const char *s, int c);
char *__builtin_strcpy(char *dest, const char *src);
char *__builtin_strcpy_chk(char *dest, const char *src, __SIZE_TYPE__ n);
char *__builtin_strncat(char *dest, const char *src, __SIZE_TYPE__ n);
char *__builtin_strncpy(char *dest, const char *src, __SIZE_TYPE__ n);
char *__builtin_strpbrk(const char *s, const char *accept);
char *__builtin_strrchr(const char *s, int c);
char *__builtin_strstr(const char *haystack, const char *needle);
double __builtin_acos(double x);
double __builtin_asin(double x);
double __builtin_atan(double x);
double __builtin_atan2(double y, double x);
double __builtin_ceil(double x);
double __builtin_copysign(double x, double y);
double __builtin_cos(double x);
double __builtin_cosh(double x);
double __builtin_exp(double x);
double __builtin_fabs(double x);
double __builtin_floor(double x);
double __builtin_fmod(double x, double y);
double __builtin_frexp(double x, int *exp);
double __builtin_huge_val();
double __builtin_inf();
double __builtin_ldexp(double x, int exp);
double __builtin_log(double x);
double __builtin_log10(double x);
double __builtin_modf(double x, double *iptr);
double __builtin_nan(char*);
double __builtin_pow(double x, double y);
double __builtin_sin(double x);
double __builtin_sinh(double x);
double __builtin_sqrt(double x);
double __builtin_tan(double x);
double __builtin_tanh(double x);
float __builtin_acosf(float x);
float __builtin_asinf(float x);
float __builtin_atan2f(float y, float x);
float __builtin_atanf(float x);
float __builtin_ceilf(float x);
float __builtin_copysignf(float x, float y);
float __builtin_cosf(float x);
float __builtin_coshf(float x);
float __builtin_expf(float x);
float __builtin_fabsf(float x);
float __builtin_floorf(float x);
float __builtin_fmodf(float x, float y);
float __builtin_frexpf(float x, int *exp);
float __builtin_huge_valf();
float __builtin_inff();
float __builtin_ldexpf(float x, int exp);
float __builtin_log10f(float x);
float __builtin_logf(float x);
float __builtin_modff(float x, float *iptr);
float __builtin_nanf(char*);
float __builtin_powf(float x, float y);
float __builtin_sinf(float x);
float __builtin_sinhf(float x);
float __builtin_sqrtf(float x);
float __builtin_tanf(float x);
float __builtin_tanhf(float x);
int __builtin___snprintf_chk (char *s, __SIZE_TYPE__ maxlen, int flag, __SIZE_TYPE__ os, char *fmt, ...);
int __builtin___sprintf_chk(char * str, int flag, __SIZE_TYPE__ strlen, char * format, ...);
int __builtin___vsnprintf_chk(char * s, __SIZE_TYPE__ maxlen, int flag, __SIZE_TYPE__ slen, char * format, __builtin_va_list args);
int __builtin_abs(int j);
int __builtin_clz (unsigned int x);
int __builtin_clzl (unsigned long x);
int __builtin_ctz (unsigned int x);
int __builtin_ctzl (unsigned long x);
int __builtin_dprintf(int fd, const char *format, ...);
int __builtin_fprintf(void *stream, const char *format, ...);
int __builtin_fputc(int c, void *stream);
int __builtin_fputs(const char *s, void *stream);
int __builtin_fscanf(void *stream, const char *format, ...);
int __builtin_isalnum(int c);
int __builtin_isalpha(int c);
int __builtin_isascii(int c);
int __builtin_isblank(int c);
int __builtin_iscntrl(int c);
int __builtin_isdigit(int c);
int __builtin_isgraph(int c);
int __builtin_islower(int c);
int __builtin_isprint(int c);
int __builtin_ispunct(int c);
int __builtin_isspace(int c);
int __builtin_isunordered(double, double);
int __builtin_isupper(int c);
int __builtin_isxdigit(int c);
int __builtin_memcmp(const void *s1, const void *s2, __SIZE_TYPE__ n);
int __builtin_printf(const char *format, ...);
int __builtin_putc(int c, void *stream);
int __builtin_putchar(int c);
int __builtin_puts(const char *s);
int __builtin_scanf(const char *format, ...);
int __builtin_snprintf(char *str, __SIZE_TYPE__ size, const char *format, ...);
int __builtin_sprintf(char *str, const char *format, ...);
int __builtin_sscanf(const char *str, const char *format, ...);
int __builtin_strcmp(const char *s1, const char *s2);
int __builtin_strncmp(const char *s1, const char *s2, __SIZE_TYPE__ n);
int __builtin_tolower(int c);
int __builtin_toupper(int c);
int __builtin_vdprintf(int fd, const char *format, __builtin_va_list ap);
int __builtin_vfprintf(void *stream, const char *format, __builtin_va_list ap);
int __builtin_vfscanf(void *stream, const char *format, __builtin_va_list ap);
int __builtin_vprintf(const char *format, __builtin_va_list ap);
int __builtin_vscanf(const char *format, __builtin_va_list ap);
int __builtin_vsnprintf(char *str, __SIZE_TYPE__ size, const char *format, __builtin_va_list ap);
int __builtin_vsprintf(char *str, const char *format, __builtin_va_list ap);
int __builtin_vsscanf(const char *str, const char *format, __builtin_va_list ap);
int __ccgo__types_compatible_p();
long __builtin_expect(long, long);
long __builtin_labs(long j);
long double __builtin_acosl(long double x);
long double __builtin_asinl(long double x);
long double __builtin_atan2l(long double y, long double x);
long double __builtin_atanl( long double x);
long double __builtin_atanl(long double x);
long double __builtin_ceill(long double x);
long double __builtin_copysignl(long double x, long double y);
long double __builtin_coshl(long double x);
long double __builtin_cosl(long double x);
long double __builtin_expl(long double x);
long double __builtin_fabsl(long double x);
long double __builtin_floorl(long double x);
long double __builtin_fmodl(long double x, long double y);
long double __builtin_frexpl(long double x, int *exp);
long double __builtin_infl();
long double __builtin_ldexpl(long double x, int exp);
long double __builtin_log10l(long double x);
long double __builtin_logl(long double x);
long double __builtin_modfl(long double x, long double *iptr);
long double __builtin_nanl(char*);
long double __builtin_powl(long double x, long double y);
long double __builtin_sinhl(long double x);
long double __builtin_sinl(long double x);
long double __builtin_sqrtl(long double x);
long double __builtin_tanhl(long double x);
long double __builtin_tanl(long double x);
long long __builtin_llabs(long long j);
void *__builtin___memcpy_chk(void * dest, void * src, __SIZE_TYPE__ len, __SIZE_TYPE__ destlen);
void *__builtin___memmove_chk(void * dest, void * src, __SIZE_TYPE__ len, __SIZE_TYPE__ destlen);
void *__builtin___memset_chk(void * dest, int c, __SIZE_TYPE__ len, __SIZE_TYPE__ destlen);
void *__builtin___strncpy_chk (char *dest, char *src, __SIZE_TYPE__ len, __SIZE_TYPE__ dstlen);
void *__builtin__strncpy_chk (char *dest, char *src, __SIZE_TYPE__ len, __SIZE_TYPE__ dstlen);
void *__builtin_alloca(__SIZE_TYPE__ size);
void *__builtin_calloc(__SIZE_TYPE__ nmemb, __SIZE_TYPE__ size);
void *__builtin_malloc(__SIZE_TYPE__ size);
void *__builtin_memchr(const void *s, int c, __SIZE_TYPE__ n);
void *__builtin_memcpy(void *dest, const void *src, __SIZE_TYPE__ n);
void *__builtin_memrchr(const void *s, int c, __SIZE_TYPE__ n);
void *__builtin_memset(void *s, int c, __SIZE_TYPE__ n);
void *__builtin_rawmemchr(const void *s, int c);
void *__builtin_realloc(void *ptr, __SIZE_TYPE__ size);
void *__builtin_reallocarray(void *ptr, __SIZE_TYPE__ nmemb, __SIZE_TYPE__ size);
void __builtin_abort(void);
void __builtin_exit(int status);
void __builtin_free(void *ptr);
void __builtin_prefetch (void*, ...);
void __builtin_unreachable();
