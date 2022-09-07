using DelimitedFiles
using SnpArrays
aims = sort(Int.(readdlm("../rslts/aims_15pop_UKB_80000"))[:])
s = SnpArray("../UKB/ukb_genotype_v2_merged.filtered.bed")
n, p = size(s)
SnpArrays.filter("../UKB/ukb_genotype_v2_merged.filtered", trues(n), aims; des = "../UKB/ukb15_genotype_80000")
