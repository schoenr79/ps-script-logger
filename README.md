# PowerShell ScriptLogger CmdLet
A logging interface for your PowerShell scripts, build with NLot

# About
this CmdLet provides you a few functions to implement logging behavior in your PS-Scripts. Based on the [Nlog](https://nlog.org) C# library, you have a lot of possibilities how you want to implement your logging. Also it is easy and fast.

## Goals
One of my personal goals was, to get a better understanding, how .NET-Objects and a scripting engine can interact together.

To all of those who are familar with PowerShell, just download the CmdLet and start logging. Otherwise just go to my blog and view the original article ([here](http://12.mayjestic.net/index.php/20150205/powershell-logging-interface))

## Benefits
* Common logging functionality for all your PowerShell scripts
* Reusable code
* Easy to implement for the future

# Setup
Use the `TestScript.ps1` file to look how, logging functionality can be implemented into your script logic.

# Roadmap
* Move all logic to a PS Module (*.psm*) => V2.0
* Easier logger initializtion
* Add more default layouts