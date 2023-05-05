local NPCS = {}

for i, v in pairs(game:GetService("Workspace").World.Live.Mobs:GetDescendants()) do
    if v:IsA "Model" and v:FindFirstChild("HumanoidRootPart") then
        if not table.find(NPCS, v.Name) then
            table.insert(NPCS, v.Name)
        end
    end
end

local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/yupbr/rbxscripts/main/UI%20Libraries/MaterialLua/Module.lua"))()

local UI = Material.Load({
    Title = "LuaHHub | Project Mugetsu",
    Style = 2,
    SizeX = 300,
    SizeY = 350,
    Theme = "Light",
    ColorOverrides = {
        MainFrame = Color3.fromRGB(0,0,0),
        Toggle = Color3.fromRGB(124,37,255),
        ToggleAccent = Color3.fromRGB(255,255,255), 
        Dropdown = Color3.fromRGB(124,37,255),
		DropdownAccent = Color3.fromRGB(255,255,255),
        Slider = Color3.fromRGB(124,37,255),
		SliderAccent = Color3.fromRGB(255,255,255),
        NavBarAccent = Color3.fromRGB(0,0,0),
        Content = Color3.fromRGB(0,0,0),
    }
})

local X = UI.New({
    Title = "Principal"
})

X.Toggle({
    Text = "Auto Meditar",
    Callback = function(Value)
        a = Value
        while a do task.wait(0.1)
            local args = {
	              [1] = "Meditating",
	              [2] = true,
	          }
	          local args2 = {
	              [1] = "Apply_Meditation",
	              [2] = 1,
                [3] = true
             }
            game:GetService("ReplicatedStorage").Remotes.Server.Initiate_Server:FireServer(unpack(args))
            game:GetService("ReplicatedStorage").Remotes.Server.Initiate_Server:FireServer(unpack(args2))
        end
	  end,
    Enabled = false
})

X.Toggle({
    Text = "Auto Eat (Hallow)",
    Callback = function(Value)
        a = Value
        while a do task.wait()
            	local partsEat = game:GetService("Workspace").World.Visuals
		for i, v in ipairs(partsEat:GetChildren()) do
			local prompt = v:FindFirstChild("Eat_Part")
			if prompt and prompt:IsA("ProximityPrompt") then
				fireproximityprompt(prompt)
				task.wait(1)
			end
		end
        end
end,
    Enabled = false
})

X.Dropdown({
    Text = "Selecionar Arma",
    Callback = function(Value)
        if Value == "Espada" then
          local args = {
            [1] = "Equip_Zanpakuto",
            [2] = true
          }

          game:GetService("ReplicatedStorage").Remotes.Server.Initiate_Server:FireServer(unpack(args))
        elseif Value == "Punho" then
          local args = {
            [1] = "Equip_Zanpakuto",
            [2] = false
          }

        game:GetService("ReplicatedStorage").Remotes.Server.Initiate_Server:FireServer(unpack(args))
	end
    end,
    Options = {"Punho", "Espada"}
})

X.Toggle({
    Text = "Auto Click",
    Callback = function(Value)
        a = Value
        while a do task.wait(0.1)
              local args = {
		            [1] = "Swing",
		            [2] = 1,
		            [3] = "Sword"
	            }
	            game:GetService("ReplicatedStorage").Remotes.Server.Initiate_Server:FireServer(unpack(args))
        end
	  end,
    Enabled = false
})

local ii = X.Dropdown({
    Text = "Selecionar Mob",
    Callback = function(Value)
        getgenv().mobname = Value
    end,
    Options = NPCS
})

X.Dropdown({
    Text = "Selecionar Direção",
    Callback = function(Value)
        getgenv().direction = Value
    end,
    Options = {"Atrás", "Abaixo", "Acima"}
})

X.Button({
    Text = "Atualizar Mobs",
    Callback = function()
    table.clear(NPCS)
    for i, v in pairs(game:GetService("Workspace").World.Live.Mobs:GetDescendants()) do
           if v:IsA "Model" and v:FindFirstChild("HumanoidRootPart") then
               if not table.find(NPCS, tostring(v)) then
                    table.insert(NPCS, tostring(v))
                    ii:SetOptions(NPCS)
                end
            end
        end
    end
})

X.Toggle({
    Text = "Auto Mob",
    Callback = function(Value)
        b = Value
        while b do task.wait()
                    pcall(function()
	                  if direction == "Atrás" then
	                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = getNPC().HumanoidRootPart.CFrame * CFrame.new(0,0,-8)
	                  elseif direction == "Abaixo" then
	                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = getNPC().HumanoidRootPart.CFrame * CFrame.new(0,-8,0) * CFrame.Angles(math.rad(90),0,0)
	                  elseif direction == "Acima" then
	                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = getNPC().HumanoidRootPart.CFrame * CFrame.new(0,8,0) * CFrame.Angles(math.rad(-90),0,0)
	              end
            end)
        end
	  end,
    Enabled = false
})

function getNPC()
    local dist, thing = math.huge
    for i, v in pairs(game:GetService("Workspace").World.Live.Mobs:GetDescendants()) do
        if v:IsA "Model" and v:FindFirstChild("HumanoidRootPart") and v.Name == mobname then
            local mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).magnitude
            if mag < dist then
                dist = mag
                thing = v
            end
        end
    end
    return thing
end
