-- Chef Chubbyini Finder + Teleport + Marker 3D
-- GUI dijamin muncul

local targetName = "Chef Chubbyini"
local trackedNPC = nil
local marker = nil

-- GUI SETUP (DIJAMIN MUNCUL)
local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = 0.2

frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "Chef Finder"
title.TextColor3 = Color3.new(1,1,1)

local function makeBtn(text, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(1,-20,0,30)
	b.Position = UDim2.new(0,10,0,y)
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.Text = text
	return b
end

local scanBtn = makeBtn("SCAN Chef", 40)
local tpBtn   = makeBtn("TELEPORT", 75)

-- CREATE MARKER
local function createMarker(part)
	if marker then marker:Destroy() end

	local m = Instance.new("Part")
	m.Shape = Enum.PartType.Ball
	m.Size = Vector3.new(2,2,2)
	m.Color = Color3.fromRGB(255, 120, 0)
	m.Material = Enum.Material.Neon
	m.Anchored = true
	m.CanCollide = false
	m.Parent = workspace

	marker = m

	task.spawn(function()
		while marker and trackedNPC and trackedNPC.Parent do
			if trackedNPC:IsA("BasePart") then
				marker.CFrame = trackedNPC.CFrame + Vector3.new(0,4,0)
			elseif trackedNPC:FindFirstChild("HumanoidRootPart") then
				marker.CFrame = trackedNPC.HumanoidRootPart.CFrame + Vector3.new(0,4,0)
			end
			task.wait(0.1)
		end
	end)
end

-- FIND FUNCTION
local function findChef()
	trackedNPC = nil

	for _,obj in ipairs(workspace:GetDescendants()) do
		if obj.Name:lower() == targetName:lower() then
			if obj:IsA("BasePart") then
				trackedNPC = obj
				break
			elseif obj:FindFirstChild("HumanoidRootPart") then
				trackedNPC = obj.HumanoidRootPart
				break
			end
		end
	end

	if trackedNPC then
		createMarker(trackedNPC)
	end
end

-- TELEPORT FUNCTION
local function teleportToChef()
	if not trackedNPC then return end

	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	-- Teleport
	root.CFrame = trackedNPC.CFrame + Vector3.new(0,2,0)
end

-- BUTTON EVENTS
scanBtn.MouseButton1Click:Connect(findChef)
tpBtn.MouseButton1Click:Connect(teleportToChef)

print("CHEF CHUBBYINI FINDER LOADED")
