-- ==========================================
-- FIND NPC: Pantry Chef Chubbyini (Client-Side)
-- By ChatGPT
-- ==========================================

local TARGET_NAMES = {
    "Pantry Chef Chubbyini",
    "Chef Chubbyini",
    "Chubbyini",
    "PantryChef",
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- UI
local CoreGui = game:GetService("CoreGui")
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "FindChubbyini_GUI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 240, 0, 130)
main.Position = UDim2.new(0.02, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BackgroundTransparency = 0.15
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Find Pantry Chef Chubbyini"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 15

local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1, -10, 0, 25)
status.Position = UDim2.new(0, 5, 0, 33)
status.Text = "Status: Searching..."
status.TextColor3 = Color3.fromRGB(200,200,200)
status.BackgroundTransparency = 1
status.Font = Enum.Font.SourceSans
status.TextSize = 13

local tp = Instance.new("TextButton", main)
tp.Size = UDim2.new(1, -10, 0, 35)
tp.Position = UDim2.new(0, 5, 0, 70)
tp.Text = "Teleport to NPC"
tp.Font = Enum.Font.SourceSansBold
tp.TextSize = 14
tp.BackgroundColor3 = Color3.fromRGB(40,40,40)
tp.TextColor3 = Color3.fromRGB(255,255,255)

local foundNPC = nil

-- Function: check if instance is the target
local function isTarget(objName)
    local lower = string.lower(objName)
    for _, n in ipairs(TARGET_NAMES) do
        if string.find(lower, string.lower(n), 1, true) then
            return true
        end
    end
    return false
end

-- Function: tag NPC
local function addMarker(part)
    if part:FindFirstChild("ChubbyiniMarker") then return end

    local b = Instance.new("BillboardGui", part)
    b.Name = "ChubbyiniMarker"
    b.Adornee = part
    b.Size = UDim2.new(0, 120, 0, 35)
    b.AlwaysOnTop = true

    local label = Instance.new("TextLabel", b)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "⬆ Pantry Chef Chubbyini"
    label.TextColor3 = Color3.fromRGB(255,255,0)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
end

-- Scan workspace for NPC
local function scan()
    foundNPC = nil
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Folder") or obj:IsA("BasePart") then
            if isTarget(obj.Name) then
                -- Find a root part
                local root = nil
                if obj:IsA("Model") then
                    root = obj:FindFirstChild("HumanoidRootPart")
                        or obj:FindFirstChild("Head")
                        or obj:FindFirstChildWhichIsA("BasePart")
                elseif obj:IsA("BasePart") then
                    root = obj
                end

                if root then
                    foundNPC = root
                    addMarker(root)
                    break
                end
            end
        end
    end

    if foundNPC then
        status.Text = "Status: FOUND!"
    else
        status.Text = "Status: Not found"
    end
end

scan()

-- Teleport button
tp.MouseButton1Click:Connect(function()
    if not foundNPC then
        status.Text = "Status: NPC not found!"
        return
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = foundNPC.CFrame + Vector3.new(0, 3, 0)
        status.Text = "Teleported ✔"
    else
        status.Text = "Character not loaded!"
    end
end)

-- Auto search every 1.5s
while task.wait(1.5) do
    scan()
end
