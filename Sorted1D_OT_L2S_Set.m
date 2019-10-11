function [dd, id] = Sorted1D_OT_L2S_Set(XX_cell, ZZ_cell, bb_cell, ww_cell)

ddMM = zeros(length(XX_cell), length(ZZ_cell));

for ii = 1:length(XX_cell)
    for jj = 1:length(ZZ_cell)
        % compute ddMM(ii, jj)
        ddMM(ii, jj) = SortedOT_1D_L2S_Full(XX_cell{ii}, ZZ_cell{jj}, bb_cell{ii}, ww_cell{jj});
    end
end

[dd, id] = min(ddMM, [], 2);


end




