function TimeFeatures = features_t_domain(s)   
    s_mean = mean(s); % media
    s_desv = std(s); % desviación estándar
    s_median = median(s); % mediana
    s_max = max(s);
    s_min = min(s);
    s_dr = s_max-s_min; % rango dinámico
    s_diff1 = diff(s); % 1ª derivada
    s_diff1_median = median(s_diff1); % mediana de la 1ª derivada
    s_diff1_desv = std(s_diff1); % desviación estándar de la 1ª derivada
    s_kurt = kurtosis(s);
    s_diff2 = diff(s_diff1); %2ª Derivada
    s_diff2_desv = std(s_diff2); % desviación estándar de la 1ª derivada
    [peaks, locs] = peaks_local(s); % picos y su localización
    peaks_total = peaks';
    numSCR = numel(cell2mat(peaks_total)); % nº picos
    %sumSCR = sum(cell2mat(peaks_total)); % suma de la magnitud de los picos
    s_int = trapz(s,1); % área bajo cada ventana
    TimeFeatures = [s_mean; s_median; s_desv; s_max; s_min; s_diff1_desv; s_diff1_median; s_diff2_desv; s_int; s_kurt; numSCR];
    %TimeFeatures = [s_median; s_desv; s_max; s_min; s_diff1_desv; s_diff1_median; s_int; numSCR];
end

function [peaks_total,locs_total] = peaks_local(s)
    N = size(s, 2);
    column = 1;
    peaks_total = {};
    locs_total = {};
    while (column <= N)
        fragmento = s(:,column);
        [peaks, locs] = findpeaks(fragmento, ...
            'Threshold', 0.01); %según el artículo de Posada-Quintero
        % findpeaks considera pico toda muestra que es mayor que la muestra
        % previa y la muestra siguiente (todos los máximos locales). 
        int = cumtrapz(fragmento); %área total acumulativa bajo la ventana
        int_peaks = diff(int(locs)); %área bajo los picos
        peaks_total{end+1} = peaks;
        locs_total{end+1} = locs;
        column = column+1;
    end
end