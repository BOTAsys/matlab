# Simple EtherCAT Master for Bota Devices

The example SOEM_bota_master Block shows basic usage of the Simple Open EtherCAT Master (SOEM) library by transferring input and output PDO data with an EtherCAT Slave device. The example model is to be run in Normal or Accelerator mode on Windows. 

Prerequisites:
(- Supported version of Microsoft Visual Studio + Windows SDK installed)
- Pcap driver installed
    - WinPcap for Windows 7/8/8.1, see https://www.winpcap.org
    - Npcap for Windows 10, see https://nmap.org/npcap/. **During install select winpcap compatible mode.**
    
Build/usage instructions:
1. Copy and rename pcap dll files, because the pcap dll files included in the Matlab installation do not work and causes a crash. 
    - Copy C:\Windows\System32\Packet.dll as Packet64.dll in the map of this simulink model.
    - Copy C:\Windows\System32\wpcap.dll as wpcap64.dll in the map of this simulink model.
2. Open Simulink model "run_bota_ethercat.slx".
    - Note that some Pcap drivers require Matlab/Simulink to be run in administrator mode to access ethernet device. This can be by right-click Matlab icon, and select run in administrator mode.
3. Run the models in Normal or Accelerator mode. External mode is not supported.
    - First run is likely to fail, because DeviceID parameter must be correctly set.
    - After first run, open diagnostics viewer and note the DeviceID Nr. related to your Ethernet device.
    - Update DeviceID in the parameters of the SOEM_bota_master and run again.
