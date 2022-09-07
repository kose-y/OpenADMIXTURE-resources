using DelimitedFiles
using SnpArrays
sp = parse(Int, ARGS[1])
aims = sort(Int.(readdlm("../rslts/TGP/aims_tgp_noAMR_8pop_path_$(sp)"))[:])
s = SnpArray("../TGP/TGP_1718.bed")
n, p = size(s)
SnpArrays.filter("../TGP/TGP_1718", trues(n), aims; des = "../TGP/TGP_noAMR_path_$(sp)")
