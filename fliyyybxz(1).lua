--// GUI Fly Script (Final Clean + Keybind + HUD) //--

--// GUI Setup
local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

-- HUD status
local HUD = Instance.new("TextLabel")

main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

-- Fly control panel
Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.1, 0, 0.38, 0)
Frame.Size = UDim2.new(0, 190, 0, 57)
Frame.Active = true
Frame.Draggable = true

-- HUD Setup
HUD.Parent = main
HUD.Size = UDim2.new(0, 200, 0, 30)
HUD.Position = UDim2.new(0, 10, 0, 10) -- pojok kiri atas
HUD.BackgroundTransparency = 1
HUD.Text = "Fly: OFF | Speed: 1"
HUD.TextColor3 = Color3.fromRGB(255, 255, 255)
HUD.TextStrokeTransparency = 0.5
HUD.Font = Enum.Font.SourceSansBold
HUD.TextSize = 20
HUD.TextXAlignment = Enum.TextXAlignment.Left

-- (disingkat: button setup sama seperti sebelumnya)

--// Variables
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local flying = false
local speedValue = 1
local velocity
local gyro
local uis = game:GetService("UserInputService")

--// Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "FLY SCRIPT",
	Text = "By Glitch (HUD + Keybind F)",
	Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150",
	Duration = 5
})

--// Functions
local function updateHUD()
	HUD.Text = "Fly: " .. (flying and "ON" or "OFF") .. " | Speed: " .. tostring(speedValue)
end

local function startFly()
	if flying then return end
	flying = true

	gyro = Instance.new("BodyGyro")
	gyro.P = 9e4
	gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	gyro.CFrame = hrp.CFrame
	gyro.Parent = hrp

	velocity = Instance.new("BodyVelocity")
	velocity.Velocity = Vector3.zero
	velocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	velocity.Parent = hrp

	game:GetService("RunService").RenderStepped:Connect(function()
		if flying then
			gyro.CFrame = workspace.CurrentCamera.CFrame
			local move = Vector3.zero
			if uis:IsKeyDown(Enum.KeyCode.W) then
				move += workspace.CurrentCamera.CFrame.LookVector
			end
			if uis:IsKeyDown(Enum.KeyCode.S) then
				move -= workspace.CurrentCamera.CFrame.LookVector
			end
			if uis:IsKeyDown(Enum.KeyCode.A) then
				move -= workspace.CurrentCamera.CFrame.RightVector
			end
			if uis:IsKeyDown(Enum.KeyCode.D) then
				move += workspace.CurrentCamera.CFrame.RightVector
			end
			velocity.Velocity = (move.Magnitude > 0 and move.Unit or Vector3.zero) * (speedValue * 10)
		end
	end)

	updateHUD()
end

local function stopFly()
	flying = false
	if velocity then velocity:Destroy() end
	if gyro then gyro:Destroy() end
	updateHUD()
end

local function toggleFly()
	if flying then
		stopFly()
		onof.Text = "fly"
	else
		startFly()
		onof.Text = "unfly"
	end
end

--// Buttons
onof.MouseButton1Click:Connect(toggleFly)

plus.MouseButton1Click:Connect(function()
	speedValue += 1
	speed.Text = tostring(speedValue)
	updateHUD()
end)

mine.MouseButton1Click:Connect(function()
	if speedValue > 1 then
		speedValue -= 1
		speed.Text = tostring(speedValue)
		updateHUD()
	end
end)

up.MouseButton1Click:Connect(function()
	if flying then hrp.CFrame += Vector3.new(0, speedValue * 2, 0) end
end)

down.MouseButton1Click:Connect(function()
	if flying then hrp.CFrame -= Vector3.new(0, speedValue * 2, 0) end
end)

closebutton.MouseButton1Click:Connect(function()
	main:Destroy()
	stopFly()
end)

mini.MouseButton1Click:Connect(function()
	Frame.Visible = false
	mini2.Visible = true
end)

mini2.MouseButton1Click:Connect(function()
	Frame.Visible = true
	mini2.Visible = false
end)

--// Keybind Toggle (F)
uis.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.F then
		toggleFly()
	end
end)

--// Respawn Fix
player.CharacterAdded:Connect(function(char)
	character = char
	hrp = char:WaitForChild("HumanoidRootPart")
	humanoid = char:WaitForChild("Humanoid")
	stopFly()
end)

-- Initial HUD update
updateHUD()