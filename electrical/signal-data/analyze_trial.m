function results = analyze_trial(trial_struct)
% ANALYZE_TRIAL decodes and labels data from one trial, and appends to labeled.mat

fields = {'on', 'off', 'uniform', 'nonuniform'};
results = struct();

fprintf('--- Trial Analysis ---\n');

for i = 1:length(fields)
    field = fields{i};
    raw_data = trial_struct.(field);

    % --- Threshold decoding ---
    % .   simple threshold
    %threshold = mean([max(raw_data), min(raw_data)]);  % robust threshold
    %threshold = 30;
    %binary = raw_data > threshold; 

    % .    sliding mean threshold
    binary = sliding_mean_threshold(raw_data,20);


    % --- Show preview ---
    binary_str = sprintf('%d', binary(1+20:min(32+20, end)));
    fprintf('%-12s decoded: %s\n', field, binary_str);

    % --- BER & ground truth selection ---
    switch field
        case 'on'
            expected = ones(1, length(binary));
            ber = sum(binary ~= expected) / length(binary);

        case 'off'
            expected = zeros(1, length(binary));
            ber = sum(binary ~= expected) / length(binary);

        case 'uniform'
            alt1 = repmat([0 1], 1, ceil(length(binary)/2));
            alt2 = repmat([1 0], 1, ceil(length(binary)/2));
            alt1 = alt1(1:length(binary));
            alt2 = alt2(1:length(binary));
            ber1 = sum(binary ~= alt1) / length(binary);
            ber2 = sum(binary ~= alt2) / length(binary);
            ber = min(ber1, ber2);
            best_pattern = alt1;
            if ber2 < ber1
                best_pattern = alt2;
            end

        case 'nonuniform'
            base = [1 0 0 1 1 0 1 0 0 1 0 0 1 1 1 0];
            pattern_length = length(base);
            min_ber = Inf;
            best_shift = NaN;
            best_pattern = [];

            for shift = 0:pattern_length-1
                ref = circshift(base, [0, shift]);
                repeated = repmat(ref, 1, ceil(length(binary)/pattern_length));
                ref_cut = repeated(1:length(binary));
                ber_shift = sum(binary ~= ref_cut) / length(binary);

                if ber_shift < min_ber
                    min_ber = ber_shift;
                    best_pattern = ref_cut;
                    best_shift = shift;
                end
            end
            ber = min_ber;
    end

    %fprintf('%-12s BER: %.4f\n', '', ber);


    % --- Store signal and ground truth ---
    labeled_entry.(field).signal = raw_data(:);           % force column vector
    switch field
        case {'on', 'off'}
            labeled_entry.(field).truth = expected(:);    % binary truth
            truth_str = sprintf('%d', expected(1+20:min(32+20, end)));
            fprintf('%-12s truth:   %s\n', '', truth_str);
        otherwise
            labeled_entry.(field).truth = best_pattern(:);  % best aligned pattern
            truth_str = sprintf('%d', best_pattern(1+20:min(32+20, end)));
            fprintf('%-12s truth:   %s\n', '', truth_str);
    end

    fprintf('\n')

    % Also keep for return output if needed
    results.(field).signal = labeled_entry.(field).signal;
    results.(field).truth  = labeled_entry.(field).truth;
end

% Ensure consistent initialization of labeled_data
if ~exist('labeled_data', 'var') || isempty(labeled_data)
    % Use labeled_entry as the structural template
    labeled_data = repmat(labeled_entry, 0, 1);  % empty, but structurally correct
end

end

