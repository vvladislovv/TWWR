local TextLabel = script.Parent

local function UpdateFPS()
	local fps = workspace:GetRealPhysicsFPS()
	TextLabel.Text = string.format("FPS: %.0f", fps)
end

task.spawn(function()
	task.wait()
	while true do
		UpdateFPS()
		task.wait(1)
	end	
end)
