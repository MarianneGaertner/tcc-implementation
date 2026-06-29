function [J, yestimado] = f_custo(parametros, xmedido, ymedido)

    N = numel(ymedido);
    
    J = 0;
    yestimado = zeros(N,1);
    
    b1 = parametros(1);
    b2 = parametros(2);
    a1 = parametros(3);
    a2 = parametros(4);
    
    xbuffer = zeros(3,1);
    ybuffer = zeros(2,1);
    
    for n = 1:N
        % atualiza buffer da entrada
        xbuffer(2:end) = xbuffer(1:end-1);
        xbuffer(1) = xmedido(n);
        
        % calcula saída
        yestimado(n) = [0 b1 b2]*xbuffer - [a1 a2]*ybuffer;
        
        % atualizada buffer da saída
        ybuffer(2:end) = ybuffer(1:end-1);
        ybuffer(1) = yestimado(n);
        
        % atualiza custo
        J = J + (yestimado(n)-ymedido(n))^2;
    end
    
    % J = J/N;
end