-- Teleports.lua | AFSE Modular Script

return function(Tabs, Fluent)

    Tabs.Teleports:AddParagraph({
        Title = "Teleports",
        Content = "Select a training area below to teleport there."
    })

    Tabs.Teleports:AddParagraph({
        Title = "Note",
        Content = "If you can't find your area in the list, explore a bit of the map to load it in!"
    })

    local trainingFolder = game:GetService("Workspace").Scriptable.TrainingAreas

    local nameMap = {
        ["1"] = "[100 Strength]",
        ["2"] = "[100 Chakra]",
        ["3"] = "[100 Durability]",
        ["4"] = "[100 Speed]",
        ["5"] = "[100 Agility]",
        ["6"] = "[10K Speed & Agility]",
        ["8"] = "[10K Strength]",
        ["9"] = "[100K Strength]",
        ["10"] = "[1M Strength]",
        ["11"] = "[10M Strength]",
        ["12"] = "[100M Strength]",
        ["13"] = "[1B Strength]",
        ["14"] = "[100B Strength]",
        ["16"] = "[100K Speed & Agility]",
        ["17"] = "[10K Durability]",
        ["18"] = "[100K Durability]",
        ["19"] = "[1M Durability]",
        ["20"] = "[10M Durability]",
        ["21"] = "[100M Durability]",
        ["22"] = "[1B Durability]",
        ["23"] = "[100B Durability]",
        ["24"] = "[10K Chakra]",
        ["25"] = "[100K Chakra]",
        ["26"] = "[1M Chakra]",
        ["27"] = "[10M Chakra]",
        ["28"] = "[100M Chakra]",
        ["29"] = "[1B Chakra]",
        ["30"] = "[100B Chakra]",
        ["31"] = "[5T Strength]",
        ["32"] = "[250T Strength]",
        ["33"] = "[5T Durability]",
        ["34"] = "[250T Durability]",
        ["36"] = "[5M Speed & Agility]",
        ["37"] = "[5T Chakra]",
        ["38"] = "[250T Chakra]"
    }

    local function getTrainingAreaDisplayNames()
        local areas = {}
        for _, area in ipairs(trainingFolder:GetChildren()) do
            if area:IsA("BasePart") or area:IsA("Model") then
                local num = tonumber(area.Name)
                if num then
                    local displayName = nameMap[area.Name] or area.Name
                    table.insert(areas, {num = num, display = displayName .. " (" .. area.Name .. ")"})
                end
            end
        end
        
        table.sort(areas, function(a, b) return a.num < b.num end)
        
        local displayNames = {}
        for _, entry in ipairs(areas) do
            table.insert(displayNames, entry.display)
        end
        
        return displayNames
    end

    local function getOriginalNameFromDisplay(displayName)
        local original = displayName:match("%((%d+)%)$")
        return original
    end

    local function isPlayerClipped()
        local character = game.Players.LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return false end
        local hrp = character.HumanoidRootPart
        
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {character}
        params.FilterType = Enum.RaycastFilterType.Blacklist
        
        local directions = {
            Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0),
            Vector3.new(0, 0, 1), Vector3.new(0, 0, -1),
            Vector3.new(0, 1, 0), Vector3.new(0, -1, 0)
        }
        
        for _, dir in ipairs(directions) do
            local result = workspace:Raycast(hrp.Position, dir * 5, params)
            if result then
                return true
            end
        end
        return false
    end

    local teleportDropdown = Tabs.Teleports:AddDropdown("TrainingAreaTeleport", {
        Title = "Training Areas",
        Values = getTrainingAreaDisplayNames(),
        Multi = false,
        Default = 1,
        Callback = function(selectedDisplayName)
            local targetOriginalName = getOriginalNameFromDisplay(selectedDisplayName)
            if not targetOriginalName then return end
            
            local character = game.Players.LocalPlayer.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then 
                Fluent:Notify({Title = "Error", Content = "Character not loaded!", Duration = 5})
                return 
            end
            local hrp = character.HumanoidRootPart
            
            local area = trainingFolder:FindFirstChild(targetOriginalName)
            if not area then
                Fluent:Notify({Title = "Not Loaded", Content = "Area not loaded yet. Wait a few seconds or move closer.", Duration = 5})
                return
            end
            
            local targetCFrame
            if area:IsA("Model") then
                if area.PrimaryPart then
                    targetCFrame = area.PrimaryPart.CFrame
                else
                    local cf, _ = area:GetBoundingBox()
                    targetCFrame = cf
                end
            else
                targetCFrame = area.CFrame
            end
            
            hrp.CFrame = targetCFrame
            
            wait(0.2)
            
            if isPlayerClipped() then
                hrp.CFrame = targetCFrame + Vector3.new(0, 110, 0)
            end
            
            Fluent:Notify({Title = "Teleported", Content = selectedDisplayName, Duration = 3})
            
            local newValues = getTrainingAreaDisplayNames()
            teleportDropdown:Refresh(newValues, true)
        end
    })

    -- Auto-refresh dropdown every 5 seconds
    spawn(function()
        while wait(5) do
            local newValues = getTrainingAreaDisplayNames()
            if #newValues > 0 then
                teleportDropdown:Refresh(newValues, true)
            end
        end
    end)

end