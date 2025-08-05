-- King Legacy Auto Farm Level (Mobile Simple) - by Bụng Béo
repeat task.wait() until game:IsLoaded()
local plr = game.Players.LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local rs = game:GetService("ReplicatedStorage")
local vn = require(rs:WaitForChild("Framework"):WaitForChild("Library"):WaitForChild("VirtualInput"))

-- CONFIG
local weapon = "Combat" -- Đổi thành tên vũ khí bạn dùng: "Combat", "Longsword", "Dragon Claw",...

-- HÀM TÌM NPC NHIỆM VỤ GẦN NHẤT
function getQuestNPC()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ClickDetector") and v.Parent:FindFirstChild("Head") then
            return v
        end
    end
end

-- HÀM NHẬN NHIỆM VỤ
function takeQuest()
    local npc = getQuestNPC()
    if npc then
        fireclickdetector(npc)
        task.wait(0.5)
        vn:ClickButton1(Vector2.new(0, 0))
    end
end

-- HÀM TÌM QUÁI GẦN NHẤT
function getNearestMob()
    local mobs = workspace.Mobs:GetChildren()
    local nearest, dist = nil, math.huge
    for _, mob in pairs(mobs) do
        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            local d = (mob.HumanoidRootPart.Position - chr.HumanoidRootPart.Position).Magnitude
            if d < dist then
                nearest, dist = mob, d
            end
        end
    end
    return nearest
end

-- HÀM TẤN CÔNG
function attack()
    if weapon and chr:FindFirstChild(weapon) then
        local args = {
            [1] = {
                ["Humanoid"] = true,
                ["Weapon"] = weapon
            }
        }
        rs.Remotes.Combat:FireServer(unpack(args))
    end
end

-- MAIN LOOP
while task.wait() do
    pcall(function()
        if not plr.PlayerGui:FindFirstChild("QuestGUI") then
            takeQuest()
        else
            local mob = getNearestMob()
            if mob then
                chr.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                attack()
            end
        end
    end)
end
