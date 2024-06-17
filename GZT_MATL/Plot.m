% Parameters
N = 135;              % Number of samples per period
f_s = 4e6;            % Sampling frequency in Hz
f_0 = 150e3;          % Target frequency in Hz
num_periods = 4;      % Number of periods to plot

% Time vector for one period
t_period = (0:N-1) / f_s;

% Generate a 150 kHz sine wave signal for 4 periods
signal = zeros(1, N*num_periods);
for period = 1:num_periods
    signal((period-1)*N+1:period*N) = 0.5 * (2^12 - 1) * sin(2 * pi * f_0 * t_period) + 0.5 * (2^12 - 1);
end

% Run Goertzel filter
power_values = zeros(1, num_periods);
for period = 1:num_periods
    start_idx = (period-1)*N + 1;
    end_idx = period*N;
    power_values(period) = goertzel_filter(signal(start_idx:end_idx), N, f_0, f_s);
end

% Convert power values to binary representation
binary_representations = cell(1, num_periods);
for period = 1:num_periods
    binary_representations{period} = dec2bin(power_values(period), 16); % 16 bits for clarity
end

% Plot the sine wave and its binary representation
figure;

% Plot the sine wave
subplot(2, 1, 1);
plot(signal);
title('Sine Wave Signal');
xlabel('Sample');
ylabel('Amplitude');

% Plot the binary representation
subplot(2, 1, 2);
hold on;
for period = 1:num_periods
    binary_str = binary_representations{period};
    num_bits = length(binary_str);
    for bit = 1:num_bits
        bit_value = str2double(binary_str(bit));
        stem((period-1)*num_bits + bit, bit_value, 'filled', 'Marker', 'square', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
    end
end
title('Binary Representation of Power Values');
xlabel('Bit Index');
ylabel('Bit Value (0 or 1)');
xticks(1:num_periods*num_bits);
xticklabels({'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16'});
grid on;
hold off;

sgtitle('Sine Wave and Binary Representation');

% Goertzel filter function
function power = goertzel_filter(signal, N, f_0, f_s)
    k = round(N * f_0 / f_s); % Bin number
    omega = 2 * pi * k / N;   % Angular frequency
    coeff = 2 * cos(omega);
    
    Q1 = 0;
    Q2 = 0;
    
    for n = 1:N
        Q0 = signal(n) + coeff * Q1 - Q2;
        Q2 = Q1;
        Q1 = Q0;
    end
    
    real_part = Q1 - Q2 * cos(omega);
    imag_part = Q2 * sin(omega);
    
    power = real_part^2 + imag_part^2;
end
