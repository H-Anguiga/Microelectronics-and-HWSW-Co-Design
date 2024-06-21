function signal = generate_waveform(wave_type, freq, phase, N, sample_freq)
    t = (0:N-1) / sample_freq; % Time vector
    phase_rad = phase * pi / 180; % Convert phase to radians
    
    switch wave_type
        case 'sine'
            signal = sin(2 * pi * freq * t + phase_rad);
        case 'square'
            signal = square(2 * pi * freq * t + phase_rad);
        case 'triangle'
            signal = sawtooth(2 * pi * freq * t + phase_rad, 0.5);
        otherwise
            error('Unknown wave type');
    end
    
    % Convert to 16-bit integer format
    signal = round(signal * 32767); % Scale to fit 16-bit range
end
