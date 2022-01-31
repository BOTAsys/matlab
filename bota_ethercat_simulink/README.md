# Simple EtherCAT Master for Bota Devices #

The example SOEM_bota_master Block uses the Simple Open EtherCAT Master (SOEM) library to transfer input and output PDO data and SDO with an EtherCAT Slave device. The model is to be run in Normal or Accelerator mode on Windows. 

### Prerequisites ###
Pcap driver installed:
    * WinPcap for **Windows 7/8/8.1**, see https://www.winpcap.org
    * Npcap for **Windows 10**, see https://nmap.org/npcap/. **Note: during install select winpcap compatible mode.**
    
### Setup & Connection Instructions ###
1. Connect the sensor to a network adapter of your computer (e.g. ethernet port or usb-2-ethernet adapter)
2. Copy and rename pcap dll files from your system, because the pcap dll files included in the Matlab installation do not work and causes a crash. 
    * Copy C:\Windows\System32\Packet.dll as Packet64.dll in the map of this simulink model.
    * Copy C:\Windows\System32\wpcap.dll as wpcap64.dll in the map of this simulink model.
3. Open the Simulink model "run_bota_ethercat.slx".
    * Note that some Pcap drivers require Matlab/Simulink to be run in administrator mode to access ethernet device. This can be by right-click Matlab icon, and select run in administrator mode.
4. Run the model in Normal or Accelerator mode. Rapid Accelerator mode is not supported.
    * The first run is likely to fail, because the **Device ID** parameter must be correctly set.
    * After the first run, open diagnostics viewer and note the Device ID Nr. related to your ethernet device.
    * Update the **Device ID** parameter of the SOEM_bota_master and run again.

### Sensor Configuration ###
The MATLAB interface allows three different modes:
* **Stop:** There is not communication between the master (computer) and sensor (no SDO, no PDO).
* **Config:** The sensor is configured through SDOs. The adjustable paramters can be found in the green box 'Sensor Configuration'. The paramters are explained in the [User Manual](https://botasys.with2.dolicloud.com/document.php?hashp=xT1E8TsY8r39x0NxIrZ1GJla14r4sKCy).
* **Run:** The sensor is streaming data through PDOs. Note that after each power cycle the sensor uses the default configuration paramters if it is not put into Config mode beforehand.

