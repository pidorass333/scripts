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

            if hrp and hum and hum.Health > 0 and port and hrp:IsDescendantOf(workspace) then
                local touchTimeout = 0
                while active and Plr.Character == char and hum and hum.Health > 0 and not char:FindFirstChild("entered") and touchTimeout < 60 do
                    firetouchinterest(hrp, port, 0)
                    firetouchinterest(hrp, port, 1)
                    task.wait(0.05)
                    touchTimeout = touchTimeout + 1
                end

                if active and Plr.Character == char and hum and hum.Health > 0 and char:FindFirstChild("entered") then
                    pcall(function()
                        keypress(0x45)
                        task.wait(0.05)
                        keyrelease(0x45)
                    end)
                    
                    task.wait(0.05)
                    
                    if hum and hum.Health > 0 then
                        pcall(function()
                            hum.Health = 0
                        end)
                    end

                    local lastChar = char
                    local respawnTimeout = 0
                    while active and Plr.Character == lastChar and respawnTimeout < 100 do
                        task.wait(0.05)
                        respawnTimeout = respawnTimeout + 1
                    end
                    task.wait(0.1)
                else
                    task.wait(0.1)
                end
            else
                task.wait(0.2)
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
