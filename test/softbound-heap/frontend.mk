case_name := $(notdir $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))))
CASES_CONFIG_sb := $(CASES_CONFIG_sb) $(case_name)
CASES_c := $(CASES_c) $(case_name)
