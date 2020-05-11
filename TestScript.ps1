<#
.SYNOPSIS
   TestScript for the PS Logging Interface
.DESCRIPTION
	TestScript
.EXAMPLE
   Look at the Test-ScriptLogger Function to see how the script works
#>

<# Include block #>
. ".\LogInterface.ps1"

<# Function block #>
function Test-ScriptLogger() {
	
	# Create a log config
	$logCfg						= Get-NewLogConfig
	
	# Configure file logging target
	$debugLog 					= Get-NewLogTarget -targetType "file"
	$debugLog.ArchiveAboveSize 	= 102400
	$debugLog.archiveEvery 		= "Month"
	$debugLog.ArchiveNumbering 	= "Rolling"	
	$debugLog.CreateDirs		= $true	
	$debugLog.FileName 			= 'C:\tmp\powershell\LogInterface\log\debug.log'
	$debugLog.Encoding 			= [System.Text.Encoding]::GetEncoding("iso-8859-2")
	$debugLog.KeepFileOpen 		= $false
	$debugLog.Layout 			= Get-LogMessageLayout -layoutId 1	
	$debugLog.maxArchiveFiles 	= 1
	
	# Add target to Log config
	$logCfg.AddTarget("file", $debugLog)
	
	# Configure a console logging target
	$console 					= Get-NewLogTarget -targetType "console"
	$console.Layout 			= Get-LogMessageLayout -layoutId 1
	
	# Add target to Log config
	$logCfg.AddTarget("console", $console)
	
	# Configure rules for targets
	$rule1 = New-Object NLog.Config.LoggingRule("*", [NLog.LogLevel]::Trace, $console)
	$logCfg.LoggingRules.Add($rule1)
	
	$rule2 = New-Object NLog.Config.LoggingRule("*", [NLog.LogLevel]::Debug, $debugLog)
	$logCfg.LoggingRules.Add($rule2)

	# Assign configured Log config to LogManager
	[NLog.LogManager]::Configuration = $logCfg
	
	# Create a new Logger
	$Log = Get-NewLogger -loggerName "TestLogger"
	
	# Write test Log messages
	$Log.Debug("Debug Message")
	$Log.Info("Info Message")
	$Log.Warn("Warn Message")
	$Log.Error("Error Message")
	$Log.Trace("Trace Message")
	$Log.Fatal("Fatal Message")
	
	$Log.Warn("Warn Message")
	$Log.Error("Error Message")
}

# Restore NLog lib
Add-PackageReference

<# Test Section / Function call#>
Test-ScriptLogger
