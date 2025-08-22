local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local flying = false
local hover = false
local speed = 50
local bodyVelocity

-- GUI utama
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 180)
frame.Position = UDim2.new(0.5, -125, 0.7, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Tombol Fly
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(1, -20, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 10)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.Text = "Enable Fly"
flyButton.Font = Enum.Font.SourceSansBold
flyButton.TextSize = 18
flyButton.Parent = frame

-- Tombol Hover
local hoverButton = Instance.new("TextButton")
hoverButton.Size = UDim2.new(1, -20, 0, 30)
hoverButton.Position = UDim2.new(0, 10, 0, 55)
hoverButton.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
hoverButton.TextColor3 = Color3.new(1, 1, 1)
hoverButton.Text = "Enable Hover"
hoverButton.Font = Enum.Font.SourceSansBold
hoverButton.TextSize = 16
hoverButton.Parent = frame

-- Label Speed
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 95)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Text = "Speed: " .. speed
speedLabel.Font = Enum.Font.SourceSansBold
speedLabel.TextSize = 16
speedLabel.Parent = frame

-- Slider Background
local sliderBG = Instance.new("Frame")
sliderBG.Size = UDim2.new(1, -20, 0, 10)
sliderBG.Position = UDim2.new(0, 10, 0, 120)
sliderBG.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
sliderBG.BorderSizePixel = 0
sliderBG.Parent = frame

-- Slider Button
local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 20, 0, 20)
sliderButton.Position = UDim2.new(0.5, -10, -0.5, 0)
sliderButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
sliderButton.Text = ""
sliderButton.Parent = sliderBG

-- Fungsi toggle fly
local function toggleFly()
    flying = not flying
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    if flying then
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0,0,0)
            bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
            bodyVelocity.Parent = root
        end
        flyButton.Text = "Disable Fly"
        flyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    else
        flyButton.Text = "Enable Fly"
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        if not hover then
            if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        end
    end
end

-- Fungsi toggle hover
local function toggleHover()
    hover = not hover
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    if hover then
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0,0,0)
            bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
            bodyVelocity.Parent = root
        end
        hoverButton.Text = "Disable Hover"
        hoverButton.BackgroundColor3 = Color3.fromRGB(200, 80, 30)
    else
        hoverButton.Text = "Enable Hover"
        hoverButton.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
        if not flying then
            if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        end
    end
end

flyButton.MouseButton1Click:Connect(toggleFly)
hoverButton.MouseButton1Click:Connect(toggleHover)

-- Update gerakan fly
RunService.RenderStepped:Connect(function()
    if bodyVelocity then
        if flying then
            local move = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                move = move + (workspace.CurrentCamera.CFrame.LookVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                move = move - (workspace.CurrentCamera.CFrame.LookVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                move = move - (workspace.CurrentCamera.CFrame.RightVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                move = move + (workspace.CurrentCamera.CFrame.RightVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                move = move + Vector3.new(0,1,0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                move = move + Vector3.new(0,-1,0)
            end
            bodyVelocity.Velocity = move * speed
        elseif hover then
            bodyVelocity.Velocity = Vector3.new(0,0,0) -- tetap diam di udara
        end
    end
end)

-- Fungsi slider drag
local dragging = false
sliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mouse = UserInputService:GetMouseLocation().X
        local sliderPos = math.clamp(mouse - sliderBG.AbsolutePosition.X, 0, sliderBG.AbsoluteSize.X)
        sliderButton.Position = UDim2.new(0, sliderPos - sliderButton.AbsoluteSize.X/2, -0.5, 0)

        -- hitung speed dari slider (10 - 200)
        local percent = sliderPos / sliderBG.AbsoluteSize.X
        speed = math.floor(10 + (200 - 10) * percent)
        speedLabel.Text = "Speed: " .. speed
    end
end)