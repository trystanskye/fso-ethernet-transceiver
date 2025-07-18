function binary_signal = sliding_mean_threshold(signal, buffer_length)
% sliding_mean_threshold - Converts a vector of doubles into a logical vector
% using a sliding mean of min/max threshold approach.
%
% Syntax:
%   binary_signal = sliding_mean_threshold(signal, buffer_length)
%
% Inputs:
%   signal        - Vector of doubles to process
%   buffer_length - Number of samples to use in the sliding window buffer
%
% Output:
%   binary_signal - Logical vector (same length as signal)

    % Ensure signal is a column vector
    signal = signal(:);
    N = length(signal);

    if N < buffer_length
        error('Signal must be at least as long as the buffer length.');
    end

    % Preallocate binary signal
    binary_signal = false(N, 1);

    % Initial threshold from first `buffer_length` samples
    buffer = signal(1:buffer_length);
    threshold = mean([min(buffer), max(buffer)]);
    
    % Threshold the first `buffer_length` points using the initial threshold
    binary_signal(1:buffer_length) = buffer > threshold;
    
    % Loop from buffer_length + 1 to the end
    for i = buffer_length+1:N
        % Update buffer by removing oldest value and adding new one
        buffer = [buffer(2:end); signal(i)];
        
        % Calculate new threshold from buffer
        threshold = mean([min(buffer), max(buffer)]);
        
        % Apply threshold
        binary_signal(i) = signal(i) > threshold;
    end

    % Final static threshold for the last `buffer_length` values
    final_threshold = threshold;
    for i = N-buffer_length+1:N
        binary_signal(i) = signal(i) > final_threshold;
    end

    % Convert to logical vector explicitly
    binary_signal = logical(binary_signal);
end
