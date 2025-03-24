function FreqFeatures = features_f_domain(s_entrada, fs)
    N = length(s_entrada);
    s_espectro = fft(s_entrada);
    power = abs(s_espectro).^2/N; %densidad espectral de potencia
    pw = sum(power, 1); %potencia de cada ventana
    [bw, flo, fhi, pow99] = obw(s_entrada,fs);
    FreqFeatures = [pw; flo; fhi];
end