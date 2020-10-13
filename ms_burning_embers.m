
% --------------------------------------------------------------------
% subroutine to compute burning-embers-type exposure
% note: preferably run "main"
% --------------------------------------------------------------------



% define parameters for burning embers plots
GMT_increment = 0.1;                                        % GMT increment [°C]
GMT_year_fut  = 2010;                                       % year in which the future starts in SR15 scenarios []
GMT_ind_fut   = find(years_SR15 == GMT_year_fut,1,'first'); % index in which the future starts in SR15 scenarios []
GMT_min       = GMT_15(GMT_ind_fut-1);                      % minimum GMT [°C] - assuming constant present-day GMT
GMT_max       = 3.5;                                        % maximum GMT [°C] - assuming constant present-day GMT
% GMT_max       = 2.5;  % for testing


% get the GMT steps
GMT_steps = 0:GMT_increment:GMT_max;
GMT_steps = [GMT_min GMT_steps(GMT_steps > GMT_min)];


% get number of GMT steps
nGMTsteps = length(GMT_steps);


% get GMT step corresponding to the 1.5°C, 2.0°C and NDC scenarios, respectively
[~, ind_15 ] = min( abs( GMT_steps - GMT_15(end)  ) );
[~, ind_20 ] = min( abs( GMT_steps - GMT_20(end)  ) );
[~, ind_NDC] = min( abs( GMT_steps - GMT_NDC(end) ) );


% construct GMT trajectories based on SR15 GMT scenarios
GMT_BE = NaN(nyears, nGMTsteps);


% fill matrix with info we have
GMT_BE(1:GMT_ind_fut-1, :      ) = repmat(GMT_15(1:GMT_ind_fut-1), [1 nGMTsteps]);
GMT_BE(GMT_ind_fut:end, 1      ) = GMT_min;                                                              % assume constant temperature
GMT_BE(GMT_ind_fut:end, end    ) = interp1([GMT_ind_fut nyears], [GMT_min GMT_max], GMT_ind_fut:nyears); % assume linear increase to maximum temperature
GMT_BE(:              , ind_15 ) = GMT_15;                                                               % put it on the right spot
GMT_BE(:              , ind_20 ) = GMT_20;                                                               % put it on the right spot
GMT_BE(:              , ind_NDC) = GMT_NDC;                                                              % put it on the right spot


% fill missing values through interpolation
GMT_BE = fillmissing(GMT_BE, 'linear', 2);


