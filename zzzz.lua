-- Rivals Mobile ESP + Aimbot (Delta Android)
-- Uses ScreenGui, touch injection, and CFrame aiming

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local espEnabled = true
local aimbotEnabled = true
local aimFOV = 120
local smoothness = 0.2

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui
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
                label.Text = player.Name .. " | " .. string.format("%dm", math.floor(depth * 3.28))
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

local function getClosestPlayer()
    local closest = nil
    local closestDistance = aimFOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, player in ipairs(getPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local screenPos = worldToScreen(rootPart.Position)
            if screenPos then
                local screenDist = (screenPos - center).Magnitude
                if screenDist < closestDistance then
                    closestDistance = screenDist
                    closest = player
                end
            end
        end
    end
    return closest
end

-- Aimbot via CFrame (no mouse required)
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESP(player)
        end
    end
    updateESP()
    if aimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = target.Character.HumanoidRootPart
            local lookAt = CFrame.new(Camera.CFrame.Position, rootPart.Position)
            Camera.CFrame = Camera.CFrame:Lerp(lookAt, smoothness)
        end
    end
end)

-- Toggle controls (tap on screen edges or use volume buttons if supported)
UserInputService.TouchTap:Connect(function(touch)
    if touch.Position.X < 100 then
        espEnabled = not espEnabled
    elseif touch.Position.X > Camera.ViewportSize.X - 100 then
        aimbotEnabled = not aimbotEnabled
    end
end)

-- Initialize
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end
