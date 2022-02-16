# Simple EtherCAT Master for Bota Devices #

The example SOEM_bota_master Block uses the Simple Open EtherCAT Master (SOEM) library to transfer input and output PDO data and SDO with an EtherCAT Slave device. The model is to be run in Normal or Accelerator mode on Windows or Linux.

### Prerequisites ###
Pcap driver installed (Windows only):
* WinPcap for **Windows 7/8/8.1**, see https://www.winpcap.org
* Npcap for **Windows 10**, see https://nmap.org/npcap/. **Note: during install select winpcap compatible mode.**

### Setup & Connection Instructions ###
1. Connect the sensor to a network adapter of your computer (e.g. ethernet port or usb-2-ethernet adapter)
2. (Windows only) Copy and rename pcap dll files from your system, because the pcap dll files included in the Matlab installation do not work and causes a crash.
    * Copy C:\Windows\System32\Packet.dll as Packet64.dll in the map of this simulink model.
    * Copy C:\Windows\System32\wpcap.dll as wpcap64.dll in the map of this simulink model.
3. Open the Simulink model "run_bota_ethercat.slx".
    * Note that some Pcap drivers require Matlab/Simulink to be run in administrator mode to access ethernet device. This can be by right-click Matlab icon, and select run in administrator mode.
    * Note that Linux requires to run Matlab as root to have socket access.
4. Run the model in Normal or Accelerator mode. Rapid Accelerator mode is not supported.
    * The first run is likely to fail, because the **Device ID** parameter must be correctly set.
    * After the first run, open diagnostics viewer and note the Device ID Nr. related to your ethernet device.
    * Update the **Device ID** parameter of the SOEM_bota_master and run again.

### Sensor Configuration ###
The MATLAB interface allows three different modes:
* **Stop:** There is not communication between the master (computer) and sensor (no SDO, no PDO).
* **Config:** The sensor is configured through SDOs. The adjustable paramters can be found in the green box 'Sensor Configuration'. The paramters are explained in more detail in the [User Manual](https://botasys.with2.dolicloud.com/document.php?hashp=xT1E8TsY8r39x0NxIrZ1GJla14r4sKCy).
    * **SINC_length:** (cut-off Freq high/low@sampling Freq) 51 = 1674/252Hz@1000Hz, 64 = 1255/189Hz@800Hz, 128 = 628/94.5hz@400Hz, 205 = 393/59.5Hz@250Hz 256 = 314/47.5Hz@200Hz, 512 = 157/23.5@100Hz
    * **enable_CHOP:** should be always false.
    * **disable_FIR:** false = low cut-off frequency, true = high cut-off frequency from the above result e.g. for sinc filter_size: 51 and fir_disable: 1 you get cut-off freq 1674Hz@1000Hz sample rate.
    * **enable_FAST:** (only applies if disable_FIR is false) True = will result in low cut-off frequency but would be still able to catch step impulses of high cut-off frequency
    * **offset:** Fx, Fy, Fz, Mx, My, Mz offset
    * **IMU_config:**
        * Acceleration filter: (cut-off Freq) 1 = 460Hz, 2 = 184Hz, 3 = 92Hz, 4 = 41Hz, 5 = 21Hz, 6 = 10Hz, 7 = 5Hz
        * Angular Rate Filter: (cut-off Freq) 3 = 184Hz, 4 = 92Hz, 5 = 41Hz, 6 = 21Hz, 7 = 10Hz, 8 = 5Hz
        * Acceleration range: 0 = ±2g, 1 = ±4g, 2 = ±8g, 3 = ±16g
        * Angular rate range: 0 = ±250°/s, 1 = ±500°/s, 2 = ±1000°/s, 3 = ±2000°/s
* **Run:** The sensor is streaming data through PDOs. Note that after each power cycle the sensor uses the default configuration paramters if it is not put into Config mode beforehand.
