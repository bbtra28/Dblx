local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local label = Instance.new("TextLabel", gui)
label.Size = UDim2.new(1, 0, 0, 50)
label.BackgroundTransparency = 0.5
label.TextScaled = true
label.TextColor3 = Color3.new(1,1,1)
label.BackgroundColor3 = Color3.new(0,0,0)
label.Text = "Scanning remotes..."

local found = {}

for _, v in pairs(game:GetDescendants()) do
    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
        table.insert(found, v:GetFullName())
    end
end

label.Text = "Found: " .. table.concat(found, " | ")
