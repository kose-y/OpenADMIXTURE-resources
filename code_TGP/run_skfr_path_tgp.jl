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
        #Xtrue = convert(Matrix{Float64}, X, model=ADDITIVE_MODEL, center=false, scale=false)
        rng = MersenneTwister(1696)
        ISM = SKFR.ImputedSnpMatrix{Float64}(X, classes; rng=rng)
        #Random.seed!(1696)
        # IM = SKFR.ImputedMatrix{Float64}(Xtrue, classes)

        @time (bestclusters, aims) = SKFR.sparsekmeans_path(ISM, sparsities; iter=10)
    return (bestclusters, aims)
end

data_path = "../TGP/TGP_1718.bed"
clusters = 8

sparsities = [100000, 80000, 60000, 40000, 20000, 10000, 5000]
#s = ARGS[1]
#sparsities = 50_000:-1000:1000
(clusters, snps) = run_SKFR(data_path, clusters, sparsities);
using DelimitedFiles
mkpath("../rslts/TGP")
f = open("../rslts/TGP/clusters_tgp_8pop_path_100000", "w")
writedlm(f, clusters)
close(f)
#
for (v, s) in zip(snps, sparsities)
    f = open("../rslts/TGP/aims_tgp_8pop_path_$(s)", "w")
    writedlm(f, v)
    close(f)
end
