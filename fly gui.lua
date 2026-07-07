local flySpeed = 60
local minSpeed = 30
local maxSpeed = 500

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyControlGui"
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.5, -100, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 2
Frame.Active = true
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 1
TitleBar.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleBottomCover = Instance.new("Frame")
TitleBottomCover.Name = "TitleBottomCover"
TitleBottomCover.Size = UDim2.new(1, 0, 0, 10)
TitleBottomCover.Position = UDim2.new(0, 0, 1, -10)
TitleBottomCover.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBottomCover.BorderSizePixel = 0
TitleBottomCover.ZIndex = 2
TitleBottomCover.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Fly GUI"
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.Font = Enum.Font.Gotham
Title.TextSize = 14
Title.ZIndex = 3
Title.Parent = TitleBar

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0.9, 0, 0, 30)
ToggleButton.Position = UDim2.new(0.05, 0, 0, 40)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "Enable Fly"
ToggleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.TextSize = 12
ToggleButton.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ToggleButton

local SpeedSlider = Instance.new("Frame")
SpeedSlider.Name = "SpeedSlider"
SpeedSlider.Size = UDim2.new(0.9, 0, 0, 50)
SpeedSlider.Position = UDim2.new(0.05, 0, 0, 80)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedSlider.BorderSizePixel = 0
SpeedSlider.Parent = Frame

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0, 6)
SliderCorner.Parent = SpeedSlider

local SpeedText = Instance.new("TextLabel")
SpeedText.Name = "SpeedText"
SpeedText.Size = UDim2.new(1, 0, 0, 20)
SpeedText.Position = UDim2.new(0, 0, 0, 0)
SpeedText.BackgroundTransparency = 1
SpeedText.Text = "Speed: " .. flySpeed
SpeedText.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedText.Font = Enum.Font.Gotham
SpeedText.TextSize = 12
SpeedText.Parent = SpeedSlider

local SliderBar = Instance.new("Frame")
SliderBar.Name = "SliderBar"
SliderBar.Size = UDim2.new(0.9, 0, 0, 6)
SliderBar.Position = UDim2.new(0.05, 0, 0, 25)
SliderBar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
SliderBar.BorderSizePixel = 0
SliderBar.Parent = SpeedSlider

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(0, 3)
BarCorner.Parent = SliderBar

local SliderFill = Instance.new("Frame")
SliderFill.Name = "SliderFill"
SliderFill.Size = UDim2.new((flySpeed - minSpeed) / (maxSpeed - minSpeed), 0, 1, 0)
SliderFill.Position = UDim2.new(0, 0, 0, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBar

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(0, 3)
FillCorner.Parent = SliderFill

local SliderButton = Instance.new("TextButton")
SliderButton.Name = "SliderButton"
SliderButton.Size = UDim2.new(0, 20, 0, 20)
SliderButton.Position = UDim2.new((flySpeed - minSpeed) / (maxSpeed - minSpeed), -10, 0.5, -10)
SliderButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
SliderButton.BorderSizePixel = 0
SliderButton.Text = ""
SliderButton.Parent = SliderBar

local SliderButtonCorner = Instance.new("UICorner")
SliderButtonCorner.CornerRadius = UDim.new(0, 10)
SliderButtonCorner.Parent = SliderButton

-- Collapse Button and Logic
local TweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local CollapseButton = Instance.new("TextButton")
CollapseButton.Name = "CollapseButton"
CollapseButton.Size = UDim2.new(0, 30, 0, 30)
CollapseButton.AnchorPoint = Vector2.new(0.5, 0.5)
CollapseButton.Position = UDim2.new(1, -15, 0, 15) -- Center of 30x30 area at top right
CollapseButton.BackgroundTransparency = 1
CollapseButton.Text = "▼"
CollapseButton.Rotation = 180 -- Pointing UP initially
CollapseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
CollapseButton.Font = Enum.Font.GothamBold
CollapseButton.TextSize = 14
CollapseButton.ZIndex = 5
CollapseButton.Parent = Frame

local collapsed = false
local originalSize = UDim2.new(0, 200, 0, 150)
local collapsedSize = UDim2.new(0, 200, 0, 30)

local collapseTween = TweenService:Create(Frame, tweenInfo, {Size = collapsedSize})
local expandTween = TweenService:Create(Frame, tweenInfo, {Size = originalSize})
local rotateCollapse = TweenService:Create(CollapseButton, tweenInfo, {Rotation = 0})
local rotateExpand = TweenService:Create(CollapseButton, tweenInfo, {Rotation = 180})

CollapseButton.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    if collapsed then
        rotateCollapse:Play()
        TitleBottomCover.Visible = false
        collapseTween:Play()
        
        -- Hide contents after a brief delay
        task.spawn(function()
            task.wait(0.15)
            if collapsed then
                ToggleButton.Visible = false
                SpeedSlider.Visible = false
            end
        end)
    else
        ToggleButton.Visible = true
        SpeedSlider.Visible = true
        rotateExpand:Play()
        TitleBottomCover.Visible = true
        expandTween:Play()
    end
end)

CollapseButton.MouseEnter:Connect(function()
    TweenService:Create(CollapseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)

CollapseButton.MouseLeave:Connect(function()
    TweenService:Create(CollapseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
end)


local flying = false
local flyConnection = nil
local plr = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local function disableFlight()
    if flying then
        flying = false
        ToggleButton.Text = "Enable Fly"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        
        if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
            plr.Character.Humanoid.PlatformStand = false
            
            local bv = plr.Character.HumanoidRootPart:FindFirstChild("VelocityHandler")
            if bv then
                bv.MaxForce = Vector3.new(0, 0, 0)
                bv:Destroy()
            end
            
            local bg = plr.Character.HumanoidRootPart:FindFirstChild("GyroHandler")
            if bg then
                bg.MaxTorque = Vector3.new(0, 0, 0)
                bg:Destroy()
            end
        end
        
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
    end
end

local function enableFlight()
    if not flying then
        flying = true
        ToggleButton.Text = "Disable Fly"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        local camera = Workspace.CurrentCamera
        local controlModule = require(plr.PlayerScripts:WaitForChild('PlayerModule'):WaitForChild("ControlModule"))
        
        -- Create or update BodyVelocity
        local bv = plr.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") or Instance.new("BodyVelocity")
        bv.Name = "VelocityHandler"
        bv.Parent = plr.Character.HumanoidRootPart
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        
        -- Create or update BodyGyro
        local bg = plr.Character.HumanoidRootPart:FindFirstChild("GyroHandler") or Instance.new("BodyGyro")
        bg.Name = "GyroHandler"
        bg.Parent = plr.Character.HumanoidRootPart
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.P = 1000
        bg.D = 50
        
        -- Enable flying
        plr.Character.Humanoid.PlatformStand = true
        
        -- Main flying loop
        flyConnection = rs.RenderStepped:Connect(function()
            if not flying or not plr.Character or not plr.Character:FindFirstChildOfClass("Humanoid") or 
               not plr.Character.Humanoid.RootPart or plr.Character.Humanoid.Health <= 0 or
               not plr.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") or 
               not plr.Character.HumanoidRootPart:FindFirstChild("GyroHandler") then
                disableFlight()
                return
            end
            
            bg.CFrame = camera.CoordinateFrame
            local direction = controlModule:GetMoveVector()
            bv.Velocity = Vector3.new()
            
            if direction.X ~= 0 then
                bv.Velocity = bv.Velocity + camera.CFrame.RightVector * (direction.X * flySpeed)
            end
            if direction.Z ~= 0 then
                bv.Velocity = bv.Velocity - camera.CFrame.LookVector * (direction.Z * flySpeed)
            end
        end)
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    if flying then
        disableFlight()
    else
        enableFlight()
    end
end)

plr.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").Died:Connect(function()
        disableFlight()
    end)
end)

local sliding = false

local function updateSlider(input)
    if sliding then
        local sliderAbsolutePosition = SliderBar.AbsolutePosition
        local sliderAbsoluteSize = SliderBar.AbsoluteSize
        
        local touchPosition
        if input.UserInputType == Enum.UserInputType.Touch then
            touchPosition = input.Position
        else
            touchPosition = UserInputService:GetMouseLocation()
        end
        
        local relativeX = (touchPosition.X - sliderAbsolutePosition.X) / sliderAbsoluteSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        SliderButton.Position = UDim2.new(relativeX, -10, 0.5, -10)
        SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        
        flySpeed = math.floor(minSpeed + (maxSpeed - minSpeed) * relativeX)
        SpeedText.Text = "Speed: " .. flySpeed
    end
end

SliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliding = true
    end
end)

SliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        sliding = true
        updateSlider(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliding = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliding and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        updateSlider(input)
    end
end)

-- Smooth Dragging Logic for the Title Bar
local dragging = false
local dragInput
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)