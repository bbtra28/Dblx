--// Anti Lag GUI Script (bisa digeser + close/minimize)
--// Buat LocalScript di StarterPlayerScripts

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiLagGui"
screenGui.Parent = playerGui

-- Frame utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.5, -110, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 25)
title.Position = UDim2.new(0, 5, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Anti Lag GUI"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Tombol Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.Parent = frame

-- Tombol Minimize
local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0, 25, 0, 25)
miniBtn.Position = UDim2.new(1, -60, 0, 5)
miniBtn.Text = "-"
miniBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
miniBtn.TextColor3 = Color3.new(1, 1, 1)
miniBtn.Font = Enum.Font.SourceSansBold
miniBtn.TextSize = 18
miniBtn.Parent = frame

-- Tombol Anti Lag
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 50)
button.Position = UDim2.new(0, 10, 0.5, -15)
button.Text = "Aktifkan Anti Lag"
button.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.Parent = frame

-- Variabel
local aktif = false
local minimized = false

-- Fungsi Anti Lag
local function setAntiLag(state)
	local lighting = game:GetService("Lighting")
	local settings = settings()
	local terrain = workspace:FindFirstChildOfClass("Terrain")

	if state then
		-- FPS Boost Aktif
		settings.Rendering.QualityLevel = Enum.QualityLevel.Level01
		lighting.GlobalShadows = false
		lighting.FogEnd = 999999
		lighting.EnvironmentDiffuseScale = 0
		lighting.EnvironmentSpecularScale = 0
		lighting.Brightness = 1

		for _, v in pairs(lighting:GetChildren()) do
			if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") 
			or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") 
			or v:IsA("DepthOfFieldEffect") then
				v.Enabled = false
			end
		end

		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Material = Enum.Material.SmoothPlastic
				if v:IsA("MeshPart") then
					v.TextureID = ""
				end
			elseif v:IsA("Decal") or v:IsA("Texture") then
				v:Destroy()
			elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") then
				v.Enabled = false
			end
		end

		if terrain then
			terrain.WaterWaveSize = 0
			terrain.WaterWaveSpeed = 0
			terrain.WaterReflectance = 0
			terrain.WaterTransparency = 0
		end

		button.Text = "Matikan Anti Lag"
		button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	else
		-- Reset
		settings.Rendering.QualityLevel = Enum.QualityLevel.Automatic
		lighting.GlobalShadows = true
		lighting.EnvironmentDiffuseScale = 1
		lighting.EnvironmentSpecularScale = 1
		lighting.Brightness = 2

		button.Text = "Aktifkan Anti Lag"
		button.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
	end
end

-- Event klik tombol Anti Lag
button.MouseButton1Click:Connect(function()
	aktif = not aktif
	setAntiLag(aktif)
end)

-- Event klik Close
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

-- Event klik Minimize
miniBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		button.Visible = false
		frame.Size = UDim2.new(0, 220, 0, 35) -- kecil
	else
		button.Visible = true
		frame.Size = UDim2.new(0, 220, 0, 120) -- normal
	end
end)