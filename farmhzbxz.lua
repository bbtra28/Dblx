local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local speaker = Players.LocalPlayer
local character = speaker.Character or speaker.CharacterAdded:Wait()

-- GUI
local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local flyBtn = Instance.new("TextButton")
local noclipBtn = Instance.new("TextButton")
local lowGfxBtn = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

main.Name = "main"
main.Parent = speaker:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.1, 0, 0.38, 0)
Frame.Size = UDim2.new(0, 230, 0, 120)
Frame.Active = true
Frame.Draggable = true

-- Label
TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.35, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "Fly GUI V3"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true

-- Tombol UP
up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Position = UDim2.new(0, 0, 0.3, 0)
up.Size = UDim2.new(0, 60, 0, 28)
up.Text = "UP"

-- Tombol DOWN
down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0.55, 0)
down.Size = UDim2.new(0, 60, 0, 28)
down.Text = "DOWN"

-- Tombol Fly
flyBtn.Name = "flyBtn"
flyBtn.Parent = Frame
flyBtn.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
flyBtn.Position = UDim2.new(0.65, 0, 0.3, 0)
flyBtn.Size = UDim2.new(0, 70, 0, 28)
flyBtn.Text = "Fly"

-- Tombol Noclip
noclipBtn.Name = "noclipBtn"
noclipBtn.Parent = Frame
noclipBtn.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
noclipBtn.Position = UDim2.new(0.65, 0, 0.55, 0)
noclipBtn.Size = UDim2.new(0, 70, 0, 28)
noclipBtn.Text = "Noclip"

-- Tombol Low Grafik
lowGfxBtn.Name = "lowGfxBtn"
lowGfxBtn.Parent = Frame
lowGfxBtn.BackgroundColor3 = Color3.fromRGB(200, 255, 150)
lowGfxBtn.Position = UDim2.new(0.33, 0, 0.8, 0)
lowGfxBtn.Size = UDim2.new(0, 100, 0, 28)
lowGfxBtn.Text = "Low GFX"

-- Close
closebutton.Name = "Close"
closebutton.Parent = Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Position = UDim2.new(0, 0, -0.5, 0)
closebutton.Size = UDim2.new(0, 45, 0, 28)
closebutton.Text = "X"
closebutton.TextSize = 30

-- Minimize
mini.Name = "minimize"
mini.Parent = Frame
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini.Position = UDim2.new(0.25, 0, -0.5, 0)
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Text = "-"

mini2.Name = "minimize2"
mini2.Parent = Frame
mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini2.Position = UDim2.new(0.25, 0, -0.5, 30)
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Text = "+"
mini2.Visible = false

----------------------------------------------------------------
-- Logic Fly
local flying = false
local bg, bv

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	local hrp = character:WaitForChild("HumanoidRootPart")
	if flying then
		flyBtn.Text = "Flying..."
		bg = Instance.new("BodyGyro", hrp)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = hrp.CFrame

		bv = Instance.new("BodyVelocity", hrp)
		bv.velocity = Vector3.new(0,0,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

		RunService.RenderStepped:Connect(function()
			if flying and hrp then
				local camCF = workspace.CurrentCamera.CFrame
				local moveDir = speaker.Character.Humanoid.MoveDirection
				bv.velocity = (camCF.LookVector * moveDir.Z + camCF.RightVector * moveDir.X) * 50
				bg.cframe = camCF
			elseif bv and bg then
				bv:Destroy()
				bg:Destroy()
			end
		end)
	else
		flyBtn.Text = "Fly"
		if bv then bv:Destroy() bv=nil end
		if bg then bg:Destroy() bg=nil end
	end
end)

-- UP & DOWN manual
up.MouseButton1Click:Connect(function()
	if character:FindFirstChild("HumanoidRootPart") then
		character.HumanoidRootPart.CFrame *= CFrame.new(0,2,0)
	end
end)

down.MouseButton1Click:Connect(function()
	if character:FindFirstChild("HumanoidRootPart") then
		character.HumanoidRootPart.CFrame *= CFrame.new(0,-2,0)
	end
end)

----------------------------------------------------------------
-- Noclip
local noclipEnabled = false
local noclipConn

local function startNoclip()
	if noclipConn then noclipConn:Disconnect() end
	noclipConn = RunService.Stepped:Connect(function()
		if noclipEnabled and character.Parent then
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end)
end

noclipBtn.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	if noclipEnabled then
		noclipBtn.Text = "Noclip ON"
		startNoclip()
	else
		noclipBtn.Text = "Noclip"
		if noclipConn then noclipConn:Disconnect() end
	end
end)

----------------------------------------------------------------
-- Low Grafik
local lowGfx = false

local function setLowGraphics(state)
	if state then
		lowGfxBtn.Text = "Low GFX ON"
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9e9
		Lighting.Brightness = 1
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	else
		lowGfxBtn.Text = "Low GFX"
		Lighting.GlobalShadows = true
		Lighting.FogEnd = 1000
		Lighting.Brightness = 2
		settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
	end
end

lowGfxBtn.MouseButton1Click:Connect(function()
	lowGfx = not lowGfx
	setLowGraphics(lowGfx)
end)

----------------------------------------------------------------
-- Close & Minimize
closebutton.MouseButton1Click:Connect(function()
	main:Destroy()
end)

mini.MouseButton1Click:Connect(function()
	for _, v in pairs(Frame:GetChildren()) do
		if v:IsA("TextButton") and v.Name ~= "minimize2" and v.Name ~= "Close" then
			v.Visible = false
		end
	end
	mini.Visible = false
	mini2.Visible = true
	Frame.BackgroundTransparency = 1
end)

mini2.MouseButton1Click:Connect(function()
	for _, v in pairs(Frame:GetChildren()) do
		if v:IsA("TextButton") and v.Name ~= "minimize2" then
			v.Visible = true
		end
	end
	mini.Visible = true
	mini2.Visible = false
	Frame.BackgroundTransparency = 0
end)
