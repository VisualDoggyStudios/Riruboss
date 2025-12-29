-- Autofarm.lua | AFSE Modular Script

return function(Tabs, Fluent)

    Tabs.Autofarm:AddParagraph({
        Title = "Autofarm Features",
        Content = "Toggle the features below to enable or disable automatic actions."
    })

    -- Auto Train Strength
    local TrainEnabled = false
    Tabs.Autofarm:AddToggle("AutoTrain", {
        Title = "Auto Train Strength",
        Default = false,
        Callback = function(state)
            TrainEnabled = state
            if state then
                spawn(function()
                    while TrainEnabled do
                        game:GetService("ReplicatedStorage").Remotes.RemoteEvent:FireServer("Train", 1)
                        wait(0.1)
                    end
                end)
            end
        end
    })

    -- Auto Farm Durability
    local DurabilityEnabled = false
    Tabs.Autofarm:AddToggle("AutoDurability", {
        Title = "Auto Farm Durability",
        Default = false,
        Callback = function(state)
            DurabilityEnabled = state
            if state then
                spawn(function()
                    while DurabilityEnabled do
                        game:GetService("ReplicatedStorage").Remotes.RemoteEvent:FireServer("Train", 2)
                        wait(0.1)
                    end
                end)
            end
        end
    })

    -- Auto Farm Chakra
    local ChakraEnabled = false
    Tabs.Autofarm:AddToggle("AutoChakra", {
        Title = "Auto Farm Chakra",
        Default = false,
        Callback = function(state)
            ChakraEnabled = state
            if state then
                spawn(function()
                    while ChakraEnabled do
                        game:GetService("ReplicatedStorage").Remotes.RemoteEvent:FireServer("Train", 3)
                        wait(0.1)
                    end
                end)
            end
        end
    })

    -- Auto Farm Sword
    local SwordEnabled = false
    Tabs.Autofarm:AddToggle("AutoSword", {
        Title = "Auto Farm Sword",
        Default = false,
        Callback = function(state)
            SwordEnabled = state
            if state then
                -- Activate sword once
                local args = {"ActivateSword"}
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
                
                spawn(function()
                    while SwordEnabled do
                        game:GetService("ReplicatedStorage").Remotes.RemoteEvent:FireServer("Train", 4)
                        wait(0.1)
                    end
                end)
            end
        end
    })

    -- Auto Farm Speed & Agility
    local SpeedAgilityEnabled = false
    Tabs.Autofarm:AddToggle("AutoSpeedAgility", {
        Title = "Auto Farm Speed & Agility",
        Default = false,
        Callback = function(state)
            SpeedAgilityEnabled = state
            if state then
                spawn(function()
                    while SpeedAgilityEnabled do
                        game:GetService("ReplicatedStorage").Remotes.RemoteEvent:FireServer("Train", 5)
                        wait(0.1)
                        game:GetService("ReplicatedStorage").Remotes.RemoteEvent:FireServer("Train", 6)
                        wait(0.1)
                    end
                end)
            end
        end
    })

end