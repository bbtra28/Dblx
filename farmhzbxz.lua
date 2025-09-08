-- Full LocalScript untuk Fly GUI (Mobile Friendly)
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- ✅ Buat GUI Fly Button
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FlyGUI"
screenGui.ResetOnSpawn = false

local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Parent = screenGui
flyButton.Size = UDim2.new(0, 100, 0, 50)
flyButton.Position = UDim2.new(0.8, 0, 0.8, 0) -- kanan bawah
flyButton.Text = "Fly"
flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.TextScaled = true
flyButton.Font = Enum.Font.GothamBold

-- 🛫 Fly logic
local flying = false
local speed = 50
local bv, bg, conn

local function startFly()
	if flying then return end
	flying = true

	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local hum = char:WaitForChild("Humanoid")
	hum.PlatformStand = true

	bg = Instance.new("BodyGyro")
	bg.P = 9e4
	bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	bg.CFrame = hrp.CFrame
	bg.Parent = hrp

	bv = Instance.new("BodyVelocity")
	bv.Velocity = Vector3.zero
	bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	bv.Parent = hrp

	conn = RS.RenderStepped:Connect(function()
		if not flying then return end

		local moveDir = hum.MoveDirection
		local cam = workspace.CurrentCamera

		-- Arahkan gerakan ke arah kamera (dari thumbstick)
		if moveDir.Magnitude > 0 then
			local moveVector = (cam.CFrame:VectorToWorldSpace(moveDir)).Unit * speed
			bv.Velocity = moveVector
		else
			bv.Velocity = Vector3.zero
		end

		bg.CFrame = cam.CFrame
	end)

	flyButton.Text = "Unfly"
end

local function stopFly()
	flying = false
	local char = player.Character
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.PlatformStand = false
	end
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
	if conn then conn:Disconnect() end

	flyButton.Text = "Fly"
end

-- 🔁 Toggle Fly saat tombol ditekan
flyButton.MouseButton1Click:Connect(function()
	if flying then
		stopFly()
	else
		startFly()
	end
end)

-- 🔄 Reset fly jika karakter respawn
player.CharacterAdded:Connect(function()
	wait(0.5)
	stopFly()
end)
