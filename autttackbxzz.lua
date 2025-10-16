-- 🧲 View + Attach GUI (supports unanchored parts)
-- safe for executor (client-side visual use)
-- by ChatGPT (GPT-5)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AttachPartGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 380)
frame.Position = UDim2.new(0.35, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.Text = "🎥 Player Viewer + Attach Part"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 0, 180)
scroll.Position = UDim2.new(0, 5, 0, 40)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6
scroll.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local partBox = Instance.new("TextBox", frame)
partBox.Size = UDim2.new(1, -20, 0, 30)
partBox.Position = UDim2.new(0, 10, 0, 230)
partBox.PlaceholderText = "Nama Part di Workspace"
partBox.Text = ""
partBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
partBox.TextColor3 = Color3.new(1, 1, 1)
partBox.ClearTextOnFocus = false

local attachBtn = Instance.new("TextButton", frame)
attachBtn.Size = UDim2.new(0.45, 0, 0, 35)
attachBtn.Position = UDim2.new(0.05, 0, 0, 270)
attachBtn.Text = "📎 Attach"
attachBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
attachBtn.TextColor3 = Color3.new(1, 1, 1)
attachBtn.Font = Enum.Font.SourceSansBold
attachBtn.TextSize = 16

local detachBtn = Instance.new("TextButton", frame)
detachBtn.Size = UDim2.new(0.45, 0, 0, 35)
detachBtn.Position = UDim2.new(0.5, 0, 0, 270)
detachBtn.Text = "🗙 Detach"
detachBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
detachBtn.TextColor3 = Color3.new(1, 1, 1)
detachBtn.Font = Enum.Font.SourceSansBold
detachBtn.TextSize = 16

local backBtn = Instance.new("TextButton", frame)
backBtn.Size = UDim2.new(1, -20, 0, 35)
backBtn.Position = UDim2.new(0, 10, 1, -45)
backBtn.Text = "🔙 Kembali ke Kamera Sendiri"
backBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
backBtn.TextColor3 = Color3.new(1, 1, 1)
backBtn.Font = Enum.Font.SourceSansBold
backBtn.TextSize = 16

local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0, 170, 0, 35)
toggle.Position = UDim2.new(0, 20, 0, 20)
toggle.Text = "📂 Show Viewer GUI"
toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 16

-- ===== Toggle Show/Hide =====
local visible = true
toggle.MouseButton1Click:Connect(function()
	visible = not visible
	frame.Visible = visible
	toggle.Text = visible and "📁 Hide Viewer GUI" or "📂 Show Viewer GUI"
end)

-- ===== Player List + Camera View =====
local currentView = nil
local function viewPlayer(target)
	if target and target.Character and target.Character:FindFirstChild("Humanoid") then
		Camera.CameraSubject = target.Character.Humanoid
		currentView = target
		game.StarterGui:SetCore("SendNotification", {
			Title = "🎥 View Camera",
			Text = "Sekarang melihat: " .. target.Name,
			Duration = 3
		})
	end
end

backBtn.MouseButton1Click:Connect(function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		Camera.CameraSubject = LocalPlayer.Character.Humanoid
	end
	currentView = nil
	game.StarterGui:SetCore("SendNotification", {
		Title = "👀",
		Text = "Kembali ke kamera kamu sendiri",
		Duration = 3
	})
end)

local function refreshList()
	for _, child in pairs(scroll:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end

	local y = 0
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local btn = Instance.new("TextButton", scroll)
			btn.Size = UDim2.new(1, -10, 0, 30)
			btn.Position = UDim2.new(0, 5, 0, y)
			btn.Text = "👤 " .. plr.Name
			btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.Font = Enum.Font.SourceSansBold
			btn.TextSize = 16

			btn.MouseButton1Click:Connect(function()
				viewPlayer(plr)
			end)

			y = y + 35
		end
	end
	scroll.CanvasSize = UDim2.new(0, 0, 0, y)
end

Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)
refreshList()

-- ===== Attach Part =====
local attachedPart
local weld

attachBtn.MouseButton1Click:Connect(function()
	local partName = partBox.Text
	if partName == "" then return end

	local part = workspace:FindFirstChild(partName)
	if not part or not part:IsA("BasePart") then
		game.StarterGui:SetCore("SendNotification", {
			Title = "❌ Gagal",
			Text = "Part tidak ditemukan di Workspace!",
			Duration = 3
		})
		return
	end

	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- Hapus weld lama
	if weld then weld:Destroy() end

	-- Posisikan dulu
	part.CFrame = hrp.CFrame * CFrame.new(0, 3, 0)
	part.Anchored = false

	-- Buat WeldConstraint supaya nempel stabil
	weld = Instance.new("WeldConstraint")
	weld.Part0 = hrp
	weld.Part1 = part
	weld.Parent = part

	attachedPart = part

	game.StarterGui:SetCore("SendNotification", {
		Title = "📦 Attached",
		Text = partName .. " nempel di kamu (unanchored).",
		Duration = 3
	})
end)

detachBtn.MouseButton1Click:Connect(function()
	if weld then
		weld:Destroy()
		weld = nil
	end
	attachedPart = nil
	game.StarterGui:SetCore("SendNotification", {
		Title = "🗙 Lepas",
		Text = "Part sudah dilepas.",
		Duration = 3
	})
end)
