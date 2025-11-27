-- Pumpkin Finder + Marker Neon
-- Mendeteksi semua item ber-nama "Pumpkin" dan menandainya

local pumpkinName = "Pumpkin"  -- nama objek yg dicari

local function createMarker(target)
    -- Cegah double marker
    if target:FindFirstChild("PumpkinMarker") then
        target.PumpkinMarker:Destroy()
    end

    local ador = Instance.new("BillboardGui")
    ador.Name = "PumpkinMarker"
    ador.Size = UDim2.new(4,0,4,0)
    ador.AlwaysOnTop = true
    ador.Parent = target

    local img = Instance.new("Frame", ador)
    img.Size = UDim2.new(1,0,1,0)
    img.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    img.BackgroundTransparency = 0.4
    img.BorderSizePixel = 0
end

local function scan(model)
    for _, obj in ipairs(model:GetDescendants()) do
        if obj.Name:lower() == pumpkinName:lower() then
            createMarker(obj)
        end
    end
end

-- SCAN AWAL
scan(workspace)

-- SCAN OTOMATIS jika ada pumpkin baru
workspace.DescendantAdded:Connect(function(obj)
    if obj.Name:lower() == pumpkinName:lower() then
        createMarker(obj)
    end
end)

print("Pumpkin Finder aktif!")
