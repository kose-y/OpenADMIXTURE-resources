using LinearAlgebra, Random, SnpArrays
using OpenADMIXTURE
using CUDA, CSV, DelimitedFiles
CUDA.allowscalar(true)
filename = "../HGDP/HGDP_940.bed"
Random.seed!(7856)
d, _, _ = OpenADMIXTURE.run_admixture(filename, 10; T=Float32, use_gpu=true)
mkpath("../rslts/HGDP")
writedlm( "../rslts/HGDP/HGDP.Q.10.csv",  transpose(d.q), ',')
writedlm( "../rslts/HGDP/HGDP.P.10.csv",  transpose(d.f), ',')
