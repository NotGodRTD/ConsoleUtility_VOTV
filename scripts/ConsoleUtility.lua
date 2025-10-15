



















local ConsoleUtility = {}

--#region class UClass

---@class	UConsole : UObject
---@field	CursorPos						number
---@field	ConsoleOpenMode					FName
---@field	ButtonPressed					boolean 
---@field	OutputBuffer					table
---@field	TypedStr						string
---@field	OutputBufferBottomElement		number
---@field	HistoryBuffer					table
---@field	IsValid							function
---@field	ToString						function
---@field	AutoCompleteText				string

--#endregion class UClass

--#region reg

PropertyTypes.ArrayProperty.Size = 0x10
PropertyTypes.BoolProperty.Size = 0x1
PropertyTypes.EnumProperty.Size = 0x1
PropertyTypes.StructProperty.Size = 0xC

RegisterCustomProperty({
    ["Name"] = "OutputBuffer",
    ["Type"] = PropertyTypes.ArrayProperty,
    ["BelongsToClass"] = "/Script/Engine.Console",
    ["OffsetInternal"] = 0x50,
    ["ArrayProperty"] = {
        ["Type"] = PropertyTypes.StrProperty
    }
})

RegisterCustomProperty({
    ["Name"] = "OutputBufferSize",
    ["Type"] = PropertyTypes.IntProperty,
    ["BelongsToClass"] = "/Script/Engine.Console",
    ["OffsetInternal"] = 0x58
})

RegisterCustomProperty({
    ["Name"] = "OutputBufferCurrentMaxSize",
    ["Type"] = PropertyTypes.IntProperty,
    ["BelongsToClass"] = "/Script/Engine.Console",
    ["OffsetInternal"] = 0x5C
})

RegisterCustomProperty({
    ["Name"] = "OutputBufferBottomElement",
    ["Type"] = PropertyTypes.IntProperty,
    ["BelongsToClass"] = "/Script/Engine.Console",
    ["OffsetInternal"] = 0x60
})

RegisterCustomProperty({
    ["Name"] = "ConsoleOpenMode",
    ["Type"] = PropertyTypes.NameProperty,
    ["BelongsToClass"] = "/Script/Engine.Console",
    ["OffsetInternal"] = 0xD8
})

RegisterCustomProperty({
    ["Name"] = "CursorPos",
    ["Type"] = PropertyTypes.IntProperty,
    ["BelongsToClass"] = "/Script/Engine.Console",
    ["OffsetInternal"] = 0x88
})

RegisterCustomProperty({
    ["Name"] = "TypedStr",
    ["Type"] = PropertyTypes.StrProperty,
    ["BelongsToClass"] = "/Script/Engine.Console",
    ["OffsetInternal"] = 0x78
})

RegisterCustomProperty({
    ["Name"] = "TypedStrSize",
    ["Type"] = PropertyTypes.IntProperty,
    ["BelongsToClass"] = "/Script/Engine.Console",
    ["OffsetInternal"] = 0x84,
})

--- NOT WORK IN SHIPPING BUILD
-- RegisterCustomProperty({
--     ["Name"] = "AutoComplete",
--     ["Type"] = PropertyTypes.ArrayProperty,
--     ["BelongsToClass"] = "/Script/Engine.Console",
--     ["OffsetInternal"] = 0x90,
--     ["ArrayProperty"] = {
--         ["Type"] = PropertyTypes.StrProperty
--     }
-- })

RegisterCustomProperty({
    ["Name"] = "AutoCompleteText",
    ["Type"] = PropertyTypes.StrProperty,
    ["BelongsToClass"] = "/Script/Engine.Console",
    ["OffsetInternal"] = 0x90,
})

RegisterCustomProperty({
    ["Name"] = "SelectedHistoryBufferText",
    ["Type"] = PropertyTypes.StrProperty,
    ["BelongsToClass"] = "/Script/Engine.Console",
    ["OffsetInternal"] = 0xA0,
})

RegisterCustomProperty({
    ["Name"] = "ButtonPressed",
    ["Type"] = PropertyTypes.IntProperty,
    ["BelongsToClass"] = "/Script/Engine.Console",
    ["OffsetInternal"] = 0xB0,
})

RegisterCustomProperty({
    ["Name"] = "SelectedHistoryBufferIndex",
    ["Type"] = PropertyTypes.IntProperty,
    ["BelongsToClass"] = "/Script/Engine.Console",
    ["OffsetInternal"] = 0xD0,
})

--#endregion reg

--#region func

--- Check if console is open in any mode
---@return boolean
function ConsoleUtility:IsOpen()
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return false
	elseif console.ConsoleOpenMode:ToString() == "Open" then return true
	else return false end
end

--- Check if console is open in one line mode
---@return boolean
function ConsoleUtility:IsTyping()
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return false
	elseif console.ConsoleOpenMode:ToString() == "Typing" then return true
	else return false end
end

--- Check if console is open in full opened mode
---@return boolean
function ConsoleUtility:IsDisplayed()
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return false
	elseif console.ConsoleOpenMode:ToString() == "None" then return false -- 0x0000
	elseif console.ConsoleOpenMode:ToString() == "Typing" then return true -- 0x2F206
	elseif console.ConsoleOpenMode:ToString() == "Open" then return true -- 0x2F20A
	else return false end
end

--- Check if shift is pressed in opened console
---@return boolean
function ConsoleUtility:IsShiftPressed()
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return false
	elseif console.ButtonPressed == 4 then return true
	elseif console.ButtonPressed == 6 then return true
	else return false end
end

--- Check if ctrl is pressed in opened console
---@return boolean
function ConsoleUtility:IsCtrlPressed()
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return false
	elseif console.ButtonPressed == 2 then return true
	elseif console.ButtonPressed == 6 then return true
	else return false end
end

--- return state of console mode
---@return ConsoleState CodeState
---@return "None"|"Typing"|"Open" string
function ConsoleUtility:GetState()
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return -1, "None"
	elseif console.ConsoleOpenMode:ToString() == "None" then return 0, "None"  -- 0x0000
	elseif console.ConsoleOpenMode:ToString() == "Typing" then return 1, "Typing" -- 0x2F206
	elseif console.ConsoleOpenMode:ToString() == "Open" then return 2, "Open" -- 0x2F20A
	else return -1, "None" end
end

---@alias ConsoleState
---|	-1	none
---|	0	closed
---|	1	typing
---|	2	open

--- Set state of console display
---@param state ConsoleState
function ConsoleUtility:SetState(state)
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return end
	if state == nil or state > 2 or state < 0 then console.ConsoleOpenMode = FName("None") return end
	if state == 0 then console.ConsoleOpenMode = FName("None")
	elseif state == 1 then console.ConsoleOpenMode = FName("Typing")
	elseif state == 2 then console.ConsoleOpenMode = FName("Open")
	end
end

--- Clear output console
function ConsoleUtility:ClearOutputBuffer()
	-- ExecuteConsoleCommand("clear")
	-- or
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return end
	console.OutputBuffer = {}
end

--- Clear history of executed commands console
function ConsoleUtility:ClearHistoryBuffer()
	-- ExecuteConsoleCommand("clear")
	-- or
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return end
	console.HistoryBuffer = {}
end

--- Clear any data of console
function ConsoleUtility:Clear()
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return end
	console.HistoryBuffer = {}
	console.OutputBuffer = {}
	console.TypedStr = ""
end

--- insert line in history by index<br>
--- insert line in history to last index
---@param index number
---@param value string
---@overload fun(self,value:string)
function ConsoleUtility:InsertHistoryBuffer(index,value)
	if TestNumber(index)
	then
		if index < 0 then return end
		local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
		if not console or not console:IsValid() or value == nil then return end
		console.HistoryBuffer[index] = value
	else
		local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
		if not console or not console:IsValid() then return end
		console.HistoryBuffer[#console.HistoryBuffer + 1] = index
	end
end

--- Get history of execution in console
---@return table
function ConsoleUtility:GetHistoryBuffer()
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return {} end
	return console.HistoryBuffer or {}
end

--- Set history of execution in console
---@param array table
function ConsoleUtility:SetHistoryBuffer(array)
	if #array < 1 then return end
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return {} end
	console.HistoryBuffer = array
end

--- Check if history is empty
---@return boolean
function ConsoleUtility:IsHistoryEmpty()
    local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return false end
    return #console.HistoryBuffer == 0 or false
end

--- insert line in output by index<br>
--- insert line in output to last index
---@param index string|number
---@param value string
---@overload fun(self,v:string)
function ConsoleUtility:InsertOutput(index,value)
	if TestNumber(index)
	then
		if index < 0 then return end
		local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
		if (not console or not console:IsValid()) or value == nil then return end
		console.OutputBuffer[index] = value
	else
		local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
		if not console or not console:IsValid() then return end
		console.OutputBuffer[#console.OutputBuffer + 1] = index
	end
end

--- Set new array to output
---@param array table
function ConsoleUtility:SetOutputBuffer(array)
	if #array < 1 then return end
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return end
	console.OutputBuffer = array
end

--- Check if output is empty
---@return boolean
function ConsoleUtility:IsOutputEmpty()
    local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return false end
    return #console.OutputBuffer == 0 or false
end

--- Set padding in output view
---@param value number
function ConsoleUtility:SetBottomPadding(value)
	if not TestNumber(value) then return end
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return end
	console.OutputBufferBottomElement = value
end

--- Get padding in output view
---@return number
function ConsoleUtility:GetBottomPadding()
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return -1 end
	return console.OutputBufferBottomElement
end

--- Set string in input line
---@param string string
function ConsoleUtility:SetString(string)
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if (not console or not console:IsValid()) or (string == nil) then return end
	console.TypedStr = string
end

--- Set string in input line
---@return string|nil
function ConsoleUtility:GetString()
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return nil end
	return console.TypedStr:ToString()
end

--- Set auto string in input line
---@param string string
function ConsoleUtility:SetAutoCompleteText(string)
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return end
	console.AutoCompleteText = string
end

--- Get auto string in input line
---@return string|nil
function ConsoleUtility:GetAutoCompleteText()
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return nil end
	return console.AutoCompleteText:ToString()
end

--- Set cursor position
---@param number number
function ConsoleUtility:SetCursor(number)
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return end
	console.CursorPos = number
end

--- Get cursor position
---@return number
function ConsoleUtility:GetCursor()
	local console = FindFirstOf("Console") or CreateInvalidObject() ---@cast console UConsole
	if not console or not console:IsValid() then return -1 end
	return console.CursorPos
end

--#endregion func

return ConsoleUtility

