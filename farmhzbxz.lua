--// Fly GUI V3 (Full) by me_ozone & Quandale The Dinglish XII#3550

-- Instances
local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local toggleFly = Instance.new("TextButton")
local toggleNoclip = Instance.new("TextButton")
local title = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speedLabel = Instance.new("TextLabel")
local minus = Instance.new("TextButton")
local closeButton = Instance.new("TextButton")
local minimize = Instance.new("TextButton")
local expand = Instance.new("TextButton")
local lowGfx = Instance.new("TextButton")

-- Variables
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local flyEnabled = false
local flySpeed = 1
local noclipEnabled = false
local character = player.Character or player.CharacterAdded:Wait()

-- GUI Setup
main.Name = "FlyGuiV3"
main.Parent = player:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.1, 0, 0.38, 0)
Frame.Size = UDim2.new(0, 210, 0, 120)
Frame.Active = true
Frame.Draggable = true

-- Title
title.Parent = Frame
title.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
title.Position = UDim2.new(0.25, 0, 0, 0)
title.Size = UDim2.new(0, 100, 0, 28)
title.Font = Enum.Font.SourceSans
title.Text = "Fly GUI V3"
title.TextColor3 = Color3.fromRGB(0, 0, 0)
title.TextScaled = true

-- Toggle Fly
toggleFly.Parent = Frame
toggleFly.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
toggleFly.Position = UDim2.new(0.7, 0, 0.5, 0)
toggleFly.Size = UDim2.new(0, 56, 0, 28)
toggleFly.Text = "Fly"
toggleFly.TextColor3 = Color3.fromRGB(0, 0, 0)

-- Toggle Noclip
toggleNoclip.Parent = Frame
toggleNoclip.BackgroundColor3 = Color3.fromRGB(180, 255, 180)
toggleNoclip.Position = UDim2.new(0.7, 0, 0.25, 0)
toggleNoclip.Size = UDim2.new(0, 56, 0, 28)
toggleNoclip.Text = "Noclip"
toggleNoclip.TextColor3 = Color3.fromRGB(0, 0, 0)

-- Up Button
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Size = UDim2.new(0, 44, 0, 28)
up.Text = "↑"

-- Down Button
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0.5, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Text = "↓"

-- Speed Buttons
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0.23, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Text = "+"

minus.Parent = Frame
minus.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
minus.Position = UDim2.new(0.23, 0, 0.5, 0)
minus.Size = UDim2.new(0, 45, 0, 28)
minus.Text = "-"

speedLabel.Parent = Frame
speedLabel.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speedLabel.Position = UDim2.new(0.47, 0, 0.5, 0)
speedLabel.Size = UDim2.new(0, 44, 0, 28)
speedLabel.Text = tostring(flySpeed)

-- Close Button
closeButton.Parent = Frame
closeButton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closeButton.Size = UDim2.new(0, 45, 0, 28)
closeButton.Position = UDim2.new(0, 0, -1, 27)
closeButton.Text = "X"

-- Minimize
minimize.Parent = Frame
minimize.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
minimize.Size = UDim2.new(0, 45, 0, 28)
minimize.Position = UDim2.new(0, 44, -1, 27)
minimize.Text = "-"

expand.Parent = Frame
expand.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
expand.Size = UDim2.new(0, 45, 0, 28)
expand.Position = UDim2.new(0, 44, -1, 57)
expand.Text = "+"
expand.Visible = false

-- Low Graphics
lowGfx.Parent = Frame
lowGfx.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
lowGfx.Position = UDim2.new(0.7, 0, 0, 0)
lowGfx.Size = UDim2.new(0, 56, 0, 28)
lowGfx.Text = "LowGfx"

--// FUNCTIONS

-- Noclip
local function startNoclip()
	task.spawn(function()
		while noclipEnabled and character.Parent do
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
			RunService.Stepped:Wait()
		end
	end)
end

-- Fly
local BV, BG
local function enableFly()
	if flyEnabled then return end
	flyEnabled = true
	local hrp = character:WaitForChild("HumanoidRootPart")

	BV = Instance.new("BodyVelocity")
	BV.Velocity = Vector3.new(0, 0, 0)
	BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	BV.Parent = hrp

	BG = Instance.new("BodyGyro")
	BG.CFrame = hrp.CFrame
	BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	BG.P = 10000
	BG.Parent = hrp

	RunService.RenderStepped:Connect(function()
		if flyEnabled and hrp then
			local camCF = workspace.CurrentCamera.CFrame
			local move = Vector3.new()

			if UIS:IsKeyDown(Enum.KeyCode.W) then move += camCF.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then move -= camCF.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then move -= camCF.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then move += camCF.RightVector end

			BV.Velocity = move * flySpeed * 50
			BG.CFrame = camCF
		end
	end)
end

local function disableFly()
	flyEnabled = false
	if BV then BV:Destroy() BV = nil end
	if BG then BG:Destroy() BG = nil end
end

--// BUTTON EVENTS

toggleFly.MouseButton1Click:Connect(function()
	if flyEnabled then
		disableFly()
		toggleFly.Text = "Fly"
	else
		enableFly()
		toggleFly.Text = "Stop"
	end
end)

toggleNoclip.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	if noclipEnabled then
		toggleNoclip.Text = "Noclip: ON"
		startNoclip()
	else
		toggleNoclip.Text = "Noclip: OFF"
	end
end)

up.MouseButton1Click:Connect(function()
	if character:FindFirstChild("HumanoidRootPart") then
		character.HumanoidRootPart.CFrame *= CFrame.new(0, 5, 0)
	end
end)

down.MouseButton1Click:Connect(function()
	if character:FindFirstChild("HumanoidRootPart") then
		character.HumanoidRootPart.CFrame *= CFrame.new(0, -5, 0)
	end
end)

plus.MouseButton1Click:Connect(function()
	flySpeed += 1
	speedLabel.Text = tostring(flySpeed)
end)

minus.MouseButton1Click:Connect(function()
	if flySpeed > 1 then
		flySpeed -= 1
		speedLabel.Text = tostring(flySpeed)
	end
end)

closeButton.MouseButton1Click:Connect(function()
	main:Destroy()
end)

minimize.MouseButton1Click:Connect(function()
	for _, obj in ipairs(Frame:GetChildren()) do
		if obj:IsA("TextButton") or obj:IsA("TextLabel") then
			if obj ~= minimize and obj ~= expand then
				obj.Visible = false
			end
		end
	end
	minimize.Visible = false
	expand.Visible = true
	Frame.BackgroundTransparency = 1
end)

expand.MouseButton1Click:Connect(function()
	for _, obj in ipairs(Frame:GetChildren()) do
		obj.Visible = true
	end
	expand.Visible = false
	Frame.BackgroundTransparency = 0
end)

-- Low Graphics Toggle
lowGfx.MouseButton1Click:Connect(function()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
			obj:Destroy()
		end
	end
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "Fly GUI V3",
	Text = "Loaded Successfully!",
	Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150",
	Duration = 5
})
