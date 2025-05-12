function T = durations(raw_signals)
    durations_off = [];
    durations_on = [];
    for i = 1:numel(raw_signals(:,1))
        if mod(i,2) ~= 0
            durations_off = [durations_off length(raw_signals{i,2})/(4*60)];
            % duraciones en minutos
        else
            durations_on = [durations_on length(raw_signals{i,2})/(4*60)];
        end
    end
    
    total_off = sum(durations_off);
    total_on = sum(durations_on);
    mean_duration_off = (total_off/(numel(raw_signals(:,1))/2));
    mean_duration_on = (total_on/(numel(raw_signals(:,1))/2));
    std_dev_duration_off = std(durations_off);
    std_dev_duration_on = std(durations_on);
    mean_duration = (sum(durations_off)+sum(durations_on))/numel(raw_signals(:,1));
    std_dev_duration = std([durations_off durations_on]);
    
    % Combinar media y desviación estándar en formato texto
    mean_std_off = sprintf('%.2f ± %.2f', mean_duration_off, std_dev_duration_off);
    mean_std_on = sprintf('%.2f ± %.2f', mean_duration_on, std_dev_duration_on);
    overall_mean_std = sprintf('%.2f ± %.2f', mean_duration, std_dev_duration);
    
    metric_values = {num2str(total_off); num2str(total_on); mean_std_off; mean_std_on; overall_mean_std};
    metric_names = {'Tiempo total de registro en estado OFF (min)', ...
        'Tiempo total de registro en estado ON (min)', ...
        'Duración media de registros OFF (min)', ...
        'Duración media de registros ON (min)', ...
        'Duración media global de los registros (min)'};
    
    T = table(metric_values, 'RowNames', metric_names, 'VariableNames', {'Value'});
    
    % Mostrar en consola
    disp(newline)
    disp('Análisis de duración temporal EDA');
    disp(T);
    
    % { Mostrar en nueva ventana (opcional)
    % f = figure('Name', 'Análisis de duración temporal EDA');
    % uitable(f, 'Data', metric_values, 'RowName', metric_names, ...
    %     'ColumnName', {'Value'}, 'Units', 'Normalized', 'Position', [0, 0, 1, 1], ...
    %     'ColumnWidth', {'auto', 150});
end

