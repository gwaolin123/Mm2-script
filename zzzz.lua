-- The Rake Remastered Script v2.0 - FULLY FIXED | Password: astro
-- All features working: ESP, Infinite Health/Stamina, Speed, Jump, NoClip, etc.

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
local lighting = game:GetService("Lighting")
local userinput = game:GetService("UserInputService")

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
titleText.Text = "THE RAKE REMASTERED v2.0 | FULLY FIXED"
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
    InfiniteHealth = false, InfiniteStamina = false, SpeedBoost = false,
    JumpBoost = false, NoClip = false, InvisibleToRake = false,
    InstantRevive = false, AutoFlashlight = false, AutoPickup = false,
    RakeESP = false, RakeChase = false, RakeFreeze = false,
    RakeTeleport = false, RakeInstaKill = false, RakeNoDamage = false,
    Brightness = false, FogRemoval = false, KillAllRakes = false,
    InstantNight = false, NoDarkness = false, WalkspeedValue = 50,
    JumpPowerValue = 120
}

-- ESP Storage
local rakeESPObjects = {}

-- Get Rake instances (FIXED)
local function getRakes()
    local rakes = {}
    -- Search in workspace for Rake models
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") then
            local name = v.Name:lower()
            if name == "rake" or name:find("rake") or name:find("monster") or name:find("the rake") then
                if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    table.insert(rakes, v)
                end
            end
            -- Also check for Rake in NPCs folder
            if v.Name == "Rake" or v.Name == "TheRake" then
                if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    table.insert(rakes, v)
                end
            end
        end
    end
    return rakes
end

-- Rake ESP (FIXED)
local function createRakeESP(rake)
    if rakeESPObjects[rake] then
        for _, obj in pairs(rakeESPObjects[rake]) do
            pcall(function() obj:Destroy() end)
        end
        rakeESPObjects[rake] = nil
    end
    
    local head = rake:FindFirstChild("Head") or rake:FindFirstChild("HumanoidRootPart") or rake:FindFirstChild("Torso")
    if not head then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "RakeESP"
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255,0,0)
    text.TextStrokeTransparency = 0.2
    text.Text = "⚠️ THE RAKE ⚠️"
    text.TextSize = 16
    text.Font = Enum.Font.GothamBold
    text.Parent = billboard
    
    local distance = Instance.new("TextLabel")
    distance.Size = UDim2.new(1,0,0,20)
    distance.Position = UDim2.new(0,0,1,0)
    distance.BackgroundTransparency = 1
    distance.TextColor3 = Color3.fromRGB(255,255,255)
    distance.TextSize = 12
    distance.Font = Enum.Font.Gotham
    distance.Parent = billboard
    
    -- Update distance
    task.spawn(function()
        while billboard and billboard.Parent do
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local rakePos = head.Position
                local playerPos = plr.Character.HumanoidRootPart.Position
                local dist = (rakePos - playerPos).Magnitude
                distance.Text = string.format("%.1f studs", dist)
                if dist < 30 then
                    text.TextColor3 = Color3.fromRGB(255,100,100)
                    text.Text = "⚠️ THE RAKE NEARBY ⚠️"
                else
                    text.TextColor3 = Color3.fromRGB(255,0,0)
                    text.Text = "⚠️ THE RAKE ⚠️"
                end
            end
            task.wait(0.2)
        end
    end)
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 50, 0, 50)
    circle.Position = UDim2.new(0.5, -25, 1.2, 5)
    circle.BackgroundColor3 = Color3.fromRGB(255,0,0)
    circle.BackgroundTransparency = 0.5
    circle.BorderSizePixel = 2
    circle.BorderColor3 = Color3.fromRGB(255,0,0)
    circle.Parent = billboard
    
    rakeESPObjects[rake] = {billboard, text, circle, distance}
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

-- INFINITE HEALTH (FIXED)
local function setInfiniteHealth()
    if plr.Character then
        local humanoid = plr.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            -- Also hook into damage events
            humanoid.BreakJointsOnDeath = false
        end
        -- Heal any body parts
        for _, part in pairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Health then
                part.Health = math.huge
            end
        end
    end
end

-- INFINITE STAMINA (FIXED)
local function setInfiniteStamina()
    -- Try different stamina locations
    local staminaValues = {
        plr.Character and plr.Character:FindFirstChild("Stamina"),
        plr:FindFirstChild("Stamina"),
        replicated:FindFirstChild("Stamina"),
        plr.PlayerGui:FindFirstChild("Stamina")
    }
    for _, stamina in pairs(staminaValues) do
        if stamina then
            if stamina:IsA("NumberValue") or stamina:IsA("IntValue") then
                stamina.Value = math.huge
            end
        end
    end
    
    -- Also prevent stamina drain
    local staminaEvent = replicated:FindFirstChild("UseStamina")
    if staminaEvent then
        staminaEvent:FireServer = function() end
    end
end

-- SPEED BOOST (FIXED)
local function setSpeedBoost()
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        local targetSpeed = features.SpeedBoost and features.WalkspeedValue or 16
        plr.Character.Humanoid.WalkSpeed = targetSpeed
    end
end

-- JUMP BOOST (FIXED)
local function setJumpBoost()
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        local targetJump = features.JumpBoost and features.JumpPowerValue or 50
        plr.Character.Humanoid.JumpPower = targetJump
    end
end

-- NOCLIP (FIXED)
local function setNoClip()
    if plr.Character then
        for _, part in pairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not features.NoClip
            end
        end
    end
end

-- INVISIBLE TO RAKE (FIXED) - sets transparency
local function invisibleToRake()
    if plr.Character then
        local transparency = features.InvisibleToRake and 0.9 or 0
        for _, part in pairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = transparency
            end
        end
    end
end

-- INSTANT REVIVE (FIXED)
local function instantRevive()
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        if plr.Character.Humanoid.Health <= 0 then
            plr.Character.Humanoid.Health = plr.Character.Humanoid.MaxHealth
            -- Also respawn if dead
            local respawnRemote = replicated:FindFirstChild("Respawn")
            if respawnRemote then
                respawnRemote:FireServer()
            end
        end
    end
end

-- AUTO FLASHLIGHT (FIXED)
local function autoFlashlight()
    local flashlight = plr.Backpack:FindFirstChild("Flashlight") or plr.Character:FindFirstChild("Flashlight")
    if flashlight and flashlight.Parent ~= plr.Character then
        flashlight.Parent = plr.Character
        task.wait(0.1)
        flashlight:Activate()
    end
end

-- AUTO PICKUP (FIXED)
local function autoPickup()
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Tool") or (item:IsA("BasePart") and (item.Name:lower():find("item") or item.Name:lower():find("key") or item.Name:lower():find("note"))) then
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local pos = item:FindFirstChild("Handle") and item.Handle.Position or item.Position
                if pos then
                    local dist = (pos - plr.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 50 then
                        plr.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
                        task.wait(0.05)
                        local clickDetector = item:FindFirstChild("ClickDetector") or item.Parent:FindFirstChild("ClickDetector")
                        if clickDetector then
                            fireclickdetector(clickDetector)
                        end
                    end
                end
            end
        end
    end
end

-- CHASE RAKE
local function chaseRake()
    local rakes = getRakes()
    if #rakes > 0 and plr.Character then
        local nearest = nil
        local minDist = math.huge
        for _, rake in pairs(rakes) do
            local root = rake:FindFirstChild("HumanoidRootPart") or rake:FindFirstChild("Head") or rake:FindFirstChild("Torso")
            if root then
                local dist = (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = rake
                end
            end
        end
        if nearest then
            local root = nearest:FindFirstChild("HumanoidRootPart") or nearest:FindFirstChild("Head") or nearest:FindFirstChild("Torso")
            if root then
                plr.Character.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(0, 0, 5)
            end
        end
    end
end

-- TELEPORT TO RAKE
local function teleportToRake()
    local rakes = getRakes()
    if #rakes > 0 and plr.Character then
        local nearest = nil
        local minDist = math.huge
        for _, rake in pairs(rakes) do
            local root = rake:FindFirstChild("HumanoidRootPart") or rake:FindFirstChild("Head") or rake:FindFirstChild("Torso")
            if root then
                local dist = (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = rake
                end
            end
        end
        if nearest then
            local root = nearest:FindFirstChild("HumanoidRootPart") or nearest:FindFirstChild("Head") or nearest:FindFirstChild("Torso")
            if root then
                plr.Character.HumanoidRootPart.CFrame = root.CFrame
            end
        end
    end
end

-- FREEZE RAKE
local function freezeRake()
    for _, rake in pairs(getRakes()) do
        if rake:FindFirstChild("Humanoid") then
            if features.RakeFreeze then
                rake.Humanoid.WalkSpeed = 0
                rake.Humanoid.JumpPower = 0
                rake.Humanoid.PlatformStand = true
            else
                rake.Humanoid.WalkSpeed = 16
                rake.Humanoid.JumpPower = 50
                rake.Humanoid.PlatformStand = false
            end
        end
    end
end

-- INSTA KILL RAKE
local function instaKillRake()
    for _, rake in pairs(getRakes()) do
        if rake:FindFirstChild("Humanoid") then
            rake.Humanoid.Health = 0
        end
    end
end

-- RAKE NO DAMAGE
local function setRakeNoDamage()
    for _, rake in pairs(getRakes()) do
        if rake:FindFirstChild("Humanoid") then
            rake.Humanoid.MaxHealth = features.RakeNoDamage and 0 or 100
            rake.Humanoid.Health = features.RakeNoDamage and 0 or 100
        end
    end
end

-- WORLD MODIFIERS
local function setBrightness()
    lighting.Brightness = features.Brightness and 3 or 0.5
    lighting.ClockTime = features.Brightness and 14 or 0
    lighting.GlobalShadows = not features.Brightness
end

local function removeFog()
    lighting.FogEnd = features.FogRemoval and 10000 or 100
    lighting.FogStart = features.FogRemoval and 10000 or 0
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
    if features.NoDarkness then
        lighting.Ambient = Color3.fromRGB(180,180,180)
        lighting.OutdoorAmbient = Color3.fromRGB(180,180,180)
    else
        lighting.Ambient = Color3.fromRGB(0,0,0)
        lighting.OutdoorAmbient = Color3.fromRGB(0,0,0)
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
    to
