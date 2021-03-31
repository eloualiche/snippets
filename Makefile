# GENERAL MAKEFILE for the snippets 
#
#
#
#
#
# Erik Loualiche
# --------------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------------
# OPTIONS and ENVIRONMENT
include ./utilities/rules.mk # edit and write all of your path in rules.ml
src ?= .
# --------------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------------
iv_interact_fe:
		$(call colorecho, "Checking IV regressions in julia and stata ...")
		mkdir -p log
		$(call colorecho, "... stata ... generate the random data and run IV ... ")
		$(STATA_CLI) -q -b do src/stata/reg_2sls_fe.do 
		mv reg_2sls_fe.log log/reg_2sls_fe.log.do
		$(call colorecho, "... julia ...")
		$(JULIA) src/julia/reg_2sls_fe_nonpatched.jl &> log/reg_2sls_fe_nonpatched.log.jl
		$(JULIA) src/julia/reg_2sls_fe_patched.jl &> log/reg_2sls_fe_patched.jl
		@echo


# --------------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------------
.PHONY : clean

clean:
		$(call colorecho, "Cleaning directory ...")
		rm -f log/*
		rm -f data/iv_interact_fe_test.dta
		@echo
# --------------------------------------------------------------------------------------------------------		