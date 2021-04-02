**************************************************************************
clear all
**************************************************************************


**************************************************************************
import delimited "data/reg_sls_fe_issue.csv", clear

ivreghdfe y (x1 x2 = z1 z2), absorb(id) robust
ivreghdfe y (x1 x2 = z1eps z2eps), absorb(id) robust

ivreg2 y (x1 x2 = z1 z2) id, robust
ivreg2 y (x1 x2 = z1eps z2eps) id, robust
**************************************************************************



