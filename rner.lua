local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer


local Window = WindUI:CreateWindow({
    Folder = "Ringta Scripts",
    Title = "RINGTA",
    Icon = "star",
    Author = "discord.gg/ringta",
    Theme = "Dark",
    Size = UDim2.fromOffset(500, 350),
    Transparent = false,
    HasOutline = true,
})

Window:EditOpenButton({
    Title = "Open RINGTA SCRIPTS",
    Icon = "pointer",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(200, 0, 255), Color3.fromRGB(0, 200, 255)),
    Draggable = true,
})

local Tabs = {
    Main = Window:Tab({ Title = "RedLight", Icon = "house" }),
    Player = Window:Tab({ Title = "Player", Icon = "user" }),
    Mingle = Window:Tab({ Title = "Mingle", Icon = "users" }),
    Credits = Window:Tab({ Title = "Credits", Icon = "award" }),
}

local RedLightGodModeEnabled = false -- Default: off

local IsGreenLight = true
local LastRootPartCFrame = nil

ReplicatedStorage.Remotes.Effects.OnClientEvent:Connect(function(EffectsData)
    if EffectsData.EffectName ~= "TrafficLight" then return end
    IsGreenLight = EffectsData.GreenLight == true
    local RootPart = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    LastRootPartCFrame = RootPart and RootPart.CFrame
end)

local OriginalNamecall
OriginalNamecall = hookfunction(getrawmetatable(game).__namecall, newcclosure(function(self, ...)
    local args = {...}
    if getnamecallmethod() == "FireServer" and self.ClassName == "RemoteEvent" and self.Name == "rootCFrame" then
        if RedLightGodModeEnabled and not IsGreenLight and LastRootPartCFrame then
            args[1] = LastRootPartCFrame
            return OriginalNamecall(self, unpack(args))
        end
    end
    return OriginalNamecall(self, ...)
end))

Tabs.Main:Toggle({
    Text = "Red Light God Mode",
    Default = false,
    Callback = function(state)
        RedLightGodModeEnabled = state
    end
})

Tabs.Main:Button({
    Text = "Teleport to End",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local targetPosition = Vector3.new(-55.1, 1023.1, -527.6)
        rootPart.CFrame = CFrame.new(targetPosition)
    end
})
