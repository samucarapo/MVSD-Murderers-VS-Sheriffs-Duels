if game.PlaceId ~= 12355337193 then return end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ShootGun = Remotes:WaitForChild("ShootGun")
local ThrowStart = Remotes:WaitForChild("ThrowStart")
local ThrowHit = Remotes:WaitForChild("ThrowHit")

local Existing = PlayerGui:FindFirstChild("CombatTestUI")
if Existing then
    Existing:Destroy()
end

local Theme = {
    Background = Color3.fromRGB(13, 16, 14),
    Panel = Color3.fromRGB(22, 27, 23),
    Button = Color3.fromRGB(31, 38, 32),
    Green = Color3.fromRGB(145, 255, 0),
    White = Color3.fromRGB(240, 245, 240),
    Gray = Color3.fromRGB(130, 140, 132),
    Red = Color3.fromRGB(255, 75, 75)
}

local WIDTH = 170
local HEIGHT = 210

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CombatTestUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 20
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(WIDTH, HEIGHT)
Main.Position = UDim2.new(0, 20, 0.35, 0)
Main.BackgroundColor3 = Theme.Background
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Green
MainStroke.Thickness = 1.2
MainStroke.Transparency = 0.1
MainStroke.Parent = Main

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 28)
Header.BackgroundColor3 = Theme.Panel
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 6)
HeaderCorner.Parent = Header

local HeaderCover = Instance.new("Frame")
HeaderCover.Size = UDim2.new(1, 0, 0, 6)
HeaderCover.Position = UDim2.new(0, 0, 1, -6)
HeaderCover.BackgroundColor3 = Theme.Panel
HeaderCover.BorderSizePixel = 0
HeaderCover.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.fromOffset(8, 0)
Title.BackgroundTransparency = 1
Title.Text = "COMBAT TEST"
Title.TextColor3 = Theme.White
Title.TextStrokeColor3 = Theme.Green
Title.TextStrokeTransparency = 0.55
Title.Font = Enum.Font.Arcade
Title.TextSize = 10
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local function CreateHeaderButton(Text, Position, Color)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.fromOffset(20, 18)
    Button.Position = Position
    Button.BackgroundColor3 = Theme.Button
    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 = Color
    Button.TextStrokeColor3 = Theme.Green
    Button.TextStrokeTransparency = 0.65
    Button.Font = Enum.Font.Arcade
    Button.TextSize = 10
    Button.AutoButtonColor = true
    Button.Parent = Header

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Button

    return Button
end

local MinimizeButton = CreateHeaderButton(
    "-", UDim2.new(1, -46, 0, 5), Theme.Green
)

local CloseButton = CreateHeaderButton(
    "X", UDim2.new(1, -24, 0, 5), Theme.Red
)

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -16, 0, 14)
Status.Position = UDim2.fromOffset(8, 32)
Status.BackgroundTransparency = 1
Status.Text = "STATUS: READY"
Status.TextColor3 = Theme.Green
Status.Font = Enum.Font.Arcade
Status.TextSize = 8
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Main

local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(1, -16, 0, 22)
Tabs.Position = UDim2.fromOffset(8, 50)
Tabs.BackgroundTransparency = 1
Tabs.Parent = Main

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 6)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = Tabs

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -16, 1, -80)
Content.Position = UDim2.fromOffset(8, 76)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Pages = {}

local function CreatePage(Name)
    local Page = Instance.new("Frame")
    Page.Name = Name
    Page.Size = UDim2.fromScale(1, 1)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = Content

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 5)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Page

    Pages[Name] = Page
    return Page
end

local CombatPage = CreatePage("COMBAT")
local VisualPage = CreatePage("VISUAL")

local function CreateTab(Name)
    local Button = Instance.new("TextButton")
    Button.Name = Name .. "Tab"
    Button.Size = UDim2.new(0.5, -3, 1, 0)
    Button.BackgroundColor3 = Theme.Button
    Button.BorderSizePixel = 0
    Button.Text = Name
    Button.TextColor3 = Theme.Gray
    Button.TextStrokeColor3 = Theme.Green
    Button.TextStrokeTransparency = 0.7
    Button.Font = Enum.Font.Arcade
    Button.TextSize = 8
    Button.AutoButtonColor = true
    Button.Parent = Tabs

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Button

    return Button
end

local CombatTab = CreateTab("COMBAT")
local VisualTab = CreateTab("VISUAL")

local function SetPage(Name)
    for PageName, Page in pairs(Pages) do
        Page.Visible = PageName == Name
    end

    CombatTab.TextColor3 =
        Name == "COMBAT" and Theme.Green or Theme.Gray

    VisualTab.TextColor3 =
        Name == "VISUAL" and Theme.Green or Theme.Gray
end

CombatTab.Activated:Connect(function()
    SetPage("COMBAT")
end)

VisualTab.Activated:Connect(function()
    SetPage("VISUAL")
end)

local States = {}

local function CreateActionButton(Parent, Name, Callback)
    local Button = Instance.new("TextButton")
    Button.Name = Name
    Button.Size = UDim2.new(1, 0, 0, 26)
    Button.BackgroundColor3 = Theme.Button
    Button.BorderSizePixel = 0
    Button.Text = Name
    Button.TextColor3 = Theme.White
    Button.TextStrokeColor3 = Theme.Green
    Button.TextStrokeTransparency = 0.7
    Button.Font = Enum.Font.Arcade
    Button.TextSize = 9
    Button.AutoButtonColor = true
    Button.Parent = Parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Button

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme.Gray
    Stroke.Thickness = 1
    Stroke.Transparency = 0.45
    Stroke.Parent = Button

    Button.Activated:Connect(function()
        if not Callback then
            return
        end

        local Success = pcall(Callback)

        if Success then
            Status.Text = "STATUS: ACTION SENT"
            Status.TextColor3 = Theme.Green
        else
            Status.Text = "STATUS: ACTION FAILED"
            Status.TextColor3 = Theme.Red
        end
    end)

    return Button
end

local function CreateToggle(Parent, Name, Default, Callback)
    States[Name] = Default

    local Button = CreateActionButton(Parent, Name, nil)

    local function Refresh()
        Button.Text = Name .. ": " ..
            (States[Name] and "ON" or "OFF")

        Button.TextColor3 =
            States[Name] and Theme.Green or Theme.White

        Button.TextStrokeTransparency = 0.7
    end

    Button.Activated:Connect(function()
        States[Name] = not States[Name]
        Refresh()

        if Callback then
            local Success = pcall(Callback, States[Name])

            if not Success then
                Status.Text = "STATUS: ACTION FAILED"
                Status.TextColor3 = Theme.Red
            end
        end
    end)

    Refresh()
    return Button
end

local function GetNearestPlayer()
    local Character = LocalPlayer.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return nil
    end

    local Nearest
    local ShortestDistance = math.huge

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local TargetCharacter = Player.Character

            local TargetRoot = TargetCharacter
                and TargetCharacter:FindFirstChild("HumanoidRootPart")

            local Humanoid = TargetCharacter
                and TargetCharacter:FindFirstChildOfClass("Humanoid")

            if TargetRoot and Humanoid and Humanoid.Health > 0 then
                local Distance =
                    (Root.Position - TargetRoot.Position).Magnitude

                if Distance < ShortestDistance then
                    ShortestDistance = Distance
                    Nearest = Player
                end
            end
        end
    end

    return Nearest
end

local function GetTargetPart(Target)
    if not Target then
        return nil, nil
    end

    local Character = Target.Character

    if not Character then
        return nil, nil
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local Root = Character:FindFirstChild("HumanoidRootPart")

    if not Humanoid or not Root or Humanoid.Health <= 0 then
        return nil, nil
    end

    local Head = Character:FindFirstChild("Head")

    if Head then
        local HeadPart = Head:FindFirstChild("Part")

        if HeadPart then
            return HeadPart, Root
        end

        return Head, Root
    end

    return Root, Root
end

local function GetMuzzlePosition()
    local Character = LocalPlayer.Character

    if not Character then
        return nil
    end

    local Tool = Character:FindFirstChildOfClass("Tool")

    if Tool then
        local Handle = Tool:FindFirstChild("Handle")

        if Handle then
            local Muzzle = Handle:FindFirstChild("Muzzle")

            if Muzzle and Muzzle:IsA("Attachment") then
                return Muzzle.WorldPosition
            end

            return Handle.Position
        end
    end

    local Head = Character:FindFirstChild("Head")
    return Head and Head.Position or nil
end

local function TestGun()
    local Target = GetNearestPlayer()
    local TargetPart = GetTargetPart(Target)

    if not TargetPart then
        error("No valid target")
    end

    local HitPos = TargetPart.Position

    local OriginPos

    if States["WALLBANG"] then
        OriginPos = HitPos + Vector3.new(0, 0.25, 0)
    else
        OriginPos = GetMuzzlePosition()

        if not OriginPos then
            error("Muzzle not found")
        end
    end

    ShootGun:FireServer(OriginPos, HitPos, TargetPart, HitPos)
end

local function TestKnife()
    local Target = GetNearestPlayer()
    local TargetPart = GetTargetPart(Target)

    if not TargetPart then
        error("No valid target")
    end

    local HitPos = TargetPart.Position

    local OriginPos

    if States["WALLBANG"] then
        OriginPos = HitPos + Vector3.new(0, 0.25, 0)
    else
        OriginPos = GetMuzzlePosition()

        if not OriginPos then
            error("Muzzle not found")
        end
    end

    local Direction = (HitPos - OriginPos).Unit

    ThrowStart:FireServer(OriginPos, Direction)

    local Delay = States["WALLBANG"] and 0.05 or 0.15

    task.wait(Delay)

    ThrowHit:FireServer(TargetPart, HitPos)
end

local HighlightsEnabled = false
local Highlights = {}

local function UpdateHighlight(Player)
    if Player == LocalPlayer then
        return
    end

    local Character = Player.Character

    if not Character then
        return
    end

    if Highlights[Player] then
        Highlights[Player]:Destroy()
        Highlights[Player] = nil
    end

    if HighlightsEnabled then
        local Highlight = Instance.new("Highlight")
        Highlight.Name = "PlayerESP"
        Highlight.FillColor = Theme.Green
        Highlight.OutlineColor = Theme.White
        Highlight.FillTransparency = 0.75
        Highlight.OutlineTransparency = 0.35
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.Adornee = Character
        Highlight.Parent = ScreenGui

        Highlights[Player] = Highlight
    end
end

local function SetESP(Enabled)
    HighlightsEnabled = Enabled

    for _, Player in ipairs(Players:GetPlayers()) do
        UpdateHighlight(Player)
    end
end

local function TeleportBehindNearest()
    local Target = GetNearestPlayer()

    if not Target or not Target.Character then
        error("No valid target")
    end

    local Character = LocalPlayer.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")

    local TargetRoot =
        Target.Character:FindFirstChild("HumanoidRootPart")

    if not Root or not TargetRoot then
        error("HumanoidRootPart missing")
    end

    Root.CFrame = TargetRoot.CFrame * CFrame.new(0, 0, 3)
end

CreateActionButton(CombatPage, "GUN TEST", TestGun)
CreateActionButton(CombatPage, "KNIFE TEST", TestKnife)

CreateToggle(CombatPage, "WALLBANG", false, function(Enabled)
    Status.Text = Enabled and "STATUS: WALLBANG ON"
        or "STATUS: WALLBANG OFF"

    Status.TextColor3 = Theme.Green
end)

CreateToggle(VisualPage, "PLAYER ESP", false, function(Enabled)
    SetESP(Enabled)

    Status.Text = Enabled and "STATUS: ESP ON"
        or "STATUS: ESP OFF"

    Status.TextColor3 = Theme.Green
end)

CreateActionButton(
    VisualPage,
    "TELEPORT TEST",
    TeleportBehindNearest
)

local function ConnectPlayer(Player)
    Player.CharacterAdded:Connect(function()
        task.wait(0.5)

        if ScreenGui.Parent then
            UpdateHighlight(Player)
        end
    end)

    if Player.Character then
        UpdateHighlight(Player)
    end
end

Players.PlayerAdded:Connect(ConnectPlayer)

Players.PlayerRemoving:Connect(function(Player)
    if Highlights[Player] then
        Highlights[Player]:Destroy()
        Highlights[Player] = nil
    end
end)

for _, Player in ipairs(Players:GetPlayers()) do
    ConnectPlayer(Player)
end

local Minimized = false

MinimizeButton.Activated:Connect(function()
    Minimized = not Minimized

    Content.Visible = not Minimized
    Tabs.Visible = not Minimized
    Status.Visible = not Minimized

    Main.Size = Minimized
        and UDim2.fromOffset(WIDTH, 28)
        or UDim2.fromOffset(WIDTH, HEIGHT)

    MinimizeButton.Text = Minimized and "+" or "-"
end)

local ConfirmingClose = false

CloseButton.Activated:Connect(function()
    if ConfirmingClose then
        ScreenGui:Destroy()
        return
    end

    ConfirmingClose = true

    CloseButton.Text = "?"
    Title.Text = "CLOSE UI?"

    task.delay(3, function()
        if ScreenGui.Parent and ConfirmingClose then
            ConfirmingClose = false
            CloseButton.Text = "X"
            Title.Text = "COMBAT TEST"
        end
    end)
end)

local Dragging = false
local DragStart
local StartPosition
local DragInput

Header.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position

        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch then

        DragInput = Input
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if Dragging and Input == DragInput then
        local Delta = Input.Position - DragStart

        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

SetPage("COMBAT")
