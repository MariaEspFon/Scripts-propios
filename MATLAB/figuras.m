registro = 18;
figure
plot(phtn_signals{registro,3}) % tónica
hold on
plot(phtn_signals{registro,2}) % fásica
plot(filtered_signals{registro,2}) % filtrada original
ylabel('Amplitud (\mu S)', 'FontWeight', 'bold')
xlabel('Tiempo (s)', 'FontWeight', 'bold')
legend('Componente tónica', 'Componente fasica', 'Señal EDA filtrada')