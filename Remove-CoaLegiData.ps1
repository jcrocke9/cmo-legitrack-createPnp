Import-Module SharePointPnPPowerShellOnline -NoClobber

Get-PnPListItem -List Bills | ForEach-Object {
    Remove-PnPListItem -List Bills -Identity $_.Id -Force
}