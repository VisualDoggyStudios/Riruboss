-- Mobs.lua | AFSE Modular Script

return function(Tabs, Fluent)

    Tabs.Mobs:AddParagraph({
        Title = "Important Note",
        Content = "The desired mobs must be loaded/spawned in the world for the auto-farm to detect and target them."
    })

    local autoFarmSarkaEnabled = false
    local autoFarmGenEnabled = false
    local autoFarmIgichoEnabled = false
    local autoFarmBoohEnabled = false
    local autoFarmRemgonukEnabled = false
    local autoFarmSaytamuEnabled = false
    local autoAttackEnabled = false

    -- Enable auto-attack remote once (shared across all mob farms)
    local function enableAutoAttack()
        if autoAttackEnabled then return end
        local args = {"Setting", 10}
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
        end)
        autoAttackEnabled = true
    end

    -- Check if any mob farm is active (to disable auto-attack when all are off)
    local function checkAnyMobFarmActive()
        return autoFarmSarkaEnabled or autoFarmGenEnabled or autoFarmIgichoEnabled 
            or autoFarmBoohEnabled or autoFarmRemgonukEnabled or autoFarmSaytamuEnabled
    end

    -- Generic mob auto-farm function
    local function createMobAutoFarm(mobName, toggleVarName, title)
        Tabs.Mobs:AddToggle(toggleVarName, {
            Title = title,
            Default = false,
            Callback = function(state)
                _G[toggleVarName] = state

                if state then
                    enableAutoAttack()
                    spawn(function()
                        while _G[toggleVarName] do
                            local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                            local hrp = character:WaitForChild("HumanoidRootPart")
                            local mobFolder = workspace.Scriptable.Mobs
                            local closestMob = nil
                            local closestDist = math.huge

                            for _, mob in ipairs(mobFolder:GetChildren()) do
                                if mob.Name == mobName and mob:FindFirstChild("HumanoidRootPart") then
                                    local mobRoot = mob:FindFirstChild("HumanoidRootPart")
                                    local dist = (hrp.Position - mobRoot.Position).Magnitude
                                    if dist < closestDist then
                                        closestDist = dist
                                        closestMob = mob
                                    end
                                end
                            end

                            if closestMob and closestMob:FindFirstChild("HumanoidRootPart") then
                                hrp.CFrame = closestMob.HumanoidRootPart.CFrame
                            end

                            wait(0.1)
                        end
                    end)
                    
                    Fluent:Notify({
                        Title = "Mob Farm",
                        Content = title .. " enabled!",
                        Duration = 3
                    })
                else
                    if not checkAnyMobFarmActive() then
                        autoAttackEnabled = false
                    end
                    
                    Fluent:Notify({
                        Title = "Mob Farm",
                        Content = title .. " disabled",
                        Duration = 3
                    })
                end
            end
        })
    end

    -- Create toggles for each mob
    createMobAutoFarm("1", "AutoFarmSarka", "Auto Farm Sarka")
    createMobAutoFarm("2", "AutoFarmGen", "Auto Farm Gen")
    createMobAutoFarm("3", "AutoFarmIgicho", "Auto Farm Igicho")
    createMobAutoFarm("5", "AutoFarmBooh", "Auto Farm Booh")
    createMobAutoFarm("7", "AutoFarmRemgonuk", "Auto Farm Remgonuk")
    createMobAutoFarm("6", "AutoFarmSaytamu", "Auto Farm Saytamu")

end