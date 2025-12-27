-- ================= CONFIG =================
getgenv().AutoClick = false
getgenv().ClickDelay = 0.5

-- ================= SERVICES =================
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- ================= GUI =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoClickGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 170)
Frame.Position = UDim2.new(0.5, -110, 0.5, -85)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,35)
Title.Text = "AUTO CLICK"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

local Toggle = Instance.new("TextButton", Frame)
Toggle.Size = UDim2.new(0.8,0,0,35)
Toggle.Position = UDim2.new(0.1,0,0.3,0)
Toggle.Text = "OFF"
Toggle.Font = Enum.Font.SourceSansBold
Toggle.TextSize = 18
Toggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
Toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Toggle)

local DelayBox = Instance.new("TextBox", Frame)
DelayBox.Size = UDim2.new(0.8,0,0,35)
DelayBox.Position = UDim2.new(0.1,0,0.6,0)
DelayBox.Text = tostring(getgenv().ClickDelay)
DelayBox.PlaceholderText = "Delay (detik)"
DelayBox.Font = Enum.Font.SourceSans
DelayBox.TextSize = 16
DelayBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
DelayBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", DelayBox)

-- ================= LOGIC =================
Toggle.MouseButton1Click:Connect(function()
	getgenv().AutoClick = not getgenv().AutoClick
	if getgenv().AutoClick then
		Toggle.Text = "ON"
		Toggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
	else
		Toggle.Text = "OFF"
		Toggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
	end
end)

DelayBox.FocusLost:Connect(function()
	local val = tonumber(DelayBox.Text)
	if val and val > 0 then
		getgenv().ClickDelay = val
	end
end)

-- ================= AUTO CLICK LOOP =================
task.spawn(function()
	while true do
		if getgenv().AutoClick then
			VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			task.wait(0.05)
			VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			task.wait(getgenv().ClickDelay)
		else
			task.wait(0.1)
		end
	end
end)
