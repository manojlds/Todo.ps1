#Requires -Version 2.0
Set-StrictMode -Version 2.0

function t {
	[CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = 0)][switch] $help
        )
}
 
Export-ModuleMember -function t