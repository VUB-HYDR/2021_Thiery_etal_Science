

% --------------------------------------------------------------------
% function to plot regional averages under current pledges
% --------------------------------------------------------------------


function [] = mf_plot_regions_NDC(exposure_perregion_perlife_NDC, EMF_perregion_NDC, exposure_perregion_mms_NDC, ages, agegroups, regions, year_start, nextremes, ind_region)




% --------------------------------------------------------------------
% Initialisation
% --------------------------------------------------------------------

                               
% define axes and sea color                               
% axcolor  = [0.3  0.3  0.3 ]; % 70% contrast (so 0.3) is advised
axcolor  = [0.5  0.5  0.5 ]; % normal grey


% load pictogram
pictogram_all_1x6 = imcomplement(imread('pictogram_all_1x6.png'));


% get number of regions
nregions = length(ind_region);


% initialise line and 'boxplot' colors
figure;                                                % put it here because colororder needs an existing figure
colormaps.worldregions = mf_colormap_cpt('Dark2_08');  % CB qualitative colors
linecolors             = get(gca,'ColorOrder');        % get default colors
linecolors(8,:)        = colormaps.worldregions(8,:);  % append default colors with color number 8 from CB 'Dark2_08'
% linecolors             = colormaps.worldregions;     % alternative approach using the CB colors



% --------------------------------------------------------------------
% manipulations: hatching
% --------------------------------------------------------------------


% get number of extreme events
exposure_region_plot_NDC = squeeze(exposure_perregion_perlife_NDC(nextremes + 1, ind_region, :))';


% get associated exposure multiplication factors (EMF)
EMF_region_plot_NDC = squeeze(EMF_perregion_NDC(nextremes + 1, ind_region, :))';


% get standard deviation of extreme events
exposure_region_mms_plot_NDC = squeeze(exposure_perregion_mms_NDC(nextremes + 1, ind_region, end));


% get max y-axis range
ymax = max(exposure_region_plot_NDC(end,:) + exposure_region_mms_plot_NDC);

        

% --------------------------------------------------------------------
% Visualisation
% --------------------------------------------------------------------


% visualisation
set(gcf, 'color', 'w');
for i=1:length(ind_region)
h(i) = plot(ages, exposure_region_plot_NDC(:,i), '-', 'linewidth', 3, 'color', linecolors(i,:)); hold on; %#ok<AGROW>
end
plot(0.1, 0.1 , 'w'); hold on;                                                                    % dummy data to have y-axis starting at 0
% % % plot(0.1, ymax, 'w'); hold on;                                                                    % dummy data to have y-axis until end of the 'boxplots'
set(gca, 'XDir','reverse', 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
xlabel('Age in 2020', 'Fontsize', 15, 'Fontweight', 'Bold'); 
ylabel('Extreme events exposure', 'Fontsize', 15, 'Fontweight', 'Bold'); 
legend(regions.name(ind_region), 'location', 'Northwest');
set(legend, 'box', 'off', 'Fontweight', 'Bold', 'Fontsize', 12, 'textcolor', axcolor);


% set y-axis limits
ylim([0 2])


% add exposure multiplication factors (EMF)
% for i=1:ceil(nanmax(EMF_region_plot_NDC,[],'all'))
for i=1:10
    text(4, i .* exposure_region_plot_NDC(1),['\times' num2str(i)], 'Fontsize', 13, 'Fontweight', 'Bold', 'Color', axcolor, 'VerticalAlignment', 'middle')
end
hold off;


% Get original axis position in cm
set(gca, 'units', 'centimeters')
axpos1 = get(gca, 'Position');


% create room for 'boxplots by increasing the figure width
figpos    = get(gcf, 'Position');
figpos(3) = figpos(3) + 100;      % expand to the left
set(gcf, 'Position', figpos);


% re-set original axis position in cm
set(gca, 'units', 'centimeters', 'Position', axpos1)
set(gca, 'units', 'normalized')


% move axes up to make room for age groups
voffset  = 0.05;                 % set vertical offset
axpos    = get(gca, 'position'); % get axis position
axpos(2) = axpos(2) + voffset;   % move up bottom bound
axpos(4) = axpos(4) - voffset;   % shrink height
set(gca, 'position', axpos);     % apply new axes position
ax1      = gca;

% add age groups (horizontal: data units; vertical: normalised units)
for i=1:size(agegroups,1)
      mf_dataTextbox([agegroups{i,2}-year_start agegroups{i,3}-year_start], [0.001 0.04], agegroups{i,1}, axcolor, axcolor, 'w');
end


% add region as text
ylims = ylim;
text(ages(1), ylims(2) + ylims(2)*0.01, 'Current Pledges','ver','bottom','hor','left','Fontsize', 15, 'Fontweight', 'bold', 'color', axcolor)


% Set axes limits of 'boxplot' panel
axlims   = [1 nregions*3 ylim]; 


% create new axes for 'boxplots'
set(ax1, 'units', 'centimeters');                          % set axis units to cm
axpos    = get(ax1, 'position');                           % get axis position
axpos(1) = axpos(1) + axpos(3) + 0.3;                      % left bound to the right
axpos(3) = 0.4 .* nregions;                                % set new width
ax2      = axes('Position',axpos, 'units', 'centimeters'); % generate new axes



linecolors = get(h,'Color'); % get line colors

% loop over regions
counter    = 1;              % set counter
for i=ind_region
    
    % plot rectangle
    rectangle('Position', [1+3*(counter-1), exposure_region_plot_NDC(end, counter) - exposure_region_mms_plot_NDC(counter) , 2, exposure_region_mms_plot_NDC(counter) .* 2], 'FaceColor', [linecolors{counter} 0.5], 'EdgeColor', 'none', 'LineWidth', 3); hold on;

    % plot horizontal ine
    plot([1+3*(counter-1) 3*(counter-1)+3], [exposure_region_plot_NDC(end, counter) exposure_region_plot_NDC(end, counter)], '-', 'linewidth', 3, 'color', linecolors{counter}); hold on;

%     % when using CB color code
%     % plot rectangle
%     rectangle('Position', [1+3*(counter-1), exposure_region_plot_NDC(end, counter) - exposure_region_mms_plot_NDC(counter) , 2, exposure_region_mms_plot_NDC(counter) .* 2], 'FaceColor', [linecolors(counter,:) 0.5], 'EdgeColor', 'none', 'LineWidth', 3); hold on;
% 
%     % plot horizontal ine
%     plot([1+3*(counter-1) 3*(counter-1)+3], [exposure_region_plot_NDC(end, counter) exposure_region_plot_NDC(end, counter)], '-', 'linewidth', 3, 'color', linecolors(counter,:)); hold on;

%     % Add labels
%     text(10, max(0, exposure_region_plot_NDC(end, counter) - exposure_region_mms_plot_NDC(counter)), 'NDC '  , 'color', axcolor, 'Fontsize', 12, 'Fontweight', 'Bold', 'Rotation', 90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle')

    % update counter
    counter = counter + 1;
    
end


% finalise 'boxplots' subplot
axis(axlims); % set axes limits with same y-axis limit as main plot
set(ax2, 'position', axpos, 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
axis off


% plot pictograms
ax3 = axes('Position',[0.35 0.93 0.5 0.07]); % generate new axes
imagesc(pictogram_all_1x6); hold off         % add pictogram
axis('off', 'image');                        % remove axes



end
