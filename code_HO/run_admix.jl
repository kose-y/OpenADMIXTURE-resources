using LinearAlgebra, Random, SnpArrays
using OpenADMIXTURE
using CUDA, CSV, DelimitedFiles

CUDA.allowscalar(true)
sp = parse(Int, ARGS[1])
filename = "../HO/HO_path_$(sp).bed"
Random.seed!(7856)
d, _, _ = OpenADMIXTURE.run_admixture(filename, 14; use_gpu=true, T=Float32)
mkpath("../rslts/HO")
writedlm( "../rslts/HO/HO_$(sp).Q.14.csv",  transpose(d.q), ',')
writedlm( "../rslts/HO/HO_$(sp).P.14.csv",  transpose(d.f), ',')
