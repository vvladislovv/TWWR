local playersService = game:GetService("Players")

local OrbitalCamera = require(script:WaitForChild("Camera"):WaitForChild("OrbitalCamera"))

local camera = OrbitalCamera.new(0.01, 0.5, 20, 3)
print(camera)
camera:Enable()

function TrackCharacter(character)
	if character then
		local connection
		connection = character.ChildAdded:Connect(function(part)
			if part.Name == "HumanoidRootPart" then
				connection:Disconnect()
				camera:SetFocus(part, Vector3.new(0, 1.5, 0))
			end
		end)
	end
end

playersService.LocalPlayer.CharacterAdded:Connect(TrackCharacter)
TrackCharacter(playersService.LocalPlayer.Character)