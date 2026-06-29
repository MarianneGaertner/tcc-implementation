clear;
clc;
%close all;
%% 
% Estimacao dos coeficientes de função de transferencia de segunda ordem
% utilizando o algoritmo PSO (Particle Swarm Optimization)

% carrega as amostras de entrada e saída do sistema
load('../DadosGerados/dados_simulacao.mat');

%% parametros do algoritmo PSO
Runs = 200;     % numero de rodadas de execução do algoritmo PSO
P = 100;        % numero de particulas
K = 4;          % numero de parametros a serem estimados

w = 0.7;        % coeficiente de amortecimento
% w_max = 0.7;
% w_min = 0.7;

c1 = 1.4;
c2 = 1.4;

% limiares dos parâmetros estimados
threshold_high = [0, 0.25, -1.8, 1]';
threshold_low = [-0.2, 0.2, -2, 0.8]';
delta = threshold_high - threshold_low;

% valores iniciais
current_position = repmat(delta,1,P).*rand(K,P) + repmat(threshold_low,1,P);
current_velocity = repmat(delta,1,P).*rand(K,P) + repmat(threshold_low,1,P);

% demais parametros do algoritmo PSO
best_personal_position = current_position;
best_global_position = zeros(K,1);

% melhores valores da funcoes custo (pessoal e global)
best_personal_cost = Inf*ones(1,P);
best_global_cost = Inf;

%% execucao do algoritmo PSO
tic
for r = 1:Runs
    
    fprintf('Iteração: %d/%d\n', r, Runs);  
    
    for p = 1:P
        
        % avaliação da funcao custo para cada particula
        current_cost = f_custo(current_position(:,p), x, y);
        
        if current_cost < best_personal_cost(p)
            best_personal_cost(p) = current_cost;
            best_personal_position(:,p) = current_position(:,p);
            
            if current_cost < best_global_cost
                best_global_cost = current_cost;
                best_global_position = current_position(:,p);
            end
        end
               
        % atualiza velocidade das particulas
        r1 = rand(K,1);
        r2 = rand(K,1);
                
        current_velocity(:,p) = w*current_velocity(:,p) +...
            c1*r1.*(best_personal_position(:,p) - current_position(:,p)) +...
            c2*r2.*(best_global_position - current_position(:,p));
        
        % atualiza posicao das particulas
        current_position(:,p) = current_position(:,p) + current_velocity(:,p);
        
        % verifica intervalos
        ind1 = current_position(:,p) > threshold_high;
        current_position(ind1,p) = threshold_high(ind1);
        
        ind2 = current_position(:,p) < threshold_low;
        current_position(ind2,p) = threshold_low(ind2);        
    end
end
toc
%% avalia resultado
[~, yestimado] = f_custo(best_global_position, x, y);

figure; plot(y, 'b:' ,'linewidth', 1); hold on; plot(yestimado, 'k', 'linewidth', 1);
legend('Referência','Saída estimada');
xlabel('Amostra (n)'); ylabel('Amplitude');

parametros = [num(2:3), den(2:3)]';
fprintf('\nResultados:\n');
for k = 1:K
   fprintf('%10.4f\t%10.4f\n', parametros(k), best_global_position(k)); 
end