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
    Player = Window:Tab({ Title = "Dalgona", Icon = "user" }),
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
    Title = "Red Light God Mode",
    Default = false,
    Callback = function(state)
        RedLightGodModeEnabled = state
    end
})

Tabs.Main:Button({
    Title = "Teleport to End",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local targetPosition = Vector3.new(-45, 1026, 136.70)
        rootPart.CFrame = CFrame.new(targetPosition)
    end
})


Tabs.Main:Button({
    Title = "Help Player",
    Callback = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        local polygon = {
            Vector2.new(-52, -515),
            Vector2.new(115, -515),
            Vector2.new(115, 84),
            Vector2.new(-216, 84)
        }

        local function isPointInPolygon(point, poly)
            local inside = false
            local j = #poly
            for i = 1, #poly do
                local xi, zi = poly[i].X, poly[i].Y
                local xj, zj = poly[j].X, poly[j].Y
                if ((zi > point.Y) ~= (zj > point.Y)) and
                    (point.X < (xj - xi) * (point.Y - zi) / (zj - zi + 1e-9) + xi) then
                    inside = not inside
                end
                j = i
            end
            return inside
        end

        local function tpTo(cf)
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = cf
            end
        end

        local function fireProximityPrompt(prompt)
            if fireproximityprompt then
                fireproximityprompt(prompt)
            end
        end

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local liveChar = workspace:FindFirstChild("Live") and workspace.Live:FindFirstChild(player.Name)
                local hrp = liveChar and liveChar:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local posXZ = Vector2.new(hrp.Position.X, hrp.Position.Z)
                    if isPointInPolygon(posXZ, polygon) then
                        local prompt = hrp:FindFirstChild("CarryPrompt")
                        if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled then
                            tpTo(hrp.CFrame + Vector3.new(0, 2, 0))
                            task.wait(0.4)
                            fireProximityPrompt(prompt)
                            task.wait(0.7)
                            tpTo(CFrame.new(-46, 1024, 110))
                            break
                        end
                    end
                end
            end
        end
    end
})






local Module = game.ReplicatedStorage.Modules.Games.DalgonaClient

local function CompleteDalgona()
    for _, f in ipairs(getreg()) do
        if typeof(f) == "function" and islclosure(f) then
            if getfenv(f).script == Module then
                if getinfo(f).nups == 73 then
                    setupvalue(f, 31, 9e9)
                    break
                end
            end
        end
    end
end



Tabs.Player:Button({
    Title = "Auto Complete Dalgona",
    Callback = function()
        CompleteDalgona()
    end
})
