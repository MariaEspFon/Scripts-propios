function csvData = processCSVFiles(baseDir, csvData)
    % Esta función encuentra y accede a la información de archivos .csv
    % guardados en un sistema de directorios
    % INPUT:
    %   baseDir - String, el directorio base desde donde comenzar a buscar
    % OUTPUT:
    %   csvData - Struct que contiene los datos extraídos de cada .csv
    %   encontrado

    csvData = {};
    index = 1;
    % Lista de archivos y directorios existentes en el directorio base
    entries = dir(baseDir);

    for i = 1:length(entries)
        % nombre y ruta absoluta de la entrada actual
        entryName = entries(i).name;
        fullPath = fullfile(baseDir, entryName);
        % se ignoran en la búsqueda la ruta de ejecución y el directorio
        % padre, incluidos en la lista de entradas
        if entries(i).isdir
            if strcmp(entryName, '.') || strcmp(entryName, '..') || ...
                    strcmp(entryName,'EDA04') || strcmp(entryName,'EDA016')...
                    || strcmp(entryName,'EDA018')
                continue;
            end
            % Búsqueda recursiva
            subDirData = processCSVFiles(fullPath, csvData);
            % Combinar los resultados recursivos en el struct principal
            csvData = [csvData; subDirData];
            
        elseif endsWith(entryName, '.csv', 'IgnoreCase', true)
            % leer archivo .csv
            tableData = readtable(fullPath);
            arrayData = table2array(tableData);
            % crear un identificador basado en el nombre del archivo
            [~, fileName] = fileparts(entryName);
            nameData = matlab.lang.makeValidName(fileName,'Prefix','s_');
            % guardar los datos asociados a su identificador en el struct
            csvData{index,1} = nameData; 
            csvData{index,2} = arrayData;
            index = index + 1;
            fprintf('Archivo procesado: %s\n', fullPath);
        end
    end
end