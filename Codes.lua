-- Codes.lua | AFSE - Simple Redeem All Button

return function(Tabs, Fluent)

    local codeList = {
        "YenCode",
        "FreeChikara",
        "FreeChikara2",
        "FreeChikara3",
        "BugFixes1",
        "10Favs",
        "10Likes",
        "LASTFIX",
        "Update1Point1",
        "SorryForBugsLol",
        "1kVisits",
        "50Likes",
        "1000Members",
        "MobsUpdate",
        "1WeekAnniversary",
        "400CCU",
        "10kVisits",
        "100Favs",
        "100CCU",
        "Gullible67",
        "ChristmasDelay",
        "Krampus",
        "1MVisits",
        "10kLikes",
        "ChristmasTime"
        -- Add new codes here!
    }

    Tabs.Codes:AddButton({
        Title = "Redeem All Codes",
        Description = "Redeems every code in the list (0.3s delay)",
        Callback = function()
            local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteFunction")
            
            local successCount = 0
            local failCount = 0

            for _, code in ipairs(codeList) do
                local args = { "Code", code }
                local success, result = pcall(function()
                    return remote:InvokeServer(unpack(args))
                end)

                if success and result ~= false then
                    successCount = successCount + 1
                    Fluent:Notify({
                        Title = "Success",
                        Content = "Redeemed: " .. code,
                        Duration = 2
                    })
                else
                    failCount = failCount + 1
                    Fluent:Notify({
                        Title = "Failed",
                        Content = "Invalid/Used: " .. code,
                        Duration = 2
                    })
                end

                wait(0.3)
            end

            Fluent:Notify({
                Title = "All Codes Processed",
                Content = "Success: " .. successCount .. "\nFailed/Used: " .. failCount,
                Duration = 10
            })
        end
    })

end