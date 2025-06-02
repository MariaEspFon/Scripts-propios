registro = 18;
signal = raw_signals{registro,2};
time = linspace(0, (length(signal)-1), length(signal))/4;
figure
plot(time,signal);
hold on
registro = registro +1;
signal = raw_signals{registro,2};
time = linspace(0, (length(signal)-1), length(signal))/4;
plot(time, signal);
ylim([0 1.6])
ylabel('Amplitud (\mu S)', 'FontWeight', 'bold')
xlabel('Tiempo (s)', 'FontWeight', 'bold')
 


% figure
% plot(phtn_signals{registro,3}) % tónica
% hold on
% plot(phtn_signals{registro,2}) % fásica
% plot(filtered_signals{registro,2}) % filtrada original
% ylabel('Amplitud (\mu S)', 'FontWeight', 'bold')
% xlabel('Tiempo (s)', 'FontWeight', 'bold')
 %legend('EDA filtrada (Butterworth fc = 0.5Hz)', 'EDA sin filtro')