local Plr = game:GetService("Players").LocalPlayer
local Gui = Instance.new("ScreenGui", gethui and gethui() or Plr:WaitForChild("PlayerGui"))

local Btn = Instance.new("TextButton", Gui)
Btn.Size, Btn.Position = UDim2.new(0, 180, 0, 45), UDim2.new(0.5, -90, 0.1, 0)
Btn.Text, Btn.BackgroundColor3 = "коч", Color3.fromRGB(255, 0, 0)

local active = false

local function triggerAbilityDirect()
    local ServerAbility = game:GetService("ReplicatedStorage"):FindFirstChild("ServerAbility")
    if ServerAbility and ServerAbility:IsA("RemoteEvent") then
        ServerAbility:FireServer()
        return true
    end
    
    local rEvents = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents")
    if rEvents then
        local abilityEvent = rEvents:FindFirstChild("Ability") or rEvents:FindFirstChild("ActivateAbility")
        if abilityEvent and abilityEvent:IsA("RemoteEvent") then
            abilityEvent:FireServer()
            return true
        end
    end
    
    return false
end

task.spawn(function()
    while true do
        if active then
            local char = Plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local port = workspace:FindFirstChild("Lobby") and workspace.Lobby:FindFirstChild("Teleport1")

            if hrp and hum and hum.Health > 0 and port then
                while active and not char:FindFirstChild("entered") and hum.Health > 0 do
                    firetouchinterest(hrp, port, 0)
                    firetouchinterest(hrp, port, 1)
                    task.wait(0.02)
                end

                if active and char:FindFirstChild("entered") and hum.Health > 0 then
                    local success = triggerAbilityDirect()
                    if not success then
                        game:GetService("VirtualInputService"):PressButton(Enum.KeyCode.E)
                        task.wait(0.01)
                        game:GetService("VirtualInputService"):ReleaseButton(Enum.KeyCode.E)
                    end
                    
                    hum.Health = 0
                    
                    while active and Plr.Character == char and hum.Health <= 0 do
                        task.wait(0.1)
                    end
                end
            else
                task.wait(0.1)
            end
        else
            task.wait(0.2)
        end
    end
end)

Btn.MouseButton1Click:Connect(function()
    active = not active
    Btn.Text = active and "коч коч" or "коч"
    Btn.BackgroundColor3 = active and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)
