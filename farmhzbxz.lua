-- F3X-like Building Tool (Mobile + PC)
-- Taruh sebagai LocalScript (StarterPlayerScripts) atau jalankan di executor

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Config
local SNAP = true
local SNAP_SIZE = 1
local MOVE_STEP = 1
local ROTATE_STEP = 15 -- degrees
local SCALE_STEP = 1

-- Helpers
local function snap(n)
	if not SNAP then return n end
	return math.round(n / SNAP_SIZE) * SNAP_SIZE
end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "F3XLite"
screenGui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 240, 0, 360)
main.Position = UDim2.new(0, 20, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = screenGui

local function makeButton(name, y, text)
	local b = Instance.new("TextButton", main)
	b.Name = name
	b.Size = UDim2.new(1, -16, 0, 30)
	b.Position = UDim2.new(0, 8, 0, 36 + y)
	b.Text = text
	b.Font = Enum.Font.SourceSans
	b.TextSize = 16
	b.BackgroundTransparency = 0.2
	b.TextColor3 = Color3.fromRGB(230,230,230)
	return b
end

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 28)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Text = "F3X Lite (Mobile)"
title.TextColor3 = Color3.fromRGB(255,255,255)

local btnCreate = makeButton("Create", 0, "Create Part")
local btnDelete = makeButton("Delete", 36, "Delete Selected")
local btnDuplicate = makeButton("Duplicate", 72, "Duplicate Selected")
local btnSnapToggle = makeButton("Snap", 108, "Snap: ON")
local btnGridSize = makeButton("Grid", 144, "Grid size: 1")
local btnMode = makeButton("Mode", 180, "Mode: Move")
local btnScaleUp = makeButton("ScaleUp", 216, "Scale +")
local btnScaleDown = makeButton("ScaleDown", 252, "Scale -")
local btnHide = makeButton("Hide", 288, "Hide GUI")

local status = Instance.new("TextLabel", main)
status.Position = UDim2.new(0,8,1,-40)
status.Size = UDim2.new(1,-16,0,36)
status.BackgroundTransparency = 0.4
status.Font = Enum.Font.SourceSans
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(200,200,200)
status.TextWrapped = true
status.Text = "No selection"

-- Mode handling
local mode = "Move"
local selected = nil
local selectionAdornment = nil

local function updateStatus()
	status.Text = ("Mode: %s | Snap: %s | Grid: %s\nSelected: %s")
		:format(mode, SNAP and "ON" or "OFF", tostring(SNAP_SIZE), (selected and selected.Name or "None"))
	btnMode.Text = "Mode: " .. mode
	btnSnapToggle.Text = "Snap: " .. (SNAP and "ON" or "OFF")
	btnGridSize.Text = "Grid size: " .. tostring(SNAP_SIZE)
end

-- Selection visuals
local function setSelection(target)
	if selectionAdornment then selectionAdornment:Destroy() selectionAdornment = nil end
	selected = target
	if selected and selected:IsA("BasePart") then
		local ad = Instance.new("SelectionBox")
		ad.Adornee = selected
		ad.LineThickness = 0.01
		ad.Parent = selected
		selectionAdornment = ad
	end
	updateStatus()
end

-- Create
btnCreate.MouseButton1Click:Connect(function()
	local part = Instance.new("Part")
	part.Size = Vector3.new(2,2,2)
	part.Position = (mouse.Hit.p + Vector3.new(0,5,0))
	part.Anchored = true
	part.Parent = Workspace
	part.Name = "F3XPart"
	setSelection(part)
end)

-- Delete
btnDelete.MouseButton1Click:Connect(function()
	if selected and selected.Parent then
		selected:Destroy()
		setSelection(nil)
	end
end)

-- Duplicate
btnDuplicate.MouseButton1Click:Connect(function()
	if selected and selected.Parent then
		local copy = selected:Clone()
		copy.Parent = Workspace
		copy.CFrame = selected.CFrame * CFrame.new(3,0,0)
		setSelection(copy)
	end
end)

-- Snap toggle
btnSnapToggle.MouseButton1Click:Connect(function()
	SNAP = not SNAP
	updateStatus()
end)

-- Grid size
btnGridSize.MouseButton1Click:Connect(function()
	SNAP_SIZE = (SNAP_SIZE % 8) + 1
	updateStatus()
end)

-- Mode
btnMode.MouseButton1Click:Connect(function()
	if mode == "Move" then mode = "Rotate"
	elseif mode == "Rotate" then mode = "Scale"
	else mode = "Move" end
	updateStatus()
end)

-- Scale buttons
btnScaleUp.MouseButton1Click:Connect(function()
	if selected and mode == "Scale" then
		selected.Size = selected.Size + Vector3.new(SCALE_STEP,SCALE_STEP,SCALE_STEP)
	end
end)
btnScaleDown.MouseButton1Click:Connect(function()
	if selected and mode == "Scale" then
		selected.Size = Vector3.new(
			math.max(0.5, selected.Size.X - SCALE_STEP),
			math.max(0.5, selected.Size.Y - SCALE_STEP),
			math.max(0.5, selected.Size.Z - SCALE_STEP)
		)
	end
end)

-- Hide GUI
btnHide.MouseButton1Click:Connect(function()
	screenGui.Enabled = false
end)

-- Tap select (Mobile)
UserInputService.TouchTapInWorld:Connect(function(pos, processed)
	if processed then return end
	local target = mouse.Target
	if target and target:IsA("BasePart") then
		setSelection(target)
	else
		setSelection(nil)
	end
end)

-- Still allow PC mouse select
mouse.Button1Down:Connect(function()
	local target = mouse.Target
	if target and target:IsA("BasePart") then
		setSelection(target)
	else
		setSelection(nil)
	end
end)

-- Movement buttons (extra small GUI for mobile arrows)
local moveFrame = Instance.new("Frame", screenGui)
moveFrame.Size = UDim2.new(0,150,0,150)
moveFrame.Position = UDim2.new(1,-160,1,-160)
moveFrame.BackgroundTransparency = 1

local function moveBtn(name, pos, text, dir)
	local b = Instance.new("TextButton", moveFrame)
	b.Size = UDim2.new(0,40,0,40)
	b.Position = pos
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(50,50,50)
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.MouseButton1Click:Connect(function()
		if selected and mode == "Move" then
			local newPos = selected.Position + dir * MOVE_STEP
			if SNAP then
				newPos = Vector3.new(snap(newPos.X), snap(newPos.Y), snap(newPos.Z))
			end
			selected.CFrame = CFrame.new(newPos, newPos + selected.CFrame.LookVector)
		elseif selected and mode == "Rotate" then
			local rx,ry,rz = dir.X*ROTATE_STEP, dir.Y*ROTATE_STEP, dir.Z*ROTATE_STEP
			selected.CFrame = selected.CFrame * CFrame.Angles(math.rad(rx), math.rad(ry), math.rad(rz))
		end
	end)
end

-- Arrow layout
moveBtn("Up", UDim2.new(0,55,0,0), "↑", Vector3.new(0,0,-1))
moveBtn("Down", UDim2.new(0,55,0,110), "↓", Vector3.new(0,0,1))
moveBtn("Left", UDim2.new(0,10,0,55), "←", Vector3.new(-1,0,0))
moveBtn("Right", UDim2.new(0,100,0,55), "→", Vector3.new(1,0,0))
moveBtn("Y+", UDim2.new(0,55,0,55), "Y+", Vector3.new(0,1,0))
moveBtn("Y-", UDim2.new(0,55,0,80), "Y-", Vector3.new(0,-1,0))

-- Initial
updateStatus()
