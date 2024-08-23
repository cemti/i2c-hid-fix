# Disabling power saving for I2C HIDs

Tested on Asus ExpertBook B2502FBA.

## Introduction

An I2C HID (Inter-Integrated Circuit Human Interface Device) is a hardware I2C component that accepts human input (e.g. touchscreens and touchpads).

Due to Windows implicitly activating power-saving features on said devices, some problems might occur with these devices:
* Being unresponsive after the computer wakes up from Sleep/Hibernate.
* Increased delay.
* Single taps being falsely registered as double on touchscreens (see below).
  * Possible suboptimal touchscreen sensitivity.
  
  ![before](https://github.com/user-attachments/assets/bfa222a1-d640-4f8d-915e-24e5a34576de)

## Troubleshooting

1. Using the `Device Manager`, find the device responsible for controlling I2C HIDs (controller), and get its vendor and device IDs.

   - If there are multiple, choose one randomly (trial and error).
   
     - On my computer, the choice does not matter.

   - In my case, the device is `Intel(R) Serial IO I2C Host Controller - 51E9`, and the IDs are `8086` and `51E9`.

     ![image](https://github.com/user-attachments/assets/0fadaf2f-a73b-4bd6-a31d-8b6443290cec)

3. Run the `I2C_Fix.ps1` Powershell script, **as administrator**, with the supplied `VendorId` and `DeviceId` arguments, like this:

   `.\I2C_Fix.ps1 -VendorId 8086 -DeviceId 51e9`

   * The problem has been remedied (until system reboot):
   * On my laptop, the touchscreen is now working fine.
  
     ![after](https://github.com/user-attachments/assets/8c9f817a-f702-4227-a346-78ff0b819af1)

5. As an optional step, the script can be run automatically at system startup using the special `Startup` folder or the `Task Scheduler` component.

## About the PowerShell script

The script requires two arguments: `$VendorId` and `$DeviceId`.

><pre>$pattern = "PCI\\VEN_${VendorId}&DEV_${DeviceId}%"</pre>
>
> The WQL pattern used to find the I2C controller device.

><pre>$query = "SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE '${pattern}'"</pre>
>
> The WQL query used to find the I2C controller device.

><pre>Set-CimInstance -Namespace root\wmi -Query $query -Property @{Enable = $false}</pre>
>
> Gets the respective device, and disables its power-saving features.
>
> **This action requires administrative privileges.**

## Sources:
* https://www.reddit.com/r/PowerShell/comments/lr5iyk/uncheck_allow_the_computer_to_turn_off_this/
* https://superuser.com/questions/1707794/permanently-disable-power-management-for-trackpad-using-powershell-or-wmic
* https://www.dell.com/community/en/conversations/xps/xps-15-7590-touchpad-does-not-respond-sometimes/647f8a92f4ccf8a8dea78585?page=5
* https://www.reddit.com/r/DellXPS/comments/phahus/one_month_update_on_xps_9510/
