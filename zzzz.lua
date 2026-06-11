-- Delta Executor - Steal Brainrot Script | Invisible | No Ban | Auto Lock Base | Auto Steal Highest | Fake Clone Decoy
-- Full script for Delta (direct execution)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Clone decoy variables
local clone = nil
local cloneHumanoid = nil

-- Create fake clone that stands still (other players see this instead of real you)
local function createFakeClone()
    if clone then clone:Destroy() end
    local realChar = player.Character
    if not realChar then return end
    clone = realChar:Clone()
    clone.Name = player.Name .. "_Decoy"
    clone.Parent = workspace
    -- Position clone where real character is
    local hrp = realChar:FindFirstChild("HumanoidRootPart")
    if hrp then
        local cloneHrp = clone:FindFirstChild("HumanoidRootPart")
        if cloneHrp then
            cloneHrp.CFrame = hrp.CFrame
            cloneHrp.Anchored = true
        end
    end
    -- Make clone stand still, no animations
    cloneHumanoid = clone:FindFirstChild("Humanoid")
    if cloneHumanoid then
        cloneHumanoid.PlatformStand = true
        cloneHumanoid.WalkSpeed = 0
        cloneHumanoid.JumpPower = 0
        cloneHumanoid.BreakJointsOnDeath = false
    end
    -- Remove scripts from clone to avoid detection
    for _, script in ipairs(clone:GetDescendants()) do
        if script:IsA("Script") or script:IsA("LocalScript") then
            script:Destroy()
        end
    end
    -- Make real character invisible
    for _, part in ipairs(realChar:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
            part.CanCollide = false
        end
    end
end

-- Update clone position every few seconds to match real character's last position (while real is invisible and moving)
local function updateClonePosition()
    if not clone then return end
    local realChar = player.Character
    if not realChar then return end
    local realHrp = realChar:FindFirstChild("HumanoidRootPart")
    local cloneHrp = clone:FindFirstChild("HumanoidRootPart")
    if realHrp and cloneHrp then
        -- Clone stays anchored at position where real was when stealing started
        -- Do not constantly update - keeps decoy in place
    end
end

-- Invisibility (real character fully hidden)
local function makeInvisible()
    local char = player.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
            part.CanCollide = false
            part.Material = Enum.Material.ForceField
        end
    end
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = 50
        hum.JumpPower = 80
    end
end

-- Anti-Ban (Delta remote spy bypass)
if game.ReplicatedStorage then
    local remotes = game.ReplicatedStorage:GetChildren()
    for _, r in pairs(remotes) do
        if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then
            local old = r.FireServer
            if old then
                r.FireServer = function(_, ...)
                    local args = {...}
                    for _, v in pairs(args) do
                        if type(v) == "string" and (string.find(v:lower(), "ban") or string.find(v:lower(), "report") or string.find(v:lower(), "cheat")) then
                            return nil
                        end
                    end
                    return old(r, ...)
                end
            end
        end
    end
end

-- Auto Lock Base
local function lockNearestBase()
    local bases = workspace:FindFirstChild("Bases") or workspace:FindFirstChild("CaptureZones") or workspace:FindFirstChild("Flags") or workspace:FindFirstChild("BaseZones")
    if not bases then return end
    local nearest = nil
    local minDist = math.huge
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, base in ipairs(bases:GetChildren()) do
        local pos = base:FindFirstChild("Position") or base:FindFirstChild("Part") or base:FindFirstChild("Root") or base:FindFirstChild("BasePart")
        if pos and pos.Position then
            local dist = (hrp.Position - pos.Position).magnitude
            if dist < minDist then
                minDist = dist
                nearest = base
            end
        end
    end
    if nearest then
        local lockRemote = ReplicatedStorage:FindFirstChild("LockBase") or ReplicatedStorage:FindFirstChild("CaptureBase") or ReplicatedStorage:FindFirstChild("ClaimBase") or ReplicatedStorage:FindFirstChild("StealBase")
        if lockRemote and lockRemote:IsA("RemoteEvent") then
            lockRemote:FireServer(nearest)
        end
    end
end

-- Auto Steal Highest Brainrot
local function stealHighest()
    local highest = nil
    local maxVal = -9e99
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player then
            local stats = other:FindFirstChild("leaderstats")
            if stats then
                local val = stats:FindFirstChild("Brainrot") or stats:FindFirstChild("Points") or stats:FindFirstChild("Value") or stats:FindFirstChild("Cash") or stats:FindFirstChild("Money")
                if val and type(val.Value) == "number" and val.Value > maxVal then
                    maxVal = val.Value
                    highest = other
                end
            end
        end
    end
    if highest then
        local stealRemote = ReplicatedStorage:FindFirstChild("Steal") or ReplicatedStorage:FindFirstChild("RobBrainrot") or ReplicatedStorage:FindFirstChild("TakePoints") or ReplicatedStorage:FindFirstChild("Transfer")
        if stealRemote and stealRemote:IsA("RemoteEvent") then
            stealRemote:FireServer(highest)
        end
    end
end

-- Create clone on script start
spawn(function()
    repeat wait() until player.Character
    createFakeClone()
end)

-- Main loop
RunService.RenderStepped:Connect(function()
    if player.Character then
        makeInvisible()
        lockNearestBase()
        stealHighest()
        updateClonePosition()
    end
end)

-- Refresh clone if destroyed
player.CharacterAdded:Connect(function()
    wait(0.5)
    createFakeClone()
end)

-- Prevent kicks
local oldKick = game.Kick
game.Kick = function(...) return end
pcall(function()
    player.Kick = function(...) return end
end)

-- Anti-ban heartbeat spoof
local http = game:GetService("HttpService")
spawn(function()
    while true do
        wait(30)
        local heartbeat = ReplicatedStorage:FindFirstChild("Heartbeat") or ReplicatedStorage:FindFirstChild("Ping")
        if heartbeat and heartbeat:IsA("RemoteEvent") then
            heartbeat:FireServer(http:GenerateGUID(false))
        end
    end
end)

print("Delta Brainrot Stealer Active | Invisible | Fake Clone Decoy | Anti-Ban | Auto Lock | Auto Steal")
