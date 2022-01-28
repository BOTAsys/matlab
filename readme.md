## This archive includes the following code snippets. ##

#### rokubimini_matlab_rosbag_read.m ####

This Code is an example for reading a rosbag that includes a
rokubimini_readings topic. It will create a an Array of size
6 by number_of_samples that includes all 6 measurements Fxyz
and Txyz.
And an Array of time of size number_of_samples that includes
the timestamps of the samples starting from time zero.
Finally will plot the measurements against the time.

#### rokubimini_serial_simulink ####

This Simulink model is an example of connecting Simulink to a serial sensor and reading the force/torque data. It outputs the wrench vector(Fx, Fy, Fz, Mx, My, Mz), timestamp, and the sensor's temperature and status, as described in the manual.

#### bota_serial ####

This code is an example on how to configure and read a Bota Systems AG serial sensor from a MATLAB script. The function readSerialFrame.m parses the serial string and outputs the wrench vector(Fx, Fy, Fz, Mx, My, Mz), timestamp, and the sensor's temperature and status, as described in the manual. The function can be used to configure the sensor (SINC filter size & offset). Note that the maximum achievable update frequency through MATLAB might be below 800 Hz.

#### bota_ethercat_simulink ####

This Simulink model is an example of connecting Simulink to an EtherCAT sensor and reading the force/torque data.