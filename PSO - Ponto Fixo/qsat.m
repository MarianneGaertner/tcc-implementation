function y = qsat(x)
%QSAT Saturação para int32
%
% Entrada:
%   x : int64 (ou compatível)
%
% Saída:
%   y : int32 saturado

    MAX32 = int64(intmax('int32'));
    MIN32 = int64(intmin('int32'));

    x(x > MAX32) = MAX32;
    x(x < MIN32) = MIN32;

    y = int32(x);

end