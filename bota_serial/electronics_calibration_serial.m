%% Clear all variables

close all;
clear all;
clc

%% Set up the serial port object
SerialPort='COM4'; %serial port
BaudRate=460800; %460800;
timeout=10;

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

% offset
flush(s,'input')
bytes = unicode2native(['b,',num2str(-offset_fx),',',num2str(-offset_fy),',',num2str(-offset_fz),',',num2str(-offset_mx),',',num2str(-offset_my),',',num2str(-offset_mz)]);
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

%% Run sensor

flush(s,'input')
bytes = unicode2native('R');
write(s,bytes,"uint8");
while (s.NumBytesAvailable==0)
    pause(0.1);
end
pause(1.0)
% Clean up the serial port
clear s;