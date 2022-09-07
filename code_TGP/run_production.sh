time julia -t 16 run_skfr_path_tgp.jl

time julia filter.jl 5000
time julia filter.jl 10000
time julia filter.jl 20000
time julia filter.jl 40000
time julia filter.jl 60000
time julia filter.jl 80000
time julia filter.jl 100000

time julia run_admix.jl 5000
time julia run_admix.jl 10000
time julia run_admix.jl 20000
time julia run_admix.jl 40000
time julia run_admix.jl 60000
time julia run_admix.jl 80000
time julia run_admix.jl 100000


