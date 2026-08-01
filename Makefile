CC      := cc
LD      := ld
CFLAGS  := -O3 -Wall -Wextra -Werror
LDFLAGS :=

SRC := tools/gen-suffix.c
OBJ := $(SRC:.c=.o)

all: tools/gen-suffix

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

tools/gen-suffix: $(OBJ)
	$(CC) $(LDFLAGS) $^ -o $@

clean:
	rm -f tools/gen-suffix
	rm -f tools/*.o

.PHONY: clean
