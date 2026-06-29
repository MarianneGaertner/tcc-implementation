clc;
clear;
close all;

load('../DadosGerados/dados_simulacao.mat');  % carrega dados de simulacao
N = numel(x);                                 % quantidade de amostras  

figure;
subplot(2,1,1)
plot(x, 'k', 'LineWidth',1); title('Referência - Entrada x[n]');
ylabel('Amplitude'); xlabel('Amostra (n)');

subplot(2,1,2)
plot(y, 'k', 'LineWidth',1); title('Referência - Saída y[n]');
ylabel('Amplitude [V]'); xlabel('Amostra (n)');