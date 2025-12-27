-- ================= CONFIG =================
getgenv().TeleportFirework = false
getgenv().TeleportDelay = 0.7

getgenv().AutoClick = false
getgenv().ClickDelay = 0.5

-- ================= SERVICES =================
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local Player = Players.LocalPlayer

-- ================= CHARACTER =================
local Character = Player.Character or Player.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

Player.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
end)

-- ================= GUI =================
local gui = Instance.new("ScreenGui", Player.PlayerGui)
gui.Name = "HP_Teleport_GUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 280)
frame.Position = UDim2.new(0.5, -130, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

local function button(text, y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0, 230, 0, 40)
    b.Position = UDim2.new(0, 15, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true
    b.Text = text
    return b
end

local function box(placeholder, y)
    local t = Instance.new("TextBox", frame)
    t.Size = UDim2.new(0, 230, 0, 35)
    t.Position = UDim2.new(0, 15, 0, y)
    t.BackgroundColor3 = Color3.fromRGB(45,45,45)
    t.TextColor3 = Color3.new(1,1,1)
    t.PlaceholderText = placeholder
    t.TextScaled = true
    t.ClearTextOnFocus = false
    return t
end

local tpBtn = button("Teleport : OFF", 10)
local acBtn = button("Auto Click : OFF", 55)

local tpDelayBox = box("Teleport Delay (ex: 0.7)", 105)
local acDelayBox = box("Click Delay (ex: 0.5)", 150)

local closeBtn = button("CLOSE GUI", 200)

-- ================= BUTTON LOGIC =================
tpBtn.MouseButton1Click:Connect(function()
    getgenv().TeleportFirework = not getgenv().TeleportFirework
    tpBtn.Text = "Teleport : "..(getgenv().TeleportFirework and "ON" or "OFF")
end)

acBtn.MouseButton1Click:Connect(function()
    getgenv().AutoClick = not getgenv().AutoClick
    acBtn.Text = "Auto Click : "..(getgenv().AutoClick and "ON" or "OFF")
end)

tpDelayBox.FocusLost:Connect(function()
    local v = tonumber(tpDelayBox.Text)
    if v then getgenv().TeleportDelay = v end
end)

acDelayBox.FocusLost:Connect(function()
    local v = tonumber(acDelayBox.Text)
    if v then getgenv().ClickDelay = v end
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ================= TELEPORT =================
task.spawn(function()
    while task.wait(0.2) do
        if getgenv().TeleportFirework then
            for i = 1, 50 do
                if not getgenv().TeleportFirework then break end

                local map = workspace:FindFirstChild("ScriptedMap")
                if map and map:FindFirstChild("SpawnedFireworks") then
                    local fw = map.SpawnedFireworks:FindFirstChild(tostring(i))
                    if fw and fw:FindFirstChild("Rocket") then
                        local part = fw.Rocket:FindFirstChild("MainColor")
                        if part then
                            HRP.CFrame = part.CFrame + Vector3.new(0,3,0)
                            task.wait(getgenv().TeleportDelay)
                        end
                    end
                end
            end
        end
    end
end)

-- ================= AUTO CLICK =================
task.spawn(function()
    while task.wait() do
        if getgenv().AutoClick then
            pcall(function()
                VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(0.05)
                VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
            task.wait(getgenv().ClickDelay)
        else
            task.wait(0.2)
        end
    end
end)