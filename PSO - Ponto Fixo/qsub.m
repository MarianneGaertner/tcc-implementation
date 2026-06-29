function y = qsub(a, b)
%QSUB Subtração com saturação para int32
%
% Entradas:
%   a, b : int32
%
% Saída:
%   y    : int32 saturado

    temp = int64(a) - int64(b);
    y = qsat(temp);

end