--// Big Jump Button with Save & Show/Hide
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

if not UserInputService.TouchEnabled then
    warn("Script ini hanya untuk perangkat mobile (touch).")
    return
end

-- Nonaktifkan tombol bawaan
pcall(function()
    StarterGui:SetCore("MobileJumpButtonEnabled", false)
end)

-- Folder penyimpanan posisi
local saveFile = "jump_button_pos.txt"
local function savePos(pos)
    if writefile then
        writefile(saveFile, tostring(pos.X.Offset) .. "," .. tostring(pos.Y.Offset))
    end
end

local function loadPos()
    if readfile and isfile and isfile(saveFile) then
        local data = readfile(saveFile)
        local x, y = string.match(data, "([^,]+),([^,]+)")
        if x and y then
            return UDim2.new(1, tonumber(x), 1, tonumber(y))
        end
    end
    return nil
end

-- Buat GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CustomJumpGui"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Posisi awal
local defaultPos = UDim2.new(1, -40, 1, -150)
local savedPos = loadPos() or defaultPos

-- Tombol loncat
local jumpButton = Instance.new("ImageButton")
jumpButton.Name = "JumpButton"
jumpButton.Size = UDim2.new(0, 180, 0, 180)
jumpButton.Position = savedPos
jumpButton.AnchorPoint = Vector2.new(1, 1)
jumpButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
jumpButton.BackgroundTransparency = 0.3
jumpButton.Image = "rbxassetid://3926305904"
jumpButton.ImageRectOffset = Vector2.new(4, 204)
jumpButton.ImageRectSize = Vector2.new(36, 36)
jumpButton.AutoButtonColor = true
jumpButton.Parent = gui

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Parent = jumpButton

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = jumpButton

-- Fungsi lompat
local function doJump()
	local char = player.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.Jump = true
		end
	end
end

jumpButton.MouseButton1Down:Connect(doJump)
jumpButton.TouchTap:Connect(doJump)

-- Efek tekan
local function press(on)
	if on then
		jumpButton.BackgroundTransparency = 0.1
		jumpButton:TweenSize(UDim2.new(0, 160, 0, 160), "Out", "Quad", 0.08, true)
	else
		jumpButton.BackgroundTransparency = 0.3
		jumpButton:TweenSize(UDim2.new(0, 180, 0, 180), "Out", "Quad", 0.08, true)
	end
end

jumpButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		press(true)
	end
end)
jumpButton.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		press(false)
	end
end)

-- Draggable + auto-save posisi
local dragging = false
local dragStart, startPos
jumpButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = jumpButton.Position
	end
end)
jumpButton.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.Touch then
		local delta = input.Position - dragStart
		local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		jumpButton.Position = newPos
	end
end)
jumpButton.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
		savePos(jumpButton.Position)
	end
end)

-- Tombol kecil Show/Hide
local toggle = Instance.new("TextButton")
toggle.Name = "ToggleButton"
toggle.Size = UDim2.new(0, 80, 0, 40)
toggle.Position = UDim2.new(1, -90, 1, -40)
toggle.AnchorPoint = Vector2.new(1, 1)
toggle.Text = "HIDE"
toggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.BackgroundTransparency = 0.4
toggle.Parent = gui

toggle.MouseButton1Click:Connect(function()
	if jumpButton.Visible then
		jumpButton.Visible = false
		toggle.Text = "SHOW"
	else
		jumpButton.Visible = true
		toggle.Text = "HIDE"
	end
end)

print("✅ Tombol loncat besar aktif (draggable, auto save, show/hide)")
