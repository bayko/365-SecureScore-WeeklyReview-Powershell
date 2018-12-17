#Requires -RunAsAdministrator 
$Username = $args[0]
$Password = $args[1]
if ((!$Username) -or (!$Password)){
    Write-Host 'You must supply global admin credentials as parameters when executing this script ( ie: C:\> .\STS-Office365-Provisioning.ps1 office365admin@company.com Password99 )' -foregroundcolor Red
    Exit
}
$LoginUrl = "https://login.microsoftonline.com/login.srf"
$LogoutUrl = "https://login.microsoftonline.com/logout.srf"

# 365 Review URLS
$ReviewRoleChangesWeekly = "https://portal.office.com/AdminPortal/Home#/users"
$ReviewSignInMultipleFailure = "https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/RiskySignIns"
$ReviewAccountProvisioning = "https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Audit"
$ReviewBlockedDevices = "https://portal.office.com/EAdmin/Device/IntuneInventory.aspx"
$ReviewMalwareDetections = "https://protection.office.com/#/quarantine"


# Launch IE process
$IE = New-Object -com internetexplorer.application; 
$IE.visible = $true;  ## Set False to Hide Window
$IE.navigate($LoginUrl); 
while($IE.busy) {Start-Sleep 1}


# Select other user option if saved credentials exist
try { 
  $OtherUser = $IE.parent.document.IHTMLDocument3_getElementByID("otherTile")
  if ($OtherUser) {
    Write-Host ("Selecting Other User") -ForegroundColor Green
    $Otheruser.click()
  } else {
    }
}
catch {
  $ErrorMessage = $_.Exception.Message
  Write-Host "$ErrorMessage" -ForegroundColor Red
}

# Enter Username and click next
try {
  Write-Host("Entering Username") -ForegroundColor Green
  $AdminUsername = $IE.parent.document.IHTMLDocument3_getElementsByName("loginfmt").item(0).innerText = $Username 
  $NextButton = $IE.parent.document.IHTMLDocument3_getElementsByName("idSIButton9").item(0).click()
  while($IE.busy) {Start-Sleep 1}
}
catch {
  $ErrorMessage = $_.Exception.Message
  Write-Host "$ErrorMessage" -ForegroundColor Red
}

# Enter Password and click next
try {
  Write-Host("Entering Password") -ForegroundColor Green
  $AdminUsername = $IE.parent.document.IHTMLDocument3_getElementsByName("passwd").item(0).innerText = $Password 
  Start-Sleep -m 2000
  $NextButton = $IE.parent.document.IHTMLDocument3_getElementsByName("idSIButton9").item().click()
}
catch {
  $ErrorMessage = $_.Exception.Message
  Write-Host "$ErrorMessage" -ForegroundColor Red
}

# Select Do Not Stay Signed-in
try {
  Start-Sleep -m 1000
  $NextButton = $IE.parent.document.IHTMLDocument3_getElementsByName("idBtn_Back")
  if ($NextButton) {  
    Write-Host("Selecting not to stay signed-in") -ForegroundColor Green
    $NextButton.item().click()
  } else {
  }
}
catch {
  $ErrorMessage = $_.Exception.Message
  Write-Host "$ErrorMessage" -ForegroundColor Red
}


# Open Reports URLS
Start-Sleep -m 8000
Write-Host("Reviewing: role changes & non-global admins weekly") -ForegroundColor Green
$IE.navigate($ReviewRoleChangesWeekly);

Start-Sleep -s 15
Write-Host("Reviewing: sign-in after multiple failures weekly") -ForegroundColor Green
$IE.navigate($ReviewSignInMultipleFailure);

Start-Sleep -s 15
Write-Host("Reviewing: account provisioning weekly") -ForegroundColor Green
$IE.navigate($ReviewAccountProvisioning);

Start-Sleep -s 15
Write-Host("Reviewing: blocked devices weekly") -ForegroundColor Green
$IE.navigate($ReviewBlockedDevices);

Start-Sleep -s 15
Write-Host("Reviewing: malware detected weekly") -ForegroundColor Green
$IE.navigate($ReviewMalwareDetections);
Start-Sleep -s 5
$IE.navigate($ReviewMalwareDetections);

# Logout of 365 and close IE
Start-Sleep -s 15
Write-Host("Logging out of 365") -ForegroundColor Green
$IE.navigate($LogoutUrl);
Start-Sleep -s 10
$IE.quit()
