-- Fruits.lua | AFSE Modular Script

return function(Tabs, Fluent)

    Tabs.Fruits:AddParagraph({
        Title = "Fruits",
        Content = "Toggle Fruit ESP to highlight spawned fruits!\nLive counter + teleport dropdown appears top-left when enabled."
    })

    -- === Fruit Counter GUI with Teleport Dropdown ===
    local ScreenGui = Instance.new("ScreenGui")
    local FruitCounterFrame = Instance.new("Frame")
    local FruitCounterLabel = Instance.new("TextLabel")
    local TeleportButton = Instance.new("TextButton")
    local DropdownFrame = Instance.new("Frame")
    local DropdownList = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")

    ScreenGui.Name = "FruitCounterGUI"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Enabled = false

    FruitCounterFrame.Parent = ScreenGui
    FruitCounterFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    FruitCounterFrame.BackgroundTransparency = 0.3
    FruitCounterFrame.BorderSizePixel = 0
    FruitCounterFrame.Position = UDim2.new(0, 10, 0, 10)
    FruitCounterFrame.Size = UDim2.new(0, 260, 0, 180)
    FruitCounterFrame.Active = true
    FruitCounterFrame.Draggable = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = FruitCounterFrame

    FruitCounterLabel.Parent = FruitCounterFrame
    FruitCounterLabel.BackgroundTransparency = 1
    FruitCounterLabel.Position = UDim2.new(0, 5, 0, 5)
    FruitCounterLabel.Size = UDim2.new(1, -10, 0, 50)
    FruitCounterLabel.Font = Enum.Font.GothamBold
    FruitCounterLabel.Text = "Current Fruits Detected: 0"
    FruitCounterLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    FruitCounterLabel.TextSize = 18
    FruitCounterLabel.TextXAlignment = Enum.TextXAlignment.Left
    FruitCounterLabel.TextYAlignment = Enum.TextYAlignment.Top
    FruitCounterLabel.TextWrapped = true

    TeleportButton.Parent = FruitCounterFrame
    TeleportButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TeleportButton.BorderSizePixel = 0
    TeleportButton.Position = UDim2.new(0, 10, 0, 60)
    TeleportButton.Size = UDim2.new(1, -20, 0, 35)
    TeleportButton.Font = Enum.Font.GothamBold
    TeleportButton.Text = "▼ Teleport to Fruit"
    TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportButton.TextSize = 16

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = TeleportButton

    DropdownFrame.Parent = FruitCounterFrame
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    DropdownFrame.BackgroundTransparency = 0.2
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Position = UDim2.new(0, 10, 0, 100)
    DropdownFrame.Size = UDim2.new(1, -20, 0, 70)
    DropdownFrame.Visible = false

    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = DropdownFrame

    DropdownList.Parent = DropdownFrame
    DropdownList.BackgroundTransparency = 1
    DropdownList.Position = UDim2.new(0, 5, 0, 5)
    DropdownList.Size = UDim2.new(1, -10, 1, -10)
    DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
    DropdownList.ScrollBarThickness = 6

    UIListLayout.Parent = DropdownList
    UIListLayout.Padding = UDim.new(0, 2)

    local dropdownOpen = false

    -- Teleport to selected fruit
    local function teleportToFruit(fruitName)
        local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            Fluent:Notify({Title = "Error", Content = "Character not loaded!", Duration = 5})
            return
        end
        
        local hrp = character.HumanoidRootPart
        local fruitsFolder = workspace:FindFirstChild("Scriptable") and workspace.Scriptable:FindFirstChild("Fruits")
        if not fruitsFolder then
            Fluent:Notify({Title = "Error", Content = "Fruits folder not found!", Duration = 4})
            return
        end
        
        local targetFruit = fruitsFolder:FindFirstChild(fruitName)
        if not targetFruit then
            Fluent:Notify({Title = "Error", Content = "Fruit no longer exists!", Duration = 4})
            updateFruitCounter()
            return
        end
        
        local targetCFrame
        if targetFruit:IsA("Model") then
            if targetFruit.PrimaryPart then
                targetCFrame = targetFruit.PrimaryPart.CFrame
            else
                local cf = targetFruit:GetBoundingBox()
                targetCFrame = cf
            end
        else
            targetCFrame = targetFruit.CFrame
        end
        
        hrp.CFrame = targetCFrame + Vector3.new(0, 8, 0)
        
        Fluent:Notify({
            Title = "Teleported!",
            Content = "Teleported to: " .. fruitName,
            Duration = 3
        })
    end

    -- Update counter, list and dropdown
    local function updateFruitCounter()
        local success, folder = pcall(function()
            return workspace:WaitForChild("Scriptable"):WaitForChild("Fruits")
        end)
        
        if not success or not folder then
            FruitCounterLabel.Text = "Current Fruits Detected: Error"
            TeleportButton.Text = "▼ No Fruits Available"
            TeleportButton.Active = false
            return
        end
        
        local children = folder:GetChildren()
        local fruitCount = #children
        local fruitNames = {}
        
        for _, child in ipairs(children) do
            if child:IsA("Model") or child:IsA("BasePart") then
                table.insert(fruitNames, child.Name)
            end
        end
        
        table.sort(fruitNames)
        
        local listText = #fruitNames > 0 and table.concat(fruitNames, "\n") or "None"
        FruitCounterLabel.Text = "Current Fruits Detected: " .. fruitCount .. "\n\n" .. listText
        
        -- Rebuild dropdown
        for _, gui in ipairs(DropdownList:GetChildren()) do
            if gui:IsA("TextButton") then
                gui:Destroy()
            end
        end
        
        if #fruitNames == 0 then
            TeleportButton.Text = "▼ No Fruits Available"
            TeleportButton.Active = false
        else
            TeleportButton.Text = "▼ Teleport to Fruit (" .. #fruitNames .. ")"
            TeleportButton.Active = true
            
            for _, name in ipairs(fruitNames) do
                local btn = Instance.new("TextButton")
                btn.Parent = DropdownList
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                btn.BorderSizePixel = 0
                btn.Size = UDim2.new(1, 0, 0, 30)
                btn.Font = Enum.Font.Gotham
                btn.Text = name
                btn.TextColor3 = Color3.fromRGB(220, 220, 220)
                btn.TextSize = 15
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 4)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(function()
                    teleportToFruit(name)
                    dropdownOpen = false
                    DropdownFrame.Visible = false
                    TeleportButton.Text = "▼ Teleport to Fruit (" .. #fruitNames .. ")"
                end)
            end
            
            DropdownList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
        end
    end

    -- Dropdown toggle
    TeleportButton.MouseButton1Click:Connect(function()
        if TeleportButton.Active then
            dropdownOpen = not dropdownOpen
            DropdownFrame.Visible = dropdownOpen
            TeleportButton.Text = dropdownOpen and "▲ Teleport to Fruit" or "▼ Teleport to Fruit (" .. #DropdownList:GetChildren() .. ")"
        end
    end)

    -- === Fruit ESP ===
    local CurrentFruitFill = Color3.fromRGB(0, 255, 255)
    local CurrentFruitOutline = Color3.fromRGB(255, 255, 0)
    local fruitHighlights = {}
    local fruitConnection = nil
    local fruitFolderConnection = nil

    local function updateFruitHighlights()
        for _, h in pairs(fruitHighlights) do
            if h and h.Parent then
                h.FillColor = CurrentFruitFill
                h.OutlineColor = CurrentFruitOutline
            end
        end
    end

    Tabs.Fruits:AddColorpicker("FruitFillColor", {
        Title = "Fruit Fill Color",
        Default = CurrentFruitFill,
        Callback = function(c)
            CurrentFruitFill = c
            updateFruitHighlights()
        end
    })

    Tabs.Fruits:AddColorpicker("FruitOutlineColor", {
        Title = "Fruit Outline Color",
        Default = CurrentFruitOutline,
        Callback = function(c)
            CurrentFruitOutline = c
            updateFruitHighlights()
        end
    })

    Tabs.Fruits:AddToggle("FruitESP", {
        Title = "Fruit ESP",
        Description = "Highlights fruits + shows counter & teleport menu",
        Default = false,
        Callback = function(state)
            local folder = workspace:WaitForChild("Scriptable"):WaitForChild("Fruits")
            
            local function addHighlight(obj)
                if not fruitHighlights[obj] and (obj:IsA("Model") or obj:IsA("BasePart")) then
                    local h = Instance.new("Highlight")
                    h.Name = "FruitESP"
                    h.FillColor = CurrentFruitFill
                    h.OutlineColor = CurrentFruitOutline
                    h.FillTransparency = 0.4
                    h.OutlineTransparency = 0
                    if obj:IsA("Model") then
                        h.Adornee = obj
                    end
                    h.Parent = obj
                    fruitHighlights[obj] = h
                    
                    obj.Destroying:Connect(function()
                        fruitHighlights[obj] = nil
                        if ScreenGui.Enabled then updateFruitCounter() end
                    end)
                end
            end
            
            local function clearAllFruitHighlights()
                if fruitConnection then fruitConnection:Disconnect() fruitConnection = nil end
                if fruitFolderConnection then fruitFolderConnection:Disconnect() fruitFolderConnection = nil end
                for _, h in pairs(fruitHighlights) do if h then h:Destroy() end end
                fruitHighlights = {}
            end
            
            if state then
                clearAllFruitHighlights()
                
                for _, obj in ipairs(folder:GetChildren()) do
                    addHighlight(obj)
                end
                
                fruitConnection = folder.ChildAdded:Connect(function(child)
                    addHighlight(child)
                    updateFruitCounter()
                end)
                
                fruitFolderConnection = folder.ChildRemoved:Connect(function()
                    updateFruitCounter()
                end)
                
                ScreenGui.Enabled = true
                updateFruitCounter()
                
                Fluent:Notify({
                    Title = "Fruit ESP",
                    Content = "Enabled - Highlights + teleport menu active!",
                    Duration = 4
                })
                
                spawn(function()
                    while ScreenGui.Enabled do
                        updateFruitCounter()
                        wait(10)
                    end
                end)
            else
                clearAllFruitHighlights()
                ScreenGui.Enabled = false
                DropdownFrame.Visible = false
                
                Fluent:Notify({
                    Title = "Fruit ESP",
                    Content = "Disabled",
                    Duration = 3
                })
            end
        end
    })

end