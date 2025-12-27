-- ========= CONFIG =========
getgenv().AutoTP = false
getgenv().TPDelay = 0.3
getgenv().FireworkName = "firework" -- fleksibel
getgenv().SwitchTime = 2 -- detik sebelum ganti firework
-- ==========================

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- ========= GUI =========
local gui = Instance.new("ScreenGui")
gui.Name = "FireworkTPGUI"
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

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
title.Text = "🚀 Auto TP Firework"
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

local tpBtn = makeBtn("Auto TP : OFF", 50)
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
local currentFW
local lastSwitch = tick()

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
        currentFW = list[math.random(1, #list)]
        lastSwitch = tick()
    else
        currentFW = nil
    end
end

-- ========= BUTTON EVENTS =========
tpBtn.MouseButton1Click:Connect(function()
    getgenv().AutoTP = not getgenv().AutoTP
    tpBtn.Text = "Auto TP : " .. (getgenv().AutoTP and "ON" or "OFF")
end)

hideBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    showBtn.Visible = true
end)

showBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    showBtn.Visible = false
end)

-- ========= AUTO TP LOOP =========
task.spawn(function()
    while task.wait(getgenv().TPDelay) do
        if not getgenv().AutoTP then continue end

        local char = lp.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

        if not currentFW or not currentFW.Parent then
            pickFirework()
            continue
        end

        -- Teleport ke Firework
        char.HumanoidRootPart.CFrame =
            currentFW.CFrame * CFrame.new(0, 0, -4)

        -- Auto ganti setelah waktu tertentu
        if tick() - lastSwitch > getgenv().SwitchTime then
            ignored[currentFW] = true
            currentFW = nil
        end
    end
end)

print("✅ Auto Teleport Firework (Only TP) Loaded")
