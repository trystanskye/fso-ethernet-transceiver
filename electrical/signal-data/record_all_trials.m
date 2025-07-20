function record_all_trials(duration_sec)
    % Path to your data folder and .mat file
    folder = "/Users/trystankasprick/Documents/FSO/fso-ethernet-transceiver/electrical/signal-data";
    datafile = fullfile(folder, 'trial_data.mat');

    % Load existing data if it exists
    if isfile(datafile)
        S = load(datafile);
        if isfield(S, "trial_data")
            trial_data = S.trial_data;
        else
            trial_data = struct([]);
        end
    else
        trial_data = struct([]);
    end

    % Determine next trial number
    trial_num = length(trial_data) + 1;
    trial_labels = {'on', 'off', 'uniform', 'nonuniform'};

    % Initialize empty entry
    trial_entry = struct();

    % Record each trial type
    for i = 1:length(trial_labels)
        label = trial_labels{i};
        fprintf('\nReady to record "%s" trial #%d. Press any key to start...\n', label, trial_num);
        pause;

        % Record data
        data = record_serial_data(duration_sec);

        % Store in temporary struct
        trial_entry.(label) = data;

        fprintf('Finished recording "%s" trial.\n', label);
    end

    % Append the new trial entry to the full dataset
    trial_data(end+1) = trial_entry;

    % Save all trials
    save(datafile, 'trial_data');
    fprintf('\nAll 4 trials for trial #%d saved to trial_data.mat.\n', trial_num);

    load("trial_data.mat");
end



function data = record_serial_data(duration_sec)
    % Configuration
    port = "/dev/cu.usbmodem14101";
    baudRate = 115200;
    s = serialport(port, baudRate);
    configureTerminator(s, "LF");
    flush(s);

    fprintf("Recording for %.2f seconds...\n", duration_sec);

    % Initialize
    t0 = datetime('now');
    data = [];

    % Read loop
    while seconds(datetime('now') - t0) < duration_sec
        if s.NumBytesAvailable > 0
            line = readline(s);
            value = str2double(line);

            if ~isnan(value)
                data(end+1) = value; %#ok<AGROW>
            end
        end
    end

    clear s;
    fprintf("Recorded %d data points.\n", length(data));
end

