

% --------------------------------------------------------------------
% function to compute extreme event exposure across a person's lifetime
% --------------------------------------------------------------------


function [exposure_perlife_pdf, exposure_perlife_kernel_y] = mf_exposure_pdf_pixel(isimip_years, birth_years, year, countries, isimip_AFA, isimip_AFA_pic, population, kernel_x)


% note: 
% - countries can also be regions
% - if ind_RCP2GMT is empty, the function returns results for RCP trajectory



% --------------------------------------------------------------------
% Initialisation
% --------------------------------------------------------------------


% get number of countries (can also be regions)
ncountries = length(countries.name);


% get number of considered simulation years and birth years
ind_year = find(birth_years == year);


% prepare for loop
exposure_perlife_pdf = [];


% number op people against which to normalise
npeople_div = 10^5; % during testing
% npeople_div = 10^3; % during production



% --------------------------------------------------------------------
% Manipulations
% --------------------------------------------------------------------


% get PIC mean exposure per year
exposure_peryear_pic_map = nanmean(isimip_AFA_pic, 3);


% loop over countries
for j=1:ncountries 


    % integrate exposure over full years lived - spatial map per country
    % assume life expectancy of first year (i.e. 1960)
    exposure_perlife_pic_map = exposure_peryear_pic_map .* countries.life_expectancy{j}(1);

    
    % get indices of birth and deadth years
    ind_birth = find(isimip_years ==  birth_years(ind_year)                                                 , 1, 'first');
    ind_death = find(isimip_years == (birth_years(ind_year) + floor(countries.life_expectancy{j}(ind_year))), 1, 'first');


    % integrate exposure over full years lived - spatial map per country
    exposure_perlife_map = nansum(isimip_AFA(:,:, ind_birth:ind_death), 3);


    % add exposure during last (partial) year - spatial map per country
    exposure_perlife_map = exposure_perlife_map + isimip_AFA(:,:, ind_death + 1) .* (countries.life_expectancy{j}(ind_year) - floor(countries.life_expectancy{j}(ind_year)));

    
    % get absolute change in exposure at pixel-scale from PIC to scenario (e.g. NDC)
    % relative change doesn't make any sense at the pixel scale because you have so many zeros. 
    exposure_perlife_young2pic_map = exposure_perlife_map - exposure_perlife_pic_map;

    
    % account for people living in pixel - vector encompassing all countries
%     exposure_perlife_pdf = [exposure_perlife_pdf; repelem(exposure_perlife_map(countries.mask{j}), round(population(countries.mask{j}) ./ npeople_div), 1)]; %#ok<AGROW>
    exposure_perlife_pdf = [exposure_perlife_pdf; repelem(exposure_perlife_young2pic_map(countries.mask{j}), round(population(countries.mask{j}) ./ npeople_div), 1)]; %#ok<AGROW>

    
end



% fit a kernel to the distribution
[exposure_perlife_kernel_y, ~] = ksdensity(exposure_perlife_pdf, kernel_x,'Kernel','normal', 'Bandwidth', 1);


% % % during testing
% % figure;histogram(exposure_perlife_pdf, 50, 'DisplayStyle','stairs')
% % figure;plot(kernel_x, exposure_perlife_kernel_y)


end

