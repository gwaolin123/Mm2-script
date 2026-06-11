-- Rivals Mobile GUI + ESP + Super Aimbot (Delta Android)
-- Instant lock, infinite range, 360-degree FOV, hitscan precision

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local espEnabled = true
local aimbotEnabled = true
local aimFOV = 360  -- Full 360 degrees
local lockStrength = 1.0  -- Instant lock (no smoothing)

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

-- ESP using TextLabels
local espContainer = Instance.new("Frame")
espContainer.Size = UDim2.new(1, 0, 1, 0)
espContainer.BackgroundTransparency = 1
espContainer.Parent = screenGui

local espLabels = {}

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

local function updateESP()
    for player, label in pairs(espLabels) do
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            label.Visible = false
        else
            local rootPart = player.Character.HumanoidRootPart
            local screenPos, depth = worldToScreen(rootPart.Position)
            if screenPos then
                label.Position = UDim2.new(0, screenPos.X - 50, 0, screenPos.Y - 20)
                label.Text = player.Name .. " | " .. string.format("%.0fm", depth * 3.28)
                label.Visible = espEnabled
            else
                label.Visible = false
            end
        end
    end
end

local function createESP(player)
    if espLabels[player] then return end
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 100, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 0, 0)
    label.TextStrokeTransparency = 0.3
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = espContainer
    espLabels[player] = label
end

-- SUPER AIMBOT: closest player regardless of distance or screen position
local function getClosestPlayerAnywhere()
    local closest = nil
    local closestAngle = math.rad(aimFOV)  -- Convert to radians for 3D angle
    local cameraPos = Camera.CFrame.Position
    local cameraDir = Camera.CFrame.LookVector
    
    for _, player in ipairs(getPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local targetPos = rootPart.Position
            local toTarget = (targetPos - cameraPos).unit
            local angle = math.acos(cameraDir:Dot(toTarget))
            
            -- Check if within FOV (360 degrees means always true)
            local withinFOV = (aimFOV >= 360) or (angle <= math.rad(aimFOV / 2))
            
            if withinFOV then
                if closest == nil or angle < closestAngle then
                    closestAngle = angle
                    closest = player
                end
            end
        end
    end
    return closest
end

-- INSTANT LOCK: no smoothing, immediate snap to target
RunService.RenderStepped:Connect(function()
    -- ESP creation
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESP(player)
        end
    end
    updateESP()
    
    -- SUPER AIMBOT
    if aimbotEnabled then
        local target = getClosestPlayerAnywhere()
        if target and target.Character then
            local aimPart = target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
            if aimPart then
                local targetPos = aimPart.Position
                local currentPos = Camera.CFrame.Position
                -- Direct instant lock
                local newCFrame = CFrame.new(currentPos, targetPos)
                if lockStrength >= 0.99 then
                    Camera.CFrame = newCFrame  -- Instant snap
                else
                    Camera.CFrame = Camera.CFrame:Lerp(newCFrame, lockStrength)
                end
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
