function FreqFeatures = features_f_domain(s_entrada)
    s_espectro = fft(s_entrada);
    power = abs(s_espectro).^2/length(s_entrada); %densidad espectral de potencia
    pw = sum(power, 1); %potencia de cada ventana
    FreqFeatures = {pw};
end