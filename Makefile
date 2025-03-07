
# This Makefile may be used to build our fork of opentelemetry-swift for Linux. You may also use it
# on MacOS if you prefer the approach over Xcode (I do).

uname := $(shell uname)

SWIFTC_FLAGS += --configuration debug -Xswiftc -g
SWIFT := swift

SRCDIR := Sources/libpl
INCDIR := $(SRCDIR)/include
LIBDIR := ./lib

CC := gcc
CFLAGS := -ansi -pedantic -Wall -Werror -g

SRC := $(wildcard $(SRCDIR)/*.c)
OBJ := $(SRC:$(SRCDIR)/%.c=$(LIBDIR)/%.o)

LDFLAGS := -L.
LDLIBS := -l$(...)

.PHONY: all clean ctags etags libpl realclean reset resolve update

$(info Building for: [${uname}])

ifeq ($(uname), Linux)
all: opentelemetry
else
all: opentelemetry
endif

opentelemetry:
	${SWIFT} build $(SWIFTC_FLAGS)

update: resolve
	$(SWIFT) package update

resolve:
	$(SWIFT) package resolve

ctags:
	ctags -R --languages=swift .

etags:
	etags -R --languages=swift .

reset:
	$(SWIFT) package reset

clean:
	$(SWIFT) package clean
	@rm -rf lib

# NB: Be careful with the realclean target on MacOS, as it will affect your other local Swift project caching.

ifeq ($(uname), Darwin)
realclean: clean
	@rm -rf .build
	@rm -rf ~/Library/Caches/org.swift.swiftpm
	@rm -rf ~/Library/org.swift.swiftpm
else
realclean: clean
	@rm -rf .build
endif
