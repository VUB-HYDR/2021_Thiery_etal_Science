

% --------------------------------------------------------------------
% function to plot domain data
% --------------------------------------------------------------------


function [cbh] = mf_plot_burningember2(trans, caxis_dom, colormap_orig, ncategories, nsteps, location, flag_sp, experiment)



% --------------------------------------------------------------------
% Initialisation
% --------------------------------------------------------------------


% define axes color                               
axcolor  = [0.3 0.3 0.3]; % 70% contrast (so 0.3) is advised
seacolor = [0.8 0.8 0.8]; % light grey



% --------------------------------------------------------------------
% manipulations: set transitions and interpolate
% --------------------------------------------------------------------


% put transitions in the right location (i.e. mark span of undetectable, moderate, high and very high)
cdata          = [caxis_dom(1)        ...
                  trans.und2mod_start ... % GMT rise marking the start of the transition from undetectable to moderate  impacts [°C]
                  trans.und2mod_end   ... % GMT rise marking the end   of the transition from undetectable to moderate  impacts [°C]
                  trans.mod2hig_start ... % GMT rise marking the start of the transition from moderate     to high      impacts [°C]
                  trans.mod2hig_end   ... % GMT rise marking the end   of the transition from moderate     to high      impacts [°C]
                  trans.hig2vhi_start ... % GMT rise marking the start of the transition from high         to very high impacts [°C]
                  trans.hig2vhi_end   ... % GMT rise marking the end   of the transition from high         to very high impacts [°C]
                  caxis_dom(2)          ]; 

              
% add 4 main colors associated with the four regions             
cdata(2:4,1:8) = kron(colormap_orig,ones(2,1))';


% cut out a category (only cuts if number of categories (undetectable - moderate - high - very high) is less than four)
cdata = cdata(:, 1:ncategories*2);


% generate vector for indices to which the original color map should be interpolated
indices_tot = linspace(caxis_dom(1), caxis_dom(2), nsteps)';


% interp RGB values
R = interp1(cdata(1,:),cdata(2,:),indices_tot);
G = interp1(cdata(1,:),cdata(3,:),indices_tot);
B = interp1(cdata(1,:),cdata(4,:),indices_tot);


% collect data
colormap_interp = [R G B];



% --------------------------------------------------------------------
% Visualisation
% --------------------------------------------------------------------


% design figure
if flag_sp == 0
figure
set(gcf, 'color', 'w');
set(gca,'color','w');
end


% plot data
set(gca, 'Fontsize', 14, 'Fontweight', 'Bold');                                                                    % set axes properties
caxis(caxis_dom);                                                                                                  % set colorscale axes
colormap(colormap_interp); mf_freezeColors;                                                                        % select colormap and freeze it
cbh=colorbar('Fontsize', 14, 'Fontweight', 'Bold', 'color', axcolor, 'location', location); hold on; 
set(gca,'visible', 'off')
hold on;


% add text
text(-0.17,1.03,experiment,'ver','bottom','hor','center', 'Fontweight', 'Bold', 'Fontsize', 12, 'color', axcolor); hold on;


end
