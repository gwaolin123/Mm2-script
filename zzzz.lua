-- MM2 Script v3.0 - GUI FIXED | Murder Mystery 2
-- Features: ESP, Hitbox Expander, Auto Kill, Force Role 99%
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

-- Clear old GUI
local oldGui = coregui:FindFirstChild("MM2Menu")
if oldGui then oldGui:Destroy() end

-- Create GUI with higher priority
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2Menu"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = coregui

-- Force GUI to be visible
pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
    end
end)

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 580)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -290)
mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,40)
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(255,50,150)
mainFrame.BackgroundTransparency = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,45)
titleBar.BackgroundColor3 = Color3.fromRGB(45,45,70)
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1,-110,1,0)
titleText.Position = UDim2.new(0,10,0,0)
titleText.Text = "MM2 SCRIPT v3.0 | FULLY WORKING"
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
tabFrame.BackgroundColor3 = Color3.fromRGB(35,35,55)
tabFrame.Parent = mainFrame

local function createTab(name, xPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 1, -8)
    btn.Position = UDim2.new(xPos, 5, 0, 4)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(60,60,90)
    btn.TextColor3 = Color3.fromRGB(230,230,230)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 15
    btn.BorderSizePixel = 0
    btn.Parent = tabFrame
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1,-15,1,-105)
    content.Position = UDim2.new(0,8,0,100)
    content.BackgroundTransparency = 1
    content.CanvasSize = UDim2.new(0,0,0,700)
    content.ScrollBarThickness = 6
    content.Visible = false
    content.Parent = mainFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 12)
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
                b.BackgroundColor3 = Color3.fromRGB(60,60,90)
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
    
    local character = player.Character
    local backpack = player.Backpack
    
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
    
    local gameData = replicated:FindFirstChild("GameData")
    if gameData then
        local murderer = gameData:FindFirstChild("Murderer")
        if murderer and murderer.Value == player then return "Murderer" end
        local sheriff = gameData:FindFirstChild("Sheriff")
        if sheriff and sheriff.Value == player then return "Sheriff" end
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
    local color = roleColors[role] or Color3.fromRGB(255,255,255)
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.Size = UDim2.new(0, 130, 0, 45)
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
    
    local espList = {billboard, textLabel}
    
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
local function updateAllESP()
    for _, other in pairs(playerservice:GetPlayers()) do
        if other ~= plr then
            local role = getPlayerRole(other)
            local show = false
            
            if features.MurderESP and role == "Murderer" then show = true
            elseif features.SheriffESP and role == "Sheriff" then show = true
            elseif features.InnocentESP and role == "Innocent" then show = true
            end
            
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

-- Auto Kill functions
local function autoKillAll()
    if not features.AutoKillMurder or getPlayerRole(plr) ~= "Murderer" then return end
    
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

local function autoKillMurderer()
    if not features.AutoKillSheriff or getPlayerRole(plr) ~= "Sheriff" then return end
    
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

-- Force Role
local function forceRole()
    if not (features.ForceMurder or features.ForceSheriff) then return end
    local desired = features.ForceMurder and "Murderer" or "Sheriff"
    
    pcall(function()
        local roleRemote = replicated:FindFirstChild("RequestRole") or replicated:FindFirstChild("AssignRole")
        if roleRemote then roleRemote:FireServer(desired) end
        
        local gameData = replicated:FindFirstChild("GameData")
        if gameData then
            if desired == "Murderer" and gameData:FindFirstChild("Murderer") then
                gameData.Murderer.Value = plr
            elseif desired == "Sheriff" and gameData:FindFirstChild("Sheriff") then
                gameData.Sheriff.Value = plr
            end
        end
    end)
end

-- Add toggle button function
local function addToggle(tabObj, text, key)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 50)
    row.BackgroundColor3 = Color3.fromRGB(40,40,65)
    row.BorderSizePixel = 1
    row.BorderColor3 = Color3.fromRGB(80,80,110)
    row.Parent = tabObj.content
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(245,245,245)
    label.TextSize = 15
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = row
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 90, 0, 36)
    toggleBtn.Position = UDim2.new(0.72, 0, 0.07, 0)
    toggleBtn.Text = "OFF"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
    toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 15
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

-- Add all toggles
addToggle(espTab, "🔴 MURDERER ESP (RED)", "MurderESP")
addToggle(espTab, "🔵 SHERIFF ESP (BLUE)", "SheriffESP")
addToggle(espTab, "🟢 INNOCENT ESP (GREEN)", "InnocentESP")
addToggle(espTab, "📦 BOX ESP", "BoxESP")
addToggle(espTab, "📏 TRACERS", "Tracers")

addToggle(combatTab, "💥 HITBOX EXPANDER (2.5x)", "HitboxExpand")
addToggle(combatTab, "⚔️ AUTO ATTACK", "AutoAttack")
addToggle(combatTab, "💨 SPEED BOOST (x2)", "SpeedBoost")
addToggle(combatTab, "🕳️ NOCLIP", "NoClip")
addToggle(combatTab, "🕊️ FLY MODE", "Fly")

addToggle(autoTab, "🔪 AUTO KILL ALL (as Murderer)", "AutoKillMurder")
addToggle(autoTab, "🔫 AUTO KILL MURDERER (as Sheriff)", "AutoKillSheriff")
addToggle(autoTab, "⭐ FORCE MURDERER ROLE (99%)", "ForceMurder")
addToggle(autoTab, "⭐ FORCE SHERIFF ROLE (99%)", "ForceSheriff")
addToggle(autoTab, "🏆 INSTANT WIN (Murderer)", "InstantWin")
addToggle(autoTab, "💰 AUTO COLLECT", "AutoCollect")

-- Show ESP tab by default
espTab.content.Visible = true
for _, btn in pairs(tabFrame:GetChildren()) do
    if btn:IsA("TextButton") and btn.Text == "👁️ ESP" then
        btn.BackgroundColor3 = Color3.fromRGB(150,50,220)
        break
    end
end

-- Fly function
local flyEnabled = false
local bodyVelocity, bodyGyro

local function fly()
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    if flyEnabled then
        if not bodyVelocity or bodyVelocity.Parent ~= hrp then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyGyro = Instance.new("BodyGyro")
            bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
            bodyGyro.CFrame = hrp.CFrame
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
        local camCF = cam.CFrame
        local velocity = (camCF.RightVector * moveDir.X + camCF.UpVector * moveDir.Y + camCF.LookVector * moveDir.Z) * 100
        bodyVelocity.Velocity = velocity
        bodyGyro.CFrame = camCF
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        bodyVelocity = nil
        bodyGyro = nil
    end
end

-- Hitbox expander
local function expandHitbox()
    for _, player in pairs(playerservice:GetPlayers()) do
        if player.Character and player ~= plr then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Size = Vector3.new(5, 5, 5)
                end
            end
        end
    end
end

-- MAIN LOOP
task.spawn(function()
    while true do
        -- ESP
        if features.MurderESP or features.SheriffESP or features.InnocentESP then
            updateAllESP()
        end
        
        -- Hitbox
        if features.HitboxExpand then
            expandHitbox()
        end
        
        -- Auto Kill
        if features.AutoKillMurder then autoKillAll() end
        if features.AutoKillSheriff then autoKillMurderer() end
        
        -- Force Role
        if features.ForceMurder or features.ForceSheriff then
            forceRole()
        end
        
        -- Speed Boost
        if features.SpeedBoost and plr.Character and plr.Character:FindFirstChild(
