# -----------------------------------------------------------------------------
#
#
#
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
using DataFrames, CSV, Random
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# --- load the data and clean it up to adapt it for julia
function gen_df(ϵ; seed::Int=107, N_rows=10)
  Random.seed!(seed)
  N_id   = 2;
  i = 1
  df_example = DataFrame()
  for i in 1:N_id
    obs = 1:N_rows
    id = i .* Int.(ones(N_rows))
    Z = rand(N_rows)
    X = Z + 0.5 .* rand(N_rows)
    Y = 3 .* Z + 0.3 .* rand(N_rows)
    df_tmp = DataFrame(obs=obs, id = id, Z = Z, X = X, Y = Y)
    df_example = vcat(df_example, df_tmp)
  end  

  df_example1 = unstack(select(df_example, :obs, :id, :X), [:obs, :id, :X], :id, :X, renamecols=x->Symbol(:X, Int(x)))
  df_example2 = unstack(select(df_example, :obs, :id, :Z), [:obs, :id, :Z], :id, :Z, renamecols=x->Symbol(:Z, Int(x)))

  df_example = innerjoin(df_example, select(df_example1, :obs, :id, :X1, :X2), on = [:obs, :id])
  df_example = innerjoin(df_example, select(df_example2, :obs, :id, :Z1, :Z2), on = [:obs, :id])

  df_example[ ismissing.(df_example.X1), :X1] .= 0.0;
  df_example[ ismissing.(df_example.X2), :X2] .= 0.0;
  df_example[ ismissing.(df_example.Z1), :Z1] .= 0.0;
  df_example[ ismissing.(df_example.Z2), :Z2] .= 0.0;

  transform!(df_example, :id => categorical => :id)
  transform!(df_example, :Z1 => (x-> x .+ ϵ .* rand(N_id*N_rows)) => :Z1eps)
  transform!(df_example, :Z2 => (x-> x .+ ϵ .* rand(N_id*N_rows)) => :Z2eps)

  return(df_example)

end;

df_example = gen_df(0.01, seed=107, N_rows=10)
CSV.write("./data/reg_sls_fe_issue.csv", df_example)
# -----------------------------------------------------------------------------
