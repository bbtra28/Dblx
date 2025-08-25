-- Fly & Speed GUI Script (Rapihan)

-- Variabel kontrol
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}
local speed = 0
local speeds = 1
local tpwalking = false
local nowe = false

-- Fungsi pergerakan
if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
    bv.velocity = (
        (game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(
            ctrl.l + ctrl.r,
            (ctrl.f + ctrl.b) * 0.2,
            0
        ).p - game.Workspace.CurrentCamera.CoordinateFrame.p)
    ) * speed

    lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
    bv.velocity = (
        (game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f + lastctrl.b)) +
        ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(
            lastctrl.l + lastctrl.r,
            (lastctrl.f + lastctrl.b) * 0.2,
            0
        ).p - game.Workspace.CurrentCamera.CoordinateFrame.p))
    ) * speed
else
    bv.velocity = Vector3.new(0, 0, 0)
end

bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * 
    CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0)

-- Reset kontrol
ctrl = {f = 0, b = 0, l = 0, r = 0}
lastctrl = {f = 0, b = 0, l = 0, r = 0}
speed = 0
bg:Destroy()
bv:Destroy()

plr.Character.Humanoid.PlatformStand = false
game.Players.LocalPlayer.Character.Animate.Disabled = false
tpwalking = false

-- Tombol naik
local tis
up.MouseButton1Down:Connect(function()
    tis = up.MouseEnter:Connect(function()
        while tis do
            task.wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0)
        end
    end)
end)

up.MouseLeave:Connect(function()
    if tis then
        tis:Disconnect()
        tis = nil
    end
end)

-- Tombol turun
local dis
down.MouseButton1Down:Connect(function()
    dis = down.MouseEnter:Connect(function()
        while dis do
            task.wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -1, 0)
        end
    end)
end)

down.MouseLeave:Connect(function()
    if dis then
        dis:Disconnect()
        dis = nil
    end
end)

-- Reset setelah respawn
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.7)
    game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
    game.Players.LocalPlayer.Character.Animate.Disabled = false
end)

-- Tombol tambah kecepatan
plus.MouseButton1Down:Connect(function()
    speeds = speeds + 1
    speed.Text = speeds

    if nowe == true then
        tpwalking = false
        for i = 1, speeds do
            spawn(function()
                local hb = game:GetService("RunService").Heartbeat
                tpwalking = true
                local chr = game.Players.LocalPlayer.Character
                local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

                while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                    if hum.MoveDirection.Magnitude > 0 then
                        chr:TranslateBy(hum.MoveDirection)
                    end
                end
            end)
        end
    end
end)

-- Tombol kurang kecepatan
mine.MouseButton1Down:Connect(function()
    if speeds == 1 then
        speed.Text = "cannot be less than 1"
        task.wait(1)
        speed.Text = speeds
    else
        speeds = speeds - 1
        speed.Text = speeds

        if nowe == true then
            tpwalking = false
            for i = 1, speeds do
                spawn(function()
                    local hb = game:GetService("RunService").Heartbeat
                    tpwalking = true
                    local chr = game.Players.LocalPlayer.Character
                    local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

                    while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                        if hum.MoveDirection.Magnitude > 0 then
                            chr:TranslateBy(hum.MoveDirection)
                        end
                    end
                end)
            end
        end
    end
end)

-- Tombol tutup GUI
closebutton.MouseButton1Click:Connect(function()
    main:Destroy()
end)

-- Tombol minimize
mini.MouseButton1Click:Connect(function()
    up.Visible = false
    down.Visible = false
    onof.Visible = false
    plus.Visible = false
    speed.Visible = false
    mine.Visible = false
    mini.Visible = false
    mini2.Visible = true
    main.Frame.BackgroundTransparency = 1
    closebutton.Position = UDim2.new(0, 0, -1, 57)
end)

-- Tombol restore GUI
mini2.MouseButton1Click:Connect(function()
    up.Visible = true
    down.Visible = true
    onof.Visible = true
    plus.Visible = true
    speed.Visible = true
    mine.Visible = true
    mini.Visible = true
    mini2.Visible = false
    main.Frame.BackgroundTransparency = 0
    closebutton.Position = UDim2.new(0, 0, -1, 27)
end)