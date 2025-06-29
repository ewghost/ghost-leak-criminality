local input = game:GetService("UserInputService")
local me = game:GetService("Players").LocalPlayer
local run = game:GetService("RunService")

local Activated = false

local Settings = {
	Freeze = false,
}

local Loaded = false

function Decrypt()
	local result = ""
	for i = 1, 30 do
		result = result..string.char(math.random(1, 120))
	end
	return result
end

local gui = Instance.new("ScreenGui")
gui.Parent = me.PlayerGui
gui.ResetOnSpawn = false

local menu = Instance.new("Frame")
menu.Parent = gui
menu.Name = Decrypt()
menu.BackgroundColor3 = Color3.new(0.258824, 0.258824, 0.258824)
menu.Position = UDim2.new(0.064, 0, 0.252, 0)
menu.Size = UDim2.new(0.151, 0, 0.157, 0)
menu.Visible = true

local ActiveText = Instance.new("TextLabel")
ActiveText.Parent = menu
ActiveText.Name = Decrypt()
ActiveText.BackgroundTransparency = 1
ActiveText.Position = UDim2.new(0.099, 0, -0, 0)
ActiveText.Size = UDim2.new(0.797, 0, 0.349, 0)
ActiveText.TextScaled = true
ActiveText.TextColor3 = Color3.new(1, 0, 0)
ActiveText.Text = "Not active"
ActiveText.Visible = true

local UISActiveText = Instance.new("UIStroke")
UISActiveText.Parent = ActiveText
UISActiveText.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
UISActiveText.Color = Color3.new(0, 0, 0)
UISActiveText.Thickness = 1.5

function MakeButton(Text, Position, func)
	local Button = Instance.new("ImageButton")
	Button.Parent = menu
	Button.Name = Decrypt()
	Button.BackgroundColor3 = Color3.new(0.0627451, 0.0627451, 0.0627451)
	Button.Position = Position
	Button.Size = UDim2.new(0.102, 0, 0.243, 0)
	Button.Image = "rbxassetid://6218581738"
	Button.ImageTransparency = 1
	Button.Visible = true

	Instance.new("UIAspectRatioConstraint", Button)

	local UISButton = Instance.new("UIStroke")
	UISButton.Parent = Button
	UISButton.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UISButton.Color = Color3.new(1, 1, 1)
	UISButton.Thickness = 1

	local text = Instance.new("TextLabel")
	text.Parent = Button
	text.Name = Decrypt()
	text.BackgroundTransparency = 1
	text.Position = UDim2.new(1.286, 0, 0, 0)
	text.Size = UDim2.new(4.095, 0, 1, 0)
	text.TextScaled = true
	text.TextColor3 = Color3.new(1, 1, 1)
	text.Text = Text
	text.Visible = true

	Button.MouseButton1Click:Connect(func)
	return Button
end

local FreezeNetwork;FreezeNetwork = MakeButton("Freeze network", UDim2.new(0.166, 0, 0.405, 0), function()
	Settings.Freeze = not Settings.Freeze
	FreezeNetwork.ImageTransparency = Settings.Freeze and 0 or 1
end)

local ActivateButton = Instance.new("TextButton")
ActivateButton.Parent = menu
ActivateButton.Name = Decrypt()
ActivateButton.BackgroundTransparency = 0.85
ActivateButton.BackgroundColor3 = Color3.new(1, 1, 1)
ActivateButton.Position = UDim2.new(0.253, 0, 0.74, 0)
ActivateButton.Size = UDim2.new(0.488, 0, 0.165, 0)
ActivateButton.TextScaled = true
ActivateButton.TextColor3 = Color3.new(1, 1, 1)
ActivateButton.Text = "activate [E]"
ActivateButton.Visible = true

local UICActivateButton = Instance.new("UICorner")
UICActivateButton.Parent = ActivateButton
UICActivateButton.CornerRadius = UDim.new(0, 8)

local UISActivateButton = Instance.new("UIStroke")
UISActivateButton.Parent = ActivateButton
UISActivateButton.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UISActivateButton.Color = Color3.new(0, 0, 0)
UISActivateButton.Thickness = 1

function Load()
	if Loaded then return end
	Loaded = true
	run.RenderStepped:Connect(function()
		if Activated then
			settings():GetService("NetworkSettings").IncomingReplicationLag = Settings.Freeze and 9999999 or 0
		else
			settings():GetService("NetworkSettings").IncomingReplicationLag = 0
		end

		if Activated and me.Character then
			local hrp = me.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				local dt = run.RenderStepped:Wait()
				local cam = workspace.CurrentCamera
				local dir = Vector3.new()
				if input:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
				if input:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
				if input:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
				if input:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
				if input:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
				if input:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
				if dir.Magnitude > 0 then dir = dir.Unit end

				local speedFly = 20
				hrp.CFrame = hrp.CFrame + dir * speedFly * dt
			end
		end

		if me.Character then
			local hrp = me.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				hrp.Anchored = Activated
			end
		end
	end)
end

ActivateButton.MouseButton1Click:Connect(function()
	Activated = not Activated
	ActiveText.Text = Activated and "Active" or "Not Active"
	ActiveText.TextColor3 = Activated and Color3.new(0.0509804, 1, 0) or Color3.new(1, 0, 0)
	Load()
end)

input.InputBegan:Connect(function(key, gp)
	if gp then return end
	if key.KeyCode == Enum.KeyCode.E then
		Activated = not Activated
		ActiveText.Text = Activated and "Active" or "Not Active"
		ActiveText.TextColor3 = Activated and Color3.new(0.0509804, 1, 0) or Color3.new(1, 0, 0)
		Load()
	end
end)
