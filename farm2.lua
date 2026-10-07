local Plr = game:GetService("Players").LocalPlayer
local Gui = Instance.new("ScreenGui", gethui and gethui() or Plr:WaitForChild("PlayerGui"))
local Btn = Instance.new("TextButton", Gui)
Btn.Size, Btn.Position = UDim2.new(0, 180, 0, 45), UDim2.new(0.5, -90, 0.1, 0)
Btn.Text, Btn.BackgroundColor3 = "коч", Color3.fromRGB(255, 0, 0)
local active = false

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
                
                local timeout = 0
                while active and not char:FindFirstChild("entered") and hum.Health > 0 and timeout < 50 do
                    task.wait(0.01)
                    timeout = timeout + 1
                end
                
                if char:FindFirstChild("entered") and hum.Health > 0 then
                    pcall(function()
                        keypress(0x45)
                        task.wait(0.05)
                        keyrelease(0x45)
                    end)
                    
                    task.wait(0.02)
                    hum.Health = 0
                    
                    local lastChar = char
                    while active and Plr.Character == lastChar do
                        task.wait(0.02)
                    end
                    task.wait(0.05)
                end
            else
                task.wait()
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

