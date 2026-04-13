local Library = {}

local coreGui = game:GetService("CoreGui")
local existingGui = coreGui:FindFirstChild("xdd")
if existingGui then
    existingGui:Destroy()
end

local mainGui = Instance.new("ScreenGui")
mainGui.Parent = coreGui
mainGui.Name = "xdd"

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Consistent Color Palette (Blue Theme)
local Colors = {
    Primary = Color3.fromRGB(0, 120, 215),
    LightPrimary = Color3.fromRGB(100, 180, 255),
    DarkPrimary = Color3.fromRGB(0, 80, 150),
    Background = Color3.fromRGB(30, 30, 35),
    Text = Color3.fromRGB(240, 240, 240),
    Accent = Color3.fromRGB(150, 150, 150),
    Success = Color3.fromRGB(50, 200, 50),
    Danger = Color3.fromRGB(200, 50, 50)
}

-- Utility Functions
local function addCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
end

local function addStroke(instance, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness
    stroke.Color = color or Colors.Accent
    stroke.Transparency = 0.5
    stroke.Parent = instance
end

-- Main UI Creation
function Library:CreateUI(title, description)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = mainGui

    local Sound = Instance.new("Sound", game:GetService("SoundService"))
    Sound.SoundId = "rbxassetid://9120129807"
    Sound:Play()

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 590, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -295, 0.5, -150)
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    addCorner(MainFrame, 8)
    addStroke(MainFrame, 2)

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 60) -- Увеличена высота для размещения описания
    TopBar.BackgroundColor3 = Colors.DarkPrimary
    TopBar.BackgroundTransparency = 0.2
    TopBar.ZIndex = 10
    TopBar.Parent = MainFrame
    addCorner(TopBar, 6)

    local ResizeButton = Instance.new("TextButton")
    ResizeButton.Size = UDim2.new(0, 24, 0, 24)
    ResizeButton.Position = UDim2.new(1, -28, 1, -28)
    ResizeButton.BackgroundColor3 = Colors.LightPrimary
    ResizeButton.BackgroundTransparency = 0.5
    ResizeButton.Text = "↘"
    ResizeButton.TextSize = 14
    ResizeButton.Font = Enum.Font.Gotham
    ResizeButton.TextColor3 = Colors.Text
    ResizeButton.ZIndex = 15
    ResizeButton.Parent = MainFrame
    addCorner(ResizeButton, 4)

    local dragging, startPos, startSize
    ResizeButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = input.Position
            startSize = MainFrame.Size
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startPos
            MainFrame.Size = UDim2.new(0, math.max(300, startSize.X.Offset + delta.X), 0, math.max(200, startSize.Y.Offset + delta.Y))
        end
    end)

    local BackgroundOverlay = Instance.new("Frame")
    BackgroundOverlay.Size = UDim2.new(1, 0, 1, 0)
    BackgroundOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BackgroundOverlay.BackgroundTransparency = 0.6
    BackgroundOverlay.ZIndex = 18
    BackgroundOverlay.Visible = false
    BackgroundOverlay.Parent = MainFrame
    addCorner(BackgroundOverlay, 8)

    local SettingsFrame = Instance.new("Frame")
    SettingsFrame.Size = UDim2.new(0, 320, 0, 160)
    SettingsFrame.Position = UDim2.new(0.5, -160, 0.5, -80)
    SettingsFrame.BackgroundColor3 = Colors.Background
    SettingsFrame.BackgroundTransparency = 0.2
    SettingsFrame.ZIndex = 19
    SettingsFrame.Parent = BackgroundOverlay
    addCorner(SettingsFrame, 8)
    addStroke(SettingsFrame, 2)

    local SettingsLabel = Instance.new("TextLabel")
    SettingsLabel.Size = UDim2.new(1, 0, 0, 40)
    SettingsLabel.Text = "Settings"
    SettingsLabel.TextSize = 16
    SettingsLabel.Font = Enum.Font.GothamBold
    SettingsLabel.TextColor3 = Colors.Text
    SettingsLabel.BackgroundTransparency = 1
    SettingsLabel.ZIndex = 20
    SettingsLabel.Parent = SettingsFrame

    local Separator = Instance.new("Frame")
    Separator.Size = UDim2.new(1, -20, 0, 2)
    Separator.Position = UDim2.new(0, 10, 0, 40)
    Separator.BackgroundColor3 = Colors.Accent
    Separator.ZIndex = 20
    Separator.Parent = SettingsFrame

    local DestroyButton = Instance.new("TextButton")
    DestroyButton.Size = UDim2.new(0, 30, 0, 30)
    DestroyButton.Position = UDim2.new(1, -70, 0, 3)
    DestroyButton.BackgroundColor3 = Colors.Danger
    DestroyButton.BackgroundTransparency = 0.3
    DestroyButton.Text = "X"
    DestroyButton.TextSize = 20
    DestroyButton.Font = Enum.Font.GothamBold
    DestroyButton.TextColor3 = Colors.Text
    DestroyButton.ZIndex = 11
    DestroyButton.Parent = TopBar
    addCorner(DestroyButton, 6)

    local SettingsButton = Instance.new("TextButton")
    SettingsButton.Size = UDim2.new(0, 30, 0, 30)
    SettingsButton.Position = UDim2.new(1, -35, 0, 3)
    SettingsButton.BackgroundColor3 = Colors.Primary
    SettingsButton.BackgroundTransparency = 0.3
    SettingsButton.Text = "⚙️"
    SettingsButton.TextSize = 18
    SettingsButton.Font = Enum.Font.SourceSans
    SettingsButton.TextColor3 = Colors.Text
    SettingsButton.ZIndex = 11
    SettingsButton.Parent = TopBar
    addCorner(SettingsButton, 6)

    local ConfirmationOverlay = Instance.new("Frame")
    ConfirmationOverlay.Size = UDim2.new(1, 0, 1, 0)
    ConfirmationOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ConfirmationOverlay.BackgroundTransparency = 0.6
    ConfirmationOverlay.ZIndex = 18
    ConfirmationOverlay.Visible = false
    ConfirmationOverlay.Parent = MainFrame
    addCorner(ConfirmationOverlay, 8)

    local ConfirmationWindow = Instance.new("Frame")
    ConfirmationWindow.Size = UDim2.new(0, 320, 0, 160)
    ConfirmationWindow.Position = UDim2.new(0.5, -160, 0.5, -80)
    ConfirmationWindow.BackgroundColor3 = Colors.Background
    ConfirmationWindow.BackgroundTransparency = 0.2
    ConfirmationWindow.ZIndex = 19
    ConfirmationWindow.Parent = ConfirmationOverlay
    addCorner(ConfirmationWindow, 8)
    addStroke(ConfirmationWindow, 2)

    local ConfirmationText = Instance.new("TextLabel")
    ConfirmationText.Size = UDim2.new(1, 0, 0, 60)
    ConfirmationText.Text = "Are you sure you want to destroy the GUI?"
    ConfirmationText.TextSize = 14
    ConfirmationText.Font = Enum.Font.Gotham
    ConfirmationText.TextColor3 = Colors.Text
    ConfirmationText.BackgroundTransparency = 1
    ConfirmationText.TextWrapped = true
    ConfirmationText.ZIndex = 20
    ConfirmationText.Parent = ConfirmationWindow

    local ConfirmButton = Instance.new("TextButton")
    ConfirmButton.Size = UDim2.new(0.5, -10, 0, 40)
    ConfirmButton.Position = UDim2.new(0, 5, 1, -45)
    ConfirmButton.BackgroundColor3 = Colors.Danger
    ConfirmButton.Text = "Yes"
    ConfirmButton.TextSize = 16
    ConfirmButton.Font = Enum.Font.Gotham
    ConfirmButton.TextColor3 = Colors.Text
    ConfirmButton.ZIndex = 20
    ConfirmButton.Parent = ConfirmationWindow
    addCorner(ConfirmButton, 6)

    local CancelButton = Instance.new("TextButton")
    CancelButton.Size = UDim2.new(0.5, -10, 0, 40)
    CancelButton.Position = UDim2.new(0.5, 5, 1, -45)
    CancelButton.BackgroundColor3 = Colors.Success
    CancelButton.Text = "No"
    CancelButton.TextSize = 16
    CancelButton.Font = Enum.Font.Gotham
    CancelButton.TextColor3 = Colors.Text
    CancelButton.ZIndex = 20
    CancelButton.Parent = ConfirmationWindow
    addCorner(CancelButton, 6)

    DestroyButton.MouseButton1Click:Connect(function()
        ConfirmationOverlay.Visible = true
    end)

    ConfirmButton.MouseButton1Click:Connect(function()
        MainFrame:Destroy()
    end)

    CancelButton.MouseButton1Click:Connect(function()
        ConfirmationOverlay.Visible = false
    end)

    SettingsButton.MouseButton1Click:Connect(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://17208399163"
        sound.Volume = 0.5
        sound.PlayOnRemove = true
        sound.Parent = SettingsButton
        sound:Destroy()
        BackgroundOverlay.Visible = not BackgroundOverlay.Visible
    end)

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 50, 0, 50)
    ToggleButton.Position = UDim2.new(0.14, 0, 0.1, 0)
    ToggleButton.BackgroundColor3 = Colors.Primary
    ToggleButton.BackgroundTransparency = 0.7
    ToggleButton.Text = "👀" -- Изменено на эмодзи глаз
    ToggleButton.TextSize = 20
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextColor3 = Colors.Text
    ToggleButton.Draggable = true
    ToggleButton.Parent = ScreenGui
    addCorner(ToggleButton, 8)
    addStroke(ToggleButton, 2)

    local isActive = true
    ToggleButton.MouseButton1Click:Connect(function()
        isActive = not isActive
        MainFrame.Visible = isActive
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://10066968815"
        sound.Parent = ToggleButton
        sound:Play()
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 60, 0, 60)}):Play()
        task.wait(0.2)
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 50, 0, 50)}):Play()
    end)

    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, 0, 0, 2)
    Line.Position = UDim2.new(0, 0, 1, -2)
    Line.BackgroundColor3 = Colors.Accent
    Line.ZIndex = 12
    Line.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 300, 0, 20)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 11
    TitleLabel.Parent = TopBar

    local DescriptionLabel = Instance.new("TextLabel")
    DescriptionLabel.Size = UDim2.new(0, 300, 0, 20)
    DescriptionLabel.Position = UDim2.new(0, 10, 0, 25)
    DescriptionLabel.BackgroundTransparency = 1
    DescriptionLabel.Text = description
    DescriptionLabel.TextSize = 14
    DescriptionLabel.Font = Enum.Font.Gotham
    DescriptionLabel.TextColor3 = Colors.Text
    DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescriptionLabel.ZIndex = 11
    DescriptionLabel.Parent = TopBar

    local TabsContainer = Instance.new("ScrollingFrame")
    TabsContainer.Size = UDim2.new(0.3, 0, 1, -64)
    TabsContainer.Position = UDim2.new(0, 5, 0, 64)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabsContainer.ScrollBarThickness = 0
    TabsContainer.Parent = MainFrame
    addCorner(TabsContainer, 6)

    local TabsListLayout = Instance.new("UIListLayout")
    TabsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsListLayout.Padding = UDim.new(0, 12)
    TabsListLayout.Parent = TabsContainer

    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 8)
    Padding.PaddingRight = UDim.new(0, 8)
    Padding.Parent = TabsContainer

    TabsListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabsContainer.CanvasSize = UDim2.new(0, 0, 0, TabsListLayout.AbsoluteContentSize.Y + 16)
    end)

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(0.7, -10, 1, -64)
    Container.Position = UDim2.new(0.3, 5, 0, 64)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame
    addCorner(Container, 6)

    local Tab = {TabsContainer = TabsContainer, Container = Container}

    function Tab:AddTab(isPremium, tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, -16, 0, 40)
        TabButton.Text = tabName
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 16
        TabButton.BackgroundColor3 = Colors.Primary
        TabButton.BackgroundTransparency = 0.5
        TabButton.TextColor3 = Colors.Text
        TabButton.Parent = TabsContainer
        addCorner(TabButton, 6)
        addStroke(TabButton, 2)

        local TabFrame = Instance.new("Frame")
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.Visible = false
        TabFrame.Parent = Container

        local FrameScroll = Instance.new("ScrollingFrame")
        FrameScroll.Size = UDim2.new(1, -10, 1, -10)
        FrameScroll.Position = UDim2.new(0, 5, 0, 5)
        FrameScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        FrameScroll.ScrollBarThickness = 0
        FrameScroll.BackgroundTransparency = 1
        FrameScroll.Parent = TabFrame
        addCorner(FrameScroll, 6)

        local ButtonLayout = Instance.new("UIListLayout")
        ButtonLayout.Padding = UDim.new(0, 12)
        ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ButtonLayout.Parent = FrameScroll

        local Padding = Instance.new("UIPadding")
        Padding.PaddingLeft = UDim.new(0, 8)
        Padding.PaddingRight = UDim.new(0, 8)
        Padding.Parent = FrameScroll

        ButtonLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            FrameScroll.CanvasSize = UDim2.new(0, 0, 0, ButtonLayout.AbsoluteContentSize.Y + 16)
        end)

        TabButton.MouseButton1Click:Connect(function()
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://16480549841"
            sound.Volume = 0.5
            sound.PlayOnRemove = true
            sound.Parent = TabButton
            sound:Destroy()

            for _, button in pairs(TabsContainer:GetChildren()) do
                if button:IsA("TextButton") then
                    button.BackgroundColor3 = Colors.Primary
                    button.BackgroundTransparency = 0.5
                end
            end
            TabButton.BackgroundColor3 = Colors.LightPrimary
            TabButton.BackgroundTransparency = 0.2

            for _, frame in pairs(Container:GetChildren()) do
                if frame:IsA("Frame") then frame.Visible = false end
            end
            TabFrame.Visible = true
        end)

        return FrameScroll
    end

    return Tab
end

-- UI Elements
function Library.addButton(container, buttonText, descriptionText, callback)
    if not container then
        error("Container is nil. Please provide a valid container for the button.")
    end

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 50)
    Button.Text = buttonText
    Button.TextSize = 16
    Button.Font = Enum.Font.Gotham
    Button.BackgroundColor3 = Colors.Primary
    Button.BackgroundTransparency = 0.5
    Button.TextColor3 = Colors.Text
    Button.Parent = container
    addCorner(Button, 6)
    addStroke(Button, 2)

    local Description = Instance.new("TextLabel")
    Description.Size = UDim2.new(1, -20, 0, 20)
    Description.Position = UDim2.new(0, 10, 0, 25)
    Description.Text = descriptionText or ""
    Description.TextSize = 12
    Description.Font = Enum.Font.Gotham
    Description.BackgroundTransparency = 1
    Description.TextColor3 = Colors.Text
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.Parent = Button

    Button.MouseEnter:Connect(function()
        Button.BackgroundTransparency = 0.3
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundTransparency = 0.5
    end)

    Button.MouseButton1Click:Connect(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://99437156604053"
        sound.Volume = 0.5
        sound.PlayOnRemove = true
        sound.Parent = Button
        sound:Destroy()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Colors.LightPrimary}):Play()
        task.wait(0.2)
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Primary}):Play()
        callback()
    end)

    return Button, Description
end

function Library.AddColorPicker(container, labelText, defaultColor, callback)
    if not container then
        error("Container is nil. Please provide a valid container for the color picker.")
    end

    local ColorPicker = Instance.new("Frame")
    ColorPicker.Size = UDim2.new(1, 0, 0, 50)
    ColorPicker.BackgroundColor3 = Colors.Background
    ColorPicker.BackgroundTransparency = 0.5
    ColorPicker.Parent = container
    addCorner(ColorPicker, 6)
    addStroke(ColorPicker, 2)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Text = labelText
    Label.TextSize = 16
    Label.Font = Enum.Font.Gotham
    Label.TextColor3 = Colors.Text
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Parent = ColorPicker

    local PickerFrame = Instance.new("Frame")
    PickerFrame.Size = UDim2.new(0, 120, 0, 30)
    PickerFrame.Position = UDim2.new(1, -130, 0.5, -15)
    PickerFrame.BackgroundColor3 = defaultColor or Colors.Primary
    PickerFrame.Parent = ColorPicker
    addCorner(PickerFrame, 6)

    local OpenButton = Instance.new("TextButton")
    OpenButton.Size = UDim2.new(1, 0, 1, 0)
    OpenButton.Text = ""
    OpenButton.BackgroundTransparency = 1
    OpenButton.Parent = PickerFrame

    local Popup = Instance.new("Frame")
    Popup.Size = UDim2.new(0, 300, 0, 160)
    Popup.Position = UDim2.new(0.5, -150, 0.5, -80)
    Popup.BackgroundColor3 = Colors.Background
    Popup.BackgroundTransparency = 0.2
    Popup.Visible = false
    Popup.ZIndex = 10
    Popup.Parent = container
    addCorner(Popup, 8)
    addStroke(Popup, 2)

    local ColorWheel = Instance.new("ImageLabel")
    ColorWheel.Size = UDim2.new(0, 140, 0, 140)
    ColorWheel.Position = UDim2.new(0.5, -70, 0, 10)
    ColorWheel.Image = "rbxassetid://142488478"
    ColorWheel.BackgroundTransparency = 1
    ColorWheel.Active = true
    ColorWheel.ZIndex = 11
    ColorWheel.Parent = Popup

    local Selector = Instance.new("Frame")
    Selector.Size = UDim2.new(0, 10, 0, 10)
    Selector.BackgroundColor3 = Colors.Text
    Selector.ZIndex = 12
    Selector.Parent = ColorWheel
    addCorner(Selector, 5)

    local ConfirmButton = Instance.new("TextButton")
    ConfirmButton.Size = UDim2.new(0.5, -10, 0, 30)
    ConfirmButton.Position = UDim2.new(0, 5, 1, -35)
    ConfirmButton.Text = "Confirm"
    ConfirmButton.TextSize = 14
    ConfirmButton.Font = Enum.Font.Gotham
    ConfirmButton.TextColor3 = Colors.Text
    ConfirmButton.BackgroundColor3 = Colors.Success
    ConfirmButton.ZIndex = 11
    ConfirmButton.Parent = Popup
    addCorner(ConfirmButton, 6)

    local RainbowButton = Instance.new("TextButton")
    RainbowButton.Size = UDim2.new(0.5, -10, 0, 30)
    RainbowButton.Position = UDim2.new(0.5, 5, 1, -35)
    RainbowButton.Text = "Rainbow"
    RainbowButton.TextSize = 14
    RainbowButton.Font = Enum.Font.Gotham
    RainbowButton.TextColor3 = Colors.Text
    RainbowButton.BackgroundColor3 = Colors.Primary
    RainbowButton.ZIndex = 11
    RainbowButton.Parent = Popup
    addCorner(RainbowButton, 6)

    local rainbowActive = false
    local rainbowConnection

    local function updateColor(input)
        local pos = Vector2.new(input.Position.X, input.Position.Y) - ColorWheel.AbsolutePosition
        local x = math.clamp(pos.X / ColorWheel.AbsoluteSize.X, 0, 1)
        local y = math.clamp(pos.Y / ColorWheel.AbsoluteSize.Y, 0, 1)
        Selector.Position = UDim2.new(x, -5, y, -5)
        PickerFrame.BackgroundColor3 = Color3.fromHSV(x, 1 - y, 1)
        if callback then callback(PickerFrame.BackgroundColor3) end
    end

    ColorWheel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateColor(input)
            local conn
            conn = UserInputService.InputChanged:Connect(function(moveInput)
                if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
                    updateColor(moveInput)
                end
            end)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then conn:Disconnect() end
            end)
        end
    end)

    ConfirmButton.MouseButton1Click:Connect(function()
        Popup.Visible = false
        if callback then callback(PickerFrame.BackgroundColor3) end
    end)

    RainbowButton.MouseButton1Click:Connect(function()
        rainbowActive = not rainbowActive
        RainbowButton.BackgroundColor3 = rainbowActive and Colors.DarkPrimary or Colors.Primary
        if rainbowActive then
            local step = 0
            rainbowConnection = game:GetService("RunService").RenderStepped:Connect(function(delta)
                step = (step + delta * 0.5) % 1
                local color = Color3.fromHSV(step, 1, 1)
                PickerFrame.BackgroundColor3 = color
                if callback then callback(color) end
            end)
        else
            if rainbowConnection then rainbowConnection:Disconnect() end
        end
    end)

    OpenButton.MouseButton1Click:Connect(function()
        Popup.Visible = not Popup.Visible
    end)

    return ColorPicker
end

function Library.addToggle(container, labelText, descriptionText, defaultState, callback)
    if not container then
        error("Container is nil. Please provide a valid container for the toggle.")
    end

    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
    ToggleFrame.BackgroundColor3 = Colors.Background
    ToggleFrame.BackgroundTransparency = 0.5
    ToggleFrame.Parent = container
    addCorner(ToggleFrame, 6)
    addStroke(ToggleFrame, 2)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -80, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.Text = labelText
    Label.TextSize = 16
    Label.Font = Enum.Font.Gotham
    Label.TextColor3 = Colors.Text
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local Description = Instance.new("TextLabel")
    Description.Size = UDim2.new(1, -80, 0, 20)
    Description.Position = UDim2.new(0, 10, 0, 25)
    Description.Text = descriptionText or ""
    Description.TextSize = 12
    Description.Font = Enum.Font.Gotham
    Description.BackgroundTransparency = 1
    Description.TextColor3 = Colors.Text
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.Parent = ToggleFrame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 50, 0, 24)
    ToggleButton.Position = UDim2.new(1, -60, 0.5, -12)
    ToggleButton.BackgroundColor3 = Colors.Primary
    ToggleButton.BackgroundTransparency = 0.5
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    addCorner(ToggleButton, 12)

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 20, 0, 20)
    Indicator.BackgroundColor3 = defaultState and Colors.Success or Colors.Danger
    Indicator.Position = UDim2.new(defaultState and 0.6 or 0.1, 0, 0.5, -10)
    Indicator.Parent = ToggleButton
    addCorner(Indicator, 10)

    local function updateToggle(state)
        TweenService:Create(Indicator, TweenInfo.new(0.2), {
            Position = UDim2.new(state and 0.6 or 0.1, 0, 0.5, -10),
            BackgroundColor3 = state and Colors.Success or Colors.Danger
        }):Play()
        callback(state)
    end

    ToggleButton.MouseButton1Click:Connect(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://99437156604053"
        sound.Volume = 0.5
        sound.PlayOnRemove = true
        sound.Parent = ToggleButton
        sound:Destroy()
        defaultState = not defaultState
        updateToggle(defaultState)
    end)

    updateToggle(defaultState)
    return ToggleFrame, Description
end

function Library.addSlider(container, name, descriptionText, minValue, maxValue, defaultValue, callback)
    if not container then
        error("Container is nil. Please provide a valid container for the slider.")
    end

    local hasDescription = descriptionText and descriptionText ~= ""
    local frameHeight = hasDescription and 70 or 50

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, frameHeight)
    SliderFrame.BackgroundColor3 = Colors.Background
    SliderFrame.BackgroundTransparency = 0.5
    SliderFrame.Parent = container
    addCorner(SliderFrame, 6)
    addStroke(SliderFrame, 2)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -80, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.Text = name
    Label.TextSize = 16
    Label.Font = Enum.Font.Gotham
    Label.TextColor3 = Colors.Text
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    if hasDescription then
        local Description = Instance.new("TextLabel")
        Description.Size = UDim2.new(1, -80, 0, 20)
        Description.Position = UDim2.new(0, 10, 0, 25)
        Description.Text = descriptionText
        Description.TextSize = 12
        Description.Font = Enum.Font.Gotham
        Description.BackgroundTransparency = 1
        Description.TextColor3 = Colors.Text
        Description.TextXAlignment = Enum.TextXAlignment.Left
        Description.Parent = SliderFrame
    end

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0, 60, 0, 24)
    TextBox.Position = UDim2.new(1, -70, 0, 5)
    TextBox.Text = tostring(defaultValue)
    TextBox.TextSize = 14
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextColor3 = Colors.Text
    TextBox.BackgroundColor3 = Colors.DarkPrimary
    TextBox.BackgroundTransparency = 0.5
    TextBox.TextXAlignment = Enum.TextXAlignment.Center
    TextBox.Parent = SliderFrame
    addCorner(TextBox, 6)

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -80, 0, 8)
    Track.Position = UDim2.new(0, 10, 1, hasDescription and -14 or -14)
    Track.BackgroundColor3 = Colors.DarkPrimary
    Track.Parent = SliderFrame
    addCorner(Track, 4)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Colors.Primary
    Fill.Parent = Track
    addCorner(Fill, 4)

    local Thumb = Instance.new("Frame")
    Thumb.Size = UDim2.new(0, 24, 0, 24)
    Thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    Thumb.BackgroundColor3 = Colors.LightPrimary
    Thumb.Position = UDim2.new(0, 0, 0.5, 0)
    Thumb.ZIndex = 2
    Thumb.Parent = Track
    addCorner(Thumb, 12)

    local function update(value)
        value = math.clamp(math.floor(value + 0.5), minValue, maxValue)
        local ratio = (value - minValue) / (maxValue - minValue)
        Fill.Size = UDim2.new(ratio, 0, 1, 0)
        Thumb.Position = UDim2.new(ratio, 0, 0.5, 0)
        TextBox.Text = tostring(value)
        if callback then
            callback(value)
        end
    end

    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local function move(moveInput)
                local x = math.clamp((moveInput.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                update(minValue + x * (maxValue - minValue))
            end
            move(input)
            local conn = UserInputService.InputChanged:Connect(function(moveInput)
                if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
                    move(moveInput)
                end
            end)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then conn:Disconnect() end
            end)
        end
    end)

    TextBox.FocusLost:Connect(function()
        local val = tonumber(TextBox.Text)
        if val then
            update(val)
        else
            update(defaultValue)
        end
    end)

    update(defaultValue)
end

function Library.addDropdown(container, labelText, buttonText, options, callback)
    if not container then
        error("Container is nil. Please provide a valid container for the dropdown.")
    end

    local Dropdown = Instance.new("Frame")
    Dropdown.Size = UDim2.new(1, 0, 0, 50)
    Dropdown.BackgroundColor3 = Colors.Background
    Dropdown.BackgroundTransparency = 0.5
    Dropdown.Parent = container
    addCorner(Dropdown, 6)
    addStroke(Dropdown, 2)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = labelText
    Label.TextSize = 16
    Label.Font = Enum.Font.Gotham
    Label.TextColor3 = Colors.Text
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Dropdown

    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(0, 120, 0, 30)
    DropdownButton.Position = UDim2.new(1, -130, 0.5, -15)
    DropdownButton.Text = buttonText
    DropdownButton.TextSize = 14
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.TextColor3 = Colors.Text
    DropdownButton.BackgroundColor3 = Colors.Primary
    DropdownButton.BackgroundTransparency = 0.5
    DropdownButton.Parent = Dropdown
    addCorner(DropdownButton, 6)

    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 20, 1, 0)
    Arrow.Position = UDim2.new(1, -20, 0, 0)
    Arrow.Text = "▼"
    Arrow.TextSize = 14
    Arrow.Font = Enum.Font.Gotham
    Arrow.TextColor3 = Colors.Text
    Arrow.BackgroundTransparency = 1
    Arrow.Parent = DropdownButton

    local DropdownList = Instance.new("Frame")
    DropdownList.Size = UDim2.new(0, 120, 0, 0)
    DropdownList.BackgroundColor3 = Colors.DarkPrimary
    DropdownList.BackgroundTransparency = 0.2
    DropdownList.ClipsDescendants = true
    DropdownList.Visible = false
    DropdownList.Parent = container
    addCorner(DropdownList, 6)

    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.ScrollBarThickness = 0
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.Parent = DropdownList

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 4)
    Layout.Parent = ScrollFrame

    local function updateSize()
        local height = math.min(Layout.AbsoluteContentSize.Y, 120)
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
        return height
    end

    local function createOptions(options)
        for _, child in pairs(ScrollFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for _, option in pairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.Text = option
            OptionButton.TextSize = 14
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.TextColor3 = Colors.Text
            OptionButton.BackgroundColor3 = Colors.Primary
            OptionButton.BackgroundTransparency = 0.5
            OptionButton.Parent = ScrollFrame
            addCorner(OptionButton, 4)

            OptionButton.MouseEnter:Connect(function()
                OptionButton.BackgroundTransparency = 0.3
            end)
            OptionButton.MouseLeave:Connect(function()
                OptionButton.BackgroundTransparency = 0.5
            end)

            OptionButton.MouseButton1Click:Connect(function()
                DropdownButton.Text = option
                DropdownList.Visible = false
                Arrow.Text = "▼"
                if callback then callback(option) end
            end)
        end
    end

    createOptions(options)

    DropdownButton.MouseButton1Click:Connect(function()
        if DropdownList.Visible then
            TweenService:Create(DropdownList, TweenInfo.new(0.3), {Size = UDim2.new(0, 120, 0, 0)}):Play()
            task.wait(0.3)
            DropdownList.Visible = false
            Arrow.Text = "▼"
        else
            local absPos = Dropdown.AbsolutePosition
            DropdownList.Position = UDim2.new(0, absPos.X + Dropdown.Size.X.Offset - 130, 0, absPos.Y + 50)
            DropdownList.Visible = true
            local height = updateSize()
            TweenService:Create(DropdownList, TweenInfo.new(0.3), {Size = UDim2.new(0, 120, 0, height)}):Play()
            Arrow.Text = "▲"
        end
    end)

    function Library.updateDropdownOptions(newOptions)
        createOptions(newOptions)
    end
end

function Library.addTextbox(container, labelText, placeholderText, defaultText, callback)
    if not container then
        error("Container is nil. Please provide a valid container for the textbox.")
    end

    local TextboxFrame = Instance.new("Frame")
    TextboxFrame.Size = UDim2.new(1, 0, 0, 50)
    TextboxFrame.BackgroundColor3 = Colors.Background
    TextboxFrame.BackgroundTransparency = 0.5
    TextboxFrame.Parent = container
    addCorner(TextboxFrame, 6)
    addStroke(TextboxFrame, 2)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = labelText
    Label.TextSize = 16
    Label.Font = Enum.Font.Gotham
    Label.TextColor3 = Colors.Text
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = TextboxFrame

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0, 120, 0, 30)
    TextBox.Position = UDim2.new(1, -130, 0.5, -15)
    TextBox.Text = defaultText
    TextBox.PlaceholderText = placeholderText
    TextBox.TextSize = 14
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextColor3 = Colors.Text
    TextBox.BackgroundColor3 = Colors.DarkPrimary
    TextBox.BackgroundTransparency = 0.5
    TextBox.Parent = TextboxFrame
    addCorner(TextBox, 6)

    TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed and callback then callback(TextBox.Text) end
    end)
end

function Library.addParagraph(container, text)
    if not container then
        error("Container is nil. Please provide a valid container for the paragraph.")
    end

    local ParagraphFrame = Instance.new("Frame")
    ParagraphFrame.Size = UDim2.new(1, 0, 0, 50)
    ParagraphFrame.BackgroundTransparency = 1
    ParagraphFrame.Parent = container

    local ParagraphLabel = Instance.new("TextLabel")
    ParagraphLabel.Size = UDim2.new(1, -20, 1, 0)
    ParagraphLabel.Position = UDim2.new(0, 10, 0, 0)
    ParagraphLabel.Text = text
    ParagraphLabel.TextWrapped = true
    ParagraphLabel.TextSize = 14
    ParagraphLabel.Font = Enum.Font.Gotham
    ParagraphLabel.TextColor3 = Colors.Text
    ParagraphLabel.BackgroundTransparency = 1
    ParagraphLabel.TextXAlignment = Enum.TextXAlignment.Left
    ParagraphLabel.Parent = ParagraphFrame
end

function Library.addSection(container, title)
    if not container then
        error("Container is nil. Please provide a valid container for the section.")
    end

    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, 0, 0, 40)
    Section.BackgroundColor3 = Colors.DarkPrimary
    Section.BackgroundTransparency = 0.5
    Section.Parent = container
    addCorner(Section, 6)

    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Size = UDim2.new(1, 0, 1, 0)
    SectionLabel.Text = title or "Section"
    SectionLabel.TextSize = 16
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.TextColor3 = Colors.Text
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Center
    SectionLabel.Parent = Section
end

function Library.addLabel(container, text)
    if not container then
        error("Container is nil. Please provide a valid container for the label.")
    end

    local LabelFrame = Instance.new("Frame")
    LabelFrame.Size = UDim2.new(1, 0, 0, 50)
    LabelFrame.BackgroundColor3 = Colors.Background
    LabelFrame.BackgroundTransparency = 0.5
    LabelFrame.Parent = container
    addCorner(LabelFrame, 6)
    addStroke(LabelFrame, 2)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = text
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextColor3 = Colors.Text
    Label.BackgroundTransparency = 1
    Label.Parent = LabelFrame

    local labelObject = {Label = Label}
    function labelObject:Set(newText)
        self.Label.Text = newText
    end
    return labelObject
end

function Library.AddKeybind(container, text, defaultKey, callback)
    if not container then
        error("Container is nil. Please provide a valid container for the keybind.")
    end

    local KeybindFrame = Instance.new("Frame")
    KeybindFrame.Size = UDim2.new(1, 0, 0, 50)
    KeybindFrame.BackgroundColor3 = Colors.Background
    KeybindFrame.BackgroundTransparency = 0.5
    KeybindFrame.Parent = container
    addCorner(KeybindFrame, 6)
    addStroke(KeybindFrame, 2)

    local KeybindTitle = Instance.new("TextLabel")
    KeybindTitle.Size = UDim2.new(0.5, 0, 1, 0)
    KeybindTitle.Position = UDim2.new(0, 10, 0, 0)
    KeybindTitle.Text = text
    KeybindTitle.TextSize = 16
    KeybindTitle.Font = Enum.Font.Gotham
    KeybindTitle.TextColor3 = Colors.Text
    KeybindTitle.BackgroundTransparency = 1
    KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left
    KeybindTitle.Parent = KeybindFrame

    local KeybindButton = Instance.new("TextButton")
    KeybindButton.Size = UDim2.new(0, 120, 0, 30)
    KeybindButton.Position = UDim2.new(1, -130, 0.5, -15)
    KeybindButton.Text = defaultKey.Name
    KeybindButton.TextSize = 14
    KeybindButton.Font = Enum.Font.Gotham
    KeybindButton.TextColor3 = Colors.Text
    KeybindButton.BackgroundColor3 = Colors.Primary
    KeybindButton.BackgroundTransparency = 0.5
    KeybindButton.Parent = KeybindFrame
    addCorner(KeybindButton, 6)

    local listening = false
    KeybindButton.MouseButton1Click:Connect(function()
        listening = true
        KeybindButton.Text = "Press a key..."
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if listening and not gameProcessed then
            local key = input.KeyCode.Name
            KeybindButton.Text = key
            callback(key)
            listening = false
        end
    end)
end

return Library
