function csvData = processCSVFiles(baseDir)
    % Esta función encuentra y accede a la información de archivos .csv
    % guardados en un sistema de directorios
    % INPUT:
    %   baseDir - String, el directorio base desde donde comenzar a buscar
    % OUTPUT:
    %   csvData - Struct que contiene los datos extraídos de cada .csv
    %   encontrado

    csvData = struct();

    % Lista de archivos y directorios existentes en el directorio base
    entries = dir(baseDir);

    for i = 1:length(entries)
        % nombre y ruta absoluta de la entrada actual
        entryName = entries(i).name;
        fullPath = fullfile(baseDir, entryName);
        % se ignoran en la búsqueda la ruta de ejecución y el directorio
        % padre, incluidos en la lista de entradas
        if entries(i).isdir
            if strcmp(entryName, '.') || strcmp(entryName, '..') || strcmp(entryName,'EDA04')
                continue;
            end
            % Búsqueda recursiva
            subDirData = processCSVFiles(fullPath);
            % Combinar los resultados recursivos en el struct principal
            csvData = mergeStructs(csvData, subDirData);

        elseif endsWith(entryName, '.csv', 'IgnoreCase', true)
            % leer archivo .csv
            tableData = readtable(fullPath);
            arrayData = table2array(tableData);
            % crear un identificador basado en el nombre del archivo
            [~, fileName] = fileparts(entryName);
            fieldName = matlab.lang.makeValidName(fileName,'Prefix','s_');
            % guardar los datos asociados a su identificador en el struct
            csvData.(fieldName) = arrayData;
            fprintf('Archivo procesado: %s\n', fullPath);
        end
    end
end

function mergedStruct = mergeStructs(struct1, struct2)
    % función auxiliar para combinar los datos de dos structs en una
    % variable struct única
    mergedStruct = struct1;
    fields2 = fieldnames(struct2);
    for i = 1:length(fields2)
        mergedStruct.(fields2{i}) = struct2.(fields2{i});
    end
end
