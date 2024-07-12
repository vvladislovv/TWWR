-- Chrythm's basic smoothed camera system
-- Camera class
-- November 1, 2021

local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local contextActionService = game:GetService("ContextActionService")

local Camera = {}
Camera.__index = Camera

function Camera.new(minDistance, maxDistance, smoothing)
	local newCamera = setmetatable({}, Camera)
	newCamera.DesiredDistance = 10
	newCamera.Distance = newCamera.DesiredDistance
	newCamera.Smoothing = smoothing or 2 -- the higher the number, the more the smoothing; use 1 for no smoothing
	newCamera.MinDistance = minDistance
	newCamera.MaxDistance = maxDistance
	newCamera.ThumbstickPosition = Vector3.new()
	return newCamera
end

function Camera:Zoom(step)
	local zoomIncrement = math.max(math.abs(step) * (self.DesiredDistance / 2), 3) * math.sign(step)
	self.DesiredDistance = math.clamp(self.DesiredDistance - zoomIncrement, self.MinDistance, self.MaxDistance)
end

function Camera:Enable()
	self:Disable()
	workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
	local inputFunctions = {
		[Enum.UserInputType.MouseWheel] = function(actionName, inputState, inputObject)
			self:Zoom(inputObject.Position.Z)
		end,
		[Enum.UserInputType.MouseButton2] = function(actionName, inputState, inputObject)
			if inputState == Enum.UserInputState.Begin then
				userInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
			else
				userInputService.MouseBehavior = Enum.MouseBehavior.Default
			end
		end,
		[Enum.UserInputType.MouseMovement] = function(actionName, inputState, inputObject)
			if userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
				self:Move(inputObject.Delta)
			end
		end,
		[Enum.UserInputType.Touch] = function(actionName, inputState, inputObject)
			if inputObject.Position.X > workspace.CurrentCamera.ViewportSize.X / 2 then
				self:Move(inputObject.Delta)
			end
		end,
		[Enum.KeyCode.Thumbstick2] = function(actionName, inputState, inputObject)
			if inputObject.Position.Magnitude > 0.5 then
				self.ThumbstickPosition = inputObject.Position * Vector3.new(1, -1, 0) * 5
			else
				self.ThumbstickPosition = Vector3.new()
			end
		end,
	}
	local inputs = {}
	for input, func in pairs(inputFunctions) do
		table.insert(inputs, input)
	end
	contextActionService:BindAction("MoveCamera", function(actionName, inputState, inputObject)
		if inputFunctions[inputObject.KeyCode] then
			inputFunctions[inputObject.KeyCode](actionName, inputState, inputObject)
		elseif inputFunctions[inputObject.UserInputType] then
			inputFunctions[inputObject.UserInputType](actionName, inputState, inputObject)
		end
	end, false, table.unpack(inputs))
	runService:BindToRenderStep("CustomCamera", Enum.RenderPriority.Camera.Value, function()
		workspace.CurrentCamera.CFrame = self:GetCFrame() or workspace.CurrentCamera.CFrame
		self:Move(self.ThumbstickPosition)
	end)
end

function Camera:Disable()
	runService:UnbindFromRenderStep("CustomCamera")
end

return Camera