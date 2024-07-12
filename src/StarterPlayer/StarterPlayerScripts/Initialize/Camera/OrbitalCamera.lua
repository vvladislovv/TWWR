-- Chrythm's basic smoothed camera system
-- OrbitalCamera class
-- November 1, 2021

local Camera = require(script.Parent)
local OrbitalCamera = setmetatable({}, Camera)
OrbitalCamera.__index = OrbitalCamera

function OrbitalCamera.new(sensitivity, ...)
	local newOrbitalCamera = setmetatable(Camera.new(...), OrbitalCamera)
	newOrbitalCamera.DesiredAngleY = 0
	newOrbitalCamera.DesiredAngleX = 0
	newOrbitalCamera.AngleY = 0
	newOrbitalCamera.AngleX = 0
	newOrbitalCamera.Sensitivity = sensitivity -- pixels needed to move for a half y-axis rotation
	return newOrbitalCamera
end

function OrbitalCamera:Move(delta)
	self.DesiredAngleY -= delta.X * self.Sensitivity
	self.DesiredAngleX = math.clamp(self.DesiredAngleX - (delta.Y * self.Sensitivity), math.pi / -2, math.pi / 2)
end

function OrbitalCamera:SetFocus(part, offset)
	self.FocusPart = part
	self.Offset = offset
end

function OrbitalCamera:GetCFrame()
	if self.FocusPart then
		self.AngleY += (self.DesiredAngleY - self.AngleY) / self.Smoothing
		self.AngleX += (self.DesiredAngleX - self.AngleX) / self.Smoothing
		self.Distance += (self.DesiredDistance - self.Distance) / self.Smoothing
		local cframe = CFrame.Angles(0, self.AngleY, 0) * CFrame.Angles(self.AngleX, 0, 0) + self.FocusPart.CFrame:PointToWorldSpace(self.Offset)
		cframe -= cframe.LookVector * self.Distance
		return cframe
	end
end

return OrbitalCamera