BUILD_OUTDIR := build
BUILD_OUTPUT := $(BUILD_OUTDIR)/libtess2.a

RM ?= rm -f
CP ?= cp -f
CC ?= gcc
MKDIR ?= mkdir -p
AR ?= ar
AR_CMD ?= $(AR) rcs

BUILD_SRCS := \
	Source/bucketalloc.c \
	Source/tess.c \
	Source/sweep.c \
	Source/priorityq.c \
	Source/mesh.c \
	Source/geom.c \
	Source/dict.c

BUILD_CFLAGS = $(CPPFLAGS) $(CFLAGS) -IInclude

BUILD_SRCS := $(BUILD_SRCS:.c=.o)
BUILD_SRCS := $(BUILD_SRCS:.cpp=.o)

BUILD_OBJS := $(addprefix $(BUILD_OUTDIR)/,$(BUILD_SRCS))
BUILD_DIRS := $(sort $(dir $(BUILD_OBJS)))


all: .prebuild_local $(BUILD_OUTPUT)

-include $(patsubst %.o,%.d,$(BUILD_OBJS))

$(BUILD_OUTPUT) : $(BUILD_OBJS)
	$(AR_CMD) $(BUILD_OUTPUT) $(BUILD_OBJS)

$(BUILD_OUTDIR)/%.o: %.c
	$(CC) -MMD -MP -MF $(BUILD_OUTDIR)/$*.d $(BUILD_CFLAGS) -c -o $@ $<

.prebuild_local:
	@echo "=== Begin build ==="
	$(MKDIR) $(BUILD_DIRS) $(BUILD_OUTDIR)

clean:
	$(RM) -r $(BUILD_OUTDIR)
