-- Load WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Create custom Peach theme (from VoidWare)
WindUI:CreateTheme({
    Name = "Peach",
    Main = Color3.fromRGB(255, 218, 185), -- Peach
    Secondary = Color3.fromRGB(255, 160, 122), -- Light Salmon
    Tertiary = Color3.fromRGB(255, 127, 80), -- Coral
    Text = Color3.fromRGB(50, 30, 20), -- Dark Brown
    PlaceholderText = Color3.fromRGB(120, 80, 60),
    Textbox = Color3.fromRGB(255, 239, 213),
    NavBar = Color3.fromRGB(255, 200, 165),
    Theme = Color3.fromRGB(255, 180, 140),
})

-- Create custom Catppuccin Mocha theme
WindUI:CreateTheme({
    Name = "Catppuccin Mocha",
    Main = Color3.fromRGB(30, 30, 46), -- Base
    Secondary = Color3.fromRGB(49, 50, 68), -- Surface0
    Tertiary = Color3.fromRGB(137, 180, 250), -- Blue
    Text = Color3.fromRGB(205, 214, 244), -- Text
    PlaceholderText = Color3.fromRGB(108, 112, 134), -- Overlay0
    Textbox = Color3.fromRGB(24, 24, 37), -- Mantle
    NavBar = Color3.fromRGB(17, 17, 27), -- Crust
    Theme = Color3.fromRGB(180, 190, 254), -- Lavender
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
