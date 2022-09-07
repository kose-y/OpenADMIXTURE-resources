using LinearAlgebra, Random, SnpArrays
using OpenADMIXTURE
using CUDA, CSV, DelimitedFiles

CUDA.allowscalar(true)
filename = "../HGDP/HGDP_940.bed"
Random.seed!(7856)
d, _, _ = OpenADMIXTURE.run_admixture(filename, 14; T=Float32, use_gpu=true)
mkpath("../rslts/HO")
writedlm( "../rslts/HO/HO.Q.14.csv",  transpose(d.q), ',')
writedlm( "../rslts/HO/HO.P.14.csv",  transpose(d.f), ',')
