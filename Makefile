CFLAGS += -Wall -std=gnu99 -O0 -g

clz-tests: clz-tests.o
	gcc $(CFLAGS) clz-tests.c -o clz-tests

gencsv: clz-tests
	for i in `seq 0 1 214700`; do \
		printf "%d " $$i;\
		./clz-tests $$i; \
	done > runtime.csv	

plot: runtime.csv
	gnuplot scripts/runtime.gp
clean:
	rm clz-tests runtime.png