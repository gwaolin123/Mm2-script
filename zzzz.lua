-- Auto Treasure Bot with GUI Menu (Delta Android)
-- Insta-collect, auto-pathfind, anti-AFK, full menu

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Settings
local TREASURE_DISTANCE = 15
local COLLECT_DELAY = 0.1
local RAYCAST_DISTANCE = 10
local botActive = true

-- Create FULL MENU GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TreasureBotMenu"
screenGui.Parent = game.CoreGui

-- Main Menu Frame
local mainMenu = Instance.new("Frame")
mainMenu.Size = UDim2.new(0, 250, 0, 320)
mainMenu.Position = UDim2.new(0.5, -125, 0.5, -160)
mainMenu.BackgroundColor3 = Color3.new(0.05, 0.05, 0.1)
mainMenu.BackgroundTransparency = 0.15
mainMenu.BorderSizePixel = 2
mainMenu.BorderColor3 = Color3.new(0.3, 0.8, 1)
mainMenu.ClipsDescendants = true
mainMenu.Parent = screenGui

-- Title Bar (for dragging)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainMenu

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.Text = "🤖 TREASURE BOT v2.0"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14
titleText.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 0, 0)
closeBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

-- Status Display
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(0, 230, 0, 50)
statusFrame.Position = UDim2.new(0.5, -115, 0, 40)
statusFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
statusFrame.BorderSizePixel = 1
statusFrame.Parent = mainMenu

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0.6, 0)
statusLabel.Position = UDim2.new(0, 0, 0, 5)
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.new(1, 1, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 12
statusLabel.Parent = statusFrame

local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, 0, 0.4, 0)
targetLabel.Position = UDim2.new(0, 0, 0.6, 0)
targetLabel.Text = "Target: None"
targetLabel.TextColor3 = Color3.new(0.7, 0.7, 0.7)
targetLabel.BackgroundTransparency = 1
targetLabel.Font = Enum.Font.Gotham
targetLabel.TextSize = 11
targetLabel.Parent = statusFrame

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 200, 0, 45)
toggleBtn.Position = UDim2.new(0.5, -100, 0, 105)
toggleBtn.Text = "▶ START BOT"
toggleBtn.TextColor3 = Color3.new(0, 1, 0)
toggleBtn.BackgroundColor3 = Color3.new(0.1, 0.3, 0.1)
toggleBtn.BorderSizePixel = 1
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
toggleBtn.Parent = mainMenu

-- Settings Section
local settingsFrame = Instance.new("Frame")
settingsFrame.Size = UDim2.new(0, 230, 0, 100)
settingsFrame.Position = UDim2.new(0.5, -115, 0, 165)
settingsFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
settingsFrame.BorderSizePixel = 1
settingsFrame.Parent = mainMenu

local distLabel = Instance.new("TextLabel")
distLabel.Size = UDim2.new(0, 100, 0, 20)
distLabel.Position = UDim2.new(0, 10, 0, 10)
distLabel.Text = "Collect Range:"
distLabel.TextColor3 = Color3.new(1, 1, 1)
distLabel.BackgroundTransparency = 1
distLabel.TextSize = 11
distLabel.Parent = settingsFrame

local distSlider = Instance.new("TextButton")
distSlider.Size = UDim2.new(0, 100, 0, 20)
distSlider.Position = UDim2.new(0, 120, 0, 10)
distSlider.Text = "15"
distSlider.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
distSlider.Parent = settingsFrame

local wanderLabel = Instance.new("TextLabel")
wanderLabel.Size = UDim2.new(0, 150, 0, 20)
wanderLabel.Position = UDim2.new(0, 10, 0, 40)
wanderLabel.Text = "Wander Distance: 30"
wanderLabel.TextColor3 = Color3.new(1, 1, 1)
wanderLabel.BackgroundTransparency = 1
wanderLabel.TextSize = 11
wanderLabel.Parent = settingsFrame

-- Credits
local credits = Instance.new("TextLabel")
credits.Size = UDim2.new(1, 0, 0, 20)
credits.Position = UDim2.new(0, 0, 1, -22)
credits.Text = "Drag title bar to move | Made for Delta"
credits.TextColor3 = Color3.new(0.5, 0.5, 0.5)
credits.BackgroundTransparency = 1
credits.TextSize = 9
credits.Parent = mainMenu

-- Drag functionality
local dragging = false
local dragStart, frameStart
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        frameStart = mainMenu.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        mainMenu.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Close button
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    botActive = false
end)

-- Range slider logic
local rangeValues = {10, 15, 20, 25, 30, 35, 40}
local rangeIndex = 2
distSlider.MouseButton1Click:Connect(function()
    rangeIndex = rangeIndex % #rangeValues + 1
    TREASURE_DISTANCE = rangeValues[rangeIndex]
    distSlider.Text = tostring(TREASURE_DISTANCE)
end)

-- Bot state
local botRunning = false
local currentTarget = nil

-- Find treasure
local function findNearestTreasure()
    local nearest = nil
    local shortestDist = math.huge
    local treasureKeywords = {"treasure", "chest", "gem", "coin", "gold", "reward", "collect", "pickup", "star", "diamond", "crystal", "orb", "token", "key"}
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("Model") then
            local name = (obj.Name or ""):lower()
            local isTreasure = false
            for _, kw in ipairs(treasureKeywords) do
                if name:find(kw) then
                    isTreasure = true
                    break
                end
            end
            if isTreasure and obj.Parent ~= Character then
                local partPos = obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") and obj.HumanoidRootPart.Position or (obj:IsA("BasePart") and obj.Position)
                if partPos then
                    local dist = (partPos - RootPart.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        nearest = obj
                    end
                end
            end
        end
    end
    return nearest, shortestDist
end

-- Move to position
local function moveTo(position)
    Humanoid:MoveTo(position)
    local lookAt = CFrame.new(RootPart.Position, position)
    RootPart.CFrame = RootPart.CFrame:Lerp(lookAt, 0.2)
end

-- Collect treasure
local function collect(treasure)
    if not treasure then return end
    local collectPart = treasure:IsA("Model") and treasure:FindFirstChild("HumanoidRootPart") or (treasure:IsA("BasePart") and treasure)
    if collectPart then
        local dist = (collectPart.Position - RootPart.Position).Magnitude
        if dist <= TREASURE_DISTANCE then
            local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(collectPart.Position)
            if onScreen then
                mousemoveabs(screenPos.X, screenPos.Y)
                task.wait(0.05)
                mouseclick1()
                statusLabel.Text = "Status: Collecting!"
                task.wait(COLLECT_DELAY)
                return true
            end
        end
    end
    return false
end

-- Anti-AFK
local lastMove = tick()
local function antiAFK()
    if tick() - lastMove > 40 then
        mousemoverel(math.random(-20, 20), math.random(-15, 15))
        lastMove = tick()
    end
end

-- Main bot loop
coroutine.wrap(function()
    while true do
        if botRunning and Humanoid and Humanoid.Health > 0 then
            local treasure, dist = findNearestTreasure()
            if treasure then
                currentTarget = treasure
                targetLabel.Text = "Target: " .. (treasure.Name or "Unknown") .. " (" .. string.format("%.0f", dist) .. "m)"
                statusLabel.Text = "Status: Moving..."
                moveTo(treasure:IsA("Model") and treasure.HumanoidRootPart.Position or treasure.Position)
                task.wait(0.05)
                collect(treasure)
            else
                targetLabel.Text = "Target: None"
                statusLabel.Text = "Status: Wandering..."
                local wanderPos = RootPart.Position + Vector3.new(math.random(-35, 35), 0, math.random(-35, 35))
                Humanoid:MoveTo(wanderPos)
                task.wait(0.5)
            end
            antiAFK()
        end
        task.wait(0.1)
    end
end)()

-- Toggle button
toggleBtn.MouseButton1Click:Connect(function()
    botRunning = not botRunning
    if botRunning then
        toggleBtn.Text = "⏸ STOP BOT"
        toggleBtn.BackgroundColor3 = Color3.new(0.3, 0.1, 0.1)
        toggleBtn.TextColor3 = Color3.new(1, 0.5, 0.5)
        statusLabel.Text = "Status: Active"
    else
        toggleBtn.Text = "▶ START BOT"
        toggleBtn.BackgroundColor3 = Color3.new(0.1, 0.3, 0.1)
        toggleBtn.TextColor3 = Color3.new(0, 1, 0)
        statusLabel.Text = "Status: Stopped"
        targetLabel.Text = "Target: None"
        Humanoid:MoveTo(RootPart.Position)
    end
end)

-- Character respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    task.wait(1)
end)
