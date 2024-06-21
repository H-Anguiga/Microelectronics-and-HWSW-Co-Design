onbreak resume
onerror resume
vsim -voptargs=+acc work.goertzel_filter_fixpt_tb

add wave sim:/goertzel_filter_fixpt_tb/u_goertzel_filter_fixpt/input_signal
add wave sim:/goertzel_filter_fixpt_tb/u_goertzel_filter_fixpt/N
add wave sim:/goertzel_filter_fixpt_tb/u_goertzel_filter_fixpt/target_freq
add wave sim:/goertzel_filter_fixpt_tb/u_goertzel_filter_fixpt/sample_freq
add wave sim:/goertzel_filter_fixpt_tb/u_goertzel_filter_fixpt/output
add wave sim:/goertzel_filter_fixpt_tb/output_ref
run -all
