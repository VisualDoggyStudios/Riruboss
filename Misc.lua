-- Misc.lua | AFSE Modular Script

return function(Tabs, Fluent)

    Tabs.Misc:AddParagraph({
        Title = "Miscellaneous",
        Content = "Extra useful features."
    })

    local AntiAFKEnabled = false

    Tabs.Misc:AddToggle("AntiAFK", {
        Title = "Anti AFK (new beta)",
        Default = false,
        Callback = function(state)
            AntiAFKEnabled = state
            
            if state then
                spawn(function()
                    local VirtualInputManager = game:GetService("VirtualInputManager")
                    local screenSize = game:GetService("GuiService"):GetScreenResolution()
                    
                    -- Bottom-right corner (slightly inset to avoid edge issues)
                    local clickPosX = screenSize.X - 10
                    local clickPosY = screenSize.Y - 10
                    
                    Fluent:Notify({
                        Title = "Anti AFK",
                        Content = "Enabled - Clicking every 10 minutes",
                        Duration = 5
                    })
                    
                    while AntiAFKEnabled do
                        -- First click
                        VirtualInputManager:SendMouseButtonEvent(clickPosX, clickPosY, 0, true, game, 0)  -- Left button down
                        wait(0.05)
                        VirtualInputManager:SendMouseButtonEvent(clickPosX, clickPosY, 0, false, game, 0) -- Left button up
                        
                        wait(0.1)
                        
                        -- Second click (double-click feel)
                        VirtualInputManager:SendMouseButtonEvent(clickPosX, clickPosY, 0, true, game, 0)
                        wait(0.05)
                        VirtualInputManager:SendMouseButtonEvent(clickPosX, clickPosY, 0, false, game, 0)
                        
                        -- Wait ~10 minutes before next cycle
                        local waited = 0
                        while waited < 600 and AntiAFKEnabled do
                            wait(1)
                            waited = waited + 1
                        end
                    end
                end)
            else
                Fluent:Notify({
                    Title = "Anti AFK",
                    Content = "Disabled",
                    Duration = 3
                })
            end
        end
    })

end