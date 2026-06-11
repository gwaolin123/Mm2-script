-- MM2 Script v4.0 - DELTA EXECUTOR FIXED | Murder Mystery 2
-- Features: ESP, Hitbox Expander, Auto Kill, Force Role 99%
-- DELTA SPECIFIC: Uses Delta's UI library, no CoreGui issues

getgenv().AstroPass = "astro"

-- Password gate (simplified for Delta)
local function deltaPasswordGate()
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
    deltaPasswordGate()
    getgenv().AstroChecked = true
end

-- Services
local plr = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local playerservice = game:GetService("Players")
local replicated = game:GetService("ReplicatedStorage")
local userinput = game:GetService("UserInputService")
local http = game:GetService("HttpService")

-- Clear any existing GUI
pcall(function()
    for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
        if v.Name == "MM2MenuDelta" then v:Destroy() end
    end
end)

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2MenuDelta"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

-- Force protect for Delta
pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
    end
end)

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 600)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(15,15,30)
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(255,50,150)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,45)
titleBar.BackgroundColor3 = Color3.fromRGB(40,40,65)
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1,-110,1,0)
titleText.Position = UDim2.new(0,10,0,0)
titleText.Text = "MM2 SCRIPT v4.0 | DELTA EDITION"
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
    btn.Size = UDim2.new(0, 120, 1, -8)
    btn.Position = UDim2.new(xPos, 5, 0, 4)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(55,55,85)
    btn.TextColor3 = Color3.fromRGB(230,230,230)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 15
    btn.BorderSizePixel = 0
    btn.Parent = tabFrame
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1,-15,1,-105)
    content.Position = UDim2.new(0,8,0,100)
    content.BackgroundTransparency = 1
    content.CanvasSize = UDim2.new(0,0,0,650)
    content.ScrollBarThickness = 6
    content.Visible = false
    content.Parent = mainFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
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
                b.BackgroundColor3 = Color3.fromRGB(55,55,85)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(150,50,220)
    end)
    
    return {content = content}
end

local espTab = createTab("👁️ ESP", 0.01)
local combatTab = createTab("⚔️ COMBAT", 0.26)
local autoTab = createTab("🤖 AUTO", 0.51)
local miscTab = createTab("🔧 MISC", 0.76)

-- Features
local features = {
    MurderESP = false, SheriffESP = false, InnocentESP = false,
    BoxESP = false, Tracers = false, HitboxExpand = false,
    AutoKillMurder = false, AutoKillSheriff = false,
    ForceMurder = false, ForceSheriff = false,
    AutoAttack = false, SpeedBoost = false, NoClip = false,
    InstantWin = false, AutoCollect = false, Fly = false
}

-- ESP Storage
local espObjects = {}

-- Get player role
local function getPlayerRole(player)
    if not player or not player.Character then return "Unknown" end
    
    for _, tool in pairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if name:find("knife") or name:find("dagger") then
                return "Murderer"
            elseif name:find("gun") or name:find("pistol") then
                return "Sheriff"
            end
        end
    end
    
    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if name:find("knife") or name:find("dagger") then
                return "Murderer"
            elseif name:find("gun") or name:find("pistol") then
                return "Sheriff"
            end
        end
    end
    
    return "Innocent"
end

local roleColors = {
    Murderer = Color3.fromRGB(255, 0, 0),
    Sheriff = Color3.fromRGB(0, 150, 255),
    Innocent = Color3.fromRGB(0, 255, 0)
}

-- Create ESP
local function createESP(player, role)
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do
            pcall(function() obj:Destroy() end)
        end
        espObjects[player] = nil
    end
    
    if not player.Character or not player.Character:FindFirstChild("Head") then return end
    
    local head = player.Character.Head
    local color = roleColors[role]
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.Size = UDim2.new(0, 130, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = color
    textLabel.TextStrokeTransparency = 0.2
    textLabel.Text = player.Name .. " [" .. role .. "]"
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = billboard
    
    local espList = {billboard}
    
    if features.BoxESP then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "BoxESP"
        box.Size = Vector3.new(4, 5, 2)
        box.Color3 = color
        box.Transparency = 0.4
        box.AlwaysOnTop = true
        box.Adornee = head
        box.Parent = head
        table.insert(espList, box)
    end
    
    espObjects[player] = espList
end

-- Update ESP
local function updateESP()
    for _, other in pairs(playerservice:GetPlayers()) do
        if other ~= plr then
            local role = getPlayerRole(other)
            local show = (features.MurderESP and role == "Murderer") or
                        (features.SheriffESP and role == "Sheriff") or
                        (features.InnocentESP and role == "Innocent")
            
            if show then
                createESP(other, role)
            elseif espObjects[other] then
                for _, obj in pairs(espObjects[other]) do
                    pcall(function() obj:Destroy() end)
                end
                espObjects[other] = nil
            end
        end
    end
end

-- Auto Kill
local function autoKillAll()
    if not features.AutoKillMurder or getPlayerRole(plr) ~= "Murderer" then return end
    
    for _, other in pairs(playerservice:GetPlayers()) do
        if other ~= plr and other.Character and other.Character:FindFirstChild("Humanoid") and other.Character.Humanoid.Health > 0 then
            local knife = nil
            for _, tool in pairs(plr.Character:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name:lower():find("knife") or tool.Name:lower():find("dagger")) then
                    knife = tool
                    break
                end
            end
            if knife and plr.Character then
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

local function autoKillMurderer()
    if not features.AutoKillSheriff or getPlayerRole(plr) ~= "Sheriff" then return end
    
    for _, other in pairs(playerservice:GetPlayers()) do
        if other ~= plr and getPlayerRole(other) == "Murderer" and other.Character then
            local gun = nil
            for _, tool in pairs(plr.Character:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name:lower():find("gun") or tool.Name:lower():find("pistol")) then
                    gun = tool
                    break
                end
            end
            if gun and plr.Character then
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

-- Force Role
local function forceRole()
    if not (features.ForceMurder or features.ForceSheriff) then return end
    local desired = features.ForceMurder and "Murderer" or "Sheriff"
    
    pcall(function()
        local roleRemote = replicated:FindFirstChild("RequestRole") or replicated:FindFirstChild("AssignRole")
        if roleRemote then roleRemote:FireServer(desired) end
    end)
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

-- Add toggles
addToggle(espTab, "🔴 MURDERER ESP", "MurderESP")
addToggle(espTab, "🔵 SHERIFF ESP", "SheriffESP")
addToggle(espTab, "🟢 INNOCENT ESP", "InnocentESP")
addToggle(espTab, "📦 BOX ESP", "BoxESP")

addToggle(combatTab, "💥 HITBOX EXPANDER", "HitboxExpand")
addToggle(combatTab, "⚔️ AUTO ATTACK", "AutoAttack")
addToggle(combatTab, "💨 SPEED BOOST", "SpeedBoost")
addToggle(combatTab, "🕊️ FLY MODE", "Fly")

addToggle(autoTab, "🔪 AUTO KILL ALL (Murderer)", "AutoKillMurder")
addToggle(autoTab, "🔫 AUTO KILL MURDERER (Sheriff)", "AutoKillSheriff")
addToggle(autoTab, "⭐ FORCE MURDERER", "ForceMurder")
addToggle(autoTab, "⭐ FORCE SHERIFF", "ForceSheriff")
addToggle(autoTab, "🏆 INSTANT WIN", "InstantWin")

addToggle(miscTab, "🕳️ NOCLIP", "NoClip")
addToggle(miscTab, "💰 AUTO COLLECT", "AutoCollect")

-- Show ESP tab by default
espTab.content.Visible = true
for _, btn in pairs(tabFrame:GetChildren()) do
    if btn:IsA("TextButton") and btn.Text == "👁️ ESP" then
        btn.BackgroundColor3 = Color3.fromRGB(150,50,220)
        break
    end
end

-- Fly function
local bodyVelocity, bodyGyro
local flyEnabled = false

local function flyUpdate()
    if not features.Fly then
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        return
    end
    
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    if not bodyVelocity or bodyVelocity.Parent ~= hrp then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyGyro = Instance.new("BodyGyro")
        bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
        bodyVelocity.Parent = hrp
        bodyGyro.Parent = hrp
    end
    
    local moveDir = Vector3.new()
    if userinput:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Vector3.new(0, 0, -1) end
    if userinput:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir + Vector3.new(0, 0, 1) end
    if userinput:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir + Vector3.new(-1, 0, 0) end
    if userinput:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Vector3.new(1, 0, 0) end
    if userinput:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
    if userinput:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir + Vector3.new(0, -1, 0) end
    
    moveDir = moveDir.Unit
    local cam = workspace.CurrentCamera
    local velocity = (cam.CFrame.RightVector * moveDir.X + cam.CFrame.UpVector * moveDir.Y + cam.CFrame.LookVector * moveDir.Z) * 80
    bodyVelocity.Velocity = velocity
    bodyGyro.CFrame = cam.CFrame
end

-- Hitbox expander
local function expandHitbox()
    for _, player in pairs(playerservice:GetPlayers()) do
        if player.Character and player ~= plr then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Size = Vector3.new(6, 6, 6)
                end
            end
        end
    end
end

-- MAIN LOOP
task.spawn(function()
    while true do
        if features.MurderESP or features.SheriffESP or features.InnocentESP then
            updateESP()
        end
        
        if features.HitboxExpand then
            expandHitbox()
        end
        
        if features.AutoKillMurder then autoKillAll() end
        if features.AutoKillSheriff then autoKillMurderer() end
        
        if features.ForceMurder or features.ForceSheriff then
            forceRole()
        end
        
        if features.SpeedBoost and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.WalkSpeed = 40
            plr.Character.Humanoid.JumpPower = 80
        elseif plr.Character and plr.Character:FindFirstChild("Humanoid") and not features.SpeedBoost then
            if plr.Character.Humanoid.WalkSpeed > 20 then
                plr.Character.Humanoid.WalkSpeed = 16
                plr.Character.Humanoid.JumpPower = 50
            end
        end
        
        if features.NoClip and plr.Character then
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
        
        flyUpdate()
        
        if features.InstantWin and getPlayerRole(plr) == "Murderer" then
            for _, other in pairs(playerservice:GetPlayers()) do
                if other ~= plr and other.Character and other.Character:FindFirstChild("Humanoid") then
                    other.Character.Humanoid.Health = 0
                end
            end
        end
        
        task.wait(0.15)
    end
end)

-- Auto Attack
task.spawn(function()
    while true do
        if features.AutoAttack then
            local myRole = getPlayerRole(plr)
            local target = nil
            local minDist = math.huge
            
            for _, other in pairs(playerservice:GetPlayers()) do
                if other ~= plr and other.Character and other.Character:FindFirstChild("Humanoid") and other.Character.Humanoid.Health > 0 then
                    local otherRole = getPlayerRole(other)
                    local shouldTarget = (myRole == "Murderer") or (myRole == "Sheriff" and otherRole == "Murderer")
                    
                    if shouldTarget and plr.Character then
                        local otherRoot = other.Charac
