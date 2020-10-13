
% --------------------------------------------------------------------
% main script to postprocess and visualise ISIMIP2b output: 'Lange data'
% For 'burden of young people' study
% --------------------------------------------------------------------


% to do:
% - is averaging across models and extremes ok for EMF??? Improve uncertainty propagation?
% - use spatially-explicit life expectancy data for BE too? (now it's using the global LE)
% - avoid double counting of ISIMIP years ?
% - make maps of absolute changes
% - regional line plots: add pie charts with relative fractions for selected age groups (at birth? end of life is more difficult and SSP dependend) below the figure
% - ms_exposure: mf_invprctile and prctile not fully reversible !!!
% - BE scenarios branch off in 2010 already, is this ok? We've had a decade of warming since then already, so most conservative scenario is not possible anymore
% - apply running mean to GMT data? e.g. 5-yr running mean? to be able to reduce maxdiff from 0.5 to 0.1 again?


% notes:
% - ISIMIP GMT anomalies are computed using the 1850-1900 period (51-yr average) as reference (historical, not picontrol), consistent with SR15 Ch1 (sect. 1.2.1)
% - in several countries life expectancy in 1960 is <60, yet x-axis of contry plots suggests they are still alive in 2020!
% - previously, hazards were dropping for very young ages. This was due to makima giving weird extrapolations in some countries. Linear extrapolation solved the issue
% - hazards emerge in certain countries, e.g. TCs in Korea,
% - heatwaves suspicious in eastern-Europe+scandinavia+UK: seems to be related to fact that definition is for 'wet heatwaves' see e-mail stefan Lange 20/01/2020
% - population data assumes SSP3 for all RCP/GMT scenarios
% - spatial averaging is done using world life expectancy instead of country life expectancy
% - now brute GMT difference threshold (0.5K) to remove entire runs, this could be refined if needed
% - updated axdiff threshold from 0.1°C to 0.5°C due to presence of year-to-year jumps >0.1°C in annual GMT series (and sticking to annual
%   makes sense due to damage function approach + moving window has no data for last years)
% - for the global analysis we assume one uniform life expectancy, but instead we could account for the spatial life expectancy variability
% - BE: weird line structures are due to GCM sampling.
% - spatial pdfs: mismatch of ~500 million people when applying repelem at pixel scale using country-level data because they live along the coastlines
%     popmask = zeros(size(population(:,:,61)));
%     for i=1:ncountries; popmask(countries.mask{i})=1; end;
%     figure;imagesc(popmask);colorbar
%     AAE=population(:,:,61);
%     figure;imagesc(AAE);colorbar;caxis([0 1]);
% - stefan's new data set (20200417) differs from his earlier data set (20190601). We can use new data because:
%     He uses the same heatwave definition but processed it in cdo instead of R to be faster
%     AFA=NaN instead of AFA=zero where there is no data ==> Small islands like Bahama's, Comores, Cape Verde etc. now sometimes have NaN as e.g. CLM4.5, LPJmL,... do not simulate there. So caution needed when interpreting small island results as there is less data
%     the original files differ, e.g. burntarea orchidee-gfdl-rcp2.6. So it looks like the differences are owing to new input data, not flaws in my procesisng chain
% - regarding means:
%     geometric mean on exposure suggests no change in many countries: does not make any sense if you look at EMFs of individual hazards ==> don't use
%     geometric mean on EMFs : works, gives substantial diff between 1.5 and NDC, is theoretically defendable (mean of 'different things')
%     harmonic mean on EMFs : works and is theoretically defendable (mean of ratios), but is most conservative of all means and gives little diff between scenarios and weird results in many countries under 1.5



tic


% clean up
clc;
clear;
close all;


% flags
flags.extr  = 0;    % 0: all
                    % 1: burntarea
                    % 2: cropfailedarea
                    % 3: driedarea
                    % 4: floodedarea
                    % 5: heatwavedarea
                    % 6: tropicalcyclonedarea
flags.embers = 1;   % 0: do not compute info for burning embers
                    % 1: compute info for burning embers
flags.masks = 0;    % 0: do not process country data (i.e. load masks workspace)
                    % 1: process country data (i.e. produce and save masks as workspace)
flags.runs  = 0;    % 0: do not process ISIMIP runs (i.e. load runs workspace)
                    % 1: process ISIMIP runs (i.e. produce and save runs as workspace)
flags.exposure = 0; % 0: do not process ISIMIP runs to compute exposure (i.e. load exposure workspace)
                    % 1: process ISIMIP runs to compute exposure (i.e. produce and save exposure as workspace)
flags.valp  = 1;    % 0: do not compute values used in the paper
                    % 1: compute values used in the paper
flags.plot  = 1;    % 0: do not plot
                    % 1: plot



% --------------------------------------------------------------------
% initialisation
% --------------------------------------------------------------------


% declare globals
global island                                                              %#ok<NUSED>


% add matlab scripts directory to path
addpath(genpath('C:\Users\u0079068\Documents\Research\matlab_scripts'));


% add directory containing nc files to path
indir = 'C:\Users\u0079068\Documents\Research\ISIMIP2b_exposure\ncfiles';
addpath(genpath(indir));  


% initialise age and associated time period of interest
ages        = (60:-1:0)';
age_young   = 0;
age_ref     = nanmax(ages);
year_ref    = 2020;
year_start  = year_ref - age_ref;
birth_years = (year_start:year_ref)';       
year_end    = 2109;


% initialise age groups
% (https://www.carbonbrief.org/analysis-why-children-must-emit-eight-times-less-co2-than-their-grandparents)
% (https://www.pewresearch.org/fact-tank/2019/01/17/where-millennials-end-and-generation-z-begins/)
agegroups = {'Boomers'    1950 1965;
             'Gen X'      1965 1981;
             'Millenials' 1981 1997;
             'Gen Z'      1997 2020;};

         
% initialise reference period for computing GMT anomalies
year_start_GMT_ref  = 1850;
year_end_GMT_ref    = 1900;


% initialise types of extremes
extremes        = {'burntarea', 'cropfailedarea', 'driedarea', 'floodedarea' , 'heatwavedarea', 'tropicalcyclonedarea'};
extremes_legend = {'Wildfires', 'Crop failures' , 'Droughts' , 'River floods', 'Heatwaves'    , 'Tropical cyclones'   , 'All'};
if flags.extr > 0
    extremes        = extremes(flags.extr);
    extremes_legend = extremes_legend(flags.extr);
end


% initialise model names
model_names.burntarea            = {'CARAIB', 'LPJ-GUESS', 'LPJmL', 'ORCHIDEE', 'VISIT'                                        };
model_names.cropfailedarea       = {'GEPIC' , 'LPJmL'    , 'PEPIC'                                                             };
model_names.driedarea            = {'CLM45' , 'H08'      , 'LPJmL', 'JULES-W1', 'MPI-HM', 'ORCHIDEE', 'PCR-GLOBWB', 'WaterGAP2'};
model_names.floodedarea          = {'CLM45' , 'H08'      , 'LPJmL', 'JULES-W1', 'MPI-HM', 'ORCHIDEE', 'PCR-GLOBWB', 'WaterGAP2'};
model_names.heatwavedarea        = {'HWMId-humidex'};
model_names.tropicalcyclonedarea = {'KE-TG-meanfield'};


% Set threshold maximum T difference between RCP and GMT trajectories
% i.e. any run with T difference exceeding this threshold is excluded
% year-to-year jumps in GMT larger than 0.1, so using a 0.1 maxdiff threshold erronously removes runs
% used to be 0.5, but then rcp2.6 is used for high-warming levels
% Anything between 0.1 and 0.2 removes RCP2.6 in NDC scenarios (see histograms of maxdiff_NDC)
% take 0.2 to have more data in BE scenarios and hence smooth EMF curves in BE plot
RCP2GMT_maxdiff_threshold = 0.2; % [K]


% set kernel x-values
kernel_x = 1:0.5:50;



% --------------------------------------------------------------------
% load data
% --------------------------------------------------------------------


ms_load



% --------------------------------------------------------------------
% manipulations: general
% --------------------------------------------------------------------


ms_manip



% --------------------------------------------------------------------
% Prepare for burning embers figure
% --------------------------------------------------------------------


if flags.embers == 1   
   ms_burning_embers;
end



% --------------------------------------------------------------------
% Compute exposure per lifetime
% --------------------------------------------------------------------


ms_exposure;



% --------------------------------------------------------------------
% visualise output
% --------------------------------------------------------------------


if flags.plot == 1
   ms_plotscript
end



% --------------------------------------------------------------------
% get values used in the paper
% --------------------------------------------------------------------


if flags.valp == 1
   ms_valp
end




toc
