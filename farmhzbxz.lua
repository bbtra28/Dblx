-- Instances:
local FlyScript = Instance.new("ScreenGui")
local Gradient = Instance.new("Frame")
local UIGradient = Instance.new("UIGradient")
local UICorner = Instance.new("UICorner")
local Button = Instance.new("TextButton")
local Shadow = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")

-- Properties:
FlyScript.Name = "FlyScript"
FlyScript.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
FlyScript.ResetOnSpawn = false

Gradient.Name = "Gradient"
Gradient.Parent = FlyScript
Gradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Gradient.BorderSizePixel = 0
Gradient.Position = UDim2.new(0.02, 0, 0.78, 0)
Gradient.Size = UDim2.new(0, 231, 0, 81)

UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(57, 104, 252)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(51, 68, 175))
}
UIGradient.Parent = Gradient

UICorner.CornerRadius = UDim.new(0.04, 0)
UICorner.Parent = Gradient

Button.Name = "Button"
Button.Parent = Gradient
Button.BackgroundColor3 = Color3.fromRGB(77, 100, 150)
Button.BorderSizePixel = 0
Button.Position = UDim2.new(0.09, 0, 0.23, 0)
Button.Size = UDim2.new(0, 187, 0, 41)
Button.ZIndex = 2
Button.Font = Enum.Font.GothamSemibold
Button.Text = ""
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextScaled = true
Button.TextWrapped = true

Shadow.Name = "Shadow"
Shadow.Parent = Button
Shadow.BackgroundColor3 = Color3.fromRGB(53, 69, 103)
Shadow.BorderSizePixel = 0
Shadow.Size = UDim2.new(1, 0, 1, 4)

TextLabel.Parent = Gradient
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
TextLabel.Size = UDim2.new(0.87, -20, 0.72, -20)
TextLabel.ZIndex = 2
TextLabel.Font = Enum.Font.GothamBold
TextLabel.Text = "Fly"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextWrapped = true

-- Fly System
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local flying = false
local speed = 0
local maxspeed = 50
local ctrl = {f=0, b=0, l=0, r=0}
local lastctrl = {f=0, b=0, l=0, r=0}

function Fly()
	local bg = Instance.new("BodyGyro", HRP)
	bg.P = 9e4
	bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	bg.CFrame = HRP.CFrame

	local bv = Instance.new("BodyVelocity", HRP)
	bv.Velocity = Vector3.new(0,0.1,0)
	bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

	while flying and task.wait() do
		Character.Humanoid.PlatformStand = true
		if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
			speed += 0.5 + (speed/maxspeed)
			if speed > maxspeed then speed = maxspeed end
		elseif speed ~= 0 then
			speed -= 1
			if speed < 0 then speed = 0 end
		end

		if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
			bv.Velocity = ((workspace.CurrentCamera.CFrame.LookVector * (ctrl.f+ctrl.b)) 
			+ ((workspace.CurrentCamera.CFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0)).Position 
			- workspace.CurrentCamera.CFrame.Position)) * speed
			lastctrl = {f=ctrl.f, b=ctrl.b, l=ctrl.l, r=ctrl.r}
		elseif speed ~= 0 then
			bv.Velocity = ((workspace.CurrentCamera.CFrame.LookVector * (lastctrl.f+lastctrl.b)) 
			+ ((workspace.CurrentCamera.CFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0)).Position 
			- workspace.CurrentCamera.CFrame.Position)) * speed
		else
			bv.Velocity = Vector3.new(0,0.1,0)
		end
		bg.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
	end

	ctrl = {f=0, b=0, l=0, r=0}
	lastctrl = ctrl
	speed = 0
	bg:Destroy()
	bv:Destroy()
	Character.Humanoid.PlatformStand = false
end

-- Input
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.E then
		flying = not flying
		if flying then Fly() end
	elseif input.KeyCode == Enum.KeyCode.W then ctrl.f = 1
	elseif input.KeyCode == Enum.KeyCode.S then ctrl.b = -1
	elseif input.KeyCode == Enum.KeyCode.A then ctrl.l = -1
	elseif input.KeyCode == Enum.KeyCode.D then ctrl.r = 1 end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W then ctrl.f = 0
	elseif input.KeyCode == Enum.KeyCode.S then ctrl.b = 0
	elseif input.KeyCode == Enum.KeyCode.A then ctrl.l = 0
	elseif input.KeyCode == Enum.KeyCode.D then ctrl.r = 0 end
end)

-- GUI Button Toggle
Button.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then Fly() end
end)

-- Draggable GUI (modern)
local dragging, dragInput, dragStart, startPos
Gradient.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Gradient.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Gradient.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		Gradient.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
