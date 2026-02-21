-- 🌐 Roblox Data Saver GUI v3 Ultra Extreme (Auto Aktif + Loading Render + Draggable + FPS/Ping lowercase + Fix + Ultra Extreme Optimizations)
-- 💻 Kompatibel: Arceus X, Delta, VegaX, Fluxus, Hydrogen, Codex
-- 🔋 Ultra Extreme Mode: Sangat agresif dalam menghemat data, menonaktifkan hampir semua elemen visual, mengurangi render distance drastis, menghapus objek tidak esensial, dan optimalisasi maksimal. PERINGATAN: Ini bisa merusak fungsionalitas game tertentu!

task.spawn(function()
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local SoundService = game:GetService("SoundService")
    local Players = game:GetService("Players")
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Stats = game:GetService("Stats")
    local LocalPlayer = Players.LocalPlayer
    local enabled = true

    -- 📦 Simpan posisi GUI antar sesi
    local function SavePos(x, y)
        pcall(function()
            LocalPlayer:SetAttribute("DataSaver_PosX", x)
            LocalPlayer:SetAttribute("DataSaver_PosY", y)
        end)
    end

    local function LoadPos()
        local x = LocalPlayer:GetAttribute("DataSaver_PosX")
        local y = LocalPlayer:GetAttribute("DataSaver_PosY")
        if x and y then
            return UDim2.new(0, x, 0, y)
        else
            return UDim2.new(0.8, 0, 0.1, 0)
        end
    end

    -- 🪟 GUI
    local gui = Instance.new("ScreenGui")
    gui.Name = "DataSaverGUI"
    gui.ResetOnSpawn = false
    gui.Parent = game:GetService("CoreGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 90)
    frame.Position = LoadPos()
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BackgroundTransparency = 0.2
    frame.Active = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.5, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚙️ rendering ultra extreme low graphic..."
    title.Font = Enum.Font.SourceSansBold
    title.TextScaled = true
    title.TextColor3 = Color3.fromRGB(255,255,100)
    title.Parent = frame

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, 0, 0.5, 0)
    info.Position = UDim2.new(0, 0, 0.5, 0)
    info.BackgroundTransparency = 1
    info.Text = "fps: 0 | ping: 0ms"
    info.Font = Enum.Font.SourceSansBold
    info.TextScaled = true
    info.TextColor3 = Color3.fromRGB(255,255,255)
    info.Parent = frame

    -- ✅ Draggable GUI + simpan posisi
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
        frame.Position = newPos
        SavePos(newPos.X.Offset, newPos.Y.Offset)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    -- ⚙️ Fungsi ultra extreme low graphic
    local function EnableUltraExtremeLowGraphics()
        pcall(function()
            -- Lighting optimizations (ultra extreme)
            Lighting.GlobalShadows = false
            Lighting.Brightness = 0  -- Brightness nol untuk minim cahaya
            Lighting.FogStart = 0
            Lighting.FogEnd = 1e8  -- Fog sangat jauh
            Lighting.Ambient = Color3.fromRGB(0,0,0)  -- Ambient hitam total
            Lighting.OutdoorAmbient = Color3.fromRGB(0,0,0)
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
            Lighting.ClockTime = 0  -- Malam total
            Lighting.GeographicLatitude = 0
            Lighting.TimeOfDay = "00:00:00"  -- Waktu gelap

            -- Nonaktifkan SEMUA post-processing effects dan hapus jika memungkinkan
            for _, v in ipairs(Lighting:GetChildren()) do
                v:Destroy()
            end

            -- Nonaktifkan dan hapus semua sound
            SoundService.AmbientReverb = Enum.ReverbType.NoReverb
            for _, s in ipairs(SoundService:GetDescendants()) do
                if s:IsA("Sound") then
                    s:Destroy()
                end
            end

            -- Optimasi Workspace (ultra extreme): Hapus hampir semua, kurangi detail maksimal
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail")
                or obj:IsA("Smoke") or obj:IsA("Fire")
                or obj:IsA("Sparkles") or obj:IsA("Explosion") or obj:IsA("Beam") or obj:IsA("Attachment")
                or obj:IsA("Light") or obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                    obj:Destroy()  -- Hapus langsung
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj:Destroy()  -- Hapus texture/decal
                elseif obj:IsA("BasePart") then
                    obj.Material = Enum.Material.ForceField  -- Material paling sederhana/invisible
                    obj.CastShadow = false
                    obj.Reflectance = 0
                    obj.Transparency = 0.9  -- Hampir invisible untuk kurangi render load
                    if obj:IsA("MeshPart") then
                        obj.MeshId = ""  -- Hapus mesh jika memungkinkan
                        obj.TextureID = ""
                    end
                    obj.Anchored = true  -- Anchor untuk kurangi physics
                    obj.CanCollide = false  -- Nonaktifkan collision
                elseif obj:IsA("Model") and obj.Name \~= LocalPlayer.Character.Name then
                    -- Hapus model non-player jika kompleks
                    obj:Destroy()  -- Agresif: Hapus semua model lain
                elseif obj:IsA("Humanoid") and obj.Parent \~= LocalPlayer.Character then
                    obj.WalkSpeed = 0  -- Stop movement NPC
                    obj.JumpPower = 0
                end
            end

            -- Terrain optimizations (ultra extreme)
            if Workspace:FindFirstChildOfClass("Terrain") then
                Workspace.Terrain:Clear()  -- Hapus terrain sepenuhnya
            end

            -- Tambahan ultra extreme: Batasi render distance via camera
            local camera = Workspace.CurrentCamera
            camera.CameraType = Enum.CameraType.Scriptable  -- Kontrol manual
            camera.FieldOfView = 30  -- FOV sangat kecil untuk kurangi render
            camera.NearPlaneZ = 0.1  -- Clip dekat
            camera.FarPlaneZ = 100  -- Clip jauh sangat pendek (render distance minimal)

            -- Nonaktifkan physics global
            Workspace.Gravity = 0
            game:GetService("PhysicsService"):SetCollisionGroup(1, 1, false)  -- Nonaktifkan collision groups jika ada

            -- Kurangi update rate (ultra extreme)
            RunService:Set3dRenderingEnabled(false)  -- Nonaktifkan 3D rendering sepenuhnya (INI SANGAT EXTREME, GAME BISA HITAM TOTAL)
            -- Catatan: Ini bisa membuat layar hitam, gunakan jika benar-benar ingin ultra low
            -- Alternatif: RunService:UnbindFromRenderStep(all steps jika memungkinkan)

            -- Hapus GUI non-esensial
            for _, g in ipairs(game:GetService("CoreGui"):GetChildren()) do
                if g.Name \~= "DataSaverGUI" then
                    g.Enabled = false
                end
            end
        end)
    end

    -- 🔘 Toggle lewat klik judul
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if enabled then
                enabled = false
                title.Text = "🟢 data saver ultra extreme: off"
                title.TextColor3 = Color3.fromRGB(100,255,100)
            else
                enabled = true
                EnableUltraExtremeLowGraphics()
                title.Text = "🔴 data saver ultra extreme: on"
                title.TextColor3 = Color3.fromRGB(255,100,100)
            end
        end
    end)

    -- 🚀 Efek loading render
    task.spawn(function()
        for i = 1, 3 do
            title.Text = "⚙️ rendering ultra extreme low graphic" .. string.rep(".", i)
            task.wait(0.4)
        end
        EnableUltraExtremeLowGraphics()
        title.Text = "🔴 data saver ultra extreme: on"
        title.TextColor3 = Color3.fromRGB(255,100,100)
    end)

    -- 📊 FPS + Ping real-time (fix tanpa error)
    local lastUpdate = tick()
    local frameCount = 0
    RunService.RenderStepped:Connect(function()
        frameCount += 1
        if tick() - lastUpdate >= 1 then
            local fps = frameCount / (tick() - lastUpdate)
            frameCount = 0
            lastUpdate = tick()

            local pingStat = Stats.Network:FindFirstChild("ServerStatsItem") and Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
            local ping = pingStat and math.floor(pingStat:GetValue()) or 0

            info.Text = string.format("fps: %d | ping: %dms", math.floor(fps), ping)
        end
    end)
end)
