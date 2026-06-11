-- The Rake Remastered Script v1.0 - 20 Features | Password: astro
-- Executor: Delta / Synapse / KRNL / Fluxus

getgenv().AstroPass = "astro"

-- Password gate
local function passwordGate()
    local success = false
    local dialog = Instance.new("ScreenGui")
    dialog.Name = "PassGate"
    dialog.Parent = game:GetService("CoreGui")
    dialog.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    dialog.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 140)
    frame.Position = UDim2.new(0.5, -175, 0.5, -70)
    frame.BackgroundColor3 = Color3.fromRGB(25,25,45)
    frame.BorderSizePixel = 3
    frame.BorderColor3 = Color3.fromRGB(255,0,150)
    frame.Parent = dialog
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,40)
    title.Text = "ENTER PASSWORD"
    title.TextColor3 = Color3.fromRGB(255,100,200)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.BackgroundTransparency = 1
    title.Parent = frame
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.7,0,0,35)
    input.Position = UDim2.new(0.15,0,0.4,0)
    input.PlaceholderText = "password"
    input.Text = ""
    input.BackgroundColor3 = Color3.fromRGB(60,60,90)
    input.TextColor3 = Color3.fromRGB(255,255,255)
    input.TextSize = 16
    input.Parent = frame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.4,0,0,35)
    button.Position = UDim2.new(0.3,0,0.7,0)
    button.Text = "UNLOCK"
    button.BackgroundColor3 = Color3.fromRGB(0,170,0)
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.TextSize = 16
    button.Parent = frame
    
    button.MouseButton1Click:Connect(function()
        if input.Text == getgenv().AstroPass then
            success = true
            dialog:Destroy()
        else
            input.Text = "WRONG!"
            task.wait(0.8)
            input.Text = ""
        end
    end)
    
    repeat task.wait() until success == true
end

if not getgenv().AstroChecked then
    passwordGate()
    getgenv().AstroChecked = true
end

-- Services
local plr = game.Players.LocalPlayer
local coregui = game:GetService("CoreGui")
local workspace = game:GetService("Workspace")
local playerservice = game:GetService("Players")
local replicated = game:GetService("ReplicatedStorage")
local runservice = game:GetService("RunService")
local userinput = game:GetService("UserInputService")
local lighting = game:GetService("Lighting")
local tween = game:GetService("TweenService")

-- Clear old GUI
local oldGui = coregui:FindFirstChild("RakeMenu")
if oldGui then oldGui:Destroy() end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RakeMenu"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = coregui

pcall(function()
    if syn and syn.protect_gui then syn.protect_gui(screenGui) end
end)

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 600)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(15,15,30)
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(150,50,200)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,45)
titleBar.BackgroundColor3 = Color3.fromRGB(40,40,65)
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1,-110,1,0)
titleText.Position = UDim2.new(0,10,0,0)
titleText.Text = "THE RAKE REMASTERED v1.0 | 20 FEATURES"
titleText.TextColor3 = Color3.fromRGB(200,100,255)
titleText.TextSize = 15
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.BackgroundTransparency = 1
titleText.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,50,1,0)
closeBtn.Position = UDim2.new(1,-55,0,0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.BackgroundColor3 = Color3.fromRGB(180,30,30)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0,120,0,50)
openBtn.Position = UDim2.new(0.5, -60, 0.5, -25)
openBtn.Text = "OPEN MENU"
openBtn.TextColor3 = Color3.fromRGB(255,255,255)
openBtn.BackgroundColor3 = Color3.fromRGB(0,180,0)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 18
openBtn.BorderSizePixel = 2
openBtn.Visible = false
openBtn.Parent = screenGui

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)

-- Tab buttons
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1,0,0,50)
tabFrame.Position = UDim2.new(0,0,0,45)
tabFrame.BackgroundColor3 = Color3.fromRGB(30,30,50)
tabFrame.Parent = mainFrame

local function createTab(name, xPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 125, 1, -8)
    btn.Position = UDim2.new(xPos, 5, 0, 4)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(55,55,85)
    btn.TextColor3 = Color3.fromRGB(230,230,230)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = tabFrame
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1,-15,1,-105)
    content.Position = UDim2.new(0,8,0,100)
    content.BackgroundTransparency = 1
    content.CanvasSize = UDim2.new(0,0,0,750)
    content.ScrollBarThickness = 6
    content.Visible = false
    content.Parent = mainFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = content
    
    btn.MouseButton1Click:Connect(function()
        for _, child in pairs(mainFrame:GetChildren()) do
            if child:IsA("ScrollingFrame") then child.Visible = false end
        end
        content.Visible = true
        for _, b in pairs(tabFrame:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(55,55,85) end
        end
        btn.BackgroundColor3 = Color3.fromRGB(150,50,220)
    end)
    
    return {content = content}
end

local playerTab = createTab("👤 PLAYER", 0.01)
local monsterTab = createTab("👹 MONSTER", 0.26)
local worldTab = createTab("🌍 WORLD", 0.51)
local miscTab = createTab("🔧 MISC", 0.76)

-- Features
local features = {
    -- Player features
    InfiniteHealth = false, InfiniteStamina = false, SpeedBoost = false,
    JumpBoost = false, NoClip = false, InvisibleToRake = false,
    InstantRevive = false, AutoFlashlight = false, AutoPickup = false,
    -- Monster features
    RakeESP = false, RakeChase = false, RakeFreeze = false,
    RakeTeleport = false, RakeInstaKill = false, RakeNoDamage = false,
    -- World features
    Brightness = false, FogRemoval = false, KillAllRakes = false,
    InstantNight = false, NoDarkness = false
}

-- Variables
local rakeESPObjects = {}
local rakeTarget = nil

-- Get Rake instances
local function getRakes()
    local rakes = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and (v.Name:lower():find("rake") or v.Name:lower():find("monster")) then
            if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                table.insert(rakes, v)
            end
        end
    end
    return rakes
end

-- Rake ESP
local function createRakeESP(rake)
    if rakeESPObjects[rake] then
        for _, obj in pairs(rakeESPObjects[rake]) do
            pcall(function() obj:Destroy() end)
        end
        rakeESPObjects[rake] = nil
    end
    
    local head = rake:FindFirstChild("Head") or rake:FindFirstChild("HumanoidRootPart")
    if not head then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "RakeESP"
    billboard.Size = UDim2.new(0, 120, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255,0,0)
    text.TextStrokeTransparency = 0.2
    text.Text = "THE RAKE"
    text.TextSize = 16
    text.Font = Enum.Font.GothamBold
    text.Parent = billboard
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 40, 0, 40)
    circle.Position = UDim2.new(0.5, -20, 1, 5)
    circle.BackgroundColor3 = Color3.fromRGB(255,0,0)
    circle.BackgroundTransparency = 0.5
    circle.BorderSizePixel = 2
    circle.BorderColor3 = Color3.fromRGB(255,0,0)
    circle.Parent = billboard
    
    rakeESPObjects[rake] = {billboard, text, circle}
end

-- Update Rake ESP
local function updateRakeESP()
    for _, rake in pairs(getRakes()) do
        if features.RakeESP then
            createRakeESP(rake)
        else
            if rakeESPObjects[rake] then
                for _, obj in pairs(rakeESPObjects[rake]) do
                    pcall(function() obj:Destroy() end)
                end
                rakeESPObjects[rake] = nil
            end
        end
    end
end

-- Player modifiers
local function setInfiniteHealth()
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.MaxHealth = math.huge
        plr.Character.Humanoid.Health = math.huge
    end
end

local function setInfiniteStamina()
    local stamina = plr.Character and plr.Character:FindFirstChild("Stamina")
    if stamina then
        stamina.Value = math.huge
    end
end

local function setSpeedBoost()
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.WalkSpeed = features.SpeedBoost and 50 or 16
    end
end

local function setJumpBoost()
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.JumpPower = features.JumpBoost and 120 or 50
    end
end

local function setNoClip()
    if plr.Character then
        for _, part in pairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not features.NoClip
            end
        end
    end
end

-- Rake chase / teleport
local function chaseRake()
    local rakes = getRakes()
    if #rakes > 0 and plr.Character then
        local nearest = nil
        local minDist = math.huge
        for _, rake in pairs(rakes) do
            local root = rake:FindFirstChild("HumanoidRootPart") or rake:FindFirstChild("Head")
            if root then
                local dist = (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = rake
                end
            end
        end
        if nearest then
            local root = nearest:FindFirstChild("HumanoidRootPart") or nearest:FindFirstChild("Head")
            if root then
                plr.Character.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(0, 0, 5)
            end
        end
    end
end

local function teleportToRake()
    local rakes = getRakes()
    if #rakes > 0 and plr.Character then
        local nearest = nil
        local minDist = math.huge
        for _, rake in pairs(rakes) do
            local root = rake:FindFirstChild("HumanoidRootPart") or rake:FindFirstChild("Head")
            if root then
                local dist = (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = rake
                end
            end
        end
        if nearest then
            local root = nearest:FindFirstChild("HumanoidRootPart") or nearest:FindFirstChild("Head")
            if root then
                plr.Character.HumanoidRootPart.CFrame = root.CFrame
            end
        end
    end
end

local function freezeRake()
    for _, rake in pairs(getRakes()) do
        if rake:FindFirstChild("Humanoid") then
            rake.Humanoid.WalkSpeed = features.RakeFreeze and 0 or 16
            rake.Humanoid.JumpPower = 0
        end
    end
end

local function instaKillRake()
    for _, rake in pairs(getRakes()) do
        if rake:FindFirstChild("Humanoid") then
            rake.Humanoid.Health = 0
        end
    end
end

local function setRakeNoDamage()
    for _, rake in pairs(getRakes()) do
        if rake:FindFirstChild("Humanoid") then
            rake.Humanoid.MaxHealth = features.RakeNoDamage and 0 or 100
            rake.Humanoid.Health = 0
        end
    end
end

-- World modifiers
local function setBrightness()
    lighting.Brightness = features.Brightness and 2 or 0.5
    lighting.ClockTime = features.Brightness and 14 or 0
end

local function removeFog()
    lighting.FogEnd = features.FogRemoval and 1000 or 100
    lighting.FogStart = features.FogRemoval and 1000 or 0
end

local function killAllRakes()
    for _, rake in pairs(getRakes()) do
        if rake:FindFirstChild("Humanoid") then
            rake.Humanoid.Health = 0
        end
    end
end

local function setInstantNight()
    lighting.ClockTime = features.InstantNight and 0 or 14
end

local function noDarkness()
    lighting.Ambient = features.NoDarkness and Color3.fromRGB(255,255,255) or Color3.fromRGB(0,0,0)
    lighting.OutdoorAmbient = features.NoDarkness and Color3.fromRGB(255,255,255) or Color3.fromRGB(0,0,0)
end

-- Auto pickup items
local function autoPickup()
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Tool") or (item:IsA("BasePart") and item.Name:lower():find("item")) then
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local pos = item:FindFirstChild("Handle") and item.Handle.Position or item.Position
                if pos then
                    plr.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
                    task.wait(0.05)
                    fireclickdetector(item:FindFirstChild("ClickDetector") or item.Parent:FindFirstChild("ClickDetector"))
                end
            end
        end
    end
end

-- Auto flashlight
local function autoFlashlight()
    local flashlight = plr.Backpack:FindFirstChild("Flashlight") or plr.Character:FindFirstChild("Flashlight")
    if flashlight then
        flashlight.Parent = plr.Character
        flashlight:Activate()
    end
end

-- Instant revive
local function instantRevive()
    if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health <= 0 then
        plr.Character.Humanoid.Health = plr.Character.Humanoid.MaxHealth
    end
end

-- Invisible to Rake
local function invisibleToRake()
    if plr.Character then
        for _, part in pairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = features.InvisibleToRake and 0.8 or 0
            end
        end
    end
end

-- Add toggle button
local function addToggle(tabObj, text, key)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 48)
    row.BackgroundColor3 = Color3.fromRGB(35,35,60)
    row.BorderSizePixel = 1
    row.BorderColor3 = Color3.fromRGB(70,70,100)
    row.Parent = tabObj.content
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(245,245,245)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = row
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 90, 0, 34)
    toggleBtn.Position = UDim2.new(0.72, 0, 0.07, 0)
    toggleBtn.Text = "OFF"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
    toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 14
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = row
    
    local state = false
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        features[key] = state
        if state then
            toggleBtn.Text = "ON"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50,180,50)
        else
            toggleBtn.Text = "OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
        end
    end)
end

-- Add all toggles (20 features)
addToggle(playerTab, "❤️ INFINITE HEALTH", "InfiniteHealth")
addToggle(playerTab, "⚡ INFINITE STAMINA", "InfiniteStamina")
addToggle(playerTab, "💨 SPEED BOOST (x3)", "SpeedBoost")
addToggle(playerTab, "🦘 JUMP BOOST (x2)", "JumpBoost")
addToggle(playerTab, "🕳️ NOCLIP", "NoClip")
addToggle(playerTab, "👻 INVISIBLE TO RAKE", "InvisibleToRake")
addToggle(playerTab, "💀 INSTANT REVIVE", "InstantRevive")
addToggle(playerTab, "🔦 AUTO FLASHLIGHT", "AutoFlashlight")
addToggle(playerTab, "💰 AUTO PICKUP ITEMS", "AutoPickup")

addToggle(monsterTab, "👁️ RAKE ESP (RED)", "RakeESP")
addToggle(monsterTab, "🏃 CHASE RAKE (Auto Move)", "RakeChase")
addToggle(monsterTab, "❄️ FREEZE RAKE", "RakeFreeze")
addToggle(monsterTab, "🌀 TELEPORT TO RAKE", "RakeTeleport")
addToggle(monsterTab, "💀 INSTA-KILL RAKE", "RakeInstaKill")
addToggle(monsterTab, "🛡️ RAKE NO DAMAGE", "RakeNoDamage")

addToggle(worldTab, "☀️ BRIGHTNESS (Day)", "Brightness")
addToggle(worldTab, "🌫️ REMOVE FOG", "FogRemoval")
addToggle(worldTab, "🗡️ KILL ALL RAKES", "KillAllRakes")
addToggle(worldTab, "🌙 INSTANT NIGHT", "InstantNight")
addToggle(worldTab, "🔦 NO DARKNESS", "NoDarkness")

-- Show first tab
playerTab.content.Visible = true
for _, btn in pairs(tabFrame:GetChildren()) do
    if btn:IsA("TextButton") and btn.Text == "👤 PLAYER" then
        btn.BackgroundColor3 = Color3.fromRGB(150,50,220)
        break
    end
end

-- MAIN LOOP
task.spawn(function()
    while true do
        -- Player features
        if features.InfiniteHealth then setInfiniteHealth() end
        if features.InfiniteStamina then setInfiniteStamina() end
        if features.SpeedBoost or not features.SpeedBoost then setSpeedBoost() end
        if features.JumpBoost or not features.JumpBoost then setJumpBoost() end
        if features.NoClip then setNoClip() end
        if features.InvisibleToRake then invisibleToRake() end
        if features.InstantRevive then instantRevive() end
        if features.AutoFlashlight then autoFlashlight() end
        if features.AutoPickup then autoPickup() end
        
        -- Monster features
        if features.RakeESP then updateRakeESP() end
        if features.RakeChase then chaseRake() end
        if features.RakeTeleport then teleportToRake(); features.RakeTeleport = false end
        if features.RakeFreeze then freezeRake() end
        if features.RakeInstaKill then instaKillRake(); features.RakeInstaKill = false end
        if features.RakeNoDamage then setRakeNoDamage() end
        
        -- World features
        if features.Brightness or not features.Brightness then setBrightness() end
        if features.FogRemoval or not features.FogRemoval then removeFog() end
        if features.KillAllRakes then killAllRakes(); features.KillAllRakes = false end
        if features.InstantNight or not features.InstantNight then setInstantNight() end
        if features.NoDarkness or not features.NoDarkness then noDarkness() end
        
        task.wait(0.15)
    end
end)

print("✅ THE RAKE REMASTERED v1.0 LOADED | Password: astro | 20 Features")
print("⚠️ GUI should appear | Enter 'astro' to unlock")
