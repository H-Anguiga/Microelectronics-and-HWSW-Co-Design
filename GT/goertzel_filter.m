function output = goertzel_filter(input_signal, N, target_freq, sample_freq)
    omega = 2 * pi * target_freq / sample_freq;
    coeff = 2 * cos(omega);
    s_prev = 0;
    s_prev2 = 0;
    for n = 1:N
        s = double(input_signal(n)) + coeff * s_prev - s_prev2;
        s_prev2 = s_prev;
        s_prev = s;
    end
    real_part = s_prev - s_prev2 * cos(omega);
    imag_part = s_prev2 * sin(omega);
    power = real_part^2 + imag_part^2;
    
    % Scale the power to match the expected results format
    max_expected_value = 65535; % Assuming 16-bit unsigned expected results
    output = power / (2^(20 * 2)); % Adjust scaling factor as needed
    output = round(output * max_expected_value); % Scale to 16-bit range
end
