--// GUI Fly Script (Rapih) //--

local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

--// Main GUI
main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

--// Frame
Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.1, 0, 0.38, 0)
Frame.Size = UDim2.new(0, 190, 0, 57)
Frame.Active = true
Frame.Draggable = true

--// Buttons & Labels
up.Name = "go up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Size = UDim2.new(0, 44, 0, 28)
up.Font = Enum.Font.SourceSans
up.Text = "GO UP"
up.TextColor3 = Color3.new(0, 0, 0)
up.TextSize = 14

down.Name = "go down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0.49, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "GO DOWN"
down.TextColor3 = Color3.new(0, 0, 0)
down.TextSize = 14

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.70, 0, 0.49, 0)
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "fly"
onof.TextColor3 = Color3.new(0, 0, 0)
onof.TextSize = 14

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.47, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "GLITCH"
TextLabel.TextColor3 = Color3.new(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextWrapped = true

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0.23, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "+"
plus.TextColor3 = Color3.new(0, 0, 0)
plus.TextScaled = true
plus.TextWrapped = true

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speed.Position = UDim2.new(0.47, 0, 0.49, 0)
speed.Size = UDim2.new(0, 44, 0, 28)
speed.Font = Enum.Font.SourceSans
speed.Text = "1"
speed.TextColor3 = Color3.new(0, 0, 0)
speed.TextScaled = true
speed.TextWrapped = true

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Position = UDim2.new(0.23, 0, 0.49, 0)
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Font = Enum.Font.SourceSans
mine.Text = "-"
mine.TextColor3 = Color3.new(0, 0, 0)
mine.TextScaled = true
mine.TextWrapped = true

closebutton.Name = "Close"
closebutton.Parent = Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Font = Enum.Font.SourceSans
closebutton.Size = UDim2.new(0, 45, 0, 28)
closebutton.Text = "Delete"
closebutton.TextSize = 20
closebutton.Position = UDim2.new(0, 0, -1, 27)

mini.Name = "minimize"
mini.Parent = Frame
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini.Font = Enum.Font.SourceSans
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Text = "close"
mini.TextSize = 20
mini.Position = UDim2.new(0, 44, -1, 27)

mini2.Name = "minimize2"
mini2.Parent = Frame
mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini2.Font = Enum.Font.SourceSans
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Text = "open"
mini2.TextSize = 20
mini2.Position = UDim2.new(0, 44, -1, 57)
mini2.Visible = false

--// Variables
local speeds = 10
local speaker = game:GetService("Players").LocalPlayer
local chr = speaker.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
local nowe = false

--// Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "FLY UNKNOWN VERSION",
	Text = "By Glitch",
	Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150",
	Duration = 5
})

--// Rest of Script (Fly, Controls, Speed adjust, Close, Minimize dll) masih sama
-- (Aku gak ubah logikanya, cuma rapiin & benerin parent + event)