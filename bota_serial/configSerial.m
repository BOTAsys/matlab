function configSerial(s,lSinc,offset)
%CONFIGSERIAL configure a Bota Systems AG sensor through the serial
%interface
%   s: serial port
%   lSinc: Sinc Filter size
%       256 corresponds to ~200 Hz output rate
%       512 corresponds to ~100 Hz output rate
%       1024 corresponds to ~50 Hz output rate
%   offset: offset of the sensor

%% Config sensor
% timeout=10;
% s = serialport(serialPort,baudRate,"Timeout",timeout,'FlowControl','hardware');
chopEnable=0;
fastEnable=0;
firDisable=1;

offset_fx=offset(1);
offset_fy=offset(2);
offset_fz=offset(3);
offset_mx=offset(4);
offset_my=offset(5);
offset_mz=offset(6);

% Put the sensor into config mode
flush(s,'input')
nWritten=s.NumBytesWritten;
bytes = unicode2native('C');
while (s.NumBytesWritten==nWritten)
    write(s,bytes,"uint8");
end
pause(1.0)

% filter parameters
flush(s,'input')
bytes = unicode2native(['f,',num2str(lSinc),',',num2str(chopEnable),',',num2str(fastEnable),',',num2str(firDisable)]);
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

% Put the sensor into run mode
flush(s,'input')
bytes = unicode2native('R');
write(s,bytes,"uint8");
while (s.NumBytesAvailable==0)
    pause(0.1);
end

end