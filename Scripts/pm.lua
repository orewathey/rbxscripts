
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/yupbr/CustomField/main/versions/1b.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "Lunar | Project Mugetsu",
   LoadingTitle = "Lunar Interface",
   LoadingSubtitle = "by Lunar",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "SiriusConfig"
   },
   Discord = {
      Enabled = true,
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = "key" -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

_G.AutoPunch = false
_G.AutoMob = false
_G.AutoMeditate = false
_G.AutoEat = false
_G.AutoCollect = false
_G.Direction = "Atrás"
_G.Distance = 8
_G.WorldName = ""
local slot1 = game:GetService("ReplicatedStorage").Player_Datas[game.Players.LocalPlayer.Name].Slot_1

local NPCS = {}

local Tab = Window:CreateTab("Principal", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Farm")

for i, v in pairs(game:GetService("Workspace").World.Live.Mobs:GetDescendants()) do
    if v:IsA "Model" and v:FindFirstChild("HumanoidRootPart") then
            if not table.find(NPCS, v.Name) then
            table.insert(NPCS, v.Name)
        end
    end
end

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

function AutoMob()
   while _G.AutoMob == true do task.wait()
               pcall(function() 
	       if _G.Direction == "Atrás" then
	         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = getNPC().HumanoidRootPart.CFrame * CFrame.new(0,0,-8)
	       elseif _G.Direction == "Abaixo" then
	         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = getNPC().HumanoidRootPart.CFrame * CFrame.new(0,-8,0) * CFrame.Angles(math.rad(90),0,0)
	       elseif _G.Direction == "Acima" then
	         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = getNPC().HumanoidRootPart.CFrame * CFrame.new(0,8,0) * CFrame.Angles(math.rad(-90),0,0)
	       end
       end)
   end
end

function AutoMeditate()
        while _G.AutoMeditate == true do task.wait(0.1)
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
end

function AutoPunch()
   while _G.AutoPunch == true do
            local args = {
		[1] = "Swing",
		[2] = 1,
		[3] = "Sword"
	    }
	    game:GetService("ReplicatedStorage").Remotes.Server.Initiate_Server:FireServer(unpack(args))
            wait(0.1)
   end
end


local Toggle = Tab:CreateToggle({
   Name = "Auto Meditar",
   CurrentValue = false,
   Flag = "AutoMeditar", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(v)
   	_G.AutoMeditate = v
	AutoMeditate()
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Auto Ataque",
   CurrentValue = false,
   Flag = "AutoAtaque", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(v)
   	_G.AutoPunch = v
	AutoPunch()
   end,
})

local Toggle = Tab:CreateToggle({
   Name = "Auto Mob",
   CurrentValue = false,
   Flag = "AutoMob", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(v)
   	_G.AutoMob = v
	AutoMob()
   end,
})

local Slider = Tab:CreateSlider({
   Name = "Distância de Farm",
   Range = {1, 10},
   Increment = 1,
   Suffix = "de distância",
   CurrentValue = 8,
   Flag = "DistanciaFarm", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(v)
	_G.Distance = v
   end,
})

local Dropdown2 = Tab:CreateDropdown({
   Name = "Selecionar Direção",
   Options = {"Acima", "Atrás", "Abaixo"},
   CurrentOption = "Atrás",
   MultipleOptions = false,
   Flag = "SelecionarDireção", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(v)
	_G.Direction = v
   end,
})

local Dropdown = Tab:CreateDropdown({

   Name = "Selecionar Mob",

   Options = NPCS,

   CurrentOption = NPCS[1],

   MultipleOptions = false,

   Flag = "SelecionarMob", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps

   Callback = function(v)

	getgenv().mobname = v

   end,

})

while task.wait(5) do
	Dropdown:Set(NPCS) -- The new list of options
end


local Tab2 = Window:CreateTab("Misc", 4483362458) -- Title, Image
local Tab3 = Window:CreateTab("Créditos", 4483362458) -- Title, Image
