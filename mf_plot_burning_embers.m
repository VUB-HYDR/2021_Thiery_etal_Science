

% --------------------------------------------------------------------
% function to plot domain data
% --------------------------------------------------------------------


function [] = mf_plot_burning_embers(ages, GMT_BE, EMF_region_plot_BE, PCT_region_plot_BE, colormap_BE, caxes_BE, ind_region, ind_extreme, age_ref, agegroups, regions, year_start, nextremes, panelletters_regions, extremes, extremes_legend, axcolor, flags_text, aggregation_method)



% --------------------------------------------------------------------
% Initialisation
% --------------------------------------------------------------------


% get alphabet                               
alphabet = char(repmat('a' + (1:26) - 1, [2 1]))';

    
% define unprecedented
prob_unprecedented = 99.99; % 1 in 10000


% define contour colors
color_PCT     = [0.85 0.85 0.85]; % light grey



% --------------------------------------------------------------------
% manipulations: 
% --------------------------------------------------------------------


% get number of GMT steps
nGMTsteps = size(EMF_region_plot_BE, 1);


% apply a three-element moving average in the vertical
EMF_region_plot_BE = movmean(EMF_region_plot_BE, 3 ,1);



% --------------------------------------------------------------------
% Visualisation
% --------------------------------------------------------------------



% visualisation
figure
set(gcf, 'color', 'w');
imagesc(ages, GMT_BE(end,:), EMF_region_plot_BE); hold on;
cbh=colorbar;
colormap(colormap_BE)
caxis(caxes_BE)
set(gca, 'XDir', 'reverse', 'YDir', 'normal', 'Fontsize', 15, 'Fontweight', 'Bold', 'Xcolor', axcolor, 'Ycolor', axcolor);
xlabel('Age in 2020', 'Fontsize', 15, 'Fontweight', 'Bold'); 
ylabel('GMT change relative to PI [°C]', 'Fontsize', 15, 'Fontweight', 'Bold'); 
hold on;


% add PCT contours
if ind_region == 12 && ind_extreme == 6  % global tropical cyclones

    % fit a polynomial
    for i=1:nGMTsteps
        if ~isempty(find(PCT_region_plot_BE(i,:) > prob_unprecedented, 1, 'first'))
            [~, unprecedented_col(i,1)]=find(PCT_region_plot_BE(i,:) > prob_unprecedented, 1, 'first');
        else
            unprecedented_col(i,1) = age_ref+1;
        end
    end
    p = polyfit(GMT_BE(end,:), age_ref+1 - unprecedented_col, 4);
    f1 = polyval(p,GMT_BE(end,:));
    %plot(age_ref+1 - unprecedented_col, GMT_BE(end,:), '+', 'Color', 'r', 'LineWidth', 2); hold on

    % plot contour
    plot(f1', GMT_BE(end,:), 'Color', color_PCT, 'LineWidth', 2); hold on

else                                      % all other cases

    % apply a three-element moving average in the vertical
    PCT_region_plot_BE = movmean(PCT_region_plot_BE, 3 ,1);

    % plot contour
    [~, ~] = contour(ages, GMT_BE(end,:), PCT_region_plot_BE,  [-999 prob_unprecedented], 'LineColor', color_PCT, 'LineWidth', 2); hold on;

end


% add panel labels
if     flags_text == 1   % letter & region - supplementary figures 3 & 4

    % add panel letter and region as text
    text(ages(1),GMT_BE(end,end) + 0.03, [panelletters_regions{ind_region} ' ' regions.name{ind_region}],'ver','bottom','hor','left','Fontsize', 15, 'Fontweight', 'bold', 'color', axcolor)

elseif flags_text == 2   % letter & extreme - main figure 2

    % add extreme as text
    if ind_extreme <= nextremes
    text(ages(end-7),GMT_BE(end,end) + 0.03, extremes_legend{ind_extreme},'ver','bottom','hor','right','Fontsize', 16, 'Fontweight', 'bold', 'color', axcolor)
    end

    % add panel letter
    text(ages(1),GMT_BE(end,end) + 0.03, alphabet(ind_extreme),'ver','bottom','hor','left','Fontsize', 16, 'Fontweight', 'bold', 'color', axcolor)

elseif flags_text == 3   % letter & aggregation method - supplementary figures 5

    % add panel letter and region as text
    text(ages(1),GMT_BE(end,end) + 0.03, aggregation_method,'ver','bottom','hor','left','Fontsize', 15, 'Fontweight', 'bold', 'color', axcolor)

end


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
y1=get(gca,'position');                                                       % make colorbar thinner
y=get(cbh,'Position');
y(1)=y(1)+0.05;
y(3)=0.025;
set(cbh,'Position',y);
set(gca,'position',y1);
mf_cbarrow;                                                                   % add pointy ends
if ind_extreme == 5 % heatwaves
    BE_ticks = [1 10 20 30];
else
    BE_ticks = caxes_BE(:,1):caxes_BE(:,2); % generate colorbar ticks
end
for i=1:length(BE_ticks) % generate colorbar ticklabels
    BE_ticklabels{i} = ['\times' num2str(BE_ticks(i))];  %#ok<AGROW>
end
set(cbh, 'color', axcolor, 'Ticks', BE_ticks, 'Ticklabels', BE_ticklabels);   % add ticks and labels


% load and plot pictograms
if ind_extreme == nextremes+1
    pictogram = imadjust(imcomplement(imread('pictogram_all_1x6.png')),[0.3 0.3 0.3; 1 1 1],[]);
else
    pictogram = imadjust(imcomplement(imread(['pictogram_' extremes{ind_extreme} '.png'])),[0.3 0.3 0.3; 1 1 1],[]);
end
ax2 = axes('Position',[0.5 0.93 0.5 0.07]); %#ok<NASGU>
imagesc(pictogram); hold off   % add pictogram
axis('off', 'image');


end
