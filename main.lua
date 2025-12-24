-- Place this in StarterPlayer > StarterPlayerScripts as a LocalScript

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptExecutor"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Create main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 400)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
mainFrame.Parent = screenGui

-- Create title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -35, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ScriptPlayground"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 16
titleLabel.Parent = titleBar

-- Create close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -28, 0, 2.5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = titleBar

-- Create text box (code editor)
local codeBox = Instance.new("TextBox")
codeBox.Name = "CodeBox"
codeBox.Size = UDim2.new(1, -10, 1, -80)
codeBox.Position = UDim2.new(0, 5, 0, 35)
codeBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
codeBox.BorderSizePixel = 1
codeBox.BorderColor3 = Color3.fromRGB(60, 60, 60)
codeBox.TextColor3 = Color3.fromRGB(220, 220, 220)
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 14
codeBox.Text = "-- Type your code here\nprint('Hello from executor!')"
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.ClearTextOnFocus = false
codeBox.MultiLine = true
codeBox.TextWrapped = false
codeBox.Parent = mainFrame

-- Create run button
local runButton = Instance.new("TextButton")
runButton.Name = "RunButton"
runButton.Size = UDim2.new(0, 100, 0, 35)
runButton.Position = UDim2.new(1, -110, 1, -42)
runButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
runButton.Text = "Run"
runButton.TextColor3 = Color3.fromRGB(255, 255, 255)
runButton.Font = Enum.Font.SourceSansBold
runButton.TextSize = 18
runButton.Parent = mainFrame

-- Add UICorner for rounded buttons
local function addCorner(obj, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = obj
end

addCorner(closeButton, 4)
addCorner(runButton, 6)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Run button functionality
runButton.MouseButton1Click:Connect(function()
	local code = codeBox.Text
	local success, err = pcall(function()
		local func = loadstring(code)
		if func then
			func()
		end
	end)
	
	if not success then
		warn("Script execution error: " .. tostring(err))
	end
end)

-- Make draggable
local dragging = false
local dragInput, mousePos, framePos

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		mousePos = input.Position
		framePos = mainFrame.Position
	end
end)

titleBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - mousePos
		mainFrame.Position = UDim2.new(
			framePos.X.Scale,
			framePos.X.Offset + delta.X,
			framePos.Y.Scale,
			framePos.Y.Offset + delta.Y
		)
	end
end)
