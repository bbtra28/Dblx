-- Fly Script with GUI Toggle + Speed Slider
-- Buat game sendiri (bukan cheat)

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "FlyGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Fly Toggle Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 120, 0, 40)
button.Position = UDim2.new(0.05, 0, 0.1, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.Text = "Enable Fly"
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.Parent = gui

-- Speed Slider Frame
local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(0, 200, 0, 40)
sliderFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderFrame.Parent = gui

-- Slider Bar
local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(1, 0, 0.3, 0)
sliderBar.Position = UDim2.new(0, 0, 0.35, 0)
sliderBar.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
sliderBar.Parent = sliderFrame

-- Slider Button
local sliderBtn = Instance.new("Frame")
sliderBtn.Size = UDim2.new(0, 10, 1.5, 0)
sliderBtn.Position = UDim2.new(0, 0, -0.25, 0)
sliderBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sliderBtn.Parent = sliderBar
sliderBtn.Active = true
sliderBtn.Draggable = true

-- Speed Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 1, 0)
speedLabel.Position = UDim2.new(0, 0, -1.2, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Font = Enum.Font.SourceSansBold
speedLabel.TextSize = 16
speedLabel.Text = "Speed: 60"
speedLabel.Parent = sliderFrame

-- Fly variables
local flying = false
local speed = 60
local minSpeed, maxSpeed = 20, 200

-- Toggle Fly
button.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		button.Text = "Disable Fly"
		button.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
	else
		button.Text = "Enable Fly"
		button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		hrp.Velocity = Vector3.zero
	end
end)

-- Slider Update
local function updateSpeed()
	local percent = math.clamp(sliderBtn.Position.X.Scale, 0, 1)
	speed = math.floor(minSpeed + (maxSpeed - minSpeed) * percent)
	speedLabel.Text = "Speed: " .. tostring(speed)
end

sliderBtn:GetPropertyChangedSignal("Position"):Connect(updateSpeed)

-- Fly movement loop
RS.Heartbeat:Connect(function()
	if flying then
		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then
			dir += workspace.CurrentCamera.CFrame.LookVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.S) then
			dir -= workspace.CurrentCamera.CFrame.LookVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.A) then
			dir -= workspace.CurrentCamera.CFrame.RightVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.D) then
			dir += workspace.CurrentCamera.CFrame.RightVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then
			dir += Vector3.new(0,1,0)
		end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
			dir -= Vector3.new(0,1,0)
		end

		if dir.Magnitude > 0 then
			hrp.Velocity = dir.Unit * speed
		else
			hrp.Velocity = Vector3.zero
		end
	end
end)