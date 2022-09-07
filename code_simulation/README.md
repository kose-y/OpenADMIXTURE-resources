# code_simulation

This directory contains code for simulating genotypes and running admixture analyses. 

- `generate_sets.sh` generates simulated data sets.
- `run_skfr_all.jl` runs SKFR1 algorithm on the data sets.
- `run_skfr2_all.jl` runs SKFR2 on the data sets.
- `run_admix.jl` runs admixture on the SKFR1-filtered data sets.
- `run_admix_2.jl` runs admixture on the SKFR2-filtered data sets.

- `simulateA.py` and `generate_plink_frq.py` are based on the code at https://github.com/sriramlab/SCOPE/tree/master/misc/simulations. These two code files requires [pyplink](https://pypi.org/project/pyplink/) and [parmapper](https://github.com/Jwink3101/parmapper) packages, and are originally distributed under the MIT License:

MIT License

Copyright (c) 2021 Alec Chiu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
