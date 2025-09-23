-- Save & Teleport Multi Slot (1-10) + Clear Option + Draggable + Hide/Show
-- Bisa dijalankan di executor atau LocalScript

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Simpan posisi di table
local savedPositions = {}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame utama (draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 480)
MainFrame.Position = UDim2.new(0, 20, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "Save & Teleport (1-10)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Parent = MainFrame

-- Tombol Hide/Show
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 100, 0, 30)
ToggleButton.Position = UDim2.new(1, -110, 0, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
ToggleButton.Text = "Hide"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Parent = MainFrame

-- Fungsi buat tombol
local function createButton(text, posX, posY, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = MainFrame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Buat tombol untuk 10 slot
local buttons = {}
for i = 1, 10 do
    local yPos = 40 + ((i - 1) * 40)

    buttons[#buttons+1] = createButton("Save " .. i, 10, yPos, Color3.fromRGB(50, 200, 50), function()
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            savedPositions[i] = root.CFrame
            print("Saved slot " .. i)
        end
    end)

    buttons[#buttons+1] = createButton("TP " .. i, 120, yPos, Color3.fromRGB(50, 50, 200), function()
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:FindFirstChild("HumanoidRootPart")
        if root and savedPositions[i] then
            root.CFrame = savedPositions[i]
            print("Teleported to slot " .. i)
        end
    end)

    buttons[#buttons+1] = createButton("Clear " .. i, 230, yPos, Color3.fromRGB(200, 50, 50), function()
        savedPositions[i] = nil
        print("Cleared slot " .. i)
    end)
end

-- Fungsi hide/show
local hidden = false
ToggleButton.MouseButton1Click:Connect(function()
    hidden = not hidden
    for _, btn in ipairs(buttons) do
        btn.Visible = not hidden
    end
    Title.Visible = not hidden
    ToggleButton.Text = hidden and "Show" or "Hide"
end)