```lua
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("DarkRainbowTeleporter") then
    CoreGui.DarkRainbowTeleporter:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "коч братан ультра крутой телепортер"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 330, 0, 340)
MainFrame.Position = UDim2.new(0.5, -165, 0.4, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2.5
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0.8, 1)),
    ColorSequenceKeypoint.new(0.2, Color3.fromHSV(0.2, 0.8, 1)),
    ColorSequenceKeypoint.new(0.4, Color3.fromHSV(0.4, 0.8, 1)),
    ColorSequenceKeypoint.new(0.6, Color3.fromHSV(0.6, 0.8, 1)),
    ColorSequenceKeypoint.new(0.8, Color3.fromHSV(0.8, 0.8, 1)),
    ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 0.8, 1))
})
UIGradient.Parent = UIStroke

RunService.RenderStepped:Connect(function()
    UIGradient.Offset = Vector2.new((tick() * 0.4) % 1, 0)
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 0, 40)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "коч коч"
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 25)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 90, 100)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Thickness = 1
CloseStroke.Color = Color3.fromRGB(70, 30, 35)
CloseStroke.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 6)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 205)
MinimizeBtn.TextSize = 12
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = MainFrame

Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

local MinStroke = Instance.new("UIStroke")
MinStroke.Thickness = 1
MinStroke.Color = Color3.fromRGB(50, 50, 55)
MinStroke.Parent = MinimizeBtn

local minimized = false
local originalSize = MainFrame.Size

MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized

    if minimized then
        MainFrame:TweenSize(
            UDim2.new(0, 330, 0, 40),
            "Out",
            "Quad",
            0.2,
            true
        )

        for _, child in ipairs(MainFrame:GetChildren()) do
            if child ~= Title
                and child ~= CloseBtn
                and child ~= MinimizeBtn
                and child:IsA("GuiObject") then
                child.Visible = false
            end
        end
    else
        MainFrame:TweenSize(originalSize, "Out", "Quad", 0.2, true)

        for _, child in ipairs(MainFrame:GetChildren()) do
            if child ~= Title
                and child ~= CloseBtn
                and child ~= MinimizeBtn
                and child:IsA("GuiObject") then
                child.Visible = true
            end
        end
    end
end)

local TargetInput = Instance.new("TextBox")
TargetInput.Size = UDim2.new(1, -24, 0, 36)
TargetInput.Position = UDim2.new(0, 12, 0, 55)
TargetInput.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
TargetInput.Text = ""
TargetInput.PlaceholderText = "Имя жертвы (частично)"
TargetInput.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetInput.TextSize = 14
TargetInput.Font = Enum.Font.Gotham
TargetInput.Parent = MainFrame

Instance.new("UICorner", TargetInput).CornerRadius = UDim.new(0, 6)

local TargetStroke = Instance.new("UIStroke")
TargetStroke.Thickness = 1
TargetStroke.Color = Color3.fromRGB(45, 45, 55)
TargetStroke.Parent = TargetInput

local DelayInput = Instance.new("TextBox")
DelayInput.Size = UDim2.new(1, -24, 0, 36)
DelayInput.Position = UDim2.new(0, 12, 0, 105)
DelayInput.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
DelayInput.Text = "500"
DelayInput.PlaceholderText = "Задержка перед ТП (мс)"
DelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayInput.TextSize = 14
DelayInput.Font = Enum.Font.Gotham
DelayInput.Parent = MainFrame

Instance.new("UICorner", DelayInput).CornerRadius = UDim.new(0, 6)

local DelayStroke = Instance.new("UIStroke")
DelayStroke.Thickness = 1
DelayStroke.Color = Color3.fromRGB(45, 45, 55)
DelayStroke.Parent = DelayInput

local ResetInput = Instance.new("TextBox")
ResetInput.Size = UDim2.new(1, -24, 0, 36)
ResetInput.Position = UDim2.new(0, 12, 0, 155)
ResetInput.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
ResetInput.Text = "1000"
ResetInput.PlaceholderText = "Время до ресета после ТП в милисекундах)"
ResetInput.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetInput.TextSize = 14
ResetInput.Font = Enum.Font.Gotham
ResetInput.Parent = MainFrame

Instance.new("UICorner", ResetInput).CornerRadius = UDim.new(0, 6)

local ResetStroke = Instance.new("UIStroke")
ResetStroke.Thickness = 1
ResetStroke.Color = Color3.fromRGB(45, 45, 55)
ResetStroke.Parent = ResetInput

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -24, 0, 25)
StatusLabel.Position = UDim2.new(0, 12, 0, 205)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Статус: Остановлен"
StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.GothamItalic
StatusLabel.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, -24, 0, 45)
ToggleBtn.Position = UDim2.new(0, 12, 0, 245)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 45, 30)
ToggleBtn.Text = "СТАРТ"
ToggleBtn.TextColor3 = Color3.fromRGB(120, 255, 140)
ToggleBtn.TextSize = 16
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = MainFrame

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 1
ToggleStroke.Color = Color3.fromRGB(40, 75, 45)
ToggleStroke.Parent = ToggleBtn

local isRunning = false

local function findTargetPlayer(namePart)
    if namePart == "" then
        return nil
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer
            and string.find(
                string.lower(player.Name),
                string.lower(namePart)
            ) then
            return player
        end
    end

    return nil
end

local function enterArena()
    local character = LocalPlayer.Character

    if not character
        or not character:FindFirstChild("HumanoidRootPart") then
        return false, false
    end

    if character:FindFirstChild("entered") then
        return true, true
    end

    StatusLabel.Text = "Статус: Вход на арену..."

    pcall(function()
        firetouchinterest(
            character.HumanoidRootPart,
            workspace.Lobby.Teleport1,
            0
        )

        firetouchinterest(
            character.HumanoidRootPart,
            workspace.Lobby.Teleport1,
            1
        )
    end)

    if character:FindFirstChild("entered") then
        return true, true
    end

    return true, false
end

task.spawn(function()
    while true do
        task.wait(0.05)

        if isRunning then
            local target = findTargetPlayer(TargetInput.Text)

            if not target then
                StatusLabel.Text = "Статус: жертва не найдена"
                ToggleBtn.Text = "СТАРТ"
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 45, 30)
                ToggleBtn.TextColor3 = Color3.fromRGB(120, 255, 140)
                ToggleStroke.Color = Color3.fromRGB(40, 75, 45)
                isRunning = false
            else
                local hasHrp, alreadyEntered = enterArena()

                if hasHrp
                    and target.Character
                    and target.Character:FindFirstChild("HumanoidRootPart") then

                    if not alreadyEntered then
                        local enteredTimeout = tick()

                        repeat
                            task.wait()
                        until (
                            LocalPlayer.Character
                            and LocalPlayer.Character:FindFirstChild("entered")
                        ) or (tick() - enteredTimeout > 2)
                    end

                    if LocalPlayer.Character
                        and LocalPlayer.Character:FindFirstChild("entered") then

                        if not alreadyEntered then
                            StatusLabel.Text =
                                "Статус: ТП"
                        else
                            StatusLabel.Text =
                                "Статус: Ожидание ТП к " .. target.Name

                            local ms = tonumber(DelayInput.Text) or 0

                            if ms > 0 then
                                task.wait(ms / 1000)
                            end
                        end

                        if not isRunning then
                            break
                        end

                        local tpSuccess = false

                        pcall(function()
                            local myHrp = LocalPlayer.Character
                                and LocalPlayer.Character:FindFirstChild(
                                    "HumanoidRootPart"
                                )

                            local targetHrp =
                                target.Character:FindFirstChild(
                                    "HumanoidRootPart"
                                )

                            if myHrp and targetHrp then
                                local frontPosition =
                                    targetHrp.CFrame * CFrame.new(0, 0, -3)

                                myHrp.CFrame = CFrame.new(
                                    frontPosition.Position,
                                    targetHrp.Position
                                )

                                StatusLabel.Text = "Статус: Телепортирован"
                                tpSuccess = true
                            end
                        end)

                        if tpSuccess then
                            local resetMs = tonumber(ResetInput.Text) or 0

                            if resetMs > 0 then
                                task.wait(resetMs / 1000)
                            end

                            pcall(function()
                                if LocalPlayer.Character
                                    and LocalPlayer.Character:FindFirstChild(
                                        "Humanoid"
                                    ) then

                                    LocalPlayer.Character.Humanoid.Health = 0
                                    StatusLabel.Text = "Статус: Ресет выполнен"
                                end
                            end)
                        end

                        task.wait(0.5)
                    else
                        StatusLabel.Text = "Статус: Ошибка входа"
                    end
                else
                    StatusLabel.Text =
                        "Статус: жертва мертва или не на арене"
                end
            end
        end
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning

    if isRunning then
        ToggleBtn.Text = "СТОП"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 25)
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
        ToggleStroke.Color = Color3.fromRGB(75, 40, 40)
        StatusLabel.Text = "Статус: Запуск..."
    else
        ToggleBtn.Text = "СТАРТ"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 45, 30)
        ToggleBtn.TextColor3 = Color3.fromRGB(120, 255, 140)
        ToggleStroke.Color = Color3.fromRGB(40, 75, 45)
        StatusLabel.Text = "Статус: Остановлен"
    end
end)
```
