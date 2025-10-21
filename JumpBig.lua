--// Big Jump Button (Draggable Version)
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

if not UserInputService.TouchEnabled then
    warn("Script ini hanya untuk perangkat mobile (touch).")
    return
end

-- cari tombol JumpButton bawaan
local function findJumpButton()
    for _, v in ipairs(CoreGui:GetDescendants()) do
        if v:IsA("ImageButton") and v.Name == "JumpButton" then
            return v
        end
    end
end

-- tunggu tombol muncul
local jumpButton = findJumpButton() or CoreGui.DescendantAdded:Wait()
while not (jumpButton:IsA("ImageButton") and jumpButton.Name == "JumpButton") do
    jumpButton = CoreGui.DescendantAdded:Wait()
end

-- atur ukuran (1.8x lebih besar)
local scale = 1.8
local oldSize = jumpButton.Size
local newSize = UDim2.new(
    oldSize.X.Scale * scale,
    oldSize.X.Offset * scale,
    oldSize.Y.Scale * scale,
    oldSize.Y.Offset * scale
)
jumpButton.Size = newSize

-- atur posisi biar sedikit naik (opsional)
jumpButton.Position = UDim2.new(jumpButton.Position.X.Scale, jumpButton.Position.X.Offset - 40, jumpButton.Position.Y.Scale, jumpButton.Position.Y.Offset - 40)

-- biar ukuran tidak kembali ke semula
jumpButton:GetPropertyChangedSignal("Size"):Connect(function()
    task.wait(0.1)
    if jumpButton.Size ~= newSize then
        jumpButton.Size = newSize
    end
end)

-- fitur drag
local dragging = false
local dragStart, startPos

jumpButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = jumpButton.Position
    end
end)

jumpButton.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        jumpButton.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

jumpButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("✅ Tombol loncat bawaan diperbesar dan bisa digeser!")