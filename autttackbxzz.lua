-- Low Graphics Toggle GUI (Executor Safe) with Hide Others + Draggable Show Button -- Paste ke executor dan jalankan. -- Fitur lengkap: -- • Toggle Low Graphics on/off -- • Hide Others (client-side visual hide for other players) with ON/OFF (instan) -- • FPS & Ping display -- • Minimize (–) and Close (X) -- • When minimized, a draggable small "Show GUI" button appears (position follows last mainFrame position)

local Players = game:GetService("Players") local RunService = game:GetService("RunService") local Lighting = game:GetService("Lighting") local UserInputService = game:GetService("UserInputService")

local Stats = nil pcall(function() Stats = game:GetService("Stats") end)

local LocalPlayer = Players.LocalPlayer

-- store original rendering values local original = { QualityLevel = nil, GlobalShadows = Lighting.GlobalShadows, Brightness = Lighting.Brightness, FogEnd = Lighting.FogEnd } pcall(function() original.QualityLevel = settings().Rendering.QualityLevel end)

local lowGraphicsEnabled = false local hideOthersEnabled = false

-- For reverting hide modifications local hiddenPlayersState = {}

-- Utility: safe pcall wrapper local function safe(fn) local ok, res = pcall(fn) return ok, res end

-- GUI main local screenGui = Instance.new("ScreenGui") screenGui.Name = "LowGraphicsGUI" screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame") mainFrame.Name = "Main" mainFrame.Size = UDim2.new(0, 220, 0, 120) mainFrame.Position = UDim2.new(0, 20, 0, 80) mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30) mainFrame.BorderSizePixel = 0 mainFrame.Parent = screenGui

local title = Instance.new("TextLabel") title.Name = "Title" title.Size = UDim2.new(1, -60, 0, 28) title.BackgroundTransparency = 1 title.Text = "Low Graphics" title.Font = Enum.Font.SourceSansBold title.TextSize = 18 title.TextColor3 = Color3.fromRGB(255,255,255) title.TextXAlignment = Enum.TextXAlignment.Left title.Parent = mainFrame

-- minimize button (–) local minimizeBtn = Instance.new("TextButton") minimizeBtn.Size = UDim2.new(0,28,0,24) minimizeBtn.Position = UDim2.new(1, -60, 0, 2) minimizeBtn.Text = "–" minimizeBtn.Font = Enum.Font.SourceSansBold minimizeBtn.TextSize = 18 minimizeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60) minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255) minimizeBtn.BorderSizePixel = 0 minimizeBtn.Parent = mainFrame

-- close button (X) local closeBtn = Instance.new("TextButton") closeBtn.Size = UDim2.new(0,28,0,24) closeBtn.Position = UDim2.new(1, -30, 0, 2) closeBtn.Text = "X" closeBtn.Font = Enum.Font.SourceSansBold closeBtn.TextSize = 18 closeBtn.BackgroundColor3 = Color3.fromRGB(120,40,40) closeBtn.TextColor3 = Color3.fromRGB(255,255,255) closeBtn.BorderSizePixel = 0 closeBtn.Parent = mainFrame

-- Toggle Low Graphics button local toggleBtn = Instance.new("TextButton") toggleBtn.Size = UDim2.new(1, -20, 0, 34) toggleBtn.Position = UDim2.new(0, 10, 0, 34) toggleBtn.Text = "Turn Low ON" toggleBtn.Font = Enum.Font.SourceSans toggleBtn.TextSize = 16 toggleBtn.BackgroundColor3 = Color3.fromRGB(50,50,50) toggleBtn.TextColor3 = Color3.fromRGB(255,255,255) toggleBtn.BorderSizePixel = 0 toggleBtn.Parent = mainFrame

-- Hide Others button (same style) local hideBtn = Instance.new("TextButton") hideBtn.Size = UDim2.new(1, -20, 0, 34) hideBtn.Position = UDim2.new(0, 10, 0, 74) hideBtn.Text = "Hide Others" hideBtn.Font = Enum.Font.SourceSans hideBtn.TextSize = 16 hideBtn.BackgroundColor3 = Color3.fromRGB(50,50,50) hideBtn.TextColor3 = Color3.fromRGB(255,255,255) hideBtn.BorderSizePixel = 0 hideBtn.Parent = mainFrame

-- FPS label (not visible when minimized) local fpsLabel = Instance.new("TextLabel") fpsLabel.Size = UDim2.new(1, -20, 0, 14) fpsLabel.Position = UDim2.new(0, 10, 1, -20) fpsLabel.BackgroundTransparency = 1 fpsLabel.Text = "FPS: -- | PING: --" fpsLabel.Font = Enum.Font.SourceSans fpsLabel.TextSize = 13 fpsLabel.TextColor3 = Color3.fromRGB(220,220,220) fpsLabel.TextXAlignment = Enum.TextXAlignment.Left fpsLabel.Parent = mainFrame

-- Dragging logic for mainFrame local dragging, dragInput, dragStart, startPos

title.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = mainFrame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)

title.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)

UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

-- Show button (small draggable) appears when main GUI minimized local showButton = Instance.new("TextButton") showButton.Name = "ShowButton" showButton.Size = UDim2.new(0, 100, 0, 30) showButton.BackgroundColor3 = Color3.fromRGB(60,60,60) showButton.TextColor3 = Color3.fromRGB(255,255,255) showButton.Text = "Show GUI" showButton.Font = Enum.Font.SourceSans showButton.TextSize = 16 showButton.Visible = false

-- Draggable for showButton local sbDragging, sbDragInput, sbDragStart, sbStartPos showButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sbDragging = true sbDragStart = input.Position sbStartPos = showButton.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then sbDragging = false end end) end end) showButton.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then sbDragInput = input end end) UserInputService.InputChanged:Connect(function(input) if input == sbDragInput and sbDragging then local delta = input.Position - sbDragStart showButton.Position = UDim2.new(sbStartPos.X.Scale, sbStartPos.X.Offset + delta.X, sbStartPos.Y.Scale, sbStartPos.Y.Offset + delta.Y) end end)

-- Minimize / Close behavior local hidden = false local function setHidden(h) hidden = h if hidden then -- hide all except title, minimize and close (title still visible area) for _, child in ipairs(mainFrame:GetChildren()) do if child ~= title and child ~= minimizeBtn and child ~= closeBtn then child.Visible = false end end mainFrame.Size = UDim2.new(0, 220, 0, 28) -- position showButton to match mainFrame position (so it feels natural) showButton.Position = UDim2.new(0, mainFrame.Position.X.Offset, 0, mainFrame.Position.Y.Offset) showButton.Visible = true -- parent showButton to the same parent if not showButton.Parent then showButton.Parent = screenGui end else for _, child in ipairs(mainFrame:GetChildren()) do child.Visible = true end mainFrame.Size = UDim2.new(0, 220, 0, 120) showButton.Visible = false end end

minimizeBtn.MouseButton1Click:Connect(function() setHidden(not hidden) end) showButton.MouseButton1Click:Connect(function() setHidden(false) end)

closeBtn.MouseButton1Click:Connect(function() pcall(function() screenGui:Destroy() end) end)

-- Low graphics toggle implementation local prevValues = {} local function enableLowGraphics() if lowGraphicsEnabled then return end lowGraphicsEnabled = true pcall(function() prevValues.QualityLevel = settings().Rendering.QualityLevel end) prevValues.GlobalShadows = Lighting.GlobalShadows prevValues.Brightness = Lighting.Brightness prevValues.FogEnd = Lighting.FogEnd pcall(function() settings().Rendering.QualityLevel = 1 end) Lighting.GlobalShadows = false Lighting.Brightness = math.clamp(Lighting.Brightness * 0.9, 0, 10) Lighting.FogEnd = 1000 end local function disableLowGraphics() if not lowGraphicsEnabled then return end lowGraphicsEnabled = false pcall(function() if prevValues.QualityLevel then settings().Rendering.QualityLevel = prevValues.QualityLevel end end) if prevValues.GlobalShadows ~= nil then Lighting.GlobalShadows = prevValues.GlobalShadows end if prevValues.Brightness ~= nil then Lighting.Brightness = prevValues.Brightness end if prevValues.FogEnd ~= nil then Lighting.FogEnd = prevValues.FogEnd end end

toggleBtn.MouseButton1Click:Connect(function() if lowGraphicsEnabled then disableLowGraphics(); toggleBtn.Text = "Turn Low ON" else enableLowGraphics(); toggleBtn.Text = "Turn Low OFF" end end)

-- Hide Others implementation (client-side visual hide using LocalTransparencyModifier and disabling name tags) local function hidePlayerVisual(plr) if not plr or not plr.Character then return end if hiddenPlayersState[plr] then return end local state = { parts = {}, guis = {} } hiddenPlayersState[plr] = state

for _, part in ipairs(plr.Character:GetDescendants()) do
    if part:IsA("BasePart") then
        -- store previous value if exists
        local prev = 0
        pcall(function() prev = part.LocalTransparencyModifier end)
        state.parts[#state.parts+1] = { part = part, prev = prev }
        pcall(function() part.LocalTransparencyModifier = 1 end)
    elseif part:IsA("BillboardGui") or part:IsA("SurfaceGui") then
        state.guis[#state.guis+1] = part
        pcall(function() part.Enabled = false end)
    end
end
-- hide character name via hum: DisplayDistanceType if available
pcall(function()
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        state.humDisplay = hum.DisplayDistanceType
        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end
end)

end

local function showPlayerVisual(plr) local state = hiddenPlayersState[plr] if not state then return end for _, info in ipairs(state.parts) do pcall(function() info.part.LocalTransparencyModifier = info.prev or 0 end) end for _, g in ipairs(state.guis) do pcall(function() g.Enabled = true end) end pcall(function() local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") if hum and state.humDisplay then hum.DisplayDistanceType = state.humDisplay end end) hiddenPlayersState[plr] = nil end

local function hideAllOtherPlayers() for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LocalPlayer then hidePlayerVisual(plr) end end end

local function showAllOtherPlayers() for plr, _ in pairs(hiddenPlayersState) do pcall(function() showPlayerVisual(plr) end) end end

hideBtn.MouseButton1Click:Connect(function() if hideOthersEnabled then -- turn off showAllOtherPlayers() hideOthersEnabled = false hideBtn.Text = "Hide Others" hideBtn.BackgroundColor3 = Color3.fromRGB(50,50,50) else -- turn on hideAllOtherPlayers() hideOthersEnabled = true hideBtn.Text = "Show Others" hideBtn.BackgroundColor3 = Color3.fromRGB(60,200,80) -- green end end)

-- Keep hiding state consistent when players join/leave or character respawn Players.PlayerRemoving:Connect(function(plr) hiddenPlayersState[plr] = nil end) Players.PlayerAdded:Connect(function(plr) -- if hideOthersEnabled and player added after, hide them plr.CharacterAdded:Connect(function(char) if hideOthersEnabled and plr ~= LocalPlayer then -- small delay to ensure parts exist task.wait(0.1) hidePlayerVisual(plr) end end) end)

-- Also handle when existing players respawn for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LocalPlayer then plr.CharacterAdded:Connect(function() if hideOthersEnabled then task.wait(0.1) hidePlayerVisual(plr) end end) end end

-- FPS & Ping updater (safe) local fps, frameCount, accumulator = 0, 0, 0 RunService.RenderStepped:Connect(function(dt) frameCount = frameCount + 1 accumulator = accumulator + dt if accumulator >= 0.5 then fps = math.floor(frameCount / accumulator + 0.5) frameCount, accumulator = 0, 0 local ping = "--" pcall(function() if Stats and Stats:FindFirstChild("Network") and Stats.Network:FindFirstChild("ServerStatsItem") then local item = Stats.Network.ServerStatsItem:FindFirstChild("Data Ping") if item then ping = math.floor(item:GetValue() + 0.5) end end end) fpsLabel.Text = string.format("FPS: %s | PING: %s", tostring(fps), tostring(ping)) end end)

-- Parent GUI (gethui fallback) local suc, gh = pcall(function() return gethui() end) screenGui.Parent = (suc and gh) or game:GetService("CoreGui")

-- put mainFrame into screenGui mainFrame.Parent = screenGui

print("[Low Graphics GUI] Executor Safe with Hide Others loaded")

