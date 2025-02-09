local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local camera = workspace.CurrentCamera
local canSpawn = true
local connection
local MaxFPS = 7

local titles = {
	"COME BACK",
	"DONT RUN",
	"WHERE ARE YOU?",
	"GET OUT",
}



local function onRenderedFrame(part)
	local position, visible = camera:WorldToScreenPoint(part.Position)
	return visible
end

local function superDuperScary()
	local sound = Instance.new("Sound")
	sound.Parent = SoundService
	sound.SoundId = "rbxassetid://6866593791"
	sound.Looped = true
	sound:Play()	
	MaxFPS = 1
	coroutine.resume(coroutine.create(function()
		while true do
			local randomTitle = titles[math.random(1,#titles)]
			game:GetService("StarterGui"):SetCore("SendNotification",{
				Title = randomTitle, -- Required
				Text = "null", -- Required
			})
			local t0 = tick()
			RunService.Heartbeat:Wait()
			repeat until (t0 + 1/MaxFPS) < tick()
		end
	end))
	
	task.wait(3)
	MaxFPS = 60
	
	
	local sound2 = Instance.new("Sound")
	sound2.Parent = SoundService
	sound2.SoundId = "rbxassetid://9125351901"
	sound2.Looped = true
	sound2:Play()
	sound:Destroy()
	Lighting.Atmosphere.Density = .8
	Lighting.Atmosphere.Haze = 5
	Lighting.Atmosphere.Color = Color3.new(0,0,0)
	Lighting.Brightness = 0
	Lighting.Sky.StarCount = 0
	Lighting.ClockTime = 0
	
	for i, d in pairs(game:GetDescendants()) do
		if d:IsA("BasePart") then
			d.Material = Enum.Material.Grass
		end
	end	
end


coroutine.resume(coroutine.create(function()
	while canSpawn do
		if workspace:FindFirstChild("Redacted") then return end
		local random = math.random(1,30)
		print(random)
		task.wait(random)
		
		
		
		
		
		local part = Instance.new('Part')
		part.Name = "Redacted"
		part.Size = Vector3.new(2,5,2)
		part.Anchored = true
		part.Position = Vector3.new(char.PrimaryPart.Position.X + math.random(-30,30),char.PrimaryPart.Position.Y + 20,char.PrimaryPart.Position.Z + math.random(-30,30))
		
		part.Parent = workspace
		
		local result = workspace:Raycast(part.Position,Vector3.new(0,-100,0))
		if result then
			part.Position = result.Position + Vector3.new(0,2.5,0)
			
			part.Transparency = 1
			local billboardGui =  Instance.new("BillboardGui")
			billboardGui.Size = UDim2.new(5,0,7,0)
			billboardGui.StudsOffset = Vector3.new(0,1,0)
			local imageLabel = Instance.new('ImageLabel')
			imageLabel.BackgroundTransparency = 1
			imageLabel.Size = UDim2.new(1,0,1,0)
			imageLabel.Image = "rbxassetid://9360984353"
			
			billboardGui.Parent = part
			imageLabel.Parent = billboardGui
			
			
			if connection then connection:Disconnect() end
			connection = RunService.RenderStepped:Connect(function()
				if part then
					if onRenderedFrame(part) == true then
						canSpawn = false
						task.wait(.2)
						part.CFrame = CFrame.lookAt(part.Position,plr.Character.HumanoidRootPart.Position)
						local distanceToMove = (part.Position - plr.Character.HumanoidRootPart.Position).Magnitude
						part.Position = part.Position + part.CFrame.LookVector * distanceToMove/2
						superDuperScary()
						part:Destroy()
						connection:Disconnect()
					end
				end
			end)
			
			Debris:AddItem(part,math.random(10,20))
			
			
			
		else
			part:Destroy()
		end
		
		
	end
end))
