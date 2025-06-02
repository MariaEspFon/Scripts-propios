function filtered_signals = filter_ema(raw_signals, filtered_signals)
    alpha = input('Elija el parámetro de suavizado para el filtro exponencial: ');
    % alpha = 2/(N+1) se comporta como un media móvil de N muestras
    % si alpha -> 0, es equivalente a tomar más muestras para hacer la ema
    % un alpha próximo a 1 reduce las muestras significativas
    for i = 1:numel(filtered_signals(:,1))
        filtered_signals{i,2} = filter(alpha, [1, alpha-1], raw_signals{i,2});
    end
end

