% Testbench for Goertzel Filter with all test cases
N = 135;
sample_freq = 4e6;
target_freq = 150e3;
non_target_frequencies = [149e3, 151e3];
test_frequencies = [target_freq, non_target_frequencies];
phases = [0, 30, 45, 90, 120];
wave_types = {'sine', 'square', 'triangle'};

% Open files to store results
fileID_input = fopen('input_data.txt', 'w');
fileID_output = fopen('expected_results.txt', 'w');

% Threshold to determine if the detection is correct
threshold = 0.1; % Adjust this value based on the actual power output values

% Variables to hold test results
results = struct('frequency', [], 'phase', [], 'wave_type', [], 'power', [], 'detected', []);

for i = 1:length(wave_types)
    for j = 1:length(test_frequencies)
        for k = 1:length(phases)
            wave_type = wave_types{i};
            freq = test_frequencies(j);
            phase = phases(k);
            
            input_signal = generate_waveform(wave_type, freq, phase, N, sample_freq);
            
            % Write input signal to file
            fprintf(fileID_input, '%d\n', input_signal);
            
            % Apply Goertzel filter
            result = goertzel_filter(input_signal, N, target_freq, sample_freq);
            
            % Write expected result to file
            fprintf(fileID_output, '%d\n', result);
            
            % Check detection
            detected = false;
            if freq == target_freq
                % For target frequency, the result should be above the threshold
                if result >= threshold
                    detected = true;
                end
            else
                % For non-target frequencies, the result should be below the threshold
                if result < threshold
                    detected = false;
                end
            end
            
            % Log the results
            results(end+1) = struct('frequency', freq, 'phase', phase, 'wave_type', wave_type, 'power', result, 'detected', detected);
        end
    end
end

fclose(fileID_input);
fclose(fileID_output);

% Display the results
for r = 1:length(results)
    if results(r).frequency == target_freq
        fprintf('Frequency: %.1f Hz, Phase: %d°, Wave Type: %s, Power: %.4f, Detected: %d\n', ...
            results(r).frequency, results(r).phase, results(r).wave_type, results(r).power, results(r).detected);
    else
        fprintf('Frequency: %.1f Hz, Phase: %d°, Wave Type: %s, Power: %.4f, Not Detected: %d\n', ...
            results(r).frequency, results(r).phase, results(r).wave_type, results(r).power, ~results(r).detected);
    end
end
