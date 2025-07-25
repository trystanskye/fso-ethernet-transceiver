function ber = calculate_ber(binary_signal)
% Calculates the bit error rate (BER) of a decoded signal against the true pattern 010101...
% Handles frame shifts and repeated/dropped bits

frame_shift_period = 20;
truth = [];

pattern1 = repmat([0 1], 1, ceil(frame_shift_period/2))';
pattern2 = repmat([1 0], 1, ceil(frame_shift_period/2))';

% generate truth vector
for i = 1:frame_shift_period:length(binary_signal)

    if i < max(1:frame_shift_period:length(binary_signal))
        truth(i:i+frame_shift_period-1) = find_frame(...
            binary_signal(i:i+frame_shift_period-1),...
            pattern1, pattern2);
    else
        last_frame_length = length(binary_signal) - ...
            max(1:frame_shift_period:length(binary_signal));
        
        truth(i:i+last_frame_length) = find_frame(...
            binary_signal(i:i+last_frame_length),...
            pattern1(1:last_frame_length+1),pattern2(1:last_frame_length+1));

    end

end

% calculate number of errors
%fprintf('%d %d\n',length(binary_signal),length(truth)); % for testing

num_error = binary_signal(binary_signal ~= truth');

ber = length(num_error) / length(binary_signal);

%ber = [binary_signal truth']; % for testing

end



function truth_frame = find_frame(binary_frame, pattern1_frame, pattern2_frame)

matches1 = binary_frame(binary_frame == pattern1_frame);
matches2 = binary_frame(binary_frame == pattern2_frame);

if sum(matches1) > sum(matches2)
    truth_frame = pattern1_frame;
else
    truth_frame = pattern2_frame;


end
end