-- Load WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Create custom Peach theme (from VoidWare)
WindUI:AddTheme({
    Name = "Peach",
    Accent = Color3.fromRGB(255, 127, 80), -- Coral
    Background = Color3.fromRGB(255, 218, 185), -- Peach
    Outline = Color3.fromRGB(255, 160, 122), -- Light Salmon
    Text = Color3.fromRGB(50, 30, 20), -- Dark Brown
    Placeholder = Color3.fromRGB(120, 80, 60),
    Button = Color3.fromRGB(255, 180, 140),
    Icon = Color3.fromRGB(255, 200, 165),
})

-- Create custom Catppuccin Mocha theme
WindUI:AddTheme({
    Name = "Catppuccin Mocha",
    Accent = Color3.fromRGB(137, 180, 250), -- Blue
    Background = Color3.fromRGB(30, 30, 46), -- Base
    Outline = Color3.fromRGB(49, 50, 68), -- Surface0
    Text = Color3.fromRGB(205, 214, 244), -- Text
    Placeholder = Color3.fromRGB(108, 112, 134), -- Overlay0
    Button = Color3.fromRGB(49, 50, 68), -- Surface0
    Icon = Color3.fromRGB(180, 190, 254), -- Lavender
})

-- Create the main window
local Window = WindUI:CreateWindow({
    Title = "ScriptPlayground",
    Icon = "code",
    Author = ".srhi",
    Folder = "ScriptPlaygroundConfig",
    Transparent = false,
    Theme = "Catppuccin Mocha",
    Keybind = Enum.KeyCode.RightAlt,
})

-- Create main tab
local Tab = Window:Tab({
    Title = "Editor",
    Icon = "edit"
})

-- Store the code
local currentCode = "-- Type your code here\nprint('Hello World!')"

-- Add the code input (textarea)
local CodeInput = Tab:Section({Title = "Code Editor"})

CodeInput:Input({
    Title = "Script Code",
    Placeholder = "Enter your Lua code here...",
    Value = currentCode,
    Textarea = true,
    Callback = function(value)
        currentCode = value
    end
})

-- Add run button
local Actions = Tab:Section({Title = "Actions"})

Actions:Button({
    Title = "Run Code",
    Description = "Execute the script locally",
    Callback = function()
        local success, err = pcall(function()
            local func = loadstring(currentCode)
            if func then
                func()
                WindUI:Notification({
                    Title = "Success",
                    Content = "Script executed successfully!",
                    Duration = 3
                })
            else
                WindUI:Notification({
                    Title = "Error",
                    Content = "Failed to compile script",
                    Duration = 5
                })
            end
        end)
        
        if not success then
            warn("Script execution error: " .. tostring(err))
            WindUI:Notification({
                Title = "Execution Error",
                Content = tostring(err),
                Duration = 5
            })
        end
    end
})

Actions:Button({
    Title = "Clear Code",
    Description = "Reset the code editor",
    Callback = function()
        currentCode = ""
        WindUI:Notification({
            Title = "Cleared",
            Content = "Code editor has been cleared",
            Duration = 2
        })
    end
})

-- Add settings tab
local Settings = Window:Tab({
    Title = "Settings",
    Icon = "settings"
})

local GeneralSettings = Settings:Section({Title = "General"})

-- Theme dropdown (includes default WindUI themes + custom ones)
GeneralSettings:Dropdown({
    Title = "Theme",
    Description = "Change the UI theme",
    Options = {"Dark", "Light", "Mocha", "Aqua", "Jester", "Peach", "Catppuccin Mocha"},
    Default = "Catppuccin Mocha",
    Callback = function(value)
        Window:SetTheme(value)
        WindUI:Notification({
            Title = "Theme Changed",
            Content = "Theme set to " .. value,
            Duration = 2
        })
    end
})

-- Keybind to minimize UI
GeneralSettings:Keybind({
    Title = "Toggle UI Keybind",
    Description = "Keybind to show/hide the UI",
    Default = Enum.KeyCode.RightAlt,
    Callback = function(key)
        Window:SetKeybind(key)
        WindUI:Notification({
            Title = "Keybind Updated",
            Content = "UI toggle set to " .. key.Name,
            Duration = 2
        })
    end
})
