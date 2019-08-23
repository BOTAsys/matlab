%% PLOT ROSBAG

%% Copyright
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

%% Sensor Type
% Valid types are "ethercat", "serial", "usb"
sensor_type = "ethercat";

%% Reading the rosbag 
bag = rosbag('ros.bag');

%% Reading the Topic
if sensor_type == "ethercat"
    RMtopic = select(bag,'Topic','/rokubimini_cosmo/forcetorque_readings');
elseif sensor_type == "serial" || sensor_type == "usb"
    RMtopic = select(bag,'Topic','/rokubi_node/force_torque_sensor_measurements');
else
    error("Please select a valid type of sensor. """ + sensor_type + """ is not valid name");
end

%% Create a struct out of the message
RMStruct = readMessages(RMtopic,'DataFormat','struct');

%% Create a an Array of the measurements 
RMF(:,1) = cellfun(@(m) m.Wrench.Wrench.Force.X,RMStruct);
RMF(:,2) = cellfun(@(m) m.Wrench.Wrench.Force.Y,RMStruct);
RMF(:,3) = cellfun(@(m) m.Wrench.Wrench.Force.Z,RMStruct);
RMF(:,4) = cellfun(@(m) m.Wrench.Wrench.Torque.X,RMStruct);
RMF(:,5) = cellfun(@(m) m.Wrench.Wrench.Torque.Y,RMStruct);
RMF(:,6) = cellfun(@(m) m.Wrench.Wrench.Torque.Z,RMStruct);

%% Create Time of the measurements
ts = cellfun(@(m) m.Wrench.Header.Stamp,RMStruct);
sec = [ts.Sec] - bag.StartTime;
time = (cast(sec, 'single') + cast([ts.Nsec], 'single')/10^9);

%% Visualize
figure('name', "Forces/Torques"); hold on; grid on
subplot(2,1,1);
title("Forces (N)");
hold on; grid on;
Fx = plot(time, RMF(:,1), 'r');
Fy = plot(time, RMF(:,2), 'g');
Fz = plot(time, RMF(:,3), 'b');
legend([Fx; Fy; Fz], ["Fx"; "Fy"; "Fz"]);
hold off;

subplot(2,1,2);
title("Torques (Nm)");
hold on; grid on;
Tx = plot(time, RMF(:,4), 'r');
Ty = plot(time, RMF(:,5), 'g');
Tz = plot(time, RMF(:,6), 'b');
legend([Tx; Ty; Tz], ["Tx"; "Ty"; "Tz"]);
hold off;
