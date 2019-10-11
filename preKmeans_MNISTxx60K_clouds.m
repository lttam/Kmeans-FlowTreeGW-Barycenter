clear all
clc

kTimes = 1;

load(['MNIST' num2str(kTimes) 'x60K_clouds.mat']);

TM_L = 6; %highest level
TM_KC = 4; %# of clusters

disp(['... Centered to origin']);
% Centered to the origin for XX
XX_center = cell(length(XX), 1);
bb_cell = cell(length(XX), 1);
for ii = 1:length(XX)
    XX_center{ii} = XX{ii} - mean(XX{ii});
    bb_cell{ii} = ones(size(XX{ii}, 1), 1)/size(XX{ii}, 1);
end


disp('... Build tree metric');
%%%%%%%%
tic
[TM, XX_VertexID] = BuildTreeMetric_HighDim_V2(XX_center, TM_L, TM_KC);
runTime_TM = toc;

disp('... Extract flow-based representation');
%%%%%%%%
maxDD = 0; % for normalization (distances from root to supports)
XX_DD_cell = cell(length(XX), 1);
tic
for ii = 1:length(XX)
    
    XXII = XX_VertexID{ii};
    XXII_DD = zeros(length(XXII), 1);
    for jj = 1:length(XXII_DD)
        % distance from root to each support
        XXII_DD(jj) = sum(TM.Edge_Weight(TM.Vertex_EdgeIdPath{XXII(jj)}));
    end
    sort_XXII_DD = sort(XXII_DD);
    
    XX_DD_cell{ii} = sort_XXII_DD;
    maxDD = max(maxDD, sort_XXII_DD(end));
    
end
runTime_DD = toc;

disp('... normalization');
% normalization for XX_DD_cell by maxDD
for ii =1:length(XX)
    % normalization
    XX_DD_cell{ii} = XX_DD_cell{ii} / maxDD;
end

% input for Kmeans
% XX_DD_cell
% bb_cell
% for checking results ===> YY
% save TM, maxDD --> for further information
% save space ---> ignore TM!!!

if kTimes <= 8
    save(['MNIST' num2str(kTimes) 'x60K_clouds_preKmeans.mat'], 'XX_DD_cell', 'bb_cell', 'maxDD', 'runTime_TM', 'runTime_DD');
else
    save(['MNIST' num2str(kTimes) 'x60K_clouds_preKmeans.mat'], 'XX_DD_cell', 'bb_cell', 'maxDD', 'runTime_TM', 'runTime_DD', '-v7.3');
end

disp('FINISH!');

