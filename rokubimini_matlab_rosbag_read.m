
% Copyright (C) 2019 by Ilias Patsiaouras
% 
% Permission is hereby granted, free of charge, to any person obtaining a 
% copy of this software and associated documentation files, to deal in the
% Software without restriction, including without limitation the rights to 
% use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
% copies of the Software, and to permit persons to whom the Software is 
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included 
% in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
% IN THE SOFTWARE.

bag = rosbag('Rosbags/slow.bag');

% For etherCAT sensor bag files use the follow line 
RMtopic = select(bag,'Topic','/rokubimini_cosmo/forcetorque_readings');

% For Serial/USB sensor bag files use the follow line 
% RMtopic = select(bag,'Topic','/rokubi_node/force_torque_sensor_measurements');

RMStruct = readMessages(RMtopic,'DataFormat','struct');

% Create a an Array of all 6 measurements history
RMF(:,1) = cellfun(@(m) m.Wrench.Wrench.Force.X,RMStruct);
RMF(:,2) = cellfun(@(m) m.Wrench.Wrench.Force.Y,RMStruct);
RMF(:,3) = cellfun(@(m) m.Wrench.Wrench.Force.Z,RMStruct);
RMF(:,4) = cellfun(@(m) m.Wrench.Wrench.Torque.X,RMStruct);
RMF(:,5) = cellfun(@(m) m.Wrench.Wrench.Torque.Y,RMStruct);
RMF(:,6) = cellfun(@(m) m.Wrench.Wrench.Torque.Z,RMStruct);
ts = cellfun(@(m) m.Wrench.Header.Stamp,RMStruct);

sec = [ts.Sec] - bag.StartTime;
time = (cast(sec, 'single') + cast([ts.Nsec], 'single')/10^9);

plot(time, RMF)