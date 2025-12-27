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

-- ================= DRAWING UI =================
local Drawing = Drawing
local UIS = game:GetService("UserInputService")

local UI = {
    Open = true,
    X = 100,
    Y = 200,
    W = 240,
    H = 210
}

local function box(x,y,w,h)
    local b = Drawing.new("Square")
    b.Position = Vector2.new(x,y)
    b.Size = Vector2.new(w,h)
    b.Color = Color3.fromRGB(25,25,25)
    b.Filled = true
    b.Thickness = 1
    return b
end

local function text(txt,x,y)
    local t = Drawing.new("Text")
    t.Text = txt
    t.Position = Vector2.new(x,y)
    t.Size = 18
    t.Color = Color3.new(1,1,1)
    t.Outline = true
    return t
end

local bg = box(UI.X,UI.Y,UI.W,UI.H)
local title = text("🔥 FIREWORK FARM (DELTA)", UI.X+15, UI.Y+10)

local tpTxt = text("Teleport : OFF", UI.X+15, UI.Y+50)
local acTxt = text("AutoClick : OFF", UI.X+15, UI.Y+80)
local tpDelayTxt = text("TP Delay : "..getgenv().TeleportDelay, UI.X+15, UI.Y+115)
local acDelayTxt = text("Click Delay : "..getgenv().ClickDelay, UI.X+15, UI.Y+145)
local closeTxt = text("[ TAP TO CLOSE ]", UI.X+15, UI.Y+175)

-- ================= INPUT =================
UIS.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.Touch then return end
    local pos = input.Position

    local function hit(x,y,w,h)
        return pos.X >= x and pos.X <= x+w and pos.Y >= y and pos.Y <= y+h
    end

    if hit(UI.X,UI.Y+45,UI.W,25) then
        getgenv().TeleportFirework = not getgenv().TeleportFirework
        tpTxt.Text = "Teleport : "..(getgenv().TeleportFirework and "ON" or "OFF")
    elseif hit(UI.X,UI.Y+75,UI.W,25) then
        getgenv().AutoClick = not getgenv().AutoClick
        acTxt.Text = "AutoClick : "..(getgenv().AutoClick and "ON" or "OFF")
    elseif hit(UI.X,UI.Y+105,UI.W,25) then
        getgenv().TeleportDelay = math.max(0.1, getgenv().TeleportDelay - 0.1)
        tpDelayTxt.Text = "TP Delay : "..string.format("%.1f", getgenv().TeleportDelay)
    elseif hit(UI.X,UI.Y+135,UI.W,25) then
        getgenv().ClickDelay = math.max(0.1, getgenv().ClickDelay - 0.1)
        acDelayTxt.Text = "Click Delay : "..string.format("%.1f", getgenv().ClickDelay)
    elseif hit(UI.X,UI.Y+170,UI.W,25) then
        bg:Remove()
        title:Remove()
        tpTxt:Remove()
        acTxt:Remove()
        tpDelayTxt:Remove()
        acDelayTxt:Remove()
        closeTxt:Remove()
    end
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
            VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(0.05)
            VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(getgenv().ClickDelay)
        else
            task.wait(0.2)
        end
    end
end)
