clear;
clc;

load('../DadosGerados/dados_simulacao.mat');  % carrega dados de simulacao
param = [num(2:3), den(2:3)];                 % parâmetros da planta
N = numel(x);                                 % quantidade de amostras  

% definicao do formato de numero de ponto fixo utilizado
FRACTION_BITS = 20;
WORD_LENGTH = 32;

% transforma dados para ponto fixo
[xin, ~] = f_double2sfixed(x, FRACTION_BITS);
[yin, ~] = f_double2sfixed(y, FRACTION_BITS);
pin = f_double2sfixed(param, FRACTION_BITS);

% parametros do algoritmo pso
Runs = 200;     % numero de rodadas de execucao do algoritmo PSO
P = 100;        % numero de particulas
K = 4;          % numero de parametros a serem estimados

w = f_double2sfixed(0.7, FRACTION_BITS);
c1 = f_double2sfixed(1.4, FRACTION_BITS);
c2 = f_double2sfixed(1.4, FRACTION_BITS);

% limiares dos parâmetros estimados
threshold_high = f_double2sfixed([0, 0.25, -1.8, 1]', FRACTION_BITS);
threshold_low = f_double2sfixed([-0.2, 0.2, -2, 0.8]', FRACTION_BITS);
delta = threshold_high - threshold_low;

% valores iniciais
current_position = int32(double(repmat(delta,1,P)).*rand(K,P)) + repmat(threshold_low,1,P);
current_velocity = int32(double(repmat(delta,1,P)).*rand(K,P)) + repmat(threshold_low,1,P);

% demais parametros do algoritmo PSO
best_personal_position = current_position;
best_global_position = zeros(K,1, 'int32');

% melhores valores da funcoes custo (pessoal e global)
best_personal_cost = int32(Inf)*ones(1,P, 'int32');
best_global_cost = int32(Inf);

%% execucao do algoritmo PSO
tic
for r = 1:Runs
    
    fprintf('Iteração: %d/%d\n', r, Runs);
    
    for p = 1:P
         
        % avaliação da funcao custo para cada particula
        current_cost = f_custo_fp(current_position(:,p), xin, yin, FRACTION_BITS);
        
        if current_cost < best_personal_cost(p)
            best_personal_cost(p) = current_cost;
            best_personal_position(:,p) = current_position(:,p);
            
            if current_cost < best_global_cost
                best_global_cost = current_cost;
                best_global_position = current_position(:,p);
            end
        end
        
        % atualiza velocidade das particulas
        r1 = int32(randi(2^FRACTION_BITS, K, 1));
        r2 = int32(randi(2^FRACTION_BITS, K, 1));
        
        aux1 = qmul(w, current_velocity(:,p), FRACTION_BITS,0);
        
        aux20 = qmul(r1, qsub(best_personal_position(:,p), current_position(:,p)), FRACTION_BITS,1);
        aux2 = qmul(c1, aux20, FRACTION_BITS,0);
       
        aux30 = qmul(r2, qsub(best_global_position, current_position(:,p)), FRACTION_BITS,1);
        aux3 = qmul(c2, aux30, FRACTION_BITS,0);        
        
        current_velocity(:,p) = qadd(aux1, qadd(aux2, aux3));
        
        % atualiza posicao das particulas     
        current_position(:,p) = qadd(current_position(:,p), current_velocity(:,p));
        
        % verifica intervalos
        ind1 = current_position(:,p) > threshold_high;
        current_position(ind1,p) = threshold_high(ind1);
        
        ind2 = current_position(:,p) < threshold_low;
        current_position(ind2,p) = threshold_low(ind2); 
          
    end    
end
toc

%% avalia resultado
[~, yestimado] = f_custo_fp(best_global_position, xin, yin, FRACTION_BITS);

figure; plot(yin, 'b:', 'linewidth', 1); hold on; plot(yestimado, 'k', 'linewidth', 1);
legend('Referência', 'Saída estimada');
xlabel('Amostra (n)'); ylabel('Amplitude');

fprintf('\nResultados:\n');
for k = 1:K
   fprintf('%10.4f\t%10.4f\n', f_sfixed2double(pin(k),FRACTION_BITS), f_sfixed2double(best_global_position(k),FRACTION_BITS)); 
end
