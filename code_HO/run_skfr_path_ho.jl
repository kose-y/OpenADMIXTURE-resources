using SKFR
using Test
using StatsBase
using Statistics
using SnpArrays
using NaNMath
using Random
using Missings
using LinearAlgebra
using Clustering
using DelimitedFiles
function run_SKFR(data_path, clusters, sparsities)

    # Run SKFR
    classes = clusters

    X = SnpArray(data_path)
    rng = MersenneTwister(1696)
    ISM = SKFR.ImputedSnpMatrix{Float64}(X, classes; rng=rng)


    @time (bestclusters, aims) = SKFR.sparsekmeans_path(ISM, sparsities; iter=10)
    return (bestclusters, aims)
end

data_path = "../HO/ho_final.bed"
clusters = 14

sparsities = [100000, 80000, 60000, 40000, 20000, 10000, 5000]

(clusters, snps) = run_SKFR(data_path, clusters, sparsities);
using DelimitedFiles
f = open("../rslts/HO/clusters_ho_14pop_path_100000", "w")
writedlm(f, clusters)
close(f)

for (v, s) in zip(snps, sparsities)
    f = open("../rslts/HO/aims_ho_14pop_path_$(s)", "w")
    writedlm(f, v)
    close(f)
end
