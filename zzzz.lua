-- Rivals Mobile GUI + ESP Box/Health + Smooth Aimbot (Delta Android)
-- ESP: Box + Health bar only (no names)
-- Aimbot: Camera + weapon alignment using mouse movement simulation

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local espEnabled = true
local aimbotEnabled = true
local aimFOV = 360
local smoothness = 0.12  -- Smooth but strong tracking

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 150, 0, 100)
mainFrame.Position = UDim2.new(0, 10, 0, 50)
mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 1
mainFrame.Parent = screenGui

local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0, 130, 0, 35)
espButton.Position = UDim2.new(0, 10, 0, 10)
espButton.Text = "ESP: ON"
espButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
espButton.TextColor3 = Color3.new(1, 1, 1)
espButton.Parent = mainFrame

local aimButton = Instance.new("TextButton")
aimButton.Size = UDim2.new(0, 130, 0, 35)
aimButton.Position = UDim2.new(0, 10, 0, 55)
aimButton.Text = "AIMBOT: ON"
aimButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
aimButton.TextColor3 = Color3.new(1, 1, 1)
aimButton.Parent = mainFrame

-- Drag functionality
local dragging = false
local dragStart
local frameStart

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        frameStart = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
end)

aimButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimButton.Text = aimbotEnabled and "AIMBOT: ON" or "AIMBOT: OFF"
end)

-- ESP: Box + Health Bar (no names)
local espContainer = Instance.new("Frame")
espContainer.Size = UDim2.new(1, 0, 1, 0)
espContainer.BackgroundTransparency = 1
espContainer.Parent = screenGui

local espBoxes = {}
local espHealthBars = {}

local function getPlayers()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(list, plr)
        end
    end
    return list
end

local function worldToScreen(position)
    local vector, onScreen = Camera:WorldToViewportPoint(position)
    if onScreen then
        return Vector2.new(vector.X, vector.Y), vector.Z
    end
    return nil, nil
end

local function getPlayerHealth(player)
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        return humanoid.Health, humanoid.MaxHealth
    end
    return 0, 100
end

local function updateESP()
    for player, box in pairs(espBoxes) do
        local healthBar = espHealthBars[player]
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            box.Visible = false
            healthBar.Visible = false
        else
            local rootPart = player.Character.HumanoidRootPart
            local screenPos, depth = worldToScreen(rootPart.Position)
            if screenPos then
                local distance = depth * 3.28
                local boxSize = 100 / distance * 4
                local boxWidth = boxSize
                local boxHeight = boxSize * 1.5
                local boxPos = Vector2.new(screenPos.X - boxWidth/2, screenPos.Y - boxHeight/2)
                
                -- Box
                box.Position = UDim2.new(0, boxPos.X, 0, boxPos.Y)
                box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
                box.Visible = espEnabled
                
                -- Health
                local health, maxHealth = getPlayerHealth(player)
                local healthPercent = math.clamp(health / maxHealth, 0, 1)
                local healthHeight = boxHeight * healthPercent
                healthBar.Size = UDim2.new(0, 4, 0, healthHeight)
                healthBar.Position = UDim2.new(0, boxPos.X - 6, 0, boxPos.Y + boxHeight - healthHeight)
                healthBar.Visible = espEnabled
                healthBar.BackgroundColor3 = Color3.new(1 - healthPercent, healthPercent, 0)
            else
                box.Visible = false
                healthBar.Visible = false
            end
        end
    end
end

local function createESP(player)
    if espBoxes[player] then return end
    
    local box = Instance.new("Frame")
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 2
    box.BorderColor3 = Color3.new(1, 0, 0)
    box.Parent = espContainer
    
    local healthBar = Instance.new("Frame")
    healthBar.BackgroundColor3 = Color3.new(0, 1, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = espContainer
    
    espBoxes[player] = box
    espHealthBars[player] = healthBar
end

-- AIMBOT: Smooth camera + simulated weapon alignment
local function getClosestPlayerAnywhere()
    local closest = nil
    local closestAngle = math.huge
    local cameraPos = Camera.CFrame.Position
    local cameraDir = Camera.CFrame.LookVector
    
    for _, player in ipairs(getPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local targetPos = rootPart.Position
            local toTarget = (targetPos - cameraPos).unit
            local angle = math.acos(cameraDir:Dot(toTarget))
            
            if angle < closestAngle then
                closestAngle = angle
                closest = player
            end
        end
    end
    return closest
end

-- Mouse movement simulation for weapon alignment
local function moveMouseToTarget(targetPos)
    local targetScreen, onScreen = Camera:WorldToViewportPoint(targetPos)
    if not onScreen then return end
    
    local currentMouse = UserInputService:GetMouseLocation()
    local deltaX = targetScreen.X - currentMouse.X
    local deltaY = targetScreen.Y - currentMouse.Y
    
    -- Apply smooth movement
    mousemoverel(deltaX * smoothness, deltaY * smoothness)
end

RunService.RenderStepped:Connect(function()
    -- ESP creation and update
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESP(player)
        end
    end
    updateESP()
    
    -- SMOOTH AIMBOT (camera + weapon)
    if aimbotEnabled then
        local target = getClosestPlayerAnywhere()
        if target and target.Character then
            local aimPart = target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
            if aimPart then
                local targetPos = aimPart.Position
                local currentPos = Camera.CFrame.Position
                
                -- Smooth camera movement
                local newCFrame = CFrame.new(currentPos, targetPos)
                Camera.CFrame = Camera.CFrame:Lerp(newCFrame, smoothness * 2)
                
                -- Move mouse for weapon alignment (critical for killing)
                moveMouseToTarget(targetPos)
            end
        end
    end
end)

-- Initialize
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end
