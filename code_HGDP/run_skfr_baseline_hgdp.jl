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

data_path = "../HGDP/HGDP_940.bed"
clusters = 10
snparr = SnpArray(data_path)
sparsities = [size(snparr, 2)]

(clusters, snps) = run_SKFR(data_path, clusters, sparsities);
using DelimitedFiles
mkpath("../rslts/HGDP")
f = open("../rslts/HGDP/clusters_hgdp_10pop_baseline", "w")
writedlm(f, clusters)
close(f)
