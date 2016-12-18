demo1.m -> demonstrates how to split your data into halves to evaluate how well the obtained CCAs are
This file is useful to decide how many PCA components and how many CCA components to include in the M-CCA procedure (as illustrated in Figure 1 in the paper).

demo2.m -> demonstrates how to split your data into halves to evaluate how well the obtained CCAs are when regularization is added
This file is only useful if one considers to add regularization to M-CCA.

demo3.m -> uses CCA weights caculated from averaged data to obtain single-trial CCAs
This file is for transferring single-trial data from sensor space to CCA space, once one already knows the parameters to use in M-CCA from demo1.m and demo2.m

Before running the demos, make sure to add all folder to the path 