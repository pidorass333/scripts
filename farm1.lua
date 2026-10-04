local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("DarkSmartTeleporter") then
    CoreGui.DarkSmartTeleporter:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DarkSmartTeleporter"
ScreenGui.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 260, 0, 190)
Main.Position = UDim2.new(0.5, -130, 0.4, -95)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Stroke.Parent = Main

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 25, 0, 25)
Close.Position = UDim2.new(1, -30, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(50, 25, 25)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 100, 100)
Close.Font = Enum.Font.SourceSansBold
Close.TextSize = 14
Close.Parent = Main
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)

local Target = Instance.new("TextBox")
Target.Size = UDim2.new(1, -20, 0, 30)
Target.Position = UDim2.new(0, 10, 0, 40)
Target.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Target.PlaceholderText = "Ник жертвы (часть)"
Target.Text = ""
Target.TextColor3 = Color3.fromRGB(255, 255, 255)
Target.Font = Enum.Font.SourceSans
Target.TextSize = 14
Target.Parent = Main
Instance.new("UICorner", Target).CornerRadius = UDim.new(0, 5)

local DelayBox = Instance.new("TextBox")
DelayBox.Size = UDim2.new(1, -20, 0, 30)
DelayBox.Position = UDim2.new(0, 10, 0, 80)
DelayBox.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
DelayBox.PlaceholderText = "Задержка (мс)"
DelayBox.Text = "500"
DelayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayBox.Font = Enum.Font.SourceSans
DelayBox.TextSize = 14
DelayBox.Parent = Main
Instance.new("UICorner", DelayBox).CornerRadius = UDim.new(0, 5)

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(1, -20, 0, 40)
Toggle.Position = UDim2.new(0, 10, 0, 130)
Toggle.BackgroundColor3 = Color3.fromRGB(35, 60, 35)
Toggle.Text = "СТАРТ"
Toggle.TextColor3 = Color3.fromRGB(100, 255, 100)
Toggle.Font = Enum.Font.SourceSansBold
Toggle.TextSize = 16
Toggle.Parent = Main
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 6)

local isRunning = false

local function getTarget()
    local text = string.lower(Target.Text)
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

Toggle.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    Toggle.Text = isRunning and "СТОП" or "СТАРТ"
    Toggle.TextColor3 = isRunning and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100)
    Toggle.BackgroundColor3 = isRunning and Color3.fromRGB(60, 35, 35) or Color3.fromRGB(35, 60, 35)
end)

local rainbowThread = task.spawn(function()
    local hue = 0
    while task.wait(0.03) do
        hue = (hue + 1) % 360
        Stroke.Color = Color3.fromHSV(hue / 360, 0.7, 0.6)
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
                local ms = tonumber(DelayBox.Text) or 0
                if ms > 0 then task.wait(ms / 1000) end
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

Close.MouseButton1Click:Connect(function()
    isRunning = false
    if rainbowThread then task.cancel(rainbowThread) end
    if mainThread then task.cancel(mainThread) end
    ScreenGui:Destroy()
end)
