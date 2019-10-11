function [id_XX, center_XX, center_aa] = Kmeans_SortedOT_1D(XX_cell, bb_cell, kk, maxIter, allOpt)

% For stability, supports XX_cell should be  

% INPUT:
% XX_cell: sorted supports
% bb_cell: corresponding simplex weights
% kk: number of clustering
% maxIter: maximum iterations in Kmeans

% % % max supports in barycenter
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
maxSupp_bc = allOpt.maxSupp_bc;
maxIter_bc = allOpt.maxIter_bc;
tol_bc = allOpt.tol_bc;
theta_bc = allOpt.theta_bc;

constMB_SIZE = allOpt.constMB_SIZE;
% each cluster about 12K
optFS_bc.maxIter = allOpt.optFS_bc.maxIter;
optFS_bc.mb_size = allOpt.optFS_bc.mb_size;
optFS_bc.step_size = allOpt.optFS_bc.step_size;
optFS_bc.tol = allOpt.optFS_bc.tol;

% % kk = 10;
% % maxIter = 100;
% % tol = 1e-6;
% % theta = 0.1; 
% % optFS.maxIter = 500;
% % optFS.tol = 1e-6;
% % optFS.step_size = 0.05;
% % optFS.mb_size = min(50, length(YY_cell));

% INITIALIZATION kmeans++
center_XX = cell(kk, 1);
center_aa = cell(kk, 1);

disp('... Initialization with Kmeans++');

% Kmeans++ initialization 
% FOR THE CENTERS
idRR = round(rand()*length(XX_cell));

disp('... init for barycenters');
center_XX{1} = XX_cell{idRR};
center_aa{1} = bb_cell{idRR};
disp(['... run ID#1']);
for ii = 2:kk
    disp(['... run ID#' num2str(ii)]);
    ZZ_cell = center_XX(1:(ii-1));
    ww_cell = center_aa(1:(ii-1));
    
    % using squared L2 ground matrix for OT_1D
    dd = Sorted1D_OT_L2S_Set(XX_cell, ZZ_cell, bb_cell, ww_cell);
    
    % random weighted sampling
    next_id = randsample(1:length(XX_cell), 1, true, dd);
    
    center_XX{ii} = XX_cell{next_id};
    center_aa{ii} = bb_cell{next_id};
end

disp('... init for assignment');
% FOR THE ASSIGNMENTS
[~, id_XX] = Sorted1D_OT_L2S_Set(XX_cell, center_XX, bb_cell, center_aa);

iIter = 1;
while iIter <= maxIter

    disp(['......Iteration in Kmean: ' num2str(iIter)]);
    % compute new barycenters
    for ii = 1:kk
        % extract samples in cluster_ii
        XX_II_cell = XX_cell(id_XX == ii);
        bb_II_cell = bb_cell(id_XX == ii);
        
        disp(['.........Compute barycenter #' num2str(ii) ' of iteration #' num2str(iIter)]);
        % compute barycenter
        optFS_bc.mb_size = min(constMB_SIZE, length(XX_II_cell));
        [center_XX{ii}, center_aa{ii}] = SortedOT_1D_Barycenter_FreeSupport(maxSupp_bc, XX_II_cell, bb_II_cell, maxIter_bc, tol_bc, theta_bc, optFS_bc); 
    
    end
    
    disp(['......... Compute assignment of iteration #' num2str(iIter)]);
    % compute new assignments
    [~, id_XX] = Sorted1D_OT_L2S_Set(XX_cell, center_XX, bb_cell, center_aa);
    
    iIter = iIter + 1;
end

end






