diff -u good.c bad.c

# rm -f good.ssa bad.ssa
# qbecc --dump-ssa good.c -I /usr/include/csmith -lm 2> good.ssa
# qbecc --dump-ssa bad.c -I /usr/include/csmith -lm 2> bad.ssa

diff -u good.ssa bad.ssa

rm -f a.out
gcc -w good.c -I /usr/include/csmith && ./a.out

rm -f a.out
gcc -w bad.c -I /usr/include/csmith && ./a.out

rm -f good.s a.out
qbe -t arm64 good.ssa > good.s
gcc -w good.s -lm && ./a.out

rm -f bad.s a.out
qbe -t arm64 bad.ssa > bad.s
gcc -w bad.s -lm && ./a.out

rm -f a.out
