<#
.SYNOPSIS
   A PowerShell CmdLet that add's logging functionality to your scripts
.DESCRIPTION
   The script is using the nLog .NET Library ( https://github.com/nlog/NLog | http://nlog-project.org )
   What gives you a couple of good logging features with a lot of control.
.EXAMPLE
   Look at the Test-ScriptLogger Function to see how the script works
#>

<# Function block #>
function Invoke-UnzipPackage($nupkg, $out)
{
    Add-Type -AssemblyName 'System.IO.Compression.FileSystem'
    $zipFile = [IO.Compression.ZipFile]
    $zipFile::ExtractToDirectory($nupkg, $out)
}
function Add-PackageReference
{
    $url = 'https://www.nuget.org/api/v2/package/NLog'
    $directory = $PSScriptRoot, 'packages', 'NLog.4.7.0' -Join '\'
    $nupkg = Join-Path $directory 'NLog.4.7.0.nupkg'
    $assemblyPath = $directory, 'lib', 'net45', 'NLog.dll' -Join '\'
    
    if (Test-Path $assemblyPath) {
        Add-Type -Path $assemblyPath
        return
    }
    
    Remove-Item -Recurse -Force $directory 2>&1 | Out-Null
    mkdir -f $directory | Out-Null
    Invoke-WebRequest $url -OutFile $nupkg
    Invoke-UnzipPackage $nupkg -Out $directory
    Add-Type -Path $assemblyPath
}

<#
.SYNOPSIS
	Creates a new LogManager instance
.DESCRIPTION
	Important to log messages to file, mail, console etc.
.EXAMPLE
   $myLogger = Get-NewLogger()
#>
function Get-NewLogger() {
    param ( [parameter(mandatory=$true)] [System.String]$loggerName ) 
    
    [NLog.LogManager]::GetLogger($loggerName) 
}


<#
.SYNOPSIS
	Creates a new configuration in memory
.DESCRIPTION
	Important to add logging behaviour and log targets to your LogManager
.EXAMPLE
   $myLogconfig = Get-NewLogConfig()
#>
function Get-NewLogConfig() {

	New-Object NLog.Config.LoggingConfiguration 
}


<#
.SYNOPSIS
	Creates a new logging target
.DESCRIPTION
	Logging targets are required to write down the log messages somewhere
.EXAMPLE
   $myFilelogtarget = Get-NewLogTarget -targetType "file"
#>
function Get-NewLogTarget() {
	param ( [parameter(mandatory=$true)] [System.String]$targetType ) 
	
	switch ($targetType) {
		"console" {
			New-Object NLog.Targets.ColoredConsoleTarget	
		}
		"file" {
			New-Object NLog.Targets.FileTarget
		}
		"mail" { 
			New-Object NLog.Targets.MailTarget
		}
	}

}

<#
.SYNOPSIS
	Sets the log message layout
.DESCRIPTION
	Defines, how your log message looks like. This function can be enhanced by yourself. I just provided a few examples how log messages can look like
.EXAMPLE
   #$myFilelogtarget.Layout	= Get-LogMessageLayout -layoutId 1
#>
function Get-LogMessageLayout() {
	param ( [parameter(mandatory=$true)] [System.Int32]$layoutId ) 
	
	switch ($layoutId) {
		1 {
			$layout	= '${longdate} | ${machinename} | ${processid} | ${processname} | ${level} | ${logger} | ${message}'
		}
		default {
			$layout	= '${longdate}|${machinename}|${processid}|${processname}|${level}|${logger}|${message}'
		}
	}
	return $layout
}


