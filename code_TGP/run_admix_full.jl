using LinearAlgebra, Random, SnpArrays, LoopVectorization
using OpenADMIXTURE
using CUDA, CSV, DelimitedFiles

CUDA.allowscalar(true)
filename = "../TGP/TGP_1718.bed"
Random.seed!(7856)
d, _, _ = OpenADMIXTURE.run_admixture(filename, 8; T=Float32, use_gpu=true)
mkpath("../rslts/TGP")
writedlm( "../rslts/TGP/TGP_full.Q.8.csv",  transpose(d.q), ',')
writedlm( "../rslts/TGP/TGP_full.P.8.csv",  transpose(d.f), ',')
