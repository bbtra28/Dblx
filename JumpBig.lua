--// Big Jump Button (Mobile Executor Compatible)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Matikan tombol bawaan
pcall(function()
    StarterGui:SetCore("MobileJumpButtonEnabled", false)
end)

-- GUI setup
local gui = Instance.new("ScreenGui")
gui.Name = "CustomJumpGui"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Tombol loncat besar
local jumpButton = Instance.new("ImageButton")
jumpButton.Name = "JumpButton"
jumpButton.Size = UDim2.new(0, 180, 0, 180)
jumpButton.Position = UDim2.new(1, -50, 1, -160)
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

-- Fungsi lompat (pakai VirtualInput)
local function doJump()
	local hum = character:FindFirstChildOfClass("Humanoid")
	if hum and hum:GetState() ~= Enum.HumanoidStateType.Dead then
		hum.Jump = true
	end
end

-- Perbaikan touch: deteksi manual & trigger jump
jumpButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		doJump()
		jumpButton.BackgroundTransparency = 0.1
		jumpButton:TweenSize(UDim2.new(0, 160, 0, 160), "Out", "Quad", 0.08, true)
	end
end)

jumpButton.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		jumpButton.BackgroundTransparency = 0.3
		jumpButton:TweenSize(UDim2.new(0, 180, 0, 180), "Out", "Quad", 0.08, true)
	end
end)

-- Draggable (biar bisa dipindah)
local dragging, dragStart, startPos
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
		jumpButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

jumpButton.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

print("✅ Tombol loncat besar aktif (versi fix touch jump)")
