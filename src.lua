print("loading")
task.wait(10)

local char = game.Players.LocalPlayer.Character
local plr = game.Players.LocalPlayer
local status = ""

local serverhop = true
local targets = {"Ethereal", "Divine"}

local teleportTo = function(cfx, cfy, cfz)
    if typeof(cfx) == "Vector3" then
        char.HumanoidRootPart.CFrame = CFrame.new(cfx)
    else
        char.HumanoidRootPart.CFrame = CFrame.new(cfx,cfy,cfz)
    end
end

local findClosestEggWithName = function(name)
    local eggs = {}
    local distances = {}
    for times, renderedegg in pairs(workspace.RenderedEggs:GetChildren()) do
        if renderedegg.Name == name then
            table.insert(eggs, renderedegg)
        end
    end
    if #eggs > 1 then
        for _, egg in pairs(eggs) do
            distances[egg] = {Dist = (plr.Character.HumanoidRootPart.Position - egg.Handle.Position).Magnitude, Egg = egg}
        end
    else
        return workspace.RenderedEggs[name]
    end
    --find smallset boiiiii
    local closestEgg
    local minDist = math.huge

    for _, data in pairs(distances) do
        if data.Dist < minDist then
            minDist = data.Dist
            closestEgg = data.Egg
        end
    end

    return closestEgg
end
local findAllEggsWithinTargetRarity = function()
    local ServerData = game.ReplicatedStorage.ServerData
    local ActiveEggs = ServerData.ActiveEggs
    local Eggs = require(game.ReplicatedStorage.GameData.Eggs)
    local eggs = {}

    for _, config in pairs(ActiveEggs:GetChildren()) do
        local attributes = config:GetAttributes()
        if attributes.Egg and table.find(targets, Eggs[attributes.Egg].Rarity) and workspace.RenderedEggs:FindFirstChild(attributes.Egg) then
            eggs[attributes.Egg] = {Egg = attributes.Egg, Pos = attributes.Position, Id = config.Name}
            print("aaa")
        end
    end

    return eggs
end

local autoLoop = function()
    local Plot
    for _, plot in pairs(workspace.Plots:GetChildren()) do
        if plot.Data.Owner.Value == plr then
            Plot = plot
        end
    end
    if Plot then
        local eggs = findAllEggsWithinTargetRarity()
        if eggs then
            for _, entry in eggs do
                if not entry then status = "hopping servers..." end
                status = "teleporting to "..entry.Egg
                task.wait(1)
                teleportTo(entry.Pos)
                print(entry)
                local egg = findClosestEggWithName(entry.Egg)
                local Id = entry.Id
                task.wait(.5)
                status = "picking up..."
                game:GetService("ReplicatedStorage").Remotes.Game.EggPickup:FireServer(Id)
                task.wait(5)
                status = "going back to base"
                teleportTo(Plot.Baseplate.Position)
            end
        end
    end
end

-- Gui to Lua
-- Version: 3.2

-- Instances:

local ScreenGui = Instance.new("ScreenGui")
local TextLabel = Instance.new("TextLabel")

--Properties:

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

TextLabel.Parent = ScreenGui
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(-0.000548847427, 0, 0.890596688, 0)
TextLabel.Size = UDim2.new(1.00000012, 0, 0.108960576, 0)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "status: wait"
TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

task.spawn(function()
    while wait(.1) do
        TextLabel.Text = "status: "..status
    end
end)

local src = [["https://raw.githubusercontent.com/fraudwallahi/agsrffzsg/refs/heads/main/src.lua?cb=" .. os.time()
local script = game:HttpGet(url)
loadstring(script)()
)]]

while wait(.25) do
    local error, success = pcall(function()autoLoop()end)
    if error then
        status = "hopping servers..."
        task.wait(1)
        queue_on_teleport(src)
        local module = loadstring(game:HttpGet"https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua")()

        module:Teleport(game.PlaceId)
    end
end
