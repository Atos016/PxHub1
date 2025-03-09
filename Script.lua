--// Load Rayfield Library
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()
local Window = Rayfield:CreateWindow({
    Name = "PxHub",
    LoadingTitle = "Loading PxHub...",
    LoadingSubtitle = "by Project X",
    ConfigurationSaving = { Enabled = false }
})

--// Variables
local noclip = false
local infJump = false

--// NoClip Function
function toggleNoClip()
    noclip = not noclip
    game:GetService("RunService").Stepped:Connect(function()
        if noclip then
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

--// Infinite Jump Function
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

--// Create Tabs
local MainTab = Window:CreateTab("Main", 4483362458)

--// Buttons
MainTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Callback = function(state)
        noclip = state
        toggleNoClip()
    end
})

MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(state)
        infJump = state
    end
})

MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 500},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(value)
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
    end
})
