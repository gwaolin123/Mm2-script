-- Steal Brainrot Script | Invisible | No Ban Bypass | Auto Lock Base | Auto Steal Highest Value
-- Roblox (Synapse X / Krnl / ScriptWare compatible)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- Anti-Ban / Invisibility
local function makeInvisible()
    local char = player.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                part.CanCollide = false
            end
        end
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.BreakJointsOnDeath = false
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end
    end
end

-- Hook remote events to prevent detection
local oldFireServer = nil
if ReplicatedStorage and ReplicatedStorage.FindFirstChild then
    oldFireServer = debug.getupvalues(ReplicatedStorage.FindFirstChild("FireServer")) or function() end
    hookfunction(oldFireServer, function(...)
        local args = {...}
        for i, v in pairs(args) do
            if type(v) == "string" and (string.find(v, "report") or string.find(v, "ban")) then
                return nil
            end
        end
        return oldFireServer(...)
    end)
end

-- Auto Lock Base (find nearest base and claim it repeatedly)
local function lockNearestBase()
    local bases = workspace:FindFirstChild("Bases") or workspace:FindFirstChild("BaseZones")
    if not bases then return end
    local nearest = nil
    local minDist = math.huge
    local charPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not charPos then return end
    for _, base in ipairs(bases:GetChildren()) do
        if base:IsA("Model") or base:IsA("Part") then
            local pos = base:FindFirstChild("Position") or base:FindFirstChild("Part")
            if pos and pos.Position then
                local dist = (charPos.Position - pos.Position).magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = base
                end
            end
        end
    end
    if nearest then
        local lockRemote = ReplicatedStorage:FindFirstChild("LockBase") or ReplicatedStorage:FindFirstChild("ClaimBase")
        if lockRemote then
            lockRemote:FireServer(nearest)
        end
    end
end

-- Auto Steal Highest (brainrot currency / points)
local function stealHighest()
    local leaderstats = player:FindFirstChild("leaderstats")
    local playersList = Players:GetPlayers()
    local highest = nil
    local maxVal = -math.huge
    for _, other in ipairs(playersList) do
        if other ~= player then
            local stats = other:FindFirstChild("leaderstats")
            if stats then
                local brainrotVal = stats:FindFirstChild("Brainrot") or stats:FindFirstChild("Points") or stats:FindFirstChild("Value")
                if brainrotVal and type(brainrotVal.Value) == "number" and brainrotVal.Value > maxVal then
                    maxVal = brainrotVal.Value
                    highest = other
                end
            end
        end
    end
    if highest then
        local stealRemote = ReplicatedStorage:FindFirstChild("StealBrainrot") or ReplicatedStorage:FindFirstChild("Rob")
        if stealRemote then
            stealRemote:FireServer(highest)
        end
    end
end

-- Loop for auto lock and auto steal
spawn(function()
    while true do
        wait(0.5)
        if player.Character then
            makeInvisible()
            lockNearestBase()
            stealHighest()
        end
    end
end)

-- Bypass kick/ban checks (simulate normal client behavior)
local oldKick = game.Kick
game.Kick = function(...)
    -- block kick
    return nil
end

local oldBan = game:GetService("Players").LocalPlayer.Kick
if oldBan then
    player.Kick = function(...) return nil end
end

-- Hide from server logs (fake ping and stats)
local oldStats = game:GetService("Stats").Network
if oldStats then
    hookfunction(oldStats.GetAveragePing, function() return 50 end)
end

print("Brainrot Stealer Active | Invisible | Anti-Ban | Auto Lock Base | Auto Steal Highest")
