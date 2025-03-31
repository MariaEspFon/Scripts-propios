function filtered_signals = filter_median(raw_signals, signals, filtered_signals)
    n = input('Elija el tamaño (nº impar de muestras) del filtro de mediana: ');
    for i = 1:numel(raw_signals(:,1))
        filtered_signals{i,2} = medfilt1(raw_signals{i,2},n);
    end
end