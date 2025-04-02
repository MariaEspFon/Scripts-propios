function TnPhFeatures = convexopt(p,t,fs)
    %p se corresponde con los impulsos nerviosos sudomotores
    %r es la respuesta fásica a los impulsos p
    %t se corresponde con la componente tónica
    ph_mean = mean(p);
    tn_mean = mean(t);
    ph_stdev = std(p);
    tn_stdev = std(t);
    time = (0:length(p)-1) / fs;
    ph_auc = trapz(time,p);
    tn_auc = trapz(time,t);
    TnPhFeatures = [ph_mean; ph_stdev; ph_auc; tn_mean; tn_stdev; tn_auc];
end