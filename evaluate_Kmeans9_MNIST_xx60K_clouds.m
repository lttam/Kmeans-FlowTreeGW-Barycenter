clear all
clc

NN = 1; % number of runing times (in Step 2) for different number of initilaizations
idRUN_array = 1:NN;

beta_array = ones(NN, 1);
fbeta_array = ones(NN, 1);
runTime_Kmeans_array = zeros(NN, 1);

kTimes = 1;

load(['MNIST' num2str(kTimes) 'x60K_clouds.mat']);
% XX, YY
YY(YY==9)=6; % merge digit 6 and digit 9 due to random rotation
clear('XX');

tic
for rr=idRUN_array

    disp(['... RunID: #' num2str(rr)]);
    % load YYpre
    load(['MNIST' num2str(kTimes) 'x60K_clouds_Kmeans9_ID' num2str(rr) '.mat']);
    runTime_Kmeans_array(rr) = runTime_Kmeans;
    [fbeta_array(rr), beta_array(rr)] = F_Beta_Measure(YY, YYpre);
    
end
runTime_evaluate = toc

mean_fbeta = mean(fbeta_array);
std_fbeta = std(fbeta_array);
mean_runTime_Kmeans = mean(runTime_Kmeans_array);

save(['MNIST' num2str(kTimes) 'x60K_clouds_G69_Results' num2str(NN) '.mat'], ...
        'beta_array', 'fbeta_array', 'idRUN_array', ...
        'mean_fbeta', 'std_fbeta', ...
        'runTime_Kmeans_array', 'mean_runTime_Kmeans');

disp('FINISH !');


