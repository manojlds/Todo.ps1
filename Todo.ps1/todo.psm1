#Requires -Version 2.0
Set-StrictMode -Version 2.0

$TODO_DIR = $PSScriptRoot
$TODO_TXT = Join-Path $TODO_DIR todo.txt


function Write-Help {
    Write-Output "todo.ps1 help"
}

function t {
	[CmdletBinding()]
    param(
        [Parameter(Mandatory = 0)][switch] $help,
        [Parameter(Position = 0, Mandatory = 0)][string] $command,
        [Parameter(Position = 1, Mandatory = 0)][string[]] $args
        )

    if($help){
        Write-Help
    }

    if($command -eq "add") {
        $args[0] | Out-File -FilePath $TODO_TXT -Append -Encoding utf8
    }


}
 
Export-ModuleMember -function t