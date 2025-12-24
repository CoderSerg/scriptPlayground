-- ScriptPlayground v3
-- Fully Local LocalScript

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

--// MAIN WINDOW
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(620, 440)
main.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromOffset(310, 220)
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

--// EDITOR CONTAINER
local editor = Instance.new("Frame")
editor.Position = UDim2.fromOffset(10, 46)
editor.Size = UDim2.new(1, -20, 1, -96)
editor.BackgroundColor3 = Theme.Crust
editor.Parent = main
editor.ClipsDescendants = true
round(editor, 10)

--// LINE NUMBERS
local lines = Instance.new("TextLabel")
lines.Size = UDim2.new(0, 42, 1, 0)
lines.BackgroundColor3 = Theme.Mantle
lines.TextXAlignment = Enum.TextXAlignment.Right
lines.TextYAlignment = Enum.TextYAlignment.Top
lines.Font = Enum.Font.Code
lines.TextSize = 14
lines.RichText = true
lines.TextColor3 = Theme.Subtext
lines.Text = "1"
lines.Parent = editor

--// HIGHLIGHT LAYER
local highlight = Instance.new("TextLabel")
highlight.Position = UDim2.fromOffset(48, 6)
highlight.Size = UDim2.new(1, -54, 1, -12)
highlight.BackgroundTransparency = 1
highlight.TextXAlignment = Enum.TextXAlignment.Left
highlight.TextYAlignment = Enum.TextYAlignment.Top
highlight.Font = Enum.Font.Code
highlight.TextSize = 14
highlight.RichText = true
highlight.TextWrapped = false
highlight.TextColor3 = Theme.Text
highlight.Parent = editor

--// INPUT LAYER
local input = Instance.new("TextBox")
input.Position = highlight.Position
input.Size = highlight.Size
input.BackgroundTransparency = 1
input.ClearTextOnFocus = false
input.MultiLine = true
input.TextWrapped = false
input.TextXAlignment = Enum.TextXAlignment.Left
input.TextYAlignment = Enum.TextYAlignment.Top
input.Font = Enum.Font.Code
input.TextSize = 14
input.TextTransparency = 1
input.Text = "-- type code here\nprint('hello world')"
input.Parent = editor

--// SYNTAX HIGHLIGHTING
local keywords = {
	local=true,function=true,end=true,if=true,then=true,else=true,
	elseif=true,for=true,while=true,do=true,return=true,true=true,false=true,nil=true
}

local function color(text, c)
	return string.format(
		'<font color="rgb(%d,%d,%d)">%s</font>',
		c.R*255, c.G*255, c.B*255, text
	)
end

local function highlightLua(src)
	src = src:gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;")
	src = src:gsub("%-%-.-\n", function(m) return color(m, Theme.Comment) end)
	src = src:gsub("\".-\"", function(m) return color(m, Theme.String) end)
	src = src:gsub("%d+", function(m) return color(m, Theme.Number) end)
	src = src:gsub("%a+", function(m)
		if keywords[m] then
			return color(m, Theme.Keyword)
		end
		return m
	end)
	return src
end

local function update()
	local text = input.Text
	highlight.Text = highlightLua(text)

	local count = select(2, text:gsub("\n", "")) + 1
	local nums = {}
	for i = 1, count do nums[i] = tostring(i) end
	lines.Text = table.concat(nums, "\n")
end

input:GetPropertyChangedSignal("Text"):Connect(update)
update()

--// DRAGGING
do
	local dragging = false
	local startMouse
	local startPos

	title.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			startMouse = i.Position
			startPos = main.Position
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
			dragging = false
		end
	end)
end

--// RESIZING SYSTEM
local function resizeHandle(size, pos, onDrag)
	local h = Instance.new("Frame")
	h.Size = size
	h.Position = pos
	h.BackgroundTransparency = 1
	h.Active = true
	h.Parent = main

	local resizing = false
	local startMouse, startSize, startPos

	h.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = true
			startMouse = i.Position
			startSize = main.Size
			startPos = main.Position
		end
	end)

	UIS.InputChanged:Connect(function(i)
		if resizing and i.UserInputType == Enum.UserInputType.MouseMovement then
			onDrag(i.Position - startMouse, startSize, startPos)
		end
	end)

	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = false
		end
	end)
end

-- Right
resizeHandle(UDim2.new(0,6,1,-20), UDim2.new(1,-3,0,10), function(d,s)
	main.Size = UDim2.fromOffset(math.max(MIN_WIDTH, s.X.Offset+d.X), s.Y.Offset)
end)

-- Bottom
resizeHandle(UDim2.new(1,-20,0,6), UDim2.new(0,10,1,-3), function(d,s)
	main.Size = UDim2.fromOffset(s.X.Offset, math.max(MIN_HEIGHT, s.Y.Offset+d.Y))
end)

-- Left
resizeHandle(UDim2.new(0,6,1,-20), UDim2.new(0,-3,0,10), function(d,s,p)
	local w = math.max(MIN_WIDTH, s.X.Offset-d.X)
	main.Size = UDim2.fromOffset(w, s.Y.Offset)
	main.Position = p + UDim2.fromOffset(s.X.Offset-w,0)
end)

-- Top
resizeHandle(UDim2.new(1,-20,0,6), UDim2.new(0,10,0,-3), function(d,s,p)
	local h = math.max(MIN_HEIGHT, s.Y.Offset-d.Y)
	main.Size = UDim2.fromOffset(s.X.Offset, h)
	main.Position = p + UDim2.fromOffset(0, s.Y.Offset-h)
end)

-- Bottom-right corner
resizeHandle(UDim2.fromOffset(14,14), UDim2.new(1,-14,1,-14), function(d,s)
	main.Size = UDim2.fromOffset(
		math.max(MIN_WIDTH, s.X.Offset+d.X),
		math.max(MIN_HEIGHT, s.Y.Offset+d.Y)
	)
end)

--// RIGHT ALT TOGGLE
UIS.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.RightAlt then
		gui.Enabled = not gui.Enabled
	end
end)
