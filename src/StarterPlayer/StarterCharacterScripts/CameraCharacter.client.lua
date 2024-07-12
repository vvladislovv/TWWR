local RunService = game:GetService("RunService")

local Character = game.Players.LocalPlayer.Character
local Camera = workspace.CurrentCamera

local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local XOffset = 0

function lerp(a, b, c)
	return a + (b-a) * c
end

RunService:BindToRenderStep("MoveCamera", Enum.RenderPriority.Camera.Value, function(deltaTime)
	local flatCamLookVector = (Camera.CFrame.LookVector * Vector3.new(1,0,1)).Unit 	
	-- flat camera vector (no Y axis)
	-- So the X and Z movement is relative to the camera
	-- but the Y is relative to the world
	
	local flatCamCFrame = CFrame.new(Vector3.zero, flatCamLookVector) -- cframe from the flat vector
	local localMovement = flatCamCFrame:VectorToObjectSpace(HumanoidRootPart.Velocity/16) -- turn velocity from world to the flat camera cframe
	local xMovement = localMovement.X -- calculate the X movement based on the camera
	
	XOffset = lerp(XOffset, xMovement, math.pow(0.1, deltaTime*60)) -- interpolate for smoothness
	-- see https://www.construct.net/blogs/2/924 for delta time implementation
	
	Camera.CFrame = Camera.CFrame * CFrame.new(1, 0, 1) + flatCamCFrame.RightVector*-XOffset -- add negative offset to camera CFrame
end)