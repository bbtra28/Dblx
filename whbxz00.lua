local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "WallhackGUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Frame utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0, 50, 0, 150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Tombol Show (draggable)
local showButton = Instance.new("TextButton")
showButton.Size = UDim2.new(0, 50, 0, 25)
showButton.Position = UDim2.new(0, 10, 0, 50)
showButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
showButton.TextColor3 = Color3.new(1, 1, 1)
showButton.Text = "Show"
showButton.Font = Enum.Font.SourceSansBold
showButton.TextSize = 14
showButton.Visible = false
showButton.Active = true
showButton.Draggable = true
showButton.Parent = gui

-- Tombol Hide
local hideButton = Instance.new("TextButton")
hideButton.Size = UDim2.new(0, 25, 0, 25)
hideButton.Position = UDim2.new(1, -30, 0, 0)
hideButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
hideButton.TextColor3 = Color3.new(1, 1, 1)
hideButton.Text = "-"
hideButton.Font = Enum.Font.SourceSansBold
hideButton.TextSize = 18
hideButton.Parent = frame

-- Tombol utama
local wallhackButton = Instance.new("TextButton")
wallhackButton.Size = UDim2.new(1, -20, 0, 40)
wallhackButton.Position = UDim2.new(0, 10, 0, 30)
wallhackButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
wallhackButton.TextColor3 = Color3.new(1, 1, 1)
wallhackButton.Text = "Enable Wallhack"
wallhackButton.Font = Enum.Font.SourceSansBold
wallhackButton.TextSize = 18
wallhackButton.Parent = frame

-- Tombol warna
local redButton = Instance.new("TextButton")
redButton.Size = UDim2.new(0.45, 0, 0, 30)
redButton.Position = UDim2.new(0.05, 0, 0, 80)
redButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
redButton.TextColor3 = Color3.new(1, 1, 1)
redButton.Text = "Merah"
redButton.Font = Enum.Font.SourceSansBold
redButton.TextSize = 16
redButton.Parent = frame

local greenButton = Instance.new("TextButton")
greenButton.Size = UDim2.new(0.45, 0, 0, 30)
greenButton.Position = UDim2.new(0.5, 0, 0, 80)
greenButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
greenButton.TextColor3 = Color3.new(1, 1, 1)
greenButton.Text = "Hijau"
greenButton.Font = Enum.Font.SourceSansBold
greenButton.TextSize = 16
greenButton.Parent = frame

-- Variabel utama
local wallhackEnabled = false
local currentColor = Color3.fromRGB(0, 255, 0)

-- Fungsi tambah username di atas kepala
local function addNameTag(player)
	if player == LocalPlayer then return end
	if not player.Character then return end
	local head = player.Character:FindFirstChild("Head")
	if not head then return end

	if not head:FindFirstChild("NameTag") then
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "NameTag"
		billboard.Size = UDim2.new(0, 100, 0, 20)
		billboard.StudsOffset = Vector3.new(0, 2.5, 0)
		billboard.AlwaysOnTop = true
		billboard.Parent = head

		local text = Instance.new("TextLabel")
		text.Size = UDim2.new(1, 0, 1, 0)
		text.BackgroundTransparency = 1
		text.Text = player.Name
		text.TextColor3 = Color3.fromRGB(255, 255, 255)
		text.Font = Enum.Font.SourceSansBold
		text.TextSize = 14
		text.Parent = billboard
	end
end

-- Fungsi hapus username
local function removeNameTag(player)
	if player.Character and player.Character:FindFirstChild("Head") then
		local tag = player.Character.Head:FindFirstChild("NameTag")
		if tag then tag:Destroy() end
	end
end

-- Fungsi highlight aman
local function applyHighlight(player)
	if player == LocalPlayer then return end
	if not player.Character then return end
	task.wait(0.1) -- delay kecil biar head/body sudah siap

	local highlight = player.Character:FindFirstChild("WallhackHighlight")
	if not highlight then
		highlight = Instance.new("Highlight")
		highlight.Name = "WallhackHighlight"
		highlight.FillColor = currentColor
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Parent = player.Character
	else
		highlight.FillColor = currentColor
	end

	addNameTag(player)
end

-- Toggle wallhack semua player
local function toggleWallhack(enabled)
	for _, p in ipairs(Players:GetPlayers()) do
		if enabled then
			applyHighlight(p)
		else
			local h = p.Character and p.Character:FindFirstChild("WallhackHighlight")
			if h then h:Destroy() end
			removeNameTag(p)
		end
	end
end

-- Auto apply saat player baru spawn
Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		if wallhackEnabled then
			task.wait(0.5)
			applyHighlight(p)
		end
	end)
end)

-- Periksa otomatis tiap 2 detik agar tidak hilang
task.spawn(function()
	while true do
		task.wait(2)
		if wallhackEnabled then
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LocalPlayer then
					if not (p.Character and p.Character:FindFirstChild("WallhackHighlight")) then
						applyHighlight(p)
					end
				end
			end
		end
	end
end)

-- Tombol utama
wallhackButton.MouseButton1Click:Connect(function()
	wallhackEnabled = not wallhackEnabled
	toggleWallhack(wallhackEnabled)
	wallhackButton.Text = wallhackEnabled and "Disable Wallhack" or "Enable Wallhack"
	wallhackButton.BackgroundColor3 = wallhackEnabled and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(0, 120, 255)
end)

-- Tombol warna
redButton.MouseButton1Click:Connect(function()
	currentColor = Color3.fromRGB(255, 0, 0)
	if wallhackEnabled then toggleWallhack(true) end
end)

greenButton.MouseButton1Click:Connect(function()
	currentColor = Color3.fromRGB(0, 255, 0)
	if wallhackEnabled then toggleWallhack(true) end
end)

-- Hide / Show GUI
hideButton.MouseButton1Click:Connect(function()
	frame.Visible = false
	showButton.Visible = true
end)

showButton.MouseButton1Click:Connect(function()
	frame.Visible = true
	showButton.Visible = false
end)
