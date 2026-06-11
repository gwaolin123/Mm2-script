-- Slap Tower + Fly + Long Range + GUI Menu
-- Roblox script

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Settings
local settings = {
    SlapRange = 100,
    SlapPower = 50,
    KnockbackForce = 100,
    AutoSlap = false,
    FlyEnabled = false,
    SlapAll = false
}

local lastSlap = 0
local flying = false
local bodyVelocity = nil
local towerParts = {}
local TOWER_HEIGHT = 50
local TOWER_RADIUS = 20

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Slap Tower Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = mainFrame

local function addButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = mainFrame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function addSlider(text, yPos, minVal, maxVal, settingKey)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.9, 0, 0, 20)
    label.Position = UDim2.new(0.05, 0, 0, yPos)
    label.Text = text .. ": " .. tostring(settings[settingKey])
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Parent = mainFrame

    local slider = Instance.new("TextBox")
    slider.Size = UDim2.new(0.8, 0, 0, 30)
    slider.Position = UDim2.new(0.1, 0, 0, yPos + 25)
    slider.PlaceholderText = tostring(settings[settingKey])
    slider.Text = ""
    slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    slider.TextColor3 = Color3.new(1, 1, 1)
    slider.Parent = mainFrame

    slider.FocusLost:Connect(function(enterPressed)
        local num = tonumber(slider.Text)
        if num then
            num = math.clamp(num, minVal, maxVal)
            settings[settingKey] = num
            label.Text = text .. ": " .. num
        end
        slider.Text = ""
    end)
end

-- Slap function (all players in range)
local function slapAllInRange()
    if tick() - lastSlap < 0.3 then return end
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = other.Character.HumanoidRootPart
            local dist = (hrp.Position - player.Character.HumanoidRootPart.Position).magnitude
            if dist <= settings.SlapRange then
                local humanoid = other.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:TakeDamage(settings.SlapPower)
                    local dir = (hrp.Position - player.Character.HumanoidRootPart.Position).unit
                    hrp.Velocity = dir * settings.KnockbackForce + Vector3.new(0, 30, 0)
                end
            end
        end
    end
    lastSlap = tick()
end

-- Fly logic
local function enableFly()
    if flying then return end
    flying = true
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = player.Character.HumanoidRootPart

    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bg.Parent = player.Character.HumanoidRootPart

    UserInputService.InputChanged:Connect(function(input)
        if not flying then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local move = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0, 0, -1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0, 0, 1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move + Vector3.new(0, -1, 0) end
            move = move.Unit * 80
            bodyVelocity.Velocity = move
        end
    end)
end

local function disableFly()
    if not flying then return end
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        for _, v in pairs(hrp:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then v:Destroy() end
        end
    end
end

-- Tower building
local function createTower()
    local base = Instance.new("Part")
    base.Size = Vector3.new(TOWER_RADIUS * 2, 1, TOWER_RADIUS * 2)
    base.Position = player.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0)
    base.Anchored = true
    base.BrickColor = BrickColor.new("Dark stone grey")
    base.Parent = game.Workspace
    table.insert(towerParts, base)

    for i = 1, TOWER_HEIGHT do
        local pillar = Instance.new("Part")
        pillar.Size = Vector3.new(3, 1, 3)
        pillar.Position = base.Position + Vector3.new(0, i, 0)
        pillar.Anchored = true
        pillar.BrickColor = BrickColor.new("Really red")
        pillar.Material = Enum.Material.Neon
        pillar.Parent = game.Workspace
        table.insert(towerParts, pillar)
    end
end

-- Destroy tower
local function destroyTower()
    for _, part in ipairs(towerParts) do
        part:Destroy()
    end
    towerParts = {}
end

-- UI Buttons
addButton("Build Tower", 50, function()
    destroyTower()
    createTower()
end)

addButton("Destroy Tower", 100, destroyTower)

addButton("Toggle Auto Slap", 150, function()
    settings.AutoSlap = not settings.AutoSlap
    print("AutoSlap: " .. tostring(settings.AutoSlap))
end)

addButton("Toggle Slap All", 200, function()
    settings.SlapAll = not settings.SlapAll
    print("Slap All Mode: " .. tostring(settings.SlapAll))
end)

addButton("Toggle Fly (Space/Shift)", 250, function()
    if not flying then
        enableFly()
    else
        disableFly()
    end
    settings.FlyEnabled = flying
end)

addSlider("Slap Range", 300, 10, 500, "SlapRange")
addSlider("Slap Damage", 370, 10, 200, "SlapPower")

-- Auto slap loop
RunService.RenderStepped:Connect(function()
    if settings.AutoSlap then
        if settings.SlapAll then
            slapAllInRange()
        else
            -- single nearest would go here, keeping simple: slap all when auto
            slapAllInRange()
        end
    end
end)

-- Manual slap on F
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        if settings.SlapAll then
            slapAllInRange()
        else
            slapAllInRange() -- simplified to all anyway
        end
    end
end)

-- Initial tower
spawn(function()
    repeat wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    createTower()
end)
