-- 🧍‍♂️ FE GIANT GUI TOGGLE
-- 💻 Compatible: Arceus X, Delta, Fluxus, Hydrogen, Codex
-- ⚠️ Rekomendasi avatar R6 (agar proporsional)

-- GUI Buat Tombol
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local Button = Instance.new("TextButton", Frame)

Frame.Size = UDim2.new(0, 150, 0, 50)
Frame.Position = UDim2.new(0.8, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true

Button.Size = UDim2.new(1, 0, 1, 0)
Button.Text = "🟢 FE Giant: OFF"
Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Font = Enum.Font.GothamBold
Button.TextScaled = true

local giantEnabled = false
local plr = game.Players.LocalPlayer

local function setGiant(state)
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")

    if hum and hum:FindFirstChild("BodyDepthScale") then
        if state then
            hum.BodyDepthScale.Value = 4
            hum.BodyHeightScale.Value = 4
            hum.BodyWidthScale.Value = 4
            hum.HeadScale.Value = 4
            hum.WalkSpeed = 24
            hum.JumpPower = 75
        else
            hum.BodyDepthScale.Value = 1
            hum.BodyHeightScale.Value = 1
            hum.BodyWidthScale.Value = 1
            hum.HeadScale.Value = 1
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end
end

Button.MouseButton1Click:Connect(function()
    giantEnabled = not giantEnabled
    setGiant(giantEnabled)
    if giantEnabled then
        Button.Text = "🔴 FE Giant: ON"
        Button.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
    else
        Button.Text = "🟢 FE Giant: OFF"
        Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

print("✅ FE Giant GUI Loaded — Tekan tombol untuk ubah ukuran!")
