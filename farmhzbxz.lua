-- // Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- // Vars
local flyEnabled = false
local noclipEnabled = false
local flySpeed = 1
local flyForce, flyGyro

--====================================================
-- FLY SYSTEM
--====================================================
local function enableFly()
	if flyEnabled then return end
	flyEnabled = true

	flyForce = Instance.new("BodyVelocity")
	flyForce.Velocity = Vector3.new(0, 0, 0)
	flyForce.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	flyForce.Parent = HumanoidRootPart

	flyGyro = Instance.new("BodyGyro")
	flyGyro.CFrame = HumanoidRootPart.CFrame
	flyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	flyGyro.P = 10000
	flyGyro.Parent = HumanoidRootPart

	-- Loop agar tetap mengikuti kamera
	RunService.RenderStepped:Connect(function()
		if flyEnabled and flyForce and flyGyro then
			flyGyro.CFrame = workspace.CurrentCamera.CFrame
			flyForce.Velocity = flyGyro.CFrame.LookVector * (flySpeed * 50)
		end
	end)
end

local function disableFly()
	flyEnabled = false
	if flyForce then flyForce:Destroy() flyForce = nil end
	if flyGyro then flyGyro:Destroy() flyGyro = nil end
end

--====================================================
-- NOCLIP SYSTEM
--====================================================
local function startNoclip()
	task.spawn(function()
		while noclipEnabled and Character.Parent do
			for _, part in pairs(Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
			RunService.Stepped:Wait()
		end
	end)
end

--====================================================
-- LOW GRAPHIC SYSTEM
--====================================================
local function enableLowGraphics()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
			obj:Destroy()
		end
	end
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end

local function disableLowGraphics()
	settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
end

--====================================================
-- GUI (contoh sederhana, bisa kamu rapihin sesuai style)
--====================================================
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "FlyGui"

-- Tombol Fly
local toggleFly = Instance.new("TextButton", ScreenGui)
toggleFly.Text = "Fly"
toggleFly.Size = UDim2.new(0, 100, 0, 30)
toggleFly.Position = UDim2.new(0, 20, 0, 50)

toggleFly.MouseButton1Click:Connect(function()
	if flyEnabled then
		disableFly()
		toggleFly.Text = "Fly"
	else
		enableFly()
		toggleFly.Text = "Stop"
	end
end)

-- Tombol Noclip
local toggleNoclip = Instance.new("TextButton", ScreenGui)
toggleNoclip.Text = "Noclip: OFF"
toggleNoclip.Size = UDim2.new(0, 100, 0, 30)
toggleNoclip.Position = UDim2.new(0, 20, 0, 90)

toggleNoclip.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	if noclipEnabled then
		toggleNoclip.Text = "Noclip: ON"
		startNoclip()
	else
		toggleNoclip.Text = "Noclip: OFF"
	end
end)

-- Tombol Low Graphics
local lowGfx = Instance.new("TextButton", ScreenGui)
lowGfx.Text = "LowGfx"
lowGfx.Size = UDim2.new(0, 100, 0, 30)
lowGfx.Position = UDim2.new(0, 20, 0, 130)

lowGfx.MouseButton1Click:Connect(function()
	if lowGfx.Text == "LowGfx" then
		enableLowGraphics()
		lowGfx.Text = "Normal"
	else
		disableLowGraphics()
		lowGfx.Text = "LowGfx"
	end
end)

-- Tombol Speed +
local plus = Instance.new("TextButton", ScreenGui)
plus.Text = "+"
plus.Size = UDim2.new(0, 50, 0, 30)
plus.Position = UDim2.new(0, 130, 0, 50)

plus.MouseButton1Click:Connect(function()
	flySpeed = flySpeed + 1
end)

-- Tombol Speed -
local minus = Instance.new("TextButton", ScreenGui)
minus.Text = "-"
minus.Size = UDim2.new(0, 50, 0, 30)
minus.Position = UDim2.new(0, 190, 0, 50)

minus.MouseButton1Click:Connect(function()
	if flySpeed > 1 then
		flySpeed = flySpeed - 1
	end
end)
