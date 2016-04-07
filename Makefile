CC := ldmd2
LD := ldmd2

PROGRAM := huffman

D_SRCS := $(wildcard *.d)

OBJS_DIR := objs
OBJS := $(patsubst %.d,$(OBJS_DIR)/%.o,$(D_SRCS))

INCLUDE := 
LIBS    :=

BASEFLAGS := -m64 -g
WARNFLAGS := -w
CFLAGS := $(DEFINES) $(BASEFLAGS) $(WARNFLAGS) $(INCLUDE)
LDFLAGS := 

$(PROGRAM): $(OBJS) 
	$(LD) $(LDFLAGS) $(OBJS) -of$@

$(OBJS_DIR)/%.o: %.d Makefile
	$(CC) $(CFLAGS) -c $< -od$(OBJS_DIR)

.PHONY: clean
clean:
	$(RM) -f $(OBJS) $(PROGRAM)

