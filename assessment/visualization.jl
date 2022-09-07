# This file contains a visualization example of the HO dataset.
using DelimitedFiles
using CSV
using DataFrames
using Statistics
using Clustering, Distances
include("soft_clustering.jl")

# get dictionary mapping sample ID to population
ENV["COLUMNS"] = 1200
df = CSV.read("../HO/data.ind", DataFrame; stripwhitespace=true, header=false)
id = []
sex = []
pop = []
for r in eachrow(df)
    _id, _sex, _pop = split(r.Column1)
    push!(id, _id)
    push!(sex, _sex)
    push!(pop, _pop)
end

df.id = id
df.sex = sex
df.pop = pop

sampleID_to_population = Dict{String, String}()
for r in eachrow(df)
    id = r.id
    population = r.pop
    sampleID_to_population[id] = population
end

fam = CSV.read("../HO/ho_final.fam", DataFrame; header=false)
rename!(fam, ["IID", "FID", "c3", "c4", "c5", "c6"])
fam_cut = copy(fam)
filter!(x -> x.FID in keys(sampleID_to_population), fam_cut)

fam_cut.pop = map(x -> sampleID_to_population[x.FID], eachrow(fam_cut))

q_base = readdlm("../rslts/HO/HO.Q.14.csv", ',')
q_skfr = readdlm("../rslts/HO/HO_100000.Q.14.csv", ',');
qscope = transpose(readdlm("../rslts/HO/scope_HO_14_Qhat.txt"));


q_df = DataFrame(q_base, :auto)
q_df.IID = fam.IID
q_df.FID = fam.FID
q_df.idx = 1:size(q_df, 1)

dat = innerjoin(fam_cut, q_df; on=:FID, makeunique=true)


d = Dict()

gdf = groupby(dat, :pop)
combined_mean = combine(gdf, :x1 => mean, :x2 => mean, :x3 => mean, :x4 => mean, 
       :x5 => mean, :x6 => mean, :x7 => mean ,:x8 => mean, :x9 => mean, :x10 => mean, :x11=>mean, :x12=>mean, :x13=>mean, :x14=>mean)

m = Matrix(combined_mean[!, 2:end])
superpops = combined_mean[!, 1]
d = pairwise(Euclidean(), m, dims=1)
hclust_superpop = hclust(d; linkage=:complete)

hclust_sample = Dict()
sample_dict = Dict()
for p in unique(dat.pop)
    dat_tmp = copy(dat)
    filter!(x -> x.pop == p, dat_tmp)
    sample_dict[p] = dat_tmp.idx
    m = Matrix(dat_tmp[!, 8:20])
    d = pairwise(Euclidean(), m, dims=1)
    hclust_sample[p] = hclust(d; linkage=:complete)
end

orderlist = Int[]
superpoplist = String[]
poplist = String[]
for spid in 1:length(superpops)
    sp = superpops[hclust_superpop.order[spid]]
    println(sp)
    for sid in 1:length(sample_dict[sp])
        push!(orderlist, sample_dict[sp][hclust_sample[sp].order[sid]])
        push!(superpoplist, sp)

    end
end
ordering = DataFrame(sampleidx = orderlist, superpop = superpoplist)


using StatsPlots
q_base_reordered = q_base[ordering[!, :sampleidx], :]
q_skfr_reordered = permute_q2(q_base_reordered, q_skfr[ordering[!, :sampleidx], :])
qscope_reordered = permute_q2(q_base_reordered, qscope[ordering[!, :sampleidx], :])

plt_a = groupedbar(q_base_reordered, linecolor=nothing, 
        bar_position = :stack, size=(1000, 150), dpi=300, legend=false, title = "(a) OpenADMIXTURE: All SNPs", 
    xlims=(0, 1931), ylims=(0, 1), gridlinewidth=0, xticks=[])


plt_b = groupedbar(q7_reordered, linecolor=nothing, 
        bar_position = :stack, size=(1000, 150), dpi=300, legend=false, title = "(b) OpenADMIXTURE: 100,000 SNPs",
        xlims=(0, 1931), ylims=(0, 1), gridlinewidth=0, xticks=[])

plt_c = groupedbar(qscope_reordered, linecolor=nothing, 
        bar_position = :stack, size=(1000, 150), dpi=300, legend=false, title = "(c) SCOPE",
        xlims=(0, 1931), ylims=(0, 1), gridlinewidth=0, xticks=[])

plt_all = plot(plt_a, plt_b, plt_c, layout = grid(3, 1, heights=[0.3/.9 ,0.3/.9, 0.3/.9]), size=(1000, 530 * 0.9))
savefig(plt_all, "HO_overall.pdf")