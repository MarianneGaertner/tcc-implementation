
function [J, ye] = f_custo_fp(pin, xin, yin, FRACTION_BITS)

J = int32(0);

% parametros da planta
b1 = pin(1);
b2 = pin(2);
a1 = pin(3);
a2 = pin(4);

xbuffer = zeros(3,1,'int32');
ybuffer = zeros(2,1,'int32');

N = numel(xin);
ye = zeros(1,N,'int32');

for n = 1:N
   % atualiza buffer da entrada
   xbuffer(3) = xbuffer(2);
   xbuffer(2) = xbuffer(1);
   xbuffer(1) = xin(n);

   % calcula saida do sistema
   aux1 = qmul(b1, xbuffer(2), FRACTION_BITS,0);
   aux2 = qmul(b2, xbuffer(3), FRACTION_BITS,0);
   aux3 = qmul(a1, ybuffer(1), FRACTION_BITS,0);
   aux4 = qmul(a2, ybuffer(2), FRACTION_BITS,0);
   
   ye(n) = qsub(qsub(qadd(aux1, aux2), aux3), aux4);
   
   % atualizada buffer da saída
   ybuffer(2) = ybuffer(1);
   ybuffer(1) = ye(n);

   % atualiza custo
   aux5 = qmul(qsub(ye(n), yin(n)), qsub(ye(n), yin(n)), FRACTION_BITS,0);
   J = qadd(J, aux5);
   
end
