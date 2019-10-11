function [fbeta, beta] = F_Beta_Measure(YY, YYpre)

% YY: truth
% YYpre: prediction

% measure
TP = 0;
% not need
% % TN = 0; 

FP = 0;
FN = 0;

% number of same/different-class pairs
DD = 0;
SS = 0;

NN = length(YY);
for ii = 1:NN

    if mod(ii, 5000) == 0
        disp(['......ID: ' num2str(ii)]);
    end
    % truth
    % ii vs (ii+1):end
    idSS = find(YY((ii+1):NN) == YY(ii));
    idDD = find(YY((ii+1):NN) ~= YY(ii));
    
    SS = SS + length(idSS);
    DD = DD + length(idDD);
    
    pair_pre = (YYpre((ii+1):NN)==YYpre(ii));
    pairSS_pre = pair_pre(idSS);
    pairDD_pre = pair_pre(idDD);
    
    sum_pairSS_pre = sum(pairSS_pre);
    TP = TP + sum_pairSS_pre;
    FN = FN + length(idSS) - sum_pairSS_pre;
    
    sum_pairDD_pre = sum(pairDD_pre);
    FP = FP + sum_pairDD_pre;
    % not need
% %     TN = TN + length(idDD) - sum_pairDD_pre;
    
end

P = TP / (TP + FP);
R = TP / (TP + FN);

beta = sqrt(DD/SS);
fbeta = (beta*beta+1)*P*R / (beta*beta*P + R);

end






