function binary_signal = decoder(raw_data, bit_period, frame_shift_period)
% takes a vector of raw signal data, the number of samples per bit, and the
% variable. outputs the decoded binary signal. coded to emulate a stream of
% signal. first register_length of bits are not decoded

% Initialize bit data
binary_signal = [];

register_length = bit_period*20;

% ---Adaptive thresholding via a sliding register---
% initialize variables
register_counter = register_length - 1; 
next_bit_countdown = register_length; %used to count down to the start of a frame
register = zeros(register_length,1);



% for loop through raw data to simulate data stream
for i = 1:length(raw_data)
    
    
    % Either fill register at start or (re)calculate frame shift
    if i < register_length
        register(i) = raw_data(i);

        register_counter = register_counter - 1; 
        continue

    elseif register_counter == 0
        % finish filling registers
        if i == register_length
            % first full register
            register(i) = raw_data(i);
        else
            % subsequent full registers
            register = [register(2:end); raw_data(i)];
        end
        
        % calculate frame offset for register
        frame_offset = find_bit_frame(register, bit_period);
        
        % reset countdowns according to calculated frame
        next_bit_countdown = frame_offset;
        register_counter = frame_shift_period + frame_offset;
    else
        register = [register(2:end); raw_data(i)];

    end
    
    % Record new decoded bit at start of every frame
    if next_bit_countdown == 0
        % calculate and update bit_signal
        binary_signal = update_binary_signal(register,bit_period,binary_signal);
        % set next bit calculation to a full frame
        next_bit_countdown = bit_period;
    end

    % timer countdowns
    next_bit_countdown = next_bit_countdown - 1;
    register_counter = register_counter - 1; 
    
end

binary_signal = binary_signal';

end




function frame_offset = find_bit_frame(register, bit_period)
% frame_offset is the frame offset from [0,bit_period-1], where 0 means bit
% one in the register is aligned with bit one in the frame

% initialize variables
num_bit_periods = floor(length(register)/bit_period)-1;
mean_variation = [];

% loop through offset numbers ie. 0 offset ... bit_period-1 offset
for i = 1:(bit_period)

    % initialize empty variable to hold standard deviation values
    bit_frame_std = [];

    % loop through each repeating n-bit frame through the register
    for j = 1:num_bit_periods
        
        % fill vector of standard deviations for each n-bit frame 
        
        bit_frame_std(j) = std(double(register(((j-1)*bit_period+i):((((j-1)*bit_period+i)+4)))));
        
    end
    
    %take the mean of all n-bit frames for each offset
    mean_variation(i) = mean(bit_frame_std);

end

% determine offset with lowest mean standard deviation
frame_offset = find(mean_variation==min(mean_variation))-1;

end


function send_bit(bit)
% placeholder for HDL code for FPGA send to ethernet PHY

fprintf("%d\n",bit);

end


function updated_binary_signal = update_binary_signal(register,bit_period,binary_signal)
% triggers at the start of every frame to calculate and record the decoded 
% bit. 

% find threshold of whole register
sorted_vals = sort(register);
register_threshold = mean(mean([sorted_vals(1:2), sorted_vals(end-1:end)]));

% find threshold of current frame
frame_threshold = mean(register(1:bit_period));

% compare thresholds to determine new bit
new_bit = 0;
if frame_threshold > register_threshold
    new_bit = 1;
end

% add to binary signal data
updated_binary_signal = [binary_signal new_bit];

%fprintf('%d\n',new_bit)


end