%TEST_SIMUL simple script to test reconstruction accuracy of the cvxEDA method
%   (see http://dx.doi.org/10.1109/TBME.2015.2474131).

% ______________________________________________________________________________
%
% File:                         test_simul.m
% Last revised:                 01 Oct 2015 r67
% ______________________________________________________________________________
%
% Copyright (C) 2015 Luca Citi
% 
% This program is free software; you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free Software
% Foundation; either version 3 of the License, or (at your option) any later
% version.
% 
% This program is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
% You may contact the author by e-mail (lciti@ieee.org).
% ______________________________________________________________________________
%
% This algorithm was used in:
% A Greco, G Valenza, A Lanata, EP Scilingo, and L Citi
% "cvxEDA: a Convex Optimization Approach to Electrodermal Activity Processing"
% IEEE Transactions on Biomedical Engineering, 2015
% DOI: 10.1109/TBME.2023.24741
%
% If you use this program in support of published research, please include a
% citation of the reference above. If you use this code in a software package,
% please explicitly inform the end users of this copyright notice and ask them
% to cite the reference above in their published research.
% ______________________________________________________________________________

close all
clearvars

addpath('../src/')

delta = 1/4;

% SIMULATION
tau1 = .7;
tau0_min = 2;
tau0_max = 4;

% ESTIMATION
fit_edr_model = @cvxEDA;
delta_knot = 10; % sec
alpha = 8e-4;
gamma = 1e-2;
tau0_step = .2;
tau0_ = tau0_min:tau0_step:tau0_max;

%% Carga de los CSV de interés

raw_signals = {};
ruta = '/home/gordi/Escritorio/TFG/TFG Maria - Parkinson/Datos_analizados_EDA';
%ruta = input('Introduzca la ruta a la base de datos EDA: '); %'/home/gordi/Escritorio/TFG/TFG Maria - Parkinson/Datos_analizados_EDA'
raw_signals = processCSVFiles(ruta, raw_signals);

%% análisis con una señal aleatoria
idx = randi(size(raw_signals,1));
signal = raw_signals{24,2};
% estimation
T = length(signal);
t = (0:1:T-1)*delta;
for i = length(tau0_):-1:1
    [phasic{i}, smna{i}, tonic{i}, l{i}, d{i}, e{i}] = fit_edr_model(...
        signal(:), delta, tau1, tau0_(i), delta_knot, alpha, gamma);
end
res_e = cellfun(@norm, e);
[~,best] = min(res_e);

figure
plot(tau0_, res_e)

figure, hold all
plot(t, signal)
plot(t, tonic{best})
plot(t, smna{best}*delta)


%% análisis para todas las señales

for j = 1:size(raw_signals,1) 
    signal = raw_signals{j,2};
    % estimation
    T = length(signal);
    t = (0:1:T-1)*delta;
    for i = length(tau0_):-1:1
        [phasic{i}, smna{i}, tonic{i}, l{i}, d{i}, e{i}] = fit_edr_model(...
            signal(:), delta, tau1, tau0_(i), delta_knot, alpha, gamma);
    end
    res_e = cellfun(@norm, e);
    [~,best] = min(res_e);

    figure
    plot(tau0_, res_e)

    figure, hold all
    plot(t, signal)
    plot(t, tonic{best})
    plot(t, smna{best}*delta)
end

