local players = game:GetService("Players")
local player = players.LocalPlayer
repeat task.wait() until player.Character
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")
local top = script.Parent.Top.CanvasGroup.Frame
local connection_health
local connection_maxhealth

local HealthModule = {}

local function update()
	top:TweenSize(UDim2.new(math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1), 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)
end

local function connections()
	connection_health = humanoid:GetPropertyChangedSignal("Health"):Connect(update)
	connection_maxhealth = humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(update)
	update()
end

player.CharacterAdded:Connect(function(new)
	if connection_health then connection_health:Disconnect() end
	if connection_maxhealth then connection_maxhealth:Disconnect() end
	character = new
	humanoid = character:WaitForChild("Humanoid")
	connections()
end)

connections()

return HealthModule