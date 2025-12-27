-- ===== SETTING =====
getgenv().AutoHit = false
getgenv().HitDistance = 20
getgenv().HitDelay = 0.15
getgenv().FireworkName = "Firework"
-- ===================

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- ===== GUI ROOT =====
local gui = Instance.new("ScreenGui")
gui.Name = "AutoHitGUI"
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

-- ===== MAIN FRAME =====
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,260,0,220)
main.Position = UDim2.new(0.5,-130,0.5,-110)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Visible = true
main.Active = true
main.Draggable = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

-- ===== TITLE =====
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "🔥 Auto Hit Firework"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- ===== BUTTON CREATOR =====
local function createBtn(text, y)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(1,-20,0,40)
    b.Position = UDim2.new(0,10,0,y)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

local autoBtn = createBtn("Auto Hit : OFF", 50)
local tpBtn   = createBtn("Teleport ke Firework", 95)
local hideBtn = createBtn("Hide GUI", 145)

-- ===== SHOW BUTTON (FLOATING) =====
local showBtn = Instance.new("TextButton", gui)
showBtn.Size = UDim2.new(0,60,0,60)
showBtn.Position = UDim2.new(0,20,0.5,-30)
showBtn.Text = "SHOW"
showBtn.Font = Enum.Font.GothamBold
showBtn.TextSize = 14
showBtn.TextColor3 = Color3.new(1,1,1)
showBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
showBtn.Visible = false
showBtn.Active = true
showBtn.Draggable = true

Instance.new("UICorner", showBtn).CornerRadius = UDim.new(1,0)

-- ===== FUNCTIONS =====
local function getFirework()
    for _,v in pairs(workspace:GetDescendants()) do
        if v.Name == getgenv().FireworkName and v:IsA("BasePart") then
            return v
        end
    end
end

local function tpFirework()
    local fw = getFirework()
    if fw and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = fw.CFrame + Vector3.new(0,3,0)
    end
end

local function getTarget()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = lp.Character.HumanoidRootPart

    for _,m in pairs(workspace:GetChildren()) do
        if m:IsA("Model") and m ~= lp.Character then
            local hum = m:FindFirstChildOfClass("Humanoid")
            local root = m:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 then
                if (root.Position - hrp.Position).Magnitude <= getgenv().HitDistance then
                    return m
                end
            end
        end
    end
end

-- ===== BUTTON EVENTS =====
autoBtn.MouseButton1Click:Connect(function()
    getgenv().AutoHit = not getgenv().AutoHit
    autoBtn.Text = "Auto Hit : " .. (getgenv().AutoHit and "ON" or "OFF")
end)

tpBtn.MouseButton1Click:Connect(tpFirework)

hideBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    showBtn.Visible = true
end)

showBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    showBtn.Visible = false
end)

-- ===== AUTO HIT LOOP =====
task.spawn(function()
    while task.wait(getgenv().HitDelay) do
        if getgenv().AutoHit then
            local target = getTarget()
            if target then
                pcall(function()
                    for _,tool in pairs(lp.Character:GetChildren()) do
                        if tool:IsA("Tool") then
                            tool:Activate()
                        end
                    end
                end)
            end
        end
    end
end)

print("✅ Auto Hit + TP Firework GUI Loaded")
