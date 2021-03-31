# -----------------------------------------------------------------------------
#
#
#
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
import Pkg;
Pkg.add(name="Vcov", version="0.4.2", preserve=Pkg.PRESERVE_ALL); # this new version has the fix
Pkg.add(name="FixedEffectModels", version="1.4.2", preserve=Pkg.PRESERVE_ALL); # this new version has the fix
Pkg.add.(["FileIO", "DataFrames", "PairsMacros", "Dates"])

using FileIO, DataFrames, PairsMacros, Dates
using FixedEffectModels
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# --- load the data and clean it up to adapt it for julia
df_reg = load("data/iv_interact_fe_test.dta") |> DataFrame;
transform!(df_reg, [:group, :Z_range, :group_x_Z] .=> ByRow(x->Int(x)) .=> [:group, :Z_range, :group_x_Z]);
for i in 1:4, j in 1:3
  u = Symbol("group_" * string(i) * "_" * string(j));
  transform!(df_reg, @cols($u = Int.($u) ));
  categorical!(df_reg, u);
end
categorical!(df_reg, :group);
categorical!(df_reg, :Z_range);
categorical!(df_reg, :group_x_Z);
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# julia code works but F-stat is not inline with old version of reghdfe
try
   eval(Meta.parse("reg(df_reg, @formula(Y ~ fe(unit_id) + (X ~ group&Z_range)), Vcov.robust())"))
catch e
   @error "Something went wrong" exception=(e, catch_backtrace())
end

try
   eval(Meta.parse("reg(df_reg, @formula(Y ~ fe(unit_id) + (X ~ group_x_Z)), Vcov.robust())"))
catch e
   @error "Something went wrong" exception=(e, catch_backtrace())
end
# -----------------------------------------------------------------------------




