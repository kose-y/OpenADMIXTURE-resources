using LinearAlgebra, Random, SnpArrays, LoopVectorization
using OpenADMIXTURE
using CUDA, CSV, DelimitedFiles

CUDA.allowscalar(true)
sp = parse(Int, ARGS[1])
filename = "../TGP/TGP_path_$(sp).bed"
Random.seed!(7856)
d, _, _ = OpenADMIXTURE.run_admixture(filename, 8; T=Float64, use_gpu=true)
writedlm( "TGP_$(sp)_sp.Q.8.csv",  transpose(d.q), ',')
writedlm( "TGP_$(sp)_sp.P.8.csv",  transpose(d.f), ',')
