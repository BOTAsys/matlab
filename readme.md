## This archive includes the following code snippets. ##

#### rokubimini_matlab_rosbag_read.m ####

This Code is an example for reading a rosbag that includes a 
rokubimini_readings topic. It will create a an Array of size
6 by number_of_samples that includes all 6 measurements Fxyz 
and Txyz. 
And an Array of time of size number_of_samples that includes 
the timestamps of the samples starting from time zero.
Finally will plot the measurements against the time.