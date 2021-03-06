THIS_MAKEFILE := $(lastword $(MAKEFILE_LIST))

SRCROOT := $(realpath $(dir $(THIS_MAKEFILE))/../..)
include $(SRCROOT)/config.mk
export CXXFLAGS += \
-I$(LIBCXXGEN)/include \
-I$(LIBDWARFPP)/include \
-I$(LIBSRK31CXX)/include \
-I$(LIBCXXFILENO)/include \
-I$(LIBDLBIND)/include \

export LDFLAGS += \
-L$(LIBCXXGEN)/lib -Wl,-rpath,$(LIBCXXGEN)/lib \
-L$(LIBDWARFPP)/lib -Wl,-rpath,$(LIBDWARFPP)/lib \
-L$(LIBSRK31CXX)/lib -Wl,-rpath,$(LIBSRK31CXX)/lib \
-L$(LIBCXXFILENO)/lib -Wl,-rpath,$(LIBCXXFILENO)/lib \
-L$(LIBDLBIND)/lib -Wl,-rpath,$(LIBDLBIND)/lib

CXXFLAGS += -I$(SRCROOT)/include

LIBALLOCS ?= $(SRCROOT)/../liballocs
LIBALLOCS_BASE ?= $(realpath $(LIBALLOCS))

OCAMLFIND ?= ocamlfind
CIL_INSTALL ?= $(LIBALLOCS_BASE)/tools/lang/c/cil
CILLY ?= $(CIL_INSTALL)/bin/cilly
CIL_TOOLS := trumptr vsimplemem vsimpleaddr crunchbound dumpreftypes ptrintarith
OCAMLFLAGS +=  -package findlib -I $(CIL_INSTALL)/lib/cil
OCAMLFLAGS += -I $(dir $(THIS_MAKEFILE))/lib -I $(LIBALLOCS_BASE)/tools/lang/c/cilallocs #-I $(dir $(wildcard $(shell which $(CILLY))/../lib/ocaml/*/cil))

default: src lib cil sanity-tests

.PHONY: cil
cil: $(foreach t,$(CIL_TOOLS),$(t)/$(t).cmxs $(t)/$(t).cma)

%.cmxs: %.cmx 
	$(OCAMLFIND) ocamlopt -shared -o "$@" $(OCAMLOPTFLAGS) $(OCAMLFLAGS) $+
%.cmx %.cmi: %.ml
	$(OCAMLFIND) ocamlopt -o "$@" $(OCAMLOPTFLAGS) $(OCAMLFLAGS) -c "$<"
%.cmo %.cmi: %.ml
	$(OCAMLFIND) ocamlc -o "$@" $(OCAMLFLAGS) -c "$<"
%.cma: %.cmo
	$(OCAMLFIND) ocamlc -o "$@" $(OCAMLFLAGS) -a $+

# for testing
%.cil.o: %.c
	cd "$(dir $<)" && $(CILLY) --do$$( echo $(dir $<) | tr -d '/' ) --save-temps -c -o "$(notdir $@)" "$(notdir $<)"

clean:
	for dir in $(CIL_TOOLS); do (cd $$dir && rm -f *.o *.cmo *.cma *.cmi *.cmx *.cmxa *.cmxs *.cil.c *.i ); done
	$(MAKE) -C src clean

.PHONY: sanity-tests
sanity-tests: | src lib cil
	$(MAKE) -C ../../test FRONTEND=c cleanrun-hello cleanrun-hello-errno cleanrun-hello-static cleanrun-hello-stack cleanrun-hello-heap

.PHONY: src
src:
	$(MAKE) -C src
