clear
clc

%% Paso 1: Carga de señales y limpieza

% Carga de los CSV de interés y generación de arrays con cada señal
raw_signals = processCSVFiles('/home/gordi/Escritorio/TFG/TFG Maria - Parkinson/Datos_analizados_EDA');
signals = fieldnames(raw_signals);

%% Paso 2: FILTRADO
fs = 4; % frecuencia de muestreo de la señal
% Parámetros del filtro Paso Bajo
fc = 1; % frecuencia de corte porque....
N=5; % orden del filtro
wn = fc/(fs/2); 
% esta variable es la frecuencia de corte NORMALIZADA en relación a la
% frecuencia de Nyquist. En nuestro caso, la frecuencia de Nyquist es 2 (la
% máxima frecuencia de nuestra señal dada la fs)

% diseña un filtro Butterworth de paso bajo
% a y b son los coeficientes de la funcion de transferencia 
[b,a] = butter(N,wn,'low'); % devuelve los coeficientes de función de transferencia de un filtro Butterworth digital de paso bajo de la orden con frecuencia de corte normalizada 

filtered_signals = cell(length(signals),2);
% adding identifiers
filtered_signals(:,1) = signals;
for i = 1:numel(signals)
    filtered_signals{i,2} = filter(b,a,raw_signals.(signals{i}));
end

disp('Section 2 complete: done filtering')

%% Paso 3: ENVENTANADO

%   0. Comprobamos la normalidad de las señales con el test Shapiro-Wilk
%   (swft.m)
%[SWOFF, SFOFF] = swft(sf);

% determine the size of signal fragments in secconds
w_length = 30;

windowed_signals = cell(length(signals),2);
% add identifiers
windowed_signals(:,1) = signals;
for i = 1:numel(signals)
    windowed_signals{i,2} = enventanar(filtered_signals{i,2},fs,w_length);
end

disp('Section 3 complete: done windowing')

%% Paso 4.1. Cálculo y extracción de características DOMINIO TEMPORAL

flag = input('choose your analysis strategy: full signal (f) or windowed signal (w): ','s');

if flag == 'f'
    % analysis for complete signal
    TimeFeatures = cell(length(signals),2);
    TimeFeatures(:,1) = signals;
    for i = 1:numel(signals)
        TimeFeatures{i,2} = features_t_domain(filtered_signals{i,2});
    end
    disp('Section 4.1. complete: time features extraction for whole signal')
elseif flag == 'w'
    % analysis for each window
    TimeFeatures_w = cell(length(signals),2);
    TimeFeatures_w(:,1) = signals;
    for i = 1:numel(signals)
        % get windowed signal
        w_signal = windowed_signals{i,2};
        TimeFeatures_w{i,2} = zeros(6,size(w_signal,2));
        for window = 1:size(w_signal, 2)
            %extract features and save
            t_features = features_t_domain(w_signal(:,window));
            TimeFeatures_w{i,2}(:,window) = cell2mat(t_features);
        end
    end
    disp('Section 4.1. complete: time features extraction for windowed signals')
else
    disp('error: wrong input')
end
% features are stored by columns

%% Paso 4.2. Cálculo y extracción de características DOMINIO ESPECTRAL

if flag == 'f'
    % analysis for complete signal
    FreqFeatures = cell(length(signals),2);
    FreqFeatures(:,1) = signals;
    for i = 1:numel(signals)
        FreqFeatures{i,2} = features_f_domain(filtered_signals{i,2});
    end
    disp('Section 4.2. complete: spectral features extraction for whole signals')

elseif flag == 'w'
    % analysis for each window
    FreqFeatures_w = cell(length(signals),2);
    FreqFeatures_w(:,1) = signals;
    for i = 1:numel(signals)
        % get windowed signal
        w_signal = windowed_signals{i,2};
        FreqFeatures_w{i,2} = zeros(1,size(w_signal,2));
        for window = 1:size(w_signal, 2)
            % extract features and save
            f_features = features_f_domain(w_signal(:,window));
            FreqFeatures_w{i,2}(:,window) = cell2mat(f_features);
        end
    end
    disp('Section 4.2. complete: spectral features extraction for windowed signals')
else
    disp('error: wrong input')
end

%% Paso 4.3. Extracción de características tónica-fásica


%% Paso 5. Formación del dataset

if flag == 'f'
    
elseif flag == 'w'

end
