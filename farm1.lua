local Fluent = loadstring(game:HttpGet("https://github.com"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Fluent:CreateWindow({
    Title = "Smart Teleporter",
    SubTitle = "by Dark",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 320),
    Acrylic = true,
    Theme = "Dark"
})

local Tab = Window:AddTab({ Title = "Основное", Icon = "map-pin" })

local TargetInput = Tab:AddInput("Target", {
    Title = "Ник жертвы",
    Default = "",
    Placeholder = "Имя игрока (можно часть)",
    Numeric = false,
    Finished = false
})

local DelayInput = Tab:AddInput("Delay", {
    Title = "Задержка (мс)",
    Default = "500",
    Placeholder = "0",
    Numeric = true,
    Finished = false
})

local Toggle = Tab:AddToggle("State", { Title = "Активация телепорта", Default = false })

local function getTarget()
    local text = string.lower(TargetInput.Value)
    if text == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and string.find(string.lower(p.Name), text) then
            return p
        end
    end
    return nil
end

local function enterArena(char, hrp)
    if char:FindFirstChild("entered") then return true end
    local portal = workspace:FindFirstChild("Lobby") and workspace.Lobby:FindFirstChild("Teleport1")
    if not portal then return false end
    pcall(function()
        firetouchinterest(hrp, portal, 0)
        firetouchinterest(hrp, portal, 1)
    end)
    task.wait(0.05)
    return char:FindFirstChild("entered") ~= nil
end

local rainbowThread = task.spawn(function()
    local hue = 0
    while task.wait(0.03) do
        hue = (hue + 1) % 360
        Window.DialogHolder.BackgroundColor3 = Color3.fromHSV(hue / 360, 0.7, 0.6)
    end
end)

local mainThread = task.spawn(function()
    while true do
        task.wait(0.05)
        if Toggle.Value then
            local target = getTarget()
            local myChar = LocalPlayer.Character
            local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and myHrp then
                local targetHrp = target.Character.HumanoidRootPart
                local ms = tonumber(DelayInput.Value) or 0
                if ms > 0 then task.wait(ms / 1000) end
                if Toggle.Value and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    if enterArena(myChar, myHrp) and Toggle.Value then
                        pcall(function()
                            local frontPos = targetHrp.CFrame * CFrame.new(0, 0, -3)
                            myHrp.CFrame = CFrame.new(frontPos.Position, targetHrp.Position)
                        end)
                        task.wait(0.3)
                    end
                end
            end
        end
    end
end)

Window:OnClose(function()
    Toggle:SetValue(false)
    if rainbowThread then task.cancel(rainbowThread) end
    if mainThread then task.cancel(mainThread) end
    Fluent:Destroy()
end)

Window:SelectTab(1)
