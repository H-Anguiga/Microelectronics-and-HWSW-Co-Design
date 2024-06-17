% Testbench for Goertzel Filter with all test cases
N = 135;
sample_freq = 4e6;
target_freq = 150e3;
test_frequencies = [150e3, 149e3, 151e3, 5e3, 200e3];
phases = [0, 30, 45, 90, 120];
wave_types = {'sine', 'square', 'triangle'};

% Open files to store results
fileID_input = fopen('input_data.txt', 'w');
fileID_output = fopen('expected_results.txt', 'w');

for wave_type = wave_types
    for freq = test_frequencies
        for phase = phases
            input_signal = generate_waveform(wave_type{1}, freq, phase, N, sample_freq);
            
            % Write input signal to file
            fprintf(fileID_input, '%d\n', input_signal);
            
            % Apply Goertzel filter
            result = goertzel_filter(input_signal, N, target_freq, sample_freq);
            
            % Write expected result to file
            fprintf(fileID_output, '%d\n', result);
        end
    end
end

fclose(fileID_input);
fclose(fileID_output);
