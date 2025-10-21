--// Universal Big Jump Button (Mobile Executor FIX)
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

-- Matikan tombol bawaan
pcall(function()
    StarterGui:SetCore("MobileJumpButtonEnabled", false)
end)

-- GUI utama
local gui = Instance.new("ScreenGui")
gui.Name = "BigJumpGui"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Tombol besar
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
jumpButton.Parent = gui

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Parent = jumpButton

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = jumpButton

-- Fungsi loncat universal
local function forceJump()
    -- Simulasikan tekan tombol spasi (jump default)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

-- Saat tombol disentuh
jumpButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		forceJump()
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

-- Draggable
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

print("✅ Big Jump Button aktif — versi VirtualInputManager (lompat fix 100%)")
