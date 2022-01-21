%% Clear all variables

close all;
clear all;
clc

%% Set up the serial port object
SerialPort='/dev/ttyUSB0'; %serial port
BaudRate=460800; %460800;
timeout=2;

disp(['Configure sensor on port ', SerialPort, '. This may take a while.'])

s = serialport(SerialPort,BaudRate,"Timeout",timeout,'FlowControl','hardware');

%% Config sensor
offset_fx=0.0;
offset_fy=0.0;
offset_fz=0.0;
offset_mx=0.0;
offset_my=0.0;
offset_mz=0.0;

flush(s)
bytes = unicode2native('C');
write(s,bytes,"uint8");

flush(s)
bytes = unicode2native(['b,',num2str(-offset_fx),',',num2str(-offset_fy),',',num2str(-offset_fz),',',num2str(-offset_mx),',',num2str(-offset_my),',',num2str(-offset_mz)]);
write(s,bytes,"uint8");
pause(0.1)

flush(s)
bytes = unicode2native('f,512,0,0,1');
write(s,bytes,"uint8");
pause(0.2)

%% Init sensor
flush(s)
bytes = unicode2native('R');
write(s,bytes,"uint8");

pause(0.1)

flush(s)
%% Clean up the serial port
clear s;