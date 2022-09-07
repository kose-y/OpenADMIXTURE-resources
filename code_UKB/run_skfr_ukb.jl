using CSV, DataFrames, SnpArrays, SKFR

function run_SKFR(data_path, clusters, sparsity)

    # Run SKFR
    classes = clusters

    clusters_output = []
    centers_output = []
    informative_SNPs = []
    i = 0
    @time X = SnpArray(data_path)
        @time ISM = SKFR.ImputedSnpMatrix{Float64}(X, classes)
        #Random.seed!(1696)
        @time clusters, centers, selectedvec, WSSval, TSSval = SKFR.sparsekmeans1(ISM, sparsity;squares=false)
    return clusters, centers, selectedvec
end

data_path = "../UKB/ukb_genotype_v2_merged.filtered.bed"
clusters = 15

s = 80000
clusters, centers, selectedvec = run_SKFR(data_path, clusters, s);
mkpath("../rslts/UKB")
f = open("../rslts/UKB/clusters_15pop_UKB_$(s)", "w")
for v in clusters
    println(f, v)
end
close(f)

f = open("../rslts/UKB/aims_15pop_UKB_$(s)", "w")
for v in selectedvec
    println(f, v)
end
close(f)
