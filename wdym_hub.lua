local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- Settings
local NAME_KEYWORDS = { "SmallSafe", "MediumSafe" }
local HIGHLIGHT_NAME = "SafeESP"
local ADMIN_HIGHLIGHT_NAME = "AdminESP"
local ADMIN_LIST = {
    ["tabootvcat"] = true, ["Revenantic"] = true, ["Saabor"] = true, ["MoIitor"] = true,
    ["IAmUnderAMask"] = true, ["SheriffGorji"] = true, ["xXFireyScorpionXx"] = true,
    ["LoChips"] = true, ["DeliverCreations"] = true, ["TDXiswinning"] = true,
    ["TZZV"] = true, ["FelixVenue"] = true, ["SIEGFRlED"] = true, ["ARRYvvv"] = true,
    ["z_papermoon"] = true, ["Malpheasance"] = true, ["ModHandIer"] = true,
    ["valphex"] = true, ["J_anday"] = true, ["tvdisko"] = true, ["yIlehs"] = true,
    ["COLOSSUSBUILTOFSTEEL"] = true, ["SeizedHolder"] = true, ["r3shape"] = true,
    ["RVVZ"] = true, ["adurize"] = true, ["codedcosmetics"] = true,
    ["QuantumCaterpillar"] = true, ["FractalHarmonics"] = true, ["GalacticSculptor"] = true,
    ["oTheSilver"] = true, ["Kretacaous"] = true, ["icarus_xs1goliath"] = true,
    ["GlamorousDradon"] = true, ["rainjeremy"] = true, ["parachuter2000"] = true,
    ["faintermercury"] = true, ["harht"] = true, ["Sansek1252"] = true,
    ["Snorpuwu"] = true, ["BenAzoten"] = true, ["Cand1ebox"] = true, ["KeenlyAware"] = true,
    ["mrzued"] = true, ["BruhmanVIII"] = true, ["Nystesia"] = true, ["fausties"] = true,
    ["zateopp"] = true, ["Iordnabi"] = true, ["ReviveTheDevil"] = true, ["jake_jpeg"] = true,
    ["UncrossedMeat3888"] = true, ["realpenyy"] = true, ["karateeeh"] = true,
    ["JayyMlg"] = true, ["Lo_Chips"] = true, ["Avelosky"] = true, ["king_ab09"] = true,
    ["TigerLe123"] = true, ["Dalvanuis"] = true, ["iSonMillions"] = true,
    ["Cefasin"] = true, ["ulzig"] = true, ["DieYouOder"] = true, ["whosframed"] = true, 
    ["Idont_HavePizza"] = true, ["b3THyb1T3z"] = true
}

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedESP_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Main Menu
local menuFrame = Instance.new("Frame")
menuFrame.Name = "MenuFrame"
menuFrame.Size = UDim2.new(0, 280, 0, 270)
menuFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.BorderSizePixel = 0
menuFrame.BackgroundTransparency = 0.1
menuFrame.Visible = true
menuFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = menuFrame

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.Parent = menuFrame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 15)
padding.PaddingLeft = UDim.new(0, 20)
padding.PaddingRight = UDim.new(0, 20)
padding.Parent = menuFrame

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "ADVANCED ESP MENU"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1
title.Parent = menuFrame

-- Function to create styled buttons
local function createStyledButton(name, text, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = color
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.AutoButtonColor = true
    button.Parent = menuFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button

    return button
end

-- Create buttons
local buttonDestroy = createStyledButton("DestroyButton", "💀 DESTROY SCRIPT", Color3.fromRGB(150, 0, 0))
local buttonFind = createStyledButton("FindButton", "🔍 Find Safes", Color3.fromRGB(40, 170, 70))
local buttonAdminCheck = createStyledButton("AdminCheckButton", "👑 Admin Check: OFF", Color3.fromRGB(120, 80, 200))
local buttonAdminESP = createStyledButton("AdminESPButton", "👁️‍🗨️ Admin ESP: ON", Color3.fromRGB(200, 80, 120))
local buttonClear = createStyledButton("ClearButton", "❌ Clear Highlights", Color3.fromRGB(170, 40, 40))

-- State variables
local adminCheckEnabled = false
local espEnabled = true
local adminHighlights = {}
local safeHighlights = {}

-- Function to get display name (with RVVZ replacement)
local function getDisplayName(player)
    if player.Name == "Idont_HavePizza" then
        return "RVVZ"
    end
    return player.Name
end

-- Function to show admin alert (only shows when adminCheckEnabled is true)
local function showAdminAlert(playerName)
    if not adminCheckEnabled then return end
    
    local alert = Instance.new("TextLabel")
    alert.Name = "AdminAlert"
    alert.Size = UDim2.new(0, 300, 0, 50)
    alert.Position = UDim2.new(0.5, -150, 0.1, 0)
    alert.AnchorPoint = Vector2.new(0.5, 0)
    alert.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    alert.Text = "ADMIN DETECTED (" .. (playerName == "Idont_HavePizza" and "RVVZ" or playerName) .. ")"
    alert.TextColor3 = Color3.new(1, 1, 1)
    alert.Font = Enum.Font.GothamBold
    alert.TextSize = 18
    alert.BackgroundTransparency = 0.3
    alert.Parent = screenGui

    local alertCorner = Instance.new("UICorner")
    alertCorner.CornerRadius = UDim.new(0, 8)
    alertCorner.Parent = alert

    delay(5, function()
        alert:Destroy()
    end)
end

-- Remove Highlight
local function removeHighlight(target, highlightName)
    local highlight = target:FindFirstChild(highlightName)
    if highlight then
        highlight:Destroy()
    end
end

-- Create Highlight
local function createHighlight(target, highlightName, color)
    removeHighlight(target, highlightName)
    
    local highlight = Instance.new("Highlight")
    highlight.Name = highlightName
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = target
    
    return highlight
end

-- Check object name
local function matchesTargetName(name)
    for _, keyword in ipairs(NAME_KEYWORDS) do
        if name:find(keyword) then
            return true
        end
    end
    return false
end

-- Check if broken
local function isBroken(obj)
    local valuesFolder = obj:FindFirstChild("Values")
    if valuesFolder then
        local brokenValue = valuesFolder:FindFirstChild("Broken")
        if brokenValue and brokenValue:IsA("BoolValue") then
            return brokenValue.Value
        end
    end
    return false
end

-- Check if admin
local function isAdmin(player)
    return ADMIN_LIST[player.Name] == true
end

-- Create Admin ESP (with RVVZ name replacement)
local function createAdminESP(player)
    if not player.Character then return end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local color = Color3.fromRGB(255, 0, 0) -- Always red for admins
    local highlight = createHighlight(character, ADMIN_HIGHLIGHT_NAME, color)
    
    -- Name tag with RVVZ replacement
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "AdminNameTag"
    billboardGui.Adornee = humanoidRootPart
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = getDisplayName(player) -- Uses the name replacement function
    textLabel.TextColor3 = color
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 18
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextStrokeColor3 = Color3.new(0,0,0)
    textLabel.Parent = billboardGui
    
    billboardGui.Parent = character
    
    adminHighlights[player] = {highlight = highlight, billboard = billboardGui}
    
    -- Show admin alert (only if admin check is enabled)
    showAdminAlert(player.Name)
end

-- Destroy Admin ESP
local function destroyAdminESP(player)
    if adminHighlights[player] then
        if adminHighlights[player].highlight then 
            adminHighlights[player].highlight:Destroy()
        end
        if adminHighlights[player].billboard then 
            adminHighlights[player].billboard:Destroy()
        end
        adminHighlights[player] = nil
    end
end

-- Find and highlight safes
local function scanSafes()
    local healthyCount = 0
    local processed = {}

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if matchesTargetName(obj.Name) then
            local target = obj:IsA("BasePart") and obj:FindFirstAncestorOfClass("Model") or obj
            
            if not processed[target] then
                processed[target] = true
                removeHighlight(target, HIGHLIGHT_NAME)

                local color = isBroken(target) and Color3.fromRGB(255, 0, 0) or Color3.new(1, 1, 1)
                safeHighlights[target] = createHighlight(target, HIGHLIGHT_NAME, color)
                
                if not isBroken(target) then
                    healthyCount = healthyCount + 1
                end
            end
        end
    end

    buttonFind.Text = "✅ Intact Safes: " .. healthyCount
    task.delay(2, function()
        buttonFind.Text = "🔍 Find Safes"
    end)
end

-- Clear all highlights
local function removeAllHighlights()
    for model, _ in pairs(safeHighlights) do
        removeHighlight(model, HIGHLIGHT_NAME)
    end
    safeHighlights = {}

    for player, _ in pairs(adminHighlights) do
        destroyAdminESP(player)
    end
    adminHighlights = {}

    buttonClear.Text = "✔️ Highlights Cleared"
    task.delay(2, function()
        buttonClear.Text = "❌ Clear Highlights"
    end)
end

-- Update Admin ESP
local function updateAdminESP()
    if not espEnabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and isAdmin(player) then
            if not adminHighlights[player] and player.Character then
                createAdminESP(player)
            elseif adminHighlights[player] and not player.Character then
                destroyAdminESP(player)
            end
        elseif adminHighlights[player] then
            destroyAdminESP(player)
        end
    end
end

-- Toggle Admin Check
local function toggleAdminCheck()
    adminCheckEnabled = not adminCheckEnabled
    buttonAdminCheck.Text = "👑 Admin Check: " .. (adminCheckEnabled and "ON" or "OFF")
end

-- Toggle Admin ESP
local function toggleESP()
    espEnabled = not espEnabled
    buttonAdminESP.Text = "👁️‍🗨️ Admin ESP: " .. (espEnabled and "ON" or "OFF")
    
    if espEnabled then
        updateAdminESP()
    else
        for player, _ in pairs(adminHighlights) do
            destroyAdminESP(player)
        end
    end
end

-- Destroy script completely
local function destroyScript()
    removeAllHighlights()
    screenGui:Destroy()
    
    for _, connection in ipairs(getconnections(RunService.Heartbeat)) do
        connection:Disconnect()
    end
end

-- Button handlers
buttonDestroy.MouseButton1Click:Connect(destroyScript)
buttonFind.MouseButton1Click:Connect(scanSafes)
buttonAdminCheck.MouseButton1Click:Connect(toggleAdminCheck)
buttonAdminESP.MouseButton1Click:Connect(toggleESP)
buttonClear.MouseButton1Click:Connect(removeAllHighlights)

-- Handle new players
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        if espEnabled and isAdmin(player) then
            createAdminESP(player)
        end
    end)
    
    if espEnabled and isAdmin(player) and player.Character then
        createAdminESP(player)
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)

-- Automatic updates
RunService.Heartbeat:Connect(function()
    if espEnabled then
        updateAdminESP()
    end
end)

-- Initial admin check
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer and isAdmin(player) then
        if espEnabled and player.Character then
            createAdminESP(player)
        end
    end
end
