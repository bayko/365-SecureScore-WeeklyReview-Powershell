# 365-SecureScore-WeeklyReview-Powershell
Script to automate weekly review required for 365 SecureScore telemetry points.

Review signs-ins after multiple failures report weekly - 45 Points
Review role changes weekly - 10 Points
Review malware detections report weekly - 5 Points
Review account provisioning activity report weekly - 5 Points
Review non-global administrators weekly - 5 Points
Review blocked devices report weekly - 5 Points

Script only requires an Office 365 Global admin username/password as parameters when running.

```````````````````````````````````````````````````````````````````````````````````````
>: .\SecureScore-WeeklyReviewPoints.ps1 admin@contoso.onmicrosoft.com Password123
