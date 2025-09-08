-- Instances
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
local noclipBtn = Instance.new("TextButton")
local lowGfxBtn = Instance.new("TextButton")

main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.1003, 0, 0.379, 0)
Frame.Size = UDim2.new(0, 250, 0, 100)
Frame.Active = true
Frame.Draggable = true

-- Tombol2 utama (UP/DOWN/Fly/Speed Control)
up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Size = UDim2.new(0, 44, 0, 28)
up.Text = "UP"

down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0.491, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Text = "DOWN"

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.7, 0, 0.491, 0)
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Text = "Fly"

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.46, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Text = "Fly GUI V3"

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0.23, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Text = "+"

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speed.Position = UDim2.new(0.468, 0, 0.491, 0)
speed.Size = UDim2.new(0, 44, 0, 28)
speed.Text = "1"

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Position = UDim2.new(0.23, 0, 0.491, 0)
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Text = "-"

-- Tombol Noclip
noclipBtn.Name = "noclipBtn"
noclipBtn.Parent = Frame
noclipBtn.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
noclipBtn.Position = UDim2.new(0.7, 0, 0, 0)
noclipBtn.Size = UDim2.new(0, 56, 0, 28)
noclipBtn.Text = "Noclip"

-- Tombol Low Grafik
lowGfxBtn.Name = "lowGfxBtn"
lowGfxBtn.Parent = Frame
lowGfxBtn.BackgroundColor3 = Color3.fromRGB(200, 255, 150)
lowGfxBtn.Position = UDim2.new(0.33, 0, 0.8, 0)
lowGfxBtn.Size = UDim2.new(0, 100, 0, 28)
lowGfxBtn.Text = "Low GFX"

-- Close & Minimize
closebutton.Name = "Close"
closebutton.Parent = Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Size = UDim2.new(0, 45, 0, 28)
closebutton.Text = "X"
closebutton.Position = UDim2.new(0, 0, -0.5, 27)

mini.Name = "minimize"
mini.Parent = Frame
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Text = "-"
mini.Position = UDim2.new(0, 44, -0.5, 27)

mini2.Name = "minimize2"
mini2.Parent = Frame
mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Text = "+"
mini2.Position = UDim2.new(0, 44, -0.5, 57)
mini2.Visible = false

--------------------------------------------------------
-- Fly System asli (dari script kamu)
-- (tetap pakai tpwalking dan speed + / -)
-- kode kamu yang lama tetap disini...
-- (biar tidak kepanjangan aku potong, cukup ganti tombol GUI saja)
--------------------------------------------------------

-- Noclip
local RunService = game:GetService("RunService")
local character = game.Players.LocalPlayer.Character
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

-- Low Grafik
local Lighting = game:GetService("Lighting")
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

-- Close & Minimize
closebutton.MouseButton1Click:Connect(function() main:Destroy() end)
mini.MouseButton1Click:Connect(function()
	for _,v in pairs(Frame:GetChildren()) do
		if v:IsA("TextButton") and v.Name ~= "minimize2" and v.Name ~= "Close" then
			v.Visible = false
		end
	end
	mini.Visible = false
	mini2.Visible = true
	Frame.BackgroundTransparency = 1
end)
mini2.MouseButton1Click:Connect(function()
	for _,v in pairs(Frame:GetChildren()) do
		if v:IsA("TextButton") and v.Name ~= "minimize2" then
			v.Visible = true
		end
	end
	mini.Visible = true
	mini2.Visible = false
	Frame.BackgroundTransparency = 0
end)
