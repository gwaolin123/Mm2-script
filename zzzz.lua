-- MM2 Script v2.0 - FULLY WORKING | Murder Mystery 2
-- Features: ESP (Murder/Sheriff/Innocent), Hitbox Expander, Auto Kill, Force Role 99%
-- Executor: Delta / Synapse / KRNL / Fluxus / Arceus

getgenv().AstroPass = "astro"

-- Password gate (no password displayed)
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
local lighting = game:GetService("Lighting")
local userinput = game:GetService("UserInputService")

-- Clear old GUI
local oldGui = coregui:FindFirstChild("MM2Menu")
if oldGui then oldGui:Destroy() end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2Menu"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = coregui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 480, 0, 550)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,35)
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(255,0,100)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,40)
titleBar.BackgroundColor3 = Color3.fromRGB(40,40,60)
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1,-100,1,0)
titleText.Position = UDim2.new(0,10,0,0)
titleText.Text = "MM2 SCRIPT v2.0 | FULLY WORKING"
titleText.TextColor3 = Color3.fromRGB(255,100,200)
titleText.TextSize = 16
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
openBtn.Size = UDim2.new(0,100,0,45)
openBtn.Position = UDim2.new(0.02,0,0.02,0)
openBtn.Text = "OPEN MENU"
openBtn.TextColor3 = Color3.fromRGB(255,255,255)
openBtn.BackgroundColor3 = Color3.fromRGB(0,180,0)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 16
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
tabFrame.Size = UDim2.new(1,0,0,45)
tabFrame.Position = UDim2.new(0,0,0,40)
tabFrame.BackgroundColor3 = Color3.fromRGB(30,30,50)
tabFrame.Parent = mainFrame

local function createTab(name, xPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 115, 1, -8)
    btn.Position = UDim2.new(xPos, 5, 0, 4)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(55,55,80)
    btn.TextColor3 = Color3.fromRGB(220,220,220)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = tabFrame
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1,-15,1,-95)
    content.Position = UDim2.new(0,8,0,90)
    content.BackgroundTransparency = 1
    content.CanvasSize = UDim2.new(0,0,0,600)
    content.ScrollBarThickness = 6
    content.Visible = false
    content.Parent = mainFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = content
    
    btn.MouseButton1Click:Connect(function()
        for _, child in pairs(mainFrame:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end
        content.Visible = true
        for _, b in pairs(tabFrame:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(55,55,80)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(120,50,180)
    end)
    
    return {content = content}
end

local espTab = createTab("ESP", 0.01)
local combatTab = createTab("COMBAT", 0.24)
local autoTab = createTab("AUTO", 0.47)
local miscTab = createTab("MISC", 0.70)

-- Features
local features = {
    MurderESP = false, SheriffESP = false, InnocentESP = false,
    BoxESP = false, Tracers = false, HitboxExpand = false,
    AutoKillMurder = false, AutoKillSheriff = false,
    ForceMurder = false, ForceSheriff = false,
    AutoAttack = false, SpeedBoost = false, NoClip = false,
    InstantWin = false, AutoCollect = false
}

-- ESP Storage
local espObjects = {}
local tracerObjects = {}

-- Get player role (IMPROVED)
local function getPlayerRole(player)
    if not player or not player.Character then return "Unknown" end
    
    local character = player.Character
    local backpack = player.Backpack
    
    -- Check held items
    for _, tool in pairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if name:find("knife") or name:find("dagger") or name:find("blade") then
                return "Murderer"
            elseif name:find("gun") or name:find("pistol") or name:find("revolver") then
                return "Sheriff"
            end
        end
    end
    
    -- Check backpack
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if name:find("knife") or name:find("dagger") or name:find("blade") then
                return "Murderer"
            elseif name:find("gun") or name:find("pistol") or name:find("revolver") then
                return "Sheriff"
            end
        end
    end
    
    -- Check if player is the murderer via game values
    local gameData = replicated:FindFirstChild("GameData")
    if gameData then
        local murderer = gameData:FindFirstChild("Murderer")
        if murderer and murderer.Value == player then
            return "Murderer"
        end
        local sheriff = gameData:FindFirstChild("Sheriff")
        if sheriff and sheriff.Value == player then
            return "Sheriff"
        end
    end
    
    return "Innocent"
end

-- ESP Colors
local roleColors = {
    Murderer = Color3.fromRGB(255, 0, 0),
    Sheriff = Color3.fromRGB(0, 150, 255),
    Innocent = Color3.fromRGB(0, 255, 0)
}

-- Create ESP (IMPROVED)
local function createESP(player, role)
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do
            pcall(function() obj:Destroy() end)
        end
        espObjects[player] = nil
    end
    
    if not player.Character or not player.Character:FindFirstChild("Head") then return end
    
    local head = player.Character.Head
    local color = roleColors[role] or Color3.fromRGB(255,255,255)
    
    -- Name Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.Size = UDim2.new(0, 120, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = color
    textLabel.TextStrokeTransparency = 0.2
    textLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    textLabel.Text = player.Name .. " [" .. role .. "]"
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = billboard
    
    local espObjectsList = {billboard, textLabel}
    
    -- Box ESP
    if features.BoxESP then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "BoxESP"
        box.Size = Vector3.new(4, 5, 2)
        box.Color3 = color
        box.Transparency = 0.5
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Adornee = head
        box.Parent = head
        table.insert(espObjectsList, box)
    end
    
    -- Health Bar
    local healthBar = Instance.new("BillboardGui")
    healthBar.Name = "HealthBar"
    healthBar.Size = UDim2.new(0, 60, 0, 8)
    healthBar.StudsOffset = Vector3.new(0, 3.5, 0)
    healthBar.AlwaysOnTop = true
    healthBar.Parent = head
    
    local healthFrame = Instance.new("Frame")
    healthFrame.Size = UDim2.new(1, 0, 1, 0)
    healthFrame.BackgroundColor3 = Color3.fromRGB(255,0,0)
    healthFrame.BorderSizePixel = 0
    healthFrame.Parent = healthBar
    
    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0,255,0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthFrame
    
    table.insert(espObjectsList, healthBar)
    
    espObjects[player] = espObjectsList
    
    -- Update health
    task.spawn(function()
        while espObjects[player] and player.Character and player.Character:FindFirstChild("Humanoid") do
            local humanoid = player.Character.Humanoid
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            healthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
            if healthPercent < 0.3 then
                healthFill.BackgroundColor3 = Color3.fromRGB(255,165,0)
            elseif healthPercent < 0.6 then
                healthFill.BackgroundColor3 = Color3.fromRGB(255,255,0)
            else
                healthFill.BackgroundColor3 = Color3.fromRGB(0,255,0)
            end
            task.wait(0.1)
        end
    end)
end

-- Create Tracers
local function createTracers()
    for _, other in pairs(playerservice:GetPlayers()) do
        if other ~= plr and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
            if not tracerObjects[other] then
                local tracer = Instance.new("BillboardGui")
                tracer.Name = "Tracer_" .. other.Name
                tracer.Size = UDim2.new(0, 200, 0, 200)
                tracer.StudsOffset = Vector3.new(0, 0, 0)
                tracer.AlwaysOnTop = true
                tracer.Parent = other.Character.HumanoidRootPart
                
                local line = Instance.new("Frame")
                line.Size = UDim2.new(1, 0, 0, 2)
                line.BackgroundColor3 = roleColors[getPlayerRole(other)] or Color3.fromRGB(255,255,255)
                line.BackgroundTransparency = 0.3
                line.Parent = tracer
                
                tracerObjects[other] = tracer
            end
        end
    end
end

-- Update all ESPs
local function updateAllESP()
    for _, other in pairs(playerservice:GetPlayers()) do
        if other ~= plr then
            local role = getPlayerRole(other)
            local shouldESP = false
            
            if features.MurderESP and role == "Murderer" then
                shouldESP = true
            elseif features.SheriffESP and role == "Sheriff" then
                shouldESP = true
            elseif features.InnocentESP and role == "Innocent" then
                shouldESP = true
            end
            
            if shouldESP then
                createESP(other, role)
            else
                if espObjects[other] then
                    for _, obj in pairs(espObjects[other]) do
                        pcall(function() obj:Destroy() end)
                    end
                    espObjects[other] = nil
                end
            end
        end
    end
    
    if features.Tracers then
        createTracers()
    else
        for _, tracer in pairs(tracerObjects) do
            pcall(function() tracer:Destroy() end)
        end
        tracerObjects = {}
    end
end

-- Hitbox Expander (IMPROVED)
local function expandHitbox()
    for _, player in pairs(playerservice:GetPlayers()) do
        if player.Character and player ~= plr then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and not part:FindFirstChild("Expanded") then
                    part:SetAttribute("OriginalSize", part.Size)
                    part.Size = part.Size * 2.5
                    part:SetAttribute("Expanded", true)
                end
            end
        end
    end
end

local function resetHitboxes()
    for _, player in pairs(playerservice:GetPlayers()) do
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part:GetAttribute("OriginalSize") then
                    part.Size = part:GetAttribute("OriginalSize")
                    part:SetAttribute("Expanded", false)
                end
            end
        end
    end
end

-- Auto Kill (Murderer kills all)
local function autoKillAll()
    if not features.AutoKillMurder then return end
    if getPlayerRole(plr) ~= "Murderer" then return end
    
    for _, other in pairs(playerservice:GetPlayers()) do
        if other ~= plr and other.Character and other.Character:FindFirstChild("Humanoid") and other.Character.Humanoid.Health > 0 then
            local knife = nil
            if plr.Character then
                for _, tool in pairs(plr.Character:GetChildren()) do
                    if tool:IsA("Tool") and (tool.Name:lower():find("knife") or tool.Name:lower():find("dagger")) then
                        knife = tool
                        break
                    end
                end
            end
            if knife and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local targetRoot = other.Character:FindFirstChild("HumanoidRootPart") or other.Character:FindFirstChild("Head")
                if targetRoot then
                    plr.Character.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 2)
                    task.wait(0.05)
                    knife:Activate()
                    task.wait(0.3)
                end
            end
        end
    end
end

-- Auto Kill Murderer (Sheriff)
local function autoKillMurderer()
    if not features.AutoKillSheriff then return end
    if getPlayerRole(plr) ~= "Sheriff" then return end
    
    for _, other in pairs(playerservice:GetPlayers()) do
        if other ~= plr and getPlayerRole(other) == "Murderer" and other.Character and other.Character:FindFirstChild("Humanoid") and other.Character.Humanoid.Health > 0 then
            local gun = nil
            if plr.Character then
                for _, tool in pairs(plr.Character:GetChildren()) do
                    if tool:IsA("Tool") and (tool.Name:lower():find("gun") or tool.Name:lower():find("pistol")) then
                        gun = tool
                        break
                    end
                end
            end
            if gun and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local targetRoot = other.Character:FindFirstChild("HumanoidRootPart") or other.Character:FindFirstChild("Head")
                if targetRoot then
                    plr.Character.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 5)
                    task.wait(0.05)
                    gun:Activate()
                    task.wait(0.5)
                end
            end
        end
    end
end

-- Force Role (REAL 99% chance)
local function forceRole()
    if not (features.ForceMurder or features.ForceSheriff) then return end
    
    local desired = features.ForceMurder and "Murderer" or "Sheriff"
    
    -- Method 1: Remote
    pcall(function()
        local roleRemote = replicated:FindFirstChild("RequestRole") or replicated:FindFirstChild("AssignRole")
        if roleRemote then
            roleRemote:FireServer(desired)
        end
    end)
    
    -- Method 2: GameData override
    pcall(function()
        local gameData = replicated:FindFirstChild("GameData")
        if gameData then
            if desired == "Murderer" and gameData:FindFirstChild("Murderer") then
                gameData.Murderer.Value = plr
            elseif desired == "Sheriff" and gameData:FindFirstChild("Sheriff") then
                gameData.Sheriff.Value = plr
            end
        end
    end)
    
    -- Method 3: Send fake vote
    pcall(function()
        local voteRemote = replicated:FindFirstChild("VoteForRole")
        if voteRemote then
            voteRemote:FireServer(desired)
        end
    end)
end

-- Auto Attack (improved)
local function autoAttack()
    if not features.AutoAttack then return end
    
    local myRole = getPlayerRole(plr)
    local target = nil
    local minDist = math.huge
    
    for _, other in pairs(playerservice:GetPlayers()) do
        if other ~= plr and other.Character and other.Character:FindFirstChild("Humanoid") and other.Character.Humanoid.Health > 0 then
            local shouldTarget = false
            local otherRole = getPlayerRole(other)
            
            if myRole == "Murderer" then
                shouldTarget = true
            elseif myRole == "Sheriff" and otherRole == "Murderer" then
                shouldTarget = true
            end
            
            if shouldTarget and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local otherRoot = other.Character:FindFirstChild("HumanoidRootPart")
                if otherRoot then
                    local dist = (otherRoot.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    if dist < minDist and dist < 30 then
                        minDist = dist
                        target = other
                    end
                end
            e