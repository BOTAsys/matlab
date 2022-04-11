%% Clear all variables

close all;
clear all;
clc

runOffsetCalibration=false;

%% Set up the serial port object
SerialPort='COM1'; %/dev/ttyUSB0; % serial port
BaudRate=460800; %460800;
timeout=10;
runtime=5;

disp(['Configure sensor on port ', SerialPort, '. This may take a while.'])

s = serialport(SerialPort,BaudRate,"Timeout",timeout);

%% Parameters
sincLength=64;
chopEnable=0;
fastEnable=0;
firDisable=1;
offset_fx=0.0;
offset_fy=0.0;
offset_fz=0.0;
offset_mx=0.0;
offset_my=0.0;
offset_mz=0.0;


%% Config sensor
pause(5.0);
flush(s,'input')
nWritten=s.NumBytesWritten;
bytes = unicode2native('C');
while (s.NumBytesWritten==nWritten)
    write(s,bytes,"uint8");
end
pause(1.0)

% filter parameters
flush(s,'input')
bytes = unicode2native(['f,',num2str(sincLength),',',num2str(chopEnable),',',num2str(fastEnable),',',num2str(firDisable)]);
write(s,bytes,"uint8");
while (s.NumBytesAvailable==0)
    pause(0.1);
end

% save configuration
flush(s,'input')
bytes = unicode2native('s');
write(s,bytes,"uint8");
while (s.NumBytesAvailable==0)
    disp('Save Configuration');
    pause(0.1);
end

% save configuration
disp('Disable calibration matrix');
flush(s,'input')
bytes = unicode2native(['c,',num2str(0),',',num2str(0),',',num2str(0),',',num2str(4)]);
write(s,bytes,"uint8");
while (s.NumBytesAvailable==0)
    pause(0.1);
end

%% Run sensor and observe strain gauge readings

flush(s,'input')
bytes = unicode2native('R');
write(s,bytes,"uint8");
while (s.NumBytesAvailable==0)
    pause(0.1);
end
pause(1.0)

% Run the sensor in a loop
tStart=now;
count=0;
flush(s)
tNow=now;
G_max=zeros(6,1);
while tNow<tStart+runtime*1e-5
    [Status, Gauges, Timestamp, Temperature] = readSerialFrame(s);
    
    if (Status>=0)
        tNow=now;
        
        for i = 1:6
            if (G_max(i,1) < abs(Gauges(i)))
                G_max(i,1) = abs(Gauges(i));
            end
        end
    end
end
G_max
for i = 1:6
    if (G_max(i,1) > 20000)
        disp(['Gauge ',num2str(i),' is saturated!']);
    end
end

flush(s,'input')
nWritten=s.NumBytesWritten;
bytes = unicode2native('C');
while (s.NumBytesWritten==nWritten)
    write(s,bytes,"uint8");
end
pause(1.0)

% print parameters configuration
flush(s,'input')
bytes = unicode2native('q');
write(s,bytes,"uint8");
while (s.NumBytesAvailable==0)
    disp('print parameters');
    pause(0.1);
end
output_register_offset_gain = [readline(s); readline(s); readline(s); readline(s); readline(s); readline(s); readline(s)];
output_dac = [readline(s); readline(s); readline(s); readline(s); readline(s); readline(s); readline(s)];
output_adc_mode = [readline(s); readline(s); readline(s); readline(s)];
disp(output_register_offset_gain)
disp(output_dac)
disp(output_adc_mode)

% save configuration
disp('Enable calibration matrix');
flush(s,'input')
bytes = unicode2native(['c,',num2str(0),',',num2str(1),',',num2str(0),',',num2str(4)]);
write(s,bytes,"uint8");
while (s.NumBytesAvailable==0)
    pause(0.1);
end

%% Offset calibration
if runOffsetCalibration
    flush(s,'input')
    bytes = unicode2native('A');
    write(s,bytes,"uint8");
    while (s.NumBytesAvailable==0)
%         disp('DAC calibration');
        pause(0.1);
    end

    flush(s,'input')
    bytes = unicode2native('o');
    write(s,bytes,"uint8");
    while (s.NumBytesAvailable==0)
%         disp('ADC offset calibration');
        pause(0.1);
    end

    flush(s,'input')
    bytes = unicode2native('g');
    write(s,bytes,"uint8");
    while (s.NumBytesAvailable==0)
%         disp('ADC gain calibration');
        pause(0.1);
    end

    flush(s,'input')
    bytes = unicode2native('o');
    write(s,bytes,"uint8");
    while (s.NumBytesAvailable==0)
%         disp('ADC offset calibration');
        pause(0.1);
    end

    % save configuration
    flush(s,'input')
    bytes = unicode2native('s');
    write(s,bytes,"uint8");
    while (s.NumBytesAvailable==0)
        disp('Save Configuration');
        pause(0.1);
    end

    flush(s,'input')
    bytes = unicode2native('#');
    write(s,bytes,"uint8");
    while (s.NumBytesAvailable==0)
        disp('Reboot');
        pause(0.1);
    end

    pause(5.0)
end
%% Restore filter parameters
sincLength=512;
flush(s,'input')
nWritten=s.NumBytesWritten;
bytes = unicode2native('C');
while (s.NumBytesWritten==nWritten)
    write(s,bytes,"uint8");
end
pause(1.0)

% filter parameters
flush(s,'input')
bytes = unicode2native(['f,',num2str(sincLength),',',num2str(chopEnable),',',num2str(fastEnable),',',num2str(firDisable)]);
write(s,bytes,"uint8");
while (s.NumBytesAvailable==0)
    pause(0.1);
end

% save configuration
flush(s,'input')
bytes = unicode2native('s');
write(s,bytes,"uint8");
while (s.NumBytesAvailable==0)
    disp('Save Configuration');
    pause(0.1);
end

%% Clean up the serial port
clear s;