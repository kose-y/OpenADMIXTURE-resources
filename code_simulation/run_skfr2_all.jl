using StatsBase
using Statistics
using SnpArrays
using NaNMath
using Random
using Missings
using LinearAlgebra
using Clustering
using DelimitedFiles
using SKFR
function run_SKFR(data_path, clusters, sparsities)

    # Run SKFR
    classes = clusters

    X = SnpArray(data_path)
    #Xtrue = convert(Matrix{Float64}, X, model=ADDITIVE_MODEL, center=false, scale=false)
    rng = MersenneTwister(1696)
    ISM = SKFR.ImputedSnpMatrix{Float64}(X, classes; rng=rng)
    #Random.seed!(1696)
    # IM = SKFR.ImputedMatrix{Float64}(Xtrue, classes)

    @time (bestclusters, aims) = SKFR.sparsekmeans_path(ISM, sparsities; iter=10, ftn=SKFR.sparsekmeans2)
    return (bestclusters, aims)
end

function run_case(n, p, k, prefixn, prefixp)

    data_path = "n$(prefixn)_$(prefixp)_$(k)pops.bed"
    clusters = k

    sparsities = convert(Vector{Int}, [0.2, 0.175, 0.15, 0.125, 0.1, 0.075, 0.05, 0.025] .* p ./ k)
    

    (clusters, snps) = run_SKFR(data_path, clusters, sparsities);
    
    f = open("rslts/clusters_sim2_n$(prefixn)_$(prefixp)_$(k)pops_path", "w")
    writedlm(f, clusters)
    close(f)
#
    for (v, s) in zip(snps, sparsities)
        f = open("rslts/aims_sim2_n$(prefixn)_$(prefixp)_$(k)pops_path_$(s)", "w")
        writedlm(f, v)
        close(f)
        aims = sort(Int.(readdlm("rslts/aims_sim2_n$(prefixn)_$(prefixp)_$(k)pops_path_$(s)"))[:])
        SnpArrays.filter("n$(prefixn)_$(prefixp)_$(k)pops", trues(n), aims; des = "rslts/sim2_path_n$(prefixn)_$(prefixp)_$(k)pops_path_$(s)")
    end
end

configs = [(1000, 10000, 5, "1k", "10k"),
    (1000, 100000, 5, "1k", "100k"),
    (1000, 1000000, 5, "1k", "1m"),
    (10000, 10000, 5, "10k", "10k"),
    (10000, 100000, 5, "10k", "100k"),
(1000, 10000, 10, "1k", "10k"),
    (1000, 100000, 10, "1k", "100k"),
    (1000, 1000000, 10, "1k", "1m"),
    (10000, 10000, 10, "10k", "10k"),
    (10000, 100000, 10, "10k", "100k"),
]
for config in configs
    println(config)
    run_case(config...)
    println("done $config")
end
