-- Pumpkin Finder + GUI + Marker 3D (Neon Ball)
-- Fully executor-friendly

local pumpkinName = "Pumpkin"
local markers = {}

-- GUI SETUP
local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BackgroundTransparency = 0.2

frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Pumpkin Finder"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local function createButton(text, posY)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0,10, 0, posY)
	btn.Text = text
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	return btn
end

local scanBtn = createButton("SCAN Pumpkin", 35)
local hideBtn = createButton("Hide Markers", 70)

-- MARKER CREATOR
local function createMarker(obj)
	if markers[obj] then
		markers[obj]:Destroy()
	end

	local part = Instance.new("Part")
	part.Shape = Enum.PartType.Ball
	part.Size = Vector3.new(2,2,2)
	part.Color = Color3.fromRGB(255, 120, 0)
	part.Material = Enum.Material.Neon
	part.CanCollide = false
	part.Anchored = true
	part.CFrame = obj:IsA("BasePart") and obj.CFrame + Vector3.new(0,3,0) or obj.Parent:GetBoundingBox()

	part.Parent = workspace
	markers[obj] = part

	task.spawn(function()
		while markers[obj] and obj.Parent do
			if obj:IsA("BasePart") then
				part.CFrame = obj.CFrame + Vector3.new(0,3,0)
			end
			task.wait(0.1)
		end
	end)
end

-- SCAN FUNCTION
local function scanPumpkins()
	for obj,_ in pairs(markers) do
		if markers[obj] then markers[obj]:Destroy() end
	end
	markers = {}

	for _,obj in ipairs(workspace:GetDescendants()) do
		if obj.Name:lower() == pumpkinName:lower() then
			createMarker(obj)
		end
	end
end

-- BUTTON FUNCTIONS
scanBtn.MouseButton1Click:Connect(function()
	scanPumpkins()
end)

local markersVisible = true
hideBtn.MouseButton1Click:Connect(function()
	markersVisible = not markersVisible
	for _,m in pairs(markers) do
		m.Transparency = markersVisible and 0 or 1
	end
	hideBtn.Text = markersVisible and "Hide Markers" or "Show Markers"
end)

print("Pumpkin Finder Loaded!")
