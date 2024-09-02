local success, doesPlayerOwnAsset = pcall(PlayerOwnsAsset, MarketplaceService, player, 912816834)
if doesPlayerOwnAsset then

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local player = game.Players.LocalPlayer
if not player or not player.Character then
    return
end

----                     ----

if game.PlaceId ~= 11156779721 then
    return
end

print("Hello, World!")
for i = 1, 10 do
    print("")
end
----                     ----

local Window = Fluent:CreateWindow({
    Title = "RoskoInf.solutions" .. " | " .. "1.2",
    SubTitle = "by Mr. Winston (@cerberusuwu)",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Player", Icon = "user" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "flip-vertical" }),
    Boat = Window:AddTab({ Title = "Boat", Icon = "sailboat" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "arrow-big-up" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Player

local section = Tabs.Main:AddSection("Movement")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart1 = character:WaitForChild("HumanoidRootPart")
local camera = game.Workspace.CurrentCamera

local isActive = false
local speed = 23
local moveDirection = Vector3.new(0, 0, 0)
local currentVelocity = Vector3.new(0, 0, 0)

local function movePlayer(deltaTime)
    local player = game.Players.LocalPlayer

    while not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") do
        wait(0.1)
    end

    local character = player.Character
    local humanoidRootPart1 = character:FindFirstChild("HumanoidRootPart")

    if not isActive or not character:FindFirstChildOfClass("Humanoid") or character.Humanoid.Sit then
        return
    end
    
    local cameraCFrame = camera.CFrame
    local newMoveDirection = Vector3.new(0, 0, 0)

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        newMoveDirection = newMoveDirection + cameraCFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        newMoveDirection = newMoveDirection - cameraCFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        newMoveDirection = newMoveDirection - cameraCFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        newMoveDirection = newMoveDirection + cameraCFrame.RightVector
    end

    if newMoveDirection.magnitude > 0 then
        newMoveDirection = newMoveDirection.Unit * speed
        local targetVelocity = newMoveDirection * deltaTime
        currentVelocity = currentVelocity:Lerp(targetVelocity, 0.1)

        local currentY = humanoidRootPart1.Position.Y

        local newPosition = humanoidRootPart1.Position + Vector3.new(currentVelocity.X, 0, currentVelocity.Z)
        
        local ray = Ray.new(humanoidRootPart1.Position, currentVelocity)
        local hit, hitPosition = workspace:FindPartOnRay(ray, character)

        if hit then
            newPosition = hitPosition
            newPosition = Vector3.new(newPosition.X, currentY, newPosition.Z)
        end

        humanoidRootPart1.CFrame = CFrame.new(newPosition, newPosition + Vector3.new(currentVelocity.X, 0, currentVelocity.Z))
    else
        currentVelocity = currentVelocity:Lerp(Vector3.new(0, 0, 0), 0.1)
    end
end

local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Speed", Default = false})

Toggle:OnChanged(function()
    isActive = Toggle.Value
end)

RunService.RenderStepped:Connect(movePlayer)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")

local flying = false
local flyConnection
local toggleEnabled = false

function startFlying()
    local playerTorso = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not playerTorso then return end
    
    flying = true
    flyConnection = runService.RenderStepped:Connect(function()
        if flying and playerTorso then
            local direction = (mouse.Hit.p - playerTorso.Position).unit
            playerTorso.Velocity = direction * 50
        end
    end)
end

function stopFlying()
    flying = false
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    local playerTorso = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if playerTorso then
        playerTorso.Velocity = Vector3.new(0, 0, 0)
    end
end

local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Fly [Left Mouse]", Default = false})

Toggle:OnChanged(function(state)
    toggleEnabled = state
    if not toggleEnabled then
        stopFlying()
    end
end)

mouse.Button1Down:Connect(function()
    if toggleEnabled then
        startFlying()
    end
end)

mouse.Button1Up:Connect(function()
    stopFlying()
end)

--

local section = Tabs.Main:AddSection("Auto Pickup")

local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local player = game.Players.LocalPlayer
local isEnabled34 = false

local function handlePickup()
    if not isEnabled34 then
        return
    end

    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

    for _, item in pairs(workspace:WaitForChild("droppedItems"):GetChildren()) do
        if item:IsA("BasePart") and (item.Position - rootPart.Position).Magnitude <= 9 then
            item.CFrame = rootPart.CFrame
        end
    end
end

RunService.RenderStepped:Connect(function()
    handlePickup()
end)

local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Auto Pickup", Default = false})

Toggle:OnChanged(function(state)
    isEnabled34 = state
end)


local section = Tabs.Main:AddSection("Other")

local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "No FallDamage", Default = false })

local originalfallDamage = nil

Toggle:OnChanged(function()
    if Toggle.Value then
        if player.Character and player.Character:FindFirstChild("fallDamage") then
            originalfallDamage = player.Character.fallDamage:Clone()
            player.Character.fallDamage:Destroy()
        end
    else
        if originalfallDamage then
            originalfallDamage.Parent = player.Character
            originalfallDamage = nil
        end
    end
end)

Toggle:SetValue(false)

local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Inf Stamina", Default = false })

local originalStamina = nil

Toggle:OnChanged(function()
    if Toggle.Value then
        if player.Character and player.Character:FindFirstChild("stamina") then
            originalStamina = player.Character.stamina:Clone()
            player.Character.stamina:Destroy()
        end
    else
        if originalStamina then
            originalStamina.Parent = player.Character
            originalStamina = nil
        end
    end
end)

Toggle:SetValue(false)

-- Visual

local section = Tabs.Visual:AddSection("Esp")

local ESPEnabled = false
local HighlightColor = Color3.fromRGB(150, 0, 0)


local function addEsp(character)
    local localPlayer = game.Players.LocalPlayer
    if (character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).magnitude then
        if not character:FindFirstChild("ESPHighlight") then
            local newHighlight = Instance.new("Highlight")
            newHighlight.Name = "ESPHighlight"
            newHighlight.Parent = character
            newHighlight.OutlineColor = HighlightColor
            newHighlight.FillTransparency = 1
        end
    end
end

local function removeEsp(character)
    local highlight = character:FindFirstChild("ESPHighlight")
    if highlight then
        highlight:Destroy()
    end
end

local function updateEsp()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            if ESPEnabled then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    addEsp(player.Character)
                end
            else
                if player.Character then
                    removeEsp(player.Character)
                end
            end
        end
    end
end

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if ESPEnabled and character:FindFirstChild("HumanoidRootPart") then
            addEsp(character)
        end
    end)
end)

game.Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        removeEsp(player.Character)
    end
end)

local Toggle = Tabs.Visual:AddToggle("MyToggle", {Title = "ESP", Default = false})

Toggle:OnChanged(function(value)
    ESPEnabled = value
    updateEsp()
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if ESPEnabled then
        updateEsp()
    end
end)

updateEsp()

local section = Tabs.Visual:AddSection("Esp/Settings")

local Colorpicker = Tabs.Visual:AddColorpicker("Colorpicker", {
    Title = "Color Esp",
    Default = HighlightColor
})

Colorpicker:OnChanged(function()
    HighlightColor = Colorpicker.Value
end)

-- Boat

local function teleportToRandomRaft()
    local rafts = game:GetService("Workspace").boats:GetChildren()

    if #rafts == 0 then
        warn("В игре нет кораблей")
        return
    end

    local randomIndex = math.random(1, #rafts)
    local randomRaft = rafts[randomIndex]

    local vehicleSeat = randomRaft:FindFirstChild("VehicleSeat")

    if vehicleSeat then
        local localPlayer = game:GetService("Players").LocalPlayer
        localPlayer.Character:SetPrimaryPartCFrame(vehicleSeat.CFrame)
    else
        warn("На выбранной корабле нет места водителя")
    end
end

local section = Tabs.Boat:AddSection("Teleport/Boat")

Tabs.Boat:AddButton({
    Title = "Get random boat",
    Callback = function()
        teleportToRandomRaft()
    end
})

local section = Tabs.Boat:AddSection("Teleport/Island")

Tabs.Boat:AddButton({
    Title = "Boat teleport to mainisland",
    Callback = function()
    if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RootPart.CFrame = CFrame.new(Vector3.new(-318, 18, 200))
        end
    end
})

Tabs.Boat:AddButton({
    Title = "Boat teleport to desert",
    Callback = function()
    if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RootPart.CFrame = CFrame.new(Vector3.new(1224, 18, -253))
        end
    end
})

Tabs.Boat:AddButton({
    Title = "Boat teleport to jungle",
    Callback = function()
    if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RootPart.CFrame = CFrame.new(Vector3.new(-1893, 18, 395))
        end
    end
})

Tabs.Boat:AddButton({
    Title = "Boat teleport to volcano",
    Callback = function()
    if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RootPart.CFrame = CFrame.new(Vector3.new(1599, 18, 1855))
        end
    end
})

-- Teleport

local section = Tabs.Teleport:AddSection("Teleport")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Dropdown = Tabs.Teleport:AddDropdown("Dropdown", {
    Title = "Teleport to player",
    Values = {"NONE"},
    Multi = false,
    Default = "none",
})

local function UpdatePlayerList()
    local playerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    Dropdown:SetValues(playerNames)
end

UpdatePlayerList()

Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

Dropdown:OnChanged(function(Value)
    local targetPlayer = Players:FindFirstChild(Value)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:MoveTo(targetPlayer.Character.HumanoidRootPart.Position)
    end
end)

local section = Tabs.Teleport:AddSection("Teleport/Boss")

Tabs.Teleport:AddButton({
    Title = "Teleport to Titan Boss",
    Callback = function()
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RootPart.CFrame = CFrame.new(1670, 46, 2290)
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Kraken",
    Callback = function()
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RootPart.CFrame = CFrame.new(803, -104, -2196)
    end
})

-- Settings

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()

end
