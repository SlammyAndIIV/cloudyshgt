local CC = game:GetService"Workspace".CurrentCamera
local Plr
local enabled = false
 _G.accomidationfactor = 0.13532432
 _G.KeyBind = "q"
 _G.AimPart = 'HumanoidRootPart' -- Head, UpperTorso, HumanoidRootPart, LowerTorso
 _G.ScriptTitle = "Slammys Private V2" 
 _G.ScriptIcon = "http://www.roblox.com/asset/?id=8850953349"
 _G.AirshotFunction = true
 _G.AirshotFunctionPart = 'LeftLowerLeg' -- "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg",  "LeftUpperLeg", "RightLowerLeg", "RightFoot",  "RightUpperLeg"
 _G.XDotSize = 2
 _G.YDotSize = 1
 _G.DotTransparency = 0.2
 _G.DotSideNumbness = UDim.new(10, 10)
 _G.DotColor = Color3.fromRGB(82, 112, 234)
 _G.HitboxTransparency = 0.65
 _G.HitBoxSize = Vector3.new(10, 8.7, 10)

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
local mouse = game.Players.LocalPlayer:GetMouse()
local placemarker = Instance.new("Part", game.Workspace)

function SendNotification(e, a, dur)
    game.StarterGui:SetCore("SendNotification",  {Title =  _G.ScriptTitle ; Text = a; Icon = _G.ScriptIcon; Duration = dur;})
end

function makemarker(Parent, Adornee, Color, Size, Size2)
    local e = Instance.new("BillboardGui", Parent)
    e.Name = "PP"
    e.Adornee = Adornee
    e.Size = UDim2.new(Size, Size2, Size, Size2)
    e.AlwaysOnTop = true
    local a = Instance.new("Frame", e)
    a.Size = UDim2.new(_G.XDotSize, 0, _G.YDotSize, 0)
    a.BackgroundTransparency = _G.DotTransparency
    a.BackgroundColor3 = Color
    local g = Instance.new("UICorner", a)
    g.CornerRadius =  _G.DotSideNumbness
    return(e)
end

    
local data = game.Players:GetPlayers()
function noob(player)
    repeat wait() until player.Character
    local handler = makemarker(guimain, player.Character:WaitForChild("HumanoidRootPart"), Color3.fromRGB(107, 184, 255), 0.3, 3)
    handler.Name = player.Name
    player.CharacterAdded:connect(function(Char) handler.Adornee = Char:WaitForChild("HumanoidRootPart") end)


    spawn(function()
        while wait() do
            if player.Character then
                TextLabel.Text = player.Name..tostring(player:WaitForChild("leaderstats").Wanted.Value).." | "..tostring(math.floor(player.Character:WaitForChild("Humanoid").Health))
            end
        end
    end)
end

for i = 1, #data do
    if data[i] ~= game.Players.LocalPlayer then
        noob(data[i])
    end
end

game.Players.PlayerAdded:connect(function(Player)
    noob(Player)
end)

spawn(function()
    placemarker.Anchored = true
    placemarker.CanCollide = false
    placemarker.Size = _G.HitBoxSize
    placemarker.Transparency = _G.HitboxTransparency
    makemarker(placemarker, placemarker, _G.DotColor, 0.40, 0)
end)    

mouse.KeyDown:Connect(function(k)
    if k ~= _G.KeyBind then return end
    if enabled then
        enabled = false
        SendNotification('', "Unlocked", 3)
        guimain[Plr.Name].Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    else
        enabled = true 
        Plr = getClosestPlayerToCursor()
        SendNotification('', "Locked onto "..Plr.Name, 3)
        guimain[Plr.Name].Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end    
end)

function getClosestPlayerToCursor()
    local closestPlayer
    local shortestDistance = math.huge

    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos = CC:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude
                if magnitude < shortestDistance then
                closestPlayer = v
                shortestDistance = magnitude
            end
        end
    end
    return closestPlayer
end

game:GetService"RunService".Stepped:connect(function()
    if enabled and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
        placemarker.CFrame =  CFrame.new(Plr.Character[_G.AimPart].Position +
                                    (Plr.Character.UpperTorso.Velocity * _G.accomidationfactor))
    else
        placemarker.CFrame = CFrame.new(0, 9999, 0)
    end
end)

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(...)
local args = {...}
    if enabled and getnamecallmethod() == "FireServer" and args[2] == "UpdateMousePos" then
        args[3] =Plr.Character[_G.AimPart].Position +
                      (Plr.Character[_G.AimPart].Velocity * _G.accomidationfactor)
        return old(unpack(args))
    end
    return old(...)
end)

if _G.AirshotFunction then
if Plr.Character.Humanoid.Jump == true and Plr.Character.Humanoid.FloorMaterial == Enum.Material.Air then
        _G.AimPart = _G.AirshotFunctionPart
end
    end
