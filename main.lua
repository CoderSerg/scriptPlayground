-- ScriptPlayground v3.5
-- Fully Local, MacSploit-safe, plain editor with console

--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// CONSTANTS
local MIN_WIDTH = 420
local MIN_HEIGHT = 260

--// THEME (Catppuccin Mocha)
local Theme = {
	Base = Color3.fromRGB(30, 30, 46),
	Mantle = Color3.fromRGB(24, 24, 37),
	Crust = Color3.fromRGB(17, 17, 27),
	Text = Color3.fromRGB(205, 214, 244),
	Surface0 = Color3.fromRGB(49, 50, 68),
	Surface1 = Color3.fromRGB(69, 71, 90),
	Green = Color3.fromRGB(166, 227, 161),
	Red = Color3.fromRGB(243, 139, 168),
}

--// HELPERS
local function round(obj, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = obj
end

-- Safe loadstring
local SAFE_LOADSTRING = loadstring or (getgenv and getgenv().loadstring)

--// GUI ROOT
local gui = Instance.new("ScreenGui")
gui.Name = "ScriptPlayground"
gui.ResetOnSpawn = false
gui.Parent = playerGui

--// MAIN WINDOW
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(620, 500)
main.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromOffset(310, 250)
main.BackgroundColor3 = Theme.Base
main.ClipsDescendants = true
main.Parent = gui
round(main, 14)

local stroke = Instance.new("UIStroke")
stroke.Color = Theme.Surface1
stroke.Thickness = 1
stroke.Parent = main

--// TITLE BAR
local title = Instance.new("Frame")
title.Size = UDim2.new(1, 0, 0, 36)
title.BackgroundColor3 = Theme.Mantle
title.Parent = main
round(title, 14)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.fromOffset(12, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ScriptPlayground"
titleLabel.Font = Enum.Font.SourceSansSemibold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextColor3 = Theme.Text
titleLabel.Parent = title

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(26, 26)
close.Position = UDim2.new(1, -34, 0, 5)
close.Text = "×"
close.Font = Enum.Font.SourceSansBold
close.TextSize = 22
close.TextColor3 = Theme.Text
close.BackgroundColor3 = Theme.Red
close.Parent = title
round(close, 6)

close.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

--// EDITOR
local editor = Instance.new("TextBox")
editor.Position = UDim2.fromOffset(10, 46)
editor.Size = UDim2.new(1, -20, 0, 300)
editor.BackgroundColor3 = Theme.Crust
editor.ClearTextOnFocus = false
editor.MultiLine = true
editor.TextWrapped = false
editor.TextXAlignment = Enum.TextXAlignment.Left
editor.TextYAlignment = Enum.TextYAlignment.Top
editor.Font = Enum.Font.Code
editor.TextSize = 14
editor.TextColor3 = Theme.Text
editor.TextTransparency = 0 -- visible typing
editor.Text = "-- type code here\nprint('hello world')"
editor.Parent = main
round(editor, 10)

--// OUTPUT CONSOLE
local console = Instance.new("TextLabel")
console.Size = UDim2.new(1, -20, 0, 130)
console.Position = UDim2.fromOffset(10, 400)
console.BackgroundColor3 = Theme.Surface0
console.TextColor3 = Theme.Text
console.TextXAlignment = Enum.TextXAlignment.Left
console.TextYAlignment = Enum.TextYAlignment.Top
console.TextWrapped = true
console.RichText = true
console.Font = Enum.Font.Code
console.TextSize = 14
console.Text = ""
console.Parent = main
round(console, 6)

local function printConsole(...)
	local msgs = {}
	for i,v in ipairs({...}) do
		msgs[#msgs+1] = tostring(v)
	end
	console.Text = table.concat(msgs,"\t") .. "\n" .. console.Text
end

--// RUN BUTTON
local runButton = Instance.new("TextButton")
runButton.Size = UDim2.fromOffset(100, 30)
runButton.Position = UDim2.fromOffset(510, 360) -- below editor
runButton.BackgroundColor3 = Theme.Green
runButton.Text = "Run"
runButton.Font = Enum.Font.SourceSansBold
runButton.TextSize = 16
runButton.TextColor3 = Theme.Text
runButton.Parent = main
round(runButton, 6)

runButton.MouseButton1Click:Connect(function()
	if not SAFE_LOADSTRING then
		printConsole("loadstring not available in this thread")
		return
	end
	local src = editor.Text
	if src:byte(1) == 239 then
		src = src:sub(4)
	end
	local fn, err = SAFE_LOADSTRING(src)
	if not fn then
		printConsole("Compile error: "..tostring(err))
		return
	end
	local ok, res = pcall(fn)
	if not ok then
		printConsole("Runtime error: "..tostring(res))
	else
		printConsole("Executed successfully")
	end
end)

--// DRAGGING
do
	local dragging=false
	local startMouse, startPos
	title.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging=true
			startMouse=i.Position
			startPos=main.Position
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = i.Position - startMouse
			main.Position = startPos + UDim2.fromOffset(delta.X, delta.Y)
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging=false
		end
	end)
end

--// RESIZING
local function resizeHandle(size,pos,fn)
	local h = Instance.new("Frame")
	h.Size = size
	h.Position = pos
	h.BackgroundTransparency = 1
	h.Active = true
	h.Parent = main

	local resizing = false
	local startMouse, startSize, startPos
	h.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then
			resizing=true
			startMouse=i.Position
			startSize=main.Size
			startPos=main.Position
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if resizing and i.UserInputType==Enum.UserInputType.MouseMovement then
			fn(i.Position-startMouse,startSize,startPos)
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then
			resizing=false
		end
	end)
end

-- right
resizeHandle(UDim2.new(0,6,1,-20), UDim2.new(1,-3,0,10), function(d,s)
	main.Size = UDim2.fromOffset(math.max(MIN_WIDTH, s.X.Offset+d.X), s.Y.Offset)
end)
-- bottom
resizeHandle(UDim2.new(1,-20,0,6), UDim2.new(0,10,1,-3), function(d,s)
	main.Size = UDim2.fromOffset(s.X.Offset, math.max(MIN_HEIGHT, s.Y.Offset+d.Y))
end)
-- left
resizeHandle(UDim2.new(0,6,1,-20), UDim2.new(0,-3,0,10), function(d,s,p)
	local w = math.max(MIN_WIDTH, s.X.Offset-d.X)
	main.Size = UDim2.fromOffset(w, s.Y.Offset)
	main.Position = p + UDim2.fromOffset(s.X.Offset-w, 0)
end)
-- top
resizeHandle(UDim2.new(1,-20,0,6), UDim2.new(0,10,0,-3), function(d,s,p)
	local h = math.max(MIN_HEIGHT, s.Y.Offset-d.Y)
	main.Size = UDim2.fromOffset(s.X.Offset, h)
	main.Position = p + UDim2.fromOffset(0, s.Y.Offset-h)
end)
-- bottom-right corner
resizeHandle(UDim2.fromOffset(14,14), UDim2.new(1,-14,1,-14), function(d,s)
	main.Size = UDim2.fromOffset(math.max(MIN_WIDTH, s.X.Offset+d.X), math.max(MIN_HEIGHT, s.Y.Offset+d.Y))
end)

--// RIGHT ALT TOGGLE
UIS.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.RightAlt then
		gui.Enabled = not gui.Enabled
	end
end)
