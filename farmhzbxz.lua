-- Fly + Noclip GUI (Mobile Friendly, Fix Naik Turun)
-- Analog atas = naik, analog bawah = turun

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
                local forward = cam.CFrame.LookVector
                local right = cam.CFrame.RightVector
                local up = cam.CFrame.UpVector

                -- Buat forward/right tetap datar (tanpa Y)
                forward = Vector3.new(forward.X, 0, forward.Z).Unit
                right = Vector3.new(right.X, 0, right.Z).Unit

                -- Mapping analog
                local move = (forward * moveDir.Z) + (right * moveDir.X)

                -- Analog atas = naik, bawah = turun
                move = move + (up * moveDir.Y)

                bodyVel.Velocity = move * speed
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
