local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Wizard west hax",
   LoadingTitle = "Wizard west",
   LoadingSubtitle = "by veru",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Wizard west"
   },
})

Rayfield:Notify({
   Title = "menu executed",
   Content = "pozdro",
   Duration = 5,
   Image = 13047715178,
   Actions = { -- Notification Buttons
      Ignore = {
         Name = "Okay!",
         Callback = function()
         print("The user tapped Okay!")
      end
   },
},
})

local MainTab = Window:CreateTab("Main", "code")
local MainSection = MainTab:CreateSection("Main features")

local AimbotTab = Window:CreateTab("Aimbot", "crosshair")
local AimbotSection = AimbotTab:CreateSection("Aimbot")

local VisualsTab = Window:CreateTab("Visuals", "eye")
local VisualsSection = VisualsTab:CreateSection("Visuals")

local CharacterTab = Window:CreateTab("Character", "person-standing")
local CharacterSection = CharacterTab:CreateSection("Character")

local TeleportTab = Window:CreateTab("Teleports", "map-pinned")
local TeleportSection = TeleportTab:CreateSection("Locations")

--Main Window
local AntiAfkCheckBox = MainTab:CreateToggle({
   Name = "Anti-AFK",
   CurrentValue = false,
   Flag = "AntiafkFlag", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
           local vu = game:GetService("VirtualUser")

        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
   end,
})
local InfiniteJump = false

local InfiniteJumpToggle = MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJumpFlag",
    Callback = function(Value)
        InfiniteJump = Value
    end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJump then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

local noclip = false

local NoclipToggle = MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipFlag",
    Callback = function(Value)
        noclip = Value
    end,
})

game:GetService("RunService").Stepped:Connect(function()
    if noclip then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)
--end of main window
----------------------

--Aimbot tab

local AimbotToggle = AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Flag = "AimbotEnableFlag",
    Callback = function(Value)
        if Value then
            local Camera = workspace.CurrentCamera
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local UserInputService = game:GetService("UserInputService")
            local TweenService = game:GetService("TweenService")
            local LocalPlayer = Players.LocalPlayer
            local Holding = false

            _G.AimbotEnabled = true
            _G.TeamCheck = false -- If set to true then the script would only lock your aim at enemy team members.
            _G.AimPart = "Head" -- Where the aimbot script would lock at.
            _G.Sensitivity = 0 -- How many seconds it takes for the aimbot script to officially lock onto the target's aimpart.

            _G.CircleSides = 64 -- How many sides the FOV circle would have.
            _G.CircleColor = Color3.fromRGB(255, 255, 255) -- (RGB) Color that the FOV circle would appear as.
            _G.CircleTransparency = 0.7 -- Transparency of the circle.
            _G.CircleRadius = 80 -- The radius of the circle / FOV.
            _G.CircleFilled = false -- Determines whether or not the circle is filled.
            _G.CircleVisible = true -- Determines whether or not the circle is visible.
            _G.CircleThickness = 0 -- The thickness of the circle.

            local FOVCircle = Drawing.new("Circle")
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            FOVCircle.Radius = _G.CircleRadius
            FOVCircle.Filled = _G.CircleFilled
            FOVCircle.Color = _G.CircleColor
            FOVCircle.Visible = _G.CircleVisible
            FOVCircle.Radius = _G.CircleRadius
            FOVCircle.Transparency = _G.CircleTransparency
            FOVCircle.NumSides = _G.CircleSides
            FOVCircle.Thickness = _G.CircleThickness

            local function GetClosestPlayer()
                local MaximumDistance = _G.CircleRadius
                local Target = nil

                for _, v in next, Players:GetPlayers() do
                    if v.Name ~= LocalPlayer.Name then
                        if _G.TeamCheck == true then
                            if v.Team ~= LocalPlayer.Team then
                                if v.Character ~= nil then
                                    if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                                        if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
                                            local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
                                            local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude

                                            if VectorDistance < MaximumDistance then
                                                Target = v
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            if v.Character ~= nil then
                                if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
                                    if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
                                        local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
                                        local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude

                                        if VectorDistance < MaximumDistance then
                                            Target = v
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                return Target
            end

            UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton2 then
                    Holding = true
                end
            end)

            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton2 then
                    Holding = false
                end
            end)

            RunService.RenderStepped:Connect(function()
                FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                FOVCircle.Radius = _G.CircleRadius
                FOVCircle.Filled = _G.CircleFilled
                FOVCircle.Color = _G.CircleColor
                FOVCircle.Visible = _G.CircleVisible
                FOVCircle.Radius = _G.CircleRadius
                FOVCircle.Transparency = _G.CircleTransparency
                FOVCircle.NumSides = _G.CircleSides
                FOVCircle.Thickness = _G.CircleThickness

                if Holding == true and _G.AimbotEnabled == true then
                    local target = GetClosestPlayer()
                    if target then
                        local targetPart = target.Character[_G.AimPart]
                        if targetPart then
                            local targetPosition = targetPart.Position
                            local cameraCFrame = Camera.CFrame
                            local lookVector = (targetPosition - cameraCFrame.Position).Unit
                            local newCFrame = CFrame.new(cameraCFrame.Position, targetPosition)
                            TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = newCFrame}):Play()
                        end
                    end
                end
            end)
        else
            -- Clean up when disabling the aimbot
            if FOVCircle then
                FOVCircle:Remove()
            end
        end
    end,
})

local AimbotEnabled = AimbotTab:CreateToggle({
    Name = "Enabled",
    CurrentValue = true,
    Flag = "AimbotEnabledFlag",
    Callback = function(Value)
        _G.AimbotEnabled = Value
    end,
})

local TeamCheckToggle = AimbotTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Flag = "TeamCheckFlag",
    Callback = function(Value)
        _G.TeamCheck = Value
    end,
})

local CircleRadiusSlider = AimbotTab:CreateSlider({
    Name = "Circle Radius",
    Range = {1, 360},
    Increment = 1,
    Suffix = "°",
    CurrentValue = 80,
    Flag = "CircleRadiusFlag",
    Callback = function(Value)
        _G.CircleRadius = Value
        if FOVCircle then
            FOVCircle.Radius = Value
        end
    end,
})

local CircleVisibleToggle = AimbotTab:CreateToggle({
    Name = "Circle Visible",
    CurrentValue = true,
    Flag = "CircleVisibleFlag",
    Callback = function(Value)
        _G.CircleVisible = Value
        if FOVCircle then
            FOVCircle.Visible = Value
        end
    end,
})

local CircleThicknessSlider = AimbotTab:CreateSlider({
    Name = "Circle Thickness",
    Range = {0, 10},
    Increment = 1,
    Suffix = "",
    CurrentValue = 0,
    Flag = "CircleThicknessFlag",
    Callback = function(Value)
        _G.CircleThickness = Value
        if FOVCircle then
            FOVCircle.Thickness = Value
        end
    end,
})

--end of aimbot

-------------------------

--Visuals tab

local InfoEspToggle = VisualsTab:CreateToggle({
    Name = "Enable Esp",
    CurrentValue = false,
    Flag = "EspToggleFlag",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local ESPs = {}
local function createESP(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = "ESP"
        BillboardGui.Parent = targetPlayer.Character.Head
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Size = UDim2.new(0, 100, 0, 40)
        BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
 
        local NameTag = Instance.new("TextLabel")
        NameTag.Parent = BillboardGui
        NameTag.BackgroundTransparency = 1
        NameTag.Size = UDim2.new(1, 0, 0.5, 0)
        NameTag.Text = targetPlayer.Name
        NameTag.TextColor3 = Color3.fromRGB(255, 255, 255)
        NameTag.TextStrokeTransparency = 0.5
        NameTag.TextScaled = true
 
        local HealthTag = Instance.new("TextLabel")
        HealthTag.Parent = BillboardGui
        HealthTag.BackgroundTransparency = 1
        HealthTag.Position = UDim2.new(0, 0, 0.5, 0)
        HealthTag.Size = UDim2.new(1, 0, 0.5, 0)
        HealthTag.TextColor3 = Color3.fromRGB(255, 0, 0)
        HealthTag.TextStrokeTransparency = 0.5
        HealthTag.TextScaled = true
 
        game:GetService("RunService").RenderStepped:Connect(function()
            if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
                HealthTag.Text = "HP: " .. math.floor(targetPlayer.Character.Humanoid.Health)
                local distance = (player.Character.HumanoidRootPart.Position - targetPlayer.Character.HumanoidRootPart.Position).magnitude
                NameTag.Text = targetPlayer.Name .. " (" .. math.floor(distance) .. "m)"
            end
        end)
 
        table.insert(ESPs, BillboardGui)
    end
end

 
-- Aplica ESP a todos os jogadores
for _, targetPlayer in pairs(game.Players:GetPlayers()) do
    if targetPlayer ~= player then
        createESP(targetPlayer)
    end
end
 
game.Players.PlayerAdded:Connect(function(targetPlayer)
    targetPlayer.CharacterAdded:Connect(function()
        wait(1)
        createESP(targetPlayer)
    end)
end)
 
-- Função para desativar ESP
local function disableESP()
    for _, esp in pairs(ESPs) do
        esp:Destroy()
    end
    ESPs = {}
end

    end,
})

local BoxESPEnabled = false

-- Create the toggle in your menu
local BoxESP_Toggle = VisualsTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Flag = "BoxESPFlag",
    Callback = function(Value)
        BoxESPEnabled = Value
        if not Value then
            -- Destroy all existing Box ESPs
            for _, esp in pairs(game:GetService("CoreGui"):GetChildren()) do
                if esp.Name == "BoxHandleAdornment" then
                    esp:Destroy()
                end
            end
        end
    end,
})

-- Function to create Box ESP for a player
local function createBoxESP(targetPlayer)
    if not BoxESPEnabled then return end
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "BoxHandleAdornment"
        box.Adornee = targetPlayer.Character.HumanoidRootPart
        box.Size = Vector3.new(2, 3, 1)
        box.Color = Color3.fromRGB(0, 255, 0)
        box.Transparency = 0.5
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Parent = game:GetService("CoreGui")
    end
end

-- Apply Box ESP to existing players
local function applyBoxESP()
    if not BoxESPEnabled then return end
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            createBoxESP(player)
        end
    end
end

-- Connect to new players joining
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1) -- wait for character to load
        createBoxESP(player)
    end)
end)

-- Apply to existing players at start
applyBoxESP()

local TrailToggle = VisualsTab:CreateToggle({
    Name = "Trail Effect",
    CurrentValue = false,
    Flag = "TrailFlag",
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if Value then
                local trail = Instance.new("Trail")
                trail.Name = "CoolTrail"
                trail.Attachment0 = Instance.new("Attachment", char.HumanoidRootPart)
                trail.Attachment1 = Instance.new("Attachment", char.Head)
                trail.Lifetime = 0.5
                trail.Color = ColorSequence.new(Color3.fromRGB(0,255,255))
                trail.Transparency = NumberSequence.new(0,1)
                trail.Parent = char.HumanoidRootPart
            else
                local trail = char.HumanoidRootPart:FindFirstChild("CoolTrail")
                if trail then trail:Destroy() end
            end
        end
    end,
})

--box esp toggle
--skeleton toggle
--chams toggle
--team check
--of course visuals refreshing so if new person joins they will have esp
--end of visuals

--------------------

--Character Tab
--walk speed toggle
--walk speed slider
--fly toggle
--fly keybind
--fly speed
--end of character tab

--Teleport tab
-- to do teleports
--for the quests,spawn

