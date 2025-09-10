-- F3X Lite Mobile (Full + Tap Fix)
-- Bisa dijalankan di HP & PC

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Config
local SNAP = true
local SNAP_SIZE = 1
local ROTATE_STEP = 15
local SCALE_STEP = 0.5

local selected = nil
local selectionAdornment = nil
local mode = "Move" -- Move | Rotate | Scale

-- UI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "F3XMobile"

-- Main panel
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 250, 0, 360)
main.Position = UDim2.new(0, 20, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(35,35,35)
main.BackgroundTransparency = 0.2
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 28)
title.Text = "F3X Mobile"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1

-- Helper buat tombol
local function makeBtn(parent, text, pos, size)
    local b = Instance.new("TextButton", parent)
    b.Text = text
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 18
    b.AutoButtonColor = true
    return b
end

-- Tombol utama
local btnCreate = makeBtn(main, "Create Part", UDim2.new(0,10,0,40), UDim2.new(0,230,0,40))
local btnDelete = makeBtn(main, "Delete", UDim2.new(0,10,0,90), UDim2.new(0,110,0,40))
local btnDuplicate = makeBtn(main, "Duplicate", UDim2.new(0,130,0,90), UDim2.new(0,110,0,40))
local btnMode = makeBtn(main, "Mode: Move", UDim2.new(0,10,0,140), UDim2.new(0,230,0,40))
local btnSnap = makeBtn(main, "Snap: ON", UDim2.new(0,10,0,190), UDim2.new(0,230,0,40))

-- Status
local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1, -20, 0, 40)
status.Position = UDim2.new(0,10,1,-50)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(200,200,200)
status.TextWrapped = true
status.TextSize = 14
status.Text = "No selection"

-- Pad arah
local pad = Instance.new("Frame", gui)
pad.Size = UDim2.new(0,200,0,200)
pad.Position = UDim2.new(1,-220,1,-220)
pad.BackgroundTransparency = 1

local up = makeBtn(pad, "↑", UDim2.new(0.5,-40,0,0), UDim2.new(0,80,0,80))
local down = makeBtn(pad, "↓", UDim2.new(0.5,-40,0,120), UDim2.new(0,80,0,80))
local left = makeBtn(pad, "←", UDim2.new(0,0,0,60), UDim2.new(0,80,0,80))
local right = makeBtn(pad, "→", UDim2.new(1,-80,0,60), UDim2.new(0,80,0,80))

-- Selection box
local function setSelection(part)
    if selectionAdornment then selectionAdornment:Destroy() end
    selected = part
    if selected and selected:IsA("BasePart") then
        local box = Instance.new("SelectionBox", selected)
        box.Adornee = selected
        box.LineThickness = 0.05
        selectionAdornment = box
    end
    status.Text = selected and ("Selected: "..selected.Name) or "No selection"
end

-- Events
btnCreate.MouseButton1Click:Connect(function()
    local p = Instance.new("Part")
    p.Size = Vector3.new(4,1,4)
    p.Position = mouse.Hit.p + Vector3.new(0,5,0)
    p.Anchored = false
    p.Parent = workspace
    setSelection(p)
end)

btnDelete.MouseButton1Click:Connect(function()
    if selected then
        selected:Destroy()
        setSelection(nil)
    end
end)

btnDuplicate.MouseButton1Click:Connect(function()
    if selected then
        local c = selected:Clone()
        c.CFrame = selected.CFrame * CFrame.new(3,0,0)
        c.Parent = workspace
        setSelection(c)
    end
end)

btnMode.MouseButton1Click:Connect(function()
    if mode=="Move" then mode="Rotate"
    elseif mode=="Rotate" then mode="Scale"
    else mode="Move" end
    btnMode.Text = "Mode: "..mode
end)

btnSnap.MouseButton1Click:Connect(function()
    SNAP = not SNAP
    btnSnap.Text = "Snap: "..(SNAP and "ON" or "OFF")
end)

-- Transform
local function moveSelected(dx,dy,dz,rot)
    if not selected then return end
    if mode=="Move" then
        local cf = selected.CFrame * CFrame.new(dx,dy,dz)
        local pos = cf.Position
        if SNAP then
            pos = Vector3.new(
                math.round(pos.X/SNAP_SIZE)*SNAP_SIZE,
                math.round(pos.Y/SNAP_SIZE)*SNAP_SIZE,
                math.round(pos.Z/SNAP_SIZE)*SNAP_SIZE
            )
        end
        selected.CFrame = CFrame.new(pos, pos + cf.LookVector)
    elseif mode=="Rotate" then
        local r = CFrame.Angles(math.rad(rot.X), math.rad(rot.Y), math.rad(rot.Z))
        selected.CFrame = selected.CFrame * r
    elseif mode=="Scale" then
        local newSize = selected.Size + Vector3.new(dx,dy,dz)
        newSize = Vector3.new(
            math.max(0.5,newSize.X),
            math.max(0.5,newSize.Y),
            math.max(0.5,newSize.Z)
        )
        selected.Size = newSize
    end
end

-- Tombol arah
up.MouseButton1Click:Connect(function()
    if mode=="Rotate" then
        moveSelected(0,0,0,Vector3.new(ROTATE_STEP,0,0))
    elseif mode=="Scale" then
        moveSelected(0,SCALE_STEP,0)
    else
        moveSelected(0,0,-1)
    end
end)

down.MouseButton1Click:Connect(function()
    if mode=="Rotate" then
        moveSelected(0,0,0,Vector3.new(-ROTATE_STEP,0,0))
    elseif mode=="Scale" then
        moveSelected(0,-SCALE_STEP,0)
    else
        moveSelected(0,0,1)
    end
end)

left.MouseButton1Click:Connect(function()
    if mode=="Rotate" then
        moveSelected(0,0,0,Vector3.new(0,ROTATE_STEP,0))
    elseif mode=="Scale" then
        moveSelected(-SCALE_STEP,0,0)
    else
        moveSelected(-1,0,0)
    end
end)

right.MouseButton1Click:Connect(function()
    if mode=="Rotate" then
        moveSelected(0,0,0,Vector3.new(0,-ROTATE_STEP,0))
    elseif mode=="Scale" then
        moveSelected(SCALE_STEP,0,0)
    else
        moveSelected(1,0,0)
    end
end)

-- ✅ Fix select part di HP & PC
UserInputService.TouchTapInWorld:Connect(function(pos, processed)
    if processed then return end
    local target = mouse.Target
    if target and target:IsA("BasePart") then
        setSelection(target)
    else
        setSelection(nil)
    end
end)

mouse.Button1Down:Connect(function()
    local target = mouse.Target
    if target and target:IsA("BasePart") then
        setSelection(target)
    else
        setSelection(nil)
    end
end)
