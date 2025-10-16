-- 📱 Mobile Click (Tap) to Attach Part Script
-- by ChatGPT (GPT-5)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MobileAttachGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 160)
frame.Position = UDim2.new(0.35, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
title.Text = "📱 Tap Part untuk Nempel"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1, -10, 0, 50)
info.Position = UDim2.new(0, 5, 0, 40)
info.BackgroundTransparency = 1
info.TextWrapped = true
info.Text = "👆 Ketuk part di layar untuk menempelkannya.\n🗙 Gunakan tombol bawah untuk lepas."
info.TextColor3 = Color3.fromRGB(220, 220, 220)
info.Font = Enum.Font.SourceSans
info.TextSize = 16

local attachInfo = Instance.new("TextLabel", frame)
attachInfo.Size = UDim2.new(1, -10, 0, 25)
attachInfo.Position = UDim2.new(0, 5, 0, 95)
attachInfo.BackgroundTransparency = 1
attachInfo.TextColor3 = Color3.fromRGB(180, 255, 180)
attachInfo.Font = Enum.Font.SourceSansBold
attachInfo.TextSize = 16
attachInfo.Text = "Tidak ada part menempel"

local detachBtn = Instance.new("TextButton", frame)
detachBtn.Size = UDim2.new(1, -20, 0, 35)
detachBtn.Position = UDim2.new(0, 10, 1, -45)
detachBtn.Text = "🗙 Lepaskan Part"
detachBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
detachBtn.TextColor3 = Color3.new(1, 1, 1)
detachBtn.Font = Enum.Font.SourceSansBold
detachBtn.TextSize = 16

-- Show/Hide Button
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0, 160, 0, 35)
toggle.Position = UDim2.new(0, 20, 0, 20)
toggle.Text = "📂 Show Attach GUI"
toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 16

local visible = true
toggle.MouseButton1Click:Connect(function()
	visible = not visible
	frame.Visible = visible
	toggle.Text = visible and "📁 Hide Attach GUI" or "📂 Show Attach GUI"
end)

-- ===== Attach System =====
local weld
local attachedPart

local function attachPart(part)
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp or not part or not part:IsA("BasePart") then return end

	if weld then weld:Destroy() end

	part.Anchored = false
	weld = Instance.new("WeldConstraint")
	weld.Part0 = hrp
	weld.Part1 = part
	weld.Parent = part
	attachedPart = part

	attachInfo.Text = "📦 Nempel: " .. part.Name
	attachInfo.TextColor3 = Color3.fromRGB(100, 255, 100)

	game.StarterGui:SetCore("SendNotification", {
		Title = "📎 Attach",
		Text = "Part '" .. part.Name .. "' menempel ke kamu!",
		Duration = 3
	})
end

detachBtn.MouseButton1Click:Connect(function()
	if weld then
		weld:Destroy()
		weld = nil
	end
	attachedPart = nil
	attachInfo.Text = "Tidak ada part menempel"
	attachInfo.TextColor3 = Color3.fromRGB(180, 255, 180)

	game.StarterGui:SetCore("SendNotification", {
		Title = "🗙 Lepas",
		Text = "Part sudah dilepaskan.",
		Duration = 3
	})
end)

-- ===== Touch Tap Detection (mobile tap)
UserInputService.TouchTapInWorld:Connect(function(position, processed, result)
	if processed then return end
	if result and result.Instance and result.Instance:IsA("BasePart") then
		attachPart(result.Instance)
	end
end)
