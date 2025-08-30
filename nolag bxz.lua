--// Anti Lag GUI Script
--// Buat LocalScript di StarterPlayerScripts

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiLagGui"
screenGui.Parent = playerGui

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.Parent = screenGui

-- Tombol
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 50)
button.Position = UDim2.new(0, 10, 0.5, -25)
button.Text = "Aktifkan Anti Lag"
button.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.Parent = frame

-- Status
local aktif = false

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
		-- Reset sebagian (tidak full, hanya dasar)
		settings.Rendering.QualityLevel = Enum.QualityLevel.Automatic
		lighting.GlobalShadows = true
		lighting.EnvironmentDiffuseScale = 1
		lighting.EnvironmentSpecularScale = 1
		lighting.Brightness = 2

		button.Text = "Aktifkan Anti Lag"
		button.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
	end
end

-- Event klik tombol
button.MouseButton1Click:Connect(function()
	aktif = not aktif
	setAntiLag(aktif)
end)