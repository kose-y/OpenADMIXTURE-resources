# OpenADMIXTURE-resources

This repository contains information for reproducing experiments in the OpenADMIXTURE manuscript:

_Ko S, Chu BB, Peterson D, Okenwa C, Papp JC, Alexander DH, Sobel EM, Zhou H, and Lange KL. Unsupervised Discovery of Ancestry Informative Markers and Genetic Admixture Proportions in Biobank-Scale Data Sets. The American Journal of Human Genetics, in revision._

To download the 1000 Genomes Project (TGP), Human Genome Diversity Project (HGDP), and Human Origins (HO) public data sets, follow the steps in https://github.com/sriramlab/SCOPE/tree/master/misc/real_data.  

The directory `environments` defines Julia package environment for the experiments. To install all the packages, 
- launch Julia with `--project=<path-to-this directory>/environments/v1.7` or activate the environment with `using Pkg; Pkg.activate(normpath("<path-to-this directory>/environments/v1.7"))`,
- then run `using Pkg; Pkg.instantiate()`. 
