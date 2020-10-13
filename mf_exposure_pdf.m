

% --------------------------------------------------------------------
% function to compute extreme event exposure across a person's lifetime
% --------------------------------------------------------------------


function [exposure_perlife_perrun_kernel_y, exposure_perlife_kernel_y] = mf_exposure_pdf(isimip, extremes, RCP2GMT_maxdiff, RCP2GMT_maxdiff_threshold, exposure_perrun_NDC, exposure_perrun_pic_mean, population, kernel_x)


% note: 
% - countries can also be regions
% - if ind_RCP2GMT is empty, the function returns results for RCP trajectory



% --------------------------------------------------------------------
% Initialisation
% --------------------------------------------------------------------


% get number of simulations
nruns = size(exposure_perrun_NDC, 1);


% get number of extremes
nextremes = length(extremes);


% prepare for loop
exposure_perlife_perrun_kernel_y = NaN(nruns    , length(kernel_x));
exposure_perlife_kernel_y        = NaN(nextremes, length(kernel_x));


% number op people against which to normalise
npeople_div = 10^5; % during testing
% npeople_div = 10^3; % during production


% bandwidth for Kernel smoother
bandwidth = 2;



% --------------------------------------------------------------------
% Manipulations
% --------------------------------------------------------------------


% loop over countries
for ind_run=1:nruns 
    
    
ind_run=ind_run


%     % get the distribution of the absolute change
%     exposure_perlife_pdf  = repelem(exposure_perrun_NDC(ind_run, :) - exposure_perrun_pic_mean(ind_run, :), round(population ./ npeople_div))';


    % get the distribution of the exposure multiplication factor
    exposure_perlife_pdf  = repelem(exposure_perrun_NDC(ind_run, :) ./ exposure_perrun_pic_mean(ind_run, :), round(population ./ npeople_div))';

    
    % fit a kernel to the distribution
    [exposure_perlife_perrun_kernel_y(ind_run, :), ~] = ksdensity(exposure_perlife_pdf, kernel_x,'Kernel','normal', 'Bandwidth', bandwidth);
% exposure_perlife_pdf(exposure_perlife_pdf<=0) = NaN;
%     [exposure_perlife_perrun_kernel_y(ind_run, :), ~] = ksdensity(exposure_perlife_pdf, kernel_x,'Kernel','normal', 'Bandwidth', bandwidth, 'Support','positive');

end


% fit a kernel to the distribution over countries and simulations
for ind_extreme=1:nextremes
    
    
ind_extreme=ind_extreme

    
    % two conditions: runs for that category of extremes and maximum GMT difference below the threshold
    ind_run_ex = find(strcmp({isimip.extreme}, extremes{ind_extreme})' & RCP2GMT_maxdiff <= RCP2GMT_maxdiff_threshold);
    
            
    % prepare for loop
    exposure_perlife_pdf_mm = [];
    
    
    % loop over selected runs
    for j=1:length(ind_run_ex)
        

%         % get the distribution of the absolute change
%         exposure_perlife_pdf  = repelem(exposure_perrun_NDC(ind_run_ex(j), :) - exposure_perrun_pic_mean(ind_run_ex(j), :), round(population ./ npeople_div))';
        

        % get the distribution of the exposure multiplication factor
        exposure_perlife_pdf  = repelem(exposure_perrun_NDC(ind_run_ex(j), :) ./ exposure_perrun_pic_mean(ind_run_ex(j), :), round(population ./ npeople_div))';

        
        % store the data
        exposure_perlife_pdf_mm = [exposure_perlife_pdf_mm; exposure_perlife_pdf]; %#ok<AGROW>

        
    end
    
    
    % fit a kernel to the distribution
    [exposure_perlife_kernel_y(ind_extreme,:), ~] = ksdensity(exposure_perlife_pdf_mm, kernel_x,'Kernel','normal', 'Bandwidth', bandwidth);
% exposure_perlife_pdf_mm(exposure_perlife_pdf_mm<=0) = NaN;
%     [exposure_perlife_kernel_y(ind_extreme,:), ~] = ksdensity(exposure_perlife_pdf_mm, kernel_x,'Kernel','normal', 'Bandwidth', bandwidth, 'Support','positive');

    
% %     % during testing
% %     figure;histogram(exposure_perlife_pdf_mm, 100, 'DisplayStyle','stairs')
% %     figure;plot(kernel_x, exposure_perlife_kernel_y(ind_extreme,:))

    
end





end

