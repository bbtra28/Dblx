-- 🟢 Auto Walk GUI + Show/Hide
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local PathfindingService = game:GetService("PathfindingService")
local CoreGui = game.CoreGui

-- === GUI Utama ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoWalkGUI"
ScreenGui.Parent = CoreGui

-- === Frame Utama ===
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 140)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

-- === Title ===
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🚶 Auto Walk"
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = Frame

-- === Tombol Tandai ===
local markButton = Instance.new("TextButton")
markButton.Size = UDim2.new(1, -20, 0, 30)
markButton.Position = UDim2.new(0, 10, 0, 40)
markButton.Text = "🎯 Tandai Posisi"
markButton.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
markButton.TextColor3 = Color3.new(1, 1, 1)
markButton.Font = Enum.Font.SourceSansBold
markButton.TextSize = 18
markButton.Parent = Frame
Instance.new("UICorner", markButton)

-- === Tombol Jalan ===
local walkButton = Instance.new("TextButton")
walkButton.Size = UDim2.new(1, -20, 0, 30)
walkButton.Position = UDim2.new(0, 10, 0, 80)
walkButton.Text = "🚶 Mulai Jalan"
walkButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
walkButton.TextColor3 = Color3.new(1, 1, 1)
walkButton.Font = Enum.Font.SourceSansBold
walkButton.TextSize = 18
walkButton.Parent = Frame
Instance.new("UICorner", walkButton)

-- === Tombol Hide ===
local hideButton = Instance.new("TextButton")
hideButton.Size = UDim2.new(1, -20, 0, 30)
hideButton.Position = UDim2.new(0, 10, 0, 115)
hideButton.Text = "👁️ Hide GUI"
hideButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
hideButton.TextColor3 = Color3.new(1, 1, 1)
hideButton.Font = Enum.Font.SourceSansBold
hideButton.TextSize = 18
hideButton.Parent = Frame
Instance.new("UICorner", hideButton)

-- === Tombol Show (di luar frame) ===
local showButton = Instance.new("TextButton")
showButton.Size = UDim2.new(0, 120, 0, 40)
showButton.Position = UDim2.new(0.05, 0, 0.3, 0)
showButton.Text = "👁️ Show GUI"
showButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
showButton.TextColor3 = Color3.new(1, 1, 1)
showButton.Font = Enum.Font.SourceSansBold
showButton.TextSize = 18
showButton.Visible = false
showButton.Draggable = true
showButton.Parent = ScreenGui
Instance.new("UICorner", showButton)

-- === Variabel ===
local targetPos = nil
local walking = false

-- === Fungsi Jalan Otomatis ===
local function WalkTo(position)
	local character = LocalPlayer.Character
	if not character or not character:FindFirstChild("Humanoid") then return end

	local humanoid = character:FindFirstChild("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local path = PathfindingService:CreatePath({
		AgentRadius = 2,
		AgentHeight = 5,
		AgentCanJump = true
	})
	
	path:ComputeAsync(root.Position, position)
	local waypoints = path:GetWaypoints()
	walking = true
	
	for _, waypoint in ipairs(waypoints) do
		if not walking then break end
		humanoid:MoveTo(waypoint.Position)
		humanoid.MoveToFinished:Wait()
	end
	
	walking = false
end

-- === Event Klik "Tandai Posisi" ===
markButton.MouseButton1Click:Connect(function()
	game.StarterGui:SetCore("SendNotification", {
		Title = "Auto Walk";
		Text = "Klik tanah untuk tandai posisi!";
		Duration = 4;
	})
	
	local connection
	connection = Mouse.Button1Down:Connect(function()
		if Mouse.Target then
			targetPos = Mouse.Hit.p
			game.StarterGui:SetCore("SendNotification", {
				Title = "Posisi Ditandai!";
				Text = string.format("x: %.1f, y: %.1f, z: %.1f", targetPos.X, targetPos.Y, targetPos.Z);
				Duration = 4;
			})
			connection:Disconnect()
		end
	end)
end)

-- === Event Klik "Mulai Jalan" ===
walkButton.MouseButton1Click:Connect(function()
	if targetPos then
		WalkTo(targetPos)
	else
		game.StarterGui:SetCore("SendNotification", {
			Title = "❌ Gagal";
			Text = "Belum ada posisi yang ditandai!";
			Duration = 3;
		})
	end
end)

-- === Event Hide/Show GUI ===
hideButton.MouseButton1Click:Connect(function()
	Frame.Visible = false
	showButton.Visible = true
end)

showButton.MouseButton1Click:Connect(function()
	Frame.Visible = true
	showButton.Visible = false
end)
