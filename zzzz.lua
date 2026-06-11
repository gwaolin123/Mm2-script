-- Rivals ESP + Aimbot Script
-- Compatible with Delta Executor (Roblox)
-- Controls: RightControl = Toggle ESP, RightShift = Toggle Aimbot

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local espEnabled = true
local aimbotEnabled = true
local aimFOV = 120
local smoothness = 0.2
local checkTeam = false
local visibleCheck = true

local espObjects = {}

local function getPlayers()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(list, plr)
        end
    end
    return list
end

local function createESP(player)
    if espObjects[player] then return end
    local esp = {}
    esp.Box = Drawing.new("Square")
    esp.Box.Thickness = 2
    esp.Box.Filled = false
    esp.Box.Visible = false
    esp.Box.Color = Color3.new(1, 0, 0)
    esp.Name = Drawing.new("Text")
    esp.Name.Outline = true
    esp.Name.Size = 14
    esp.Name.Center = true
    esp.Name.Visible = false
    esp.Distance = Drawing.new("Text")
    esp.Distance.Outline = true
    esp.Distance.Size = 12
    esp.Distance.Center = true
    esp.Distance.Visible = false
    espObjects[player] = esp
end

local function updateESP()
    for player, esp in pairs(espObjects) do
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            esp.Box.Visible = false
            esp.Name.Visible = false
            esp.Distance.Visible = false
        else
            local rootPart = player.Character.HumanoidRootPart
            local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            if onScreen then
                local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude
                local size = 100 / distance * 4
                local boxSize = Vector2.new(size, size * 1.5)
                local boxPos = Vector2.new(vector.X - boxSize.X/2, vector.Y - boxSize.Y/2)
                esp.Box.Position = boxPos
                esp.Box.Size = boxSize
                esp.Box.Visible = espEnabled
                esp.Name.Text = player.Name
                esp.Name.Position = Vector2.new(vector.X, vector.Y - boxSize.Y/2 - 10)
                esp.Name.Visible = espEnabled
                esp.Distance.Text = string.format("%dm", math.floor(distance/3.28))
                esp.Distance.Position = Vector2.new(vector.X, vector.Y + boxSize.Y/2 + 5)
                esp.Distance.Visible = espEnabled
                if checkTeam then
                    esp.Box.Color = player.Team == LocalPlayer.Team and Color3.new(0,1,0) or Color3.new(1,0,0)
                else
                    esp.Box.Color = Color3.new(1,0,0)
                end
            else
                esp.Box.Visible = false
                esp.Name.Visible = false
                esp.Distance.Visible = false
            end
        end
    end
end

local function getClosestPlayer()
    local closest = nil
    local closestDistance = aimFOV
    local mousePos = UserInputService:GetMouseLocation()
    for _, player in ipairs(getPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            if onScreen then
                local screenDist = (Vector2.new(vector.X, vector.Y) - mousePos).Magnitude
                if screenDist < closestDistance then
                    local valid = true
                    if visibleCheck then
                        local ray = Ray.new(Camera.CFrame.Position, (rootPart.Position - Camera.CFrame.Position).unit * 500)
                        local hit = workspace:FindPartOnRay(ray, LocalPlayer.Character)
                        if hit and not hit:IsDescendantOf(player.Character) then
                            valid = false
                        end
                    end
                    if valid then
                        closestDistance = screenDist
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

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
            local targetScreen = Camera:WorldToViewportPoint(rootPart.Position)
            local currentMouse = UserInputService:GetMouseLocation()
            local delta = Vector2.new(targetScreen.X - currentMouse.X, targetScreen.Y - currentMouse.Y)
            mousemoverel(delta.X * smoothness, delta.Y * smoothness)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        espEnabled = not espEnabled
    elseif input.KeyCode == Enum.KeyCode.RightShift then
        aimbotEnabled = not aimbotEnabled
    end
end)

-- Initialize for existing players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end
