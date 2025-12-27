-- ===== CONFIG =====
getgenv().AutoFarm = false
getgenv().Delay = 0.3

-- ===== SERVICES =====
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local function getChar()
    return Player.Character or Player.CharacterAdded:Wait()
end

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "FireworkMobileGUI"
gui.ResetOnSpawn = false
gui.Parent = Player:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0,220,0,50)
btn.Position = UDim2.new(0.5,-110,0.8,0)
btn.BackgroundColor3 = Color3.fromRGB(180,0,0)
btn.Text = "AUTO FIREWORK : OFF"
btn.TextColor3 = Color3.new(1,1,1)
btn.TextScaled = true
btn.BorderSizePixel = 0
Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

-- ===== BUTTON =====
btn.Activated:Connect(function()
    getgenv().AutoFarm = not getgenv().AutoFarm
    if getgenv().AutoFarm then
        btn.Text = "AUTO FIREWORK : ON"
        btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
    else
        btn.Text = "AUTO FIREWORK : OFF"
        btn.BackgroundColor3 = Color3.fromRGB(180,0,0)
    end
end)

-- ===== MAIN LOOP =====
task.spawn(function()
    while task.wait() do
        if getgenv().AutoFarm then
            local char = getChar()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local tool = char:FindFirstChildOfClass("Tool")

            local fw = workspace:FindFirstChild("Fireworks")
            if hrp and tool and fw then
                local rocket = fw:FindFirstChild("Rocket", true)
                if rocket and rocket:IsA("BasePart") then
                    -- TELEPORT
                    hrp.CFrame = rocket.CFrame * CFrame.new(0,0,-3)
                    task.wait(0.15)

                    -- HIT (MOBILE)
                    tool:Activate()
                    task.wait(getgenv().Delay)
                end
            end
        end
    end
end)
