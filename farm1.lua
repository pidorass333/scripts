local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("DarkRainbowTeleporter") then
    CoreGui.DarkRainbowTeleporter:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DarkRainbowTeleporter"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 260)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

task.spawn(function()
    local hue = 0
    while true do
        hue = (hue + 1) % 360
        UIStroke.Color = Color3.fromHSV(hue / 360, 0.7, 0.5)
        task.wait(0.05)
    end
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Dark Slap Teleporter"
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 15)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.TextSize = 14
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.Parent = MainFrame
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

local minimized = false
local originalSize = MainFrame.Size
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame:TweenSize(UDim2.new(0, 320, 0, 40), "Out", "Quad", 0.2, true)
        for _, child in ipairs(MainFrame:GetChildren()) do
            if child ~= Title and child ~= CloseBtn and child ~= MinimizeBtn and child:IsA("GuiObject") then
                child.Visible = false
            end
        end
    else
        MainFrame:TweenSize(originalSize, "Out", "Quad", 0.2, true)
        for _, child in ipairs(MainFrame:GetChildren()) do
            if child ~= Title and child ~= CloseBtn and child ~= MinimizeBtn and child:IsA("GuiObject") then
                child.Visible = true
            end
        end
    end
end)

local TargetInput = Instance.new("TextBox")
TargetInput.Size = UDim2.new(1, -20, 0, 35)
TargetInput.Position = UDim2.new(0, 10, 0, 50)
TargetInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
TargetInput.Text = ""
TargetInput.PlaceholderText = "имя жертвы (можно часть имени)"
TargetInput.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetInput.TextSize = 14
TargetInput.Font = Enum.Font.SourceSans
TargetInput.Parent = MainFrame
Instance.new("UICorner", TargetInput).CornerRadius = UDim.new(0, 4)

local DelayInput = Instance.new("TextBox")
DelayInput.Size = UDim2.new(1, -20, 0, 35)
DelayInput.Position = UDim2.new(0, 10, 0, 95)
DelayInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
DelayInput.Text = "500"
DelayInput.PlaceholderText = "задержка перед тп в милисекундах)"
DelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayInput.TextSize = 14
DelayInput.Font = Enum.Font.SourceSans
DelayInput.Parent = MainFrame
Instance.new("UICorner", DelayInput).CornerRadius = UDim.new(0, 4)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 25)
StatusLabel.Position = UDim2.new(0, 10, 0, 140)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Статус: Остановлен"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.SourceSansItalic
StatusLabel.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, -20, 0, 45)
ToggleBtn.Position = UDim2.new(0, 10, 0, 175)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 60, 35)
ToggleBtn.Text = "СТАРТ"
ToggleBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
ToggleBtn.TextSize = 18
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Parent = MainFrame
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

local isRunning = false

local function findTargetPlayer(namePart)
    if namePart == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and string.find(string.lower(p.Name), string.lower(namePart)) then
            return p
        end
    end
    return nil
end

local function enterArena()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    
    if char:FindFirstChild("entered") == nil then
        StatusLabel.Text = "Статус: Вход на арену..."
        local timeout = tick()
        repeat
            task.wait(0.1)
            pcall(function()
                firetouchinterest(char.HumanoidRootPart, workspace.Lobby.Teleport1, 0)
                firetouchinterest(char.HumanoidRootPart, workspace.Lobby.Teleport1, 1)
            end)
            if tick() - timeout > 5 then return false end
        until char:FindFirstChild("entered")
    end
    return true
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if isRunning then
            local target = findTargetPlayer(TargetInput.Text)
            
            if not target then
                StatusLabel.Text = "Статус: жертва не найдена"
                ToggleBtn.Text = "СТАРТ"
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 60, 35)
                ToggleBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
                isRunning = false
            else
                local ready = enterArena()
                
                if ready and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    StatusLabel.Text = "Статус: ожидание тп к " .. target.Name
                    
                    local ms = tonumber(DelayInput.Text) or 0
                    if ms > 0 then
                        task.wait(ms / 1000)
                    end
                    
                    if not isRunning then break end
                    
                    pcall(function()
                        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
                        
                        if myHrp and targetHrp then
                            local frontPosition = targetHrp.CFrame * CFrame.new(0, 0, -3)
                            myHrp.CFrame = CFrame.new(frontPosition.Position, targetHrp.Position)
                            StatusLabel.Text = "Статус: Телепортирован"
                        end
                    end)
                    
                    task.wait(0.5) 
                else
                    StatusLabel.Text = "Статус: жертва мертва или не на арене"
                end
            end
        end
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        ToggleBtn.Text = "СТОП"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 35, 35)
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        StatusLabel.Text = "Статус: Запуск..."
    else
        ToggleBtn.Text = "СТАРТ"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 60, 35)
        ToggleBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
        StatusLabel.Text = "Статус: Остановлен"
    end
end)
