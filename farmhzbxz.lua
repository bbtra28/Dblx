--// Fly + Noclip GUI Mobile Script with Hide/Close
-- LocalScript taruh di StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local Humanoid = character:WaitForChild("Humanoid")
local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variabel Fly
local flyEnabled = false
local flySpeed = 60
local flyBodyVelocity
local flyBodyGyro

-- Variabel Noclip
local noclipEnabled = false

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyNoclipGui"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 100)
Frame.Position = UDim2.new(0.05, 0, 0.5, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BackgroundTransparency = 0.3
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Tombol Fly
local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0.5, 0, 0.5, 0)
FlyButton.Position = UDim2.new(0, 0, 0, 0)
FlyButton.Text = "Fly: OFF"
FlyButton.TextScaled = true
FlyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlyButton.Parent = Frame

-- Tombol Noclip
local NoclipButton = Instance.new("TextButton")
NoclipButton.Size = UDim2.new(0.5, 0, 0.5, 0)
NoclipButton.Position = UDim2.new(0.5, 0, 0, 0)
NoclipButton.Text = "Noclip: OFF"
NoclipButton.TextScaled = true
NoclipButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
NoclipButton.Parent = Frame

-- Tombol Hide
local HideButton = Instance.new("TextButton")
HideButton.Size = UDim2.new(0.5, 0, 0.5, 0)
HideButton.Position = UDim2.new(0, 0, 0.5, 0)
HideButton.Text = "Hide"
HideButton.TextScaled = true
HideButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
HideButton.Parent = Frame

-- Tombol Close
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0.5, 0, 0.5, 0)
CloseButton.Position = UDim2.new(0.5, 0, 0.5, 0)
CloseButton.Text = "Close"
CloseButton.TextScaled = true
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
CloseButton.Parent = Frame

-- Tombol Show (muncul kalau Hide)
local ShowButton = Instance.new("TextButton")
ShowButton.Size = UDim2.new(0, 100, 0, 40)
ShowButton.Position = UDim2.new(0.05, 0, 0.4, 0)
ShowButton.Text = "Show GUI"
ShowButton.TextScaled = true
ShowButton.Visible = false
ShowButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
ShowButton.Parent = ScreenGui

-- Fungsi Fly
local function startFly()
	if flyBodyVelocity then flyBodyVelocity:Destroy() end
	if flyBodyGyro then flyBodyGyro:Destroy() end

	flyBodyVelocity = Instance.new("BodyVelocity")
	flyBodyVelocity.Velocity = Vector3.zero
	flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	flyBodyVelocity.Parent = HumanoidRootPart

	flyBodyGyro = Instance.new("BodyGyro")
	flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	flyBodyGyro.P = 9000
	flyBodyGyro.CFrame = HumanoidRootPart.CFrame
	flyBodyGyro.Parent = HumanoidRootPart

	task.spawn(function()
		while flyEnabled and character.Parent do
			local moveDir = Humanoid.MoveDirection

			if moveDir.Magnitude > 0 then
				local camCF = workspace.CurrentCamera.CFrame
				local forward = camCF.LookVector
				local right = camCF.RightVector

				local x = moveDir.X
				local z = moveDir.Z

				local dir = (right * x) + (forward * z)
				dir = Vector3.new(dir.X, z, dir.Z)

				if dir.Magnitude > 0 then
					dir = dir.Unit * flySpeed
				end

				moveDir = dir
			end

			flyBodyVelocity.Velocity = moveDir
			flyBodyGyro.CFrame = CFrame.new(
				HumanoidRootPart.Position,
				HumanoidRootPart.Position + workspace.CurrentCamera.CFrame.LookVector
			)

			RunService.Heartbeat:Wait()
		end

		if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
		if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
	end)
end

-- Fungsi Noclip
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

-- Toggle Fly
FlyButton.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	FlyButton.Text = flyEnabled and "Fly: ON" or "Fly: OFF"
	if flyEnabled then
		startFly()
	end
end)

-- Toggle Noclip
NoclipButton.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	NoclipButton.Text = noclipEnabled and "Noclip: ON" or "Noclip: OFF"
	if noclipEnabled then
		startNoclip()
	end
end)

-- Hide GUI
HideButton.MouseButton1Click:Connect(function()
	Frame.Visible = false
	ShowButton.Visible = true
end)

-- Show GUI
ShowButton.MouseButton1Click:Connect(function()
	Frame.Visible = true
	ShowButton.Visible = false
end)

-- Close GUI
CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Update saat respawn
player.CharacterAdded:Connect(function(char)
	character = char
	Humanoid = character:WaitForChild("Humanoid")
	HumanoidRootPart = character:WaitForChild("HumanoidRootPart")
end)
