

% --------------------------------------------------------------------
% function to plot regional averages per scenario
% --------------------------------------------------------------------


function [] = mf_plot_hazards(exposure_NDC, EMF_NDC, ages, agegroups, regions, year_start, extremes_legend, nextremes, ind_region)




% --------------------------------------------------------------------
% Initialisation
% --------------------------------------------------------------------

                               
% define axes and sea color                               
axcolor  = [0.3  0.3  0.3 ]; % 70% contrast (so 0.3) is advised


% load pictogram
pictogram_all_1x6 = imcomplement(imread('pictogram_all_1x6.png'));


% line colors
colors = mf_colors;


% define colors
color_extremes(1,:) = colors(10,:);
color_extremes(2,:) = colors(36,:);
color_extremes(3,:) = colors(35,:);
color_extremes(4,:) = colors(33,:);
color_extremes(5,:) = colors(16,:);
color_extremes(6,:) = colors(17,:);



% --------------------------------------------------------------------
% manipulations: hatching
% --------------------------------------------------------------------


% % % % get number of extreme events
% % % exposure_plot_15  = squeeze(exposure_15( nextremes + 1, ind_region, :));
% % % exposure_plot_20  = squeeze(exposure_20( nextremes + 1, ind_region, :));
% % % exposure_plot_NDC = squeeze(exposure_NDC(nextremes + 1, ind_region, :));
% % % 
% % % 
% % % % get associated Exposure Multiplication Factors (EMF)
% % % EMF_plot_15  = squeeze(EMF_15( nextremes + 1, ind_region, :));
% % % EMF_plot_20  = squeeze(EMF_20( nextremes + 1, ind_region, :));
% % % EMF_plot_NDC = squeeze(EMF_NDC(nextremes + 1, ind_region, :));
% % % 
% % % 
% % % % get standard deviation of extreme events
% % % exposure_mms_plot_15  = squeeze(exposure_mms_15( nextremes + 1, ind_region, end));
% % % exposure_mms_plot_20  = squeeze(exposure_mms_20( nextremes + 1, ind_region, end));
% % % exposure_mms_plot_NDC = squeeze(exposure_mms_NDC(nextremes + 1, ind_region, end));
% % % 
% % % 
% % % % get max y-axis range
% % % ymax = max([exposure_plot_NDC(end) + exposure_mms_plot_NDC , ...
% % %             exposure_plot_20(end)  + exposure_mms_plot_20  , ...
% % %             exposure_plot_15(end)  + exposure_mms_plot_15       ]);



% --------------------------------------------------------------------
% Visualisation
% --------------------------------------------------------------------


% visualisation
figure
set(gcf, 'color', 'w');
for i=1:nextremes
% h(i) = plot(ages, permute(exposure_NDC(i, ind_region, :), [3 1 2]), '-', 'linewidth', 3, 'color', color_extremes(i,:)); hold on;
h(i) = plot(ages, permute(EMF_NDC(i, ind_region, :), [3 1 2]), '-', 'linewidth', 3, 'color', color_extremes(i,:)); hold on;
end
h(7) = plot(0.1, 0.1 , 'w'); hold on;                                                                    % dummy data to have y-axis starting at 0
% h(8) = plot(0.1, ymax, 'w'); hold on;                                                                    % dummy data to have y-axis until end of the 'boxplots'
set(gca, 'XDir','reverse', 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
xlabel('Age in 2020', 'Fontsize', 15, 'Fontweight', 'Bold'); 
% ylabel('Extreme events exposure', 'Fontsize', 15, 'Fontweight', 'Bold'); 
ylabel('Exposure multiplication factor', 'Fontsize', 15, 'Fontweight', 'Bold'); 
legend(h, extremes_legend, 'location', 'Northwest');
set(legend, 'box', 'off', 'Fontweight', 'Bold', 'Fontsize', 14, 'textcolor', axcolor);
hold off;


% % add exposure multiplication factors (EMF)
% for i=1:ceil(ymax)
%     text(4, i .* exposure_plot_NDC(1),['\times' num2str(i)], 'Fontsize', 13, 'Fontweight', 'Bold', 'Color', axcolor, 'VerticalAlignment', 'middle')
% end
% hold off;


% move axes up and left to make room for age groups and 'boxplots'
voffset  = 0.05;                 % set vertical offset
hoffset  = 0.01;                 % set horizontal offset
axpos    = get(gca, 'position'); % get axis position
axpos(2) = axpos(2) + voffset;   % move up bottom bound
axpos(3) = axpos(3) - hoffset;   % shrink width
axpos(4) = axpos(4) - voffset;   % shrink height
set(gca, 'position', axpos);     % apply new axes position


% add age groups (horizontal: data units; vertical: normalised units)
for i=1:size(agegroups,1)
    mf_dataTextbox([agegroups{i,2}-year_start agegroups{i,3}-year_start], [0.001 0.04], agegroups{i,1}, axcolor, axcolor, 'w');
end


% add region as text
ylims = ylim;
text(ages(1), ylims(2) + ylims(2)*0.01, [regions.name{ind_region} ' - Current pledges'],'ver','bottom','hor','left','Fontsize', 15, 'Fontweight', 'bold', 'color', axcolor)


% create new axes for 'boxplots'
axlims   = [1 12 ylim];            % axes limits of 'boxplot' panel
axpos    = get(gca, 'position');   % get axis position
axpos(1) = 0.90;                   % left bound to the right
axpos(3) = 0.10;                   % shrink width
ax2      = axes('Position',axpos); % generate new axes


% % % % plot 'boxplots': rectangle and horizontal line
% % % % rectangle('Position', [1, exposure_plot_15(end)  - exposure_mms_plot_15  ./ 2, 3, exposure_mms_plot_15 ], 'FaceColor', [color_15  0.5], 'EdgeColor', 'none', 'LineWidth', 3); hold on; % +- 0.5 std
% % % % rectangle('Position', [5, exposure_plot_20(end)  - exposure_mms_plot_20  ./ 2, 3, exposure_mms_plot_20 ], 'FaceColor', [color_20  0.5], 'EdgeColor', 'none', 'LineWidth', 3); hold on;
% % % % rectangle('Position', [9, exposure_plot_NDC(end) - exposure_mms_plot_NDC ./ 2, 3, exposure_mms_plot_NDC], 'FaceColor', [color_NDC 0.5], 'EdgeColor', 'none', 'LineWidth', 3); hold on;
% % % rectangle('Position', [1, exposure_plot_15(end)  - exposure_mms_plot_15  , 3, exposure_mms_plot_15  .* 2], 'FaceColor', [color_15  0.5], 'EdgeColor', 'none', 'LineWidth', 3); hold on; % +- 1 std
% % % rectangle('Position', [5, exposure_plot_20(end)  - exposure_mms_plot_20  , 3, exposure_mms_plot_20  .* 2], 'FaceColor', [color_20  0.5], 'EdgeColor', 'none', 'LineWidth', 3); hold on;
% % % rectangle('Position', [9, exposure_plot_NDC(end) - exposure_mms_plot_NDC , 3, exposure_mms_plot_NDC .* 2], 'FaceColor', [color_NDC 0.5], 'EdgeColor', 'none', 'LineWidth', 3); hold on;
% % % plot([1 4 ], [exposure_plot_15(end)  exposure_plot_15(end) ], '-', 'linewidth', 3, 'color', color_15 ); hold on;
% % % plot([5 8 ], [exposure_plot_20(end)  exposure_plot_20(end) ], '-', 'linewidth', 3, 'color', color_20 ); hold on;
% % % plot([9 12], [exposure_plot_NDC(end) exposure_plot_NDC(end)], '-', 'linewidth', 3, 'color', color_NDC); hold on;
% % % 
% % % 
% % % % Add labels
% % % text(2 , max(0, exposure_plot_15(end)  - exposure_mms_plot_15 ), '1.5°C ', 'color', axcolor, 'Fontsize', 12, 'Fontweight', 'Bold', 'Rotation', 90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle')
% % % text(6 , max(0, exposure_plot_20(end)  - exposure_mms_plot_20 ), '2.0°C ', 'color', axcolor, 'Fontsize', 12, 'Fontweight', 'Bold', 'Rotation', 90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle')
% % % text(10, max(0, exposure_plot_NDC(end) - exposure_mms_plot_NDC), 'NDC '  , 'color', axcolor, 'Fontsize', 12, 'Fontweight', 'Bold', 'Rotation', 90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle')


% finalise 'boxplot' plotting
axis(axlims);
set(gca, 'position', axpos, 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
axis off


% plot pictograms
ax3 = axes('Position',[0.5 0.93 0.5 0.07]); % generate new axes
imagesc(pictogram_all_1x6); hold off        % add pictogram
axis('off', 'image');                       % remove axes


end
