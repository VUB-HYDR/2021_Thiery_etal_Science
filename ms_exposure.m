
% --------------------------------------------------------------------
% subroutine to compute extreme event exposure across a person's lifetime
% note: preferably run "main"
% --------------------------------------------------------------------



% --------------------------------------------------------------------
% convert Area Fraction Affected (AFA) to per-country 
% number of extremes affecting one individual across life span
% --------------------------------------------------------------------



% get exposure
if flags.exposure == 1   


    % prepare for loop
    exposure_peryear_percountry         = NaN(nruns, ncountries, nyears);
    exposure_peryear_perregion          = NaN(nruns, nregions  , nyears);
    
    landfrac_peryear_perregion          = NaN(nruns, nregions  , nyears);
    landfrac_peryear_perregion_15       = NaN(nruns, nregions  , nyears);
    landfrac_peryear_perregion_20       = NaN(nruns, nregions  , nyears);
    landfrac_peryear_perregion_NDC      = NaN(nruns, nregions  , nyears);
    
    exposure                            = NaN(nruns, ncountries, nbirthyears);
    exposure_perrun_15                  = NaN(nruns, ncountries, nbirthyears);
    exposure_perrun_20                  = NaN(nruns, ncountries, nbirthyears);
    exposure_perrun_NDC                 = NaN(nruns, ncountries, nbirthyears);

    exposure_perregion                  = NaN(nruns, nregions, nbirthyears);
    exposure_perregion_perrun_15        = NaN(nruns, nregions, nbirthyears);
    exposure_perregion_perrun_20        = NaN(nruns, nregions, nbirthyears);
    exposure_perregion_perrun_NDC       = NaN(nruns, nregions, nbirthyears);
    exposure_perregion_perrun_OS        = NaN(nruns, nregions, nbirthyears);  
    exposure_perregion_perrun_noOS      = NaN(nruns, nregions, nbirthyears);    
    

    if flags.embers == 1
    exposure_perregion_perrun_BE      = NaN(nruns, nregions, nbirthyears, nGMTsteps);
    end
    
    RCP2GMT_maxdiff_15                = NaN(nruns, 1);
    RCP2GMT_maxdiff_20                = NaN(nruns, 1);
    RCP2GMT_maxdiff_NDC               = NaN(nruns, 1);
    RCP2GMT_maxdiff_OS                = NaN(nruns, 1);
    RCP2GMT_maxdiff_noOS              = NaN(nruns, 1);
    

    % loop over simulations
    for i=1:nruns
%     for i=246:257 % heatwaves
    

        % print country name to screen
        disp(['run ' num2str(i) ' of ' num2str(nruns)])
        

        % Get ISIMIP GMT indices closest to GMT trajectories        
        [RCP2GMT_diff_15  , ind_RCP2GMT_15  ] = min(abs(bsxfun(@minus,isimip(i).GMT, GMT_15'  )));
        [RCP2GMT_diff_20  , ind_RCP2GMT_20  ] = min(abs(bsxfun(@minus,isimip(i).GMT, GMT_20'  )));
        [RCP2GMT_diff_NDC , ind_RCP2GMT_NDC ] = min(abs(bsxfun(@minus,isimip(i).GMT, GMT_NDC' )));
        [RCP2GMT_diff_OS  , ind_RCP2GMT_OS  ] = min(abs(bsxfun(@minus,isimip(i).GMT, GMT_OS'  )));
        [RCP2GMT_diff_noOS, ind_RCP2GMT_noOS] = min(abs(bsxfun(@minus,isimip(i).GMT, GMT_noOS')));


        % Get maximum T difference between RCP and GMT trajectories (to remove rows later)
        RCP2GMT_maxdiff_15(i,1)   = nanmax(RCP2GMT_diff_15  );
        RCP2GMT_maxdiff_20(i,1)   = nanmax(RCP2GMT_diff_20  );
        RCP2GMT_maxdiff_NDC(i,1)  = nanmax(RCP2GMT_diff_NDC );
        RCP2GMT_maxdiff_OS(i,1)   = nanmax(RCP2GMT_diff_OS  );
        RCP2GMT_maxdiff_noOS(i,1) = nanmax(RCP2GMT_diff_noOS);


        % load AFA data of that run
        load(['ncfiles\workspaces\mw_isimip_AFA_' num2str(i)]);
        
        
        % --------------------------------------------------------------------
        % per country 
        % --------------------------------------------------------------------

        
        % get spatial average
        for j=1:ncountries 
            
            % corresponding picontrol - assume constant 1960 population density (this line takes about 16h by itself)
            [~, exposure_peryear_percountry_pic{i,j}] = mf_fieldmean(isimip_AFA_pic, population(:,:,1), countries.mask{j}); %#ok<SAGROW>
            
            % historical + RCP simulations
            [~, exposure_peryear_percountry(i,j,:)  ] = mf_fieldmean(isimip_AFA    , population       , countries.mask{j});
            
        end


        % call function to compute extreme event exposure per country and per lifetime
        exposure(i,:,:)            = mf_exposure(isimip(i).years, birth_years, countries, exposure_peryear_percountry(i,:,:              ) );
        exposure_perrun_15(i,:,:)  = mf_exposure(isimip(i).years, birth_years, countries, exposure_peryear_percountry(i,:,ind_RCP2GMT_15 ) );
        exposure_perrun_20(i,:,:)  = mf_exposure(isimip(i).years, birth_years, countries, exposure_peryear_percountry(i,:,ind_RCP2GMT_20 ) );
        exposure_perrun_NDC(i,:,:) = mf_exposure(isimip(i).years, birth_years, countries, exposure_peryear_percountry(i,:,ind_RCP2GMT_NDC) );

        
        
        % --------------------------------------------------------------------
        % per region
        % --------------------------------------------------------------------


        % get spatial average
        for j=1:nregions 

            % corresponding picontrol - assume constant 1960 population density
            [~, exposure_peryear_perregion_pic{i,j}] = mf_fieldmean(isimip_AFA_pic, population(:,:,1), regions.mask{j}); %#ok<SAGROW>

            % historical + RCP simulations
            [~, exposure_peryear_perregion(i,j,:)] = mf_fieldmean(isimip_AFA, population, regions.mask{j});
            
            % historical + RCP simulations
            [~, landfrac_peryear_perregion(i,j,:)] = mf_fieldmean(isimip_AFA, grid_area, regions.mask{j});
            

        end

        
        % call function to compute extreme event exposure per region and per lifetime
        exposure_perregion(i,:,:)            = mf_exposure(isimip(i).years, birth_years, regions, exposure_peryear_perregion(i,:,:              ) );
        exposure_perregion_perrun_15(i,:,:)  = mf_exposure(isimip(i).years, birth_years, regions, exposure_peryear_perregion(i,:,ind_RCP2GMT_15 ) );
        exposure_perregion_perrun_20(i,:,:)  = mf_exposure(isimip(i).years, birth_years, regions, exposure_peryear_perregion(i,:,ind_RCP2GMT_20 ) );
        exposure_perregion_perrun_NDC(i,:,:) = mf_exposure(isimip(i).years, birth_years, regions, exposure_peryear_perregion(i,:,ind_RCP2GMT_NDC) );


        % call function to compute extreme event exposure per region and per lifetime - for Nico Bauer
        exposure_perregion_perrun_OS(i,:,:)   = mf_exposure(isimip(i).years, birth_years, regions, exposure_peryear_perregion(i,:,ind_RCP2GMT_OS  ) );
        exposure_perregion_perrun_noOS(i,:,:) = mf_exposure(isimip(i).years, birth_years, regions, exposure_peryear_perregion(i,:,ind_RCP2GMT_noOS) );

        
        % call function to compute land fraction exposed to extreme events per region and per year - for eulerian perspective figure
        landfrac_peryear_perregion_15(i,:,:)  = landfrac_peryear_perregion(i,:,ind_RCP2GMT_15 );
        landfrac_peryear_perregion_20(i,:,:)  = landfrac_peryear_perregion(i,:,ind_RCP2GMT_20 );
        landfrac_peryear_perregion_NDC(i,:,:) = landfrac_peryear_perregion(i,:,ind_RCP2GMT_NDC);


        %  calculations for Burning Embers diagram
        if flags.embers == 1
            for l=1:nGMTsteps

                % Get ISIMIP GMT indices closest to GMT trajectories        
                [RCP2GMT_diff_BE(l,:), ind_RCP2GMT_BE(l,:) ] = min(abs(bsxfun(@minus,isimip(i).GMT, GMT_BE(:,l)' ))); %#ok<SAGROW>

                % Get maximum T difference between RCP and GMT trajectories (to remove rows later)
                RCP2GMT_maxdiff_BE(i,l) = nanmax(RCP2GMT_diff_BE(l,:));

                % call function to compute extreme event exposure per region and per lifetime - for burning embers diagram
                exposure_perregion_perrun_BE(i,:,:,l) = mf_exposure(isimip(i).years, birth_years, regions, exposure_peryear_perregion(i,:,ind_RCP2GMT_BE(l,:)) );
                
            end
        end


    end


    % save arrays as matlab workspace
    disp('saving mw_exposure')
    save('mw_exposure', 'RCP2GMT_maxdiff_15', 'RCP2GMT_maxdiff_20', 'RCP2GMT_maxdiff_NDC', 'RCP2GMT_maxdiff_OS', 'RCP2GMT_maxdiff_noOS', 'RCP2GMT_maxdiff_BE', ...
                        'landfrac_peryear_perregion', 'landfrac_peryear_perregion_15', 'landfrac_peryear_perregion_20', 'landfrac_peryear_perregion_NDC'                                   , ...
                        'exposure'              , 'exposure_perrun_15'              , 'exposure_perrun_20'              , 'exposure_perrun_NDC'              , ...
                        'exposure_perregion'    , 'exposure_perregion_perrun_15'    , 'exposure_perregion_perrun_20'    , 'exposure_perregion_perrun_NDC'    , ...
                        'exposure_perregion_perrun_OS'    , 'exposure_perregion_perrun_noOS'                                                                 , ...
                        'exposure_peryear_percountry', 'exposure_peryear_percountry_pic', 'exposure_peryear_perregion', 'exposure_peryear_perregion_pic'     , ...
                        'exposure_perregion_perrun_BE');


elseif flags.exposure == 0

    % load matlab workspace
    disp('loading mw_exposure')
    load('mw_exposure')
    
end



% --------------------------------------------------------------------
% Process picontrol data
% --------------------------------------------------------------------


% Define percentages for computing percentiles
percentages = [90 99.9 99.999]; % 1-in-10 to 1-in-100'000


% select only unique picontrol data sets
mod_gcm_ext                   = cellfun(@(x,y,z) [x y z], {isimip.model}', {isimip.gcm}', {isimip.extreme}','un',0); % concatenate 'model', 'gcm' and 'extreme' into one string
[~, ind_pic, ind_pic_reverse] = unique(mod_gcm_ext, 'stable');                                                       % get their unique values
isimip_pic                    = isimip(ind_pic);                                                                     % subset isimip struct


% for small countries: replace NaN by vector of NaNs.
[nan_row, nan_col] = find(cell2mat(cellfun(@(x)any(isnan(x)),exposure_peryear_percountry_pic,'UniformOutput',false)));
for i=1:length(nan_row)
    exposure_peryear_percountry_pic{nan_row(i), nan_col(i)} = NaN(size(exposure_peryear_percountry_pic{nan_row(i), nan_col(i) - 1}));
end


% get picontrol exposure - no duplicate pic runs - per country
[exposure_percountry_pic, ~                          , ~, ~, ~] = mf_exposure_pic(isimip_pic, extremes, countries, percentages, [], exposure_peryear_percountry_pic(ind_pic, :));


% get picontrol exposure - no duplicate pic runs - per region
[exposure_perregion_pic , exposure_perregion_pic_mean, ~, ~, ~ ] = mf_exposure_pic(isimip_pic, extremes, regions  , percentages, [], exposure_peryear_perregion_pic(ind_pic, :));


% quantify 'pure effect of increased life expectancy' from picontrol simulations - per region
for i=1:nbirthyears
[~ , exposure_perregion_pic_mean_perage(:,:,i) , ~, ~, ~ ] = mf_exposure_pic(isimip_pic, extremes, regions  , percentages, i, exposure_peryear_perregion_pic(ind_pic, :) ); %#ok<SAGROW>
end



% --------------------------------------------------------------------
% compute averages across runs and sums across extremes 
% --------------------------------------------------------------------


% get indices corresponding to RCPs
ind_rcp26 = ismember({isimip.rcp}, 'rcp26')';
ind_rcp60 = ismember({isimip.rcp}, 'rcp60')';
ind_gmt   = contains({isimip.rcp}, 'rcp'  )';   % consider all indices


% call function computing the multi-model mean (MMM) and the Exposure Multiplication Factor (EMF)
[exposure_rcp26            , exposure_mms_rcp26            , EMF_rcp26            ] = mf_exposure_mmm(extremes, isimip, ind_rcp26, ages, age_ref, exposure                         , [], []                 , RCP2GMT_maxdiff_threshold);
[exposure_rcp60            , exposure_mms_rcp60            , EMF_rcp60            ] = mf_exposure_mmm(extremes, isimip, ind_rcp60, ages, age_ref, exposure                         , [], []                 , RCP2GMT_maxdiff_threshold);
[exposure_perregion_rcp26  , exposure_perregion_mms_rcp26  , EMF_perregion_rcp26  ] = mf_exposure_mmm(extremes, isimip, ind_rcp26, ages, age_ref, exposure_perregion               , [], []                 , RCP2GMT_maxdiff_threshold);
[exposure_perregion_rcp60  , exposure_perregion_mms_rcp60  , EMF_perregion_rcp60  ] = mf_exposure_mmm(extremes, isimip, ind_rcp60, ages, age_ref, exposure_perregion               , [], []                 , RCP2GMT_maxdiff_threshold);
[exposure_15               , exposure_mms_15               , EMF_15               ] = mf_exposure_mmm(extremes, isimip, ind_gmt  , ages, age_ref, exposure_perrun_15               , [], RCP2GMT_maxdiff_15 , RCP2GMT_maxdiff_threshold);
[exposure_20               , exposure_mms_20               , EMF_20               ] = mf_exposure_mmm(extremes, isimip, ind_gmt  , ages, age_ref, exposure_perrun_20               , [], RCP2GMT_maxdiff_20 , RCP2GMT_maxdiff_threshold);
[exposure_NDC              , exposure_mms_NDC              , EMF_NDC              ] = mf_exposure_mmm(extremes, isimip, ind_gmt  , ages, age_ref, exposure_perrun_NDC              , [], RCP2GMT_maxdiff_NDC, RCP2GMT_maxdiff_threshold);
[exposure_perregion_15     , exposure_perregion_mms_15     , EMF_perregion_15     , EMF_perregion_q25_15  , EMF_perregion_q75_15  ] = mf_exposure_mmm(extremes, isimip, ind_gmt  , ages, age_ref, exposure_perregion_perrun_15     , [], RCP2GMT_maxdiff_15  , RCP2GMT_maxdiff_threshold);
[exposure_perregion_20     , exposure_perregion_mms_20     , EMF_perregion_20     , EMF_perregion_q25_20  , EMF_perregion_q75_20  ] = mf_exposure_mmm(extremes, isimip, ind_gmt  , ages, age_ref, exposure_perregion_perrun_20     , [], RCP2GMT_maxdiff_20  , RCP2GMT_maxdiff_threshold);
[exposure_perregion_NDC    , exposure_perregion_mms_NDC    , EMF_perregion_NDC    , EMF_perregion_q25_NDC , EMF_perregion_q75_NDC ] = mf_exposure_mmm(extremes, isimip, ind_gmt  , ages, age_ref, exposure_perregion_perrun_NDC    , [], RCP2GMT_maxdiff_NDC , RCP2GMT_maxdiff_threshold);


[exposure_perregion_NDC_young2pic, exposure_perregion_mms_NDC_young2pic, EMF_perregion_NDC_young2pic, EMF_perregion_q25_NDC_young2pic, EMF_perregion_q75_NDC_young2pic] = mf_exposure_mmm(extremes, isimip, ind_gmt  , ages, age_ref, exposure_perregion_perrun_NDC    ,exposure_perregion_pic_mean , RCP2GMT_maxdiff_NDC , RCP2GMT_maxdiff_threshold);

[exposure_perregion_OS     , exposure_perregion_mms_OS     , EMF_perregion_OS     , EMF_perregion_q25_OS  , EMF_perregion_q75_OS  , exposure_perregion_q25_OS  , exposure_perregion_q75_OS  ] = mf_exposure_mmm(extremes, isimip, ind_gmt  , ages, age_ref, exposure_perregion_perrun_OS  , [], RCP2GMT_maxdiff_OS  , RCP2GMT_maxdiff_threshold);
[exposure_perregion_noOS   , exposure_perregion_mms_noOS   , EMF_perregion_noOS   , EMF_perregion_q25_noOS, EMF_perregion_q75_noOS, exposure_perregion_q25_noOS, exposure_perregion_q75_noOS] = mf_exposure_mmm(extremes, isimip, ind_gmt  , ages, age_ref, exposure_perregion_perrun_noOS, [], RCP2GMT_maxdiff_noOS, RCP2GMT_maxdiff_threshold);


%  calculations for Burning Embers diagram
if flags.embers == 1
    for l=1:nGMTsteps

        
        % print GT level to screen
        disp(['GMT step ' num2str(l) ' of ' num2str(nGMTsteps)])


        % get multi-model mean exposure
        [exposure_perregion_BE(:,:,:,l), ~, EMF_perregion_young2pic_BE(:,:,:,l), ~, ~, ~, ~, EMF_perregion_young2pic_BE_harmean(:,:,:,l), EMF_perregion_young2pic_BE_geomexp(:,:,:,l)] = mf_exposure_mmm(extremes, isimip, ind_gmt, ages, age_ref, exposure_perregion_perrun_BE(:,:,:,l), exposure_perregion_pic_mean, RCP2GMT_maxdiff_BE(:,l), RCP2GMT_maxdiff_threshold); %#ok<SAGROW>
        
        
        % loop over extremes
        for i=1:nextremes+1
            
            % loop over regions
            for j=1:nregions
%             for j=nregions
                
                
                % compute inverse percentiles of BE exposure scenarios given pic exposure distribution
                PCT_perregion_young2pic_BE(i,j,:,l) = mf_invprctile(exposure_perregion_pic{i,j}', squeeze(exposure_perregion_BE(i,j,:,l)));
                
                
                % for verification - TBR
                % NOT YET WORKING COMPLETELY - IT DOES FOR MOST PERCENTILES BUT NOT FOR ALL !!!!!
                % TEST OTHER FUNCTION OPTIONS??
                VERIFY_INVPRCTILE(i,j,:,l) = prctile(exposure_perregion_pic{i,j}', squeeze(PCT_perregion_young2pic_BE(i,j,:,l)));

                
            end


        end


    end


end


% % diagnostic plot for testing
% figure;
% for i=1:8; plot(isimip(i).years, isimip(i).GMT); hold on; end
% legend('gfdl rcp2.6', 'gfdl rcp6.0', 'hadgem rcp2.6', 'hadgem rcp6.0', 'ipsl rcp2.6', 'ipsl rcp6.0', 'miroc rcp2.6', 'miroc rcp6.0', 'location', 'northwest')

