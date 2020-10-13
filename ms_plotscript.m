
% --------------------------------------------------------------------
% visualisation subroutine
% note: preferably run "main"
% --------------------------------------------------------------------


% clean up
% close all;


% flags for paper plots
flags.plot_fig1   = 0; % 0: do not plot figure 1 of paper
                       % 1: plot figure 1 of paper
flags.plot_fig2   = 0; % 0: do not plot figure 2 of paper
                       % 1: plot figure 2 of paper
flags.plot_fig3   = 0; % 0: do not plot figure 3 of paper
                       % 1: plot figure 3 of paper
flags.plot_fig4   = 0; % 0: do not plot figure 4 of paper
                       % 1: plot figure 4 of paper
flags.plot_sfig1  = 0; % 0: do not plot supplementary figure 1 of paper
                       % 1: plot supplementary figure 1 of paper
flags.plot_sfig2  = 0; % 0: do not plot supplementary figure 2 of paper
                       % 1: plot supplementary figure 2 of paper
flags.plot_sfig3  = 0; % 0: do not plot supplementary figure 3 of paper
                       % 1: plot supplementary figure 3 of paper
flags.plot_sfig4  = 0; % 0: do not plot supplementary figure 4 of paper
                       % 1: plot supplementary figure 4 of paper
flags.plot_sfig5  = 0; % 0: do not plot supplementary figure 5 of paper
                       % 1: plot supplementary figure 5 of paper
flags.plot_sfig6  = 0; % 0: do not plot supplementary figure 6 of paper
                       % 1: plot supplementary figure 6 of paper
flags.plot_sfig7  = 0; % 0: do not plot supplementary figure 7 of paper
                       % 1: plot supplementary figure 7 of paper
flags.plot_sfig8  = 0; % 0: do not plot supplementary figure 8 of paper
                       % 1: plot supplementary figure 8 of paper
flags.plot_sfig9  = 0; % 0: do not plot supplementary figure 9 of paper
                       % 1: plot supplementary figure 9 of paper

                     
% flags for other plots               
flags.plot_4Nico    = 0;       % 0: do not plot heatwave exposure under OS and noOS scenarios
                               % 1: plot heatwave exposure under OS and noOS scenarios
flags.plot_maps_rcp = 0;       % 0: do not plot Maps per RCP
                               % 1: plot Maps per RCP
flags.plot_maps_gmt = 0;       % 0: do not plot Maps per GMT
                               % 1: plot Maps per GMT
flags.plot_cnt_rcp_scen = 0;   % 0: line plots per country per RCP per scenario
                               % 1: line plots per country per RCP per scenario
flags.plot_cnt_rcp_haz  = 0;   % 0: line plots per country per RCP per hazard
                               % 1: line plots per country per RCP per hazard
flags.plot_cnt_gmt_scen = 0;   % 0: line plots per country per GMT per scenario
                               % 1: line plots per country per GMT per scenario
flags.plot_cnt_gmt_haz  = 0;   % 0: line plots per country per GMT per hazard
                               % 1: line plots per country per GMT per hazard
flags.plot_reg_rcp_scen = 0;   % 0: line plots per region per RCP per scenario
                               % 1: line plots per region per RCP per scenario
flags.plot_reg_rcp_haz  = 0;   % 0: line plots per region per RCP per hazard
                               % 1: line plots per region per RCP per hazard
flags.plot_reg_gmt_scen = 0;   % 0: line plots per region per GMT per scenario
                               % 1: line plots per region per GMT per scenario
flags.plot_reg_gmt_haz  = 0;   % 0: line plots per region per GMT per hazard
                               % 1: line plots per region per GMT per hazard
flags.plot_reg_gmt_haz_area = 0;   % 0: line plots per region per GMT per hazard
                               % 1: line plots per region per GMT per hazard
flags.plot_reg_gmt_allreg = 0; % 0: line plots per region per GMT per hazard  ==> fig. 3
                               % 1: line plots per region per GMT per hazard
flags.plot_lifeexpectancy = 0; % 0: life expectancy data
                               % 1: 
flags.plot_reg_gmt_BE_EMF = 0; % 0: area plots per region per GMT - burning embers (EMF, original)
                               % 1: 
flags.plot_reg_gmt_BE_PCT = 0; % 0: area plots per region per GMT - burning embers (PCT, picontrol)
                               % 1: 
flags.plot_ecdf           = 0; % 0: empirical cumulative density function
                               % 1: 
flags.plot_bubble         = 0; % 0: Bubble plot
                               % 1: 
flags.plot_pdf_cnt        = 0; % 0: pdf plot country scale: to be removed
                               % 1: 
flags.plot_pdf            = 0; % 0: pdf plot
                               % 1: 
       

                     
% --------------------------------------------------------------------
% initialisation
% --------------------------------------------------------------------


% set colorscale axes
% caxes.EMF                = [1/5     5  ]; %  used for sum (i.e. arithmetric mean)
% caxes.EMF                = [1/3     3  ]; %  used for harmonic mean
caxes.EMF                = [1/6     6  ]; %  used for geometric mean
caxes.EMF_heatwaves      = [1/40    40 ]; %  used for geometric mean

caxes.EMF_BE             = [1       4  ];
caxes.PCT_BE_plot        = [0.001 100000]; % 8 o.o.m., i.e. 2 o.o.m. per risk category, looks good
caxes.dexposure          = [-20    20];

caxes.regions_geographic = [0.5     7.5];
caxes.regions_income     = [0.5     4.5];



% set colormaps
colormaps.EMF   =        mf_colormap_cpt('dkbluered', 28); % four options, test them once we have the final plots
% colormaps.EMF   =        mf_colormap_cpt('balance'  , 28);
% colormaps.EMF   =        mf_colormap_cpt('curl'     , 28);
% colormaps.EMF   = flipud(mf_colormap_cpt('damien2'  , 28)); % midtones
colormaps.regions_geographic =        mf_colormap_cpt('Dark2_07', 7);      
colormaps.regions_income     = flipud(mf_colormap_cpt('neutral-s1-09', 4));

colormaps.dexposure   =        mf_colormap_cpt('dkbluered', 20); % four options, test them once we have the final plots

% nice color schemes:
% - thallium
% - jjg/neo10! 
% - jjg/cbc! CB continuous
% - jjg/neo10/elements (poison, rain)
% - ssz (statistic stadt zurich: nice qualitative ones)


% Set end to lighter blue to avoid too close resemblance with dark red
colormaps.EMF(1,:)   = colormaps.EMF(2,:);


% set BE colormap
% white: undetectable    [1.00 1.00 1.00]
% yellow: moderate       [0.99 0.80 0.07]
% red: high              [0.85 0.24 0.19]
% dark-purple: very high [0.56 0.13 0.36]
colormaps.BE_4 = [255/255 255/255 255/255 ; ... % white - derived from 'german-flag-smooth' (white added)
                  252/255 204/255  18/255 ; ... % yellow
                  218/255  60/255  48/255 ; ... % red
                  143/255  34/255  91/255 ];    % dark-purple

                       
% go from discrete to 'pseudo-discrete' color map                       
% colormaps.BE_pseudodiscrete = repelem(colormaps.BE_4, 5, 1);     % to get that 'pseudo-discrete' look of burning embers, the higher the repetition, the more discrete it looks
colormaps.BE_pseudodiscrete = repelem(colormaps.BE_4, 20, 1);     % to get that 'pseudo-discrete' look of burning embers, the higher the repetition, the more discrete it looks
colormaps.BE_pseudodiscrete = imresize(colormaps.BE_pseudodiscrete, [1000, 3]);  % original color map contain just 4 colors, this increase it to 1000
colormaps.BE_pseudodiscrete = min(max(colormaps.BE_pseudodiscrete, 0), 1);       % impose [0 1] bounds


% go from discrete to continuous color map                       
colormaps.BE_continuous = imresize(colormaps.BE_4, [1000, 3]);     % original color map contain just 4 colors, this increase it to 1000
colormaps.BE_continuous = min(max(colormaps.BE_continuous, 0), 1); % impose [0 1] bounds


% rescale to plotting scale
caxes.EMF_plot           = mf_PR_plotscale( caxes.EMF          );
caxes.EMF_heatwaves_plot = mf_PR_plotscale( caxes.EMF_heatwaves);
% caxes.PCT_BE_plot = mf_PCT_plotscale(caxes.PCT_BE);


% line colors
colors = mf_colors;

                               
% define axes and sea color                               
darkcolor = [0.3  0.3  0.3 ]; % dark grey - 70% contrast (so 0.3) is advised
axcolor   = [0.5  0.5  0.5 ]; % normal grey
boxcolor  = [0.70 0.70 0.70]; % light grey
seacolor  = [0.95 0.95 0.95]; % very light grey


% get alphabet                               
alphabet = char(repmat('a' + (1:26) - 1, [2 1]))';


% define panel letters for region plots
panelletters_regions = {'b', 'c', 'd', 'd', 'a', 'b', 'e', 'f', 'g', 'h', 'c', 'a'};


% Set pictogram dimansions [x_min  x_max y_max y_min]
pictogram_dims = [ -2.8 -2.2 -0.2 -1.0;  ... % burntarea
                   -3.0 -2.0 -0.2 -1.2;  ... % cropfailedarea
                   -2.8 -2.2 -0.2 -1.0;  ... % driedarea
                   -2.8 -2.0 -0.2 -1.0;  ... % floodedarea
                   -2.8 -2.0 -0.2 -1.0;  ... % heatwavedarea
                   -2.8 -2.0 -0.2 -1.0;  ... % tropicalcyclonedarea
                   -3.0 -1.7 -0.2 -1.0];     % all events


% load pictogram and make them a bit darker using imadjust
pictogram_all_2x3 = imadjust(imcomplement(imread('pictogram_all_2x3.png')),[0.3 0.3 0.3; 1 1 1],[]);
pictogram_all_1x6 = imadjust(imcomplement(imread('pictogram_all_1x6.png')),[0.3 0.3 0.3; 1 1 1],[]);



% define world regions/income group indices
ind_region = [8 4 2 7 10 1 9 12]; % world regions West to East
ind_income = [5 6 11 3];          % income categories low to high


% get line colors
figure;
colormaps.worldregions = mf_colormap_cpt('Dark2_08');  % CB qualitative colors
linecolors             = get(gca,'ColorOrder');        % get default colors
linecolors(8,:)        = colormaps.worldregions(8,:);  % append default colors with color number 8 from CB 'Dark2_08'
close(gcf)



% --------------------------------------------------------------------
% figure 1: conceptual figure
% --------------------------------------------------------------------


if flags.plot_fig1 == 1


    
% -----------------------------
% Prepare visualisation
% -----------------------------

   
% get land fraction exposed to heatwaves under 1.5°, 2.0° and NDC tarjectories
[landfrac_peryear_15 , ~, ~] = mf_exposure_mmm(extremes, isimip, ind_gmt, ages, age_ref, landfrac_peryear_perregion_15 , RCP2GMT_maxdiff_15 , RCP2GMT_maxdiff_threshold);
[landfrac_peryear_20 , ~, ~] = mf_exposure_mmm(extremes, isimip, ind_gmt, ages, age_ref, landfrac_peryear_perregion_20 , RCP2GMT_maxdiff_20 , RCP2GMT_maxdiff_threshold);
[landfrac_peryear_NDC, ~, ~] = mf_exposure_mmm(extremes, isimip, ind_gmt, ages, age_ref, landfrac_peryear_perregion_NDC, RCP2GMT_maxdiff_NDC, RCP2GMT_maxdiff_threshold);


% define which extreme to analyse
ind_extreme = 5; % heatwaves


% define which region to analyse
ind_region = 12; % world
% ind_region = 2; % North America where people live longer


% define reference age for figure
age_ref_plot = 60;
% age_ref_plot = 50; % to be on average alive in 2020


% get time series and apply smoothing - panel a
landfrac_15_plot  = smooth(squeeze(landfrac_peryear_15( ind_extreme, ind_region, :))) .* 100;
landfrac_20_plot  = smooth(squeeze(landfrac_peryear_20( ind_extreme, ind_region, :))) .* 100;
landfrac_NDC_plot = smooth(squeeze(landfrac_peryear_NDC(ind_extreme, ind_region, :))) .* 100;


% get number of extreme events - panel c
exposure_plot_15  = squeeze(exposure_perregion_15( ind_extreme, ind_region, :));
exposure_plot_20  = squeeze(exposure_perregion_20( ind_extreme, ind_region, :));
exposure_plot_NDC = squeeze(exposure_perregion_NDC(ind_extreme, ind_region, :));


% get associated Exposure Multiplication Factors (EMF) - panel c
EMF_plot_15  = squeeze(EMF_perregion_15( ind_extreme, ind_region, :));
EMF_plot_20  = squeeze(EMF_perregion_20( ind_extreme, ind_region, :));
EMF_plot_NDC = squeeze(EMF_perregion_NDC(ind_extreme, ind_region, :));


% get q25 of Exposure Multiplication Factors (EMF) - panel c
EMF_plot_q25_15  = squeeze(EMF_perregion_q25_15( ind_extreme, ind_region, :));
EMF_plot_q25_20  = squeeze(EMF_perregion_q25_20( ind_extreme, ind_region, :));
EMF_plot_q25_NDC = squeeze(EMF_perregion_q25_NDC(ind_extreme, ind_region, :));


% get q75 of Exposure Multiplication Factors (EMF) - panel c
EMF_plot_q75_15  = squeeze(EMF_perregion_q75_15( ind_extreme, ind_region, :));
EMF_plot_q75_20  = squeeze(EMF_perregion_q75_20( ind_extreme, ind_region, :));
EMF_plot_q75_NDC = squeeze(EMF_perregion_q75_NDC(ind_extreme, ind_region, :));


% get number of extreme events for bars - panel c
exposure_bars = [exposure_plot_15(ages==age_ref_plot) exposure_plot_20(ages==age_ref_plot) exposure_plot_NDC(ages==age_ref_plot); ...
                 exposure_plot_15(ages==age_young   ) exposure_plot_20(ages==age_young   ) exposure_plot_NDC(ages==age_young   )      ];


% define colors
color_15  = colors(27,:);
color_20  = colors(26,:);
color_NDC = colors(25,:);


% visualisation
figure
set(gcf, 'color', 'w');
set(gca,'color','w');
set(gcf, 'Position',  [100, 100, 1600, 400])


    
% -----------------------------
% panel a
% -----------------------------

   

% define fist axes for eulerian heatwave area change
ax1_pos = get(gca, 'position'); % get axis position


% shrink axes width to make room for second and thir axes
set(gca, 'position', [0.05 0.15 0.4 0.80]);      % apply new axes position


% plot eulerian heatwaves
h(3) = plot(years_SR15(1:end-4), landfrac_15_plot(1:end-4) , 'color', color_15 , 'linewidth', 2); hold on;
h(2) = plot(years_SR15(1:end-4), landfrac_20_plot(1:end-4) , 'color', color_20 , 'linewidth', 2); hold on;
h(1) = plot(years_SR15(1:end-4), landfrac_NDC_plot(1:end-4), 'color', color_NDC, 'linewidth', 2); hold on;
plot(years_SR15(years_SR15<year_ref), landfrac_NDC_plot(years_SR15<year_ref), 'color', colors(28,:), 'linewidth', 2); hold on;
set(gca, 'Fontsize', 11, 'Fontweight', 'Bold', 'Xcolor', boxcolor, 'Ycolor', boxcolor, 'box', 'off');
set(gca, 'xtick', (1960:20:2100));
xlabel('Time', 'Fontsize', 12, 'Fontweight', 'Bold'); 
ylabel('Land area annually exposed to heatwaves [%] ', 'Fontsize', 12, 'Fontweight', 'Bold'); 


% add annotations for scenarios (now still legend
text(years_SR15(end-4), landfrac_15_plot(end-4) , ' 1.5°C '                      , 'color', color_15 , 'Fontsize', 12, 'Fontweight', 'Bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle')
text(years_SR15(end-4), landfrac_20_plot(end-4) , ' 2.0°C '                      , 'color', color_20 , 'Fontsize', 12, 'Fontweight', 'Bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle')
text(years_SR15(end-4), landfrac_NDC_plot(end-4), [' Current' newline ' pledges'], 'color', color_NDC, 'Fontsize', 12, 'Fontweight', 'Bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle')


% draw vertical line at 2020
ylims = [0 18];%ylim % get y-axis limits
plot([2020 2020], [ylims(1) ylims(2)-ylims(2)*0.01], 'color', boxcolor, 'linewidth', 2); hold on;


% add title
text(years_SR15(1), ylims(2) + ylims(2)*0.01, 'a Eulerian perspective','ver','bottom','hor','left','Fontsize', 12, 'Fontweight', 'bold', 'color', boxcolor)


% draw arrow and text for 60yr old
ind_age = ages==age_ref_plot;
arrow_start = regions.birth_years{ind_region}(ind_age);
arrow_end   = regions.birth_years{ind_region}(ind_age)+regions.life_expectancy{ind_region}(ind_age);
mf_dataArrow([arrow_start arrow_end], [12 12], gca, axcolor, 3, 'vback1');
plot([arrow_end arrow_end], [11.6 12.4], 'color', axcolor, 'linewidth', 1.5); hold on; % add small vertical line atthe end of the grey arrow
text(regions.birth_years{ind_region}(ind_age)+regions.life_expectancy{ind_region}(ind_age)./2, 12.3, ['Average lifetime of a ' num2str(age_ref_plot) '-yr old in 2020'], 'FontSize', 10, 'Fontweight', 'Bold', 'color', axcolor, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')


% draw arrow and text for newborn
ind_age = ages==age_young;
arrow_start = regions.birth_years{ind_region}(ind_age);
arrow_end   = regions.birth_years{ind_region}(ind_age)+regions.life_expectancy{ind_region}(ind_age);
mf_dataArrow([arrow_start arrow_end], [16 16], gca, axcolor, 3, 'vback1');
plot([arrow_end arrow_end], [15.6 16.4], 'color', axcolor, 'linewidth', 1.5); hold on; % add small vertical line atthe end of the grey arrow
text(regions.birth_years{ind_region}(ind_age)+regions.life_expectancy{ind_region}(ind_age)./2, 16.3, 'Average lifetime of a newborn in 2020', 'FontSize', 10, 'Fontweight', 'Bold', 'color', axcolor, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom')


    
% -----------------------------
% panel b
% -----------------------------
   

% define second axes for bar plots
ax2_pos    = get(gca, 'position');   % get axis position
ax2_pos(1) = 0.50;                   % left bound to the right
ax2_pos(3) = 0.10;                   % shrink width
ax2        = axes('Position',ax2_pos); % generate new axes


% set bar width
barwidth = 0.8;
ylims    = [0   5  ];
xlims    = [0.5 2.5];


% plot data
cats = categorical({num2str(age_ref_plot), num2str(age_young)});
cats = reordercats(cats,{num2str(age_ref_plot), num2str(age_young)}); 
ba = bar(cats, exposure_bars, barwidth, 'EdgeColor', 'none'); hold on;
ba(1).FaceColor = color_15;
ba(2).FaceColor = color_20;
ba(3).FaceColor = color_NDC;
set(gca, 'Fontsize', 11, 'Fontweight', 'Bold', 'Xcolor', boxcolor, 'Ycolor', boxcolor, 'box', 'off');
xlabel('Age of person in 2020', 'Fontsize', 12, 'Fontweight', 'Bold'); 
ylabel('Life-accumulated heatwave exposure [-]', 'Fontsize', 12, 'Fontweight', 'Bold'); 


% add exposure multiplication factors (EMF)
text(ba(1).XEndPoints, ba(1).YEndPoints, {['\times' num2str(round(EMF_plot_15( ages==age_ref_plot)))],['\times' num2str(round(EMF_plot_15( ages==age_young)))]},'HorizontalAlignment','left','VerticalAlignment','middle', 'color', axcolor, 'Fontweight', 'Bold', 'fontsize', 13, 'rotation', 90)
text(ba(2).XEndPoints, ba(2).YEndPoints, {['\times' num2str(round(EMF_plot_20( ages==age_ref_plot)))],['\times' num2str(round(EMF_plot_20( ages==age_young)))]},'HorizontalAlignment','left','VerticalAlignment','middle', 'color', axcolor, 'Fontweight', 'Bold', 'fontsize', 13, 'rotation', 90)
text(ba(3).XEndPoints, ba(3).YEndPoints, {['\times' num2str(round(EMF_plot_NDC(ages==age_ref_plot)))],['\times' num2str(round(EMF_plot_NDC(ages==age_young)))]},'HorizontalAlignment','left','VerticalAlignment','middle', 'color', axcolor, 'Fontweight', 'Bold', 'fontsize', 13, 'rotation', 90)


% add title
ylims = ylim; % get y-axis limits
text(xlims(1), ylims(2) + ylims(2)*0.01, 'b','ver','bottom','hor','left','Fontsize', 12, 'Fontweight', 'bold', 'color', boxcolor)


    
% -----------------------------
% panel c
% -----------------------------


% define third axes for EMF plots
ax3_pos    = get(gca, 'position');   % get axis position
ax3_pos(1) = 0.66;                   % left bound to the right
ax3_pos(3) = 0.275;                   % shrink width
ax3        = axes('Position',ax3_pos); % generate new axes


% get max y-axis range
ymax = max([EMF_plot_q75_NDC(end) EMF_plot_q75_20(end) EMF_plot_q75_15(end)]);


% visualisation
h(1) = plot(ages, EMF_plot_NDC, '-', 'linewidth', 3, 'color', color_NDC); hold on;
h(2) = plot(ages, EMF_plot_20 , '-', 'linewidth', 3, 'color', color_20 ); hold on;
h(3) = plot(ages, EMF_plot_15 , '-', 'linewidth', 3, 'color', color_15 ); hold on;
h(4) = plot(0.1, 0.1 , 'w'); hold on;                                                                    % dummy data to have y-axis starting at 0
h(5) = plot(0.1, ymax, 'w'); hold on;                                                                    % dummy data to have y-axis until end of the 'boxplots'
set(gca, 'XDir','reverse', 'Fontsize', 11, 'Fontweight', 'Bold', 'Xcolor', boxcolor, 'Ycolor', boxcolor, 'box', 'off');
yticks([1 3 5 7 9 11 13 15 17])
yticklabels({'\times1','\times3','\times5','\times7','\times9','\times11','\times13','\times15','\times17',})
xlabel('Age of person in 2020', 'Fontsize', 12, 'Fontweight', 'Bold'); 
ylabel('Exposure multiplication factor over lifetime [-]', 'Fontsize', 12, 'Fontweight', 'Bold'); 


% add title
ylims = ylim; % get y-axis limits
text(ages(1), ylims(2) + ylims(2)*0.01, 'c  Lagrangian perspective','ver','bottom','hor','left','Fontsize', 12, 'Fontweight', 'bold', 'color', boxcolor)


% create new axes for 'boxplots'
axlims     = [1 12 ylim];              % axes limits of 'boxplot' panel
ax4_pos    = get(gca, 'position');     % get axis position
ax4_pos(1) = 0.94;                     % left bound to the right
ax4_pos(3) = 0.03;                     % shrink width
ax4        = axes('Position',ax4_pos); % generate new axes


% plot 'boxplots': rectangle and horizontal line
rectangle('Position', [1, EMF_plot_q25_15(end) , 3, EMF_plot_q75_15( end)  - EMF_plot_q25_15(end) ], 'FaceColor', [color_15  0.5], 'EdgeColor', 'none', 'LineWidth', 3); hold on; % +- 1 std
rectangle('Position', [5, EMF_plot_q25_20(end) , 3, EMF_plot_q75_20( end)  - EMF_plot_q25_20(end) ], 'FaceColor', [color_20  0.5], 'EdgeColor', 'none', 'LineWidth', 3); hold on;
rectangle('Position', [9, EMF_plot_q25_NDC(end), 3, EMF_plot_q75_NDC(end)  - EMF_plot_q25_NDC(end)], 'FaceColor', [color_NDC 0.5], 'EdgeColor', 'none', 'LineWidth', 3); hold on;
plot([1 4 ], [EMF_plot_15(end)  EMF_plot_15(end) ], '-', 'linewidth', 3, 'color', color_15 ); hold on;
plot([5 8 ], [EMF_plot_20(end)  EMF_plot_20(end) ], '-', 'linewidth', 3, 'color', color_20 ); hold on;
plot([9 12], [EMF_plot_NDC(end) EMF_plot_NDC(end)], '-', 'linewidth', 3, 'color', color_NDC); hold on;


% Add labels
text(2 , max(0, EMF_plot_q25_15(end) ), '1.5°C '          , 'color', color_15 , 'Fontsize', 12, 'Fontweight', 'Bold', 'Rotation', 90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle')
text(6 , max(0, EMF_plot_q25_20(end) ), '2.0°C '          , 'color', color_20 , 'Fontsize', 12, 'Fontweight', 'Bold', 'Rotation', 90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle')
text(10, max(0, EMF_plot_q25_NDC(end)), 'Current pledges ', 'color', color_NDC, 'Fontsize', 12, 'Fontweight', 'Bold', 'Rotation', 90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle')


% finalise 'boxplot' plotting
axis(axlims);
set(gca, 'position', ax4_pos, 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
axis off


% load and plot pictograms
if ind_extreme == nextremes+1
    pictogram = pictogram_all_1x6;
else
    pictogram = imadjust(imcomplement(imread(['pictogram_' extremes{ind_extreme} '.png'])),[0.3 0.3 0.3; 1 1 1],[]);
end
ax5 = axes('Position',[0.67 0.95 0.5 0.05]);
imagesc(pictogram); hold off   % add pictogram
axis('off', 'image');


% save figure
export_fig('figures/fig1_conceptual.png', '-transparent');

    
    
end



% --------------------------------------------------------------------
% figure 2: BE figure
% --------------------------------------------------------------------


if flags.plot_fig2 == 1


% get caxis per extreme
caxes.EMF_BE_pe = [1  4; ...   % burntarea
                   1  4; ...   % cropfailedarea
                   1  4; ...   % driedarea
                   1  4; ...   % floodedarea
                   1 30; ...   % heatwavedarea
                   1  4; ...   % tropicalcyclone
                   1  4  ];    % all
ticksteps       = [1; ...   % burntarea
                   1; ...   % cropfailedarea
                   1; ...   % driedarea
                   1; ...   % floodedarea
                   5; ...   % heatwavedarea
                   1; ...   % tropicalcyclone
                   1  ];    % all

    
% loop over regions
for ind_region = 12
  
    
    for ind_extreme = 1:nextremes+1
%     for ind_extreme = nextremes+1
        
    
        % get percentages of extreme events
        PCT_region_plot_BE = squeeze(PCT_perregion_young2pic_BE(ind_extreme, ind_region, :, :))';

        
        % get associated Exposure Multiplication Factors (EMF)
        EMF_region_plot_BE = squeeze(EMF_perregion_young2pic_BE(ind_extreme, ind_region, :, :))';

        
        % call plotting function
        mf_plot_burning_embers(ages, GMT_BE, EMF_region_plot_BE, PCT_region_plot_BE, colormaps.BE_continuous, caxes.EMF_BE_pe(ind_extreme,:), ind_region, ind_extreme, age_ref, agegroups, regions, year_start, nextremes, panelletters_regions, extremes, extremes_legend, axcolor, 2, [])
        
               
        % save figure
        export_fig(['figures/burning_embers/EMF_PCTcont_region_GMT_BE_' regions.name{ind_region} '_'  extremes_legend{ind_extreme} '.png'], '-transparent');

        
        % clean up
        close all


    end
    

end


end



% --------------------------------------------------------------------
% figure 3: line plots per region
% --------------------------------------------------------------------


if flags.plot_fig3 == 1

    
% plot world regions
mf_plot_regions_NDC_EMF(exposure_perregion_NDC, EMF_perregion_NDC_young2pic, EMF_perregion_q25_NDC_young2pic, EMF_perregion_q75_NDC_young2pic, exposure_perregion_mms_NDC, ages, agegroups, regions, year_start, nextremes, ind_region, 'a', [], [0.75 15.5], 'worldregions')
export_fig('figures/per_region/exposure_region_GMT_perscenario_worldregions_geomean_maxdiff02_EMF_young2pic.png', '-transparent');
% export_fig('figures/per_region/exposure_region_GMT_perscenario_worldregions_CBcolors.png', '-transparent');


% plot income regions
mf_plot_regions_NDC_EMF(exposure_perregion_NDC, EMF_perregion_NDC_young2pic, EMF_perregion_q25_NDC_young2pic, EMF_perregion_q75_NDC_young2pic, exposure_perregion_mms_NDC, ages, agegroups, regions, year_start, nextremes, ind_income, 'b', colormaps.regions_income, [0.75 7.5], 'income')
export_fig('figures/per_region/exposure_region_GMT_perscenario_incomegroups_geomean_maxdiff02_EMF_young2pic.png', '-transparent');

    
    
end


% --------------------------------------------------------------------
% figure 4: EMF maps
% --------------------------------------------------------------------


if flags.plot_fig4 == 1

    
% initialise arrays
EMF_map_young2ref_15_allhazards   = NaN(nlat, nlon);
EMF_map_young2ref_NDC_allhazards  = NaN(nlat, nlon);


% loop over countries
for ind_country = 1:ncountries

    % reconstruct global map
    EMF_map_young2ref_15_allhazards( countries.mask{ind_country}) = EMF_15( nextremes + 1, ind_country, ages==age_young);
    EMF_map_young2ref_NDC_allhazards(countries.mask{ind_country}) = EMF_NDC(nextremes + 1, ind_country, ages==age_young);

end

               
% rescale for plotting
EMF_map_young2ref_15_allhazards_plot  = mf_PR_plotscale(EMF_map_young2ref_15_allhazards);
EMF_map_young2ref_NDC_allhazards_plot = mf_PR_plotscale(EMF_map_young2ref_NDC_allhazards);


% young2ref EMF map - NDC - all hazards
cbh = mf_plot_dom2(lon_mod, lat_mod, EMF_map_young2ref_NDC_allhazards_plot, [], island, caxes.EMF_plot, colormaps.EMF, 0, 2, 'c', ['Current pledges - ' num2str(age_young) 'yr compared to ' num2str(age_ref) 'yr'], 'Exposure multiplication factor'); hold on;
set(cbh,'XTickLabel',{'\div6','\div5','\div4','\div3','\div2','\times1','\times2','\times3','\times4','\times5','\times6'}, 'Xtick', mf_PR_plotscale([1/6 1/5 1/4 1/3 1/2 1 2 3 4 5 6]))
imagesc([pictogram_dims(nextremes+1,1) pictogram_dims(nextremes+1,2)], [pictogram_dims(nextremes+1,3) pictogram_dims(nextremes+1,4)], pictogram_all_2x3); hold off   % add pictogram
export_fig figures/EMF_map_young2ref_NDC_allhazards_lowres_geomean_on_EMF.png  -transparent;
% export_fig figures/EMF_map_young2ref_NDC_allhazards_highres.png  -m10 -transparent; close all;


% young2ref EMF map - 1.5°C - all hazards
cbh = mf_plot_dom2(lon_mod, lat_mod, EMF_map_young2ref_15_allhazards_plot, [], island, caxes.EMF_plot, colormaps.EMF, 0, 2, 'd', ['1.5°C warming - ' num2str(age_young) 'yr compared to ' num2str(age_ref) 'yr'], 'Exposure multiplication factor'); hold on;
set(cbh,'XTickLabel',{'\div6','\div5','\div4','\div3','\div2','\times1','\times2','\times3','\times4','\times5','\times6'}, 'Xtick', mf_PR_plotscale([1/6 1/5 1/4 1/3 1/2 1 2 3 4 5 6]))
imagesc([pictogram_dims(nextremes+1,1) pictogram_dims(nextremes+1,2)], [pictogram_dims(nextremes+1,3) pictogram_dims(nextremes+1,4)], pictogram_all_2x3); hold off   % add pictogram
export_fig figures/EMF_map_young2ref_15_allhazards_lowres_geomean_on_EMF.png  -transparent;
% export_fig figures/EMF_map_young2ref_15_allhazards_highres.png -m10 -transparent; close all;




% define panel letters
panelletters_NDC = {'a', 'c', 'e', 'g', 'a', 'i'};
panelletters_15  = {'b', 'd', 'f', 'h', 'b', 'j'};


% loop over extremes
for i=1:nextremes    
    
    % initialise arrays
    EMF_map_young2ref_15(i).perextreme       = NaN(nlat, nlon);
    EMF_map_young2ref_NDC(i).perextreme      = NaN(nlat, nlon);
    exposure_map_young2ref_15(i).perextreme  = NaN(nlat, nlon);
    exposure_map_young2ref_NDC(i).perextreme = NaN(nlat, nlon);

    
    % loop over countries
    for ind_country = 1:ncountries
        
        % EMF
        EMF_map_young2ref_NDC(i).perextreme(countries.mask{ind_country}) = EMF_NDC(i, ind_country, ages==age_young);
        EMF_map_young2ref_15(i).perextreme( countries.mask{ind_country}) = EMF_15( i, ind_country, ages==age_young);
        
        % exposure
        exposure_map_young2ref_NDC(i).perextreme(countries.mask{ind_country}) = exposure_NDC(i, ind_country, ages==age_young);
        exposure_map_young2ref_15(i).perextreme( countries.mask{ind_country}) = exposure_15( i, ind_country, ages==age_young);
        
    end
    
    
    % rescale for plotting
    EMF_map_young2ref_15(i).perextreme_plot  = mf_PR_plotscale(EMF_map_young2ref_15(i).perextreme ); 
    EMF_map_young2ref_NDC(i).perextreme_plot = mf_PR_plotscale(EMF_map_young2ref_NDC(i).perextreme); 

    
    % load pictograms
    pictogram = imcomplement(imread(['pictogram_' extremes{i} '.png']));

    
    % get the right color bar range
    if strcmp(extremes{i}, 'heatwavedarea')
        caxes.EMF_perextreme  = caxes.EMF_heatwaves_plot;
        XTickLabel_perextreme = {'\div40','\div30','\div20','\div10','\times1','\times10','\times20','\times30','\times40'};
        XTicks_perextreme     = mf_PR_plotscale([1/40 1/30 1/20 1/10 1 10 20 30 40]);
    else
        caxes.EMF_perextreme  = caxes.EMF_plot;
        XTickLabel_perextreme = {'\div6','\div5','\div4','\div3','\div2','\times1','\times2','\times3','\times4','\times5','\times6'};
        XTicks_perextreme     = mf_PR_plotscale([1/6 1/5 1/4 1/3 1/2 1 2 3 4 5 6]);
    end
    
    
    % young2ref EMF map - 1.5°C - per extreme
    cbh = mf_plot_dom2(lon_mod, lat_mod, EMF_map_young2ref_15(i).perextreme_plot, [], island, caxes.EMF_perextreme, colormaps.EMF, 0, 2, panelletters_15{i}, ['1.5°C warming - ' extremes_legend{i} ' - ' num2str(age_young) 'yr compared to ' num2str(age_ref) 'yr'], 'Exposure multiplication factor'); hold on;
    set(cbh,'XTickLabel',XTickLabel_perextreme, 'Xtick', XTicks_perextreme)
    imagesc([pictogram_dims(i,1) pictogram_dims(i,2)], [pictogram_dims(i,3) pictogram_dims(i,4)], pictogram); hold off   % add pictogram
    export_fig(['figures/EMF_map_young2ref_15_' extremes{i} '_lowres.png' ], '-transparent');
    % export_fig(['figures/EMF_map_young2ref_15_' extremes{i} '_highres.png' ], '-transparent', '-m10'); close all;

    
    % young2ref EMF map - NDC - per extreme
    cbh = mf_plot_dom2(lon_mod, lat_mod, EMF_map_young2ref_NDC(i).perextreme_plot, [], island, caxes.EMF_perextreme, colormaps.EMF, 0, 2, panelletters_NDC{i}, ['Current pledges - ' extremes_legend{i} ' - ' num2str(age_young) 'yr compared to ' num2str(age_ref) 'yr'], 'Exposure multiplication factor'); hold on;
    set(cbh,'XTickLabel',XTickLabel_perextreme, 'Xtick', XTicks_perextreme)
    imagesc([pictogram_dims(i,1) pictogram_dims(i,2)], [pictogram_dims(i,3) pictogram_dims(i,4)], pictogram); hold off   % add pictogram
    export_fig(['figures/EMF_map_young2ref_NDC_' extremes{i} '_lowres.png' ], '-transparent');
    % export_fig(['figures/EMF_map_young2ref_NDC_' extremes{i} '_highres.png' ], '-transparent', '-m10'); close all;

    
end



    
end
   


% --------------------------------------------------------------------
% figure for overshoot/no overshoot paper of Nico Bauer
% --------------------------------------------------------------------


if flags.plot_4Nico == 1


    
% -----------------------------
% Prepare visualisation
% -----------------------------

   
% define reference age for figure
age_ref_plot = 60;


% define colors
color_noOS = colors(27,:);
color_OS   = colors(25,:);


% loop over regions
for ind_region=1:nregions
    
    % loop over extremes
    for ind_extreme =1:nextremes

        
        % get number of extreme events - panel c
        exposure_plot_noOS = squeeze(exposure_perregion_noOS(ind_extreme, ind_region, :));
        exposure_plot_OS   = squeeze(exposure_perregion_OS(  ind_extreme, ind_region, :));


        % get q25 of Exposure Multiplication Factors (EMF) - panel c
        exposure_plot_q25_noOS = squeeze(exposure_perregion_q25_noOS(ind_extreme, ind_region, :));
        exposure_plot_q25_OS   = squeeze(exposure_perregion_q25_OS(  ind_extreme, ind_region, :));


        % get q75 of Exposure Multiplication Factors (EMF) - panel c
        exposure_plot_q75_noOS = squeeze(exposure_perregion_q75_noOS(ind_extreme, ind_region, :));
        exposure_plot_q75_OS   = squeeze(exposure_perregion_q75_OS(  ind_extreme, ind_region, :));

        
        % visualisation
        figure
        set(gcf, 'color', 'w');
        set(gca,'color','w');


        % get max y-axis range
        ymax = max([exposure_plot_q75_OS(end) exposure_plot_q75_noOS(end)]);


        % visualisation
        h(1) = plot(ages, exposure_plot_OS  , '-', 'linewidth', 3, 'color', color_OS  ); hold on;
        h(3) = plot(ages, exposure_plot_noOS, '-', 'linewidth', 3, 'color', color_noOS); hold on;
        h(4) = plot(0.1, 0.1 , 'w'); hold on;                                                                    % dummy data to have y-axis starting at 0
        h(5) = plot(0.1, ymax, 'w'); hold on;                                                                    % dummy data to have y-axis until end of the 'boxplots'
        set(gca, 'XDir','reverse', 'Fontsize', 11, 'Fontweight', 'Bold', 'Xcolor', boxcolor, 'Ycolor', boxcolor, 'box', 'off');
        xlabel('Age of person in 2020', 'Fontsize', 12, 'Fontweight', 'Bold'); 
        ylabel('Exposure over lifetime [-]', 'Fontsize', 12, 'Fontweight', 'Bold'); 


        % add title
        ylims = ylim; % get y-axis limits
        text(ages(1), ylims(2) + ylims(2)*0.01, [extremes_legend{ind_extreme} ' exposure - '   regions.name{ind_region}],'ver','bottom','hor','left','Fontsize', 12, 'Fontweight', 'bold', 'color', boxcolor)


        % create new axes for 'boxplots'
        axlims     = [1 16 ylim];              % axes limits of 'boxplot' panel
        ax4_pos    = get(gca, 'position');     % get axis position
        ax4_pos(1) = 0.92;                     % left bound to the right
        ax4_pos(3) = 0.06;                     % shrink width
        ax4        = axes('Position',ax4_pos); % generate new axes


        % plot 'boxplots': rectangle and horizontal line
        rectangle('Position', [1, exposure_plot_q25_noOS(end), 4, exposure_plot_q75_noOS(end) - exposure_plot_q25_noOS(end)], 'FaceColor', [color_noOS 0.5], 'EdgeColor', 'none', 'LineWidth', 3); hold on; % +- 1 std
        rectangle('Position', [9, exposure_plot_q25_OS(  end), 4, exposure_plot_q75_OS(  end) - exposure_plot_q25_OS(  end)], 'FaceColor', [color_OS   0.5], 'EdgeColor', 'none', 'LineWidth', 3); hold on;
        plot([1 5 ], [exposure_plot_noOS(end) exposure_plot_noOS(end)], '-', 'linewidth', 3, 'color', color_noOS); hold on;
        plot([9 13], [exposure_plot_OS(  end) exposure_plot_OS(  end)], '-', 'linewidth', 3, 'color', color_OS  ); hold on;


        % Add labels
        text(2 , max(0, exposure_plot_q25_noOS(end)), 'no overshoot  ', 'color', color_noOS, 'Fontsize', 12, 'Fontweight', 'Bold', 'Rotation', 90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle')
        text(10, max(0, exposure_plot_q25_OS(end))  , 'overshoot  '   , 'color', color_OS  , 'Fontsize', 12, 'Fontweight', 'Bold', 'Rotation', 90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle')


        % finalise 'boxplot' plotting
        axis(axlims);
        set(gca, 'position', ax4_pos, 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
        axis off


        % save figure
        export_fig(['figures/for_nico/exposure_region_GMT_perscenario_' regions.name{ind_region} '_' extremes_legend{ind_extreme} '.png'], '-transparent');

        
        % clean up
        close all

    end
    
end
    
end



% --------------------------------------------------------------------
% Maps per RCP
% --------------------------------------------------------------------


if flags.plot_maps_rcp == 1

    
% initialise arrays
EMF_map_young2ref_rcp26_allhazards = NaN(nlat, nlon);
EMF_map_young2ref_rcp60_allhazards = NaN(nlat, nlon);


% loop over countries
for ind_country = 1:ncountries

    % reconstruct global map
    EMF_map_young2ref_rcp26_allhazards(countries.mask{ind_country}) = EMF_rcp26(nextremes + 1, ind_country, ages==age_young);
    EMF_map_young2ref_rcp60_allhazards(countries.mask{ind_country}) = EMF_rcp60(nextremes + 1, ind_country, ages==age_young);
    
end


% rescale for plotting
EMF_map_young2ref_rcp26_allhazards_plot = mf_PR_plotscale(EMF_map_young2ref_rcp26_allhazards);
EMF_map_young2ref_rcp60_allhazards_plot = mf_PR_plotscale(EMF_map_young2ref_rcp60_allhazards);


% young2ref EMF map - RCP2.6 - all hazards
cbh = mf_plot_dom2(lon_mod, lat_mod, EMF_map_young2ref_rcp26_allhazards_plot, [], island, caxes.EMF_plot, colormaps.EMF, 0, 2, 'a', ['RCP2.6 - ' num2str(age_young) 'yr compared to ' num2str(age_ref) 'yr'], 'Exposure multiplication factor'); hold on;
set(cbh,'XTickLabel',{'\div5','\div4','\div3','\div2','\times1','\times2','\times3','\times4','\times5'}, 'Xtick', mf_PR_plotscale([1/5 1/4 1/3 1/2 1 2 3 4 5]))
imagesc([pictogram_dims(nextremes+1,1) pictogram_dims(nextremes+1,2)], [pictogram_dims(nextremes+1,3) pictogram_dims(nextremes+1,4)], pictogram_all_2x3); hold off   % add pictogram
export_fig figures/EMF_map_young2ref_rcp26_allhazards_lowres.png  -transparent;
% export_fig figures/EMF_map_young2ref_rcp26_allhazards_highres.png -m10 -transparent; close all;


% young2ref EMF map - RCP6.0 - all hazards
cbh = mf_plot_dom2(lon_mod, lat_mod, EMF_map_young2ref_rcp60_allhazards_plot, [], island, caxes.EMF_plot, colormaps.EMF, 0, 2, 'b', ['RCP6.0 - ' num2str(age_young) 'yr compared to ' num2str(age_ref) 'yr'], 'Exposure multiplication factor'); hold on;
set(cbh,'XTickLabel',{'\div5','\div4','\div3','\div2','\times1','\times2','\times3','\times4','\times5'}, 'Xtick', mf_PR_plotscale([1/5 1/4 1/3 1/2 1 2 3 4 5]))
imagesc([pictogram_dims(nextremes+1,1) pictogram_dims(nextremes+1,2)], [pictogram_dims(nextremes+1,3) pictogram_dims(nextremes+1,4)], pictogram_all_2x3); hold off   % add pictogram
export_fig figures/EMF_map_young2ref_rcp60_allhazards_lowres.png  -transparent;
% export_fig figures/EMF_map_young2ref_rcp60_allhazards_highres.png  -m10 -transparent; close all;


% loop over extremes
for i=1:nextremes    
    
    % initialise array
    EMF_map_young2ref_rcp60(i).perextreme = NaN(nlat, nlon);

    % loop over countries
    for ind_country = 1:ncountries
        EMF_map_young2ref_rcp60(i).perextreme(countries.mask{ind_country}) = EMF_rcp60(i, ind_country, ages==age_young);
    end
    
    % rescale for plotting
    EMF_map_young2ref_rcp60(i).perextreme_plot = mf_PR_plotscale(EMF_map_young2ref_rcp60(i).perextreme); 

    % load pictograms
    pictogram = imcomplement(imread(['pictogram_' extremes{i} '.png']));

    % young2ref EMF map - RCP6.0 - per extreme
    cbh = mf_plot_dom2(lon_mod, lat_mod, EMF_map_young2ref_rcp60(i).perextreme_plot, [], island, caxes.EMF_plot, colormaps.EMF, 0, 2, alphabet(i), ['RCP6.0 - ' extremes_legend{i} ' - ' num2str(age_young) 'yr compared to ' num2str(age_ref) 'yr'], 'Exposure multiplication factor'); hold on;
    set(cbh,'XTickLabel',{'\div5','\div4','\div3','\div2','\times1','\times2','\times3','\times4','\times5'}, 'Xtick', mf_PR_plotscale([1/5 1/4 1/3 1/2 1 2 3 4 5]))
    imagesc([pictogram_dims(i,1) pictogram_dims(i,2)], [pictogram_dims(i,3) pictogram_dims(i,4)], pictogram); hold off   % add pictogram
    export_fig(['figures/EMF_map_young2ref_rcp60_' extremes{i} '_lowres.png' ], '-transparent');
    % export_fig(['figures/EMF_map_young2ref_rcp60_' extremes{i} '_highres.png' ], '-transparent', '-m10'); close all;

end
    

end



% --------------------------------------------------------------------
% Maps per GMT
% --------------------------------------------------------------------


if flags.plot_maps_gmt == 1

    
% initialise arrays
EMF_map_young2ref_15_allhazards   = NaN(nlat, nlon);
EMF_map_young2ref_20_allhazards   = NaN(nlat, nlon);
EMF_map_young2ref_NDC_allhazards  = NaN(nlat, nlon);
exposure_map_young_15_allhazards  = NaN(nlat, nlon);
exposure_map_young_NDC_allhazards = NaN(nlat, nlon);
exposure_map_ref_15_allhazards    = NaN(nlat, nlon);
exposure_map_ref_NDC_allhazards   = NaN(nlat, nlon);


% loop over countries
for ind_country = 1:ncountries

    % reconstruct global map
    EMF_map_young2ref_15_allhazards( countries.mask{ind_country}) = EMF_15( nextremes + 1, ind_country, ages==age_young);
    EMF_map_young2ref_20_allhazards( countries.mask{ind_country}) = EMF_20( nextremes + 1, ind_country, ages==age_young);
    EMF_map_young2ref_NDC_allhazards(countries.mask{ind_country}) = EMF_NDC(nextremes + 1, ind_country, ages==age_young);
            
    % exposure - young
    exposure_map_young_15_allhazards( countries.mask{ind_country}) = exposure_15( nextremes + 1, ind_country, ages==age_young);
    exposure_map_young_NDC_allhazards(countries.mask{ind_country}) = exposure_NDC(nextremes + 1, ind_country, ages==age_young);

    % exposure - ref
    exposure_map_ref_15_allhazards( countries.mask{ind_country})   = exposure_15( nextremes + 1, ind_country, ages==age_ref);
    exposure_map_ref_NDC_allhazards(countries.mask{ind_country})   = exposure_NDC(nextremes + 1, ind_country, ages==age_ref);

end

               
% rescale for plotting
EMF_map_young2ref_15_allhazards_plot  = mf_PR_plotscale(EMF_map_young2ref_15_allhazards);
EMF_map_young2ref_20_allhazards_plot  = mf_PR_plotscale(EMF_map_young2ref_20_allhazards);
EMF_map_young2ref_NDC_allhazards_plot = mf_PR_plotscale(EMF_map_young2ref_NDC_allhazards);


% young2ref EMF map - NDC - all hazards
cbh = mf_plot_dom2(lon_mod, lat_mod, EMF_map_young2ref_NDC_allhazards_plot, [], island, caxes.EMF_plot, colormaps.EMF, 0, 2, 'a', ['Current pledges - ' num2str(age_young) 'yr compared to ' num2str(age_ref) 'yr'], 'Exposure multiplication factor'); hold on;
set(cbh,'XTickLabel',{'\div6','\div5','\div4','\div3','\div2','\times1','\times2','\times3','\times4','\times5','\times6'}, 'Xtick', mf_PR_plotscale([1/6 1/5 1/4 1/3 1/2 1 2 3 4 5 6]))
imagesc([pictogram_dims(nextremes+1,1) pictogram_dims(nextremes+1,2)], [pictogram_dims(nextremes+1,3) pictogram_dims(nextremes+1,4)], pictogram_all_2x3); hold off   % add pictogram
export_fig figures/EMF_map_young2ref_NDC_allhazards_lowres_maxdiff02.png  -transparent;
% export_fig figures/EMF_map_young2ref_NDC_allhazards_lowres_geomean_on_EMF_maxdiff02.png  -transparent;
% export_fig figures/EMF_map_young2ref_NDC_allhazards_highres.png  -m10 -transparent; close all;


% % % % young2ref EMF map - 2.0°C - all hazards
% % % cbh = mf_plot_dom2(lon_mod, lat_mod, EMF_map_young2ref_20_allhazards_plot, [], island, caxes.EMF_plot, colormaps.EMF, 0, 2, 'b', ['2.0°C warming - ' num2str(age_young) 'yr compared to ' num2str(age_ref) 'yr'], 'Exposure multiplication factor'); hold on;
% % % set(cbh,'XTickLabel',{'\div6','\div5','\div4','\div3','\div2','\times1','\times2','\times3','\times4','\times5','\times6'}, 'Xtick', mf_PR_plotscale([1/6 1/5 1/4 1/3 1/2 1 2 3 4 5 6]))
% % % imagesc([pictogram_dims(nextremes+1,1) pictogram_dims(nextremes+1,2)], [pictogram_dims(nextremes+1,3) pictogram_dims(nextremes+1,4)], pictogram_all_2x3); hold off   % add pictogram
% % % export_fig figures/EMF_map_young2ref_20_allhazards_lowres_maxdiff02.png  -transparent;
% % % % export_fig figures/EMF_map_young2ref_20_allhazards_lowres_harmmean_on_EMF_maxdiff01.png  -transparent;
% % % % export_fig figures/EMF_map_young2ref_20_allhazards_lowres_geomean_on_EMF_maxdiff02.png  -transparent;
% % % % export_fig figures/EMF_map_young2ref_20_allhazards_highres.png  -m10 -transparent; close all;


% young2ref EMF map - 1.5°C - all hazards
cbh = mf_plot_dom2(lon_mod, lat_mod, EMF_map_young2ref_15_allhazards_plot, [], island, caxes.EMF_plot, colormaps.EMF, 0, 2, 'b', ['1.5°C warming - ' num2str(age_young) 'yr compared to ' num2str(age_ref) 'yr'], 'Exposure multiplication factor'); hold on;
set(cbh,'XTickLabel',{'\div6','\div5','\div4','\div3','\div2','\times1','\times2','\times3','\times4','\times5','\times6'}, 'Xtick', mf_PR_plotscale([1/6 1/5 1/4 1/3 1/2 1 2 3 4 5 6]))
imagesc([pictogram_dims(nextremes+1,1) pictogram_dims(nextremes+1,2)], [pictogram_dims(nextremes+1,3) pictogram_dims(nextremes+1,4)], pictogram_all_2x3); hold off   % add pictogram
export_fig figures/EMF_map_young2ref_15_allhazards_lowres_maxdiff02.png  -transparent;
% export_fig figures/EMF_map_young2ref_15_allhazards_lowres_harmmean_on_EMF_maxdiff01.png  -transparent;
% export_fig figures/EMF_map_young2ref_15_allhazards_lowres_geomean_on_EMF_maxdiff02.png  -transparent;
% export_fig figures/EMF_map_young2ref_15_allhazards_highres.png -m10 -transparent; close all;




% % % % young2ref delta exposure map - 1.5°C - all hazards
% % % cbh = mf_plot_dom2(lon_mod, lat_mod, exposure_map_young_15_allhazards - exposure_map_ref_15_allhazards, [], island, caxes.dexposure, colormaps.dexposure, 0, 2, alphabet(i), [num2str(age_young) 'yr compared to ' num2str(age_ref) 'yr'], 'Change in exposure under 1.5°C [-]'); hold on;
% % % imagesc([pictogram_dims(nextremes+1,1) pictogram_dims(nextremes+1,2)], [pictogram_dims(nextremes+1,3) pictogram_dims(nextremes+1,4)], pictogram_all_2x3); hold off   % add pictogram
% % % export_fig(['figures/dexposure_map_young2ref_15_allhazards_lowres.png' ], '-transparent');
% % % % export_fig(['figures/avoidance_map_young2ref_15_allhazards_highres.png' ], '-transparent', '-m10'); close all;
% % % 
% % % 
% % % % young2ref delta exposure map - NDC - all hazards
% % % cbh = mf_plot_dom2(lon_mod, lat_mod, exposure_map_young_NDC_allhazards - exposure_map_ref_NDC_allhazards, [], island, caxes.dexposure, colormaps.dexposure, 0, 2, alphabet(i), [num2str(age_young) 'yr compared to ' num2str(age_ref) 'yr'], 'Change in exposure under current pledges [-]'); hold on;
% % % imagesc([pictogram_dims(nextremes+1,1) pictogram_dims(nextremes+1,2)], [pictogram_dims(nextremes+1,3) pictogram_dims(nextremes+1,4)], pictogram_all_2x3); hold off   % add pictogram
% % % export_fig(['figures/dexposure_map_young2ref_NDC_allhazards_lowres.png' ], '-transparent');
% % % % export_fig(['figures/avoidance_map_young2ref_NDC_allhazards_highres.png' ], '-transparent', '-m10'); close all;
% % % 
% % % 
% % % % loop over extremes
% % % for i=5%1:nextremes    
% % %     
% % %     % initialise arrays
% % %     EMF_map_young2ref_15(i).perextreme       = NaN(nlat, nlon);
% % %     EMF_map_young2ref_NDC(i).perextreme      = NaN(nlat, nlon);
% % %     exposure_map_young2ref_15(i).perextreme  = NaN(nlat, nlon);
% % %     exposure_map_young2ref_NDC(i).perextreme = NaN(nlat, nlon);
% % % 
% % %     
% % %     % loop over countries
% % %     for ind_country = 1:ncountries
% % %         
% % %         % EMF
% % %         EMF_map_young2ref_NDC(i).perextreme(countries.mask{ind_country}) = EMF_NDC(i, ind_country, ages==age_young);
% % %         EMF_map_young2ref_15(i).perextreme( countries.mask{ind_country}) = EMF_15( i, ind_country, ages==age_young);
% % %         
% % %         % exposure
% % %         exposure_map_young2ref_NDC(i).perextreme(countries.mask{ind_country}) = exposure_NDC(i, ind_country, ages==age_young);
% % %         exposure_map_young2ref_15(i).perextreme( countries.mask{ind_country}) = exposure_15( i, ind_country, ages==age_young);
% % %         
% % %     end
% % %     
% % %     
% % %     % rescale for plotting
% % %     EMF_map_young2ref_15(i).perextreme_plot  = mf_PR_plotscale(EMF_map_young2ref_15(i).perextreme ); 
% % %     EMF_map_young2ref_NDC(i).perextreme_plot = mf_PR_plotscale(EMF_map_young2ref_NDC(i).perextreme); 
% % % 
% % %     
% % %     % load pictograms
% % %     pictogram = imcomplement(imread(['pictogram_' extremes{i} '.png']));
% % % 
% % %     
% % %     % young2ref EMF map - 1.5°C - per extreme
% % %     cbh = mf_plot_dom2(lon_mod, lat_mod, EMF_map_young2ref_15(i).perextreme_plot, [], island, caxes.EMF_plot, colormaps.EMF, 0, 2, alphabet(i), ['1.5°C warming - ' extremes_legend{i} ' - ' num2str(age_young) 'yr compared to ' num2str(age_ref) 'yr'], 'Exposure multiplication factor'); hold on;
% % %     set(cbh,'XTickLabel',{'\div5','\div4','\div3','\div2','\times1','\times2','\times3','\times4','\times5'}, 'Xtick', mf_PR_plotscale([1/5 1/4 1/3 1/2 1 2 3 4 5]))
% % %     imagesc([pictogram_dims(i,1) pictogram_dims(i,2)], [pictogram_dims(i,3) pictogram_dims(i,4)], pictogram); hold off   % add pictogram
% % %     export_fig(['figures/EMF_map_young2ref_15_' extremes{i} '_lowres.png' ], '-transparent');
% % %     % export_fig(['figures/EMF_map_young2ref_15_' extremes{i} '_highres.png' ], '-transparent', '-m10'); close all;
% % % 
% % %     
% % %     % young2ref EMF map - NDC - per extreme
% % %     cbh = mf_plot_dom2(lon_mod, lat_mod, EMF_map_young2ref_NDC(i).perextreme_plot, [], island, caxes.EMF_plot, colormaps.EMF, 0, 2, alphabet(i), ['Current pledges - ' extremes_legend{i} ' - ' num2str(age_young) 'yr compared to ' num2str(age_ref) 'yr'], 'Exposure multiplication factor'); hold on;
% % %     set(cbh,'XTickLabel',{'\div5','\div4','\div3','\div2','\times1','\times2','\times3','\times4','\times5'}, 'Xtick', mf_PR_plotscale([1/5 1/4 1/3 1/2 1 2 3 4 5]))
% % %     imagesc([pictogram_dims(i,1) pictogram_dims(i,2)], [pictogram_dims(i,3) pictogram_dims(i,4)], pictogram); hold off   % add pictogram
% % %     export_fig(['figures/EMF_map_young2ref_NDC_' extremes{i} '_lowres.png' ], '-transparent');
% % %     % export_fig(['figures/EMF_map_young2ref_NDC_' extremes{i} '_highres.png' ], '-transparent', '-m10'); close all;
% % % 
% % % 
% % %     % Get avoidance as [%] - NOTE THAT WE ASSUME 60YR NDC AS BASELINE ALSO FOR 1.5°C IN THIS CASE
% % %     avoidance_map_young2ref(i).perextreme = (exposure_map_young2ref_NDC(i).perextreme - exposure_map_young2ref_15(i).perextreme) ./ exposure_map_young2ref_NDC(i).perextreme .* 100;
% % % 
% % %     % young2ref EMF map - 1.5°C - per extreme
% % %     cbh = mf_plot_dom2(lon_mod, lat_mod, avoidance_map_young2ref(i).perextreme, [], island, caxes.avoidance, colormaps.avoidance, 0, 2, alphabet(i), ['1.5°C warming - ' extremes_legend{i} ' - ' num2str(age_young) 'yr compared to ' num2str(age_ref) 'yr'], 'Avoided exposure under 1.5°C compared to current pledges [%]'); hold on;
% % %     imagesc([pictogram_dims(i,1) pictogram_dims(i,2)], [pictogram_dims(i,3) pictogram_dims(i,4)], pictogram); hold off   % add pictogram
% % %     export_fig(['figures/avoidance_map_young2ref_15_' extremes{i} '_lowres.png' ], '-transparent');
% % %     % export_fig(['figures/avoidance_map_young2ref_15_' extremes{i} '_highres.png' ], '-transparent', '-m10'); close all;
% % % 
% % %     
% % % end



end



% --------------------------------------------------------------------
% line plots per country per RCP per scenario
% --------------------------------------------------------------------


if flags.plot_cnt_rcp_scen == 1


% loop over countries
for ind_country = 1:ncountries


    % get number of extreme events
    exposure_country_plot_rcp26 = squeeze(exposure_rcp26(nextremes + 1, ind_country, :));
    exposure_country_plot_rcp60 = squeeze(exposure_rcp60(nextremes + 1, ind_country, :));


    % get associated Exposure Multiplication Factors (EMF)
    EMF_country_plot_rcp26 = squeeze(EMF_rcp26(nextremes + 1, ind_country, :));
    EMF_country_plot_rcp60 = squeeze(EMF_rcp60(nextremes + 1, ind_country, :));

    
    % visualisation
    figure
    set(gcf, 'color', 'w');
    h(1) = plot(ages, exposure_country_plot_rcp26, '-', 'linewidth', 3, 'color', [0.00,0.45,0.74]); hold on;
    h(2) = plot(ages, exposure_country_plot_rcp60, '-', 'linewidth', 3, 'color', [0.85,0.33,0.10]); hold on;
    h(3) = plot(0.1,0.1,'w'); hold on; % dummy data to have y-axis starting at 0
    set(gca, 'XDir','reverse', 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
    xlabel('Age in 2020', 'Fontsize', 15, 'Fontweight', 'Bold'); 
    ylabel('Extreme event exposure', 'Fontsize', 15, 'Fontweight', 'Bold'); 
    legend(h(1:2), 'RCP2.6', 'RCP6.0', 'location', 'Northwest');
    set(legend, 'box', 'off', 'Fontweight', 'Bold', 'Fontsize', 14, 'textcolor', axcolor);
    
        
    % add exposure multiplication factors (EMF)
    for i=1:min(ceil(nanmax(nanmax(EMF_country_plot_rcp26, EMF_country_plot_rcp60))), 50)
        text(4, i .* exposure_country_plot_rcp60(1),['\times' num2str(i)], 'Fontsize', 13, 'Fontweight', 'Bold', 'Color', axcolor, 'VerticalAlignment', 'middle')
    end
    hold off;
    
    
    % move axes up to make room for age groups
    voffset  = 0.05;                 % set vertical offset
    axpos    = get(gca, 'position'); % get axis position
    axpos(2) = axpos(2) + voffset;   % move up bottom bound
    axpos(4) = axpos(4) - voffset;   % shrink height
    set(gca, 'position', axpos);     % apply new axes position
    
    
    % add age groups (horizontal: data units; vertical: normalised units)
    for i=1:size(agegroups,1)
          mf_dataTextbox([agegroups{i,2}-year_start agegroups{i,3}-year_start], [0.001 0.04], agegroups{i,1}, axcolor, axcolor, 'w');
    end


    % add country as text
    ylims = ylim;
    text(ages(1), ylims(2) + ylims(2)*0.01, countries.name{ind_country},'ver','bottom','hor','left','Fontsize', 15, 'Fontweight', 'bold', 'color', axcolor)


    % plot pictograms
    ax2 = axes('Position',[0.5 0.93 0.5 0.07]); % generate new axes
    imagesc(pictogram_all_1x6); hold off        % add pictogram
    axis('off', 'image');                       % remove axes


    % save figure
    export_fig(['figures/per_country/exposure_country_RCP_perscenario_' countries.name{ind_country} '.png'], '-transparent');

    
    % clean up
    close all


end


end



% --------------------------------------------------------------------
% area plots per country per RCP per hazard
% --------------------------------------------------------------------


if flags.plot_cnt_rcp_haz == 1


% loop over countries
for ind_country = 1:ncountries
    
    
    % get number of extreme events
    exposure_country_plot_rcp60 = squeeze(exposure_rcp60(nextremes + 1, ind_country, :));


    % get associated Exposure Multiplication Factors (EMF)
    EMF_country_plot_rcp60 = squeeze(EMF_rcp60(nextremes + 1, ind_country, :));

    
    % visualisation
    figure
    set(gcf, 'color', 'w');
    h = area(flipud(ages), flipud(permute(exposure_rcp60(1:nextremes, ind_country, :), [3 1 2])));
    h(1).FaceColor = colors(34,:);
    h(2).FaceColor = colors(36,:);
    h(3).FaceColor = colors(35,:);
    h(4).FaceColor = colors(33,:);
    h(5).FaceColor = colors(16,:);
    h(6).FaceColor = colors(17,:);
    set(h,'EdgeColor','none')
    title([countries.name{ind_country} ' - RCP6.0'], 'color', axcolor)
    set(gca, 'XDir','reverse', 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
    xlabel('Age in 2020', 'Fontsize', 15, 'Fontweight', 'Bold'); 
    ylabel('Extreme event exposure', 'Fontsize', 15, 'Fontweight', 'Bold'); 
    legend(h, extremes_legend, 'location', 'Northwest');
    set(legend, 'box', 'off', 'Fontweight', 'Bold', 'Fontsize', 13, 'textcolor', axcolor);
    hold off;


    % add exposure multiplication factors (EMF)
    for i=1:min(ceil(nanmax(EMF_country_plot_rcp60)), 50)
        text(4, i .* exposure_country_plot_rcp60(1),['\times' num2str(i)], 'Fontsize', 13, 'Fontweight', 'Bold', 'Color', axcolor, 'VerticalAlignment', 'middle')
    end
    hold off;
    
    
    % move axes up to make room for age groups
    voffset  = 0.05;                 % set vertical offset
    axpos    = get(gca, 'position'); % get axis position
    axpos(2) = axpos(2) + voffset;   % move up bottom bound
    axpos(4) = axpos(4) - voffset;   % shrink height
    set(gca, 'position', axpos);     % apply new axes position
    
    
    % add age groups (horizontal: data units; vertical: normalised units)
    for i=1:size(agegroups,1)
          mf_dataTextbox([agegroups{i,2}-year_start agegroups{i,3}-year_start], [0.001 0.04], agegroups{i,1}, axcolor, axcolor, 'w');
    end

    
    % save figure
    export_fig(['figures/per_country/exposure_country_RCP_perhazard_' countries.name{ind_country} '.png'], '-transparent');

    
    % clean up
    close all


end

end



% --------------------------------------------------------------------
% line plots per country per GMT per scenario
% --------------------------------------------------------------------


if flags.plot_cnt_gmt_scen == 1


% loop over countries
for ind_country = 1:ncountries

    
    % call plotting function
    mf_plot_scenarios(exposure_15    , exposure_20    , exposure_NDC    , ...
                      EMF_15         , EMF_20         , EMF_NDC         , ...
                      exposure_mms_15, exposure_mms_20, exposure_mms_NDC, ...
                      ages, agegroups, countries, year_start, nextremes, ind_country)


    % save figure
    export_fig(['figures/per_country/exposure_country_GMT_perscenario_' countries.name{ind_country} '.png'], '-transparent');

    
    % clean up
    close all


end


end



% --------------------------------------------------------------------
% area plots per country per GMT per hazard
% --------------------------------------------------------------------


if flags.plot_cnt_gmt_haz == 1


% loop over countries
for ind_country = 1:ncountries
    
    
    % get number of extreme events
    exposure_country_plot_NDC = squeeze(exposure_NDC(nextremes + 1, ind_country, :));


    % get associated Exposure Multiplication Factors (EMF)
    EMF_country_plot_NDC = squeeze(EMF_NDC(nextremes + 1, ind_country, :));

    
    % visualisation
    figure
    set(gcf, 'color', 'w');
    h = area(flipud(ages), flipud(permute(exposure_NDC(1:nextremes, ind_country, :), [3 1 2])));
    h(1).FaceColor = colors(34,:);
    h(2).FaceColor = colors(36,:);
    h(3).FaceColor = colors(35,:);
    h(4).FaceColor = colors(33,:);
    h(5).FaceColor = colors(16,:);
    h(6).FaceColor = colors(17,:);
    set(h,'EdgeColor','none')
    title([countries.name{ind_country} ' - Current pledges'], 'color', axcolor)
    set(gca, 'XDir','reverse', 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
    xlabel('Age in 2020', 'Fontsize', 15, 'Fontweight', 'Bold'); 
    ylabel('Extreme event exposure', 'Fontsize', 15, 'Fontweight', 'Bold'); 
    legend(h, extremes_legend, 'location', 'Northwest');
    set(legend, 'box', 'off', 'Fontweight', 'Bold', 'Fontsize', 13, 'textcolor', axcolor);
    hold off;


    % add exposure multiplication factors (EMF)
    for i=1:min(ceil(nanmax(EMF_country_plot_NDC)), 50)
        text(4, i .* exposure_country_plot_NDC(1),['\times' num2str(i)], 'Fontsize', 13, 'Fontweight', 'Bold', 'Color', axcolor, 'VerticalAlignment', 'middle')
    end
    hold off;
    
    
    % move axes up to make room for age groups
    voffset  = 0.05;                 % set vertical offset
    axpos    = get(gca, 'position'); % get axis position
    axpos(2) = axpos(2) + voffset;   % move up bottom bound
    axpos(4) = axpos(4) - voffset;   % shrink height
    set(gca, 'position', axpos);     % apply new axes position
    
    
    % add age groups (horizontal: data units; vertical: normalised units)
    for i=1:size(agegroups,1)
          mf_dataTextbox([agegroups{i,2}-year_start agegroups{i,3}-year_start], [0.001 0.04], agegroups{i,1}, axcolor, axcolor, 'w');
    end

    
    % save figure
    export_fig(['figures/per_country/exposure_country_GMT_perhazard_' countries.name{ind_country} '.png'], '-transparent');

    
    % clean up
    close all


end

end




% --------------------------------------------------------------------
% line plots per region per RCP per scenario
% --------------------------------------------------------------------


if flags.plot_reg_rcp_scen == 1


% loop over regions
for ind_region = 1:nregions


    % get number of extreme events
    exposure_region_plot_rcp26 = squeeze(exposure_perregion_rcp26(nextremes + 1, ind_region, :));
    exposure_region_plot_rcp60 = squeeze(exposure_perregion_rcp60(nextremes + 1, ind_region, :));


    % get associated Exposure Multiplication Factors (EMF)
    EMF_region_plot_rcp26 = squeeze(EMF_perregion_rcp26(nextremes + 1, ind_region, :));
    EMF_region_plot_rcp60 = squeeze(EMF_perregion_rcp60(nextremes + 1, ind_region, :));

    
    % visualisation
    figure
    set(gcf, 'color', 'w');
    h(1) = plot(ages, exposure_region_plot_rcp26, '-', 'linewidth', 3, 'color', [0.00,0.45,0.74]); hold on;
    h(2) = plot(ages, exposure_region_plot_rcp60, '-', 'linewidth', 3, 'color', [0.85,0.33,0.10]); hold on;
    h(3) = plot(0.1,0.1,'w'); hold on; % dummy data to have y-axis starting at 0
    set(gca, 'XDir','reverse', 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
    xlabel('Age in 2020', 'Fontsize', 15, 'Fontweight', 'Bold'); 
    ylabel('Extreme event exposure', 'Fontsize', 15, 'Fontweight', 'Bold'); 
    legend(h(1:2), 'RCP2.6', 'RCP6.0', 'location', 'Northwest');
    set(legend, 'box', 'off', 'Fontweight', 'Bold', 'Fontsize', 14, 'textcolor', axcolor);

    
    % add exposure multiplication factors (EMF)
    for i=1:min(ceil(nanmax(nanmax(EMF_region_plot_rcp26, EMF_region_plot_rcp60))), 50)
        text(4, i .* exposure_region_plot_rcp60(1),['\times' num2str(i)], 'Fontsize', 13, 'Fontweight', 'Bold', 'Color', axcolor, 'VerticalAlignment', 'middle')
    end
    hold off;
    
    
    % move axes up to make room for age groups
    voffset  = 0.05;                 % set vertical offset
    axpos    = get(gca, 'position'); % get axis position
    axpos(2) = axpos(2) + voffset;   % move up bottom bound
    axpos(4) = axpos(4) - voffset;   % shrink height
    set(gca, 'position', axpos);     % apply new axes position
    
    
    % add age groups (horizontal: data units; vertical: normalised units)
    for i=1:size(agegroups,1)
          mf_dataTextbox([agegroups{i,2}-year_start agegroups{i,3}-year_start], [0.001 0.04], agegroups{i,1}, axcolor, axcolor, 'w');
    end


    % add region as text
    ylims = ylim;
    text(ages(1), ylims(2) + ylims(2)*0.01, regions.name{ind_region},'ver','bottom','hor','left','Fontsize', 15, 'Fontweight', 'bold', 'color', axcolor)


    % plot pictograms
    ax2 = axes('Position',[0.5 0.93 0.5 0.07]); % generate new axes
    imagesc(pictogram_all_1x6); hold off        % add pictogram
    axis('off', 'image');                       % remove axes

    
    % save figure
    export_fig(['figures/per_region/exposure_region_RCP_perscenario_' regions.name{ind_region} '.png'], '-transparent');

    
    % clean up
    close all


end


end



% --------------------------------------------------------------------
% area plots per region per RCP per hazard
% --------------------------------------------------------------------


if flags.plot_reg_rcp_haz == 1


% loop over regions
for ind_region = 1:nregions
    
    
    % get number of extreme events
    exposure_region_plot_rcp60 = squeeze(exposure_perregion_rcp60(nextremes + 1, ind_region, :));


    % get associated Exposure Multiplication Factors (EMF)
    EMF_region_plot_rcp60 = squeeze(EMF_perregion_rcp60(nextremes + 1, ind_region, :));

    
    % visualisation
    figure
    set(gcf, 'color', 'w');
    h = area(flipud(ages), flipud(permute(exposure_perregion_rcp60(1:nextremes, ind_region, :), [3 1 2])));
    h(1).FaceColor = colors(34,:);
    h(2).FaceColor = colors(36,:);
    h(3).FaceColor = colors(35,:);
    h(4).FaceColor = colors(33,:);
    h(5).FaceColor = colors(16,:);
    h(6).FaceColor = colors(17,:);
    set(h,'EdgeColor','none')
    title([regions.name{ind_region} ' - RCP6.0'], 'color', axcolor)
    set(gca, 'XDir','reverse', 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
    xlabel('Age in 2020', 'Fontsize', 15, 'Fontweight', 'Bold'); 
    ylabel('Extreme event exposure', 'Fontsize', 15, 'Fontweight', 'Bold'); 
    legend(h, extremes_legend, 'location', 'Northwest');
    set(legend, 'box', 'off', 'Fontweight', 'Bold', 'Fontsize', 13, 'textcolor', axcolor);
    hold off;


    % add exposure multiplication factors (EMF)
    for i=1:min(ceil(nanmax(EMF_region_plot_rcp60)), 50)
        text(4, i .* exposure_region_plot_rcp60(1),['\times' num2str(i)], 'Fontsize', 13, 'Fontweight', 'Bold', 'Color', axcolor, 'VerticalAlignment', 'middle')
    end
    hold off;
    
    
    % move axes up to make room for age groups
    voffset  = 0.05;                 % set vertical offset
    axpos    = get(gca, 'position'); % get axis position
    axpos(2) = axpos(2) + voffset;   % move up bottom bound
    axpos(4) = axpos(4) - voffset;   % shrink height
    set(gca, 'position', axpos);     % apply new axes position
    
    
    % add age groups (horizontal: data units; vertical: normalised units)
    for i=1:size(agegroups,1)
          mf_dataTextbox([agegroups{i,2}-year_start agegroups{i,3}-year_start], [0.001 0.04], agegroups{i,1}, axcolor, axcolor, 'w');
    end

    
    % save figure
    export_fig(['figures/per_region/exposure_region_RCP_perhazard_' regions.name{ind_region} '.png'], '-transparent');

    
    % clean up
    close all


end

end



% --------------------------------------------------------------------
% line plots per region per GMT per scenario
% --------------------------------------------------------------------


if flags.plot_reg_gmt_scen == 1


% loop over regions
for ind_region = 12%1:nregions


    % call plotting function
    mf_plot_scenarios(exposure_perregion_15    , exposure_perregion_20    , exposure_perregion_NDC    , ...
                      EMF_perregion_15         , EMF_perregion_20         , EMF_perregion_NDC         , ...
                      exposure_perregion_mms_15, exposure_perregion_mms_20, exposure_perregion_mms_NDC, ...
                      ages, agegroups, regions, year_start, nextremes, ind_region)


    % save figure
    export_fig(['figures/per_region/exposure_region_GMT_perscenario_' regions.name{ind_region} '.png'], '-transparent');


    % clean up
    close all


end


end



% --------------------------------------------------------------------
% area plots per region per GMT per hazard
% --------------------------------------------------------------------


if flags.plot_reg_gmt_haz == 1


% loop over regions
for ind_region = 12%1:nregions
    
    
% % %     % get number of extreme events
% % %     exposure_region_plot_NDC = squeeze(exposure_perregion_NDC(nextremes + 1, ind_region, :));
% % % 
% % % 
% % %     % get associated Exposure Multiplication Factors (EMF)
% % %     EMF_perregion_plot_NDC = squeeze(EMF_perregion_NDC(nextremes + 1, ind_region, :));
% % % 
% % %     
% % %     % visualisation
% % %     figure
% % %     set(gcf, 'color', 'w');
% % %     h = area(flipud(ages), flipud(permute(exposure_perregion_NDC(1:nextremes, ind_region, :), [3 1 2])));
% % %     h(1).FaceColor = colors(34,:);
% % %     h(2).FaceColor = colors(36,:);
% % %     h(3).FaceColor = colors(35,:);
% % %     h(4).FaceColor = colors(33,:);
% % %     h(5).FaceColor = colors(16,:);
% % %     h(6).FaceColor = colors(17,:);
% % %     set(h,'EdgeColor','none')
% % %     title([regions.name{ind_region} ' - Current pledges'], 'color', axcolor)
% % %     set(gca, 'XDir','reverse', 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
% % %     xlabel('Age in 2020', 'Fontsize', 15, 'Fontweight', 'Bold'); 
% % %     ylabel('Extreme event exposure', 'Fontsize', 15, 'Fontweight', 'Bold'); 
% % %     legend(h, extremes_legend, 'location', 'Northwest');
% % %     set(legend, 'box', 'off', 'Fontweight', 'Bold', 'Fontsize', 13, 'textcolor', axcolor);
% % %     hold off;
% % % 
% % % 
% % %     % add exposure multiplication factors (EMF)
% % %     for i=1:min(ceil(nanmax(EMF_perregion_plot_NDC)), 50)
% % %         text(4, i .* exposure_region_plot_NDC(1),['\times' num2str(i)], 'Fontsize', 13, 'Fontweight', 'Bold', 'Color', axcolor, 'VerticalAlignment', 'middle')
% % %     end
% % %     hold off;
% % %     
% % %     
% % %     % move axes up to make room for age groups
% % %     voffset  = 0.05;                 % set vertical offset
% % %     axpos    = get(gca, 'position'); % get axis position
% % %     axpos(2) = axpos(2) + voffset;   % move up bottom bound
% % %     axpos(4) = axpos(4) - voffset;   % shrink height
% % %     set(gca, 'position', axpos);     % apply new axes position
% % %     
% % %     
% % %     % add age groups (horizontal: data units; vertical: normalised units)
% % %     for i=1:size(agegroups,1)
% % %           mf_dataTextbox([agegroups{i,2}-year_start agegroups{i,3}-year_start], [0.001 0.04], agegroups{i,1}, axcolor, axcolor, 'w');
% % %     end


    mf_plot_hazards(exposure_perregion_NDC, EMF_perregion_NDC, ages, agegroups, regions, year_start, extremes_legend, nextremes, ind_region)

    
    % save figure
    export_fig(['figures/per_region/exposure_region_GMT_perhazard_' regions.name{ind_region} '_test.png'], '-transparent');

    
    % clean up
    close all


end

end




% --------------------------------------------------------------------
% area plots per region per GMT per hazard
% --------------------------------------------------------------------


if flags.plot_reg_gmt_haz_area == 1


% loop over regions
for ind_region = 12%1:nregions
    
    
    % get number of extreme events
    exposure_region_plot_NDC = squeeze(exposure_perregion_NDC(nextremes + 1, ind_region, :));


    % get associated Exposure Multiplication Factors (EMF)
    EMF_perregion_plot_NDC = squeeze(EMF_perregion_NDC(nextremes + 1, ind_region, :));

    
    % visualisation
    figure
    set(gcf, 'color', 'w');
    h = area(flipud(ages), flipud(permute(exposure_perregion_NDC(1:nextremes, ind_region, :), [3 1 2])));
    h(1).FaceColor = colors(34,:);
    h(2).FaceColor = colors(36,:);
    h(3).FaceColor = colors(35,:);
    h(4).FaceColor = colors(33,:);
    h(5).FaceColor = colors(16,:);
    h(6).FaceColor = colors(17,:);
    set(h,'EdgeColor','none')
    title([regions.name{ind_region} ' - Current pledges'], 'color', axcolor)
    set(gca, 'XDir','reverse', 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
    xlabel('Age in 2020', 'Fontsize', 15, 'Fontweight', 'Bold'); 
    ylabel('Extreme event exposure', 'Fontsize', 15, 'Fontweight', 'Bold'); 
    legend(h, extremes_legend, 'location', 'Northwest');
    set(legend, 'box', 'off', 'Fontweight', 'Bold', 'Fontsize', 13, 'textcolor', axcolor);
    hold off;


    % add exposure multiplication factors (EMF)
    for i=1:min(ceil(nanmax(EMF_perregion_plot_NDC)), 50)
        text(4, i .* exposure_region_plot_NDC(1),['\times' num2str(i)], 'Fontsize', 13, 'Fontweight', 'Bold', 'Color', axcolor, 'VerticalAlignment', 'middle')
    end
    hold off;
    
    
    % move axes up to make room for age groups
    voffset  = 0.05;                 % set vertical offset
    axpos    = get(gca, 'position'); % get axis position
    axpos(2) = axpos(2) + voffset;   % move up bottom bound
    axpos(4) = axpos(4) - voffset;   % shrink height
    set(gca, 'position', axpos);     % apply new axes position
    
    
    % add age groups (horizontal: data units; vertical: normalised units)
    for i=1:size(agegroups,1)
          mf_dataTextbox([agegroups{i,2}-year_start agegroups{i,3}-year_start], [0.001 0.04], agegroups{i,1}, axcolor, axcolor, 'w');
    end

    
    % save figure
    export_fig(['figures/per_region/exposure_region_GMT_perhazard_' regions.name{ind_region} '_test.png'], '-transparent');

    
    % clean up
    close all


end

end




% % --------------------------------------------------------------------
% % line plots all regions under NDC
% % --------------------------------------------------------------------
% 
% 
% if flags.plot_reg_gmt_allreg == 1
% 
% 
% % plot world regions
% mf_plot_regions_NDC(exposure_perregion_NDC, EMF_perregion_NDC, exposure_perregion_mms_NDC, ages, agegroups, regions, year_start, nextremes, ind_region)
% % export_fig('figures/per_region/exposure_region_GMT_perscenario_worldregions.png', '-transparent');
% export_fig('figures/per_region/exposure_region_GMT_perscenario_worldregions_geomean_maxdiff01.png', '-transparent');
% % export_fig('figures/per_region/exposure_region_GMT_perscenario_worldregions_CBcolors.png', '-transparent');
% 
% 
% % plot income regions
% mf_plot_regions_NDC(exposure_perregion_NDC, EMF_perregion_NDC, exposure_perregion_mms_NDC, ages, agegroups, regions, year_start, nextremes, ind_income)
% % export_fig('figures/per_region/exposure_region_GMT_perscenario_incomegroups.png', '-transparent');
% export_fig('figures/per_region/exposure_region_GMT_perscenario_incomegroups_geomean_maxdiff01.png', '-transparent');
% 
% 
% end



% --------------------------------------------------------------------
% Burning embers - EMF only
% --------------------------------------------------------------------


if flags.plot_reg_gmt_BE_EMF == 1


% loop over regions
% for ind_region = 1:nregions
for ind_region = [12]
  
    
%     for ind_extreme = 1:nextremes+1
    for ind_extreme = nextremes+1
        
    
        % get number of extreme events
        exposure_region_plot_BE = squeeze(exposure_perregion_BE(ind_extreme, ind_region, :, :))';


        % get associated Exposure Multiplication Factors (EMF)
        EMF_region_plot_BE = squeeze(EMF_perregion_young2ref_BE(ind_extreme, ind_region, :, :))';


        % visualisation
        figure
        set(gcf, 'color', 'w');
%         imagesc(ages,GMT_BE(end,:), exposure_region_plot_BE); 
        imagesc(ages,GMT_BE(end,:), EMF_region_plot_BE); hold on;
        cbh=colorbar;
        colormap(colormaps.BE_continuous)
        caxis(caxes.EMF_BE)
        set(gca, 'XDir', 'reverse', 'YDir', 'normal', 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
        xlabel('Age in 2020', 'Fontsize', 15, 'Fontweight', 'Bold'); 
        ylabel('GMT change relative to PI [°C]', 'Fontsize', 15, 'Fontweight', 'Bold'); 
        hold on;


        % add region as text
        text(ages(1),GMT_BE(end,end) + 0.03,regions.name{ind_region},'ver','bottom','hor','left','Fontsize', 16, 'Fontweight', 'bold', 'color', axcolor)

        
        % move axes up to make room for age groups
        voffset  = 0.05;                 % set vertical offset
        axpos    = get(gca, 'position'); % get axis position
        axpos(2) = axpos(2) + voffset;   % move up bottom bound
        axpos(4) = axpos(4) - voffset;   % shrink height
        set(gca, 'position', axpos);     % apply new axes position

        
        % Rework colorbar
        y1=get(gca,'position');                                                    % make colorbar thinner
        y=get(cbh,'Position');
        y(3)=0.025;
        set(cbh,'Position',y);
        set(gca,'position',y1);
        mf_cbarrow;                                                                 % add pointy ends
        for i=caxes.EMF_BE(1):caxes.EMF_BE(2)                                       % generate colorbar ticks
            BE_ticks(i)      = i; 
            BE_ticklabels{i} = ['\times' num2str(i)]; 
        end
        set(cbh, 'color', axcolor, 'Ticks', BE_ticks, 'Ticklabels', BE_ticklabels); % add ticks and labels
        
        
        % add age groups (horizontal: data units; vertical: normalised units)
        for i=1:size(agegroups,1)
              mf_dataTextbox([agegroups{i,2}-year_start agegroups{i,3}-year_start], [0.001 0.04], agegroups{i,1}, axcolor, axcolor, 'w');
        end
        

        % load and plot pictograms
        if ind_extreme == nextremes+1
            pictogram = pictogram_all_1x6;
        else
            pictogram = imadjust(imcomplement(imread(['pictogram_' extremes{ind_extreme} '.png'])),[0.3 0.3 0.3; 1 1 1],[]);
        end
        ax2 = axes('Position',[0.5 0.93 0.5 0.07]);
        imagesc(pictogram); hold off   % add pictogram
        axis('off', 'image');

        
        % save figure
%         export_fig(['figures/per_region/exposure_region_GMT_BE_' regions.name{ind_region} '_'  extremes_legend{ind_extreme} '.png'], '-transparent');
        export_fig(['figures/per_region/EMF_region_GMT_BE_' regions.name{ind_region} '_'  extremes_legend{ind_extreme} '_testttt.png'], '-transparent');


        % clean up
        close all


    end
    

end


end






% --------------------------------------------------------------------
% Burning embers - PCT and EMF
% --------------------------------------------------------------------


if flags.plot_reg_gmt_BE_PCT == 1


% loop over regions
% for ind_region = 1:nregions
for ind_region = 12
  
    
%     for ind_extreme = 1:nextremes+1
    for ind_extreme = nextremes+1
        
    
        % get percentages of extreme events
        PCT_region_plot_BE = mf_PCT_plotscale(squeeze(PCT_perregion_young2pic_BE(ind_extreme, ind_region, :, :))');

        
        % get associated Exposure Multiplication Factors (EMF)
        EMF_region_plot_BE = squeeze(EMF_perregion_young2pic_BE(ind_extreme, ind_region, :, :))';
        

        % visualisation
        figure
        set(gcf, 'color', 'w');
        imagesc(ages, GMT_BE(end,:), PCT_region_plot_BE); hold on;
        cbh=colorbar;
        colormap(colormaps.BE_pseudodiscrete)
        set(gca,'colorscale','log')
        caxis(caxes.PCT_BE_plot)
        set(gca, 'XDir', 'reverse', 'YDir', 'normal', 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
        xlabel('Age in 2020', 'Fontsize', 15, 'Fontweight', 'Bold'); 
        ylabel('GMT change relative to PI [°C]', 'Fontsize', 15, 'Fontweight', 'Bold'); 
        hold on;


        % add EMF contours
        color_EMF     = [0.95 0.95 0.95]; % very light grey
        [C, hcontour] = contour(ages, GMT_BE(end,:), EMF_region_plot_BE, 2:40, 'LineColor', color_EMF, 'LineWidth', 2, 'ShowText', 'on'); hold on;
        hcl           = clabel(C,hcontour, 'Color', color_EMF, 'FontSize', 11, 'Fontweight', 'bold');
 

        % add region as text
        text(ages(1),GMT_BE(end,end) + 0.03,regions.name{ind_region},'ver','bottom','hor','left','Fontsize', 16, 'Fontweight', 'bold', 'color', axcolor)

        
        % move axes up to make room for age groups
        voffset  = 0.05;                 % set vertical offset
        axpos    = get(gca, 'position'); % get axis position
        axpos(2) = axpos(2) + voffset;   % move up bottom bound
        axpos(4) = axpos(4) - voffset;   % shrink height
        set(gca, 'position', axpos);     % apply new axes position

        
        % add age groups (horizontal: data units; vertical: normalised units)
        for i=1:size(agegroups,1)
              mf_dataTextbox([agegroups{i,2}-year_start agegroups{i,3}-year_start], [0.001 0.04], agegroups{i,1}, axcolor, axcolor, 'w');
        end

        
        % Rework colorbar
        y1=get(gca,'position');                                                    % make colorbar thinner
        y=get(cbh,'Position');
        y(1)=y(1)+0.1;
        y(3)=0.025;
        set(cbh,'Position',y);
        set(gca,'position',y1);
        mf_cbarrow;                                                                % add pointy ends
        BE_PCT_ticks      = [];                                                    % initialise an empty array
        BE_PCT_ticklabels = [];                                                    % initialise an empty array
        for i=1:length(percentages)                                                % loop over percentages
            BE_PCT_ticks(i)      = mf_PCT_plotscale(percentages(i));               % generate colorbar ticks
            BE_PCT_ticklabels{i} = ['<' num2str(100-percentages(i)) '%'];                  % generate colorbar ticklabels
        end
        set(cbh, 'AxisLocation','in', 'Ticks', BE_PCT_ticks, 'Ticklabels', BE_PCT_ticklabels, 'color', axcolor,'Fontsize', 11, 'Fontweight', 'bold'); % add ticks and labels

        
        % load and plot pictograms
        if ind_extreme == nextremes+1
            pictogram = pictogram_all_1x6;
        else
            pictogram = imadjust(imcomplement(imread(['pictogram_' extremes{ind_extreme} '.png'])),[0.3 0.3 0.3; 1 1 1],[]);
        end
        ax2 = axes('Position',[0.5 0.93 0.5 0.07]);
        imagesc(pictogram); hold off   % add pictogram
        axis('off', 'image');

               
        % save figure
%         export_fig(['figures/per_region/PCT_EMFcont_region_GMT_BE_' regions.name{ind_region} '_'  extremes_legend{ind_extreme} '_sharptransitions.png'], '-transparent');
        export_fig(['figures/per_region/PCT_EMFcont_region_GMT_BE_' regions.name{ind_region} '_'  extremes_legend{ind_extreme} '_geomean_maxdiff02.png'], '-transparent');


        % clean up
        close all


    end
    

end


end
 
% attempt to have custom contour labels
% try also this: https://riptutorial.com/matlab/example/26052/contour-plots---customise-the-text-labels
% for i = 1:length(hcl)
%     oldLabelText = get(hcl(i), 'String');
%     percentage = str2double(oldLabelText)*100;
%     newLabelText = [num2str(percentage) ' %'];
%     set(hcl(i), 'String', newLabelText);
% end



% --------------------------------------------------------------------
% paper supplementary figure 1 - GMT pathways
% --------------------------------------------------------------------


if flags.plot_sfig1 == 1

    
% visualisation
figure
set(gcf, 'color', 'w');
plot(years_SR15, GMT_BE, 'color', axcolor); hold on;
h(1) = plot(years_SR15, GMT_NDC, 'color', colors(25,:), 'linewidth', 3); hold on;
h(2) = plot(years_SR15, GMT_20, 'color', colors(26,:), 'linewidth', 3); hold on;
h(3) = plot(years_SR15, GMT_15, 'color', colors(27,:), 'linewidth', 3); hold on;
plot(years_SR15(years_SR15<year_ref), GMT_NDC(years_SR15<year_ref), 'color', colors(28,:), 'linewidth', 3); hold on;
title('GMT trajectories', 'color', axcolor)
set(gca, 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
xlabel('Year', 'Fontsize', 15, 'Fontweight', 'Bold'); 
ylabel('GMT change relative to PI [°C]', 'Fontsize', 15, 'Fontweight', 'Bold'); 
legend(h(1:3), 'Current pledges', '2.0°C', '1.5°C', 'location', 'Northwest');
set(legend, 'box', 'off', 'Fontweight', 'Bold', 'Fontsize', 14, 'textcolor', axcolor);


% save figure
export_fig('figures/GMT_BE.png', '-transparent');


end


% --------------------------------------------------------------------
% paper supplementary figure 2 - world regions & incomee groups maps
% --------------------------------------------------------------------


if flags.plot_sfig2 == 1



% initialise arrays
regions_geographic = NaN(nlat, nlon);
regions_income     = NaN(nlat, nlon);

    
% loop over world regions
ind_regions_geographic = [1 2 4 7 8 9 10];
for i=1:length(ind_regions_geographic)

    % reconstruct global map
    regions_geographic(regions.mask{ind_regions_geographic(i)}) = i;
    
end


% loop over income groups
ind_regions_income = [5 6 11 3];
for i=1:length(ind_regions_income)

    % reconstruct global map
    regions_income(regions.mask{ind_regions_income(i)}) = i;
    
end


% region map - world regions
cbh = mf_plot_dom2(lon_mod, lat_mod, regions_geographic, [], island, caxes.regions_geographic, colormaps.regions_geographic, 0, 1, 'a', 'World regions', ' '); hold on;
set(cbh, 'color', axcolor, 'Ticks', 1:length(ind_regions_geographic), 'Ticklabels', regions.name(ind_regions_geographic), 'fontsize', 6.5, 'location', 'eastoutside'); % add ticks and labels
export_fig figures/regions_geographic_lowres.png  -transparent;
% export_fig figures/regions_geographic_highres.png -m10 -transparent; close all;


% region map - world regions
cbh = mf_plot_dom2(lon_mod, lat_mod, regions_income, [], island, caxes.regions_income, colormaps.regions_income, 0, 1, 'b', 'Income groups', ' '); hold on;
set(cbh, 'color', axcolor, 'Ticks', 1:length(ind_regions_income), 'Ticklabels', regions.name(ind_regions_income), 'fontsize', 7); % add ticks and labels
export_fig figures/regions_income_lowres.png  -transparent;
% export_fig figures/regions_income_highres.png -m10 -transparent; close all;



end



% --------------------------------------------------------------------
% paper supplementary figure 3 - BE per aggregation method
% --------------------------------------------------------------------



if flags.plot_sfig3 == 1


% get caxis per extreme
caxes.EMF_BE_pe = [1  4; ...   % burntarea
                   1  4; ...   % cropfailedarea
                   1  4; ...   % driedarea
                   1  4; ...   % floodedarea
                   1 30; ...   % heatwavedarea
                   1  4; ...   % tropicalcyclone
                   1  4  ];    % all
ticksteps       = [1; ...   % burntarea
                   1; ...   % cropfailedarea
                   1; ...   % driedarea
                   1; ...   % floodedarea
                   5; ...   % heatwavedarea
                   1; ...   % tropicalcyclone
                   1  ];    % all

    
% loop over regions
for ind_region = 12
  
    
    for ind_extreme = nextremes+1
        
    
        % get percentages of extreme events
        PCT_region_plot_BE = squeeze(PCT_perregion_young2pic_BE(ind_extreme, ind_region, :, :))';

        
        % --------------------------------
        % GEOMETRIC MEAN ON EMF (default)
        % --------------------------------
                
        % get associated Exposure Multiplication Factors (EMF)
        EMF_region_plot_BE = squeeze(EMF_perregion_young2pic_BE(ind_extreme, ind_region, :, :))';
        
        % call plotting function
        mf_plot_burning_embers(ages, GMT_BE, EMF_region_plot_BE, PCT_region_plot_BE, colormaps.BE_continuous, caxes.EMF_BE_pe(ind_extreme,:), ind_region, ind_extreme, age_ref, agegroups, regions, year_start, nextremes, panelletters_regions, extremes, extremes_legend, axcolor, 3, 'a Geometric mean on EMF')
               
        % save figure
        export_fig(['figures/burning_embers/EMF_PCTcont_region_GMT_BE_' regions.name{ind_region} '_'  extremes_legend{ind_extreme} '_geomemf.png'], '-transparent');

        
        % --------------------------------
        % GEOMETRIC MEAN ON EXPOSURE
        % --------------------------------
                
        % get associated Exposure Multiplication Factors (EMF)
        EMF_region_plot_BE = squeeze(EMF_perregion_young2pic_BE_geomexp(ind_extreme, ind_region, :, :))';
        
        % call plotting function
        mf_plot_burning_embers(ages, GMT_BE, EMF_region_plot_BE, PCT_region_plot_BE, colormaps.BE_continuous, caxes.EMF_BE_pe(ind_extreme,:), ind_region, ind_extreme, age_ref, agegroups, regions, year_start, nextremes, panelletters_regions, extremes, extremes_legend, axcolor, 3, 'b Geometric mean on EXP')
               
        % save figure
        export_fig(['figures/burning_embers/EMF_PCTcont_region_GMT_BE_' regions.name{ind_region} '_'  extremes_legend{ind_extreme} '_geomexp.png'], '-transparent');


        % --------------------------------
        % HARMONIC MEAN ON EMF
        % --------------------------------
                
        % get associated Exposure Multiplication Factors (EMF)
        EMF_region_plot_BE = squeeze(EMF_perregion_young2pic_BE_harmean(ind_extreme, ind_region, :, :))';
        
        % call plotting function
        mf_plot_burning_embers(ages, GMT_BE, EMF_region_plot_BE, PCT_region_plot_BE, colormaps.BE_continuous, caxes.EMF_BE_pe(ind_extreme,:), ind_region, ind_extreme, age_ref, agegroups, regions, year_start, nextremes, panelletters_regions, extremes, extremes_legend, axcolor, 3, 'c Harmonic mean on EMF')
               
        % save figure
        export_fig(['figures/burning_embers/EMF_PCTcont_region_GMT_BE_' regions.name{ind_region} '_'  extremes_legend{ind_extreme} '_harmmean.png'], '-transparent');


        
        % clean up
        close all


    end
    

end


end



% --------------------------------------------------------------------
% paper supplementary figure 4 - BE per world region
% --------------------------------------------------------------------


if flags.plot_sfig4 == 1

    
% get caxis per extreme
caxes.EMF_BE_pe = [1  4; ...   % burntarea
                   1  4; ...   % cropfailedarea
                   1  4; ...   % driedarea
                   1  4; ...   % floodedarea
                   1 30; ...   % heatwavedarea
                   1  4; ...   % tropicalcyclone
                   1  6  ];    % all
ticksteps       = [1; ...   % burntarea
                   1; ...   % cropfailedarea
                   1; ...   % driedarea
                   1; ...   % floodedarea
                   5; ...   % heatwavedarea
                   1; ...   % tropicalcyclone
                   1  ];    % all

    
% loop over regions
for ind_region = 1:nregions
  
    
    for ind_extreme = nextremes+1
        
    
        % get percentages of extreme events
        PCT_region_plot_BE = squeeze(PCT_perregion_young2pic_BE(ind_extreme, ind_region, :, :))';

        
        % get associated Exposure Multiplication Factors (EMF)
        EMF_region_plot_BE = squeeze(EMF_perregion_young2pic_BE(ind_extreme, ind_region, :, :))';
        
        
        % call plotting function
        mf_plot_burning_embers(ages, GMT_BE, EMF_region_plot_BE, PCT_region_plot_BE, colormaps.BE_continuous, caxes.EMF_BE_pe(ind_extreme,:), ind_region, ind_extreme, age_ref, agegroups, regions, year_start, nextremes, panelletters_regions, extremes, extremes_legend, axcolor, 1, [])

               
        % save figure
        export_fig(['figures/burning_embers/EMF_PCTcont_region_GMT_BE_' regions.name{ind_region} '_'  extremes_legend{ind_extreme} '_forSI.png'], '-transparent');

        
        % clean up
        close all


    end
    

end


end




% --------------------------------------------------------------------
% paper supplementary figure 5 - BE per income group
% --------------------------------------------------------------------


if flags.plot_sfig5 == 1

disp('run plot_sfig4');
    
end



% --------------------------------------------------------------------
% paper supplementary figure 6 - life expectancy data
% --------------------------------------------------------------------


if flags.plot_sfig6 == 1



% loop over regions
for ind_region = 12%1:nregions

    % visualisation
    figure
    set(gcf, 'color', 'w');
    plot(birth_years, regions.life_expectancy{ind_region}, 'color', axcolor, 'linewidth', 3); hold on;
    title(regions.name{ind_region}, 'color', axcolor)
    set(gca, 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
    xlabel('Birth year', 'Fontsize', 15, 'Fontweight', 'Bold'); 
    ylabel('Life expectancy at birth', 'Fontsize', 15, 'Fontweight', 'Bold'); 
   
    % save figure
    export_fig(['figures/per_region/life_expectancy_' regions.name{ind_region} '.png'], '-transparent');

end


% % loop over regions
% for ind_country = 1:ncountries
% 
%     % visualisation
%     figure;
%     set(gcf, 'color', 'w');
%     plot(birth_years, countries.life_expectancy{ind_country}, 'color', axcolor, 'linewidth', 3); hold on;
%     title(countries.name{ind_country}, 'color', axcolor)
%     set(gca, 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
%     xlabel('Birth year', 'Fontsize', 15, 'Fontweight', 'Bold'); 
%     ylabel('Life expectancy at birth', 'Fontsize', 15, 'Fontweight', 'Bold'); 
% 
%     % save figure
%     export_fig(['figures/per_country/life_expectancy_' countries.name{ind_country} '.png'], '-transparent');
%    
%     % clean up
%     close all
% 
% end


end



% --------------------------------------------------------------------
% paper supplementary figure 7 and 8 - area plots per region per GMT 
% per cause (constant life expectancy vs. full signal)
% --------------------------------------------------------------------


if flags.plot_sfig7 == 1


% loop over regions
for ind_region = 1:nregions
    
    
    % get number of extreme events
    exposure_region_plot_pic = exposure_perregion_pic_mean(nextremes + 1, ind_region);


    % get associated Exposure Multiplication Factors (EMF)
    EMF_perregion_plot_NDC = squeeze(EMF_perregion_NDC(nextremes + 1, ind_region, :));

    
    % compute difference in exposure between CC+life expectancy change, and CC given constant life expectancy
    exposure_perregion_diff_dle     = exposure_perregion_pic_mean_perage - repmat(exposure_perregion_pic_mean, 1, 1, nbirthyears);                               % change in exposure due to changing life expectancy
    exposure_perregion_diff_cc      = exposure_perregion_NDC             - exposure_perregion_diff_dle - repmat(exposure_perregion_pic_mean, 1, 1, nbirthyears); % change in exposure due to climate change (defined as total exposure - picontrol exposure - life expectancy effect)
    exposure_perregion_percause_NDC = [repmat(exposure_perregion_pic_mean(nextremes + 1, ind_region), nbirthyears, 1) ...                                        % prepare for area plot
                                       flipud(squeeze(exposure_perregion_diff_cc( nextremes + 1, ind_region, :)))     ...
                                       flipud(squeeze(exposure_perregion_diff_dle(nextremes + 1, ind_region, :)))        ];
                                       

    % visualisation
    figure
    set(gcf, 'color', 'w');
    h = area(flipud(ages), exposure_perregion_percause_NDC); hold on;
    h(1).FaceColor = colors(20,:); % light blue 
    h(2).FaceColor = colors(42,:); % colors based on Zekollari et al. (2020)
    h(3).FaceColor = colors(41,:);
    set(h,'EdgeColor','none')
    %plot(0:60,flipud(squeeze(exposure_perregion_NDC(nextremes + 1, ind_region, :))), 'r'); % for testing, it is correct
    set(gca, 'XDir','reverse', 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
    xlabel('Age in 2020', 'Fontsize', 15, 'Fontweight', 'Bold'); 
    ylabel('Extreme event exposure', 'Fontsize', 15, 'Fontweight', 'Bold'); 
    legend(h, 'pre-industrial mean', 'climate change', 'life expectancy change', 'location', 'Northwest');
    set(legend, 'box', 'off', 'Fontweight', 'Bold', 'Fontsize', 13, 'textcolor', axcolor);
    hold off;


    % add exposure multiplication factors (EMF)
    EMF_perregion_plot_NDC_young2pic = flipud(squeeze(exposure_perregion_NDC(nextremes + 1, ind_region, :) ./ exposure_perregion_pic_mean(nextremes + 1, ind_region, :)));
    for i=1:min(ceil(nanmax(EMF_perregion_plot_NDC_young2pic)), 50)
        text(4, i .* exposure_region_plot_pic, ['\times' num2str(i)], 'Fontsize', 13, 'Fontweight', 'Bold', 'Color', darkcolor, 'VerticalAlignment', 'middle', 'clipping', 'on')
    end
    hold off;
    
    
    % move axes up to make room for age groups
    voffset  = 0.05;                 % set vertical offset
    axpos    = get(gca, 'position'); % get axis position
    axpos(2) = axpos(2) + voffset;   % move up bottom bound
    axpos(4) = axpos(4) - voffset;   % shrink height
    set(gca, 'position', axpos);     % apply new axes position
    
    
    % add age groups (horizontal: data units; vertical: normalised units)
    for i=1:size(agegroups,1)
          mf_dataTextbox([agegroups{i,2}-year_start agegroups{i,3}-year_start], [0.001 0.04], agegroups{i,1}, axcolor, axcolor, 'w');
    end


    % add region as text
    ylims = ylim;
    text(ages(1), ylims(2) + ylims(2)*0.01, [panelletters_regions{ind_region} ' ' regions.name{ind_region}],'ver','bottom','hor','left','Fontsize', 14, 'Fontweight', 'bold', 'color', axcolor)


    % plot pictograms
    ax2 = axes('Position',[0.5 0.93 0.5 0.07]); % generate new axes
    imagesc(pictogram_all_1x6); hold off        % add pictogram
    axis('off', 'image');                       % remove axes

    
    % save figure
    export_fig(['figures/per_region/exposure_region_GMT_percause_' regions.name{ind_region} '.png'], '-transparent');

    
    % clean up
    close all


end

end



% --------------------------------------------------------------------
% paper supplementary figure 8 - area plots per region per GMT 
% per cause (constant life expectancy vs. full signal)
% --------------------------------------------------------------------


if flags.plot_sfig8 == 1

disp('run plot_sfig7');
    
end




% --------------------------------------------------------------------
% paper supplementary figure 9 - EMF maps per extreme
% --------------------------------------------------------------------


if flags.plot_sfig9 == 1

disp('run plot_fig4');
    
end



% --------------------------------------------------------------------
% empricical CDF plots
% --------------------------------------------------------------------


if flags.plot_ecdf == 1


% for testing
% make one of those per extreme event category, with each region representing a cdf line
% for paper SI

% world regions
figure;
for i=1:length(ind_region)
    h(i) = cdfplot(exposure_perregion_pic{nextremes+1,ind_region(i)}); hold on;
    set(h(i), 'linewidth', 3, 'color', linecolors(i,:))
end
set(gca, 'Fontsize', 13, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
xlabel('Extreme event exposure', 'Fontsize', 15, 'Fontweight', 'Bold'); 
legend(regions.name(ind_region), 'location', 'southeast');
set(legend, 'box', 'off', 'Fontweight', 'Bold', 'Fontsize', 12, 'textcolor', axcolor);
% xlim([0 10])
ylim([0 1])
export_fig figures/ecdf_worldregions.png  -transparent;


% income groups
figure;
colormaps.worldregions = mf_colormap_cpt('Dark2_08');  % CB qualitative colors
linecolors             = get(gca,'ColorOrder');        % get default colors
linecolors(8,:)        = colormaps.worldregions(8,:);  % append default colors with color number 8 from CB 'Dark2_08'

for i=1:length(ind_income)
    h(i) = cdfplot(exposure_perregion_pic{nextremes+1,ind_income(i)}); hold on;
    set(h(i), 'linewidth', 3, 'color', linecolors(i,:))
end
set(gca, 'Fontsize', 13, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
xlabel('Extreme event exposure', 'Fontsize', 15, 'Fontweight', 'Bold'); 
legend(regions.name(ind_income), 'location', 'southeast');
set(legend, 'box', 'off', 'Fontweight', 'Bold', 'Fontsize', 12, 'textcolor', axcolor);
% xlim([0 10])
ylim([0 1])
export_fig figures/ecdf_incomegroups.png  -transparent;


end



% --------------------------------------------------------------------
% Bubble plot
% --------------------------------------------------------------------


if flags.plot_bubble == 1


% loop over countries
for i=1:ncountries
    
    % get EMF corresponding to median age of country
    EMF_percountry_medianage_NDC(i,1)           = EMF_NDC(nextremes+1, i, find(ages == round(countries.median_age_2020(i)), 1, 'first'));
    
    
    % get exposure corresponding to median age of country
    exposure_percountry_medianage_NDC(i,1)      = exposure_NDC(nextremes+1, i, find(ages == round(countries.median_age_2020(i)), 1, 'first'));


    % get PCT corresponding to median age of country    
    PCT_percountry_medianage_NDC_young2pic(i,1) = mf_invprctile(exposure_percountry_pic{nextremes+1,i}', exposure_percountry_medianage_NDC(i,1));


    % get PCT corresponding to median age of country    
    PCT_percountry_newborn_NDC_young2pic(i,1) = mf_invprctile(exposure_percountry_pic{nextremes+1,i}', exposure_NDC(nextremes+1, i, find(ages == age_young, 1, 'first')));
    
end


% get corresponding color code - median age
colors_medianage_NDC(PCT_percountry_medianage_NDC_young2pic < percentages(1)                                                          , 1) = colormaps.BE_4(1,1);
colors_medianage_NDC(PCT_percountry_medianage_NDC_young2pic > percentages(1) & PCT_percountry_medianage_NDC_young2pic < percentages(2), 1) = colormaps.BE_4(2,1);
colors_medianage_NDC(PCT_percountry_medianage_NDC_young2pic > percentages(2) & PCT_percountry_medianage_NDC_young2pic < percentages(3), 1) = colormaps.BE_4(3,1);
colors_medianage_NDC(PCT_percountry_medianage_NDC_young2pic > percentages(3)                                                          , 1) = colormaps.BE_4(4,1);
colors_medianage_NDC(PCT_percountry_medianage_NDC_young2pic < percentages(1)                                                          , 2) = colormaps.BE_4(1,2);
colors_medianage_NDC(PCT_percountry_medianage_NDC_young2pic > percentages(1) & PCT_percountry_medianage_NDC_young2pic < percentages(2), 2) = colormaps.BE_4(2,2);
colors_medianage_NDC(PCT_percountry_medianage_NDC_young2pic > percentages(2) & PCT_percountry_medianage_NDC_young2pic < percentages(3), 2) = colormaps.BE_4(3,2);
colors_medianage_NDC(PCT_percountry_medianage_NDC_young2pic > percentages(3)                                                          , 2) = colormaps.BE_4(4,2);
colors_medianage_NDC(PCT_percountry_medianage_NDC_young2pic < percentages(1)                                                          , 3) = colormaps.BE_4(1,3);
colors_medianage_NDC(PCT_percountry_medianage_NDC_young2pic > percentages(1) & PCT_percountry_medianage_NDC_young2pic < percentages(2), 3) = colormaps.BE_4(2,3);
colors_medianage_NDC(PCT_percountry_medianage_NDC_young2pic > percentages(2) & PCT_percountry_medianage_NDC_young2pic < percentages(3), 3) = colormaps.BE_4(3,3);
colors_medianage_NDC(PCT_percountry_medianage_NDC_young2pic > percentages(3)                                                          , 3) = colormaps.BE_4(4,3);


% get corresponding color code - newborns
colors_newborn_NDC(  PCT_percountry_newborn_NDC_young2pic   < percentages(1)                                                          , 1) = colormaps.BE_4(1,1);
colors_newborn_NDC(  PCT_percountry_newborn_NDC_young2pic   > percentages(1) & PCT_percountry_newborn_NDC_young2pic   < percentages(2), 1) = colormaps.BE_4(2,1);
colors_newborn_NDC(  PCT_percountry_newborn_NDC_young2pic   > percentages(2) & PCT_percountry_newborn_NDC_young2pic   < percentages(3), 1) = colormaps.BE_4(3,1);
colors_newborn_NDC(  PCT_percountry_newborn_NDC_young2pic   > percentages(3)                                                          , 1) = colormaps.BE_4(4,1);
colors_newborn_NDC(  PCT_percountry_newborn_NDC_young2pic   < percentages(1)                                                          , 2) = colormaps.BE_4(1,2);
colors_newborn_NDC(  PCT_percountry_newborn_NDC_young2pic   > percentages(1) & PCT_percountry_newborn_NDC_young2pic   < percentages(2), 2) = colormaps.BE_4(2,2);
colors_newborn_NDC(  PCT_percountry_newborn_NDC_young2pic   > percentages(2) & PCT_percountry_newborn_NDC_young2pic   < percentages(3), 2) = colormaps.BE_4(3,2);
colors_newborn_NDC(  PCT_percountry_newborn_NDC_young2pic   > percentages(3)                                                          , 2) = colormaps.BE_4(4,2);
colors_newborn_NDC(  PCT_percountry_newborn_NDC_young2pic   < percentages(1)                                                          , 3) = colormaps.BE_4(1,3);
colors_newborn_NDC(  PCT_percountry_newborn_NDC_young2pic   > percentages(1) & PCT_percountry_newborn_NDC_young2pic   < percentages(2), 3) = colormaps.BE_4(2,3);
colors_newborn_NDC(  PCT_percountry_newborn_NDC_young2pic   > percentages(2) & PCT_percountry_newborn_NDC_young2pic   < percentages(3), 3) = colormaps.BE_4(3,3);
colors_newborn_NDC(  PCT_percountry_newborn_NDC_young2pic   > percentages(3)                                                          , 3) = colormaps.BE_4(4,3);


% visualisation
figure
set(gcf, 'color', 'w');
scatter(countries.median_age_2020, EMF_percountry_medianage_NDC, population_percountry_2020 ./ 10^6, colors_medianage_NDC, 'filled', 'MarkerEdgeColor', axcolor)
set(gca, 'XDir','reverse', 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
xlabel('Median age in 2020 (size: tot pop 2020)', 'Fontsize', 15, 'Fontweight', 'Bold'); 
ylabel('Exposure multiplication factor (median)', 'Fontsize', 15, 'Fontweight', 'Bold'); 
ylim([1 3.5]); % set y-axis limits


% save figure
export_fig figures/bubble_NDC_median_age_2020.png  -transparent;



% scatter plot gives an error for size 0
countries.popunder5_2018(countries.popunder5_2018 == 0) = NaN;


% visualisation
figure
set(gcf, 'color', 'w');
scatter(countries.hdi_2018, squeeze(EMF_NDC(nextremes+1, :, end))' , countries.popunder5_2018 .* 10^1, colors_newborn_NDC, 'filled', 'MarkerEdgeColor', axcolor)
set(gca, 'XDir','reverse', 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
xlabel('HDI in 2018 (size: popunder5 2018)', 'Fontsize', 15, 'Fontweight', 'Bold'); 
ylabel('Exposure multiplication factor (newborn)', 'Fontsize', 15, 'Fontweight', 'Bold'); 
ylim([1 6]); % set y-axis limits


% save figure
export_fig figures/bubble_NDC_hdi_2018_newbornvs60.png  -transparent;


end



% --------------------------------------------------------------------
% PDF plot - country scale (old, TBR)
% --------------------------------------------------------------------


if flags.plot_pdf_cnt == 1

    
%     TO DO: 
% - DIFFERENT POPULATION MAPS?!!
% - plot lines of individual simulations as light lines?
% - fit different distribution?


xlims_pdf = [-5 20; ...   % burntarea
             -5 20; ...   % cropfailedarea
             -5 20; ...   % driedarea
             -5 20; ...   % floodedarea
             -5 50; ...   % heatwavedarea
             -5 20; ...   % tropicalcyclone
             -5 40; ];    % all
         

% loop over extremes
for ind_extreme = 1:nextremes%+1
% for ind_extreme = 5
        
    
    % visualisation
    figure
    set(gcf, 'color', 'w');
    

% % % % %     % Get thin lines for individual simulations Erich Fischer style
% % % % %     if ind_extreme < nextremes+1
% % % % %         
% % % % %         % two conditions: runs for that category of extremes and maximum GMT difference below the threshold
% % % % %         ind_run = find(strcmp({isimip.extreme}, extremes{ind_extreme})' & RCP2GMT_maxdiff_NDC <= RCP2GMT_maxdiff_threshold);
% % % % %         
% % % % %         
% % % % %         ksdensity_ref_mm = [];
% % % % %         ksdensity_young_mm = [];
% % % % %         
% % % % %         % loop over selected runs
% % % % %         for j=1:length(ind_run)
% % % % % 
% % % % % %     ksdensity_pic = repelem(exposure_percountry_pic_mean(ind_run(j), :             ), round(population_percountry_2020 ./ 10^3))';
% % % % %     ksdensity_young  = repelem(exposure_perrun_NDC(                ind_run(j), :, ages == age_ref  ) - exposure_percountry_perrun_pic_mean(ind_run(j),:), round(population_percountry_2020 ./ 10^3))';
% % % % %     ksdensity_ref    = repelem(exposure_perrun_NDC(                ind_run(j), :, ages == age_young) - exposure_percountry_perrun_pic_mean(ind_run(j),:), round(population_percountry_2020 ./ 10^3))';
% % % % % 
% % % % % %     h(1) = histogram(ksdensity_pic, 100, 'DisplayStyle','stairs', 'edgecolor', axcolor); hold on
% % % % %     h(2) = histogram(ksdensity_young, 100, 'DisplayStyle','stairs', 'edgecolor', 'b'); hold on
% % % % %     h(3) = histogram(ksdensity_ref  , 100, 'DisplayStyle','stairs', 'edgecolor', 'r'); hold on
% % % % % 
% % % % % % % % %         h(1) = histogram(exposure_pdf_NDC_young{ind_run(j),1}, kernel_x, 'DisplayStyle','stairs', 'edgecolor', 'r'); hold on
% % % % % % % % %         h(2) = histogram(exposure_pdf_NDC_ref{ind_run(j),1}  , kernel_x, 'DisplayStyle','stairs', 'edgecolor', 'b'); hold on
% % % % % % % %           plot(kernel_x, exposure_kernel_perrun_NDC_ref(ind_run(j)  , :), 'LineWidth', 0.5, 'color', colors(20,:)); hold on;
% % % % % % % %           plot(kernel_x, exposure_kernel_perrun_NDC_young(ind_run(j), :), 'LineWidth', 0.5, 'color', colors(19,:)); hold on;
% % % % % 
% % % % % ksdensity_young_mm = [ksdensity_young_mm; ksdensity_young];
% % % % % ksdensity_ref_mm = [ksdensity_ref_mm; ksdensity_ref];
% % % % % 
% % % % %         end
% % % % %     end
% % % % %     
% % % % %     
% % % % %     % plot multi-model mean
% % % % %     h(2) = histogram(ksdensity_young_mm, 100, 'DisplayStyle','stairs', 'edgecolor', 'y'); hold on
% % % % %     h(3) = histogram(ksdensity_ref_mm  , 100, 'DisplayStyle','stairs', 'edgecolor', 'g'); hold on
% % % % % 
% % % % % %     plot(kernel_x, exposure_kernel_NDC_ref(ind_extreme  , :), 'LineWidth', 2, 'color', colors(17,:)); hold on;
% % % % % %     plot(kernel_x, exposure_kernel_NDC_young(ind_extreme, :), 'LineWidth', 2, 'color', colors(16,:)); hold on;
% % % % % 
% % % % % 
% % % % %     % ksdensity_pic(ksdensity_pic == 0) = 0.0001; % to enable zero-bounded kernel estimate
% % % % %     % ksdensity_60(  ksdensity_60 == 0) = 0.0001; % to enable zero-bounded kernel estimate
% % % % %     % ksdensity_0(  ksdensity_0   == 0) = 0.0001; % to enable zero-bounded kernel estimate
% % % % %     % 
% % % % %     % ksdensity(ksdensity_pic); hold on;
% % % % %     % ksdensity(ksdensity_60 ); hold on;
% % % % %     % ksdensity(ksdensity_0  ); hold on;
% % % % %     %
% % % % %     % ksdensity(ksdensity_pic, 'Support', 'positive'); hold on;
% % % % %     % ksdensity(ksdensity_60 , 'Support', 'positive'); hold on;
% % % % %     % ksdensity(ksdensity_0  , 'Support', 'positive'); hold on;
    

    % Get thin lines for individual simulations Erich Fischer style
    if ind_extreme < nextremes+1
        ind_run = find(strcmp({isimip.extreme}, extremes{ind_extreme}));
        for j=1:length(ind_run)

    %     h(1) = histogram(exposure_pdf_pixel_NDC_young{ind_run(j),1}, kernel_x, 'DisplayStyle','stairs', 'edgecolor', 'r'); hold on
    %     h(2) = histogram(exposure_pdf_pixel_NDC_ref{ind_run(j),1}  , kernel_x, 'DisplayStyle','stairs', 'edgecolor', 'b'); hold on
          plot(kernel_x, exposure_perrun_kernel_NDC_ref(ind_run(j)  , :), 'LineWidth', 0.5, 'color', colors(20,:)); hold on;
          plot(kernel_x, exposure_perrun_kernel_NDC_young(ind_run(j), :), 'LineWidth', 0.5, 'color', colors(19,:)); hold on;

        end
    end
    
    
    % plot multi-model mean
    plot(kernel_x, exposure_kernel_NDC_ref(ind_extreme  , :), 'LineWidth', 2, 'color', colors(17,:)); hold on;
    plot(kernel_x, exposure_kernel_NDC_young(ind_extreme, :), 'LineWidth', 2, 'color', colors(16,:)); hold on;

    
    % finalise plot
    xlim(xlims_pdf(ind_extreme,:)); % set x-axis limits
    set(gca, 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
%     xlabel('Absolute change in extreme event exposure', 'Fontsize', 15, 'Fontweight', 'Bold'); 
    xlabel('Exposure multiplication factor', 'Fontsize', 15, 'Fontweight', 'Bold'); 
    ylabel('Age cohort fraction', 'Fontsize', 15, 'Fontweight', 'Bold'); 
% %     legend(h(1:3), '60-yr, pre-industrial', '60yr, current pledges', 'newborn, current pledges', 'location', 'Northeast');
% %     set(legend, 'box', 'off', 'Fontweight', 'Bold', 'Fontsize', 14, 'textcolor', axcolor);


    % load and plot pictograms
    if ind_extreme == nextremes+1
        pictogram = pictogram_all_1x6;
    else
        pictogram = imadjust(imcomplement(imread(['pictogram_' extremes{ind_extreme} '.png'])),[0.3 0.3 0.3; 1 1 1],[]);
    end
    ax2 = axes('Position',[0.5 0.93 0.5 0.07]);
    imagesc(pictogram); hold off   % add pictogram
    axis('off', 'image');


    % save figure
    export_fig(['figures/pdf_' extremes_legend{ind_extreme} '_country_EMF_bandwidth2.png'], '-transparent');
%     export_fig(['figures/hist_' extremes_legend{ind_extreme} '.png'], '-transparent');

    
end

end



% --------------------------------------------------------------------
% PDF plot - pixel scale
% --------------------------------------------------------------------


if flags.plot_pdf == 1

    
%     TO DO: 
% - DIFFERENT POPULATION MAPS?!!
% - plot lines of individual simulations as light lines?
% - fit different distribution?


xlims_pdf = [-5 10; ...   % burntarea
             -5 10; ...   % cropfailedarea
             -5 15; ...   % driedarea
             -5 10; ...   % floodedarea
             -5 30; ...   % heatwavedarea
             -5 10; ...   % tropicalcyclone
             -5 40; ];    % all
         

% loop over extremes
% for ind_extreme = 1:nextremes+1
for ind_extreme = nextremes+1

    
    % visualisation
    figure
    set(gcf, 'color', 'w');


    % Get thin lines for individual simulations Erich Fischer style
    if ind_extreme < nextremes+1
        ind_run = find(strcmp({isimip.extreme}, extremes{ind_extreme}));
        for j=1:length(ind_run)

    %     h(1) = histogram(exposure_pdf_pixel_NDC_young{ind_run(j),1}, kernel_x, 'DisplayStyle','stairs', 'edgecolor', 'r'); hold on
    %     h(2) = histogram(exposure_pdf_pixel_NDC_ref{ind_run(j),1}  , kernel_x, 'DisplayStyle','stairs', 'edgecolor', 'b'); hold on
          plot(kernel_x, exposure_kernel_pixel_perrun_NDC_ref(ind_run(j)  , :), 'LineWidth', 0.5, 'color', colors(20,:)); hold on;
          plot(kernel_x, exposure_kernel_pixel_perrun_NDC_young(ind_run(j), :), 'LineWidth', 0.5, 'color', colors(19,:)); hold on;

        end
    end
    
    
    % plot multi-model mean
    plot(kernel_x, exposure_kernel_pixel_NDC_ref(ind_extreme  , :), 'LineWidth', 2, 'color', colors(17,:)); hold on;
    plot(kernel_x, exposure_kernel_pixel_NDC_young(ind_extreme, :), 'LineWidth', 2, 'color', colors(16,:)); hold on;

    
    % finalise plot
    xlim(xlims_pdf(ind_extreme,:)); % set x-axis limits
    set(gca, 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
    xlabel('Absolute change in extreme event exposure', 'Fontsize', 15, 'Fontweight', 'Bold'); 
    ylabel('Probability', 'Fontsize', 15, 'Fontweight', 'Bold'); 
% %     legend(h(1:3), '60-yr, PIC', '60yr, NDC', 'newborn, NDC', 'location', 'Northeast');
% %     set(legend, 'box', 'off', 'Fontweight', 'Bold', 'Fontsize', 14, 'textcolor', axcolor);


    % load and plot pictograms
    if ind_extreme == nextremes+1
        pictogram = pictogram_all_1x6;
    else
        pictogram = imadjust(imcomplement(imread(['pictogram_' extremes{ind_extreme} '.png'])),[0.3 0.3 0.3; 1 1 1],[]);
    end
    ax2 = axes('Position',[0.5 0.93 0.5 0.07]);
    imagesc(pictogram); hold off   % add pictogram
    axis('off', 'image');


    % save figure
    export_fig(['figures/pdf_' extremes_legend{ind_extreme} '_pixel.png'], '-transparent');
%     export_fig(['figures/hist_' extremes_legend{ind_extreme} '.png'], '-transparent');

    
end



end
