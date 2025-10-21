-- Buat GUI baru
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local Title = Instance.new("TextLabel", Frame)
local PositionLabel = Instance.new("TextLabel", Frame)

-- Properti Frame
Frame.Size = UDim2.new(0, 180, 0, 80)
Frame.Position = UDim2.new(0.05, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.BackgroundTransparency = 0.3
Frame.Name = "PositionGUI"

-- Title
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "📍 Koordinat Posisi"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.SourceSansBold

-- Label untuk posisi
PositionLabel.Size = UDim2.new(1, -10, 1, -25)
PositionLabel.Position = UDim2.new(0, 5, 0, 25)
PositionLabel.BackgroundTransparency = 1
PositionLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
PositionLabel.TextScaled = true
PositionLabel.Font = Enum.Font.SourceSans

-- Update posisi player setiap 0.1 detik
task.spawn(function()
	while task.wait(0.1) do
		local player = game.Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			local pos = hrp.Position
			PositionLabel.Text = string.format("X: %.1f\nY: %.1f\nZ: %.1f", pos.X, pos.Y, pos.Z)
		end
	end
end)