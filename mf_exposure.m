

% --------------------------------------------------------------------
% function to compute extreme event exposure across a person's lifetime
% --------------------------------------------------------------------


function [exposure_perlife] = mf_exposure(isimip_years, birth_years, countries, exposure_peryear)


% note: 
% - countries can also be regions
% - if ind_RCP2GMT is empty, the function returns results for RCP trajectory



% --------------------------------------------------------------------
% Initialisation
% --------------------------------------------------------------------


% get number of countries (can also be regions)
ncountries = length(countries.name);


% get number of considered simulation years and birth years
nbirthyears = length(birth_years);


% prepare for loop
exposure_perlife = NaN(1, ncountries, nbirthyears);



% --------------------------------------------------------------------
% Manipulations
% --------------------------------------------------------------------


% loop over countries
for j=1:ncountries 


    % loop over birth years
    for k=1:nbirthyears


        % get indices of birth and deadth years
        ind_birth = find(isimip_years ==  birth_years(k)                                          , 1, 'first');
        ind_death = find(isimip_years == (birth_years(k) + floor(countries.life_expectancy{j}(k))), 1, 'first');

        
        % integrate exposure over full years lived
        exposure_perlife(1,j,k) = nansum(exposure_peryear(1,j, ind_birth:ind_death));


        % add exposure during last (partial) year
        exposure_perlife(1,j,k) = exposure_perlife(1,j,k) + exposure_peryear(1,j, ind_death + 1) .* (countries.life_expectancy{j}(k) - floor(countries.life_expectancy{j}(k)));


    end


end


end

