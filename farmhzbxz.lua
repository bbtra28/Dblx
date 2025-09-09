-- Fly + Noclip GUI (Mobile, Fix Naik Turun dengan Kamera)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- Fly & Noclip settings
local flying = false
local noclip = false
local speed = 60
local bodyVel, bodyGyro

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FlyNoclipGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 160, 0, 100)
frame.Position = UDim2.new(0.05, 0, 0.7, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
frame.Visible = true

local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
flyBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
flyBtn.Text = "Fly: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
flyBtn.TextColor3 = Color3.new(1, 1, 1)
flyBtn.Font = Enum.Font.SourceSansBold
flyBtn.TextSize = 20

local noclipBtn = Instance.new("TextButton", frame)
noclipBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
noclipBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
noclipBtn.Text = "Noclip: OFF"
noclipBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
noclipBtn.TextColor3 = Color3.new(1, 1, 1)
noclipBtn.Font = Enum.Font.SourceSansBold
noclipBtn.TextSize = 20

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 80, 0, 30)
toggleBtn.Position = UDim2.new(0.05, 0, 0.62, 0)
toggleBtn.Text = "Hide GUI"
toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 18

-- Function Fly
local function startFly()
    bodyVel = Instance.new("BodyVelocity")
    bodyGyro = Instance.new("BodyGyro")
    bodyVel.Velocity = Vector3.zero
    bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)
    bodyVel.Parent = hrp
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bodyGyro.Parent = hrp

    RunService.RenderStepped:Connect(function()
        if flying and hrp and player.Character then
            local cam = workspace.CurrentCamera
            local moveDir = humanoid.MoveDirection

            if moveDir.Magnitude > 0 then
                -- Gerakan maju mundur ikut kamera (termasuk naik/turun)
                local forward = cam.CFrame.LookVector * moveDir.Z
                local right = cam.CFrame.RightVector * moveDir.X
                local move = (forward + right) * speed

                bodyVel.Velocity = move
            else
                bodyVel.Velocity = Vector3.zero
            end

            bodyGyro.CFrame = cam.CFrame
        end
    end)
end

-- Fly Button
flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        startFly()
        flyBtn.Text = "Fly: ON"
        flyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
    else
        if bodyVel then bodyVel:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        flyBtn.Text = "Fly: OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    end
end)

-- Noclip Button
noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    if noclip then
        noclipBtn.Text = "Noclip: ON"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 50)
        RunService.Stepped:Connect(function()
            if noclip and player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        noclipBtn.Text = "Noclip: OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
    end
end)

-- Hide/Show Button
toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    toggleBtn.Text = frame.Visible and "Hide GUI" or "Show GUI"
end)
