function [yint, y] = f_double2sfixed(x, FRACTION_BITS)

    factor = 2^(FRACTION_BITS);
    
    yint = int32(x * factor);
    
    y = double(yint)/factor;
    
end