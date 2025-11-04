-- Invisible / On-Off Draggable GUI for Roblox executors
-- Paste this into your executor (e.g., Synapse, KRNL) as a Local script
-- Features:
--  - Draggable by the top bar (works while GUI is transparent)
--  - "Invisible" toggle: makes GUI fully transparent but still interactive
--  - "On/Off" toggle: completely hides/shows the GUI
--  - Keybinds: RightShift toggles On/Off, RightControl toggles Invisible
--  - Smooth tween transitions

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Choose parent: try CoreGui first (for some executors), fallback to PlayerGui
local parent
do
    local ok, coreGuiOrErr = pcall(function() return game:GetService("CoreGui") end)
    if ok and coreGuiOrErr then
        parent = coreGuiOrErr
    else
        parent = player:WaitForChild("PlayerGui")
    end
end

-- Prevent creating multiple copies
if parent:FindFirstChild("InvisibleDraggableGUI") then
    parent:FindFirstChild("InvisibleDraggableGUI"):Destroy()
end

-- Utility
local function new(className, props)
    local inst = Instance.new(className)
    if props then
        for k,v in pairs(props) do
            inst[k] = v
        end
    end
    return inst
end

-- Create GUI
local screenGui = new("ScreenGui", {
    Name = "InvisibleDraggableGUI",
    ResetOnSpawn = false,
    DisplayOrder = 9999,
    Parent = parent
})

local main = new("Frame", {
    Name = "Main",
    Parent = screenGui,
    Size = UDim2.new(0, 300, 0, 140),
    Position = UDim2.new(0.5, -150, 0.5, -70),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    BackgroundTransparency = 0,
    BorderSizePixel = 0,
})

local uiCorner = new("UICorner", { Parent = main, CornerRadius = UDim.new(0, 8) })

local topBar = new("Frame", {
    Name = "TopBar",
    Parent = main,
    Size = UDim2.new(1, 0, 0, 28),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(22,22,22),
    BorderSizePixel = 0
})
new("UICorner", { Parent = topBar, CornerRadius = UDim.new(0, 8) })

local title = new("TextLabel", {
    Parent = topBar,
    Text = "Draggable GUI",
    Size = UDim2.new(1, -72, 1, 0),
    Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(220,220,220),
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.SourceSansSemibold,
    TextSize = 14,
})

-- Buttons (Invisible toggle and Power toggle)
local btnInvisible = new("TextButton", {
    Parent = topBar,
    Name = "InvisibleBtn",
    Size = UDim2.new(0, 28, 0, 20),
    Position = UDim2.new(1, -36, 0, 4),
    BackgroundTransparency = 0,
    BackgroundColor3 = Color3.fromRGB(40,40,40),
    Text = "👁",
    TextSize = 14,
    Font = Enum.Font.SourceSans,
    TextColor3 = Color3.fromRGB(220,220,220),
    AutoButtonColor = true,
})
new("UICorner", { Parent = btnInvisible, CornerRadius = UDim.new(0,6) })

local btnPower = new("TextButton", {
    Parent = topBar,
    Name = "PowerBtn",
    Size = UDim2.new(0, 28, 0, 20),
    Position = UDim2.new(1, -68, 0, 4),
    BackgroundTransparency = 0,
    BackgroundColor3 = Color3.fromRGB(200,60,60),
    Text = "⏻",
    TextSize = 14,
    Font = Enum.Font.SourceSans,
    TextColor3 = Color3.fromRGB(255,255,255),
    AutoButtonColor = true,
})
new("UICorner", { Parent = btnPower, CornerRadius = UDim.new(0,6) })

-- Some sample content
local content = new("Frame", {
    Parent = main,
    Name = "Content",
    Size = UDim2.new(1, -12, 1, -40),
    Position = UDim2.new(0, 6, 0, 34),
    BackgroundTransparency = 1,
})
local sampleLabel = new("TextLabel", {
    Parent = content,
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    Text = "Sample controls go here",
    TextColor3 = Color3.fromRGB(200,200,200),
    Font = Enum.Font.SourceSans,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Save original visuals so we can restore
local visuals = {
    mainBG = main.BackgroundTransparency,
    topBG = topBar.BackgroundTransparency,
    titleText = title.TextTransparency,
    sampleLabelText = sampleLabel.TextTransparency,
    btnInvisibleBG = btnInvisible.BackgroundTransparency,
    btnInvisibleText = btnInvisible.TextTransparency,
    btnPowerBG = btnPower.BackgroundTransparency,
    btnPowerText = btnPower.TextTransparency,
}

-- State
local invisibleMode = false -- transparent but interactive
local enabledGUI = true -- on/off (visible)
local dragging = false
local dragStart = nil
local startPos = nil

-- Draggable logic (works while Gui.Visible == true)
local function onInputBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UserInputService:GetMouseLocation()
        local absPos = main.AbsolutePosition
        local absSize = main.AbsoluteSize
        -- Only start dragging if clicked on topBar region
        local topAbsPos = topBar.AbsolutePosition
        local topAbsSize = topBar.AbsoluteSize
        if mousePos.X >= topAbsPos.X and mousePos.X <= topAbsPos.X + topAbsSize.X
           and mousePos.Y >= topAbsPos.Y and mousePos.Y <= topAbsPos.Y + topAbsSize.Y then
            dragging = true
            dragStart = Vector2.new(mousePos.X, mousePos.Y)
            startPos = main.Position
            -- capture
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end
end

local function onInputChanged(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation()
        local delta = mousePos - dragStart
        -- convert delta (px) to scale-based movement relative to viewport size
        local viewportSize = workspace.CurrentCamera.ViewportSize
        if viewportSize.X <= 0 or viewportSize.Y <= 0 then return end
        local deltaScale = UDim2.new(0, delta.X, 0, delta.Y)
        -- compute new position in offset form and clamp to screen (optional)
        local newX = startPos.X.Scale + (startPos.X.Offset + delta.X - startPos.X.Offset) / (viewportSize.X)
        local newY = startPos.Y.Scale + (startPos.Y.Offset + delta.Y - startPos.Y.Offset) / (viewportSize.Y)
        main.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
    end
end

-- Input connections
UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputChanged:Connect(onInputChanged)

-- Toggle invisible (transparent) mode
local function setInvisibleMode(val)
    invisibleMode = val
    local goal = {}
    local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    if val then
        -- Make everything transparent but keep Visible = true so it can be dragged
        goal = {
            BackgroundTransparency = 1
        }
        TweenService:Create(main, tweenInfo, goal):Play()
        TweenService:Create(topBar, tweenInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(title, tweenInfo, {TextTransparency = 1}):Play()
        TweenService:Create(sampleLabel, tweenInfo, {TextTransparency = 1}):Play()
        TweenService:Create(btnInvisible, tweenInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        TweenService:Create(btnPower, tweenInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        btnInvisible.Text = "🚫"
    else
        -- Restore originals
        TweenService:Create(main, tweenInfo, {BackgroundTransparency = visuals.mainBG}):Play()
        TweenService:Create(topBar, tweenInfo, {BackgroundTransparency = visuals.topBG}):Play()
        TweenService:Create(title, tweenInfo, {TextTransparency = visuals.titleText}):Play()
        TweenService:Create(sampleLabel, tweenInfo, {TextTransparency = visuals.sampleLabelText}):Play()
        TweenService:Create(btnInvisible, tweenInfo, {BackgroundTransparency = visuals.btnInvisibleBG, TextTransparency = visuals.btnInvisibleText}):Play()
        TweenService:Create(btnPower, tweenInfo, {BackgroundTransparency = visuals.btnPowerBG, TextTransparency = visuals.btnPowerText}):Play()
        btnInvisible.Text = "👁"
    end
end

-- Toggle on/off (completely hide GUI)
local function setEnabledGUI(val)
    enabledGUI = val
    screenGui.Enabled = val
    -- If disabling, also stop dragging
    if not val then
        dragging = false
    end
end

-- Button events
btnInvisible.MouseButton1Click:Connect(function()
    setInvisibleMode(not invisibleMode)
end)

btnPower.MouseButton1Click:Connect(function()
    setEnabledGUI(not enabledGUI)
end)

-- Keybinds
UserInputService.InputBegan:Connect(function(inp, gameProcessed)
    if gameProcessed then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        setEnabledGUI(not enabledGUI)
    elseif inp.KeyCode == Enum.KeyCode.RightControl then
        setInvisibleMode(not invisibleMode)
    end
end)

-- Ensure GUI visible initially
setInvisibleMode(false)
setEnabledGUI(true)

-- Helpful note in output (executors usually show output)
if typeof(print) == "function" then
    print("[InvisibleDraggableGUI] Loaded. RightShift = On/Off, RightControl = Invisible toggle.")
end
