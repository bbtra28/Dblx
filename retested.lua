--[[  
   Finder + ESP + Auto Teleport + GUI
   Target: Chef Chubbeloni
   Client-side (Executor Script)
]]--

local TARGET_NAME = "Chef Chubbeloni"
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

--===== GUI =====--
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ChubFinderGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 60)
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Frame.Active = true
Frame.Draggable = true

local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255,120,0)

local ToggleBtn = Instance.new("TextButton", Frame)
ToggleBtn.Size = UDim2.new(1,0,1,0)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Text = "CHUBBELONI FINDER: OFF"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextColor3 = Color3.fromRGB(255,120,0)
ToggleBtn.TextScaled = true

local enabled = false

ToggleBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    ToggleBtn.Text = enabled and "CHUBBELONI FINDER: ON" or "CHUBBELONI FINDER: OFF"
end)

--===== ESP MAKER =====--
local function clearESP(model)
    if model:FindFirstChild("ChubESP") then
        model.ChubESP:Destroy()
    end
end

local function makeESP(model)
    clearESP(model)
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local folder = Instance.new("Folder", model)
    folder.Name = "ChubESP"

    local hl = Instance.new("Highlight", folder)
    hl.Adornee = model
    hl.FillTransparency = 1
    hl.OutlineColor = Color3.fromRGB(255,120,0)
    hl.OutlineTransparency = 0

    local bill = Instance.new("BillboardGui", folder)
    bill.Adornee = hrp
    bill.Size = UDim2.new(0,150,0,35)
    bill.AlwaysOnTop = true

    local txt = Instance.new("TextLabel", bill)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Text = "CHEF CHUBBELONI"
    txt.Font = Enum.Font.GothamBold
    txt.TextScaled = true
    txt.TextColor3 = Color3.fromRGB(255,120,0)
end

--===== CARI NPC =====--
local function findChub()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find(TARGET_NAME:lower()) then
            return obj
        end
    end
    return nil
end

--===== LOOP UTAMA =====--
task.spawn(function()
    while true do
        if enabled then
            local npc = findChub()
            if npc then
                makeESP(npc)

                -- Auto teleport player ke NPC
                local hrp = npc:FindFirstChild("HumanoidRootPart")
                local myChar = lp.Character
                if hrp and myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    myChar.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(2,0,0)
                end
            end
        end
        task.wait(1)
    end
end)

print("Chubbeloni Finder + Auto TP Loaded!")
