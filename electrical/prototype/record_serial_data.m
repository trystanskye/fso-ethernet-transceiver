function record_serial_data(filename, duration_sec)
% record_serial_data - Records serial data from Arduino and saves as .mat
%
% Parameters:
%   filename      - Name of file (no extension) to save data as (string)
%   duration_sec  - Duration to record in seconds (numeric)

% Configuration
port = "/dev/cu.usbmodem14101";
baudRate = 115200;  % Adjust if needed
folder = "/Users/trystankasprick/Documents/FSO/fso-ethernet-transceiver/electrical/signal-data";

% Setup serial port
s = serialport(port, baudRate);
configureTerminator(s, "LF");
flush(s);  % Clear any previous data

fprintf("Recording for %.2f seconds...\n", duration_sec);

% Initialize timing
t0 = datetime('now');
data = [];
timestamps = [];

% Timer loop
while seconds(datetime('now') - t0) < duration_sec
    if s.NumBytesAvailable > 0
        line = readline(s);
        value = str2double(line);

        if ~isnan(value)
            data(end+1) = value; %#ok<AGROW>
            timestamps(end+1) = seconds(datetime('now') - t0); %#ok<AGROW>
        end
    end
end

% Save to .mat file
%t = (0:0.1:(length(data)-1)*0.1)';
data = uint8(data)';
%ts = timeseries(data', t);
save(fullfile(folder, filename), 'data');
fprintf("Saved %d data points to %s.mat\n", length(data), filename);

% Cleanup
clear s;
end
