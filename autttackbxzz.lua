local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Hapus GUI lama kalau ada
if PlayerGui:FindFirstChild("HiddenToolsFinder") then
    PlayerGui.HiddenToolsFinder:Destroy()
end

-- Buat GUI
local gui = Instance.new("ScreenGui")
gui.Name = "HiddenToolsFinder"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- Tombol show/hide
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,80,0,30)
toggleBtn.Position = UDim2.new(0,50,0,70)
toggleBtn.Text = "Hide"
toggleBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- Frame utama
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,300,0,400)
frame.Position = UDim2.new(0,50,0,110)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local list = Instance.new("UIListLayout", frame)
list.SortOrder = Enum.SortOrder.LayoutOrder

-- Show/hide
local visible = true
toggleBtn.MouseButton1Click:Connect(function()
    visible = not visible
    frame.Visible = visible
    toggleBtn.Text = visible and "Hide" or "Show"
end)

-- Fungsi scan tool
local function scan()
    for _,child in ipairs(frame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local function addTool(obj, lokasi)
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1,0,0,25)
        btn.Text = "["..lokasi.."] "..obj.Name
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        btn.TextScaled = true

        btn.MouseButton1Click:Connect(function()
            if obj and obj:IsA("Tool") then
                local clone = obj:Clone()
                clone.Parent = LocalPlayer.Backpack
            end
        end)
    end

    -- Scan lokasi yang bisa diakses client
    for _,obj in ipairs(game.Workspace:GetDescendants()) do
        if obj:IsA("Tool") then addTool(obj,"Workspace") end
    end
    for _,obj in ipairs(game.ReplicatedStorage:GetDescendants()) do
        if obj:IsA("Tool") then addTool(obj,"ReplicatedStorage") end
    end
    for _,obj in ipairs(game.Lighting:GetDescendants()) do
        if obj:IsA("Tool") then addTool(obj,"Lighting") end
    end
    for _,obj in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if obj:IsA("Tool") then addTool(obj,"Backpack") end
    end
    if LocalPlayer.Character then
        for _,obj in ipairs(LocalPlayer.Character:GetChildren()) do
            if obj:IsA("Tool") then addTool(obj,"Character") end
        end
    end
end

-- Scan awal
scan()

-- Auto refresh
game.Workspace.DescendantAdded:Connect(scan)
game.ReplicatedStorage.DescendantAdded:Connect(scan)
game.Lighting.DescendantAdded:Connect(scan)
LocalPlayer.Backpack.ChildAdded:Connect(scan)
if LocalPlayer.Character then
    LocalPlayer.Character.ChildAdded:Connect(scan)
end
