# ConsoleUtility_VOTV
Mod for use UConsole from script in UE4SS
---
supported parameters are registered in the Console.

No support for structure with autocomplete (currently)

# Functions

* ### ConsoleUtility:IsOpen()
Check if console is open in any mode<br>
Return: true|false
* ### ConsoleUtility:IsTyping()
Check if console is open in one line mode<br>
Return: true|false
* ### ConsoleUtility:IsDisplayed()
Check if console is open in full opened mode<br>
return: true|false
* ### ConsoleUtility:IsShiftPressed()
Check if shift is pressed in opened console<br>
return: true|false
* ### ConsoleUtility:IsCtrlPressed()
Check if ctrl is pressed in opened console<br>
return: true|false
* ### ConsoleUtility:GetState()
Return state of console mode<br>
Return: -1|0|1|2, None|None|Typing|Open

* ### ConsoleUtility:SetState(state)
Set state of console display<br>

> state<br>-1	None <br>	0	closed<br>	1	line mode<br>	2	full open
* ### ConsoleUtility:ClearOutputBuffer()
Clear output console<br>
* ### ConsoleUtility:ClearHistoryBuffer()
Clear history of executed commands console<br>
* ### ConsoleUtility:Clear()
Clear any data of console<br>

* ### ConsoleUtility:InsertHistoryBuffer(i,v)
insert line in history by index<br>
* ### ConsoleUtility:InsertHistoryBuffer(v)
insert line in history to last index<br>
* ### ConsoleUtility:GetHistoryBuffer()
Get history of execution in console<br>
Return: array
* ### ConsoleUtility:SetHistoryBuffer()
Set history of execution in console<br>
Return: array
* ### ConsoleUtility:IsHistoryEmpty()
Check if history is empty<br>
Return: true|false

* ### ConsoleUtility:InsertOutput(i,v)
insert line in output by index<br>
* ### ConsoleUtility:InsertOutput(v)
insert line in output to last index<br>
* ### ConsoleUtility:SetOutputBuffer(array)
Set new array to output<br>
* ### ConsoleUtility:IsOutputEmpty()
Check if output is empty<br>
Return: true|false

* ### ConsoleUtility:SetBottomPadding(value)
Set padding in output view<br>
* ### ConsoleUtility:GetBottomPadding()
Get padding in output view<br>
Return: number

* ### ConsoleUtility:SetString(string)
Set string in input line<br>
* ### ConsoleUtility:GetString()
Set string in input line<br>
Return: string
* ### ConsoleUtility:SetAutoCompleteText(string)
Set autofill string in input line<br>
* ### ConsoleUtility:GetAutoCompleteText()
Get auto string in input line<br>
Return: string

* ### ConsoleUtility:SetCursor(number)
Set cursor position<br>
* ### ConsoleUtility:GetCursor()
Get cursor position<br>
Return: number


# Example

``` lua
local CUtil = require("ConsoleUtility")
local function init()
	if not CUtil:IsOpen()
	then
		CUtil:SetState(2)
	end
	CUtil:clear()
	CUtil:SetOutputBuffer(
		{
			"# hello from supa script",
			"# hello from supa",
			"# hello from",
			"# hello",
			"# "
		}
	)
	CUtil:SetString("any thing what you want")
	CUtil:SetAutoCompleteText("                        and any text what you know")
	CUtil:inserHistoryBuffer("You can call any of what is index is")
	
end
init()
```
``` lua
local CUtil = require("ConsoleUtility")
LoopAsync(500,function ()
	if not ModAlive then
		return true
	end
	if not CUtil:IsDisplayed() then return false end

	if string.find("",CUtil:GetString(),0,true) then
		CUtil:SetAutoCompleteText("")
		CUtil:InsertHistoryBuffer(51,ConsoleUtil:GetString() .. "")
	elseif string.find("load",CUtil:GetString(),0,true) then
		CUtil:SetAutoCompleteText("load <mapname>")
		CUtil:InsertHistoryBuffer(51,"load ")
	elseif string.find("impulse",CUtil:GetString(),0,true) then
		CUtil:SetAutoCompleteText("impulse <integer>")
		CUtil:InsertHistoryBuffer(51,"impulse ")
	elseif string.find("test",CUtil:GetString(),0,true) then
		CUtil:SetAutoCompleteText("test is testing")
		CUtil:InsertHistoryBuffer(51,"test ")

	else
		CUtil:SetAutoCompleteText("                           Nothing Found")
		CUtil:InsertHistoryBuffer(51,ConsoleUtil:GetString() .. "")
	end
	return false
end)
```








