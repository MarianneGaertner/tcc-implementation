function y = f_sfixed2double(yint, FRACTION_BITS)

    factor = 2^(FRACTION_BITS);
    y = double(yint)/factor;
