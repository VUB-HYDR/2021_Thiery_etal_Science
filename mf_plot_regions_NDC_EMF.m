

% --------------------------------------------------------------------
% function to plot regional averages under current pledges
% --------------------------------------------------------------------


function mf_plot_regions_NDC_EMF(exposure_perregion_perlife_NDC, EMF_perregion_NDC, EMF_perregion_q25_NDC, EMF_perregion_q75_NDC, exposure_perregion_mms_NDC, ages, agegroups, regions, year_start, nextremes, ind_region, panel, linecolors, ylims, flag_region)




% --------------------------------------------------------------------
% Initialisation
% --------------------------------------------------------------------

                               
% define axes and sea color                               
axcolor  = [0.5  0.5  0.5 ]; % normal grey


% load pictogram
pictogram_all_1x6 = imcomplement(imread('pictogram_all_1x6.png'));


% get number of regions
nregions = length(ind_region);


% initialise line and 'boxplot' colors
figure;                                                % put it here because colororder needs an existing figure
colormaps.worldregions = mf_colormap_cpt('Dark2_08');  % CB qualitative colors
if isempty(linecolors)
linecolors             = get(gca,'ColorOrder');        % get default colors
end
linecolors(8,:)        = colormaps.worldregions(8,:);  % append default colors with color number 8 from CB 'Dark2_08'
% linecolors             = colormaps.worldregions;     % alternative approach using the CB colors



% --------------------------------------------------------------------
% manipulations: hatching
% --------------------------------------------------------------------


% get number of extreme events
exposure_region_plot_NDC = squeeze(exposure_perregion_perlife_NDC(nextremes + 1, ind_region, :))';


% get associated exposure multiplication factors (EMF)
EMF_region_plot_NDC     = squeeze(EMF_perregion_NDC(    nextremes + 1, ind_region, :))';
EMF_region_q25_plot_NDC = squeeze(EMF_perregion_q25_NDC(nextremes + 1, ind_region, :))';
EMF_region_q75_plot_NDC = squeeze(EMF_perregion_q75_NDC(nextremes + 1, ind_region, :))';


% get standard deviation of extreme events
exposure_region_mms_plot_NDC = squeeze(exposure_perregion_mms_NDC(nextremes + 1, ind_region, end));


% % get max y-axis range
% ymax = nanmax(EMF_region_q75_plot_NDC(end,:));

        

% --------------------------------------------------------------------
% Visualisation
% --------------------------------------------------------------------


% visualisation
set(gcf, 'color', 'w');
for i=1:length(ind_region)
h(i) = plot(ages, EMF_region_plot_NDC(:,i), '-', 'linewidth', 3, 'color', linecolors(i,:)); hold on; %#ok<AGROW>
end
% plot(0.1, 15 , 'w'); hold on;                                                                    % dummy data to have y-axis starting at 0
% plot(0.1, floor(ymax), 'w'); hold on;                                                                    % dummy data to have y-axis until end of the 'boxplots'
set(gca, 'XDir','reverse', 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
xlabel('Age in 2020', 'Fontsize', 15, 'Fontweight', 'Bold'); 
ylabel('Exposure multiplication factor [-]', 'Fontsize', 15, 'Fontweight', 'Bold'); 
legend(regions.name(ind_region), 'location', 'Northwest');
set(legend, 'box', 'off', 'Fontweight', 'Bold', 'Fontsize', 12, 'textcolor', axcolor);


% set y-axis ticks and labels
y_ticks = 1:2:30;
for i=1:length(y_ticks) % generate colorbar ticklabels
    y_ticklabels{i} = ['\times' num2str(y_ticks(i))]; 
end
yticks(y_ticks)
yticklabels(y_ticklabels)


% set y-axis limits
ylim(ylims)


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
text(ages(1), ylims(2) + ylims(2)*0.01, [panel ' Current Pledges'],'ver','bottom','hor','left','Fontsize', 15, 'Fontweight', 'bold', 'color', axcolor)


% Set axes limits of 'boxplot' panel
axlims   = [1 nregions*3 ylim]; 


% create new axes for 'boxplots'
set(ax1, 'units', 'centimeters');                          % set axis units to cm
axpos    = get(ax1, 'position');                           % get axis position
axpos(1) = axpos(1) + axpos(3) + 0.3;                      % left bound to the right
axpos(3) = 0.4 .* nregions;                                % set new width
ax2      = axes('Position',axpos, 'units', 'centimeters'); % generate new axes


% get line colors
linecolors = get(h,'Color'); 


% loop over regions
for i=1:length(ind_region)
    
    % plot rectangle
%     rectangle('Position', [1+3*(i-1), exposure_region_plot_NDC(end, i) - exposure_region_mms_plot_NDC(i) , 2, exposure_region_mms_plot_NDC(i) .* 2], 'FaceColor', [linecolors{i} 0.5], 'EdgeColor', 'none', 'LineWidth', 3); hold on;
    rectangle('Position', [1+3*(i-1), EMF_region_q25_plot_NDC(end, i) , 2, EMF_region_q75_plot_NDC(end, i)  - EMF_region_q25_plot_NDC(end, i)], 'FaceColor', [linecolors{i} 0.5], 'EdgeColor', 'none', 'LineWidth', 3); hold on;

    % plot horizontal line
%     plot([1+3*(i-1) 3*(i-1)+3], [exposure_region_plot_NDC(end, i) exposure_region_plot_NDC(end, i)], '-', 'linewidth', 3, 'color', linecolors{i}); hold on;
    plot([1+3*(i-1) 3*(i-1)+3], [EMF_region_plot_NDC(end, i) EMF_region_plot_NDC(end, i)], '-', 'linewidth', 3, 'color', linecolors{i}); hold on;
    
    
%     % when using CB color code
%     % plot rectangle
%     rectangle('Position', [1+3*(i-1), exposure_region_plot_NDC(end, i) - exposure_region_mms_plot_NDC(i) , 2, exposure_region_mms_plot_NDC(i) .* 2], 'FaceColor', [linecolors(i,:) 0.5], 'EdgeColor', 'none', 'LineWidth', 3); hold on;
% 
%     % plot horizontal ine
%     plot([1+3*(i-1) 3*(i-1)+3], [exposure_region_plot_NDC(end, i) exposure_region_plot_NDC(end, i)], '-', 'linewidth', 3, 'color', linecolors(i,:)); hold on;


end


% add EMF for upper end of the bar
if strcmp(flag_region, 'income')
    text(2, ylims(2), ['\times' num2str(round(EMF_region_q75_plot_NDC(end, 1)))], 'color', axcolor , 'Fontsize', 11, 'Fontweight', 'Bold', 'Rotation', 90, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle')
end


% finalise 'boxplots' subplot
axis(axlims); % set axes limits with same y-axis limit as main plot
set(ax2, 'position', axpos, 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor, 'clipping', 'off');
axis off


% plot pictograms
ax3 = axes('Position',[0.35 0.93 0.5 0.07]); % generate new axes
imagesc(pictogram_all_1x6); hold off         % add pictogram
axis('off', 'image');                        % remove axes



end
