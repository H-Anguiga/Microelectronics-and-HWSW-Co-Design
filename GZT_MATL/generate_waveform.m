function signal = generate_waveform(wave_type, freq, phase, N, sample_freq)
    t = (0:N-1) / sample_freq;
    phase_rad = deg2rad(phase);
    switch wave_type
        case 'sine'
            signal = 2048 + 2047 * sin(2 * pi * freq * t + phase_rad);
        case 'square'
            signal = 2048 + 2047 * square(2 * pi * freq * t + phase_rad);
        case 'triangle'
            signal = 2048 + 2047 * sawtooth(2 * pi * freq * t + phase_rad, 0.5);
        otherwise
            error('Unknown waveform type');
    end
    signal = uint16(signal);  % Convert to 12-bit unsigned
end
