%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                          %
%          Generated by MATLAB 9.13 and Fixed-Point Designer 7.5           %
%                                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%#codegen
function output = goertzel_filter_fixpt(input_signal, N, target_freq, sample_freq)
    fm = get_fimath();

    omega = fi(fi_div(fi(2 * pi, 0, 14, 11, fm) * target_freq, sample_freq), 0, 14, 16, fm);
    coeff = fi(fi(2, 0, 2, 0, fm) * cos(omega), 0, 14, 13, fm);
    s_prev = fi(0, 1, 14, -11, fm);
    s_prev2 = fi(0, 1, 14, -11, fm);
    for n = fi(1, 0, 1, 0, fm):N
        s = fi(double(input_signal(n)) + coeff * s_prev - s_prev2, 1, 14, -11, fm);
        s_prev2(:) = s_prev;
        s_prev(:) = s;
    end
    real_part = fi(s_prev - s_prev2 * cos(omega), 1, 14, -9, fm);
    imag_part = fi(s_prev2 * sin(omega), 1, 14, -9, fm);
    power = fi(real_part^2 + imag_part^2, 0, 14, -29, fm);
    
    % Scale the power to match the expected results format
    max_expected_value = fi(65535, 0, 16, 0, fm); % Assuming 16-bit unsigned expected results
    output = fi(fi_div_by_shift(power, 40), 0, 14, -5, fm); % Adjust scaling factor as needed
    output(:) = round(output * max_expected_value); % Scale to 16-bit range
end



function ntype = divideType(a,b)
    coder.inline( 'always' );
    nt1 = numerictype( a );
    nt2 = numerictype( b );
    maxFL = max( [ min( nt1.WordLength, nt1.FractionLength ), min( nt2.WordLength, nt2.FractionLength ) ] );
    FL = max( maxFL, 24 );
    extraBits = (FL - maxFL);
    WL = nt1.WordLength + nt2.WordLength;
    WL = min( WL, 124 );
    if (WL + extraBits)<64
        ntype = numerictype( nt1.Signed || nt2.Signed, WL + extraBits, FL );
    else
        ntype = numerictype( nt1.Signed || nt2.Signed, WL, FL );
    end
end


function c = fi_div(a,b)
    coder.inline( 'always' );
    a1 = fi( a, 'RoundMode', 'fix' );
    b1 = fi( b, 'RoundMode', 'fix' );
    nType = divideType( a1, b1 );
    if isfi( a ) && isfi( b ) && isscalar( b )
        c1 = divide( nType, a1, b1 );
        c = fi( c1, numerictype( c1 ), fimath( a ) );
    else
        c = fi( a / b, nType );
    end
end


function y = fi_div_by_shift(a,shift_len)
    coder.inline( 'always' );
    if isfi( a )
        nt = numerictype( a );
        fm = fimath( a );
        nt_bs = numerictype( nt.Signed, nt.WordLength + shift_len, nt.FractionLength + shift_len );
        y = bitsra( fi( a, nt_bs, fm ), shift_len );
    else
        y = a / 2 ^ shift_len;
    end
end

function fm = get_fimath()
	fm = fimath('RoundingMethod', 'Floor',...
	     'OverflowAction', 'Wrap',...
	     'ProductMode','FullPrecision',...
	     'MaxProductWordLength', 128,...
	     'SumMode','FullPrecision',...
	     'MaxSumWordLength', 128);
end
