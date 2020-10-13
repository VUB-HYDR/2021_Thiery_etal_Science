
% --------------------------------------------------------------------
% subroutine to perform manipulations on loaded variables
% note: preferably run "main"
% --------------------------------------------------------------------



% --------------------------------------------------------------------
% manipulations: general
% --------------------------------------------------------------------


% get grid dimensions
[nlat, nlon] = size(lat_mod);


% get country names
countries.abbreviation = worldbank_country_meta(:,2);
countries.name         = worldbank_country_meta(:,1);
countries.region       = worldbank_country_meta(:,3);
countries.incomegroup  = worldbank_country_meta(:,4);


% get country names
countries.median_age_2015 = unwpp_country_data(:,1);
countries.median_age_2020 = unwpp_country_data(:,2);


% get country HDI
countries.hdi_2015 = unhdi_country_data(:,26);
countries.hdi_2018 = unhdi_country_data(:,29);


% get country HDI
countries.popunder5_2015 = un_popunder5_country_data(:,10);
countries.popunder5_2018 = un_popunder5_country_data(:,13);


% get region names
regions.abbreviation = worldbank_region_meta(:,2);
regions.name         = worldbank_region_meta(:,1);


% get number of simulations
nruns = length(isimip);


% get number of birth years
nbirthyears = length(birth_years);


% get number of extreme impact categories
nextremes = length(extremes);


% get number of years considered in this study
nyears = length(year_start:year_end);



% --------------------------------------------------------------------
% manipulations: get country masks and interpolate life expectancies
% --------------------------------------------------------------------


% original data runs from 1960 to 2017 but we want estimates from 1960 to 2020
% add three columns of NaNs
worldbank_country_data(:,length(worldbank_years)+1:length(worldbank_years)+year_ref-worldbank_years(end)) = NaN;    
worldbank_region_data( :,length(worldbank_years)+1:length(worldbank_years)+year_ref-worldbank_years(end)) = NaN;    


% declare and populate interpolated World Bank data array; will be used for gap filling
worldbank_country_data_interp = worldbank_country_data;
worldbank_region_data_interp  = worldbank_region_data;


% initialise index denoting too small countries or empty regions
ind_small_countries = [];
ind_empty_regions   = [];


% get country masks
if flags.masks == 1   

    % loop over countries
    for i=1:length(countries.name)


        % print country name to screen
        disp(countries.name{i})


        % store birth_year data
        countries.birth_years{i,1} = birth_years;


        % extract data from World Bank file and fill in missing data
        ind_nan                                  = find(isnan(worldbank_country_data(i,:)));
        ind_data                                 = find(~isnan(worldbank_country_data(i,:)));
        worldbank_country_data_interp(i,ind_nan) = interp1(countries.birth_years{i,1}(ind_data), worldbank_country_data(i,ind_data), countries.birth_years{i,1}(ind_nan), 'linear', 'extrap');
        countries.life_expectancy{i,1}           = worldbank_country_data_interp(i,:);


        % extract data from country borders file
        ind_borders         = find(strcmp(country_borders.dbf.NAME_LONG(:,1), countries.name{i}));
        countries.mask{i,1} = inpolygon(lon_mod, lat_mod, country_borders.ncst{ind_borders}(:,1), country_borders.ncst{ind_borders}(:,2) );


        % extract total population
        countries.population{i,1} = squeeze(nansum( population .* repmat(countries.mask{i,1}, [1 1 nyears]), [1 2]));

        
        % check whether country has non-zero mask
        if isempty(find(countries.mask{i}==1, 1))
            ind_small_countries = [ind_small_countries i]; %#ok<AGROW>
        end


    end

    
    % Keep only those countries with non-zero masks
    countries.abbreviation(ind_small_countries)    = [];
    countries.name(ind_small_countries)            = [];
    countries.region(ind_small_countries)          = [];
    countries.incomegroup(ind_small_countries)     = [];
    countries.birth_years(ind_small_countries)     = [];
    countries.life_expectancy(ind_small_countries) = [];
    countries.mask(ind_small_countries)            = [];
    countries.median_age_2015(ind_small_countries) = [];
    countries.median_age_2020(ind_small_countries) = [];
    countries.hdi_2015(ind_small_countries)        = [];
    countries.hdi_2018(ind_small_countries)        = [];
    countries.popunder5_2015(ind_small_countries)  = [];
    countries.popunder5_2018(ind_small_countries)  = [];

 
    % loop over regions
    for i=1:length(regions.name)


        % print region name to screen
        disp(regions.name{i})


        % store birth_year data
        regions.birth_years{i,1} = birth_years;


        % extract data from World Bank file and fill in missing data
        ind_nan                                 = find(isnan(worldbank_region_data(i,:)));
        ind_data                                = find(~isnan(worldbank_region_data(i,:)));
        worldbank_region_data_interp(i,ind_nan) = interp1(regions.birth_years{i,1}(ind_data), worldbank_region_data(i,ind_data), regions.birth_years{i,1}(ind_nan), 'linear', 'extrap');
        regions.life_expectancy{i,1}            = worldbank_region_data_interp(i,:);

        
        % identify all countries belonging to the region
        ind_member_countries          = ismember(countries.region(:,1), regions.name{i}) | ismember(countries.incomegroup(:,1), regions.name{i});
        regions.member_countries{i,1} = countries.name(ind_member_countries);

        
        % merge country masks to generate the region mask
        tmp               = countries.mask(ind_member_countries);
        regions.mask{i,1} = logical(sum(cat(3, tmp{:}),3));

        
        % sum all masks to obtain the World mask
        if strcmp(regions.name{i,1}, 'World')
            regions.mask{i,1} = logical(sum(cat(3,countries.mask{:}),3));
        end
            

        % check whether region has non-zero mask
        if isempty(find(regions.mask{i}==1, 1))
            ind_empty_regions = [ind_empty_regions i]; %#ok<AGROW>
        end


    end
    
    
    % Keep only those regions with non-zero masks
    regions.abbreviation(ind_empty_regions)     = [];
    regions.name(ind_empty_regions)             = [];
    regions.birth_years(ind_empty_regions)      = [];
    regions.life_expectancy(ind_empty_regions)  = [];
    regions.member_countries(ind_empty_regions) = [];
    regions.mask(ind_empty_regions)             = [];

    
    % save struct as matlab workspace
    disp('saving mw_countries')
    save('mw_countries','countries', 'regions');


elseif flags.masks == 0

    % load matlab workspace
    disp('loading mw_countries')
    load('mw_countries')
    
end


% get number of countries and regions
ncountries = length(countries.name);
nregions   = length(regions.name);


% get total population of country in 2020
for i=1:ncountries
    population_percountry_2020(i,1) = countries.population{i,1}(years_pop == 2020); %#ok<SAGROW>
end
