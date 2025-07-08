local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

getgenv().Toggles = getgenv().Toggles or {}
getgenv().Options = getgenv().Options or {}

local Window = WindUI:CreateWindow({
    Folder = "Ringta Scripts",
    Title = "RINGTA",
    Icon = "star",
    Author = "discord.gg/ringta",
    Theme = "Indigo",
    Size = UDim2.fromOffset(500, 350),
    Transparent = true,
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
    Main = Window:Tab({ Title = "Main", Icon = "house" }),
    Player = Window:Tab({ Title = "Player", Icon = "user" }),
    Mingle = Window:Tab({ Title = "Mingle", Icon = "users" }),
    Credits = Window:Tab({ Title = "Credits", Icon = "award" }),
}

Tabs.Main:Section({ Title = "Game Features" })
Tabs.Main:Toggle({
    Title = "Red Light God Mode",
    Value = getgenv().Toggles.RedLightGodMode or false,
    Callback = function(state)
        getgenv().Toggles.RedLightGodMode = state
    end
})
Tabs.Main:Toggle({
    Title = "Glass Bridge ESP",
    Value = getgenv().Toggles.GlassBridgeESP or false,
    Callback = function(state)
        getgenv().Toggles.GlassBridgeESP = state
    end
})
Tabs.Main:Toggle({
    Title = "Tug of War Auto Pull",
    Value = getgenv().Toggles.TugOfWarAuto or false,
    Callback = function(state)
        getgenv().Toggles.TugOfWarAuto = state
    end
})
Tabs.Main:Toggle({
    Title = "Dalgona Auto Complete",
    Value = getgenv().Toggles.DalgonaAuto or false,
    Callback = function(state)
        getgenv().Toggles.DalgonaAuto = state
    end
})

Tabs.Player:Section({ Title = "Player Modifications" })
Tabs.Player:Toggle({
    Title = "Enable WalkSpeed",
    Value = getgenv().Toggles.EnableWalkSpeed or false,
    Callback = function(state)
        getgenv().Toggles.EnableWalkSpeed = state
    end
})
Tabs.Player:Slider({
    Title = "Walk Speed",
    Min = 1,
    Max = 100,
    Value = getgenv().Options.WalkSpeed or 16,
    Callback = function(val)
        getgenv().Options.WalkSpeed = val
    end
})
Tabs.Player:Toggle({
    Title = "Noclip",
    Value = getgenv().Toggles.Noclip or false,
    Callback = function(state)
        getgenv().Toggles.Noclip = state
    end
})

Tabs.Mingle:Section({ Title = "Mingle Features" })
Tabs.Mingle:Toggle({
    Title = "Power Hold Auto",
    Value = getgenv().Toggles.MinglePowerHoldAuto or false,
    Callback = function(state)
        getgenv().Toggles.MinglePowerHoldAuto = state
    end
})

Tabs.Credits:Section({ Title = "Credits" })

Tabs.Credits:Button({
    Title = "Script",
    Icon = "award",
    Callback = function() end
})

local RedLightGreenLight = {}
RedLightGreenLight.__index = RedLightGreenLight
function RedLightGreenLight.new()
    local self = setmetatable({}, RedLightGreenLight)
    self._IsGreenLight = nil
    self._LastRootPartCFrame = nil
    return self
end
function RedLightGreenLight:Start()
    local Client = LocalPlayer
    local TrafficLightImage = Client.PlayerGui:WaitForChild("ImpactFrames"):WaitForChild("TrafficLightEmpty")
    self._IsGreenLight = TrafficLightImage.Image == ReplicatedStorage.Effects.Images.TrafficLights.GreenLight.Image
    local RootPart = Client.Character and Client.Character:FindFirstChild("HumanoidRootPart")
    self._LastRootPartCFrame = RootPart and RootPart.CFrame
    self._EffectsConn = ReplicatedStorage.Remotes.Effects.OnClientEvent:Connect(function(EffectsData)
        if EffectsData.EffectName ~= "TrafficLight" then return end
        self._IsGreenLight = EffectsData.GreenLight == true
        local RootPart = Client.Character and Client.Character:FindFirstChild("HumanoidRootPart")
        self._LastRootPartCFrame = RootPart and RootPart.CFrame
    end)
    self._OriginalNamecall = hookfunction(getrawmetatable(game).__namecall, newcclosure(function(Instance, ...)
        local Args = {...}
        if getnamecallmethod() == "FireServer" and Instance.ClassName == "RemoteEvent" and Instance.Name == "rootCFrame" then
            if getgenv().Toggles.RedLightGodMode and self._IsGreenLight == false and self._LastRootPartCFrame then
                Args[1] = self._LastRootPartCFrame
                return self._OriginalNamecall(Instance, unpack(Args))
            end
        end
        return self._OriginalNamecall(Instance, ...)
    end))
end
function RedLightGreenLight:Destroy()
    if self._EffectsConn then self._EffectsConn:Disconnect() end
    if self._OriginalNamecall then
        hookfunction(getrawmetatable(game).__namecall, self._OriginalNamecall)
    end
end

local Dalgona = {}
Dalgona.__index = Dalgona
function Dalgona.new()
    local self = setmetatable({}, Dalgona)
    return self
end
function Dalgona:Start()
    local DalgonaClientModule = game.ReplicatedStorage.Modules.Games.DalgonaClient
    local function CompleteDalgona()
        if not getgenv().Toggles.DalgonaAuto then return end
        for _, Value in ipairs(getreg()) do
            if typeof(Value) == "function" and islclosure(Value) then
                if getfenv(Value).script == DalgonaClientModule then
                    if getinfo(Value).nups == 54 then
                        setupvalue(Value, 15, 9e9)
                        break
                    end
                end
            end
        end
    end
    self._OriginalDalgonaFunction = hookfunction(require(DalgonaClientModule), function(...)
        task.delay(3, CompleteDalgona)
        return self._OriginalDalgonaFunction(...)
    end)
    self._DalgonaAutoConn = RunService.Heartbeat:Connect(function()
        if getgenv().Toggles.DalgonaAuto then
            CompleteDalgona()
        end
    end)
end
function Dalgona:Destroy()
    if self._DalgonaAutoConn then self._DalgonaAutoConn:Disconnect() end
    if self._OriginalDalgonaFunction then
        hookfunction(require(game.ReplicatedStorage.Modules.Games.DalgonaClient), self._OriginalDalgonaFunction)
    end
end

local TugOfWar = {}
TugOfWar.__index = TugOfWar
function TugOfWar.new()
    local self = setmetatable({}, TugOfWar)
    return self
end
function TugOfWar:Start()
    local TemporaryReachedBindableRemote = ReplicatedStorage.Remotes.TemporaryReachedBindable
    local PULL_RATE = 0.025
    local VALID_PULL_DATA = { ["QTEGood"] = true }
    self._TugTask = task.spawn(function()
        while task.wait(PULL_RATE) do
            if getgenv().Toggles.TugOfWarAuto then
                TemporaryReachedBindableRemote:FireServer(VALID_PULL_DATA)
            end
        end
    end)
end
function TugOfWar:Destroy()
    if self._TugTask then
        task.cancel(self._TugTask)
    end
end

local GlassBridge = {}
GlassBridge.__index = GlassBridge
function GlassBridge.new()
    local self = setmetatable({}, GlassBridge)
    return self
end
function GlassBridge:Start()
    local GlassHolder = workspace.GlassBridge.GlassHolder
    local function SetupGlassPart(GlassPart)
        local CanEnableGlassBridgeESP = getgenv().Toggles.GlassBridgeESP
        if not CanEnableGlassBridgeESP then
            GlassPart.Color = Color3.fromRGB(106, 106, 106)
            GlassPart.Transparency = 0.45
            GlassPart.Material = Enum.Material.SmoothPlastic
        else
            local Color = GlassPart:GetAttribute("exploitingisevil") and Color3.fromRGB(248, 87, 87) or Color3.fromRGB(28, 235, 87)
            GlassPart.Color = Color
            GlassPart.Transparency = 0
            GlassPart.Material = Enum.Material.Neon
        end
    end
    self._GlassAddedConn = GlassHolder.DescendantAdded:Connect(function(Descendant)
        if Descendant.Name == "glasspart" and Descendant:IsA("BasePart") then
            task.defer(SetupGlassPart, Descendant)
        end
    end)
    self._GlassRefreshConn = RunService.Heartbeat:Connect(function()
        if getgenv().Toggles.GlassBridgeESP then
            for _, PanelPair in ipairs(GlassHolder:GetChildren()) do
                for _, Panel in ipairs(PanelPair:GetChildren()) do
                    local GlassPart = Panel:FindFirstChild("glasspart")
                    if GlassPart then
                        task.defer(SetupGlassPart, GlassPart)
                    end
                end
            end
        end
    end)
end
function GlassBridge:Destroy()
    if self._GlassAddedConn then self._GlassAddedConn:Disconnect() end
    if self._GlassRefreshConn then self._GlassRefreshConn:Disconnect() end
end

local PlayerMods = {}
PlayerMods.__index = PlayerMods
function PlayerMods.new()
    local self = setmetatable({}, PlayerMods)
    return self
end
function PlayerMods:Start()
    self._WalkConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            if getgenv().Toggles.EnableWalkSpeed then
                hum.WalkSpeed = getgenv().Options.WalkSpeed or 16
            end
        end
    end)
    self._NoclipConn = RunService.Stepped:Connect(function()
        if getgenv().Toggles.Noclip then
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end
function PlayerMods:Destroy()
    if self._WalkConn then self._WalkConn:Disconnect() end
    if self._NoclipConn then self._NoclipConn:Disconnect() end
end

local Mingle = {}
Mingle.__index = Mingle
function Mingle.new()
    local self = setmetatable({}, Mingle)
    return self
end
function Mingle:Start()
    local Client = LocalPlayer
    local function OnCharacterAdded(Character)
        local function OnRemoteForQTEAdded(RemoteForQTE)
            local running = true
            task.spawn(function()
                while task.wait(0.5) do
                    if not RemoteForQTE or not RemoteForQTE.Parent then break end
                    if getgenv().Toggles and getgenv().Toggles.MinglePowerHoldAuto then
                        RemoteForQTE:FireServer()
                    end
                end
            end)
        end
        local function OnChildAdded(Object)
            if Object.ClassName == "RemoteEvent" and Object.Name == "RemoteForQTE" then
                OnRemoteForQTEAdded(Object)
            end
        end
        Character.ChildAdded:Connect(OnChildAdded)
        for _, Object in ipairs(Character:GetChildren()) do
            task.spawn(OnChildAdded, Object)
        end
    end
    LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
    if LocalPlayer.Character then
        task.spawn(OnCharacterAdded, LocalPlayer.Character)
    end
end
function Mingle:Destroy()
end

local GameState = workspace:WaitForChild("Values")
local Features = {
    ["RedLightGreenLight"] = RedLightGreenLight,
    ["Dalgona"] = Dalgona,
    ["TugOfWar"] = TugOfWar,
    ["GlassBridge"] = GlassBridge,
    ["Mingle"] = Mingle,
}
local CurrentRunningFeature = nil
local PlayerModsInstance = PlayerMods.new()
PlayerModsInstance:Start()
local MingleInstance = Mingle.new()
MingleInstance:Start()
local function CleanupCurrentFeature()
    if CurrentRunningFeature then
        CurrentRunningFeature:Destroy()
        CurrentRunningFeature = nil
    end
end
local function CurrentGameChanged()
    CleanupCurrentFeature()
    local Feature = Features[GameState.CurrentGame.Value]
    if not Feature then return end
    CurrentRunningFeature = Feature.new()
    CurrentRunningFeature:Start()
end
GameState.CurrentGame:GetPropertyChangedSignal("Value"):Connect(CurrentGameChanged)
CurrentGameChanged()
