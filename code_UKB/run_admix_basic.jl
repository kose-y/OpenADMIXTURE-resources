using LinearAlgebra, LoopVectorization, Test, Random, SnpArrays
using OpenADMIXTURE
using CUDA, CSV, DelimitedFiles

CUDA.allowscalar(true)
filename = "../UKB/ukb15_genotype_80000.bed"
Random.seed!(4567)
d, _, _ = OpenADMIXTURE.run_admixture(filename, 15; use_gpu=true, T=Float32)
writedlm( "../rslts/UKB_sp_80000.Q.15.csv",  transpose(d.q), ',') 
writedlm( "../rslts/UKB_sp_80000.P.15.csv",  transpose(d.p), ',')
