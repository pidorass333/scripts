local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield-gen2'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "Smart Teleporter Gen2",
    LoadingTitle = "Загрузка Gen2...",
    LoadingSubtitle = "by Dark",
    Theme = "Dark",
    SecureMode = true -- Скрытие UI от встроенных проверок игры
})

local Tab = Window:CreateTab({
    Name = "Основное",
    Icon = "rbxassetid://4483345998"
})

local isRunning = false
local targetName = ""
local delayMs = 500

local TargetInput = Tab:CreateInput({
    Name = "Ник жертвы",
    PlaceholderText = "Имя игрока (можно часть)",
    Callback = function(Text)
        targetName = Text
    end,
})

local DelayInput = Tab:CreateInput({
    Name = "Задержка (мс)",
    PlaceholderText = "500",
    Callback = function(Text)
        delayMs = tonumber(Text) or 0
    end,
})

local Toggle = Tab:CreateToggle({
    Name = "Активация телепорта",
    CurrentValue = false,
    Callback = function(Value)
        isRunning = Value
    end,
})

local function getTarget()
    if targetName == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and string.find(string.lower(p.Name), string.lower(targetName)) then
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
        -- Динамическое обновление цвета темы в рантайме Gen2
        pcall(function()
            if Window and Window.Elements and Window.Elements.Main then
                Window.Elements.Main.BackgroundColor3 = Color3.fromHSV(hue / 360, 0.7, 0.5)
            end
         pcall)
    end
end)

local mainThread = task.spawn(function()
    while true do
        task.wait(0.05)
        if isRunning then
            local target = getTarget()
            local myChar = LocalPlayer.Character
            local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and myHrp then
                local targetHrp = target.Character.HumanoidRootPart
                if delayMs > 0 then task.wait(delayMs / 1000) end
                if isRunning and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    if enterArena(myChar, myHrp) and isRunning then
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

-- Выгрузка потоков Gen2 при удалении интерфейса из CoreGui
game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child.Name == "Rayfield" or child.Name == "RayfieldGen2" or child:FindFirstChild("Main") then
        isRunning = false
        if rainbowThread then task.cancel(rainbowThread) end
        if mainThread then task.cancel(mainThread) end
    end
end)
