-- ========= CONFIG =========
getgenv().AutoClick = false
getgenv().FireworkKeyword = "firework" -- fleksibel
getgenv().ClickDelay = 0.1
getgenv().NoDamageTime = 2 -- detik sebelum ganti target
-- ==========================

local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
local lp = Players.LocalPlayer

-- ========= GUI =========
local gui = Instance.new("ScreenGui", lp.PlayerGui)
gui.Name = "FireworkClickGUI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,260,0,200)
main.Position = UDim2.new(0.5,-130,0.5,-100)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "🔥 Auto Click Firework"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local function btn(txt,y)
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

local autoBtn = btn("Auto Click : OFF", 50)
local hideBtn = btn("Hide GUI", 100)

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

autoBtn.MouseButton1Click:Connect(function()
    getgenv().AutoClick = not getgenv().AutoClick
    autoBtn.Text = "Auto Click : "..(getgenv().AutoClick and "ON" or "OFF")
end)

hideBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    showBtn.Visible = true
end)

showBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    showBtn.Visible = false
end)

-- ========= FIREWORK SYSTEM =========
local ignored = {}
local lastProgress = tick()
local currentTarget

local function getFireworks()
    local list = {}
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart")
        and string.find(string.lower(v.Name), getgenv().FireworkKeyword)
        and not ignored[v] then
            table.insert(list, v)
        end
    end
    return list
end

local function pickTarget()
    local list = getFireworks()
    if #list > 0 then
        currentTarget = list[math.random(1,#list)]
        lastProgress = tick()
    end
end

-- ========= AUTO CLICK LOOP =========
task.spawn(function()
    while task.wait(getgenv().ClickDelay) do
        if not getgenv().AutoClick then continue end

        local char = lp.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

        if not currentTarget or not currentTarget.Parent then
            pickTarget()
            continue
        end

        -- Dekatkan ke firework
        char.HumanoidRootPart.CFrame =
            currentTarget.CFrame * CFrame.new(0,0,-4)

        -- Auto mouse click
        VIM:SendMouseButtonEvent(0,0,0,true,game,0)
        VIM:SendMouseButtonEvent(0,0,0,false,game,0)

        -- Jika terlalu lama → ganti target
        if tick() - lastProgress > getgenv().NoDamageTime then
            ignored[currentTarget] = true
            currentTarget = nil
        end
    end
end)

print("✅ FINAL Auto Click Firework Aktif")
