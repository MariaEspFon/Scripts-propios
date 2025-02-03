function TimeFeatures = features_t_domain(s)   
    s_mean = mean(s); % media
    s_desv = std(s); % desviación estándar
    s_max = max(s);
    s_min = min(s);
    s_rd = s_max-s_min; % rango dinámico
    s_median = median(s); % mediana
    s_diff1 = diff(s); % 1a derivada
    s_mean_diff1 = mean(s_diff1); % media de la 1a derivada
    [peaks, locs] = peaks_local(s); % picos y su localización
    peaks_total = peaks';
    numSCR = numel(cell2mat(peaks_total)); % nº picos
    sumSCR = sum(cell2mat(peaks_total)); % suma de la magnitud de los picos
    s_int = trapz(s,1); % área bajo cada ventana
    TimeFeatures = {s_median; s_desv; s_max; s_min; numSCR; s_int};
end

function [peaks_total,locs_total] = peaks_local(s)
    N = size(s, 2);
    column = 1;
    peaks_total = {};
    locs_total = {};
    while (column <= N)
        fragmento = s(:,column);
        [peaks, locs] = findpeaks(fragmento);
        %findpeaks considera pico toda muestra que es mayor que la muestra
        %previa y la muestra siguiente. Habría que matizar un poco qué
        %consideramos "pico" para nuestro estudio (umbral, prominencia...)
        int = cumtrapz(fragmento); %área total acumulativa bajo la ventana
        int_peaks = diff(int(locs)); %área bajo los picos
        peaks_total{end+1} = peaks;
        locs_total{end+1} = locs;
        column = column+1;
    end
end