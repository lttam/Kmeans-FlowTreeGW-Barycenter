clear all
clc

kTimes = 1; % number of rations for each samples ---> on 60K: kTimes=1
idRUN = 1; % used to identify the ID of each run (with different initialization for Kmeans)

load(['MNIST' num2str(kTimes) 'x60K_clouds_preKmeans.mat']);

kk = 9;
maxIter = 20;

% % -- for kTimes = 2 ----------
% % % parameters for K-means
% % maxSupp_bc = 100;
% % maxIter_bc = 50;
% % tol_bc = 1e-6;
% % theta_bc = 0.1;
% % 
% % constMB_SIZE = 50;
% % % each cluster about 12K
% % optFS_bc.maxIter = 500;
% % optFS_bc.mb_size = constMB_SIZE;
% % optFS_bc.step_size = 0.05;
% % optFS_bc.tol = 1e-6;

% max supports in barycenter
% parameters for K-means
allOpt.maxSupp_bc = 100;
allOpt.maxIter_bc = 50;
allOpt.tol_bc = 1e-6;
allOpt.theta_bc = 0.1;

allOpt.constMB_SIZE = 50;
% each cluster about 12K
allOpt.optFS_bc.maxIter = 250*kTimes;
allOpt.optFS_bc.mb_size = allOpt.constMB_SIZE;
allOpt.optFS_bc.step_size = 0.05;
allOpt.optFS_bc.tol = 1e-6;

tic
[YYpre, center_XX, center_aa] = Kmeans_SortedOT_1D(XX_DD_cell, bb_cell, kk, maxIter, allOpt);
runTime_Kmeans = toc;

% evaluation --> later
save(['MNIST' num2str(kTimes) 'x60K_clouds_Kmeans9_ID' num2str(idRUN) '.mat'], 'center_XX', 'center_aa', 'YYpre', 'runTime_Kmeans');

disp('FINISH !!!');



