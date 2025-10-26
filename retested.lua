-- 🎃 Script by GPT-5 | Find & Track Pumpkin Event Items
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Fungsi untuk buat highlight dan label
local function highlightPumpkin(pumpkin)
    -- Bikin jadi kelihatan
    pumpkin.Transparency = 0
    pumpkin.Material = Enum.Material.Neon
    pumpkin.Color = Color3.fromRGB(255, 140, 0)

    -- Highlight
    local hl = Instance.new("Highlight", pumpkin)
    hl.FillColor = Color3.fromRGB(255, 100, 0)
    hl.OutlineColor = Color3.fromRGB(255, 255, 0)
    hl.FillTransparency = 0.5

    -- Billboard (tulisan di atas pumpkin)
    local billboard = Instance.new("BillboardGui", pumpkin)
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold

    -- Update jarak ke player tiap 0.5 detik
    task.spawn(function()
        while pumpkin and pumpkin.Parent do
            local distance = (hrp.Position - pumpkin.Position).Magnitude
            label.Text = ("🎃 Pumpkin (%.1f m)"):format(distance)
            task.wait(0.5)
        end
    end)
end

-- Cari semua object di workspace yang namanya ada "pumpkin"
local count = 0
for _, obj in ipairs(workspace:GetDescendants()) do
    if string.find(string.lower(obj.Name), "pumpkin") and obj:IsA("BasePart") then
        highlightPumpkin(obj)
        count += 1
    end
end

if count > 0 then
    print("🎃 Ditemukan " .. count .. " pumpkin! Arah & jarak aktif.")
else
    print("❌ Tidak ada pumpkin ditemukan. Coba jalankan lagi saat map event aktif.")
end
