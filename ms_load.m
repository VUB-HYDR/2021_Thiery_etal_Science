
% --------------------------------------------------------------------
% subroutine to load the variables
% note: preferably run "main"
% --------------------------------------------------------------------



% --------------------------------------------------------------------
% Load observational data
% --------------------------------------------------------------------


% load World Bank life expectancy data (source: https://data.worldbank.org/indicator/SP.DYN.LE00.IN)
[worldbank_country_data, worldbank_country_meta, worldbank_country_raw] = xlsread('world_bank_life_expectancy_by_country.xls',1);
[worldbank_region_data , worldbank_region_meta , worldbank_region_raw ] = xlsread('world_bank_life_expectancy_by_country.xls',2);
worldbank_years                                                         = (1960:2017)';                                           % hard coded from 'world_bank_life_expectancy_by_country_original.xls'


% load United Nations median age data (source: https://population.un.org/wpp/DataQuery/)
[unwpp_country_data, unwpp_country_meta, unwpp_country_raw] = xlsread('united_nations_median_age_by_country.xls',1);


% load United Nations Human Developpent Index (HDI) data (source: http://hdr.undp.org/en/data#)
[unhdi_country_data, unhdi_country_meta, unhdi_country_raw] = xlsread('united_nations_HDI_by_country.xls',1);
unhdi_country_data(unhdi_country_data == -999) = NaN;


% load United Nations Humand Developpent Index (HDI) data (source: http://hdr.undp.org/en/data#)
[un_popunder5_country_data, un_popunder5_country_meta, un_popunder5_country_raw] = xlsread('united_nations_population_under_5_by_country.xls',1);
un_popunder5_country_data(un_popunder5_country_data == -999) = NaN;


% load country borders
country_borders = m_shaperead('ne_10m_admin_0_countries'); 



% --------------------------------------------------------------------
% Load global mean temperature projections
% --------------------------------------------------------------------


% Load global mean temperature projections from SR15
GMT_SR15   = xlsread('GMT_50pc_manualoutput_4pathways.xlsx');
years_SR15 = GMT_SR15(1,:);
if nanmax(years_SR15) < year_end 
    GMT_SR15   = cat(2, GMT_SR15, repmat( nanmean(GMT_SR15(:, end-9:end), 2), 1, year_end - nanmax(years_SR15))); % repeat average of last 10 years (i.e. end-9 to end ==> 2090:2099)
    years_SR15 = [years_SR15'; (nanmax(years_SR15)+1:1:year_end)'];
end
ind_f      = find(years_SR15 == year_start, 1, 'first');
ind_l      = find(years_SR15 == year_end  , 1, 'first');
GMT_15     = GMT_SR15(5, ind_f:ind_l)';
GMT_20     = GMT_SR15(2, ind_f:ind_l)';
GMT_NDC    = GMT_SR15(3, ind_f:ind_l)';
years_SR15 = years_SR15(ind_f:ind_l);


% Load global mean temperature projections from UVIC model - For Nico Bauer
GMT_UVIC   = xlsread('CDRMIA_overshoot_scenario_UVic_output_GMTanomalies.xlsx');
GMT_UVIC   = [GMT_SR15(1:3, GMT_SR15(1,:)<2005)' ; GMT_UVIC];
years_UVIC = GMT_UVIC(:, 1);
if nanmax(years_UVIC) < year_end 
    GMT_UVIC   = cat(1, GMT_UVIC, repmat( nanmean(GMT_UVIC(end-9:end, :), 1), year_end - nanmax(years_UVIC), 1)); % repeat average of last 10 years (i.e. end-9 to end ==> 2090:2099)
    years_UVIC = [years_UVIC; (nanmax(years_UVIC)+1:1:year_end)'];
end
ind_f      = find(years_UVIC == year_start, 1, 'first');
ind_l      = find(years_UVIC == year_end  , 1, 'first');
GMT_OS     = GMT_UVIC(ind_f:ind_l, 2);
GMT_noOS   = GMT_UVIC(ind_f:ind_l, 3);
years_UVIC = years_UVIC(ind_f:ind_l);



% --------------------------------------------------------------------
% Load SSP population totals
% --------------------------------------------------------------------


% load 2D model constants
[~, ~, years_pop_hist, population_histsoc] = mf_load('population_histsoc_0p5deg_annual_1861-2005.nc4', 'number_of_people');
[~, ~, years_pop_ssp2, population_ssp2soc] = mf_load('population_ssp2soc_0p5deg_annual_2006-2100.nc4', 'number_of_people');


% concatenate historical and future data
population = cat(3, population_histsoc, population_ssp2soc);
years_pop  = [years_pop_hist; years_pop_ssp2];


% if needed, repeat last year until entire period of interest is covered
if nanmax(years_pop) < year_end
    population = cat(3, population, repmat( nanmean(population(:,:, end-9:end), 3), 1, 1, year_end - nanmax(years_pop))); % repeat average of last 10 years (i.e. end-9 to end ==> 2090:2099)
    years_pop  = [years_pop; (nanmax(years_pop)+1:1:year_end)'];                                                          % order matters, compute this only after AFA and GMT!!!
end


% retain only period of interest
ind_start  = find(years_pop == year_start, 1, 'first');
ind_end    = find(years_pop == year_end  , 1, 'first');
years_pop  = years_pop(ind_start:ind_end);
population = population(:,:,ind_start:ind_end);


% clean up
clear years_pop_hist years_pop_ssp2 population_histsoc population_ssp2soc



% --------------------------------------------------------------------
% Load ISIMIP model data
% --------------------------------------------------------------------


% load 2D model constants
[lat_mod, lon_mod, ~, ~] = mf_load('caraib_gfdl-esm2m_historical_burntarea_global_annual_landarea_1861_2005.nc4', 'exposure');
grid_area                = rot90(ncread('clm45_area.nc4', 'cell_area'));


% load ISIMIP model output
if flags.runs == 1


    % initialise counter
    counter = 1;


    % loop over extremes
    for i=1:length(extremes)    
%     for i=1   % for testing   


        % define all model
        models = getfield(model_names,extremes{i});


        % loop over models
        for j=1:length(models)
%         for j=1 % for testing


            % get model name
            model_name = models{j};


            % store all file names starting with model name
            file_names_all = struct2cell(dir([indir '\isimip\' extremes{i} '\' lower(model_name) '\' lower(model_name) '*landarea*.nc4']));


            % only consider file names containing both '_rcp' and '2099' in their name (i.e. future projections)
            file_names_all = file_names_all(1,:)';
            file_names_fut = file_names_all(contains(file_names_all,'_rcp'));
            file_names_fut = file_names_fut(contains(file_names_fut,'2099'));

            
            % loop over file names
            for k=1:length(file_names_fut)
%             for k=1:1 % for testing


                % print message to screen
                disp(['loading ' file_names_fut{k} ' (' num2str(counter) ')']);

                
                % store metadata
                metadata                = split(file_names_fut{k}, '_');
                isimip(counter).model   = metadata{1};
                isimip(counter).gcm     = metadata{2};
                isimip(counter).rcp     = metadata{3};
                isimip(counter).extreme = metadata{4};


                % load rcp data (AFA: Area Fraction Affected)
                [~, ~, years_rcp, AFA_rcp] = mf_load(file_names_fut{k}, 'exposure');

                
                % load associated historical variable
                file_name_his               = file_names_all(contains(file_names_all, '_historical_'));
                file_name_his               = file_name_his(contains(file_name_his, isimip(counter).gcm));
                [~, ~, years_his, AFA_hist] = mf_load(file_name_his{1}, 'exposure');

                
                % load GMT for rcp and historical period - note that these data are in different files
                file_names_gmt    = struct2cell(dir([indir '\isimip\DerivedInputData\globalmeans\tas\' upper(isimip(counter).gcm) '\*.fldmean.yearmean.txt'])); % ignore running mean files
                file_names_gmt    = file_names_gmt(1,:)';
                file_name_gmt_fut = file_names_gmt(contains(file_names_gmt, isimip(counter).rcp));
                file_name_gmt_his = file_names_gmt(contains(file_names_gmt, '_historical_'));
                file_name_gmt_pic = file_names_gmt(contains(file_names_gmt, '_piControl_'));
                GMT_fut           = dlmread(file_name_gmt_fut{1}, '', 1, 0);
                GMT_his           = dlmread(file_name_gmt_his{1}, '', 1, 0);
                GMT_pic           = dlmread(file_name_gmt_pic{1}, '', 1, 0);

                
                % concatenate historical and future data
                AFA   = cat(3, AFA_hist, AFA_rcp);
                years = [years_his; years_rcp];
                GMT   = [GMT_his(:,2); GMT_fut(:,2)];
                
                
                % Convert GMT from absolute values to anomalies - use data from pic until 1861 and from his from then onwards
                GMT = GMT - nanmean( [GMT_pic(find(GMT_pic(:,1) == year_start_GMT_ref):find(GMT_pic(:,1) == GMT_his(1,1))-1,2); GMT_his(1:find(GMT_his(:,1) == year_end_GMT_ref),2)] );

                
                % if needed, repeat last year until entire period of interest is covered
                if nanmax(years) < year_end
                    AFA   = cat(3, AFA, repmat( nanmean(AFA(:,:, end-9:end), 3), 1, 1, year_end - nanmax(years))); % repeat average of last 10 years (i.e. end-9 to end ==> 2090:2099)
                    GMT   = [GMT; repmat( nanmean(GMT(end-9:end)), year_end - nanmax(years), 1)];                    % repeat average of last 10 years (i.e. end-9 to end ==> 2090:2099)
                    years = [years; (nanmax(years)+1:1:year_end)'];                                                % order matters, compute this only after AFA and GMT!!!
                end
                

                % retain only period of interest
                ind_start             = find(years == year_start, 1, 'first');
                ind_end               = find(years == year_end  , 1, 'first');
                isimip(counter).years = years(ind_start:ind_end);
                isimip(counter).GMT   = GMT(ind_start:ind_end);
                isimip_AFA            = AFA(:,:,ind_start:ind_end);

                
                % load associated picontrol variables (can be from up to 4 files)
                file_names_pic = file_names_all(contains(file_names_all, '_picontrol_'));
                file_names_pic = file_names_pic(contains(file_names_pic, isimip(counter).gcm));
                for l=1:length(file_names_pic)                                                  % loop over pic file names
                    [~, ~, years_pic{l}, AFA_pic{l}] = mf_load(file_names_pic{l}, 'exposure');  % load AFA data
                end
                [~, ind_pic_chronol]       = sortrows(cellfun(@min,years_pic)');                % get chronological order
                isimip_AFA_pic             = cat(3,AFA_pic{ind_pic_chronol});                   % concatenate AFA data & place in chronological order
                isimip(counter).years_pic  = cat(1,years_pic{ind_pic_chronol});                 % concatenate year data & place in chronological order
                isimip(counter).nyears_pic = length(isimip(counter).years_pic);                 % get number of pic years

                
                % save AFA field as matlab workspace
                save(['ncfiles\workspaces\mw_isimip_AFA_' num2str(counter)],'isimip_AFA','isimip_AFA_pic','-v7.3');


                % update counter
                counter = counter + 1;


                % clean up
                clear AFA AFA_hist AFA_rcp AFA_pic years_hist years_rcps years_pic year_end_pic


            end


        end


    end


    % save struct as matlab workspace
    disp('saving mw_isimip')
    save('mw_isimip','isimip','-v7.3');

    
elseif flags.runs == 0

    % load matlab workspace
    disp('loading mw_isimip')
    load('mw_isimip')
  
end


