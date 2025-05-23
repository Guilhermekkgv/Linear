local TweenService = game:GetService("TweenService")
local InputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local Linux = {}

function Linux.Instance(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    return inst
end

function Linux:SafeCallback(Function, ...)
    if not Function then
        return
    end
    local Success, Error = pcall(Function, ...)
    if not Success then
        self:Notify({
            Title = "Callback Error",
            Content = tostring(Error),
            Duration = 5
        })
    end
end

function Linux:Notify(config)
    local isMobile = InputService.TouchEnabled and not InputService.KeyboardEnabled
    local notificationWidth = isMobile and 200 or 300
    local notificationHeight = config.SubContent and 80 or 60
    local startPosX = isMobile and 10 or 20
    local parent = RunService:IsStudio() and LocalPlayer.PlayerGui or game:GetService("CoreGui")
    
    for _, v in pairs(parent:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == "NotificationHolder" then
            v:Destroy()
        end
    end
    
    local NotificationHolder = Linux.Instance("ScreenGui", {
        Name = "NotificationHolder",
        Parent = parent,
        ResetOnSpawn = false,
        Enabled = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    local Notification = Linux.Instance("Frame", {
        Parent = NotificationHolder,
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        BorderColor3 = Color3.fromRGB(40, 40, 50),
        BorderSizePixel = 0,
        Size = UDim2.new(0, notificationWidth, 0, notificationHeight),
        Position = UDim2.new(1, 10, 1, -notificationHeight - 10),
        ZIndex = 100
    })
    
    Linux.Instance("UICorner", {
        Parent = Notification,
        CornerRadius = UDim.new(0, 6)
    })
    
    Linux.Instance("UIStroke", {
        Parent = Notification,
        Color = Color3.fromRGB(60, 60, 70),
        Thickness = 1
    })
    
    Linux.Instance("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 5),
        Font = Enum.Font.GothamSemibold,
        Text = config.Title or "Notification",
        TextColor3 = Color3.fromRGB(230, 230, 240),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 101
    })
    
    Linux.Instance("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 25),
        Font = Enum.Font.GothamSemibold,
        Text = config.Content or "Content",
        TextColor3 = Color3.fromRGB(200, 200, 210),
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 101
    })
    
    if config.SubContent then
        Linux.Instance("TextLabel", {
            Parent = Notification,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 0, 20),
            Position = UDim2.new(0, 5, 0, 45),
            Font = Enum.Font.GothamSemibold,
            Text = config.SubContent,
            TextColor3 = Color3.fromRGB(180, 180, 190),
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            ZIndex = 101
        })
    end
    
    local ProgressBar = Linux.Instance("Frame", {
        Parent = Notification,
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        Size = UDim2.new(1, -10, 0, 4),
        Position = UDim2.new(0, 5, 1, -9),
        ZIndex = 101,
        BorderSizePixel = 0
    })
    
    Linux.Instance("UICorner", {
        Parent = ProgressBar,
        CornerRadius = UDim.new(1, 0)
    })
    
    local ProgressFill = Linux.Instance("Frame", {
        Parent = ProgressBar,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 0, 1, 0),
        ZIndex = 101,
        BorderSizePixel = 0
    })
    
    Linux.Instance("UICorner", {
        Parent = ProgressFill,
        CornerRadius = UDim.new(1, 0)
    })
    
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Notification, tweenInfo, {Position = UDim2.new(0, startPosX, 1, -notificationHeight - 10)}):Play()
    
    if config.Duration then
        local progressTweenInfo = TweenInfo.new(config.Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
        TweenService:Create(ProgressFill, progressTweenInfo, {Size = UDim2.new(1, 0, 1, 0)}):Play()
        task.delay(config.Duration, function()
            TweenService:Create(Notification, tweenInfo, {Position = UDim2.new(1, 10, 1, -notificationHeight - 10)}):Play()
            task.wait(0.5)
            NotificationHolder:Destroy()
        end)
    end
end

function Linux.Create(config)
    local randomName = "UI_" .. tostring(math.random(100000, 999999))
    
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name:match("^UI_%d+$") then
            v:Destroy()
        end
    end
    
    local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end
    
    local LinuxUI = Linux.Instance("ScreenGui", {
        Name = randomName,
        Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or game:GetService("CoreGui"),
        ResetOnSpawn = false,
        Enabled = true
    })
    
    ProtectGui(LinuxUI)
    
    local isMobile = InputService.TouchEnabled and not InputService.KeyboardEnabled
    local uiSize = isMobile and (config.SizeMobile or UDim2.fromOffset(300, 500)) or (config.SizePC or UDim2.fromOffset(550, 355))
    
    local Main = Linux.Instance("Frame", {
        Parent = LinuxUI,
        BackgroundColor3 = Color3.fromRGB(14, 14, 19),
        BorderColor3 = Color3.fromRGB(40, 40, 50),
        BorderSizePixel = 0,
        Size = uiSize,
        Position = UDim2.new(0.5, -uiSize.X.Offset / 2, 0.5, -uiSize.Y.Offset / 2),
        Active = true,
        Draggable = true,
        ZIndex = 1
    })
    
    Linux.Instance("UICorner", {
        Parent = Main,
        CornerRadius = UDim.new(0, 4)
    })
    
    Linux.Instance("UIStroke", {
        Parent = Main,
        Color = Color3.fromRGB(40, 40, 50),
        Thickness = 1
    })
    
    local TopBar = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(18, 18, 23),
        BorderColor3 = Color3.fromRGB(40, 40, 50),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30),
        ZIndex = 2
    })
    
    Linux.Instance("UICorner", {
        Parent = TopBar,
        CornerRadius = UDim.new(0, 8)
    })
    
    Linux.Instance("Frame", {
        Parent = TopBar,
        BackgroundColor3 = Color3.fromRGB(18, 18, 23),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 1, -8),
        ZIndex = 3
    })
    
    local TitleLabel = Linux.Instance("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Font = Enum.Font.GothamBold,
        Text = config.Name or "Linux UI",
        TextColor3 = Color3.fromRGB(230, 230, 240),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.X,
        ZIndex = 2
    })
    
    local MinimizeButton = Linux.Instance("ImageButton", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -46, 0.5, -8),
        Image = "rbxassetid://10734895698",
        ImageColor3 = Color3.fromRGB(180, 180, 190),
        ZIndex = 3
    })
    
    local CloseButton = Linux.Instance("ImageButton", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -26, 0.5, -8),
        Image = "rbxassetid://10747384394",
        ImageColor3 = Color3.fromRGB(180, 180, 190),
        ZIndex = 3
    })
    
    local TabsBar = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(18, 18, 23),
        BackgroundTransparency = 0,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(0, config.TabWidth or 130, 1, -30),
        ZIndex = 2,
        BorderSizePixel = 0
    })
    
    Linux.Instance("UICorner", {
        Parent = TabsBar,
        CornerRadius = UDim.new(0, 8)
    })
    
    Linux.Instance("Frame", {
        Parent = TabsBar,
        BackgroundColor3 = Color3.fromRGB(18, 18, 23),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 8, 1, 0),
        Position = UDim2.new(1, -8, 0, 0),
        ZIndex = 3
    })
    
    local SearchFrame = Linux.Instance("Frame", {
        Parent = TabsBar,
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        BorderSizePixel = 0,
        Size = UDim2.new(1, -16, 0, 32),
        Position = UDim2.new(0, 8, 0, 8),
        ZIndex = 3
    })
    
    Linux.Instance("UICorner", {
        Parent = SearchFrame,
        CornerRadius = UDim.new(0, 6)
    })
    
    Linux.Instance("UIStroke", {
        Parent = SearchFrame,
        Color = Color3.fromRGB(40, 40, 50),
        Thickness = 1
    })
    
    local SearchIcon = Linux.Instance("ImageLabel", {
        Parent = SearchFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 8, 0.5, -8),
        Image = "rbxassetid://10734943674",
        ImageColor3 = Color3.fromRGB(120, 120, 130),
        ZIndex = 3
    })
    
    local SearchBox = Linux.Instance("TextBox", {
        Parent = SearchFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -32, 1, 0),
        Position = UDim2.new(0, 32, 0, 0),
        Font = Enum.Font.GothamSemibold,
        Text = "",
        PlaceholderText = "Search...",
        PlaceholderColor3 = Color3.fromRGB(120, 120, 130),
        TextColor3 = Color3.fromRGB(200, 200, 210),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
        ClearTextOnFocus = false,
        ClipsDescendants = true,
        TextTruncate = Enum.TextTruncate.AtEnd
    })
    
    local ProfileFrame = Linux.Instance("Frame", {
        Parent = TabsBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 1, -50),
        ZIndex = 3
    })
    
    local ProfileImage = Linux.Instance("ImageLabel", {
        Parent = ProfileFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 10, 0, 8),
        Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48),
        ZIndex = 3
    })
    
    Linux.Instance("UICorner", {
        Parent = ProfileImage,
        CornerRadius = UDim.new(1, 0)
    })
    
    local PlayerName = Linux.Instance("TextLabel", {
        Parent = ProfileFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -52, 0, 32),
        Position = UDim2.new(0, 50, 0, 8),
        Font = Enum.Font.GothamSemibold,
        Text = LocalPlayer.DisplayName,
        TextColor3 = Color3.fromRGB(200, 200, 210),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 3
    })
    
    local TabHolder = Linux.Instance("ScrollingFrame", {
        Parent = TabsBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 48),
        Size = UDim2.new(1, 0, 1, -98),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 0,
        ZIndex = 2,
        BorderSizePixel = 0,
        ScrollingEnabled = true
    })
    
    Linux.Instance("UIListLayout", {
        Parent = TabHolder,
        Padding = UDim.new(0, 6),
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    Linux.Instance("UIPadding", {
        Parent = TabHolder,
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 8)
    })
    
    local Content = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(14, 14, 19),
        BackgroundTransparency = 0,
        Position = UDim2.new(0, config.TabWidth or 130, 0, 30),
        Size = UDim2.new(1, -(config.TabWidth or 130), 1, -30),
        ZIndex = 1,
        BorderSizePixel = 0
    })
    
    local isHidden = false
    local isMinimized = false
    local originalSize = uiSize
    local minimizedSize = UDim2.new(0, uiSize.X.Offset, 0, 30)
    
    MinimizeButton.MouseEnter:Connect(function()
        TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(220, 220, 230)}):Play()
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(180, 180, 190)}):Play()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        
        if isMinimized then
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = minimizedSize}):Play()
            Content.Visible = false
            TabsBar.Visible = false
            MinimizeButton.Image = "rbxassetid://10734886496"
        else
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = originalSize}):Play()
            Content.Visible = true
            TabsBar.Visible = true
            MinimizeButton.Image = "rbxassetid://10734895698"
        end
    end)
    
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(220, 220, 230)}):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(180, 180, 190)}):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        LinuxUI:Destroy()
    end)
    
    InputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftAlt then
            isHidden = not isHidden
            Main.Visible = not isHidden
        end
    end)
    
    local LinuxLib = {}
    local Tabs = {}
    local AllElements = {}
    local CurrentTab = nil
    local tabOrder = 0
    local ConfigSystem = {}
    
    if config.ConfigSave then
        local folder = "LinuxConfigs"
        local extension = ".lnx"
        
        ConfigSystem.Folder = folder
        ConfigSystem.Extension = extension
        
        local function createFolder()
            if not isfolder(folder) then
                makefolder(folder)
            end
        end
        
        function ConfigSystem.Save(name)
            createFolder()
            
            local configData = {}
            
            for tabIndex, tab in pairs(Tabs) do
                configData[tabIndex] = {
                    Elements = {}
                }
                
                for _, element in pairs(tab.Elements) do
                    if element.Type == "Toggle" then
                        configData[tabIndex].Elements[element.Name] = {
                            Type = "Toggle",
                            Value = element.Instance:GetAttribute("State")
                        }
                    elseif element.Type == "Slider" then
                        configData[tabIndex].Elements[element.Name] = {
                            Type = "Slider",
                            Value = element.Instance:GetAttribute("Value")
                        }
                    elseif element.Type == "Dropdown" then
                        if typeof(element.Value) == "table" then
                            configData[tabIndex].Elements[element.Name] = {
                                Type = "Dropdown",
                                Value = element.Value
                            }
                        else
                            configData[tabIndex].Elements[element.Name] = {
                                Type = "Dropdown",
                                Value = element.Value
                            }
                        end
                    elseif element.Type == "Colorpicker" then
                        local color = element.Instance:FindFirstChild("ColorPreview").BackgroundColor3
                        configData[tabIndex].Elements[element.Name] = {
                            Type = "Colorpicker",
                            Value = {color.R, color.G, color.B}
                        }
                    elseif element.Type == "Input" then
                        configData[tabIndex].Elements[element.Name] = {
                            Type = "Input",
                            Value = element.Value
                        }
                    elseif element.Type == "Keybind" then
                        configData[tabIndex].Elements[element.Name] = {
                            Type = "Keybind",
                            Value = tostring(element.Instance:FindFirstChildOfClass("TextButton").Text)
                        }
                    end
                end
            end
            
            local json = HttpService:JSONEncode(configData)
            writefile(folder .. "/" .. name .. extension, json)
            
            return true
        end
        
        function ConfigSystem.Load(name)
            createFolder()
            
            local fileName = folder .. "/" .. name .. extension
            if not isfile(fileName) then
                return false
            end
            
            local success, configData = pcall(function()
                return HttpService:JSONDecode(readfile(fileName))
            end)
            
            if not success then
                return false
            end
            
            for tabIndex, tabData in pairs(configData) do
                if Tabs[tabIndex] then
                    for elementName, elementData in pairs(tabData.Elements) do
                        for _, element in pairs(Tabs[tabIndex].Elements) do
                            if element.Name == elementName then
                                if elementData.Type == "Toggle" and element.Type == "Toggle" then
                                    local toggle = element.Instance
                                    toggle:SetAttribute("State", elementData.Value)
                                    
                                    local thisTrack = toggle:FindFirstChild("Track")
                                    local thisKnob = thisTrack and thisTrack:FindFirstChild("Knob")
                                    
                                    if thisTrack and thisKnob then
                                        if elementData.Value then
                                            thisTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                                            thisKnob.Position = UDim2.new(0, 20, 0.5, -7)
                                            thisKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                        else
                                            thisTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                                            thisKnob.Position = UDim2.new(0, 2, 0.5, -7)
                                            thisKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
                                        end
                                    end
                                    
                                    spawn(function()
                                        for _, v in pairs(AllElements) do
                                            if v.Tab == tabIndex and v.Element == element then
                                                local callback = element.Instance:GetAttribute("Callback")
                                                if callback then
                                                    Linux:SafeCallback(callback, elementData.Value)
                                                end
                                                break
                                            end
                                        end
                                    end)
                                elseif elementData.Type == "Slider" and element.Type == "Slider" then
                                    local slider = element.Instance
                                    local min = slider:GetAttribute("Min")
                                    local max = slider:GetAttribute("Max")
                                    local value = math.clamp(elementData.Value, min, max)
                                    
                                    slider:SetAttribute("Value", value)
                                    
                                    local relativePos = (value - min) / (max - min)
                                    local fillBar = slider:FindFirstChild("Bar"):FindFirstChild("Fill")
                                    
                                    if fillBar then
                                        fillBar.Size = UDim2.new(relativePos, 0, 1, 0)
                                    end
                                    
                                    local valueLabel = slider:FindFirstChild("Value")
                                    if valueLabel then
                                        valueLabel.Text = tostring(value)
                                    end
                                    
                                    spawn(function()
                                        for _, v in pairs(AllElements) do
                                            if v.Tab == tabIndex and v.Element == element then
                                                local callback = element.Instance:GetAttribute("Callback")
                                                if callback then
                                                    Linux:SafeCallback(callback, value)
                                                end
                                                break
                                            end
                                        end
                                    end)
                                elseif elementData.Type == "Dropdown" and element.Type == "Dropdown" then
                                    local dropdown = element.Instance
                                    local selected = dropdown:FindFirstChildOfClass("TextButton"):FindFirstChildOfClass("TextLabel"):FindFirstChildOfClass("TextLabel")
                                    
                                    if selected then
                                        if typeof(elementData.Value) == "table" then
                                            local text = #elementData.Value > 0 and (#elementData.Value > 1 and (#elementData.Value .. " Selected") or elementData.Value[1]) or "None"
                                            selected.Text = text
                                        else
                                            selected.Text = tostring(elementData.Value)
                                        end
                                    end
                                    
                                    spawn(function()
                                        for _, v in pairs(AllElements) do
                                            if v.Tab == tabIndex and v.Element == element then
                                                local callback = element.Instance:GetAttribute("Callback")
                                                if callback then
                                                    Linux:SafeCallback(callback, elementData.Value)
                                                end
                                                break
                                            end
                                        end
                                    end)
                                elseif elementData.Type == "Colorpicker" and element.Type == "Colorpicker" then
                                    local colorpicker = element.Instance
                                    local colorPreview = colorpicker:FindFirstChild("ColorPreview")
                                    
                                    if colorPreview and #elementData.Value == 3 then
                                        local color = Color3.new(elementData.Value[1], elementData.Value[2], elementData.Value[3])
                                        colorPreview.BackgroundColor3 = color
                                        
                                        spawn(function()
                                            for _, v in pairs(AllElements) do
                                                if v.Tab == tabIndex and v.Element == element then
                                                    local callback = element.Instance:GetAttribute("Callback")
                                                    if callback then
                                                        Linux:SafeCallback(callback, color)
                                                    end
                                                    break
                                                end
                                            end
                                        end)
                                    end
                                elseif elementData.Type == "Input" and element.Type == "Input" then
                                    local input = element.Instance
                                    local textBox = input:FindFirstChildOfClass("TextBox")
                                    
                                    if textBox then
                                        textBox.Text = tostring(elementData.Value)
                                        
                                        spawn(function()
                                            for _, v in pairs(AllElements) do
                                                if v.Tab == tabIndex and v.Element == element then
                                                    local callback = element.Instance:GetAttribute("Callback")
                                                    if callback then
                                                        Linux:SafeCallback(callback, textBox.Text)
                                                    end
                                                    break
                                                end
                                            end
                                        end)
                                    end
                                elseif elementData.Type == "Keybind" and element.Type == "Keybind" then
                                    local keybind = element.Instance
                                    local button = keybind:FindFirstChildOfClass("TextButton")
                                    
                                    if button then
                                        button.Text = elementData.Value
                                        
                                        spawn(function()
                                            for _, v in pairs(AllElements) do
                                                if v.Tab == tabIndex and v.Element == element then
                                                    local callback = element.Instance:GetAttribute("Callback")
                                                    if callback then
                                                        local keyCode = Enum.KeyCode[elementData.Value]
                                                        if keyCode then
                                                            Linux:SafeCallback(callback, keyCode)
                                                        end
                                                    end
                                                    break
                                                end
                                            end
                                        end)
                                    end
                                end
                                break
                            end
                        end
                    end
                end
            end
            
            return true
        end
        
        function ConfigSystem.Refresh()
            createFolder()
            
            local configs = {}
            local files = listfiles(folder)
            
            for _, file in ipairs(files) do
                if string.sub(file, #file - #extension + 1) == extension then
                    local fileName = string.gsub(string.sub(file, #folder + 2, #file - #extension), "\\", "/")
                    table.insert(configs, fileName)
                end
            end
            
            return configs
        end
        
        function ConfigSystem.Delete(name)
            createFolder()
            
            local fileName = folder .. "/" .. name .. extension
            if isfile(fileName) then
                delfile(fileName)
                return true
            end
            
            return false
        end
    end
    
    function LinuxLib.Tab(config)
        tabOrder = tabOrder + 1
        local tabIndex = tabOrder
        
        local TabBtn = Linux.Instance("TextButton", {
            Parent = TabHolder,
            BackgroundColor3 = Color3.fromRGB(25, 25, 30),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(40, 40, 50),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 32),
            Font = Enum.Font.GothamSemibold,
            Text = "",
            TextColor3 = Color3.fromRGB(200, 200, 210),
            TextSize = 14,
            ZIndex = 2,
            AutoButtonColor = false,
            LayoutOrder = tabIndex
        })
        
        Linux.Instance("UICorner", {
            Parent = TabBtn,
            CornerRadius = UDim.new(0, 6)
        })
        
        local TabSelectionIndicator = Linux.Instance("Frame", {
            Parent = TabBtn,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, 0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0
        })
        
        Linux.Instance("UICorner", {
            Parent = TabSelectionIndicator,
            CornerRadius = UDim.new(0, 2)
        })
        
        local TabIcon
        if config.Icon and config.Enabled then
            TabIcon = Linux.Instance("ImageLabel", {
                Parent = TabBtn,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 10, 0.5, -9),
                Image = config.Icon,
                ImageColor3 = Color3.fromRGB(200, 200, 200),
                ZIndex = 2
            })
        end
        
        local textOffset = config.Icon and config.Enabled and 33 or 16
        local TabText = Linux.Instance("TextLabel", {
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -(textOffset + 20), 1, 0),
            Position = UDim2.new(0, textOffset, 0, 0),
            Font = Enum.Font.GothamSemibold,
            Text = config.Name,
            TextColor3 = Color3.fromRGB(200, 200, 210),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 2
        })
        
        local TabContent = Linux.Instance("Frame", {
            Parent = Content,
            BackgroundColor3 = Color3.fromRGB(18, 18, 23),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ZIndex = 1,
            BorderSizePixel = 0
        })
        
        local TitleFrame = Linux.Instance("Frame", {
            Parent = Content,
            BackgroundColor3 = Color3.fromRGB(18, 18, 23),
            BackgroundTransparency = 0,
            Size = UDim2.new(1, 0, 0, 40),
            Position = UDim2.new(0, 0, 0, 0),
            Visible = false,
            ZIndex = 3,
            BorderSizePixel = 0
        })
        
        local TitleLabel = Linux.Instance("TextLabel", {
            Parent = TitleFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            Font = Enum.Font.GothamBold,
            Text = config.Name,
            TextColor3 = Color3.fromRGB(230, 230, 240),
            TextSize = 24,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 4
        })
        
        local Container = Linux.Instance("ScrollingFrame", {
            Parent = TabContent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 1, -60),
            Position = UDim2.new(0, 10, 0, 50),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 0,
            ZIndex = 1,
            BorderSizePixel = 0,
            ScrollingEnabled = true,
            CanvasPosition = Vector2.new(0, 0)
        })
        
        local ContainerListLayout = Linux.Instance("UIListLayout", {
            Parent = Container,
            Padding = UDim.new(0, 6),
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        Linux.Instance("UIPadding", {
            Parent = Container,
            PaddingLeft = UDim.new(0, 0),
            PaddingTop = UDim.new(0, 0)
        })
        
        local function SelectTab()
            for _, tab in pairs(Tabs) do
                tab.Content.Visible = false
                tab.TitleFrame.Visible = false
                tab.Text.TextColor3 = Color3.fromRGB(200, 200, 210)
                tab.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
                tab.Button.BackgroundTransparency = 1
                tab.Indicator.BackgroundTransparency = 1
                
                if tab.Icon then
                    tab.Icon.ImageColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
            
            TabContent.Visible = true
            TitleFrame.Visible = true
            TabText.TextColor3 = Color3.fromRGB(230, 230, 240)
            TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            TabBtn.BackgroundTransparency = 0.5
            TabSelectionIndicator.BackgroundTransparency = 0
            
            if TabIcon then
                TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            end
            
            CurrentTab = tabIndex
            Container.CanvasPosition = Vector2.new(0, 0)
        end
        
        local hoverTween = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        TabBtn.MouseEnter:Connect(function()
            if CurrentTab ~= tabIndex then
                TweenService:Create(TabBtn, hoverTween, {BackgroundTransparency = 0.7}):Play()
                TweenService:Create(TabSelectionIndicator, hoverTween, {BackgroundTransparency = 0.7}):Play()
            end
        end)
        
        TabBtn.MouseLeave:Connect(function()
            if CurrentTab ~= tabIndex then
                TweenService:Create(TabBtn, hoverTween, {BackgroundTransparency = 1}):Play()
                TweenService:Create(TabSelectionIndicator, hoverTween, {BackgroundTransparency = 1}):Play()
            end
        end)
        
        TabBtn.MouseButton1Click:Connect(SelectTab)
        
        Tabs[tabIndex] = {
            Name = config.Name,
            Button = TabBtn,
            Text = TabText,
            Icon = TabIcon,
            Content = TabContent,
            TitleFrame = TitleFrame,
            Indicator = TabSelectionIndicator,
            Elements = {}
        }
        
        if tabOrder == 1 then
            SelectTab()
        end
        
        local TabElements = {}
        local elementOrder = 0
        local lastWasDropdown = false
        
        function TabElements.Button(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local BtnFrame = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = BtnFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = BtnFrame,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            local Btn = Linux.Instance("TextButton", {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2,
                AutoButtonColor = false
            })
            
            Linux.Instance("UIPadding", {
                Parent = Btn,
                PaddingLeft = UDim.new(0, 10)
            })
            
            local BtnIcon = Linux.Instance("ImageLabel", {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -26, 0.5, -8),
                Image = "https://www.roblox.com/asset/?id=10709791437",
                ImageColor3 = Color3.fromRGB(200, 200, 200),
                ZIndex = 2
            })
            
            local originalColor = Color3.fromRGB(25, 25, 30)
            local hoverColor = Color3.fromRGB(35, 35, 40)
            local clickColor = Color3.fromRGB(45, 45, 50)
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            
            local isHovering = false
            
            Btn.MouseEnter:Connect(function()
                isHovering = true
                TweenService:Create(BtnFrame, tweenInfo, {BackgroundColor3 = hoverColor, BackgroundTransparency = 0.3}):Play()
                TweenService:Create(BtnFrame, tweenInfo, {Size = UDim2.new(1, 0, 0, 38)}):Play()
            end)
            
            Btn.MouseLeave:Connect(function()
                isHovering = false
                TweenService:Create(BtnFrame, tweenInfo, {BackgroundColor3 = originalColor, BackgroundTransparency = 0}):Play()
                TweenService:Create(BtnFrame, tweenInfo, {Size = UDim2.new(1, 0, 0, 36)}):Play()
            end)
            
            Btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    TweenService:Create(BtnFrame, tweenInfo, {BackgroundColor3 = clickColor, BackgroundTransparency = 0.5}):Play()
                end
            end)
            
            Btn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if isHovering then
                        TweenService:Create(BtnFrame, tweenInfo, {BackgroundColor3 = hoverColor, BackgroundTransparency = 0.3}):Play()
                    else
                        TweenService:Create(BtnFrame, tweenInfo, {BackgroundColor3 = originalColor, BackgroundTransparency = 0}):Play()
                    end
                end
            end)
            
            Btn.MouseButton1Click:Connect(function()
                spawn(function() Linux:SafeCallback(config.Callback) end)
            end)
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            local element = {
                Type = "Button",
                Name = config.Name,
                Instance = BtnFrame
            }
            table.insert(Tabs[tabIndex].Elements, element)
            table.insert(AllElements, {Tab = tabIndex, Element = element})
            
            return Btn
        end
        
        function TabElements.Toggle(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local Toggle = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = Toggle,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = Toggle,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            local ToggleText = Linux.Instance("TextLabel", {
                Parent = Toggle,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2,
                Name = "ToggleText"
            })
            
            local ToggleTrack = Linux.Instance("Frame", {
                Parent = Toggle,
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                Size = UDim2.new(0, 36, 0, 18),
                Position = UDim2.new(1, -46, 0.5, -9),
                ZIndex = 2,
                BorderSizePixel = 0,
                Name = "Track"
            })
            
            Linux.Instance("UICorner", {
                Parent = ToggleTrack,
                CornerRadius = UDim.new(1, 0)
            })
            
            Linux.Instance("UIStroke", {
                Parent = ToggleTrack,
                Color = Color3.fromRGB(60, 60, 70),
                Thickness = 1
            })
            
            local ToggleKnob = Linux.Instance("Frame", {
                Parent = ToggleTrack,
                BackgroundColor3 = Color3.fromRGB(200, 200, 210),
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(0, 2, 0.5, -7),
                ZIndex = 3,
                BorderSizePixel = 0,
                Name = "Knob"
            })
            
            Linux.Instance("UICorner", {
                Parent = ToggleKnob,
                CornerRadius = UDim.new(1, 0)
            })
            
            local State = config.Default or false
            Toggle:SetAttribute("State", State)
            Toggle:SetAttribute("Callback", config.Callback)
            
            local isToggling = false
            local function UpdateToggle(thisToggle)
                if isToggling then return end
                isToggling = true
                
                local currentState = thisToggle:GetAttribute("State")
                local thisTrack = thisToggle:FindFirstChild("Track")
                local thisKnob = thisTrack and thisTrack:FindFirstChild("Knob")
                
                if thisTrack and thisKnob then
                    local tween = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    if currentState then
                        TweenService:Create(thisTrack, tween, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                        TweenService:Create(thisKnob, tween, {Position = UDim2.new(0, 20, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                    else
                        TweenService:Create(thisTrack, tween, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
                        TweenService:Create(thisKnob, tween, {Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Color3.fromRGB(200, 200, 210)}):Play()
                    end
                end
                
                task.wait(0.25)
                isToggling = false
            end
            
            UpdateToggle(Toggle)
            spawn(function() Linux:SafeCallback(config.Callback, State) end)
            
            local function toggleSwitch()
                if not isToggling then
                    local newState = not Toggle:GetAttribute("State")
                    Toggle:SetAttribute("State", newState)
                    
                    UpdateToggle(Toggle)
                    spawn(function() Linux:SafeCallback(config.Callback, newState) end)
                end
            end
            
            ToggleTrack.InputBegan:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
                    toggleSwitch()
                end
            end)
            
            ToggleKnob.InputBegan:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
                    toggleSwitch()
                end
            end)
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            local element = {
                Type = "Toggle",
                Name = config.Name,
                Instance = Toggle,
                State = State
            }
            table.insert(Tabs[tabIndex].Elements, element)
            table.insert(AllElements, {Tab = tabIndex, Element = element})
            
            return Toggle
        end
        
        function TabElements.Dropdown(config)
            elementOrder = elementOrder + 1
            lastWasDropdown = true
            
            local Dropdown = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = Dropdown,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = Dropdown,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            local DropdownButton = Linux.Instance("TextButton", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = "",
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                ZIndex = 2,
                AutoButtonColor = false
            })
            
            Linux.Instance("TextLabel", {
                Parent = DropdownButton,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })
            
            local Options = config.Options or {}
            local IsMulti = config.Multi or false
            local SelectedValues = {}
            
            if IsMulti then
                if config.Default and type(config.Default) == "table" then
                    for _, value in pairs(config.Default) do
                        if table.find(Options, value) then
                            table.insert(SelectedValues, value)
                        end
                    end
                end
            else
                local SelectedValue = config.Default or (Options[1] or "None")
                if table.find(Options, SelectedValue) then
                    SelectedValues = {SelectedValue}
                elseif #Options > 0 then
                    SelectedValues = {Options[1]}
                else
                    SelectedValues = {"None"}
                end
            end
            
            local function GetSelectedText()
                if #SelectedValues == 0 then
                    return "None"
                elseif #SelectedValues == 1 then
                    return tostring(SelectedValues[1])
                else
                    return #SelectedValues .. " Selected"
                end
            end
            
            local Selected = Linux.Instance("TextLabel", {
                Parent = DropdownButton,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.3, -21, 1, 0),
                Position = UDim2.new(0.65, 5, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = GetSelectedText(),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 2
            })
            
            local Arrow = Linux.Instance("ImageLabel", {
                Parent = DropdownButton,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(1, -26, 0.5, -8),
                Image = "https://www.roblox.com/asset/?id=10709791437",
                ImageColor3 = Color3.fromRGB(200, 200, 200),
                Rotation = 0,
                ZIndex = 2
            })
            
            local DropFrame = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 0),
                ZIndex = 3,
                LayoutOrder = elementOrder + 1,
                ClipsDescendants = true,
                Visible = true
            })
            
            Linux.Instance("UICorner", {
                Parent = DropFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = DropFrame,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            local OptionsHolder = Linux.Instance("ScrollingFrame", {
                Parent = DropFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 0,
                ZIndex = 3,
                BorderSizePixel = 0,
                ScrollingEnabled = true
            })
            
            Linux.Instance("UIListLayout", {
                Parent = OptionsHolder,
                Padding = UDim.new(0, 2),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            Linux.Instance("UIPadding", {
                Parent = OptionsHolder,
                PaddingLeft = UDim.new(0, 5),
                PaddingRight = UDim.new(0, 5),
                PaddingTop = UDim.new(0, 5),
                PaddingBottom = UDim.new(0, 5)
            })
            
            local IsOpen = false
            Dropdown:SetAttribute("Callback", config.Callback)
            
            local function UpdateDropSize()
                local optionHeight = 28
                local paddingBetween = 2
                local paddingTopBottom = 10
                local maxHeight = 150
                local numOptions = #Options
                local calculatedHeight = numOptions * optionHeight + (numOptions > 0 and (numOptions - 1) * paddingBetween + paddingTopBottom or 0)
                local finalHeight = math.min(calculatedHeight, maxHeight)
                
                local tween = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                
                if IsOpen then
                    DropFrame.Visible = true
                    DropFrame.Size = UDim2.new(1, 0, 0, 0)
                    TweenService:Create(DropFrame, tween, {Size = UDim2.new(1, 0, 0, finalHeight)}):Play()
                    TweenService:Create(Arrow, tween, {Rotation = 85}):Play()
                else
                    TweenService:Create(DropFrame, tween, {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    TweenService:Create(Arrow, tween, {Rotation = 0}):Play()
                    task.delay(0.25, function()
                        if not IsOpen then
                            DropFrame.Visible = false
                        end
                    end)
                end
            end
            
            local function IsSelected(value)
                return table.find(SelectedValues, value) ~= nil
            end
            
            local function UpdateSelected()
                Selected.Text = GetSelectedText()
                
                if IsMulti then
                    spawn(function() Linux:SafeCallback(config.Callback, SelectedValues) end)
                else
                    spawn(function() Linux:SafeCallback(config.Callback, SelectedValues[1]) end)
                end
            end
            
            local function PopulateOptions()
                for _, child in pairs(OptionsHolder:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                if IsOpen then
                    for i, opt in pairs(Options) do
                        local isSelected = IsSelected(opt)
                        
                        local OptBtn = Linux.Instance("TextButton", {
                            Parent = OptionsHolder,
                            BackgroundColor3 = isSelected and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(30, 30, 35),
                            BorderColor3 = Color3.fromRGB(40, 40, 50),
                            BorderSizePixel = 0,
                            Size = UDim2.new(1, -4, 0, 28),
                            Font = Enum.Font.GothamSemibold,
                            Text = tostring(opt),
                            TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 210),
                            TextSize = 14,
                            ZIndex = 3,
                            AutoButtonColor = false,
                            LayoutOrder = i
                        })
                        
                        Linux.Instance("UICorner", {
                            Parent = OptBtn,
                            CornerRadius = UDim.new(0, 4)
                        })
                        
                        if IsMulti and isSelected then
                            local CheckMark = Linux.Instance("ImageLabel", {
                                Parent = OptBtn,
                                BackgroundTransparency = 1,
                                Size = UDim2.new(0, 16, 0, 16),
                                Position = UDim2.new(1, -20, 0.5, -8),
                                Image = "rbxassetid://10747384394",
                                ImageColor3 = Color3.fromRGB(255, 255, 255),
                                ZIndex = 4
                            })
                        end
                        
                        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        
                        OptBtn.MouseEnter:Connect(function()
                            if not IsSelected(opt) then
                                TweenService:Create(OptBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
                            end
                        end)
                        
                        OptBtn.MouseLeave:Connect(function()
                            if not IsSelected(opt) then
                                TweenService:Create(OptBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
                            end
                        end)
                        
                        OptBtn.MouseButton1Click:Connect(function()
                            if IsMulti then
                                local index = table.find(SelectedValues, opt)
                                if index then
                                    table.remove(SelectedValues, index)
                                else
                                    table.insert(SelectedValues, opt)
                                end
                                UpdateSelected()
                                PopulateOptions()
                            else
                                if not IsSelected(opt) then
                                    SelectedValues = {opt}
                                    UpdateSelected()
                                    IsOpen = false
                                    UpdateDropSize()
                                    PopulateOptions()
                                end
                            end
                        end)
                    end
                end
                
                UpdateDropSize()
            end
            
            if #Options > 0 then
                PopulateOptions()
                UpdateSelected()
            end
            
            Arrow.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    IsOpen = not IsOpen
                    PopulateOptions()
                end
            end)
            
            local function SetOptions(newOptions)
                Options = newOptions or {}
                SelectedValues = {}
                
                if not IsMulti then
                    if #Options > 0 then
                        SelectedValues = {Options[1]}
                    else
                        SelectedValues = {"None"}
                    end
                end
                
                IsOpen = false
                UpdateDropSize()
                PopulateOptions()
                UpdateSelected()
            end
            
            local function SetValue(value)
                if IsMulti and type(value) == "table" then
                    SelectedValues = {}
                    for _, v in pairs(value) do
                        if table.find(Options, v) then
                            table.insert(SelectedValues, v)
                        end
                    end
                elseif table.find(Options, value) then
                    if IsMulti then
                        if not table.find(SelectedValues, value) then
                            table.insert(SelectedValues, value)
                        end
                    else
                        SelectedValues = {value}
                    end
                end
                
                IsOpen = false
                UpdateDropSize()
                PopulateOptions()
                UpdateSelected()
            end
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            local element = {
                Type = "Dropdown",
                Name = config.Name,
                Instance = Dropdown,
                Value = IsMulti and SelectedValues or SelectedValues[1]
            }
            table.insert(Tabs[tabIndex].Elements, element)
            table.insert(AllElements, {Tab = tabIndex, Element = element})
            
            return {
                Instance = Dropdown,
                SetOptions = SetOptions,
                SetValue = SetValue,
                GetValue = function() return IsMulti and SelectedValues or SelectedValues[1] end
            }
        end
        
        function TabElements.Slider(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local Slider = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 42),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = Slider,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = Slider,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            local TitleLabel = Linux.Instance("TextLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 0, 16),
                Position = UDim2.new(0, 10, 0, 4),
                Font = Enum.Font.GothamSemibold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })
            
            local SliderBar = Linux.Instance("Frame", {
                Parent = Slider,
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 0, 26),
                ZIndex = 2,
                BorderSizePixel = 0,
                Name = "Bar"
            })
            
            Linux.Instance("UICorner", {
                Parent = SliderBar,
                CornerRadius = UDim.new(1, 0)
            })
            
            local ValueLabel = Linux.Instance("TextLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 50, 0, 16),
                Position = UDim2.new(1, -60, 0, 4),
                Font = Enum.Font.GothamSemibold,
                Text = "",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 2,
                Name = "Value"
            })
            
            local FillBar = Linux.Instance("Frame", {
                Parent = SliderBar,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(0, 0, 1, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                Name = "Fill"
            })
            
            Linux.Instance("UIGradient", {
                Parent = FillBar,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(224, 224, 224))
                }),
                Rotation = 90
            })
            
            Linux.Instance("UICorner", {
                Parent = FillBar,
                CornerRadius = UDim.new(1, 0)
            })
            
            local SliderButton = Linux.Instance("TextButton", {
                Parent = SliderBar,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                ZIndex = 3
            })
            
            local Min = config.Min or 0
            local Max = config.Max or 100
            local Rounding = config.Rounding or 0
            
            Slider:SetAttribute("Min", Min)
            Slider:SetAttribute("Max", Max)
            Slider:SetAttribute("Rounding", Rounding)
            Slider:SetAttribute("Callback", config.Callback)
            
            local Value = config.Default or Min
            
            Slider:SetAttribute("Value", Value)
            
            local function RoundValue(value)
                if Rounding <= 0 then
                    return math.floor(value + 0.5)
                else
                    local mult = 10 ^ Rounding
                    return math.floor(value * mult + 0.5) / mult
                end
            end
            
            local function AnimateValueLabel()
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                TweenService:Create(ValueLabel, tweenInfo, {TextSize = 16}):Play()
                task.wait(0.2)
                TweenService:Create(ValueLabel, tweenInfo, {TextSize = 14}):Play()
            end
            
            local function UpdateSlider(pos)
                local barSize = SliderBar.AbsoluteSize.X
                local relativePos = math.clamp((pos - SliderBar.AbsolutePosition.X) / barSize, 0, 1)
                
                local min = Slider:GetAttribute("Min")
                local max = Slider:GetAttribute("Max")
                local rounding = Slider:GetAttribute("Rounding")
                
                local value = min + (max - min) * relativePos
                value = RoundValue(value)
                
                Slider:SetAttribute("Value", value)
                
                FillBar.Size = UDim2.new(relativePos, 0, 1, 0)
                
                ValueLabel.Text = tostring(value)
                
                AnimateValueLabel()
                spawn(function() Linux:SafeCallback(config.Callback, value) end)
            end
            
            local draggingSlider = false
            
            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    UpdateSlider(input.Position.X)
                end
            end)
            
            SliderButton.InputChanged:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and draggingSlider then
                    UpdateSlider(input.Position.X)
                end
            end)
            
            SliderButton.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = false
                end
            end)
            
            local function SetValue(newValue)
                local min = Slider:GetAttribute("Min")
                local max = Slider:GetAttribute("Max")
                local rounding = Slider:GetAttribute("Rounding")
                
                newValue = math.clamp(newValue, min, max)
                newValue = RoundValue(newValue)
                
                Slider:SetAttribute("Value", newValue)
                
                local relativePos = (newValue - min) / (max - min)
                
                FillBar.Size = UDim2.new(relativePos, 0, 1, 0)
                
                ValueLabel.Text = tostring(newValue)
                
                AnimateValueLabel()
                spawn(function() Linux:SafeCallback(config.Callback, newValue) end)
            end
            
            SetValue(Value)
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            local element = {
                Type = "Slider",
                Name = config.Name,
                Instance = Slider,
                Value = Value
            }
            table.insert(Tabs[tabIndex].Elements, element)
            table.insert(AllElements, {Tab = tabIndex, Element = element})
            
            return {
                Instance = Slider,
                SetValue = SetValue,
                GetValue = function() return Slider:GetAttribute("Value") end,
                SetMin = function(min)
                    Slider:SetAttribute("Min", min)
                    SetValue(Slider:GetAttribute("Value"))
                end,
                SetMax = function(max)
                    Slider:SetAttribute("Max", max)
                    SetValue(Slider:GetAttribute("Value"))
                end,
                SetRounding = function(rounding)
                    Slider:SetAttribute("Rounding", rounding)
                    SetValue(Slider:GetAttribute("Value"))
                end
            }
        end
        
        function TabElements.Input(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local Input = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = Input,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = Input,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            Linux.Instance("TextLabel", {
                Parent = Input,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })
            
            local TextBox = Linux.Instance("TextBox", {
                Parent = Input,
                BackgroundColor3 = Color3.fromRGB(20, 20, 25),
                BorderSizePixel = 0,
                Size = UDim2.new(0.3, -16, 0, 24),
                Position = UDim2.new(0.7, 0, 0.5, -12),
                Font = Enum.Font.GothamSemibold,
                Text = config.Default or "",
                PlaceholderText = config.Placeholder or "Text here",
                PlaceholderColor3 = Color3.fromRGB(120, 120, 130),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12,
                TextScaled = false,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextXAlignment = Enum.TextXAlignment.Center,
                ClearTextOnFocus = false,
                ClipsDescendants = true,
                ZIndex = 3
            })
            
            Linux.Instance("UICorner", {
                Parent = TextBox,
                CornerRadius = UDim.new(0, 4)
            })
            
            Linux.Instance("UIPadding", {
                Parent = TextBox,
                PaddingLeft = UDim.new(0, 6),
                PaddingRight = UDim.new(0, 6)
            })
            
            local MaxLength = 100
            Input:SetAttribute("Callback", config.Callback)
            
            local function CheckTextBounds()
                if #TextBox.Text > MaxLength then
                    TextBox.Text = string.sub(TextBox.Text, 1, MaxLength)
                end
            end
            
            TextBox:GetPropertyChangedSignal("Text"):Connect(function()
                CheckTextBounds()
            end)
            
            local function UpdateInput()
                CheckTextBounds()
                spawn(function() Linux:SafeCallback(config.Callback, TextBox.Text) end)
            end
            
            TextBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    UpdateInput()
                end
            end)
            
            TextBox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    TextBox:CaptureFocus()
                end
            end)
            
            spawn(function() Linux:SafeCallback(config.Callback, TextBox.Text) end)
            
            local function SetValue(newValue)
                local text = tostring(newValue)
                if #text > MaxLength then
                    text = string.sub(text, 1, MaxLength)
                end
                TextBox.Text = text
                UpdateInput()
            end
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            local element = {
                Type = "Input",
                Name = config.Name,
                Instance = Input,
                Value = TextBox.Text
            }
            table.insert(Tabs[tabIndex].Elements, element)
            table.insert(AllElements, {Tab = tabIndex, Element = element})
            
            return {
                Instance = Input,
                SetValue = SetValue,
                GetValue = function() return TextBox.Text end
            }
        end
        
        function TabElements.Label(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local LabelFrame = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = LabelFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = LabelFrame,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            local LabelText = Linux.Instance("TextLabel", {
                Parent = LabelFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = config.Text or "Label",
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 2
            })
            
            local UpdateConnection = nil
            local lastUpdate = 0
            local updateInterval = 0.1
            
            local function StartUpdateLoop()
                if UpdateConnection then
                    UpdateConnection:Disconnect()
                end
                if config.UpdateCallback then
                    UpdateConnection = RunService.Heartbeat:Connect(function()
                        if not LabelFrame:IsDescendantOf(game) then
                            UpdateConnection:Disconnect()
                            return
                        end
                        local currentTime = tick()
                        if currentTime - lastUpdate >= updateInterval then
                            local success, newText = pcall(config.UpdateCallback)
                            if success and newText ~= nil then
                                LabelText.Text = tostring(newText)
                            end
                            lastUpdate = currentTime
                        end
                    end)
                end
            end
            
            local function SetText(newText)
                if config.UpdateCallback then
                    config.Text = tostring(newText)
                else
                    LabelText.Text = tostring(newText)
                end
            end
            
            if config.UpdateCallback then
                StartUpdateLoop()
            end
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            local element = {
                Type = "Label",
                Name = config.Text or "Label",
                Instance = LabelFrame
            }
            table.insert(Tabs[tabIndex].Elements, element)
            table.insert(AllElements, {Tab = tabIndex, Element = element})
            
            return {
                Instance = LabelFrame,
                SetText = SetText,
                GetText = function() return LabelText.Text end
            }
        end
        
        function TabElements.Section(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local Section = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 30),
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 2,
                LayoutOrder = elementOrder,
                BorderSizePixel = 0
            })
            
            local SectionLabel = Linux.Instance("TextLabel", {
                Parent = Section,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 30),
                Position = UDim2.new(0, 0, 0, 0),
                Font = Enum.Font.GothamBold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 18,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            local element = {
                Type = "Section",
                Name = config.Name,
                Instance = Section
            }
            table.insert(Tabs[tabIndex].Elements, element)
            table.insert(AllElements, {Tab = tabIndex, Element = element})
            
            return Section
        end
        
        function TabElements.Paragraph(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local ParagraphFrame = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = ParagraphFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = ParagraphFrame,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            Linux.Instance("TextLabel", {
                Parent = ParagraphFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 26),
                Position = UDim2.new(0, 10, 0, 5),
                Font = Enum.Font.GothamBold,
                Text = config.Title or "Paragraph",
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })
            
            local Content = Linux.Instance("TextLabel", {
                Parent = ParagraphFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 0),
                Position = UDim2.new(0, 10, 0, 30),
                Font = Enum.Font.GothamSemibold,
                Text = config.Content or "Content",
                TextColor3 = Color3.fromRGB(150, 150, 155),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 2
            })
            
            Linux.Instance("UIPadding", {
                Parent = ParagraphFrame,
                PaddingBottom = UDim.new(0, 10)
            })
            
            local function SetTitle(newTitle)
                ParagraphFrame:GetChildren()[3].Text = tostring(newTitle)
            end
            
            local function SetContent(newContent)
                Content.Text = tostring(newContent)
            end
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            local element = {
                Type = "Paragraph",
                Name = config.Title or "Paragraph",
                Instance = ParagraphFrame
            }
            table.insert(Tabs[tabIndex].Elements, element)
            table.insert(AllElements, {Tab = tabIndex, Element = element})
            
            return {
                Instance = ParagraphFrame,
                SetTitle = SetTitle,
                SetContent = SetContent
            }
        end
        
        function TabElements.Notification(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local NotificationFrame = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = NotificationFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = NotificationFrame,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            Linux.Instance("TextLabel", {
                Parent = NotificationFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })
            
            local NotificationText = Linux.Instance("TextLabel", {
                Parent = NotificationFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, -20, 1, 0),
                Position = UDim2.new(0.5, 10, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = config.Default or "Notification",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 2
            })
            
            local function SetText(newText)
                NotificationText.Text = tostring(newText)
            end
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            local element = {
                Type = "Notification",
                Name = config.Name,
                Instance = NotificationFrame
            }
            table.insert(Tabs[tabIndex].Elements, element)
            table.insert(AllElements, {Tab = tabIndex, Element = element})
            
            return {
                Instance = NotificationFrame,
                SetText = SetText,
                GetText = function() return NotificationText.Text end
            }
        end
        
        function TabElements.Keybind(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local KeybindFrame = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = KeybindFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = KeybindFrame,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            Linux.Instance("TextLabel", {
                Parent = KeybindFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })
            
            local currentKey = config.Default or Enum.KeyCode.None
            local isCapturing = false
            KeybindFrame:SetAttribute("Callback", config.Callback)
            
            local KeybindButton = Linux.Instance("TextButton", {
                Parent = KeybindFrame,
                BackgroundColor3 = Color3.fromRGB(20, 20, 25),
                BorderSizePixel = 0,
                Size = UDim2.new(0.3, -16, 0, 24),
                Position = UDim2.new(0.7, 0, 0.5, -12),
                Font = Enum.Font.GothamSemibold,
                Text = tostring(currentKey.Name),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12,
                ZIndex = 3,
                AutoButtonColor = false
            })
            
            Linux.Instance("UICorner", {
                Parent = KeybindButton,
                CornerRadius = UDim.new(0, 4)
            })
            
            local inputConnection = nil
            
            local function StopCapture()
                if inputConnection then
                    inputConnection:Disconnect()
                    inputConnection = nil
                end
                isCapturing = false
                KeybindButton.Text = tostring(currentKey.Name)
                KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
            
            KeybindButton.MouseButton1Click:Connect(function()
                if isCapturing then
                    StopCapture()
                    return
                end
                isCapturing = true
                KeybindButton.Text = "..."
                KeybindButton.TextColor3 = Color3.fromRGB(200, 200, 210)
                
                inputConnection = InputService.InputBegan:Connect(function(input, gameProcessedEvent)
                    if gameProcessedEvent then return end
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        if input.KeyCode == Enum.KeyCode.Escape then
                            StopCapture()
                        else
                            currentKey = input.KeyCode
                            StopCapture()
                            spawn(function() Linux:SafeCallback(config.Callback, currentKey) end)
                        end
                    end
                end)
            end)
            
            spawn(function() Linux:SafeCallback(config.Callback, currentKey) end)
            
            local function SetValue(newKey)
                if typeof(newKey) == "EnumItem" and newKey.EnumType == Enum.KeyCode then
                    currentKey = newKey
                    KeybindButton.Text = tostring(currentKey.Name)
                    spawn(function() Linux:SafeCallback(config.Callback, currentKey) end)
                end
            end
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            local element = {
                Type = "Keybind",
                Name = config.Name,
                Instance = KeybindFrame
            }
            table.insert(Tabs[tabIndex].Elements, element)
            table.insert(AllElements, {Tab = tabIndex, Element = element})
            
            return {
                Instance = KeybindFrame,
                SetValue = SetValue,
                GetValue = function() return currentKey end
            }
        end
        
        function TabElements.Colorpicker(config)
            elementOrder = elementOrder + 1
            if lastWasDropdown then
                ContainerListLayout.Padding = UDim.new(0, 10)
            else
                ContainerListLayout.Padding = UDim.new(0, 6)
            end
            lastWasDropdown = false
            
            local ColorpickerFrame = Linux.Instance("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                BorderColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 36),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })
            
            Linux.Instance("UICorner", {
                Parent = ColorpickerFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            Linux.Instance("UIStroke", {
                Parent = ColorpickerFrame,
                Color = Color3.fromRGB(40, 40, 50),
                Thickness = 1
            })
            
            Linux.Instance("TextLabel", {
                Parent = ColorpickerFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.GothamSemibold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })
            
            local currentColor = config.Default or Color3.fromRGB(255, 255, 255)
            local isPicking = false
            ColorpickerFrame:SetAttribute("Callback", config.Callback)
            
            local ColorPreview = Linux.Instance("Frame", {
                Parent = ColorpickerFrame,
                BackgroundColor3 = currentColor,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 24, 0, 24),
                Position = UDim2.new(1, -34, 0.5, -12),
                ZIndex = 3,
                Name = "ColorPreview"
            })
            
            Linux.Instance("UICorner", {
                Parent = ColorPreview,
                CornerRadius = UDim.new(0, 4)
            })
            
            Linux.Instance("UIStroke", {
                Parent = ColorPreview,
                Color = Color3.fromRGB(60, 60, 70),
                Thickness = 1
            })
            
            local ColorpickerPopup = nil
            local paletteMarker = nil
            local hueMarker = nil
            local currentHue = 0
            local currentSaturation = 0
            local currentValue = 1
            
            local function UpdateColorFromHSV()
                currentColor = Color3.fromHSV(currentHue, currentSaturation, currentValue)
                ColorPreview.BackgroundColor3 = currentColor
                
                if ColorpickerPopup then
                    local palette = ColorpickerPopup:FindFirstChild("Palette")
                    if palette then
                        palette.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
                    end
                    
                    local preview = ColorpickerPopup:FindFirstChild("ColorPreview")
                    if preview then
                        preview.BackgroundColor3 = currentColor
                    end
                end
                spawn(function() Linux:SafeCallback(config.Callback, currentColor) end)
            end
            
            local function CreateColorpickerPopup()
                if ColorpickerPopup then
                    ColorpickerPopup:Destroy()
                end
                
                ColorpickerPopup = Linux.Instance("Frame", {
                    Parent = Main,
                    BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                    BorderColor3 = Color3.fromRGB(40, 40, 50),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 200, 0, 180),
                    Position = UDim2.new(0.5, -100, 0.5, -90),
                    ZIndex = 10,
                    Visible = false
                })
                
                Linux.Instance("UICorner", {
                    Parent = ColorpickerPopup,
                    CornerRadius = UDim.new(0, 6)
                })
                
                Linux.Instance("UIStroke", {
                    Parent = ColorpickerPopup,
                    Color = Color3.fromRGB(40, 40, 50),
                    Thickness = 1
                })
                
                local Palette = Linux.Instance("Frame", {
                    Parent = ColorpickerPopup,
                    BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1),
                    Size = UDim2.new(0, 140, 0, 100),
                    Position = UDim2.new(0, 10, 0, 10),
                    ZIndex = 11,
                    Name = "Palette"
                })
                
                Linux.Instance("UICorner", {
                    Parent = Palette,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local SaturationGradient = Linux.Instance("UIGradient", {
                    Parent = Palette,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV(currentHue, 1, 1))
                    }),
                    Transparency = NumberSequence.new(0),
                    Rotation = 0
                })
                
                local ValueOverlay = Linux.Instance("Frame", {
                    Parent = Palette,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    BackgroundTransparency = 0,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 11
                })
                
                Linux.Instance("UICorner", {
                    Parent = ValueOverlay,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local ValueGradient = Linux.Instance("UIGradient", {
                    Parent = ValueOverlay,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
                    }),
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(1, 0)
                    }),
                    Rotation = 90
                })
                
                paletteMarker = Linux.Instance("Frame", {
                    Parent = Palette,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 6, 0, 6),
                    ZIndex = 12,
                    BorderSizePixel = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0)
                })
                
                Linux.Instance("UICorner", {
                    Parent = paletteMarker,
                    CornerRadius = UDim.new(1, 0)
                })
                
                local HueBar = Linux.Instance("Frame", {
                    Parent = ColorpickerPopup,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 20, 0, 100),
                    Position = UDim2.new(0, 160, 0, 10),
                    ZIndex = 11
                })
                
                Linux.Instance("UICorner", {
                    Parent = HueBar,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local HueGradient = Linux.Instance("UIGradient", {
                    Parent = HueBar,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                    }),
                    Rotation = 90
                })
                
                hueMarker = Linux.Instance("Frame", {
                    Parent = HueBar,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 24, 0, 4),
                    ZIndex = 12,
                    BorderSizePixel = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0)
                })
                
                local ColorPreview = Linux.Instance("Frame", {
                    Parent = ColorpickerPopup,
                    BackgroundColor3 = currentColor,
                    Size = UDim2.new(0, 180, 0, 30),
                    Position = UDim2.new(0, 10, 0, 120),
                    ZIndex = 11,
                    Name = "ColorPreview"
                })
                
                Linux.Instance("UICorner", {
                    Parent = ColorPreview,
                    CornerRadius = UDim.new(0, 4)
                })
                
                Linux.Instance("UIStroke", {
                    Parent = ColorPreview,
                    Color = Color3.fromRGB(60, 60, 70),
                    Thickness = 1
                })
                
                local CloseButton = Linux.Instance("TextButton", {
                    Parent = ColorpickerPopup,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                    Size = UDim2.new(0, 180, 0, 20),
                    Position = UDim2.new(0, 10, 0, 150),
                    Font = Enum.Font.GothamSemibold,
                    Text = "Close",
                    TextColor3 = Color3.fromRGB(200, 200, 210),
                    TextSize = 12,
                    ZIndex = 11,
                    AutoButtonColor = false
                })
                
                Linux.Instance("UICorner", {
                    Parent = CloseButton,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local paletteDragging = false
                local hueDragging = false
                
                Palette.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        paletteDragging = true
                        local pos = input.Position
                        local palettePos = Palette.AbsolutePosition
                        local paletteSize = Palette.AbsoluteSize
                        local x = math.clamp((pos.X - palettePos.X) / paletteSize.X, 0, 1)
                        local y = math.clamp((pos.Y - palettePos.Y) / paletteSize.Y, 0, 1)
                        currentSaturation = x
                        currentValue = 1 - y
                        paletteMarker.Position = UDim2.new(0, x * paletteSize.X - 3, 0, y * paletteSize.Y - 3)
                        UpdateColorFromHSV()
                    end
                end)
                
                Palette.InputChanged:Connect(function(input)
                    if paletteDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local pos = input.Position
                        local palettePos = Palette.AbsolutePosition
                        local paletteSize = Palette.AbsoluteSize
                        local x = math.clamp((pos.X - palettePos.X) / paletteSize.X, 0, 1)
                        local y = math.clamp((pos.Y - palettePos.Y) / paletteSize.Y, 0, 1)
                        currentSaturation = x
                        currentValue = 1 - y
                        paletteMarker.Position = UDim2.new(0, x * paletteSize.X - 3, 0, y * paletteSize.Y - 3)
                        UpdateColorFromHSV()
                    end
                end)
                
                Palette.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        paletteDragging = false
                    end
                end)
                
                HueBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        hueDragging = true
                        local pos = input.Position
                        local huePos = HueBar.AbsolutePosition
                        local hueSize = HueBar.AbsoluteSize
                        local y = math.clamp((pos.Y - huePos.Y) / hueSize.Y, 0, 1)
                        currentHue = 1 - y
                        hueMarker.Position = UDim2.new(0, -2, 0, y * hueSize.Y - 2)
                        UpdateColorFromHSV()
                    end
                end)
                
                HueBar.InputChanged:Connect(function(input)
                    if hueDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local pos = input.Position
                        local huePos = HueBar.AbsolutePosition
                        local hueSize = HueBar.AbsoluteSize
                        local y = math.clamp((pos.Y - huePos.Y) / hueSize.Y, 0, 1)
                        currentHue = 1 - y
                        hueMarker.Position = UDim2.new(0, -2, 0, y * hueSize.Y - 2)
                        UpdateColorFromHSV()
                    end
                end)
                
                HueBar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        hueDragging = false
                    end
                end)
                
                CloseButton.MouseButton1Click:Connect(function()
                    isPicking = false
                    ColorpickerPopup.Visible = false
                end)
                
                local h, s, v = currentColor:ToHSV()
                currentHue = h
                currentSaturation = s
                currentValue = v
                paletteMarker.Position = UDim2.new(0, s * Palette.AbsoluteSize.X - 3, 0, (1 - v) * Palette.AbsoluteSize.Y - 3)
                hueMarker.Position = UDim2.new(0, -2, 0, (1 - h) * HueBar.AbsoluteSize.Y - 2)
                Palette.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            end
            
            ColorPreview.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isPicking = not isPicking
                    if isPicking then
                        CreateColorpickerPopup()
                        ColorpickerPopup.Visible = true
                    else
                        if ColorpickerPopup then
                            ColorpickerPopup.Visible = false
                        end
                    end
                end
            end)
            
            local function SetValue(newColor)
                if typeof(newColor) == "Color3" then
                    currentColor = newColor
                    ColorPreview.BackgroundColor3 = currentColor
                    local h, s, v = newColor:ToHSV()
                    currentHue = h
                    currentSaturation = s
                    currentValue = v
                    if ColorpickerPopup then
                        paletteMarker.Position = UDim2.new(0, s * 140 - 3, 0, (1 - v) * 100 - 3)
                        hueMarker.Position = UDim2.new(0, -2, 0, (1 - h) * 100 - 2)
                        local palette = ColorpickerPopup:FindFirstChild("Palette")
                        if palette then
                            palette.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                        end
                        local preview = ColorpickerPopup:FindFirstChild("ColorPreview")
                        if preview then
                            preview.BackgroundColor3 = currentColor
                        end
                    end
                    spawn(function() Linux:SafeCallback(config.Callback, currentColor) end)
                end
            end
            
            spawn(function() Linux:SafeCallback(config.Callback, currentColor) end)
            
            Container.CanvasPosition = Vector2.new(0, 0)
            
            local element = {
                Type = "Colorpicker",
                Name = config.Name,
                Instance = ColorpickerFrame
            }
            table.insert(Tabs[tabIndex].Elements, element)
            table.insert(AllElements, {Tab = tabIndex, Element = element})
            
            return {
                Instance = ColorpickerFrame,
                SetValue = SetValue,
                GetValue = function() return currentColor end
            }
        end
        
        return TabElements
    end
    
    SearchBox.Changed:Connect(function(property)
        if property == "Text" then
            local searchText = string.lower(SearchBox.Text)
            
            for _, tab in pairs(Tabs) do
                local tabMatches = searchText == "" or string.find(string.lower(tab.Name), searchText) ~= nil
                local elementsMatch = false
                
                for _, element in pairs(tab.Elements) do
                    if searchText == "" then
                        element.Instance.Visible = true
                    else
                        local elementName = string.lower(element.Name or "")
                        element.Instance.Visible = string.find(elementName, searchText) ~= nil
                        if element.Instance.Visible then
                            elementsMatch = true
                        end
                    end
                end
                
                tab.Button.Visible = tabMatches or elementsMatch
            end
        end
    end)
    
    function LinuxLib.Destroy()
        for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
            if v:IsA("ScreenGui") and v.Name:match("^UI_%d+$") then
                v:Destroy()
            end
        end
    end
    
    if config.ConfigSave then
        LinuxLib.ConfigSystem = ConfigSystem
    end
    
    return LinuxLib
end

return Linux
