-- 📱 Script: Deteksi nama part saat diklik
-- 💻 Kompatibel HP executor (Arceus X, Delta, VegaX, Fluxus, dll)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- Buat GUI kecil untuk menampilkan info klik
local gui = Instance.new("ScreenGui", game.CoreGui)
local label = Instance.new("TextLabel", gui)

label.Size = UDim2.new(0, 300, 0, 50)
label.Position = UDim2.new(0.5, -150, 0.9, 0)
label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
label.TextColor3 = Color3.fromRGB(0, 255, 0)
label.Font = Enum.Font.SourceSansBold
label.TextScaled = true
label.Text = "Klik objek untuk deteksi..."
label.Visible = true

-- Fungsi saat klik
mouse.Button1Down:Connect(function()
    local target = mouse.Target
    if target then
        local name = target.Name
        local class = target.ClassName
        label.Text = "Nama: " .. name .. " (" .. class .. ")"
        print("✅ Kamu klik:", name, "Class:", class, "Parent:", target.Parent.Name)

        -- Contoh tambahan: highlight objek yang diklik
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Parent = target

        task.delay(1.5, function()
            highlight:Destroy()
        end)
    else
        label.Text = "❌ Tidak ada objek di bawah kursor"
    end
end)
