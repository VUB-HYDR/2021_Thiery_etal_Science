

% --------------------------------------------------------------------
% function to compute multi-model mean across ISIMIP simulations
% --------------------------------------------------------------------


function [exposure_mmm, exposure_mms, EMF_mmm, EMF_q25, EMF_q75, exposure_q25, exposure_q75, EMF_mmm_harmmean, EMF_mmm_geomexp] = mf_exposure_mmm(extremes, isimip, ind_rcp, ages, age_ref, exposure, exposure_pic_mean, RCP2GMT_maxdiff, RCP2GMT_maxdiff_threshold)



% --------------------------------------------------------------------
% Initialisation
% --------------------------------------------------------------------


% % % test RCP2GMT_maxdiff_threshold
% % figure;
% % for i=1:nruns
% %    plot(isimip(i).GMT); hold on;
% %    AAC(i)=max(diff(isimip(i).GMT))
% % end



% --------------------------------------------------------------------
% Manipulations
% --------------------------------------------------------------------


% get number of extremes and birth years
nextremes   = size(extremes,2);
nbirthyears = length(ages);


% set all runs with maximum GMT differences above threshold to NaN
% This is necessary to avoid that GMT scenarios with high warming levels use low-warming ISIMIP data
if ~isempty(RCP2GMT_maxdiff)
    exposure(RCP2GMT_maxdiff > RCP2GMT_maxdiff_threshold, :, :) = NaN;
end


% loop over extremes
for i=1:nextremes    
    
    % get indices corresponding to extremes
    ind_extremes(:,i) = ismember({isimip.extreme}, extremes{i})'; %#ok<*AGROW>

    
    % compute multi-model mean (mmm) per extreme impact category
    exposure_mmm(i,:,:) = nanmean(exposure(ind_rcp & ind_extremes(:,i), :, :), 1);


    % compute multi-model standard deviation (mms) per extreme impact category
    exposure_mms(i,:,:) = nanstd(exposure(ind_rcp & ind_extremes(:,i), :, :), 1);

    
    % compute multi-model IQR (q25 and q75) per extreme impact category
    exposure_q25(i,:,:) = quantile(exposure(ind_rcp & ind_extremes(:,i), :, :), 0.25, 1);
    exposure_q75(i,:,:) = quantile(exposure(ind_rcp & ind_extremes(:,i), :, :), 0.75, 1);

    
end


% compute geometric mean across extreme impact categories - used for main analysis
exposure_mmm(nextremes + 1,:,:) = geomean(exposure_mmm(1:nextremes,:,:), 1, 'omitnan'); % new approach: geometric mean


% compute sum across extreme impact categories - only used for sensitivity plots in SI
% exposure_mms(nextremes + 1,:,:) = nansum(exposure_mmm(1:nextremes,:,:), 1); % original approach: sum extremes


% % compute sum across extreme impact categories - std
% % (source: https://en.wikipedia.org/wiki/Propagation_of_uncertainty; table Example formulae, second line f=aA+bB with a=b=1 and assuming covariance=0)
% exposure_mms(nextremes + 1,:,:) = sqrt(nansum( exposure_mms(1:nextremes,:,:).^2 , 1));


% compute mean across extreme impact categories - std
% (source: https://en.wikipedia.org/wiki/Propagation_of_uncertainty; table Example formulae, second line f=aA+bB with a=b=0.5 and assuming covariance=0)
exposure_mms(nextremes + 1,:,:) = sqrt(nansum( (1./nextremes).^2 .* exposure_mms(1:nextremes,:,:).^2 , 1));


% compute multi-model IQR (q25 and q75) per extreme impact category
% exposure_q25(nextremes + 1,:,:) = nansum(exposure_q25(1:nextremes,:,:), 1); % original approach: sum extremes
% exposure_q75(nextremes + 1,:,:) = nansum(exposure_q75(1:nextremes,:,:), 1); % original approach: sum extremes
exposure_q25(nextremes + 1,:,:) = geomean(exposure_q25(1:nextremes,:,:), 1, 'omitnan'); % new approach: geometric mean
exposure_q75(nextremes + 1,:,:) = geomean(exposure_q75(1:nextremes,:,:), 1, 'omitnan'); % new approach: geometric mean



% --------------------------------------------------------------------
% prepare for plotting maps
% --------------------------------------------------------------------


% Decide which reference to use: multi-model mean of the picontrol simulations (computed in mf_exposure_pic) or of the historical simulations (computed in this function)
if isempty(exposure_pic_mean)
    exposure_ref = exposure_mmm;
else
    exposure_ref = exposure_pic_mean;
end


% Check whether EMFs need to be computed
if size(exposure_mmm,3) == nbirthyears

    
    % compute Exposure Multiplication Factor (EMF) maps
    EMF_mmm = exposure_mmm ./ repmat(exposure_ref(:,:, ages == age_ref), 1, 1, nbirthyears);   % like probability ratio (PR = Pnew/Pref), but with difference that exposure can exceed 1  

    
    % get IQR EMFs - note that we use the q25/75 of the young age but the mmm of the reference age
    EMF_q25 = exposure_q25 ./ repmat(exposure_ref(:,:,ages == age_ref), 1, 1, nbirthyears);
    EMF_q75 = exposure_q75 ./ repmat(exposure_ref(:,:,ages == age_ref), 1, 1, nbirthyears); 


    % set EMFs for inf to 100 
    ninf                    = numel(find(isinf(EMF_mmm))) ./ numel(EMF_mmm) .* 100;  % percentage of infinite numbers: 2.8% but mostly very small countries!
    EMF_mmm(isinf(EMF_mmm)) = 100;
    
    
    % for all extremes, get the geometric mean of the EMFs - for the main paper figures
    EMF_mmm(nextremes+1,:,:) = geomean(EMF_mmm(1:nextremes,:,:), 1, 'omitnan');

    
    % for all extremes, get the harmonic mean of the EMFs - for SI sensitivity plot
    EMF_mmm_harmmean(nextremes+1,:,:) = harmmean(EMF_mmm(1:nextremes,:,:), 1, 'omitnan');


    % for all extremes, get the EMF of the sum of exposure across categories - for SI sensitivity plot
    EMF_mmm_geomexp = exposure_mmm ./ repmat(exposure_ref(:,:, ages == age_ref), 1, 1, nbirthyears);   

        
    % for all extremes, get the geometric mean of the IQR of the EMFs - for the uncertainty bands in fig. 3
    EMF_q25(nextremes+1,:,:) = geomean(EMF_q25(1:nextremes,:,:), 1, 'omitnan');
    EMF_q75(nextremes+1,:,:) = geomean(EMF_q75(1:nextremes,:,:), 1, 'omitnan');

    
else
    
    
    % do not compute EMFS
    EMF_mmm = [];
    
    
end
    

% % diagnostic plot for testing
% ind_extremes(RCP2GMT_maxdiff > RCP2GMT_maxdiff_threshold,:) = 0;
% figure;imagesc(ind_extremes);colorbar


end

