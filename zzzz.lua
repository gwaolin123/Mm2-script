-- Slap Tower script for Roblox (Pastebin ready)
-- Use at your own risk

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Config
local SLAP_COOLDOWN = 0.5
local SLAP_RANGE = 10
local TOWER_RADIUS = 30
local TOWER_HEIGHT = 50
local towerParts = {}
local lastSlap = 0

-- Create tower base
function createTower()
    local base = Instance.new("Part")
    base.Size = Vector3.new(TOWER_RADIUS * 2, 1, TOWER_RADIUS * 2)
    base.Position = player.Character.HumanoidRootPart.Position - Vector3.new(0, 2, 0)
    base.Anchored = true
    base.BrickColor = BrickColor.new("Gray")
    base.Parent = game.Workspace
    table.insert(towerParts, base)

    for i = 1, TOWER_HEIGHT do
        local pillar = Instance.new("Part")
        pillar.Size = Vector3.new(2, 1, 2)
        pillar.Position = base.Position + Vector3.new(0, i, 0)
        pillar.Anchored = true
        pillar.BrickColor = BrickColor.new("Bright red")
        pillar.Parent = game.Workspace
        table.insert(towerParts, pillar)
    end
end

-- Slap nearest player
function slapNearest()
    if tick() - lastSlap < SLAP_COOLDOWN then return end
    local nearest = nil
    local minDist = SLAP_RANGE
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (other.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude
            if dist < minDist then
                nearest = other
                minDist = dist
            end
        end
    end
    if nearest and nearest.Character and nearest.Character:FindFirstChild("Humanoid") then
        local humanoid = nearest.Character.Humanoid
        humanoid:TakeDamage(15)
        -- Apply knockback
        local dir = (nearest.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).unit
        nearest.Character.HumanoidRootPart.Velocity = dir * 40 + Vector3.new(0, 20, 0)
        lastSlap = tick()
    end
end

-- Auto-slap on F key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        slapNearest()
    end
end)

-- Auto-loop slapping (optional, toggle with G)
local autoSlap = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        autoSlap = not autoSlap
        print("AutoSlap: " .. tostring(autoSlap))
    end
end)

RunService.RenderStepped:Connect(function()
    if autoSlap then
        slapNearest()
    end
end)

-- Build tower when script runs
spawn(function()
    repeat wait() until player.Character
    createTower()
end)
