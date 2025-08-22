-- Hitbox + Auto Attack + GUI Toggle Button

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local farming = false  -- status auto attack

-- Nama senjata (ubah sesuai nama tool di game kamu)
local weaponName = "Sword"

-- Buat GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AttackGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 80)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundTransparency = 0.3
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0.6, 0)
button.Position = UDim2.new(0.1, 0, 0.2, 0)
button.BackgroundColor3 = Color3.new(0, 0.6, 1)
button.Text = "Enable Auto Attack"
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 16
button.Font = Enum.Font.SourceSansBold
button.Parent = frame

-- Fungsi toggle
local function toggleAttack()
    farming = not farming
    button.Text = farming and "Disable Auto Attack" or "Enable Auto Attack"
    button.BackgroundColor3 = farming and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    print("Auto Attack:", farming and "ON" or "OFF")
end

button.MouseButton1Click:Connect(toggleAttack)

-- Perbesar hitbox
local function enlargeHitbox(tool)
    for _, v in pairs(tool:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Size = Vector3.new(40, 40, 40)  -- hitbox besar
            v.Transparency = 0.6
            v.CanCollide = false
        end
    end
    print("[+] Hitbox diperbesar untuk:", tool.Name)
end

-- Auto attack loop
local function autoAttack(tool)
    spawn(function()
        while tool.Parent == char do
            task.wait(0.2)
            if farming then
                pcall(function()
                    tool:Activate()
                end)
            end
        end
    end)
end

-- Setup senjata
local function setupTool(tool)
    enlargeHitbox(tool)
    autoAttack(tool)
end

-- Cek senjata saat awal
local tool = char:FindFirstChild(weaponName) or player.Backpack:FindFirstChild(weaponName)
if tool then
    setupTool(tool)
end

-- Kalau equip senjata baru
player.Backpack.ChildAdded:Connect(function(tool)
    if tool.Name == weaponName then
        tool.Equipped:Connect(function()
            setupTool(tool)
        end)
    end
end)