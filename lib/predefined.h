// cc/v4 specific
typedef int __predefined_declarator;

#undef __SIZEOF_INT128__
#undef __SIZEOF_UINT128__

#ifndef __extension__
#define __extension__
#endif

#ifdef __SIZE_TYPE__
typedef __SIZE_TYPE__ __predefined_size_t;
#endif

#ifdef __WCHAR_TYPE__
typedef __WCHAR_TYPE__ __predefined_wchar_t;
#endif

#ifdef __PTRDIFF_TYPE__
typedef __PTRDIFF_TYPE__ __predefined_ptrdiff_t;
#endif

#ifndef __FUNCTION__
#define __FUNCTION__ __func__
#endif

#ifndef __PRETTY_FUNCTION__
#define __PRETTY_FUNCTION__ __func__
#endif

struct __qbe_complex { double real; double imag; };
struct __qbe_complexf { float real; float imag; };
struct __qbe_complexl { long double real; long double imag; };
