-- LocalScript: Noclip + Fly dengan GUI Draggable
-- Gunakan hanya di game buatanmu sendiri

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local noclipEnabled = false
local flyEnabled = false
local flySpeed = 60

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToolsGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Parent = screenGui

-- draggable manual
local dragging = false
local dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Dev Tools"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

-- tombol toggle
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0.8, 0, 0, 30)
noclipBtn.Position = UDim2.new(0.1, 0, 0.35, 0)
noclipBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
noclipBtn.Text = "Noclip: OFF"
noclipBtn.TextColor3 = Color3.new(1, 1, 1)
noclipBtn.Font = Enum.Font.SourceSansBold
noclipBtn.TextSize = 16
noclipBtn.Parent = frame

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.8, 0, 0, 30)
flyBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
flyBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
flyBtn.Text = "Fly: OFF"
flyBtn.TextColor3 = Color3.new(1, 1, 1)
flyBtn.Font = Enum.Font.SourceSansBold
flyBtn.TextSize = 16
flyBtn.Parent = frame

-- ===== Noclip =====
noclipBtn.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	if noclipEnabled then
		noclipBtn.Text = "Noclip: ON"
		noclipBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	else
		noclipBtn.Text = "Noclip: OFF"
		noclipBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
	end
end)

RunService.Stepped:Connect(function()
	if noclipEnabled and player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- ===== Fly =====
local bv, bg

local function startFly()
	if flyEnabled then return end
	flyEnabled = true
	flyBtn.Text = "Fly: ON"
	flyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not root or not humanoid then return end

	humanoid.PlatformStand = true

	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	bv.Velocity = Vector3.zero
	bv.Parent = root

	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	bg.CFrame = root.CFrame
	bg.Parent = root

	RunService.RenderStepped:Connect(function()
		if flyEnabled and root then
			local cam = workspace.CurrentCamera
			local move = Vector3.zero

			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				move += cam.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				move -= cam.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				move -= cam.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				move += cam.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				move += Vector3.new(0,1,0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				move -= Vector3.new(0,1,0)
			end

			if move.Magnitude > 0 then
				move = move.Unit * flySpeed
			end
			bv.Velocity = move
			bg.CFrame = cam.CFrame
		end
	end)
end

local function stopFly()
	flyEnabled = false
	flyBtn.Text = "Fly: OFF"
	flyBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
	local char = player.Character
	if char then
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if humanoid then humanoid.PlatformStand = false end
	end
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
end

flyBtn.MouseButton1Click:Connect(function()
	if flyEnabled then
		stopFly()
	else
		startFly()
	end
end)