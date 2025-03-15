-- Load Rayfield library
local RayfieldLibrary = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

-- Check if the library was loaded correctly
if not RayfieldLibrary then
    warn("Rayfield failed to load!")
    return
end

-- Create the main GUI window
local Window = RayfieldLibrary:CreateWindow({
    Name = "XwareHub", -- Updated name
    LoadingTitle = "Loading...",
    LoadingSubtitle = "By Xwares Productions",
    ConfigurationSaving = {
        Enabled = false,
    },
    Theme = {
        MainColor = Color3.fromRGB(255, 0, 0), -- Red menu color
        AccentColor = Color3.fromRGB(255, 255, 255), -- White toggles
        BackgroundColor = Color3.fromRGB(255, 255, 255), -- White background
    },
    Draggable = true, -- Allows moving the menu
    Minimized = false, -- Menu starts open
})

-- Create tabs
local TabMain = Window:CreateTab("Main", 4483362458)
local TabFisch = Window:CreateTab("Fisch", 4483362458)

-- Create a section in the Main tab
local SectionMain = TabMain:CreateSection("Settings")

-- WalkSpeed slider in Main tab
TabMain:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').WalkSpeed = Value
        end
    end,
})

-- NoClip toggle in Main tab
local noclip = false
local noclipConnection

TabMain:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(Value)
        noclip = Value

        if noclip then
            noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
        end
    end,
})

-- Infinite Jump toggle in Main tab
local infiniteJumpConnection

TabMain:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(Value)
        if Value then
            infiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
                if humanoid then
                    humanoid:ChangeState("Jumping")
                end
            end)
        else
            if infiniteJumpConnection then
                infiniteJumpConnection:Disconnect()
                infiniteJumpConnection = nil
            end
        end
    end,
})

-- Invisibility toggle in Main tab
local invisible = false

TabMain:CreateToggle({
    Name = "Invisibility",
    CurrentValue = false,
    Flag = "Invisibility",
    Callback = function(Value)
        local character = game.Players.LocalPlayer.Character

        if character then
            invisible = Value
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") or part:IsA("MeshPart") then
                    part.Transparency = invisible and 1 or 0 -- 1 = Invisible, 0 = Visible
                end
            end
        end
    end,
})

-- Create a section in the Fisch tab
local SectionFisch = TabFisch:CreateSection("Fisch Settings")

-- Auto Shake toggle in Fisch tab
local autoShake = false
local autoShakeConnection

TabFisch:CreateToggle({
    Name = "Auto Shake",
    CurrentValue = false,
    Flag = "AutoShake",
    Callback = function(Value)
        autoShake = Value

        if autoShake then
            autoShakeConnection = game:GetService("RunService").Heartbeat:Connect(function()
                for _, v in pairs(game:GetService("CoreGui"):GetDescendants()) do
                    if v:IsA("TextButton") and (string.find(v.Text:upper(), "SHAKE") or string.find(v.Text:upper(), "SACUDIR")) then
                        pcall(function() v:Activate() end) -- Simulates a safe click
                    end
                end
            end)
        else
            if autoShakeConnection then
                autoShakeConnection:Disconnect()
                autoShakeConnection = nil
            end
        end
    end,
})

-- Object duplication toggle in Fisch tab
local duplicarAtivo = false
local objetoParaDuplicar = nil
local duplicarConnection

TabFisch:CreateToggle({
    Name = "Duplicate Object",
    CurrentValue = false,
    Flag = "Duplicar",
    Callback = function(Value)
        duplicarAtivo = Value

        if duplicarAtivo then
            duplicarConnection = game:GetService("UserInputService").InputBegan:Connect(function(input)
                if duplicarAtivo and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mouse = game.Players.LocalPlayer:GetMouse()
                    local alvo = mouse.Target

                    if alvo and alvo:IsA("BasePart") then
                        objetoParaDuplicar = alvo:Clone()
                        objetoParaDuplicar.Parent = game.Workspace
                        objetoParaDuplicar.Position = alvo.Position + Vector3.new(5, 0, 0)
                    end
                end
            end)
        else
            if duplicarConnection then
                duplicarConnection:Disconnect()
                duplicarConnection = nil
            end
        end
    end,
})

-- Load saved configurations
RayfieldLibrary:LoadConfiguration()
