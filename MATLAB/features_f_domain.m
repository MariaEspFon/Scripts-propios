function FreqFeatures = features_f_domain(s_entrada, fs)
    N = length(s_entrada);
    s_espectro = fft(s_entrada);
    %{
    Representación del espectro
    S = abs(s_espectro/N);
    S = S(1:N/2+1);
    %como el espectro se ha reducido a un solo lado, se deben duplicar los
    %coeficientes entre la frecuencia DC y la frecuencia de Nyquist
    S(2:end-1) = 2*S(2:end-1);
    f = fs*(0:(N/2))/N;
    plot(f,S);
    %}
    power = abs(s_espectro).^2/N; %densidad espectral de potencia
    pw = sum(power, 1); %potencia de cada ventana
    [bw, flo, fhi, pow99] = obw(s_entrada,fs);
    FreqFeatures = [pw; bw; fhi];
    %FreqFeatures = pw;
end