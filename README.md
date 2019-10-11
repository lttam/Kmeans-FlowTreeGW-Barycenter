# Kmeans-FlowTreeGW-Barycenter
Kmeans with flow-based tree Gromov-Wasserstein barycenters


%%%%%%%%%%%%%
% GUIDELINE %
%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tam Le
% RIKEN AIP
% tam.le@riken.jp
% October 11th, 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Illustration Kmeans clustering with FlowTreeGW barycneter
% on 60K MNIST samples rotated randomly


% -------------------------------------
% Step 1: run "preKmeans_MNISTxx60K_clouds.m"
% + Building tree metrics (same structure for each probability measures on
% different spaces
% + Having FlowTreeGW representation
% -------------------------------------
% Step 2: run "compute_Kmeans9_MNIST_xx60K_clouds.m"
% + compute Kmeans with FlowTreeGW barycenters
% -------------------------------------
% Step 3: run "evaluate_Kmeans9_MNIST_xx60K_clouds.m"
% + evaluate the performance of Kmeans clustering by F-beta measure
% -------------------------------------


% =====================================
% REFERENCE:
% Computationally Efficient Tree Variants of Gromov-Wasserstein
% ArXiv, 2019.
% Tam Le*, Nhat Ho*, Makoto Yamada
% (*: equal contribution)
% https://arxiv.org/pdf/1910.04462.pdf
% =====================================



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INFORMATION
% On Macbook Pro 2018 (laptop)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% STEP1:
% + run time (tree metric): 17s
% + run time (FlowTreeGW representation): 10s
% --> output file: MNIST1x60K_clouds_preKmeans.mat

% STEP2:
% + run time (Kmeans with FlowTreeGW barycenter): 409s (~7min)
% --> output file: MNIST1x60K_clouds_Kmeans9_ID1.mat
% (We can run STEP2 n times with different "IDxx" for different initialization for Kmeans)

% STEP3:
% + run time (for each result in Step2): 20s

% TOTAL: evaluation with N runs in step2 (with N different initialization
% for Kmeans)
% Step1: 27(s) ---> 0.5 (min)
% Step2: 410N(s) --> 7N (min)
% Step3: 20N(s) ---> 0.3N (min)
% ===> 7.3N + 0.5 (min)





