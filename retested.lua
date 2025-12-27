-- ========= CONFIG =========
getgenv().AutoHit = false
getgenv().HitDelay = 0.15
getgenv().FireworkName = "firework" -- fleksibel
getgenv().NoDamageTime = 2 -- detik sebelum ganti firework
-- ==========================

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- ========= GUI =========
local gui = Instance.new("ScreenGui")
gui.Name = "FireworkFinalGUI"
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,260,0,210)
main.Position = UDim2.new(0.5,-130,0.5,-105)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "🔥 Auto Firework (FINAL)"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local function makeBtn(txt, y)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(1,-20,0,40)
    b.Position = UDim2.new(0,10,0,y)
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

local autoBtn = makeBtn("Auto Hit : OFF", 50)
local hideBtn = makeBtn("Hide GUI", 100)

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

-- ========= FIREWORK FINDER =========
local ignored = {}
local currentFirework
local lastHitTime = tick()

local function getFireworks()
    local list = {}
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart")
        and string.find(string.lower(v.Name), string.lower(getgenv().FireworkName))
        and not ignored[v] then
            table.insert(list, v)
        end
    end
    return list
end

local function pickFirework()
    local list = getFireworks()
    if #list > 0 then
        currentFirework = list[math.random(1, #list)]
        lastHitTime = tick()
    else
        currentFirework = nil
    end
end

-- ========= BUTTON EVENTS =========
autoBtn.MouseButton1Click:Connect(function()
    getgenv().AutoHit = not getgenv().AutoHit
    autoBtn.Text = "Auto Hit : " .. (getgenv().AutoHit and "ON" or "OFF")
end)

hideBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    showBtn.Visible = true
end)

showBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    showBtn.Visible = false
end)

-- ========= AUTO HIT LOOP =========
task.spawn(function()
    while task.wait(getgenv().HitDelay) do
        if not getgenv().AutoHit then continue end

        local char = lp.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

        if not currentFirework or not currentFirework.Parent then
            pickFirework()
            continue
        end

        -- Dekatkan ke firework
        char.HumanoidRootPart.CFrame =
            currentFirework.CFrame * CFrame.new(0,0,-3)

        -- Serang pakai tool
        for _,tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                tool:Activate()
            end
        end

        -- Jika terlalu lama tidak ada progress → ganti firework
        if tick() - lastHitTime > getgenv().NoDamageTime then
            ignored[currentFirework] = true
            currentFirework = nil
        end
    end
end)

print("✅ FINAL Auto Firework + Auto Switch Loaded")
