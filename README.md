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
Clear any data of console<br>
Return: array
* ### ConsoleUtility:IsHistoryEmpty()
Clear any data of console<br>
Return: true|false

* ### ConsoleUtility:InsertHistoryBuffer(i,v)
insert line in history by index<br>
* ### ConsoleUtility:InsertHistoryBuffer(v)
insert line in history to last index<br>











