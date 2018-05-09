CC ?= gcc
OUT ?= build

CFLAGS := -Wall -Wextra -Wno-unused-parameter -g
CFLAGS += --std=gnu99 -pthread
CFLAGS += -include config.h -I include

SRC = src

OBJS := \
	arp.o \
	ether.o \
	ether_fcs.o \
	icmp.o \
	ip.o \
	ip_defer.o \
	ip_fragment.o \
	ip_route.o \
	tcp.o \
	udp.o \
	socket.o

OBJS += \
	linux/ether.o

# stack entry
OBJS += nstack.o

OBJS := $(addprefix $(OUT)/, $(OBJS))
deps := $(OBJS:%.o=%.o.d)

SHELL_HACK := $(shell mkdir -p $(OUT))
SHELL_HACK := $(shell mkdir -p $(OUT)/linux)

EXEC = $(OUT)/inetd

all: $(EXEC)

$(OUT)/%.o: $(SRC)/%.c
	$(CC) -o $@ $(CFLAGS) -c -MMD -MF $@.d $<

$(OUT)/inetd: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

clean:
	$(RM) $(EXEC) $(OBJS) $(deps)
distclean: clean
	$(RM) -r $(OUT)

-include $(deps)
