

```
jnml@rpi5:~/src/modernc.org/qbecc/lib/testdata/issue1 $ ls -l
total 2380
-rw-r--r-- 1 jnml jnml 146662 Aug 10 17:49 bad.c
-rw-r--r-- 1 jnml jnml 513341 Aug 10 17:51 bad.s
-rw-r--r-- 1 jnml jnml 551792 Aug 10 17:51 bad.ssa
-rw-r--r-- 1 jnml jnml 146662 Aug 10 17:49 good.c
-rw-r--r-- 1 jnml jnml 513301 Aug 10 17:51 good.s
-rw-r--r-- 1 jnml jnml 551801 Aug 10 17:51 good.ssa
-rwxr-xr-x 1 jnml jnml    491 Aug 10 17:53 issue1.sh
jnml@rpi5:~/src/modernc.org/qbecc/lib/testdata/issue1 $ ./issue1.sh | cat -n
     1	--- good.c	2025-08-10 17:49:31.826610954 +0200
     2	+++ bad.c	2025-08-10 17:49:31.846610981 +0200
     3	@@ -381,7 +381,7 @@
     4	                 int64_t l_1445 = 0x6E380154D2EE6A64LL;
     5	                 int32_t l_1446 = (-1L);
     6	                 int32_t l_1490 = 0xAB9DC537L;
     7	-		printf("%i\n", l_1487);
     8	+		printf("%i\n", l_2009);
     9	                 if ((safe_lshift_func_uint8_t_u_u((((safe_rshift_func_uint16_t_u_u((l_1445 |= ((*l_1434) = p_11)), 1)) ^ (l_1446 | ((safe_add_func_uint8_t_u_u((4294967290UL && 1UL), ((safe_mul_func_int16_t_s_s((l_1435 & ((*g_147) , ((safe_mul_func_uint8_t_u_u((safe_add_func_uint8_t_u_u((safe_lshift_func_uint16_t_u_u((safe_div_func_uint32_t_u_u((*g_896), (func_19(p_10.f0, func_19(p_11, p_12, l_1459), l_1459) , 0xAA96EC6FL))), l_1446)), p_13)), 0x1FL)) , l_1418))), p_12.f0)) & p_9))) == p_11))) > p_9), l_1435)))
    10	                 { /* block id: 591 */
    11	                     for (g_1304 = 0; (g_1304 == 12); g_1304 = safe_add_func_uint32_t_u_u(g_1304, 4))
    12	--- good.ssa	2025-08-10 17:51:26.406747151 +0200
    13	+++ bad.ssa	2025-08-10 17:51:27.214748024 +0200
    14	@@ -1,12 +1,12 @@
    15	 # ==== SSA
    16	-type :__qbe_complexl = {
    17	-	d 2,
    18	-}
    19	-
    20	 type :__qbe_complexf = {
    21	 	s 2,
    22	 }
    23	 
    24	+type :__qbe_complexl = {
    25	+	d 2,
    26	+}
    27	+
    28	 type :__fsid_t = {
    29	 	w 2,
    30	 }
    31	@@ -8457,7 +8457,7 @@
    32	 	%.1954 =l neg 1
    33	 	%l_1446.53 =w copy %.1954
    34	 	%l_1490.54 =w copy 2879243575
    35	-	%.1955 =w copy %l_1487.34
    36	+	%.1955 =w copy %l_2009.10
    37	 	%.1956 =w call $"printf"(l $".ts.881",...,w %.1955,)
    38	 	%.1957 =l copy %l_1445.52
    39	 	%.1958 =l copy %l_1434.32
    40	@@ -24588,6 +24588,7 @@
    41	 data $".ts.1775" = align 1 { b 40, b 108, b 95, b 54, b 52, b 51, b 32, b 62, b 61, b 32, b 38, b 103, b 95, b 57, b 50, b 91, b 48, b 93, b 32, b 38, b 38, b 32, b 108, b 95, b 54, b 52, b 51, b 32, b 60, b 61, b 32, b 38, b 103, b 95, b 57, b 50, b 91, b 52, b 93, b 41, b 32, b 124, b 124, b 32, b 108, b 95, b 54, b 52, b 51, b 32, b 61, b 61, b 32, b 48, b 0 }
    42	 data $".ts.670" = align 1 { b 46, b 46, b 46, b 99, b 104, b 101, b 99, b 107, b 115, b 117, b 109, b 32, b 97, b 102, b 116, b 101, b 114, b 32, b 104, b 97, b 115, b 104, b 105, b 110, b 103, b 32, b 37, b 115, b 32, b 58, b 32, b 37, b 108, b 88, b 10, b 0 }
    43	 data $".ts.2028" = align 1 { b 49, b 0 }
    44	+data $".ts.737" = align 1 { b 98, b 97, b 100, b 46, b 99, b 0 }
    45	 data $".ts.5" = align 1 { b 99, b 104, b 101, b 99, b 107, b 115, b 117, b 109, b 32, b 61, b 32, b 37, b 88, b 10, b 0 }
    46	 data $".ts.2046" = align 1 { b 103, b 95, b 49, b 48, b 48, b 0 }
    47	 data $".ts.2113" = align 1 { b 103, b 95, b 49, b 48, b 52, b 57, b 0 }
    48	@@ -24648,7 +24649,6 @@
    49	 data $".ts.2112" = align 1 { b 103, b 95, b 56, b 56, b 55, b 0 }
    50	 data $".ts.2036" = align 1 { b 103, b 95, b 57, b 48, b 0 }
    51	 data $".ts.2041" = align 1 { b 103, b 95, b 57, b 50, b 91, b 105, b 93, b 0 }
    52	-data $".ts.737" = align 1 { b 103, b 111, b 111, b 100, b 46, b 99, b 0 }
    53	 data $".ts.2044" = align 1 { b 105, b 110, b 100, b 101, b 120, b 32, b 61, b 32, b 91, b 37, b 100, b 93, b 10, b 0 }
    54	 data $".ts.2086" = align 1 { b 105, b 110, b 100, b 101, b 120, b 32, b 61, b 32, b 91, b 37, b 100, b 93, b 91, b 37, b 100, b 93, b 10, b 0 }
    55	 data $".ts.2104" = align 1 { b 105, b 110, b 100, b 101, b 120, b 32, b 61, b 32, b 91, b 37, b 100, b 93, b 91, b 37, b 100, b 93, b 91, b 37, b 100, b 93, b 10, b 0 }
    56	1
    57	1
    58	checksum = ED78C0C3
    59	1
    60	1
    61	checksum = ED78C0C3
    62	1
    63	1
    64	checksum = ED78C0C3
    65	1
    66	-79377216
    67	checksum = AA556609
jnml@rpi5:~/src/modernc.org/qbecc/lib/testdata/issue1 $ 

```

Lines 7-8 show a small difference: we print different local variables. The only relevant change in produced SSA is at lines 35-36.

Lines 56-61 are produced by gcc. Lines 62-67 are produces by qbe from the respectivce SSA, the lines should be the same as lines 56-61,  but line 66 differs from line 60. The same test  works on linux/amd64:


```
jnml@3900x:~/src/modernc.org/qbecc/lib/testdata/issue1$ ls -la
total 1388
drwxr-xr-x 2 jnml jnml   4096 Aug 10 18:00 .
drwxr-xr-x 3 jnml jnml   4096 Aug 10 15:10 ..
-rw-r--r-- 1 jnml jnml 146662 Aug 10 17:53 bad.c
-rw-r--r-- 1 jnml jnml 551792 Aug 10 17:53 bad.ssa
-rw-r--r-- 1 jnml jnml 146662 Aug 10 17:53 good.c
-rw-r--r-- 1 jnml jnml 551801 Aug 10 17:53 good.ssa
-rwxr-xr-x 1 jnml jnml    491 Aug 10 17:53 issue1.sh
-rw-r--r-- 1 jnml jnml   4303 Aug 10 17:45 README.md
jnml@3900x:~/src/modernc.org/qbecc/lib/testdata/issue1$ rm -f good.s bad.s
jnml@3900x:~/src/modernc.org/qbecc/lib/testdata/issue1$ qbe -t amd64_sysv good.ssa > good.s
jnml@3900x:~/src/modernc.org/qbecc/lib/testdata/issue1$ qbe -t amd64_sysv bad.ssa > bad.s
jnml@3900x:~/src/modernc.org/qbecc/lib/testdata/issue1$ rm -f a.out ; gcc -w good.s -lm && ./a.out
1
1
checksum = ED78C0C3
jnml@3900x:~/src/modernc.org/qbecc/lib/testdata/issue1$ rm -f a.out ; gcc -w bad.s -lm && ./a.out
1
1
checksum = ED78C0C3
jnml@3900x:~/src/modernc.org/qbecc/lib/testdata/issue1$ 

```

----

QBE version:



```

commit 120f316162879b6165deba77815cd4193fb2fb59
Author: Quentin Carbonneaux <quentin@c9x.me>
Date:   Fri May 30 17:40:17 2025 +0200

    skip deleted phis in use width scan

```
