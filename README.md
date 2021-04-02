# Collection of code


1. Fixed effects in a two-stage least square regression (see issues [here](https://github.com/sergiocorreia/ivreghdfe/issues/25) and [here](https://github.com/sergiocorreia/reghdfe/issues/226)): 
   + run `make iv_interact_fe_issue1` to run the stata code, and both julia version patched and non patched
   + files are `reg_2sls_fe.do`, `reg_2sls_fe_nonpatched.jl`, and `reg_2sls_fe_patched.jl`
   + run `make iv_interact_fe_issue2` to generate data in julia and run the stata code
   + files are `reg_2sls_fe_issue2.do`, `reg_2sls_fe_issue2.jl`
   + [related note](http://loualiche.gitlab.io/www/other/kleibergen-paap.html)
