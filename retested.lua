-- 🌐 Roblox Server Switch PRO
-- ✨ Fitur: Acak / Kosong / Baru / Luar (Ping Tinggi)
-- 💻 Kompatibel: Arceus X, Delta, VegaX, Codex, Fluxus, Hydrogen

-- GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local RandomBtn = Instance.new("TextButton")
local EmptyBtn = Instance.new("TextButton")
local NewBtn = Instance.new("TextButton")
local HighPingBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")
local UIS = game:GetService("UserInputService")

ScreenGui.Name = "ServerHopGUI"
ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.35, 0, 0.35, 0)
Frame.Size = UDim2.new(0, 260, 0, 260)
Frame.Active = true

Title.Parent = Frame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🌍 Server Switch PRO"
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20

local function makeButton(btn, text, pos)
	btn.Parent = Frame
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	btn.BorderSizePixel = 0
	btn.Position = pos
	btn.Size = UDim2.new(0, 230, 0, 40)
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextSize = 18
	btn.Font = Enum.Font.SourceSansBold
end

makeButton(RandomBtn, "🔄 Server Acak", UDim2.new(0, 15, 0, 50))
makeButton(EmptyBtn, "🧍 Server Kosong", UDim2.new(0, 15, 0, 95))
makeButton(NewBtn, "🆕 Server Baru", UDim2.new(0, 15, 0, 140))
makeButton(HighPingBtn, "🌎 Server Luar (High Ping)", UDim2.new(0, 15, 0, 185))

CloseBtn.Parent = Frame
CloseBtn.Text = "✖"
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = Color3.new(1, 0, 0)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 20

-- Drag GUI
local dragging, dragInput, dragStart, startPos
Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position
	end
end)

Frame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Server Hop
local HttpService = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")
local PlaceID = game.PlaceId
local API = "https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Desc&limit=100"

local function getServers(filter)
	local servers = {}
	local cursor = ""
	repeat
		local response = game:HttpGet(API .. (cursor ~= "" and "&cursor=" .. cursor or ""))
		local data = HttpService:JSONDecode(response)
		for _, v in ipairs(data.data) do
			if v.playing < v.maxPlayers then
				if filter == "empty" and v.playing <= 5 then
					table.insert(servers, v.id)
				elseif filter == "new" and v.playing > 0 and v.playing < 10 then
					table.insert(servers, v.id)
				elseif filter == "random" then
					table.insert(servers, v.id)
				elseif filter == "highping" and v.ping and v.ping > 250 then
					table.insert(servers, v.id)
				end
			end
		end
		cursor = data.nextPageCursor or ""
	until cursor == nil
	return servers
end

local function teleport(filter)
	local servers = getServers(filter)
	if #servers > 0 then
		local randomServer = servers[math.random(1, #servers)]
		game.StarterGui:SetCore("SendNotification", {
			Title = "Server Switch",
			Text = "🔁 Pindah server...",
			Duration = 2
		})
		TPS:TeleportToPlaceInstance(PlaceID, randomServer)
	else
		game.StarterGui:SetCore("SendNotification", {
			Title = "Server Switch",
			Text = "❌ Tidak ada server cocok ditemukan!",
			Duration = 3
		})
	end
end

RandomBtn.MouseButton1Click:Connect(function() teleport("random") end)
EmptyBtn.MouseButton1Click:Connect(function() teleport("empty") end)
NewBtn.MouseButton1Click:Connect(function() teleport("new") end)
HighPingBtn.MouseButton1Click:Connect(function() teleport("highping") end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
