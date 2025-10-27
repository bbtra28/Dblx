-- 🎃 GPT-5 Script: GUI Auto Teleport & Collect Pumpkin (Disaster Island)

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local StartBtn = Instance.new("TextButton")
local StopBtn = Instance.new("TextButton")
local Title = Instance.new("TextLabel")

ScreenGui.Name = "PumpkinFinderGUI"
ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Position = UDim2.new(0.35, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Active = true
Frame.Draggable = true
Frame.Visible = true
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0.1

Title.Parent = Frame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "🎃 Pumpkin Auto Collect"
Title.TextColor3 = Color3.fromRGB(255, 170, 0)
Title.TextScaled = true

StartBtn.Parent = Frame
StartBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
StartBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
StartBtn.Text = "▶ Start Auto Collect"
StartBtn.TextScaled = true
StartBtn.Font = Enum.Font.GothamBold
StartBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartBtn.BorderSizePixel = 0

StopBtn.Parent = Frame
StopBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
StopBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
StopBtn.Text = "⏹ Stop"
StopBtn.TextScaled = true
StopBtn.Font = Enum.Font.GothamBold
StopBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.BorderSizePixel = 0

-- Variabel kontrol
local running = false
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Pengaturan
local teleportDelay = 1.5

-- Fungsi teleport
local function tpTo(pos)
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
end

-- Fungsi collect
local function collectPumpkin(pumpkin)
    local prompt = pumpkin:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt and prompt.Enabled then
        tpTo(pumpkin.Position)
        task.wait(0.5)
        fireproximityprompt(prompt)
        print("🎃 Collected:", pumpkin.Name)
        return true
    end
    return false
end

-- Fungsi utama auto collect
local function startAutoCollect()
    running = true
    print("🎃 Auto Collect dimulai...")
    while running do
        local pumpkins = {}
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and string.find(string.lower(obj.Name), "pumpkin") then
                table.insert(pumpkins, obj)
            end
        end

        for _, p in ipairs(pumpkins) do
            if not running then break end
            if collectPumpkin(p) then
                task.wait(teleportDelay)
            else
                print("⚠️ Skip:", p.Name)
            end
        end
        task.wait(2)
    end
end

-- Tombol GUI
StartBtn.MouseButton1Click:Connect(function()
    if not running then
        task.spawn(startAutoCollect)
    end
end)

StopBtn.MouseButton1Click:Connect(function()
    running = false
    print("⏹ Auto Collect dihentikan.")
end)
