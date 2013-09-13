#Requires -Version 2.0
Set-StrictMode -Version 2.0

$TODO_DIR = $PSScriptRoot
$TODO_TXT = Join-Path $TODO_DIR todo.txt
$TODO_DONE_TXT = Join-Path $TODO_DIR done.txt
$TODO_TXT_TEMP = Join-Path $TODO_DIR todo.txt.tmp
$TODO_TXT_BACKUP = Join-Path $TODO_DIR todo.txt.bak

function Write-Help {
    Write-Output "todo.ps1 help"
}

function Create-TodoItem($todo, $number) {
    $priority = "ZZ";
    if($_ -match "^\(([A-Z])\) ") {
        $priority = $matches[1]
    }
    $todoItem = New-Object PSObject -Property @{
        "Todo" = $todo;
        "Priority" = $priority;
        "Line" = $number;
    }

    $todoItem
}

function t {
	[CmdletBinding()]
    param(
        [Parameter(Mandatory = 0)][switch] $help,
        [Parameter(Position = 0, Mandatory = 0)][string] $command,
        [Parameter(Position = 1, Mandatory = 0)][string[]] $commandArgs
        )
    if($help){
        Write-Help
    }

    if($command -eq "add") {
        $commandArgs[0] | Out-File -FilePath $TODO_TXT -Append -Encoding utf8
    }

    if($command -eq "ls") {
        $lineCount = 0
        Get-Content $TODO_TXT | %{ $lineCount++; $_} | ?{ $_ -notmatch "^x \d{4}-\d{2}-\d{2} " } | %{
            $todo = $_

            $filtered = $commandArgs | ?{ $todo -match $_; }

            if(!$commandArgs -or $filtered) {
                Create-TodoItem $todo $lineCount
            }

        } | sort-object Priority | %{
            Write-Output ("{0} {1}" -f ($_.Line, $_.Todo))
        }
    }

    if($command -eq "rm") {
        $lineCount = 0
        Get-Content $TODO_TXT | %{
            $lineCount++;
            if($lineCount -ne $commandArgs[0]) {
                $_
            }
        } | Out-File $TODO_TXT_TEMP -Encoding utf8

        Move-Item $TODO_TXT $TODO_TXT_BACKUP -Force
        Move-Item $TODO_TXT_TEMP $TODO_TXT -Force

    }

    if($command -eq "do") {
        $lineCount = 0
        Get-Content $TODO_TXT | %{
            $lineCount++;
            if($lineCount -ne $commandArgs[0]) {
                $_
            } else {
                $dateDone = Get-Date
                "x {0:yyyy-mm-dd} {1}" -f ($dateDone, $_)
            }
        } | Out-File $TODO_TXT_TEMP -Encoding utf8

        Move-Item $TODO_TXT $TODO_TXT_BACKUP -Force
        Move-Item $TODO_TXT_TEMP $TODO_TXT -Force
    }

    if($command -eq "archive") {
        $done = @()
        Get-Content $TODO_TXT |  %{ 
            if($_ -match "^x \d{4}-\d{2}-\d{2} ") {
                $done += $_
            } else {
                $_
            }
        } | Out-File $TODO_TXT_TEMP -Encoding utf8

        Move-Item $TODO_TXT $TODO_TXT_BACKUP -Force
        Move-Item $TODO_TXT_TEMP $TODO_TXT -Force

        $done | Out-File $TODO_DONE_TXT -Encoding utf8
    }

    if($command -eq "dp") {
        $lineCount = 0
        Get-Content $TODO_TXT | %{
            $lineCount++;
            if($lineCount -ne $commandArgs[0]) {
                $_
            } else {
                $_ -replace "^\([A-Z]\) ", ""
            }
        } | Out-File $TODO_TXT_TEMP -Encoding utf8

        Move-Item $TODO_TXT $TODO_TXT_BACKUP -Force
        Move-Item $TODO_TXT_TEMP $TODO_TXT -Force
    }
}
 
Export-ModuleMember -function t