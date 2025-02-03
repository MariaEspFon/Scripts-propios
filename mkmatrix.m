function s_matrix = mkmatrix(s_enventanada,TimeFeatures,FreqFeatures, state)
    length = size(s_enventanada,2); %nº ventanas de la señal
    labels = ones(length,1);
    if state == "off"
       labels = labels.*0; 
    end
    s_matrix = [TimeFeatures' FreqFeatures' labels];
end