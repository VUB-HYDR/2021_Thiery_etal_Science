
% --------------------------------------------------------------------
% Compute values used in the paper
% note: preferably run "main"
% --------------------------------------------------------------------


clc;


% --------------------------------------------------------------------
% Abstract
% --------------------------------------------------------------------


% Range of EMFs for newborn under NDC
valp_EMF_range_newborn_NDC(1) = nanmin(squeeze(EMF_perregion_NDC(1:nextremes, 12, ages == 0)));
valp_EMF_range_newborn_NDC(2) = nanmax(squeeze(EMF_perregion_NDC(1:nextremes, 12, ages == 0)))



% --------------------------------------------------------------------
% Results
% --------------------------------------------------------------------


% land fraction exposed to heatwaves in 2020 and 2100
if flags.plot_fig1 == 1

valp_landfrac_15_2020  = landfrac_15_plot(years_SR15 == 2020)
valp_landfrac_20_2020  = landfrac_20_plot(years_SR15 == 2020)
valp_landfrac_NDC_2020 = landfrac_NDC_plot(years_SR15 == 2020)
    
valp_landfrac_15_2100  = landfrac_15_plot(years_SR15 == 2100)
valp_landfrac_NDC_2100 = landfrac_NDC_plot(years_SR15 == 2100)
    
end


% 60-yr old & newborn: nr heatwaves across lifetime
if flags.plot_fig1 == 1
    valp_nr_heatwaves_6yrold = round(exposure_bars, 1)
end

% 60-yr old & newborn: EMF (just read from the plot)


% 6-yr old: 
valp_EMF_6yr = round(squeeze(EMF_perregion_young2pic_BE(:, 12, ages == 6, GMT_steps == 3)), 0)


% regional differences in EMF for a newborn
regions.name(ind_region)
valp_EMF_worldregions_newborns_NDC = round(squeeze(EMF_perregion_NDC_young2pic(nextremes + 1, ind_region, end)),1)'


% change in burden per region (all extremes)
valp_change_in_burden_perregion      = regions.name;
valp_change_in_burden_perregion_NDC  = exposure_perregion_NDC(nextremes+1, 1:12, ages == 0)' - exposure_perregion_NDC(nextremes+1, 1:12, ages == age_ref)';
valp_change_in_burden_perregion_15   = exposure_perregion_15( nextremes+1, 1:12, ages == 0)' - exposure_perregion_15( nextremes+1, 1:12, ages == age_ref)';
valp_change_in_burden_perregion(:,2) = num2cell(round((1 - valp_change_in_burden_perregion_15 ./ valp_change_in_burden_perregion_NDC) .* 100) .* -1)


% contribution of CC vs. LE change
if flags.plot_sfig6 == 1
    
    for ind_region = 1:nregions
        
            % copied from ms_plotscript: prepare area plots
            exposure_perregion_percause_NDC = [repmat(exposure_perregion_pic_mean(nextremes + 1, ind_region), nbirthyears, 1) ...                                        % prepare for area plot
                                       flipud(squeeze(exposure_perregion_diff_cc( nextremes + 1, ind_region, :)))     ...
                                       flipud(squeeze(exposure_perregion_diff_dle(nextremes + 1, ind_region, :)))        ];
                            
            % get percentage of CC signal compared to total change
            valp_CCvsLE_newborn(ind_region, 1) = round(exposure_perregion_percause_NDC(1,2) ./ (exposure_perregion_percause_NDC(1,2) + exposure_perregion_percause_NDC(1,3)) .* 100);
     
            % print to screen
            disp([regions.name{ind_region, 1}, ' ', num2str(valp_CCvsLE_newborn(ind_region, 1))])

     
    end
    
    
end


% change in burden per extreme (global) - summary paragraph
valp_change_in_burden_perextreme      = extremes_legend';
valp_change_in_burden_perextreme_NDC  = exposure_perregion_NDC(1:nextremes+1, 12, ages == 0) - exposure_perregion_NDC(1:nextremes+1, 12, ages == age_ref);
valp_change_in_burden_perextreme_15   = exposure_perregion_15( 1:nextremes+1, 12, ages == 0) - exposure_perregion_15( 1:nextremes+1, 12, ages == age_ref);
valp_change_in_burden_perextreme(:,2) = num2cell(round((1 - valp_change_in_burden_perextreme_15 ./ valp_change_in_burden_perextreme_NDC) .* 100) .* -1)



% --------------------------------------------------------------------
% Methods
% --------------------------------------------------------------------


% average number of pic years per simulation:
nyears_pic_average = round(nanmean([isimip_pic.nyears_pic]))


% GMT anomalies in 2091-2100
valp_GMT_15_endofcentury  = round(nanmean(GMT_15( years_SR15 >= 2091 & years_SR15 <= 2100)),1)
valp_GMT_20_endofcentury  = round(nanmean(GMT_20( years_SR15 >= 2091 & years_SR15 <= 2100)),1)
valp_GMT_NDC_endofcentury = round(nanmean(GMT_NDC(years_SR15 >= 2091 & years_SR15 <= 2100)),1)



% --------------------------------------------------------------------
% Supplementary information
% --------------------------------------------------------------------


% ISIMIP simulation table:
% isimip_pic copied to excel and manually reworked

