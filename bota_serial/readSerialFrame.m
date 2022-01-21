function [Status, Wrench, Timestamp, Temperature] = readSerialFrame(s)
%READSERIALFRAME convert serial frame to readings
%   This function only consumes one frame and converts it into readings.
%   It returns Status=-1 if no frame is available

Wrench=zeros(6,1);
Status=-1;
Timestamp=0;
Temperature=0;

% Check if frame is available
if (s.NumBytesAvailable<37)
    return;
end
% Start reading with header
header = read(s,1,"uint8");
while(header(1)~=170)
   header = read(s,1,"uint8");
end

% Read data
data = read(s,36,"uint8");

Status = de2bi(data(1),8);

Wrench(1) = (typecast(uint8(data(3:6)),'single'));
Wrench(2) = (typecast(uint8(data(7:10)),'single'));
Wrench(3) = (typecast(uint8(data(11:14)),'single'));
Wrench(4) = (typecast(uint8(data(15:18)),'single'));
Wrench(5) = (typecast(uint8(data(19:22)),'single'));
Wrench(6) = (typecast(uint8(data(23:26)),'single'));

Timestamp = (typecast(uint8(data(27:30)),'uint32'));
Temperature = (typecast(uint8(data(31:34)),'single'));

end

