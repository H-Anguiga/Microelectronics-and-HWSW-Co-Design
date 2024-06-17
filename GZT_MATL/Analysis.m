% Load input data and expected results
input_data = load('input_data.txt');
expected_results = load('expected_results.txt');

% Parameters for the Goertzel filter
N = 135; % Number of samples per block
sample_freq = 4e6; % Sample frequency in Hz
target_freq = 150e3; % Target frequency to detect (150 kHz)

% Initialize output data array
num_blocks = floor(length(input_data) / N);
output_data = zeros(num_blocks, 1);

% Process each block with the Goertzel filter
for i = 1:num_blocks
    start_idx = (i-1)*N + 1;
    end_idx = start_idx + N - 1;
    block = input_data(start_idx:end_idx);
    output_data(i) = goertzel_filter(block, N, target_freq, sample_freq);
end

% Compare the output data with the expected results
if length(output_data) ~= length(expected_results)
    error('The length of output data and expected results do not match.');
end

comparison = output_data == expected_results;
if all(comparison)
    disp('Test Passed: All outputs match the expected results.');
else
    disp('Test Failed: There are differences between the output and expected results.');
    % Optionally, display mismatched results
    mismatched_indices = find(~comparison);
    disp('Mismatched indices:');
    disp(mismatched_indices);
    disp('Expected vs. Actual:');
    for idx = mismatched_indices'
        disp(['Index: ', num2str(idx), ' Expected: ', num2str(expected_results(idx)), ' Actual: ', num2str(output_data(idx))]);
    end
end

% Identify indices with high expected results
high_values_indices = find(expected_results == 65535);

% Display high output values
disp('Indices with high expected results:');
disp(high_values_indices);
disp('Corresponding output values:');
disp(output_data(high_values_indices));
