using LinearAlgebra, Random, SnpArrays
using OpenADMIXTURE
using CUDA, CSV, DelimitedFiles

CUDA.allowscalar(true)
filename = "../HGDP/HGDP_940.bed"
Random.seed!(7856)
d, _, _ = OpenADMIXTURE.run_admixture(filename, 14; T=Float32, use_gpu=true)
writedlm( "HO.Q.14.csv",  transpose(d.q), ',')
writedlm( "HO.P.14.csv",  transpose(d.f), ',')
