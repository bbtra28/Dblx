-- Pantry Finder + Marker + Teleport
-- Pasti muncul GUI & bekerja di executor

local targetName = "Pantry" -- nama bangunan

local player = game:GetService("Players").LocalPlayer
local markers = {}
local foundTarget = nil

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 140)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Pantry Finder"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local function button(text, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(1,-20,0,30)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

local scanBtn = button("SCAN", 35)
local tpBtn = button("TP to Pantry", 75)

tpBtn.Text = "TP to Pantry (No Target)"
tpBtn.Active = false
tpBtn.AutoButtonColor = false

-- MARKER
local function createMarker(obj)
	if markers[obj] then markers[obj]:Destroy() end

	local part = Instance.new("Part")
	part.Shape = Enum.PartType.Ball
	part.Size = Vector3.new(4,4,4)
	part.Color = Color3.fromRGB(255,0,0)
	part.Material = Enum.Material.Neon
	part.Anchored = true
	part.CanCollide = false

	-- posisi marker
	local cf
	if obj:IsA("BasePart") then
		cf = obj.CFrame + Vector3.new(0,5,0)
	else
		local _, size = obj:GetBoundingBox()
		cf = obj:GetPivot() + Vector3.new(0, size.Y/2 + 5, 0)
	end

	part.CFrame = cf
	part.Parent = workspace

	markers[obj] = part

	-- update posisi marker supaya selalu mengikuti
	task.spawn(function()
		while part and obj and obj.Parent do
			local cf2
			if obj:IsA("BasePart") then
				cf2 = obj.CFrame + Vector3.new(0,5,0)
			else
				local _, size = obj:GetBoundingBox()
				cf2 = obj:GetPivot() + Vector3.new(0, size.Y/2 + 5, 0)
			end
			part.CFrame = cf2
			task.wait(0.1)
		end
	end)
end

-- SCAN FUNCTION
local function scan()
	foundTarget = nil

	for obj,_ in pairs(markers) do markers[obj]:Destroy() end
	markers = {}

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj.Name:lower() == targetName:lower() then
			foundTarget = obj
			createMarker(obj)
		end
	end

	if foundTarget then
		tpBtn.Text = "TP to Pantry"
		tpBtn.Active = true
		tpBtn.AutoButtonColor = true
	else
		tpBtn.Text = "TP to Pantry (Not Found)"
		tpBtn.Active = false
		tpBtn.AutoButtonColor = false
	end
end

scanBtn.MouseButton1Click:Connect(scan)

tpBtn.MouseButton1Click:Connect(function()
	if not foundTarget then return end
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local pivot = foundTarget:GetPivot()
	hrp.CFrame = pivot + Vector3.new(0,5,0)
end)

print("Pantry Finder Loaded!")
