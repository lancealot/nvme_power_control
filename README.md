# nvme_power_control
Control NVME power states for fun and profit

Example output from the interface:
```
Current power states:
Device               BUS:DEV.FNC               Serial                         Power state    
-----------------------------------------------------------------------------------------                                                                         
/dev/nvme9           01:00.0                   32241049XXXX                   0              
/dev/nvme8           c3:00.0                   32241049XXXX                   0              
/dev/nvme7           c4:00.0                   31241045XXXX                   0              
/dev/nvme6           05:00.0                   MSA2509XXXX                    0              
/dev/nvme5           06:00.0                   MSA2509XXXX                    0              
/dev/nvme4           04:00.0                   31241045XXXX                   0              
/dev/nvme3           03:00.0                   32241049XXXX                   0              
/dev/nvme2           02:00.0                   32241049XXXX                   0              
/dev/nvme1           c2:00.0                   32241049XXXX                   0              
/dev/nvme0           c1:00.0                   32241049XXXX                   0              
Enter the device number (e.g., 0 for nvme0) or 'q' to quit: 9
Enter the new power state: 6
Power state for /dev/nvme9 set successfully to 6.
Current power states:
Device               BUS:DEV.FNC               Serial                         Power state    
-----------------------------------------------------------------------------------------                                                                         
/dev/nvme9           01:00.0                   32241049XXXX                   6              
/dev/nvme8           c3:00.0                   32241049XXXX                   0              
/dev/nvme7           c4:00.0                   31241045XXXX                   0              
/dev/nvme6           05:00.0                   MSA2509XXXX                    0              
/dev/nvme5           06:00.0                   MSA2509XXXX                    0              
/dev/nvme4           04:00.0                   31241045XXXX                   0              
/dev/nvme3           03:00.0                   32241049XXXX                   0              
/dev/nvme2           02:00.0                   32241049XXXX                   0              
/dev/nvme1           c2:00.0                   32241049XXXX                   0              
/dev/nvme0           c1:00.0                   32241049XXXX                   0              
Enter the device number (e.g., 0 for nvme0) or 'q' to quit: q
```
