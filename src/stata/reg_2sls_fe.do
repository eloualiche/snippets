**************************************************************************
set seed 1118
clear all

**************************************************************************



**************************************************************************
******** GENERATE THE DATA
set obs 100
* Unit ids
gen unit_id=_n

* Make up first-stage coefficient that varies by state
gen FS_coef=runiformint(1,4)

* Assign states to groups that denote first-stage coefficient
gen group=FS_coef

* Turn into panel data
expand 100

* Generate underlying continuous exogenous instrument
gen Z_exog=round(360*uniform())
gen sine_Z_exog=sin(Z_exog*(_pi/180))

* Generate potentially endogenous (but not actually endogenous in this example) X variable
gen X=FS_coef*sine_Z_exog+3*rnormal()

* Discretize instrument
gen Z_range=1 if Z_exog<90
replace Z_range=2 if Z_exog>=90 & Z_exog<180
replace Z_range=3 if Z_exog>=180 & Z_exog<270
replace Z_range=4 if Z_exog>=270 & Z_exog<=360

* Generate outcome variable
gen Y=2*X+3*rnormal()
egen group_x_Z=group(group Z_range)
gen cons=1

forvalues g=1/4 {
  forvalues z=1/3 {
    gen group_`g'_`z'=(group==`g')*(Z_range==`z')
  }
}


save "./data/iv_interact_fe_test.dta", replace
**************************************************************************




**************************************************************************
******** RUN TESTS
* Tests begin here

* Preferred instrument: specify interactions between group variable and Z_range variable
* Use old version of reghdfe: WORKS
reghdfe Y (X = i.group#i.Z_range), absorb(unit_id) vce(robust) old

* New version of reghdfe: DOES NOT WORK
ivreghdfe Y (X = i.group#i.Z_range), absorb(unit_id) robust

***************************
* Attempted workaround one: 
* turn into single indicator instead of interactions
* egen group_x_Z=group(group Z_range)

* Background regression: four group indicators should get dropped in first stage
* (group 1 automatically omitted, three more omitted due to collinearity)
areg X i.group_x_Z, absorb(unit_id) robust

* Use old version of reghdfe: WORKS
reghdfe Y (X = i.group_x_Z), absorb(unit_id) vce(robust) old

* New version of reghdfe: DOES NOT WORK 
ivreghdfe Y (X = i.group_x_Z), absorb(unit_id) robust

* Hypothesis: problem arises when there is additional collinearity with the absorbed fixed effects
* Test: omit unit_id fixed effects (collinear with group indicators) --> new ivreghdfe works
* gen cons=1
ivreghdfe Y (X = i.group_x_Z), absorb(cons) robust

***************************
* Attempted workaround 2: 
* generate instruments manually to avoid additional collinearity.



* This workaround works
ivreghdfe Y (X = group_1* group_2* group_3* group_4*), absorb(unit_id) robust

* Hypothesis: this is also a problem with ivreg2.
* Doesn't appear to be the case. ivreg2 works
ivreg2 Y i.unit_id (X = i.group#i.Z_range), robust
**************************************************************************


