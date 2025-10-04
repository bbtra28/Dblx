local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local label = Instance.new("TextLabel", gui)
label.Size = UDim2.new(1, 0, 0, 50)
label.BackgroundTransparency = 0.5
label.TextScaled = true
label.TextColor3 = Color3.new(1,1,1)
label.BackgroundColor3 = Color3.new(0,0,0)

local names = {}
for i,v in pairs(workspace:GetChildren()) do
    table.insert(names, v.Name)
end
label.Text = table.concat(names, " | ")
