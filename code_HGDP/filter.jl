using DelimitedFiles
using SnpArrays
sp = parse(Int, ARGS[1])
aims = sort(Int.(readdlm("../rslts/HGDP/aims_hgdp_10pop_path_$(sp)"))[:])
s = SnpArray("../HGDP/HGDP_940.bed")
n, p = size(s)
SnpArrays.filter("../HGDP/HGDP_940", trues(n), aims; des = "../HGDP/HGDP_path_$(sp)")
