clear
clc

%% Paso 1: Carga de señales y limpieza

% Carga de los CSV de interés y generación de arrays con cada señal
ruta = input('Introduzca la ruta a la base de datos EDA: '); %'/home/gordi/Escritorio/TFG/TFG Maria - Parkinson/Datos_analizados_EDA'
raw_signals = processCSVFiles(ruta);
signals = fieldnames(raw_signals);

%% Paso 2: FILTRADO
fs = 4; % frecuencia de muestreo de la señal
filtered_signals = cell(length(signals),2);
% se añaden los identificadores de las señales originales
filtered_signals(:,1) = signals;
f = input('Elija el filtrado: Butterworth paso bajo(1), mediana(2), media móvil exponencial(3)');

for i = 1:numel(signals)    
    if f == 1
        fc = input('Introduzca la frecuencia de corte deseada (sin normalizar): '); % frecuencia de corte 
        N=5; % orden del filtro
        wn = fc/(fs/2); % frecuencia de corte NORMALIZADA en relación a la
        % frecuencia de Nyquist. En nuestro caso, la frecuencia de Nyquist es 2 (fc/2)
        [b,a] = butter(N,wn,'low'); %Butterworth paso bajo
        % a y b son los coeficientes de la funcion de transferencia 
        filtered_signals{i,2} = filter(b,a,raw_signals.(signals{i}));
    elseif f == 2
        n = input('Elija el tamaño (nº impar de muestras) del filtro de mediana: ');
        filtered_signals{i,2} = medfilt1(raw_signals.(signals{i}),n);
    elseif f ==3
        alpha = input('Elija el parámetro de suavizado para el filtro exponencial: ');
        filtered_signals{i,2} = filter(alpha, [1 alpha-1], raw_signals.(signals{i}),7);
    end
end

disp('Section 2 complete: done filtering')

%% Paso 3: ENVENTANADO

% se determina la longitud que tendrán las señales enventanadas 
w_length = 30; % unidades = SEGUNDOS

windowed_signals = cell(length(signals),2);
% se añaden los identificadores de las señales originales
windowed_signals(:,1) = signals;
for i = 1:numel(signals)
    windowed_signals{i,2} = enventanar(filtered_signals{i,2},fs,w_length);
end

disp('Section 3 complete: done windowing')

%% Paso 4.1. Cálculo y extracción de características DOMINIO TEMPORAL

flag = input('choose your analysis strategy: full signal (f) or windowed signal (w): ','s');

TimeFeatures = cell(length(signals),2);
TimeFeatures(:,1) = signals;    

if flag == 'f'
    % extracción de características de las señales completas
    for i = 1:numel(signals)
        TimeFeatures{i,2} = features_t_domain(filtered_signals{i,2});
    end
    disp('Section 4.1. complete: time features extraction for whole signal')
elseif flag == 'w'
    % extracción de características de cada ventana
    for i = 1:numel(signals)
        % extracción de la señal enventanada
        w_signal = windowed_signals{i,2};
        TimeFeatures{i,2} = zeros(7,size(w_signal,2));
        for window = 1:size(w_signal, 2)
            % extracción de características a cada ventana de la señal
            t_features = features_t_domain(w_signal(:,window));
            TimeFeatures{i,2}(:,window) = cell2mat(t_features);
        end
    end
    disp('Section 4.1. complete: time features extraction for windowed signals')
else
    disp('error: wrong input')
end
% las características de un mismo registro se almacenan por columnas

%% Paso 4.2. Cálculo y extracción de características DOMINIO ESPECTRAL

FreqFeatures = cell(length(signals),2);
FreqFeatures(:,1) = signals;

if flag == 'f'
    % extracción de características de las señales completas
    for i = 1:numel(signals)
        FreqFeatures{i,2} = features_f_domain(filtered_signals{i,2});
    end
    disp('Section 4.2. complete: spectral features extraction for whole signals')

elseif flag == 'w'
    % extracción de características de cada ventana
    for i = 1:numel(signals)
        % extracción de la señal enventanada
        w_signal = windowed_signals{i,2};
        FreqFeatures{i,2} = zeros(1,size(w_signal,2));
        for window = 1:size(w_signal, 2)
            % extracción de características a cada ventana de la señal
            f_features = features_f_domain(w_signal(:,window));
            FreqFeatures{i,2}(:,window) = cell2mat(f_features);
        end
    end
    disp('Section 4.2. complete: spectral features extraction for windowed signals')
else
    disp('error: wrong input')
end

%% Paso 5. Formación del dataset

n_TFeatures = size(TimeFeatures{1,2},2);
n_FFeatures = size(FreqFeatures{1,2},2);
% feature_matrix = zeros(1+n_FFeatures+n_TFeatures,);
feature_matrix = [];

% las características de cada fragmento de señal se almacenan por columnas
for i = 1:numel(signals)
    % se agrupan las características de todos los dominios en un solo
    % vector
    features = [TimeFeatures{i,2}; FreqFeatures{i,2}];
    % etiquetado del vector de características según el estado motor
    if contains(signals(i), "ON")
        features(end+1,:) = 1;       
    else
        features(end+1,:) = 0;
    end
    feature_matrix = [feature_matrix features];
end

% se exporta la matriz de vectores de características en formato .csv
writematrix(feature_matrix','EDA_data.csv')

disp('Section 5 complete: feature matrix exported to .csv file')