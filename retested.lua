-- ===== CONFIG =====
getgenv().AutoFarm = false
getgenv().Delay = 0.25

-- ===== SERVICES =====
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")

-- ===== TOUCH ATTACK (MOBILE) =====
local function attack()
    local tool = Player.Character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
    end
end

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "FireworkMobileGUI"
gui.ResetOnSpawn = false
gui.Parent = Player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,90)
frame.Position = UDim2.new(0.5,-110,0.75,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1,-20,0,50)
btn.Position = UDim2.new(0,10,0,20)
btn.BackgroundColor3 = Color3.fromRGB(180,0,0)
btn.Text = "AUTO FIREWORK : OFF"
btn.TextColor3 = Color3.new(1,1,1)
btn.TextScaled = true
btn.BorderSizePixel = 0

Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

-- ===== BUTTON TOUCH =====
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
            local fw = workspace:FindFirstChild("SpawnedFireworks")
            if fw then
                for i = 1,49 do
                    if not getgenv().AutoFarm then break end
                    local folder = fw:FindFirstChild(tostring(i))
                    if folder and folder:FindFirstChild("Rocket") then
                        local rocket = folder.Rocket
                        if rocket:IsA("BasePart") then
                            HRP.CFrame = rocket.CFrame * CFrame.new(0,0,-3)
                            task.wait(0.15)
                            attack()
                            task.wait(getgenv().Delay)
                        end
                    end
                end
            end
        end
    end
end)
