using DelimitedFiles
using SnpArrays
sp = parse(Int, ARGS[1])
mkpath("../rslts/HO")
aims = sort(Int.(readdlm("../rslts/HO/aims_ho_14pop_path_$(sp)"))[:])
s = SnpArray("../HO/ho_final.bed")
n, p = size(s)
SnpArrays.filter("../HO/ho_final", trues(n), aims; des = "../HO/HO_path_$(sp)")
