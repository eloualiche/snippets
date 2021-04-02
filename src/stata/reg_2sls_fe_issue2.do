**************************************************************************
clear all
**************************************************************************


**************************************************************************
* FIRST EXAMPLE WITH DATA GENERATED IN reg_2sls_fe_issue2.jl
import delimited "data/reg_sls_fe_issue.csv", clear

* This outputs an error 
ivreghdfe y (x1 x2 = z1 z2), absorb(id) robust
ivreg2 y (x1 x2 = z1 z2) id, robust

* add some noise to the instruments and the F-stats are correct
* Refer to the notebook to see how this approximates the correct F
ivreghdfe y (x1 x2 = z1eps z2eps), absorb(id) robust
ivreg2 y (x1 x2 = z1eps z2eps) id, robust
**************************************************************************


**************************************************************************
* OTHER EXAMPLE
sysuse auto, clear
* the issue can occur when you do IV by group (i.e. both first and second stage have group-specific coefficients)

* Say you regress price on mpg instrumented by displacement:
ivreg2 price  (mpg = displacement), robust
* ---> that works

* You can do it separately for foreign and domestic cars:
ivreg2 price  (mpg = displacement) if foreign == 0 , robust
ivreg2 price  (mpg = displacement) if foreign == 1 , robust
* ---> that still works

* Instead of doing two separate regressions, you can just pool and estimate by groups:
ivreg2 price i.foreign (i.foreign#c.mpg = i.foreign#c.displacement) , robust
ivreghdfe price i.foreign (i.foreign#c.mpg = i.foreign#c.displacement) , robust
* ---> the regression gives the exact same coefficients as the separate specification
* ---> However the KP statistic raise some error 
* "warning: -ranktest- error in calculating weak identification test statistics; may be caused by collinearities"
* even though there are no problems of collinearities in this regression and there should be a non degenerate F-stat
**************************************************************************





