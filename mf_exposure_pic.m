

% --------------------------------------------------------------------
% function to compute extreme event exposure across a person's lifetime
% under picontrol climate conditions and assuming 1960 life expectancy
% --------------------------------------------------------------------


function [exposure_perlife_pic, exposure_perlife_pic_mean, exposure_perlife_perrun_pic_mean, exposure_perlife_pic_std, exposure_perlife_pic_pct] = mf_exposure_pic(isimip_pic, extremes, countries, percentages, ind_age, exposure_peryear_pic)


% note: 
% - countries can also be regions



% --------------------------------------------------------------------
% Initialisation
% --------------------------------------------------------------------


% define number of bootstrap samples
nbootstraps = 100; % during testing
% nbootstraps = 1000; % during production


% get number of countries (can also be regions)
ncountries = length(countries.name);


% get number of pic simulations
nruns_pic = size(exposure_peryear_pic, 1);


% get number of extreme impact categories
nextremes = length(extremes);


% set number of extreme event combinations over which the boootstrap samples are to be summed
ncombinations = 1000;


% number op people against which to normalise
npeople_div = 10^5; % during testing
% npeople_div = 10^3; % during production


% set default life expectancy to consider - year 1960 value
if isempty(ind_age)
    ind_age = 1;
end



% --------------------------------------------------------------------
% Manipulations: create bootstrap samples of life-accumulated exposure
% per picontrol simulation
% --------------------------------------------------------------------


% loop over pic runs
for i=1:nruns_pic


    % For reproducibility - always take the same random numbers
    rng('default')  


    % get number of simulation years
    nyears_pic = length(exposure_peryear_pic{i});


    % ceate life expectancy mask for subsetting the bootstrap samples
    % take life expectancy of first year (i.e. 1960)!
    mask_life_expectancy = nan(nyears_pic, ncountries);
    for j=1:ncountries 
        mask_life_expectancy(1 : round(countries.life_expectancy{j}(ind_age)), j) = 1;
    end
    
        
    % ADD LAST PARTIAL YEAR OF LIFE EXPECTANCY???? SINCE WE USE 'ROUND', IT SHOULDN'T MAKE A BIG DIFFERENCE???

    
    % generate bootstrap samples and integrate exposure over full years lived
    [exposure_perlife_perrun_pic(:,:,i), ~] = bootstrp(nbootstraps, @(x)[ nansum(x .* mask_life_expectancy, 1) ], cell2mat(exposure_peryear_pic(i,:)));


end


% get mean of the bootstrapped distribution - per pic run
exposure_perlife_perrun_pic_mean = permute(nanmean(exposure_perlife_perrun_pic, 1), [3 2 1]);


% % % % get std of the bootstrapped distribution - per pic run
% % % exposure_perlife_perrun_pic_std = permute(nanstd(exposure_perlife_perrun_pic), [3 2 1]);



% --------------------------------------------------------------------
% Manipulations: pool simulation data per extreme event category
% --------------------------------------------------------------------


% loop over extremes
for i=1:nextremes    
    
    
    % get indices corresponding to extremes
    ind_extremes(:,i) = ismember({isimip_pic.extreme}, extremes{i})';


    % loop over countries
    for j=1:ncountries
        
        
        % pool data per extreme event category into one vector
        exposure_perlife_pic{i,j} = reshape(exposure_perlife_perrun_pic(:,j,ind_extremes(:,i)), 1, []);


        % get empirical percentile values for Burning embers
        exposure_perlife_pic_pct(i,j,:) = prctile(exposure_perlife_pic{i,j}, percentages);


        % get mean and std for Burning embers
        exposure_perlife_pic_mean(i,j) = nanmean(exposure_perlife_pic{i,j});
        exposure_perlife_pic_std(i,j)  = nanstd( exposure_perlife_pic{i,j});

        
        
    end

    
end



% --------------------------------------------------------------------
% Manipulations: get pool of sums over all event categories for a pre-
% defined number of random combinations of simulations
% --------------------------------------------------------------------


% they should be from the same 'picontrol years' and same GCM, but randomly select the impact model
% bootstrap the random impact model selection or use just one realisation? (just one realisation because you have enough bootstrap samples per model to remove a potential effect of selection bias)
% to get same years, select only runs with the same number of picontrol years? or run the analysis only with 239 years?


% For reproducibility
rng('default')  


% CONSIDER MAKING THIS CONDITION MORE STRINGENT TO HAVE MATCHING PIC YEARS ONLY
% select X random combinations of one simulation for each extreme
ind_run_pic_perextreme                = repmat((1:nruns_pic)',[1 nextremes]); % create array containing all simulation numbers (rows) per extreme (column)
ind_run_pic_perextreme(~ind_extremes) = NaN;                                  % per column, keep only those simulating the extreme
ind_run_pic_perextreme                = sort(ind_run_pic_perextreme,1);       % sort the data
[~,nruns_pic_perexteme]               = max(ind_run_pic_perextreme,[],1);     % get number of runs per extreme


% loop over countries
for j=1:ncountries

    
    % loop over number of extreme event combinations
    for k=1:ncombinations
        
        
        % select 'ncombinations' random combinations of one simulation for each extreme
        random_row = ceil(rand(size(nruns_pic_perexteme)).*nruns_pic_perexteme);                                                  % select a random element in each column
        random_run = ind_run_pic_perextreme(sub2ind(size(ind_run_pic_perextreme), random_row, 1:size(ind_run_pic_perextreme,2))); % get correspondong random simulation numbers


        % aggregate the impacts of these categories
        % exposure_perlife_pic_allextremes(:,k) = nansum(exposure_perlife_perrun_pic(:,j,random_run), 3); % original approach: sum extremes
        exposure_perlife_pic_allextremes(:,k) = geomean(exposure_perlife_perrun_pic(:,j,random_run), 3, 'omitnan'); % new approach: geometric mean, used for getting the 'percause' analysis
       
        
    end
    
    
    %  pool the data into one vector
    exposure_perlife_pic{nextremes+1,j} = reshape(exposure_perlife_pic_allextremes, 1, []);


    % get empirical percentile values for Burning embers
    exposure_perlife_pic_pct(nextremes+1,j,:) = prctile(exposure_perlife_pic{nextremes+1,j}, percentages);


    % get mean and std for Burning embers
    exposure_perlife_pic_mean(nextremes+1,j) = nanmean(exposure_perlife_pic{nextremes+1,j});
    exposure_perlife_pic_std(nextremes+1,j)  = nanstd( exposure_perlife_pic{nextremes+1,j});
    
    
end



end

