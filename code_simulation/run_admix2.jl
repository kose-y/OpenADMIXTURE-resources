using OpenADMIXTURE, CUDA, Random, DelimitedFiles
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
function run_admixtures(n, p, k, prefixn, prefixp)
    clusters = k
    Random.seed!(7857)

    sparsities = convert(Vector{Int}, [0.2, 0.175, 0.15, 0.125, 0.1, 0.075, 0.05, 0.025] .* p ./ k)
    for s in sparsities
        filename = "rslts/sim2_path_n$(prefixn)_$(prefixp)_$(k)pops_path_$(s).bed"
        println(filename)
        d, _, _ = OpenADMIXTURE.run_admixture(filename, k; T=Float64, use_gpu=true)
        writedlm( "rslts/sim2_n$(prefixn)_$(prefixp)_$(k)pops_path_$(s)_sp.Q.csv",  transpose(d.q), ',')
        #writedlm( "rslts/sim2_n$(prefixn)_$(prefixp)_$(k)pops_path_$(s)_sp.P.csv",  transpose(d.p), ',')
    end
    filename = "n$(prefixn)_$(prefixp)_$(k)pops.bed"
    println(filename)
    d, _, _ = OpenADMIXTURE.run_admixture(filename, k; T=Float64, use_gpu=true)
    writedlm( "rslts/sim2_n$(prefixn)_$(prefixp)_$(k)pops_full.Q.csv",  transpose(d.q), ',')
    #writedlm( "rslts/sim2_n$(prefixn)_$(prefixp)_$(k)pops_full.P.csv",  transpose(d.p), ',')
end

for config in configs
    println(config)
    run_admixtures(config...)
    println("done $config")
end
