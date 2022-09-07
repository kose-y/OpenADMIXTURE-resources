using LinearAlgebra, Random, SnpArrays
using OpenADMIXTURE
using CUDA, CSV, DelimitedFiles

CUDA.allowscalar(true)
sp = parse(Int, ARGS[1])
filename = "../HGDP/HGDP_path_$(sp).bed"
Random.seed!(7856)
d, _, _ = OpenADMIXTURE.run_admixture(filename,  10; T=Float32, use_gpu=true)
writedlm( "HGDP_$(sp).Q.10.csv",  transpose(d.q), ',')
writedlm( "HGDP_$(sp).P.10.csv",  transpose(d.f), ',')
