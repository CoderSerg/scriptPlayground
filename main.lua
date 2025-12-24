-- ScriptPlayground v2
-- LocalScript

--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// THEME (Catppuccin Mocha)
local Theme = {
	Base = Color3.fromRGB(30, 30, 46),
	Mantle = Color3.fromRGB(24, 24, 37),
	Crust = Color3.fromRGB(17, 17, 27),
	Text = Color3.fromRGB(205, 214, 244),
	Subtext = Color3.fromRGB(166, 173, 200),
	Surface0 = Color3.fromRGB(49, 50, 68),
	Surface1 = Color3.fromRGB(69, 71, 90),
	Accent = Color3.fromRGB(137, 180, 250),
	Green = Color3.fromRGB(166, 227, 161),
	Red = Color3.fromRGB(243, 139, 168),
	Keyword = Color3.fromRGB(203, 166, 247),
	String = Color3.fromRGB(244, 219, 214),
	Number = Color3.fromRGB(250, 179, 135),
	Comment = Color3.fromRGB(108, 112, 134),
}

--// HELPERS
local function round(obj, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = obj
end

--// GUI ROOT
local gui = Instance.new("ScreenGui")
gui.Name = "ScriptPlayground"
gui.ResetOnSpawn = false
gui.Parent = playerGui

--// MAIN FRAME
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(600, 420)
main.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromOffset(300, 210)
main.BackgroundColor3 = Theme.Base
main.Parent = gui
main.ClipsDescendants = true
round(main, 14)

local stroke = Instance.new("UIStroke")
stroke.Color = Theme.Surface1
stroke.Thickness = 1
stroke.Parent = main

--// TITLE BAR
local title = Instance.new("Frame")
title.Size = UDim2.new(1, 0, 0, 34)
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
titleLabel.TextXAlignment = Left
titleLabel.TextColor3 = Theme.Text
titleLabel.Parent = title

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(26, 26)
close.Position = UDim2.new(1, -34, 0, 4)
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

--// EDITOR CONTAINER
local editor = Instance.new("Frame")
editor.Position = UDim2.fromOffset(10, 44)
editor.Size = UDim2.new(1, -20, 1, -94)
editor.BackgroundColor3 = Theme.Crust
editor.Parent = main
round(editor, 10)

--// LINE NUMBERS
local lines = Instance.new("TextLabel")
lines.Size = UDim2.new(0, 40, 1, 0)
lines.BackgroundColor3 = Theme.Mantle
lines.TextXAlignment = Right
lines.TextYAlignment = Top
lines.TextWrapped = false
lines.Font = Enum.Font.Code
lines.TextSize = 14
lines.RichText = true
lines.TextColor3 = Theme.Subtext
lines.Parent = editor
round(lines, 10)

--// HIGHLIGHT LAYER
local highlight = Instance.new("TextLabel")
highlight.Position = UDim2.fromOffset(46, 6)
highlight.Size = UDim2.new(1, -52, 1, -12)
highlight.BackgroundTransparency = 1
highlight.TextXAlignment = Left
highlight.TextYAlignment = Top
highlight.TextWrapped = false
highlight.RichText = true
highlight.Font = Enum.Font.Code
highlight.TextSize = 14
highlight.TextColor3 = Theme.Text
highlight.Parent = editor

--// INPUT BOX (transparent)
local input = Instance.new("TextBox")
input.Position = highlight.Position
input.Size = highlight.Size
input.BackgroundTransparency = 1
input.ClearTextOnFocus = false
input.MultiLine = true
input.TextXAlignment = Left
input.TextYAlignment = Top
input.TextWrapped = false
input.Font = Enum.Font.Code
input.TextSize = 14
input.TextTransparency = 1
input.Text = "-- type code here\nprint('hello world')"
input.Parent = editor

--// SYNTAX HIGHLIGHTER
local keywords = {
	["local"]=true,["function"]=true,["end"]=true,["if"]=true,
	["then"]=true,["else"]=true,["elseif"]=true,["for"]=true,
	["while"]=true,["do"]=true,["return"]=true,["true"]=true,
	["false"]=true,["nil"]=true
}

local function color(text, c)
	return string.format('<font color="rgb(%d,%d,%d)">%s</font>',
		c.R*255,c.G*255,c.B*255,text)
end

local function highlightLua(src)
	src = src:gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;")

	src = src:gsub("%-%-.-\n", function(m)
		return color(m, Theme.Comment)
	end)

	src = src:gsub("\".-\"", function(m)
		return color(m, Theme.String)
	end)

	src = src:gsub("%d+", function(m)
		return color(m, Theme.Number)
	end)

	src = src:gsub("%a+", function(m)
		if keywords[m] then
			return color(m, Theme.Keyword)
		end
		return m
	end)

	return src
end

--// UPDATE LOOP
local function update()
	local text = input.Text
	highlight.Text = highlightLua(text)

	local count = select(2, text:gsub("\n", "")) + 1
	local ln = {}
	for i = 1, count do
		ln[#ln+1] = tostring(i)
	end
	lines.Text = table.concat(ln, "\n")
end

input:GetPropertyChangedSignal("Text"):Connect(update)
update()

--// DRAGGING
do
	local dragging, startPos, startFrame
	title.InputBegan:Connect(function(i)
		if i.UserInputType == MouseButton1 then
			dragging = true
			startPos = i.Position
			startFrame = main.Position
		end
	end)

	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == MouseMovement then
			local d = i.Position - startPos
			main.Position = startFrame + UDim2.fromOffset(d.X, d.Y)
		end
	end)

	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == MouseButton1 then
			dragging = false
		end
	end)
end

--// RIGHT ALT TOGGLE
UIS.InputBegan:Connect(function(i, g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.RightAlt then
		gui.Enabled = not gui.Enabled
	end
end)
