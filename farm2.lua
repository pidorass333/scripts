local Plr = game:GetService("Players").LocalPlayer
local Gui = Instance.new("ScreenGui", gethui and gethui() or Plr:WaitForChild("PlayerGui"))
local Btn = Instance.new("TextButton", Gui)

Btn.Size, Btn.Position = UDim2.new(0, 180, 0, 45), UDim2.new(0.5, -90, 0.1, 0)
Btn.Text, Btn.BackgroundColor3 = "коч", Color3.fromRGB(255, 0, 0)

local active = false

if setfpscap then setfpscap(60) end 

task.spawn(function()
    while true do
        if active then
            local char = Plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local port = workspace:FindFirstChild("Lobby") and workspace.Lobby:FindFirstChild("Teleport1")

            if hrp and hum and hum.Health > 0 and port then
                while active and char and char:FindFirstChild("HumanoidRootPart") and not char:FindFirstChild("entered") and hum.Health > 0 do
                    firetouchinterest(hrp, port, 0)
                    task.wait()
                    firetouchinterest(hrp, port, 1)
                    task.wait(0.02)
                end

                if active and char and char:FindFirstChild("entered") then
                    task.wait(0.1)
                    
                    pcall(function()
                        if keypress and keyrelease then
                            keypress(0x45)
                            task.wait(0.05)
                            keyrelease(0x45)
                        else
                            local VIS = game:GetService("VirtualInputService")
                            VIS:PressButton(Enum.KeyCode.E)
                            task.wait(0.05)
                            VIS:ReleaseButton(Enum.KeyCode.E)
                        end
                    end)
                    
                    task.wait(0.1)
                    
                    if hum and hum.Health > 0 then
                        hum.Health = 0
                    end
                    
                    local currentCharacter = Plr.Character
                    while Plr.Character == currentCharacter or not Plr.Character or not Plr.Character:FindFirstChild("HumanoidRootPart") do
                        task.wait(0.1)
                    end
                end
            else
                task.wait(0.1)
            end
        else
            task.wait(0.3)
        end
    end
end)

Btn.MouseButton1Click:Connect(function()
    active = not active
    Btn.Text = active and "коч коч" or "коч"
    Btn.BackgroundColor3 = active and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)
