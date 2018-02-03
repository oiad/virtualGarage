# HiveExt.ini updates
1. Under the [objects] category there are 2 new options for virtual garage which are optional to add to your HiveExt.ini and modify
* Copy the text in the code box below to your HiveExt.ini [Objects] category if it's not there already (reference the HiveExt.ini in this folder for the proper placement)

```
; Table name for the virtual garage data to be stored in, default table is 'garage'
;VGTable = garage
; Days for a stored vehicle to be cleaned up after, if set to -1 this feature is disabled. Default 35 days
;CleanupVehStoredDays = 35
; Log object cleanup DELETE statements (per object), including virtual garage. Default is false
;LogObjectCleanup = false
```
2. Uncomment and modify as desired
