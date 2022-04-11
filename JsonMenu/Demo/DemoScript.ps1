# [CmdletBinding()]
# param (
#     [Parameter()]
#     [string]
#     $Name
# )

# $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
# $stopwatch.Start()

# Write-Output "Beginning of action that takes some time!"
# Write-Output "Now wait 2 seconds"
# Start-Sleep 2
# Write-Output $("Important information you would rather not have to wait for, $Name!")
# Write-Output "Now wait another 2 seconds"
# Get-Process | Format-Table
# Start-Sleep 2
# Write-Output "Operation finished!"

# $stopwatch.Stop()

# Write-Output "That was another $([math]::Round($stopwatch.Elapsed.TotalMilliseconds)) milliseconds of your life ;-)"

# $ActionResult = "Just a function"
# return $ActionResult
function Write-PipeLineInfoValue {
    [cmdletbinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipeline = $true)]
        $pipelineInput
    )
    Begin {
        Write-Host `n"The begin {} block runs once at the start, and is good for setting up variables."
        Write-Host "-------------------------------------------------------------------------------"
    }
    Process {
        # Write-Host "Process [$pipelineInput]"
        ForEach ($input in $pipelineInput) {
            Write-Host "Process [$($input.Name)] information"

            $pipelineInput | AnotherLevel
            # if ($input.Path) {
            #     Write-Host "Path: $($input.Path)"`n
            # }
            # else {
            #     Write-Host "No path found!"`n -ForegroundColor Red
            # }
        }
    }
    End {
        Write-Host "-------------------------------------------------------------------------------"
        Write-Host "The end {} block runs once at the end, and is good for cleanup tasks."`n
    }
}


function AnotherLevel {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline, Mandatory = $true)]
        $Invoer
    )
    process {
        Write-Host $("Dit was de invoer $Invoer")
    }
}

function GetServices {
    [CmdletBinding()]
    param (
    )
    Write-Output "Get some services"
    Get-Service
    "hello world"
}

# "hello world" | Write-PipeLineInfoValue
GetServices | Write-PipeLineInfoValue
