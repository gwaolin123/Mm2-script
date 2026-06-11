-- Auto Treasure Bot for Roblox (Delta Executor)
-- Insta-collect, auto-pathfind, anti-AFK

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Settings
local TREASURE_DISTANCE = 15
local COLLECT_DELAY = 0.1
local RAYCAST_DISTANCE = 10
local ROTATION_SPEED = 2

-- State
local running = true
local currentTarget = nil
local botActive = true

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 80)
frame.Position = UDim2.new(0, 10, 0, 50)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BackgroundTransparency = 0.3
frame.Parent = screenGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 130, 0, 35)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "BOT: ON"
toggleBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 130, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 55)
statusLabel.Text = "Idle"
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.new(1, 1, 0)
statusLabel.Parent = frame

-- Drag
local dragging = false
local dragStart, frameStart
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        frameStart = frame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    botActive = not botActive
    toggleBtn.Text = botActive and "BOT: ON" or "BOT: OFF"
    statusLabel.Text = botActive and "Active" : "Stopped"
end)

-- Find nearest treasure (works with common collectible names)
local function findNearestTreasure()
    local nearest = nil
    local shortestDist = math.huge
    
    -- Common treasure object names
    local treasureNames = {"Treasure", "Chest", "Gem", "Coin", "Gold", "Reward", "Collectible", "Pickup", "Star", "Diamond"}
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            local name = obj.Name:lower()
            local isTreasure = false
            for _, tName in ipairs(treasureNames) do
                if name:find(tName:lower()) then
                    isTreasure = true
                    break
                end
            end
            if isTreasure and obj.Parent ~= Character then
                local dist = (obj.Position - RootPart.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    nearest = obj
                end
            end
        end
    end
    return nearest, shortestDist
end

-- Move toward target
local function moveTo(position)
    local direction = (position - RootPart.Position).Unit
    local lookCFrame = CFrame.new(RootPart.Position, position)
    RootPart.CFrame = RootPart.CFrame:Lerp(lookCFrame, 0.3)
    
    -- Move forward
    Humanoid:MoveTo(position)
end

-- Obstacle avoidance raycast
local function checkObstacle()
    local origin = RootPart.Position
    local direction = RootPart.CFrame.LookVector
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local result = workspace:Raycast(origin, direction * RAYCAST_DISTANCE, raycastParams)
    if result then
        -- Turn right to avoid
        RootPart.CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
        return true
    end
    return false
end

-- Anti-AFK: random mouse movement
local lastMoveTime = tick()
local function antiAFK()
    if tick() - lastMoveTime > 45 then
        mousemoverel(math.random(-15, 15), math.random(-10, 10))
        lastMoveTime = tick()
    end
end

-- Collect treasure
local function collect(treasure)
    if not treasure then return end
    local dist = (treasure.Position - RootPart.Position).Magnitude
    if dist <= TREASURE_DISTANCE then
        -- Simulate click on treasure
        local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(treasure.Position)
        if onScreen then
            mousemoveabs(screenPos.X, screenPos.Y)
            task.wait(0.05)
            mouseclick1()
            statusLabel.Text = "Collecting..."
            task.wait(COLLECT_DELAY)
        end
    end
end

-- Main loop
coroutine.wrap(function()
    while running do
        if botActive and Humanoid and Humanoid.Health > 0 then
            local treasure, dist = findNearestTreasure()
            if treasure then
                currentTarget = treasure
                statusLabel.Text = "Moving to treasure: " .. string.format("%.1f", dist) .. "m"
                moveTo(treasure.Position)
                checkObstacle()
                collect(treasure)
            else
                statusLabel.Text = "No treasure nearby"
                -- Random wander
                local wanderPos = RootPart.Position + Vector3.new(math.random(-30, 30), 0, math.random(-30, 30))
                Humanoid:MoveTo(wanderPos)
            end
            antiAFK()
        end
        task.wait(0.1)
    end
end)()

-- Cleanup on death
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
end)

-- Stop bot on script end
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function()
    running = false
end)
