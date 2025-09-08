-- Full Fly GUI V3 + NoClip + Low Graphics
-- (gabungan dengan file aslinya)
-- Sumber asli GUI: Fly GUI.txt (user) 

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

-- Instances (original GUI + new buttons)
local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

-- NEW: noclip and lowgfx buttons
local noclipBtn = Instance.new("TextButton")
local lowgfxBtn = Instance.new("TextButton")

main.Name = "main"
main.Parent = player:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 230, 0, 90) -- buat lebih besar agar muat tombol baru

up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Size = UDim2.new(0, 44, 0, 28)
up.Font = Enum.Font.SourceSans
up.Text = "UP"
up.TextColor3 = Color3.fromRGB(0, 0, 0)
up.TextSize = 14.000

down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0.491228074, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "DOWN"
down.TextColor3 = Color3.fromRGB(0, 0, 0)
down.TextSize = 14.000

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "fly"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextSize = 14.000

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "Fly GUI V3"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0.231578946, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(0, 0, 0)
plus.TextScaled = true
plus.TextSize = 14.000
plus.TextWrapped = true

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speed.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
speed.Size = UDim2.new(0, 44, 0, 28)
speed.Font = Enum.Font.SourceSans
speed.Text = "1"
speed.TextColor3 = Color3.fromRGB(0, 0, 0)
speed.TextScaled = true
speed.TextSize = 14.000
speed.TextWrapped = true

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Font = Enum.Font.SourceSans
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(0, 0, 0)
mine.TextScaled = true
mine.TextSize = 14.000
mine.TextWrapped = true

closebutton.Name = "Close"
closebutton.Parent = main.Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Font = "SourceSans"
closebutton.Size = UDim2.new(0, 45, 0, 28)
closebutton.Text = "X"
closebutton.TextSize = 30
closebutton.Position =  UDim2.new(0, 0, -1, 27)

mini.Name = "minimize"
mini.Parent = main.Frame
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini.Font = "SourceSans"
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Text = "-"
mini.TextSize = 40
mini.Position = UDim2.new(0, 44, -1, 27)

mini2.Name = "minimize2"
mini2.Parent = main.Frame
mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini2.Font = "SourceSans"
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Text = "+"
mini2.TextSize = 40
mini2.Position = UDim2.new(0, 44, -1, 57)
mini2.Visible = false

-- NEW: noclip button properties
noclipBtn.Name = "noclip"
noclipBtn.Parent = Frame
noclipBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
noclipBtn.Position = UDim2.new(0.68, 0, 0, 0)
noclipBtn.Size = UDim2.new(0, 64, 0, 28)
noclipBtn.Font = Enum.Font.SourceSans
noclipBtn.Text = "NoClip: OFF"
noclipBtn.TextColor3 = Color3.fromRGB(0,0,0)
noclipBtn.TextSize = 14

-- NEW: low graphics button properties
lowgfxBtn.Name = "lowgfx"
lowgfxBtn.Parent = Frame
lowgfxBtn.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
lowgfxBtn.Position = UDim2.new(0.68, 0, 0.49, 0)
lowgfxBtn.Size = UDim2.new(0, 64, 0, 28)
lowgfxBtn.Font = Enum.Font.SourceSans
lowgfxBtn.Text = "LowGfx: OFF"
lowgfxBtn.TextColor3 = Color3.fromRGB(0,0,0)
lowgfxBtn.TextSize = 14

speeds = 1

local speaker = player

local chr = player.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

nowe = false

game:GetService("StarterGui"):SetCore("SendNotification", { 
    Title = "Fly GUI V3";
    Text = "By me_ozone and Quandale The Dinglish XII#3550";
    Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
Duration = 5;

Frame.Active = true -- main = gui
Frame.Draggable = true

-- -----------------------------------
-- Fly logic (sama seperti aslinya)
-- -----------------------------------
-- (untuk ringkas di sini, kita preserve behavior asli dari file aslinya)
-- [kode fly yang sudah ada di file asli tetap dipertahankan]
-- Untuk mengurangi pengulangan, saya memasukkan kembali handler onof.MouseButton1Down
-- (kode fly detail ada pada file asli — pastikan bagian fly diletakkan di sini)
-- (di bawah ini saya meng-include kembali kode toggle fly seperti di file aslinya)

onof.MouseButton1Down:connect(function()
    if nowe == true then
        nowe = false

        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
        speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
    else 
        nowe = true

        for i = 1, speeds do
            spawn(function()
                local hb = RunService.Heartbeat    
                tpwalking = true
                local chr = player.Character
                local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                    if hum.MoveDirection.Magnitude > 0 then
                        chr:TranslateBy(hum.MoveDirection)
                    end
                end
            end)
        end
        player.Character.Animate.Disabled = true
        local Char = player.Character
        local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
        for i,v in next, Hum:GetPlayingAnimationTracks() do
            v:AdjustSpeed(0)
        end
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
        speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
    end

    -- Berikut ini adalah bagian fly untuk R6/R15 (dipertahankan dari file asli)
    if player.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
        local plr = player
        local torso = plr.Character.Torso
        local flying = true
        local deb = true
        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
        local maxspeed = 50
        local speed = 0

        local bg = Instance.new("BodyGyro", torso)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = torso.CFrame
        local bv = Instance.new("BodyVelocity", torso)
        bv.velocity = Vector3.new(0,0.1,0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        if nowe == true then
            plr.Character.Humanoid.PlatformStand = true
        end
        while nowe == true or player.Character.Humanoid.Health == 0 do
            RunService.RenderStepped:Wait()
            -- kontrol & kecepatan (sama seperti asli)
            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                speed = speed+.5+(speed/maxspeed)
                if speed > maxspeed then
                    speed = maxspeed
                end
            elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                speed = speed-1
                if speed < 0 then
                    speed = 0
                end
            end
            if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                bv.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - workspace.CurrentCamera.CoordinateFrame.p))*speed
                lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
            elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                bv.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - workspace.CurrentCamera.CoordinateFrame.p))*speed
            else
                bv.velocity = Vector3.new(0,0,0)
            end
            bg.cframe = workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
        end
        ctrl = {f = 0, b = 0, l = 0, r = 0}
        lastctrl = {f = 0, b = 0, l = 0, r = 0}
        speed = 0
        bg:Destroy()
        bv:Destroy()
        plr.Character.Humanoid.PlatformStand = false
        player.Character.Animate.Disabled = false
        tpwalking = false

    else
        -- R15 code (sama seperti file asli)
        local plr = player
        local UpperTorso = plr.Character.UpperTorso
        local flying = true
        local deb = true
        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
        local maxspeed = 50
        local speed = 0

        local bg = Instance.new("BodyGyro", UpperTorso)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = UpperTorso.CFrame
        local bv = Instance.new("BodyVelocity", UpperTorso)
        bv.velocity = Vector3.new(0,0.1,0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        if nowe == true then
            plr.Character.Humanoid.PlatformStand = true
        end
        while nowe == true or player.Character.Humanoid.Health == 0 do
            wait()
            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                speed = speed+.5+(speed/maxspeed)
                if speed > maxspeed then
                    speed = maxspeed
                end
            elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                speed = speed-1
                if speed < 0 then
                    speed = 0
                end
            end
            if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                bv.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - workspace.CurrentCamera.CoordinateFrame.p))*speed
                lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
            elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                bv.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - workspace.CurrentCamera.CoordinateFrame.p))*speed
            else
                bv.velocity = Vector3.new(0,0,0)
            end
            bg.cframe = workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
        end
        ctrl = {f = 0, b = 0, l = 0, r = 0}
        lastctrl = {f = 0, b = 0, l = 0, r = 0}
        speed = 0
        bg:Destroy()
        bv:Destroy()
        plr.Character.Humanoid.PlatformStand = false
        player.Character.Animate.Disabled = false
        tpwalking = false
    end
end)

-- up/down hold behaviour (sama seperti file asli)
local tis
up.MouseButton1Down:connect(function()
    tis = up.MouseEnter:connect(function()
        while tis do
            wait()
            player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,0)
        end
    end)
end)
up.MouseLeave:connect(function()
    if tis then
        tis:Disconnect()
        tis = nil
    end
end)

local dis
down.MouseButton1Down:connect(function()
    dis = down.MouseEnter:connect(function()
        while dis do
            wait()
            player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)
        end
    end)
end)
down.MouseLeave:connect(function()
    if dis then
        dis:Disconnect()
        dis = nil
    end
end)

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
    wait(0.7)
    game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
    game.Players.LocalPlayer.Character.Animate.Disabled = false
end)

plus.MouseButton1Down:connect(function()
    speeds = speeds + 1
    speed.Text = speeds
    if nowe == true then
        tpwalking = false
        for i = 1, speeds do
            spawn(function()
                local hb = RunService.Heartbeat    
                tpwalking = true
                local chr = player.Character
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
mine.MouseButton1Down:connect(function()
    if speeds == 1 then
        speed.Text = 'cannot be less than 1'
        wait(1)
        speed.Text = speeds
    else
        speeds = speeds - 1
        speed.Text = speeds
        if nowe == true then
            tpwalking = false
            for i = 1, speeds do
                spawn(function()
                    local hb = RunService.Heartbeat    
                    tpwalking = true
                    local chr = player.Character
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

closebutton.MouseButton1Click:Connect(function()
    main:Destroy()
end)

mini.MouseButton1Click:Connect(function()
    up.Visible = false
    down.Visible = false
    onof.Visible = false
    plus.Visible = false
    speed.Visible = false
    mine.Visible = false
    mini.Visible = false
    mini2.Visible = true
    noclipBtn.Visible = false
    lowgfxBtn.Visible = false
    main.Frame.BackgroundTransparency = 1
    closebutton.Position =  UDim2.new(0, 0, -1, 57)
end)

mini2.MouseButton1Click:Connect(function()
    up.Visible = true
    down.Visible = true
    onof.Visible = true
    plus.Visible = true
    speed.Visible = true
    mine.Visible = true
    mini.Visible = true
    mini2.Visible = false
    noclipBtn.Visible = true
    lowgfxBtn.Visible = true
    main.Frame.BackgroundTransparency = 0 
    closebutton.Position = UDim2.new(0, 0, -1, 27)
end)

-- -------------------------
-- NoClip feature
-- -------------------------
local noclipEnabled = false
local noclipConn

local function enableNoclip()
    noclipEnabled = true
    noclipBtn.Text = "NoClip: ON"
    -- koneksi per-step untuk memaksa CanCollide = false
    if noclipConn then noclipConn:Disconnect() end
    noclipConn = RunService.Stepped:Connect(function()
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function disableNoclip()
    noclipEnabled = false
    noclipBtn.Text = "NoClip: OFF"
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    -- ketika dimatikan, kembalikan CanCollide default (set true untuk safety)
    local char = player.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

noclipBtn.MouseButton1Click:Connect(function()
    if noclipEnabled then
        disableNoclip()
    else
        enableNoclip()
    end
end)

-- -------------------------
-- Low Graphics feature (toggle & restore)
-- -------------------------
local lowgfxEnabled = false
local lowgfxStore = {} -- menyimpan properti untuk restore

local function setLowGraphics()
    if lowgfxEnabled then return end
    lowgfxEnabled = true
    lowgfxBtn.Text = "LowGfx: ON"

    -- iterate workspace untuk menonaktifkan particle, trail, beam, efek visual, decals, dan ubah material
    for _, inst in ipairs(workspace:GetDescendants()) do
        -- particle-like
        if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam") then
            if not lowgfxStore[inst] then lowgfxStore[inst] = {} end
            lowgfxStore[inst].Enabled = inst.Enabled
            inst.Enabled = false
        end

        -- decals & textures
        if inst:IsA("Decal") or inst:IsA("Texture") then
            if not lowgfxStore[inst] then lowgfxStore[inst] = {} end
            lowgfxStore[inst].Transparency = inst.Transparency
            inst.Transparency = 1
        end

        -- surface appearance / material heavy items
        if inst:IsA("BasePart") then
            if not lowgfxStore[inst] then lowgfxStore[inst] = {} end
            lowgfxStore[inst].Material = inst.Material
            inst.Material = Enum.Material.SmoothPlastic
        end

        -- MeshPart texture
        if inst:IsA("MeshPart") then
            if not lowgfxStore[inst] then lowgfxStore[inst] = {} end
            lowgfxStore[inst].TextureID = inst.TextureID
            inst.TextureID = ""
        end

        -- SurfaceAppearance (menghapus detail appearance)
        if inst:IsA("SurfaceAppearance") then
            if not lowgfxStore[inst] then lowgfxStore[inst] = {} end
            lowgfxStore[inst].Parent = inst.Parent
            -- untuk sederhana, kita non-aktifkan dengan memindahkan sementara
            pcall(function() inst.Parent = nil end)
        end
    end

    -- Lighting adjustments sederhana untuk menurunkan beban
    lowgfxStore["_Lighting"] = {
        GlobalShadows = Lighting.GlobalShadows,
        Brightness = Lighting.Brightness,
        OutdoorAmbient = Lighting.OutdoorAmbient,
    }
    Lighting.GlobalShadows = false
    Lighting.Brightness = 0
    Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
end

local function restoreGraphics()
    if not lowgfxEnabled then return end
    lowgfxEnabled = false
    lowgfxBtn.Text = "LowGfx: OFF"

    -- restore dari store
    for inst, props in pairs(lowgfxStore) do
        if inst == "_Lighting" then
            local p = props
            Lighting.GlobalShadows = p.GlobalShadows
            Lighting.Brightness = p.Brightness
            Lighting.OutdoorAmbient = p.OutdoorAmbient
        else
            pcall(function()
                if props.Enabled ~= nil and inst.Enabled ~= nil then inst.Enabled = props.Enabled end
                if props.Transparency ~= nil and inst.Transparency ~= nil then inst.Transparency = props.Transparency end
                if props.Material ~= nil and inst.Material ~= nil then inst.Material = props.Material end
                if props.TextureID ~= nil and inst.TextureID ~= nil then inst.TextureID = props.TextureID end
                if props.Parent ~= nil and (not inst.Parent) then inst.Parent = props.Parent end
            end)
        end
    end
    lowgfxStore = {}
end

lowgfxBtn.MouseButton1Click:Connect(function()
    if lowgfxEnabled then
        restoreGraphics()
    else
        setLowGraphics()
    end
end)

-- Safety: saat karakter respawn, pastikan restore/clean
Players.LocalPlayer.CharacterAdded:Connect(function(char)
    wait(0.7)
    -- restore collisions jika noclip off
    if not noclipEnabled then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    -- kalau lowgfx nonaktif, jangan ubah; kalau aktif, aplikasikan ulang
    if lowgfxEnabled then
        -- reapply lowgfx to new objects (sederhana memanggil setLowGraphics lagi)
        setLowGraphics()
    end
end)

-- End of script
