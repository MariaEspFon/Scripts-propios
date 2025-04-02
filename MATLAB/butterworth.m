function filtered_signals = butterworth(raw_signals, fs, filtered_signals)
    order = input('Elija el orden del filtro Butterworth: ');
    fc = input('Introduzca la frecuencia de corte deseada (sin normalizar): '); % frecuencia de corte 
    wn = fc/(fs/2); % frecuencia de corte NORMALIZADA en relación a la
    % frecuencia de Nyquist. En nuestro caso, la frecuencia de Nyquist es 2 (fc/2)
    [b,a] = butter(order,wn,'low'); %Butterworth paso bajo
    % a y b son los coeficientes de la funcion de transferencia 
    for i = 1:numel(filtered_signals(:,1))
        filtered_signals{i,2} = filter(b,a,raw_signals{i,2});
    end
end

