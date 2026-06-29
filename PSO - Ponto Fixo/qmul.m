function y = qmul(a, b, FRACTION_BITS,flag)
%QMUL Multiplicação em ponto fixo com arredondamento e saturação
%
% Entradas:
%   a, b           : int32 em formato Qm.n
%   FRACTION_BITS  : número de bits fracionários
%
% Saída:
%   y              : int32 em formato Qm.n
%
% Implementa:
%
%   y = round((a*b)/2^FRACTION_BITS)
%
% usando:
%
%   temp = a*b + 2^(FRACTION_BITS-1)
    if flag==1
        temp = int64(a) .* int64(b);
    else
        temp = int64(a) * int64(b);
    end 
    %temp = int64(a) * int64(b);
    % arredondamento
    temp = temp + bitshift(int64(1), FRACTION_BITS-1);

    % reescala
    temp = bitshift(temp, -FRACTION_BITS);

    % saturação
    y = qsat(temp);

end