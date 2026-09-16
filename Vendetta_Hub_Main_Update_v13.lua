--// VENDETTA HUB PREMIUM
--// Vendetta Hub Presents
--// Premium Mobile + PC Edition

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

local Character = LP.Character or LP.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

--==================================================
--// STATE
--==================================================

local HealthESP = false
local NameDistanceESP = false
local FluteESP = false
local EarringsESP = false
local NoArm = false
local AutoBlock = false
local InfiniteDash = false
local Noclip = false
local Flying = false
local Farm = false
local FarmTarget = nil
local FarmTween = nil

-- Vendetta combat / utility states
local ManualIgnored = {}
local BlockBreakMacro = false
local AutoStrongAttack = false
local AutoGourds = false
local AutoGourdsRunning = false
local NPCFarm = false
local NPCFarmRunning = false
local NPCFarmTarget = nil
local NPCFarmTween = nil
local HitboxESP = false
local AutoBreathing = false
local KatanaHidden = false
local FPSBoost = false
local FullBright = false
local SavedLighting = nil
local SavedQualityLevel = nil
local SavedGlobalShadows = nil
local SavedTerrainDecoration = nil
local TrainerTween = nil
local IceShardESP = false
local IceShardTween = nil

local TrainerPoints = {
    ["Rock Trainer"] = Vector3.new(-206.29934692382812, 825.102294921875, 1351.5655517578125),
    ["Water Trainer"] = Vector3.new(530.67431640625, 819.4022216796875, 782.8063354492188),
    ["Beast Trainer"] = Vector3.new(-46.305755615234375, 821.6522827148438, 184.3372802734375),
    ["Thunder Trainer"] = Vector3.new(-2012.3070068359375, 830.0028686523438, -1037.0313720703125),
    ["Serpent Trainer"] = Vector3.new(-2557.933837890625, 830.0028076171875, -490.3348693847656),
    ["Flame Trainer"] = Vector3.new(-2390.70556640625, 827.4526977539062, 548.4616088867188),
    ["Flower Trainer"] = Vector3.new(-1257.1767578125, 868.301513671875, 1343.238525390625),
    ["Wind Trainer"] = Vector3.new(-1172.930908203125, 868.301513671875, 1336.7552490234375),
    ["Rat Trainer"] = Vector3.new(-1304.7491455078125, 1059.801513671875, 791.6906127929688),
    ["Love Trainer"] = Vector3.new(-1159.5474853515625, 885.208740234375, 849.25537109375),
}

local FlySpeed = 50
local Vertical = 0
local UpHeld = false
local DownHeld = false

local ESPObjects = {}
local NoclipConnection = nil
local FarmConnection = nil

--==================================================
--// HELPERS
--==================================================

local function GetCharacter(P)
	return P and P.Character
end

local function GetRoot(P)
	local C = GetCharacter(P)
	return C and C:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid(P)
	local C = GetCharacter(P)
	return C and C:FindFirstChildOfClass("Humanoid")
end

local function IsAlive(P)
	local H = GetHumanoid(P)
	return H and H.Health > 0
end

--==================================================
--// GUI
--==================================================

local GUI = Instance.new("ScreenGui")
GUI.Name = "VendettaHub"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.DisplayOrder = 999999
GUI.Parent = PG

--==================================================
--// PREMIUM INTRO
--==================================================

local Intro = Instance.new("Frame")
Intro.Size = UDim2.fromScale(1,1)
Intro.BackgroundColor3 = Color3.fromRGB(5,5,8)
Intro.BorderSizePixel = 0
Intro.ZIndex = 100
Intro.Parent = GUI

local IntroTitle = Instance.new("TextLabel")
IntroTitle.Size = UDim2.new(1,0,0,70)
IntroTitle.Position = UDim2.new(0,0,.37,0)
IntroTitle.BackgroundTransparency = 1
IntroTitle.Text = "VENDETTA HUB"
IntroTitle.TextColor3 = Color3.fromRGB(235,45,45)
IntroTitle.TextScaled = true
IntroTitle.Font = Enum.Font.GothamBlack
IntroTitle.ZIndex = 101
IntroTitle.Parent = Intro

local IntroDesc = Instance.new("TextLabel")
IntroDesc.Size = UDim2.new(1,0,0,35)
IntroDesc.Position = UDim2.new(0,0,.49,0)
IntroDesc.BackgroundTransparency = 1
IntroDesc.Text = "Made from the best, To be used by the best"
IntroDesc.TextColor3 = Color3.fromRGB(190,190,200)
IntroDesc.TextSize = 15
IntroDesc.Font = Enum.Font.GothamMedium
IntroDesc.ZIndex = 101
IntroDesc.Parent = Intro


task.spawn(function()
	task.wait(2)

	local FadeInfo = TweenInfo.new(1.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)

	TS:Create(Intro,FadeInfo,{BackgroundTransparency = 1}):Play()
	TS:Create(IntroTitle,FadeInfo,{TextTransparency = 1}):Play()
	TS:Create(IntroDesc,FadeInfo,{TextTransparency = 1}):Play()

	task.wait(1.3)

	if Intro then
		Intro:Destroy()
	end
end)

--==================================================
--// MAIN
--==================================================

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(500,430)
Main.Position = UDim2.new(.5,-250,.5,-195)
Main.BackgroundColor3 = Color3.fromRGB(9,9,13)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = GUI

Instance.new("UICorner",Main).CornerRadius = UDim.new(0,16)

-- Bottom profile display
local Profile = Instance.new("Frame",Main)
Profile.Size = UDim2.fromOffset(150,50)
Profile.Position = UDim2.new(1,-160,1,-58)
Profile.BackgroundTransparency = 1

local Avatar = Instance.new("ImageLabel",Profile)
Avatar.Size = UDim2.fromOffset(42,42)
Avatar.Position = UDim2.fromOffset(0,4)
Avatar.BackgroundColor3 = Color3.fromRGB(20,20,25)
Avatar.BorderSizePixel = 0
pcall(function()
    Avatar.Image = Players:GetUserThumbnailAsync(
        LP.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size100x100
    )
end)
Instance.new("UICorner",Avatar).CornerRadius = UDim.new(1,0)

local ProfileName = Instance.new("TextLabel",Profile)
ProfileName.Size = UDim2.fromOffset(100,42)
ProfileName.Position = UDim2.fromOffset(50,4)
ProfileName.BackgroundTransparency = 1
ProfileName.Text = "@"..LP.Name
ProfileName.TextColor3 = Color3.fromRGB(235,235,240)
ProfileName.Font = Enum.Font.GothamBold
ProfileName.TextSize = 12
ProfileName.TextXAlignment = Enum.TextXAlignment.Left



local MainStroke = Instance.new("UIStroke",Main)
MainStroke.Thickness = 2

local MainGradient = Instance.new("UIGradient",Main)
MainGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.fromRGB(35,8,8)),
	ColorSequenceKeypoint.new(.5,Color3.fromRGB(9,9,13)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(25,5,5))
})

--==================================================
--// TOP BAR
--==================================================

local Top = Instance.new("Frame",Main)
Top.Size = UDim2.new(1,0,0,62)
Top.BackgroundTransparency = 1
Top.Active = true

local Title = Instance.new("TextLabel",Top)
Title.Size = UDim2.new(1,-120,1,0)
Title.Position = UDim2.fromOffset(18,0)
Title.BackgroundTransparency = 1
Title.Text = "VENDETTA  •  HUB"
Title.TextColor3 = Color3.fromRGB(235,45,45)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left

local SubTitle = Instance.new("TextLabel",Top)
SubTitle.Size = UDim2.new(1,-140,0,20)
SubTitle.Position = UDim2.fromOffset(19,37)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "PREMIUM EDITION"
SubTitle.TextColor3 = Color3.fromRGB(130,130,140)
SubTitle.TextSize = 9
SubTitle.Font = Enum.Font.GothamBold
SubTitle.TextXAlignment = Enum.TextXAlignment.Left

local Minimize = Instance.new("TextButton",Top)
Minimize.Size = UDim2.fromOffset(40,40)
Minimize.Position = UDim2.new(1,-50,0,10)
Minimize.Text = "—"
Minimize.TextSize = 20
Minimize.Font = Enum.Font.GothamBold
Minimize.TextColor3 = Color3.fromRGB(235,45,45)
Minimize.BackgroundColor3 = Color3.fromRGB(25,23,18)
Minimize.BorderSizePixel = 0

Instance.new("UICorner",Minimize).CornerRadius = UDim.new(0,10)

--==================================================
--// SIDEBAR
--==================================================

local Side = Instance.new("Frame",Main)
Side.Size = UDim2.fromOffset(122,355)
Side.Position = UDim2.fromOffset(8,68)
Side.BackgroundColor3 = Color3.fromRGB(13,13,18)
Side.BorderSizePixel = 0

Instance.new("UICorner",Side).CornerRadius = UDim.new(0,12)

local SideStroke = Instance.new("UIStroke",Side)
SideStroke.Thickness = 1
SideStroke.Transparency = .5

local Content = Instance.new("Frame",Main)
Content.Size = UDim2.new(1,-140,1,-78)
Content.Position = UDim2.fromOffset(134,68)
Content.BackgroundTransparency = 1

local Pages = {}
local Tabs = {}

local function CreatePage(Name)
	local Page = Instance.new("ScrollingFrame",Content)
	Page.Name = Name
	Page.Size = UDim2.fromScale(1,1)
	Page.BackgroundTransparency = 1
	Page.BorderSizePixel = 0
	Page.ScrollBarThickness = 3
	Page.ScrollBarImageColor3 = Color3.fromRGB(235,45,45)
	Page.CanvasSize = UDim2.new(0,0,0,0)
	Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Page.Visible = false

	Pages[Name] = Page
	return Page
end

local function CreateTab(Name,Y)
    local B = Instance.new("TextButton",Side)
    B.Size = UDim2.new(1,-12,0,30)
    B.Position = UDim2.fromOffset(6,Y)
    B.Text = Name
    B.TextSize = 12
    B.Font = Enum.Font.GothamSemibold
    B.TextColor3 = Color3.fromRGB(170,170,180)
    B.BackgroundColor3 = Color3.fromRGB(19,19,25)
    B.BorderSizePixel = 0
    B.AutoButtonColor = false
    Instance.new("UICorner",B).CornerRadius = UDim.new(0,9)

    local Accent = Instance.new("Frame",B)
    Accent.Size = UDim2.fromOffset(3,16)
    Accent.Position = UDim2.fromOffset(2,7)
    Accent.BackgroundColor3 = Color3.fromRGB(235,45,45)
    Accent.BackgroundTransparency = 1
    Accent.BorderSizePixel = 0
    Instance.new("UICorner",Accent).CornerRadius = UDim.new(1,0)
    B:SetAttribute("Accent", true)

    B.MouseEnter:Connect(function()
        if B.BackgroundColor3 ~= Color3.fromRGB(65,18,18) then
            TS:Create(B,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(28,20,25)}):Play()
        end
    end)
    B.MouseLeave:Connect(function()
        if B.BackgroundColor3 ~= Color3.fromRGB(65,18,18) then
            TS:Create(B,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(19,19,25)}):Play()
        end
    end)

    Tabs[Name] = B
    return B
end

local MainPage = CreatePage("Main")
local Mobility = CreatePage("Mobility")
local FarmPage = CreatePage("Farm")
local Server = CreatePage("Server")
local TweenPage = CreatePage("Tween")
local OP = CreatePage("OP")
local Credits = CreatePage("Credits")
local Information = CreatePage("Information")
local Settings = CreatePage("Settings")

CreateTab("Main",5)
CreateTab("Mobility",39)
CreateTab("Farm",73)
CreateTab("Server",107)
CreateTab("Tween",141)
CreateTab("OP",175)
CreateTab("Credits",209)
CreateTab("Info",243)
CreateTab("Settings",277)

local function ShowPage(Name)
	for N,P in pairs(Pages) do
		P.Visible = N == Name
	end

	for N,B in pairs(Tabs) do
        local Active = (N == "Info" and Name == "Information") or N == Name
        B.BackgroundColor3 = Active and Color3.fromRGB(65,18,18) or Color3.fromRGB(19,19,25)
        B.TextColor3 = Active and Color3.fromRGB(235,45,45) or Color3.fromRGB(170,170,180)
        local Accent = B:FindFirstChildOfClass("Frame")
        if Accent then Accent.BackgroundTransparency = Active and 0 or 1 end
	end
end

for Name,PageName in pairs({
	Main = "Main",
	Mobility = "Mobility",
	Farm = "Farm",
	Server = "Server",
	Tween = "Tween",
	OP = "OP",
	Credits = "Credits",
	Info = "Information",
	Settings = "Settings"
}) do
	Tabs[Name].MouseButton1Click:Connect(function()
		ShowPage(PageName)
	end)
end

ShowPage("Main")

--==================================================
--// UI HELPERS
--==================================================

local function SetToggleVisual(ButtonObject, Enabled)
    if not ButtonObject then return end
    ButtonObject:SetAttribute("ToggleButton", true)
    ButtonObject.BackgroundColor3 = Enabled
        and Color3.fromRGB(72,20,20)
        or Color3.fromRGB(19,20,27)
    ButtonObject.TextColor3 = Enabled
        and Color3.fromRGB(255,95,95)
        or Color3.fromRGB(240,240,245)
end

local function Button(Parent,Text,Y)
	local B = Instance.new("TextButton",Parent)
	B.Size = UDim2.new(1,-12,0,40)
	B.Position = UDim2.fromOffset(6,Y)
	B.Text = Text
	B.TextSize = 13
	B.Font = Enum.Font.GothamSemibold
    B.TextColor3 = Color3.fromRGB(240,240,245)
    B.BackgroundColor3 = Color3.fromRGB(19,20,27)
    B.BorderSizePixel = 0
    B.AutoButtonColor = false

    Instance.new("UICorner",B).CornerRadius = UDim.new(0,10)

    local Stroke = Instance.new("UIStroke",B)
    Stroke.Thickness = 1
    Stroke.Transparency = .8

    B.MouseEnter:Connect(function()
        if not B:GetAttribute("ToggleButton") then
            TS:Create(B,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(28,22,29)}):Play()
        end
    end)
    B.MouseLeave:Connect(function()
        if not B:GetAttribute("ToggleButton") then
            TS:Create(B,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(19,20,27)}):Play()
        end
    end)

    return B
end

local function Label(Parent,Text,Y)
	local L = Instance.new("TextLabel",Parent)
	L.Size = UDim2.new(1,-12,0,30)
	L.Position = UDim2.fromOffset(6,Y)
	L.BackgroundTransparency = 1
	L.Text = Text
	L.TextSize = 12
	L.Font = Enum.Font.GothamMedium
	L.TextColor3 = Color3.fromRGB(145,145,155)
	L.TextXAlignment = Enum.TextXAlignment.Left
	return L
end

--==================================================
--// MAIN — ITEMS / VISUALS / COMBAT / MISC
--==================================================

Label(MainPage,"ITEMS",8)
local FluteTween = Button(MainPage,"Tween → Flute",40)
local EarringsTween = Button(MainPage,"Tween → Earrings",84)
local IceTweenButton = Button(MainPage,"Tween → Active Ice Shard",128)

Label(MainPage,"VISUALS",180)
local HealthButton = Button(MainPage,"Health ESP   •   OFF",212)
local NameDistanceButton = Button(MainPage,"Name + Distance ESP   •   OFF",256)
local FluteESPButton = Button(MainPage,"Flute ESP   •   OFF",300)
local EarringsESPButton = Button(MainPage,"Earrings ESP   •   OFF",344)
local IceESPButton = Button(MainPage,"Ice Shard ESP   •   OFF",388)
local ArmButton = Button(MainPage,"No Arm   •   OFF",432)

Label(MainPage,"COMBAT",484)
local BlockButton = Button(MainPage,"Auto Block   •   OFF",516)
local HitboxButton = Button(MainPage,"Hitbox ESP   •   OFF",560)
local KatanaButton = Button(MainPage,"Katana Hide   •   OFF",604)
local BlockBreakButton = Button(MainPage,"Block Break Macro   •   OFF",648)
local StrongAttackButton = Button(MainPage,"Auto Strong Attack   •   OFF",692)
local ComboLeaverButton = Button(MainPage,"Combo Leaver",736)

Label(MainPage,"FOV CHANGER",788)
local FOVBox = Instance.new("TextBox",MainPage)
FOVBox.Size = UDim2.fromOffset(90,38)
FOVBox.Position = UDim2.fromOffset(6,820)
FOVBox.Text = "70"
FOVBox.TextSize = 13
FOVBox.Font = Enum.Font.GothamSemibold
FOVBox.TextColor3 = Color3.new(1,1,1)
FOVBox.BackgroundColor3 = Color3.fromRGB(19,20,27)
FOVBox.BorderSizePixel = 0
FOVBox.ClearTextOnFocus = false
Instance.new("UICorner",FOVBox).CornerRadius = UDim.new(0,9)

local FOVApplyButton = Button(MainPage,"Apply FOV",820)
FOVApplyButton.Size = UDim2.fromOffset(110,38)
FOVApplyButton.Position = UDim2.fromOffset(104,820)

Label(MainPage,"COMBAT",872)
local BreathingButton = Button(MainPage,"Auto Breathing   •   OFF",904)
local KillSelfButton = Button(MainPage,"Kill Self",948)
local AntiFallButton = Button(MainPage,"Anti Fall Damage   •   OFF",992)

Label(MainPage,"MISC",1040)
local FPSBoostButton = Button(MainPage,"FPS Booster   •   OFF",1072)
local FullBrightButton = Button(MainPage,"Full Bright   •   OFF",1116)

local FriendTitle = Label(MainPage,"MANUAL FRIEND IGNORE",1160)
local FriendBox = Instance.new("TextBox",MainPage)
FriendBox.Size = UDim2.new(1,-116,0,38)
FriendBox.Position = UDim2.fromOffset(6,1194)
FriendBox.PlaceholderText = "Enter username"
FriendBox.Text = ""
FriendBox.TextSize = 12
FriendBox.Font = Enum.Font.GothamMedium
FriendBox.TextColor3 = Color3.new(1,1,1)
FriendBox.PlaceholderColor3 = Color3.fromRGB(110,110,120)
FriendBox.BackgroundColor3 = Color3.fromRGB(19,20,27)
FriendBox.BorderSizePixel = 0
Instance.new("UICorner",FriendBox).CornerRadius = UDim.new(0,9)

local AddFriendButton = Button(MainPage,"ADD",1200)
AddFriendButton.Size = UDim2.fromOffset(48,38)
AddFriendButton.Position = UDim2.new(1,-104,0,1194)
local RemoveFriendButton = Button(MainPage,"REMOVE",1252)
RemoveFriendButton.Size = UDim2.fromOffset(98,38)
RemoveFriendButton.Position = UDim2.fromOffset(6,1240)

local FriendListLabel = Label(MainPage,"Ignored: none",1294)
FriendListLabel.TextWrapped = true
FriendListLabel.Size = UDim2.new(1,-12,0,60)

--==================================================
--// MOBILITY — CONTROLS ONLY
--==================================================

local FlyButton = Button(Mobility,"CFly   •   OFF",8)
local NoclipButton = Button(Mobility,"Noclip   •   OFF",52)
local DashButton = Button(Mobility,"Infinite Dash   •   OFF",96)

Label(Mobility,"Flight Speed",100)

local SpeedBox = Instance.new("TextBox",Mobility)
SpeedBox.Size = UDim2.fromOffset(90,38)
SpeedBox.Position = UDim2.fromOffset(6,130)
SpeedBox.Text = "50"
SpeedBox.TextSize = 15
SpeedBox.Font = Enum.Font.GothamBold
SpeedBox.TextColor3 = Color3.new(1,1,1)
SpeedBox.BackgroundColor3 = Color3.fromRGB(19,20,27)
SpeedBox.BorderSizePixel = 0
SpeedBox.ClearTextOnFocus = false

Instance.new("UICorner",SpeedBox).CornerRadius = UDim.new(0,9)

local Minus = Button(Mobility,"−",178)
Minus.Size = UDim2.fromOffset(55,38)

local Plus = Button(Mobility,"+",222)
Plus.Size = UDim2.fromOffset(55,38)

local SpeedDisplay = Label(Mobility,"50",178)
SpeedDisplay.Position = UDim2.fromOffset(72,178)
SpeedDisplay.Size = UDim2.new(1,-75,0,82)
SpeedDisplay.TextSize = 25
SpeedDisplay.TextColor3 = Color3.fromRGB(235,45,45)

--==================================================
--// FARM — CONTROLS ONLY
--==================================================

Label(FarmPage,"PLAYER FARM",8)
Label(FarmPage,"Target Player",36)

local TargetBox = Instance.new("TextBox",FarmPage)
TargetBox.Size = UDim2.new(1,-12,0,40)
TargetBox.Position = UDim2.fromOffset(6,64)
TargetBox.PlaceholderText = "Enter username..."
TargetBox.Text = ""
TargetBox.TextSize = 13
TargetBox.Font = Enum.Font.GothamMedium
TargetBox.TextColor3 = Color3.new(1,1,1)
TargetBox.PlaceholderColor3 = Color3.fromRGB(110,110,120)
TargetBox.BackgroundColor3 = Color3.fromRGB(19,20,27)
TargetBox.BorderSizePixel = 0

Instance.new("UICorner",TargetBox).CornerRadius = UDim.new(0,10)

local FarmButton = Button(FarmPage,"Farm   •   OFF",110)

Label(FarmPage,"NPC FARM",178)
Label(FarmPage,"NPC Target",206)
local NPCBox = Instance.new("TextBox",FarmPage)
NPCBox.Size = UDim2.new(1,-12,0,40)
NPCBox.Position = UDim2.fromOffset(6,232)
NPCBox.PlaceholderText = "Enter NPC name..."
NPCBox.Text = ""
NPCBox.TextSize = 13
NPCBox.Font = Enum.Font.GothamMedium
NPCBox.TextColor3 = Color3.new(1,1,1)
NPCBox.PlaceholderColor3 = Color3.fromRGB(110,110,120)
NPCBox.BackgroundColor3 = Color3.fromRGB(19,20,27)
NPCBox.BorderSizePixel = 0
Instance.new("UICorner",NPCBox).CornerRadius = UDim.new(0,10)

local NPCFarmButton = Button(FarmPage,"AutoFarm NPC   •   OFF",278)
local AutoGourdsButton = Button(FarmPage,"Auto Gourds   •   OFF",322)
local RedeemCodesButton = Button(FarmPage,"Redeem All Codes",366)

local BypassButton = Button(OP,"Bypass",8)

local AutoBreathingsButton = Button(OP,"Auto Get All Breathings",52)
local AutoBDAsButton = Button(OP,"Auto Get All BDAs",96)

local KatanaSellerPosition = Vector3.new(-251.04994201660156, 821.5532836914062, -30.124601364135742)
local AutoAcquisitionRunning = false
local AcquisitionDesyncRunning = false
local AcquisitionDesyncConnection = nil
local BreathingPicker = nil

local function GetPromptPosition(Prompt)
    if not Prompt then return nil end
    local Parent = Prompt.Parent
    if Parent and Parent:IsA("BasePart") then return Parent.Position end
    local Part = Parent and Parent:FindFirstChildWhichIsA("BasePart", true)
    return Part and Part.Position or nil
end

local function FindPromptNearPosition(Position, Radius)
    local BestPrompt
    local BestDistance = Radius or 35

    for _,Object in ipairs(workspace:GetDescendants()) do
        if Object:IsA("ProximityPrompt") then
            local PromptPosition = GetPromptPosition(Object)
            if PromptPosition then
                local Distance = (PromptPosition - Position).Magnitude
                if Distance <= BestDistance then
                    BestDistance = Distance
                    BestPrompt = Object
                end
            end
        end
    end

    return BestPrompt
end

local function FindNamedNPCPrompt(Name)
    local Query = string.lower(Name)
    local Partial

    for _,Object in ipairs(workspace:GetDescendants()) do
        if Object:IsA("Model") then
            local ObjectName = string.lower(Object.Name)
            local Prompt = Object:FindFirstChildWhichIsA("ProximityPrompt", true)
            if Prompt then
                if ObjectName == Query then
                    return Prompt
                elseif not Partial and ObjectName:find(Query, 1, true) then
                    Partial = Prompt
                end
            end
        end
    end

    return Partial
end

local function TriggerPrompt(Prompt)
    if not Prompt or not Prompt.Parent then return false end

    if typeof(fireproximityprompt) == "function" then
        local Success = pcall(function()
            fireproximityprompt(Prompt)
        end)
        if Success then return true end
    end

    return pcall(function()
        Prompt:InputHoldBegin()
        task.wait(math.max(Prompt.HoldDuration, 0.05))
        Prompt:InputHoldEnd()
    end)
end

local function TweenAndWait(Position)
    if not HRP then return false end

    if TrainerTween then
        pcall(function() TrainerTween:Cancel() end)
        TrainerTween = nil
    end

    local Distance = (Position - HRP.Position).Magnitude
    local Duration = Distance <= 500 and 3 or 6

    TrainerTween = TS:Create(
        HRP,
        TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
        {CFrame = CFrame.new(Position + Vector3.new(0,3,0))}
    )

    TrainerTween:Play()
    TrainerTween.Completed:Wait()
    TrainerTween = nil
    return true
end

local function StartInventoryDesync()
    if AcquisitionDesyncRunning then return end
    AcquisitionDesyncRunning = true

    if AcquisitionDesyncConnection then
        AcquisitionDesyncConnection:Disconnect()
    end

    AcquisitionDesyncConnection = RS.Heartbeat:Connect(function()
        if not AcquisitionDesyncRunning then return end

        local CharacterNow = LP.Character
        local Hum = CharacterNow and CharacterNow:FindFirstChildOfClass("Humanoid")
        local Backpack = LP:FindFirstChildOfClass("Backpack")
        if not CharacterNow or not Hum or not Backpack then return end

        local Tools = {}
        for _,Container in ipairs({Backpack, CharacterNow}) do
            for _,Tool in ipairs(Container:GetChildren()) do
                if Tool:IsA("Tool") and not table.find(Tools, Tool) then
                    Tools[#Tools + 1] = Tool
                end
            end
        end

        for _,Tool in ipairs(Tools) do
            pcall(function()
                Hum:EquipTool(Tool)
                Hum:UnequipTools()
                Hum:EquipTool(Tool)
                Hum:UnequipTools()
                Hum:EquipTool(Tool)
                Hum:UnequipTools()
                Tool.Parent = nil
                Tool.Parent = Backpack
            end)
        end
    end)
end

local function StopInventoryDesync()
    AcquisitionDesyncRunning = false
    if AcquisitionDesyncConnection then
        AcquisitionDesyncConnection:Disconnect()
        AcquisitionDesyncConnection = nil
    end
end

local function ResetAcquisitionButton(ButtonObject, Text)
    AutoAcquisitionRunning = false
    ButtonObject.Text = Text
    SetToggleVisual(ButtonObject, false)
end

local function CreateBreathingPicker()
    if BreathingPicker and BreathingPicker.Parent then
        BreathingPicker.Visible = true
        return
    end

    local Popup = Instance.new("Frame", GUI)
    Popup.Name = "BreathingTrainerPicker"
    Popup.Size = UDim2.fromOffset(250, 330)
    Popup.Position = UDim2.new(0.5, -125, 0.5, -165)
    Popup.BackgroundColor3 = Color3.fromRGB(10,10,15)
    Popup.BorderSizePixel = 0
    Popup.ZIndex = 30
    Instance.new("UICorner", Popup).CornerRadius = UDim.new(0,14)

    local Stroke = Instance.new("UIStroke", Popup)
    Stroke.Color = Color3.fromRGB(235,45,45)
    Stroke.Thickness = 2

    local Header = Instance.new("TextLabel", Popup)
    Header.Size = UDim2.new(1,-55,0,34)
    Header.Position = UDim2.fromOffset(10,8)
    Header.BackgroundTransparency = 1
    Header.Text = "SELECT BREATHING"
    Header.TextColor3 = Color3.fromRGB(240,240,245)
    Header.TextSize = 15
    Header.Font = Enum.Font.GothamBold
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.ZIndex = 31

    local Close = Instance.new("TextButton", Popup)
    Close.Size = UDim2.fromOffset(28,28)
    Close.Position = UDim2.new(1,-36,0,7)
    Close.BackgroundColor3 = Color3.fromRGB(35,18,22)
    Close.BorderSizePixel = 0
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(235,70,70)
    Close.TextSize = 12
    Close.Font = Enum.Font.GothamBold
    Close.ZIndex = 31
    Instance.new("UICorner", Close).CornerRadius = UDim.new(0,8)

    local List = Instance.new("ScrollingFrame", Popup)
    List.Size = UDim2.new(1,-20,1,-58)
    List.Position = UDim2.fromOffset(10,50)
    List.BackgroundTransparency = 1
    List.BorderSizePixel = 0
    List.ScrollBarThickness = 3
    List.ScrollBarImageColor3 = Color3.fromRGB(235,45,45)
    List.AutomaticCanvasSize = Enum.AutomaticSize.Y
    List.CanvasSize = UDim2.new(0,0,0,0)
    List.ZIndex = 31

    local Layout = Instance.new("UIListLayout", List)
    Layout.Padding = UDim.new(0,6)

    for _,Name in ipairs(TrainerOrder) do
        local TrainerButton = Instance.new("TextButton", List)
        TrainerButton.Size = UDim2.new(1,-4,0,36)
        TrainerButton.BackgroundColor3 = Color3.fromRGB(19,20,27)
        TrainerButton.BorderSizePixel = 0
        TrainerButton.Text = Name
        TrainerButton.TextColor3 = Color3.fromRGB(240,240,245)
        TrainerButton.TextSize = 12
        TrainerButton.Font = Enum.Font.GothamSemibold
        TrainerButton.ZIndex = 32
        Instance.new("UICorner", TrainerButton).CornerRadius = UDim.new(0,9)

        TrainerButton.Activated:Connect(function()
            if AutoAcquisitionRunning then return end
            local Target = TrainerPoints[Name]
            if not Target then return end

            Popup.Visible = false
            AutoAcquisitionRunning = true
            AutoBreathingsButton.Text = "Auto Get All Breathings • RUNNING"
            SetToggleVisual(AutoBreathingsButton, true)

            task.spawn(function()
                local KatanaPrompt = FindPromptNearPosition(KatanaSellerPosition, 35)
                if not KatanaPrompt then
                    Notify("Vendetta Hub", "Katana seller prompt not found.", 3)
                    ResetAcquisitionButton(AutoBreathingsButton, "Auto Get All Breathings")
                    return
                end

                if not TweenAndWait(KatanaSellerPosition) then
                    ResetAcquisitionButton(AutoBreathingsButton, "Auto Get All Breathings")
                    return
                end

                task.wait(0.15)
                TriggerPrompt(KatanaPrompt)
                task.wait(1)
                TweenAndWait(Target)

                ResetAcquisitionButton(AutoBreathingsButton, "Auto Get All Breathings")
            end)
        end)
    end

    Close.Activated:Connect(function()
        Popup.Visible = false
    end)

    MakeDraggable(Popup)
    BreathingPicker = Popup
end

AutoBreathingsButton.MouseButton1Click:Connect(function()
    CreateBreathingPicker()
end)

AutoBDAsButton.MouseButton1Click:Connect(function()
    if AutoAcquisitionRunning then return end

    AutoAcquisitionRunning = true
    AutoBDAsButton.Text = "Auto Get All BDAs • RUNNING"
    SetToggleVisual(AutoBDAsButton, true)

    task.spawn(function()
        local AkumaPrompt = FindNamedNPCPrompt("Old Akuma")
        if not AkumaPrompt then
            Notify("Vendetta Hub", "Old Akuma prompt not found.", 3)
            ResetAcquisitionButton(AutoBDAsButton, "Auto Get All BDAs")
            return
        end

        local AkumaPosition = GetPromptPosition(AkumaPrompt)
        if not AkumaPosition or not TweenAndWait(AkumaPosition) then
            ResetAcquisitionButton(AutoBDAsButton, "Auto Get All BDAs")
            return
        end

        task.wait(0.15)
        TriggerPrompt(AkumaPrompt)
        StartInventoryDesync()
        task.wait(2.5)

        if AkumaPrompt and AkumaPrompt.Parent then
            TriggerPrompt(AkumaPrompt)
        end

        ResetAcquisitionButton(AutoBDAsButton, "Auto Get All BDAs")
    end)
end)

--==================================================

DashButton.MouseButton1Click:Connect(function()
    InfiniteDash = not InfiniteDash
    DashButton.Text = "Infinite Dash   •   "..(InfiniteDash and "ON" or "OFF")
    SetToggleVisual(DashButton, InfiniteDash)
end)

task.spawn(function()
    while GUI.Parent do
        if InfiniteDash then
            pcall(function()
                game:GetService("ReplicatedStorage").DashWithNoDelay:InvokeServer("Dash")
            end)
        end
        task.wait(.2)
    end
end)

--// SERVER — CONTROLS ONLY
--==================================================

local RejoinButton = Button(Server,"Rejoin Current Server",8)
local ServerHopButton = Button(Server,"Server Hop",52)
local DayButton = Button(Server,"Set Day",96)
local NightButton = Button(Server,"Set Night",140)

--==================================================
--// CREDITS
--==================================================

Label(Credits,"CREDITS",8)
Label(Credits,"Nishizumi - Dev",48)
Label(Credits,"3moDeath - dev",88)

--==================================================
--// INFORMATION — EXPLANATIONS
--==================================================

Label(Information,"PC CONTROLS",8)

Label(Information,"W / A / S / D     •     CFly movement",38)
Label(Information,"SPACE             •     Fly upward",63)
Label(Information,"LEFT CTRL         •     Fly downward",88)
Label(Information,"RIGHT CTRL        •     Toggle CFly",113)
Label(Information,"+ / -              •     Change Fly Speed",138)

Label(Information,"MOBILE CONTROLS",178)

local MobileInfo = Label(
    Information,
    "Use the ▲ / ▼ buttons while Fly is enabled.",
    208
)
MobileInfo.TextWrapped = true

--==================================================
--// SETTINGS — CONTROLS ONLY
--==================================================

local HideButton = Button(Settings,"Hide / Minimize",8)

--==================================================
--// DAY / NIGHT CHANGER
--==================================================

local Lighting = game:GetService("Lighting")

DayButton.MouseButton1Click:Connect(function()
    Lighting.ClockTime = 12
    Notify("Vendetta Hub","Set time to Day.",2)
end)

NightButton.MouseButton1Click:Connect(function()
    Lighting.ClockTime = 0
    Notify("Vendetta Hub","Set time to Night.",2)
end)

--==================================================
--// TWEEN — TRAINERS
--==================================================

Label(TweenPage,"TRAINERS",8)

local TrainerButtons = {}
local TrainerOrder = {
    "Rock Trainer", "Water Trainer", "Beast Trainer", "Thunder Trainer",
    "Serpent Trainer", "Flame Trainer", "Flower Trainer", "Wind Trainer",
    "Rat Trainer", "Love Trainer"
}
local trainerY = 42
for _,Name in ipairs(TrainerOrder) do
    TrainerButtons[Name] = Button(TweenPage,"Tween → "..Name,trainerY)
    trainerY += 44
end

--==================================================
--// DRAGGING
--==================================================

local function MakeDraggable(Object)

	local Dragging = false
	local Start
	local StartPosition

	Object.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.Touch
		or Input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = true
			Start = Input.Position
			StartPosition = Object.Position
		end
	end)

	Object.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.Touch
		or Input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(Input)
		if not Dragging then return end

		if Input.UserInputType == Enum.UserInputType.Touch
		or Input.UserInputType == Enum.UserInputType.MouseMovement then

			local Delta = Input.Position - Start

			Object.Position = UDim2.new(
				StartPosition.X.Scale,
				StartPosition.X.Offset + Delta.X,
				StartPosition.Y.Scale,
				StartPosition.Y.Offset + Delta.Y
			)
		end
	end)
end

MakeDraggable(Main)

--==================================================
--// MINIMIZED
--==================================================

local Mini = Instance.new("TextButton",GUI)
Mini.Size = UDim2.fromOffset(62,62)
Mini.Position = Main.Position
Mini.Text = "V"
Mini.TextSize = 28
Mini.Font = Enum.Font.GothamBlack
Mini.TextColor3 = Color3.fromRGB(235,45,45)
Mini.BackgroundColor3 = Color3.fromRGB(10,10,14)
Mini.BorderSizePixel = 0
Mini.Visible = false

Instance.new("UICorner",Mini).CornerRadius = UDim.new(1,0)

local MiniBorder = Instance.new("UIStroke",Mini)
MiniBorder.Thickness = 2

MakeDraggable(Mini)

local function MinimizeGUI()
	Mini.Position = Main.Position
	Main.Visible = false
	Mini.Visible = true
end

Minimize.MouseButton1Click:Connect(MinimizeGUI)
HideButton.MouseButton1Click:Connect(MinimizeGUI)

Mini.MouseButton1Click:Connect(function()
	Main.Position = Mini.Position
	Mini.Visible = false
	Main.Visible = true
end)

--==================================================
--// RED PREMIUM BORDER
--==================================================

MainStroke.Color = Color3.fromRGB(235,45,45)
MiniBorder.Color = Color3.fromRGB(235,45,45)

--==================================================
--// CHARACTER
--==================================================

local function UpdateCharacter(C)
	Character = C
	HRP = C:WaitForChild("HumanoidRootPart")
	Humanoid = C:WaitForChild("Humanoid")
end

LP.CharacterAdded:Connect(UpdateCharacter)

--==================================================
--// ESP CLEANUP
--==================================================

local function ClearESP(Key)

	if ESPObjects[Key] then
		for _,Object in ipairs(ESPObjects[Key]) do
			if Object and Object.Parent then
				Object:Destroy()
			end
		end
	end

	ESPObjects[Key] = nil
end

--==================================================
--// HEALTH ESP
--==================================================

local function CreateHealthESP(P)

	if P == LP then return end

	local Root = GetRoot(P)
	local Hum = GetHumanoid(P)

	if not Root or not Hum then return end

	local Key = "HEALTH_" .. P.UserId

	ClearESP(Key)

	local Billboard = Instance.new("BillboardGui")
	Billboard.Name = "VendettaHealthESP"
	Billboard.Size = UDim2.fromOffset(190,90)
	Billboard.StudsOffset = Vector3.new(0,3.5,0)
	Billboard.AlwaysOnTop = true
	Billboard.Parent = Root

	local Holder = Instance.new("Frame",Billboard)
	Holder.Size = UDim2.fromScale(1,1)
	Holder.BackgroundTransparency = 1

	local Name = Instance.new("TextLabel",Holder)
	Name.Size = UDim2.new(1,0,0,22)
	Name.BackgroundTransparency = 1
	Name.TextColor3 = Color3.fromRGB(235,45,45)
	Name.TextStrokeTransparency = .25
	Name.Font = Enum.Font.GothamBold
	Name.TextSize = 13

	local HealthText = Instance.new("TextLabel",Holder)
	HealthText.Size = UDim2.new(1,0,0,20)
	HealthText.Position = UDim2.fromOffset(0,21)
	HealthText.BackgroundTransparency = 1
	HealthText.TextColor3 = Color3.new(1,1,1)
	HealthText.TextStrokeTransparency = .25
	HealthText.Font = Enum.Font.GothamSemibold
	HealthText.TextSize = 11

	local BarBG = Instance.new("Frame",Holder)
	BarBG.Size = UDim2.new(.85,0,0,8)
	BarBG.Position = UDim2.new(.075,0,0,45)
	BarBG.BackgroundColor3 = Color3.fromRGB(30,30,35)
	BarBG.BorderSizePixel = 0

	Instance.new("UICorner",BarBG).CornerRadius = UDim.new(1,0)

	local Bar = Instance.new("Frame",BarBG)
	Bar.Size = UDim2.fromScale(1,1)
	Bar.BackgroundColor3 = Color3.fromRGB(235,45,45)
	Bar.BorderSizePixel = 0

	Instance.new("UICorner",Bar).CornerRadius = UDim.new(1,0)

	local Distance = Instance.new("TextLabel",Holder)
	Distance.Size = UDim2.new(1,0,0,20)
	Distance.Position = UDim2.fromOffset(0,55)
	Distance.BackgroundTransparency = 1
	Distance.TextColor3 = Color3.fromRGB(175,175,185)
	Distance.TextStrokeTransparency = .3
	Distance.Font = Enum.Font.GothamMedium
	Distance.TextSize = 10

	ESPObjects[Key] = {Billboard}

	task.spawn(function()

		while Billboard.Parent and HealthESP do

			local MyRoot = HRP
			local TheirRoot = GetRoot(P)
			local TheirHum = GetHumanoid(P)

			if not MyRoot or not TheirRoot or not TheirHum then break end

			local Max = math.max(TheirHum.MaxHealth,1)
			local Current = math.clamp(TheirHum.Health,0,Max)
			local Percent = Current / Max

			Name.Text = P.Name
			HealthText.Text = math.floor(Current) .. " / " .. math.floor(Max)
			Bar.Size = UDim2.new(Percent,0,1,0)

			Distance.Text =
				math.floor((MyRoot.Position - TheirRoot.Position).Magnitude)
				.. " studs"

			task.wait(.12)
		end
	end)
end

--==================================================
--// NAME + DISTANCE ESP
--==================================================

local function CreateNameDistanceESP(P)

	if P == LP then return end

	local Root = GetRoot(P)
	if not Root then return end

	local Key = "NAME_" .. P.UserId

	ClearESP(Key)

	local Billboard = Instance.new("BillboardGui")
	Billboard.Name = "VendettaNameESP"
	Billboard.Size = UDim2.fromOffset(180,50)
	Billboard.StudsOffset = Vector3.new(0,3,0)
	Billboard.AlwaysOnTop = true
	Billboard.Parent = Root

	local Text = Instance.new("TextLabel",Billboard)
	Text.Size = UDim2.fromScale(1,1)
	Text.BackgroundTransparency = 1
	Text.TextColor3 = Color3.fromRGB(235,45,45)
	Text.TextStrokeTransparency = .2
	Text.Font = Enum.Font.GothamBold
	Text.TextSize = 14

	ESPObjects[Key] = {Billboard}

	task.spawn(function()

		while Billboard.Parent and NameDistanceESP do

			local MyRoot = HRP
			local TheirRoot = GetRoot(P)

			if not MyRoot or not TheirRoot then break end

			local Distance =
				math.floor((MyRoot.Position - TheirRoot.Position).Magnitude)

			Text.Text = P.Name .. "  •  " .. Distance .. " studs"

			task.wait(.15)
		end
	end)
end

local function RefreshPlayers()

	for _,P in ipairs(Players:GetPlayers()) do

		if P ~= LP then

			if HealthESP then
				CreateHealthESP(P)
			end

			if NameDistanceESP then
				CreateNameDistanceESP(P)
			end
		end
	end
end

HealthButton.MouseButton1Click:Connect(function()

	HealthESP = not HealthESP

	HealthButton.Text =
		"Health ESP   •   " .. (HealthESP and "ON" or "OFF")
	SetToggleVisual(HealthButton, HealthESP)

	if HealthESP then
		RefreshPlayers()
	else
		for _,P in ipairs(Players:GetPlayers()) do
			ClearESP("HEALTH_"..P.UserId)
		end
	end
end)

NameDistanceButton.MouseButton1Click:Connect(function()

	NameDistanceESP = not NameDistanceESP

	NameDistanceButton.Text =
		"Name + Distance ESP   •   "
		.. (NameDistanceESP and "ON" or "OFF")
	SetToggleVisual(NameDistanceButton, NameDistanceESP)

	if NameDistanceESP then
		RefreshPlayers()
	else
		for _,P in ipairs(Players:GetPlayers()) do
			ClearESP("NAME_"..P.UserId)
		end
	end
end)


--==================================================
--// DIRECT ITEM FINDERS
--// These only inspect already-replicated objects; no map chunk scanning.
--==================================================

local StarterGui = game:GetService("StarterGui")

local function Notify(Title,Text,Duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = Title,
            Text = Text,
            Duration = Duration or 3
        })
    end)
end

--==================================================
--// FIND FLUTE
--==================================================

local function FindFlute()
    -- Direct lookup: workspace.chatnpcs -> Flute.
    -- Do not scan the whole workspace or map.
    local ChatNPCs = workspace:FindFirstChild("chatnpcs")
    if not ChatNPCs then return nil end

    local Flute = ChatNPCs:FindFirstChild("Flute")
    if not Flute then return nil end

    if Flute:IsA("BasePart") then
        return Flute
    end

    if Flute:IsA("Model") then
        return Flute
    end

    return nil
end

local function FindEarrings()
    -- Direct lookup only: workspace.map -> Barrel.
    -- No chunk/proximity/whole-workspace scanning.
    local Map = workspace:FindFirstChild("map")
    if not Map then return nil end

    local Barrel = Map:FindFirstChild("Barrel")
    if not Barrel then return nil end

    if Barrel:IsA("Model") or Barrel:IsA("BasePart") then
        return Barrel
    end

    return nil
end

BypassButton.MouseButton1Click:Connect(function()
    Notify("Vendetta Hub", "Anti-cheat bypass/destruction is not included.", 4)
end)


KillSelfButton.MouseButton1Click:Connect(function()
    local CharacterNow = LP.Character
    local HumanoidNow = CharacterNow and CharacterNow:FindFirstChildOfClass("Humanoid")
    if HumanoidNow then
        HumanoidNow.Health = 0
    else
        Notify("Vendetta Hub", "Humanoid not found.", 3)
    end
end)

--==================================================
--// OBJECT ESP
--==================================================

local function CreateObjectESP(Part,TextFunction,Key)

	if not Part then return end

	ClearESP(Key)

	local Billboard = Instance.new("BillboardGui")
	Billboard.Name = "VendettaESP"
	Billboard.Size = UDim2.fromOffset(190,45)
	Billboard.StudsOffset = Vector3.new(0,3,0)
	Billboard.AlwaysOnTop = true
	Billboard.Parent = Part

	local Text = Instance.new("TextLabel",Billboard)
	Text.Size = UDim2.fromScale(1,1)
	Text.BackgroundTransparency = 1
	Text.Font = Enum.Font.GothamBold
	Text.TextSize = 14
	Text.TextColor3 = Color3.fromRGB(235,45,45)
	Text.TextStrokeTransparency = .2

	ESPObjects[Key] = {Billboard}

	task.spawn(function()
		while Billboard.Parent do
			Text.Text = TextFunction()
			task.wait(.15)
		end
	end)
end

FluteESPButton.MouseButton1Click:Connect(function()

	FluteESP = not FluteESP

	FluteESPButton.Text =
		"Flute ESP   •   " .. (FluteESP and "ON" or "OFF")
	SetToggleVisual(FluteESPButton, FluteESP)

	if FluteESP then

		local Part = FindFlute()

		if Part then
			CreateObjectESP(
				Part,
				function()
					return "♫  FLUTE"
				end,
				"FLUTE"
			)
		end

	else
		ClearESP("FLUTE")
	end
end)

EarringsESPButton.MouseButton1Click:Connect(function()

	EarringsESP = not EarringsESP

	EarringsESPButton.Text =
		"Earrings ESP   •   " .. (EarringsESP and "ON" or "OFF")
	SetToggleVisual(EarringsESPButton, EarringsESP)

	if EarringsESP then

		local Part = FindEarrings()

		if Part then
			CreateObjectESP(
				Part,
				function()
					return "◈  EARRINGS"
				end,
				"EARRINGS"
			)
		end

	else
		ClearESP("EARRINGS")
	end
end)

--==================================================
--// TRAINER TWEEN + ICE SHARD
--==================================================

local function TweenToPosition(Position)
    if not HRP then return end

    if TrainerTween then
        TrainerTween:Cancel()
        TrainerTween = nil
    end

    local Distance = (Position - HRP.Position).Magnitude
    local Duration = Distance <= 500 and 3 or 6

    local Goal = CFrame.new(Position + Vector3.new(0,3,0))
    TrainerTween = TS:Create(
        HRP,
        TweenInfo.new(Duration,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),
        {CFrame = Goal}
    )
    TrainerTween:Play()
    TrainerTween.Completed:Once(function()
        TrainerTween = nil
    end)
end

for Name,ButtonObject in pairs(TrainerButtons) do
    ButtonObject.MouseButton1Click:Connect(function()
        TweenToPosition(TrainerPoints[Name])
    end)
end

IceTweenButton.MouseButton1Click:Connect(function()
    local Shard = GetIceShard()
    local Target = GetIceShardPart(Shard)
    if not Target then
        Notify("Vendetta Hub", "Active Ice Shard not found.", 3)
        return
    end

    local CharacterNow = LP.Character
    local Root = CharacterNow and CharacterNow:FindFirstChild("HumanoidRootPart")
    if not Root then return end

    local TargetPosition
    if Target:IsA("Model") then
        TargetPosition = Target:GetPivot().Position + Vector3.new(0,5,0)
    else
        TargetPosition = Target.Position + Vector3.new(0,5,0)
    end

    if IceShardTween then pcall(function() IceShardTween:Cancel() end) end

    local Distance = (Root.Position - TargetPosition).Magnitude
    local Duration = Distance <= 500 and 3 or 6
    IceShardTween = TS:Create(Root,TweenInfo.new(Duration,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{CFrame=CFrame.new(TargetPosition)})
    IceTweenButton.Text = "Tweening • "..Duration.."s"
    IceShardTween:Play()
    IceShardTween.Completed:Once(function()
        IceShardTween=nil
        if IceTweenButton.Parent then IceTweenButton.Text="Tween → Active Ice Shard" end
    end)
end)

--==================================================
--// ICE SHARD ESP
--==================================================

local function GetIceShard()
    return workspace:FindFirstChild("ActiveIceShard")
end

local function GetIceShardPart(Shard)
    -- ActiveIceShard itself is the direct target.
    if not Shard then return nil end
    if Shard:IsA("BasePart") then return Shard end
    if Shard:IsA("Model") then return Shard end
    return nil
end

local function UpdateIceShardESP()
    local Shard = GetIceShard()
    if not Shard then return end
    local H = Shard:FindFirstChild("VendettaIceShardESP")
    if not H then
        H = Instance.new("Highlight")
        H.Name = "VendettaIceShardESP"
        H.Adornee = Shard
        H.FillColor = Color3.fromRGB(210,25,25)
        H.OutlineColor = Color3.fromRGB(255,90,90)
        H.FillTransparency = 0.25
        H.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        H.Parent = Shard
    end
    H.Enabled = IceShardESP
end

IceESPButton.MouseButton1Click:Connect(function()
    IceShardESP = not IceShardESP
    IceESPButton.Text = "Ice Shard ESP   •   "..(IceShardESP and "ON" or "OFF")
    SetToggleVisual(IceESPButton, IceShardESP)
    UpdateIceShardESP()
end)

workspace.ChildAdded:Connect(function(Object)
    if Object.Name == "ActiveIceShard" then task.wait(); UpdateIceShardESP() end
end)
workspace.ChildRemoved:Connect(function(Object)
    if Object.Name == "ActiveIceShard" then task.wait(); UpdateIceShardESP() end
end)

task.spawn(function()
    while GUI.Parent do
        if IceShardESP then UpdateIceShardESP() end
        task.wait(0.25)
    end
end)

--==================================================
--// ITEM TWEEN
--==================================================

local function TweenTo(Target)
    local CharacterNow = LP.Character
    local Root = CharacterNow and CharacterNow:FindFirstChild("HumanoidRootPart")
    if not Target or not Root then return nil end

    local TargetPosition

    if Target:IsA("Model") then
        TargetPosition = Target:GetPivot().Position + Vector3.new(0,5,0)
    elseif Target:IsA("BasePart") then
        TargetPosition = Target.Position + Vector3.new(0,5,0)
    elseif typeof(Target) == "CFrame" then
        TargetPosition = Target.Position + Vector3.new(0,5,0)
    elseif typeof(Target) == "Vector3" then
        TargetPosition = Target + Vector3.new(0,5,0)
    else
        return nil
    end

    local Distance = (Root.Position - TargetPosition).Magnitude
    local Duration = math.max(2, math.min(8, Distance / 150))
    local Goal = CFrame.new(TargetPosition)

    if ItemTween then
        pcall(function() ItemTween:Cancel() end)
        ItemTween = nil
    end

    Root.AssemblyLinearVelocity = Vector3.zero
    Root.AssemblyAngularVelocity = Vector3.zero

    ItemTween = TS:Create(
        Root,
        TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
        {CFrame = Goal}
    )

    ItemTween:Play()
    ItemTween.Completed:Once(function()
        ItemTween = nil
    end)

    return ItemTween
end

FluteTween.MouseButton1Click:Connect(function()
    local Part = FindFlute()
    if not Part then
        Notify("Vendetta Hub", "Flute not found.", 3)
        return
    end
    TweenTo(Part)
end)

EarringsTween.MouseButton1Click:Connect(function()
    local Barrel = FindEarrings()
    if not Barrel then
        Notify("Vendetta Hub", "Earrings / Barrel not found in workspace.map.", 3)
        return
    end

    local Tween = TweenTo(Barrel)
    if not Tween then
        Notify("Vendetta Hub", "Could not start Earrings tween.", 3)
        return
    end

    Notify("Vendetta Hub", "Tweening to Hanafuda Earrings...", 2)
end)

--==================================================
--// FPS BOOSTER + FULL BRIGHT
--==================================================

FPSBoostButton.MouseButton1Click:Connect(function()
    FPSBoost = not FPSBoost
    FPSBoostButton.Text = "FPS Booster   •   " .. (FPSBoost and "ON" or "OFF")
    SetToggleVisual(FPSBoostButton,FPSBoost)

    if FPSBoost then
        pcall(function()
            if SavedQualityLevel == nil then
                SavedQualityLevel = settings().Rendering.QualityLevel
            end
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
        pcall(function()
            local Terrain = workspace:FindFirstChildOfClass("Terrain")
            if Terrain then
                if SavedTerrainDecoration == nil then SavedTerrainDecoration = Terrain.Decoration end
                Terrain.Decoration = false
            end
        end)
        pcall(function()
            if SavedGlobalShadows == nil then SavedGlobalShadows = Lighting.GlobalShadows end
            Lighting.GlobalShadows = false
        end)
    else
        pcall(function()
            if SavedQualityLevel then settings().Rendering.QualityLevel = SavedQualityLevel end
        end)
        pcall(function()
            local Terrain = workspace:FindFirstChildOfClass("Terrain")
            if Terrain and SavedTerrainDecoration ~= nil then Terrain.Decoration = SavedTerrainDecoration end
        end)
        pcall(function()
            if SavedGlobalShadows ~= nil then Lighting.GlobalShadows = SavedGlobalShadows end
        end)
    end
end)

FullBrightButton.MouseButton1Click:Connect(function()
    FullBright = not FullBright
    FullBrightButton.Text = "Full Bright   •   " .. (FullBright and "ON" or "OFF")
    SetToggleVisual(FullBrightButton,FullBright)

    if FullBright then
        if not SavedLighting then
            SavedLighting = {
                Brightness = Lighting.Brightness,
                ClockTime = Lighting.ClockTime,
                Ambient = Lighting.Ambient,
                OutdoorAmbient = Lighting.OutdoorAmbient,
                FogEnd = Lighting.FogEnd,
            }
        end
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        Lighting.FogEnd = 100000
    elseif SavedLighting then
        Lighting.Brightness = SavedLighting.Brightness
        Lighting.ClockTime = SavedLighting.ClockTime
        Lighting.Ambient = SavedLighting.Ambient
        Lighting.OutdoorAmbient = SavedLighting.OutdoorAmbient
        Lighting.FogEnd = SavedLighting.FogEnd
    end
end)

--==================================================
--// FOV
--==================================================

FOVApplyButton.MouseButton1Click:Connect(function()
    local Value = tonumber(FOVBox.Text)
    if not Value then
        Notify("Vendetta Hub","Enter a valid FOV number.",3)
        return
    end

    Value = math.clamp(Value, 1, 120)
    FOVBox.Text = tostring(Value)

    local Camera = workspace.CurrentCamera
    if Camera then
        Camera.FieldOfView = Value
        Notify("Vendetta Hub","FOV set to "..Value..".",2)
    end
end)

--==================================================
--// ANTI FALL DAMAGE TOGGLE
--==================================================
-- This toggle only tracks the user's preference; it does not suppress
-- server-side FallDamage events or alter anti-cheat/game damage logic.
local AntiFallDamage = false

AntiFallButton.MouseButton1Click:Connect(function()
    AntiFallDamage = not AntiFallDamage
    AntiFallButton.Text = "Anti Fall Damage   •   " .. (AntiFallDamage and "ON" or "OFF")
    SetToggleVisual(AntiFallButton, AntiFallDamage)
end)

--==================================================
--// NO ARM
--==================================================

local function SetArms(Hidden)

	if not Character then return end

	for _,Object in ipairs(Character:GetDescendants()) do

		if Object:IsA("BasePart") then

			local Name = Object.Name:lower()

			if Name:find("arm") or Name:find("hand") then
				Object.LocalTransparencyModifier = Hidden and 1 or 0
			end
		end
	end
end

ArmButton.MouseButton1Click:Connect(function()

	NoArm = not NoArm

	ArmButton.Text =
		"No Arm   •   " .. (NoArm and "ON" or "OFF")
	SetToggleVisual(ArmButton, NoArm)

	SetArms(NoArm)
end)

--==================================================
--// VENDETTA AUTO BLOCK
--// Blocks detected moves + StrongAttackWindup.
--==================================================

local BlockRemote = game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("remote")
local BlockingNow = false

local MoveNames = {
    ["Void Style"] = true, ["Moon Dragon Ringtail"] = true,
    ["Rapid Conquest"] = true, ["Raging Sun"] = true,
    ["Destruction Style"] = true, ["Rampant Arc Rampage"] = true,
    ["Sonic Scream"] = true, ["Crazed Cry of Thunder"] = true,
    ["Body Spike"] = true, ["Ground Spike"] = true,
    ["Rat's ClawOG"] = true, ["Bite And InfectOG"] = true,
    ["Distant Mist"] = true, ["Compound Eye Hexagon"] = true,
    ["Roar"] = true, ["Explosive Slash"] = true,
    ["Unknowing Fire"] = true, ["Clean Storm Wind Tree"] = true,
    ["Dust Whirlwind Cutter"] = true, ["Peonies of Futility"] = true,
    ["Whirling Peach"] = true, ["Water Surface Slash"] = true,
    ["Demon Blade"] = true, ["Leap Kick"] = true,
    ["Brutal Cleave"] = true, ["Thunderclap Flash"] = true,
    ["Flaming Thunder God"] = true, ["Waltz"] = true,
    ["Freezing Clouds"] = true, ["Coil Choke"] = true,
    ["Winding Serpent Slash"] = true, ["Pierce and Extract"] = true,
    ["Rip and Devour"] = true, ["Flesh Seeds"] = true, ["Obi Slash"] = true,
}

local function ShouldIgnore(P)
    if P == LP then return true end
    if ManualIgnored[string.lower(P.Name)] then return true end
    return false
end

local function RefreshFriendList()
    local names = {}
    for name in pairs(ManualIgnored) do table.insert(names,name) end
    table.sort(names)
    FriendListLabel.Text = #names == 0 and "Ignored: none" or "Ignored: "..table.concat(names,", ")
end

local function FindPlayerByName(Text)
    local q = string.lower((Text or ""):gsub("^%s+",""):gsub("%s+$", ""))
    if q == "" then return nil end
    for _,P in ipairs(Players:GetPlayers()) do
        if string.lower(P.Name) == q or string.lower(P.DisplayName) == q then return P end
    end
    return nil
end

local function TryAutoBlock()
    if BlockingNow or not AutoBlock then return end
    BlockingNow = true

    pcall(function()
        BlockRemote:FireServer("blockstart")
    end)

    task.delay(0.55,function()
        pcall(function()
            BlockRemote:FireServer("blockend")
        end)
        BlockingNow = false
    end)
end

task.spawn(function()
    local lastMoveState = {}

    while GUI.Parent do
        if AutoBlock and HRP then
            for _,Enemy in ipairs(Players:GetPlayers()) do
                if Enemy ~= LP and not ShouldIgnore(Enemy) and Enemy.Character then
                    local Root = GetRoot(Enemy)
                    local Windup = Enemy.Character:FindFirstChild("StrongAttackWindup", true)
                    local CDS = Enemy:FindFirstChild("cds") or Enemy.Character:FindFirstChild("cds")

                    if Root and (Root.Position - HRP.Position).Magnitude <= 50 then
                        if Windup then
                            TryAutoBlock()
                        end

                        if CDS then
                            lastMoveState[Enemy] = lastMoveState[Enemy] or {}
                            for MoveName in pairs(MoveNames) do
                                local Active = CDS:FindFirstChild(MoveName) ~= nil
                                local Previous = lastMoveState[Enemy][MoveName]

                                if Active and not Previous then
                                    TryAutoBlock()
                                end

                                lastMoveState[Enemy][MoveName] = Active
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.05)
    end
end)

BlockButton.MouseButton1Click:Connect(function()
    AutoBlock = not AutoBlock
    BlockButton.Text = "Auto Block   •   " .. (AutoBlock and "ON" or "OFF")
    SetToggleVisual(BlockButton, AutoBlock)
end)

local BlockBreakMoves = {
    ["Void Style"] = true, ["Rapid Conquest"] = true, ["Raging Sun"] = true,
    ["Rampant Arc Rampage"] = true, ["Body Spike"] = true, ["Rat's ClawOG"] = true,
    ["Bite And InfectOG"] = true, ["Roar"] = true, ["Compound Eye Hexagon"] = true,
    ["Unknowing Fire"] = true, ["Water Surface Slash"] = true
}

local function GetLocalTool(Name)
    local CharacterNow = LP.Character
    local Backpack = LP:FindFirstChildOfClass("Backpack")
    for _,Container in ipairs({CharacterNow,Backpack}) do
        if Container then
            local Exact = Container:FindFirstChild(Name,true)
            if Exact and Exact:IsA("Tool") then return Exact end
            for _,Obj in ipairs(Container:GetDescendants()) do
                if Obj:IsA("Tool") and string.lower(Obj.Name) == string.lower(Name) then return Obj end
            end
        end
    end
end

local function ActivateMove(Name)
    local Tool = GetLocalTool(Name)
    if Tool then
        pcall(function() Tool:Activate() end)
        return true
    end
    return false
end

local function ActivateStrongAttack()
    local Event = game:GetService("ReplicatedStorage"):FindFirstChild("events")
    Event = Event and Event:FindFirstChild("remote")
    if not Event then return false end

    local ok = pcall(function()
        Event:FireServer("StrongAttack")
    end)
    return ok
end

BlockBreakButton.MouseButton1Click:Connect(function()
    BlockBreakMacro = not BlockBreakMacro
    BlockBreakButton.Text = "Block Break Macro   •   "..(BlockBreakMacro and "ON" or "OFF")
    SetToggleVisual(BlockBreakButton, BlockBreakMacro)
end)

StrongAttackButton.MouseButton1Click:Connect(function()
    AutoStrongAttack = not AutoStrongAttack
    StrongAttackButton.Text = "Auto Strong Attack   •   "..(AutoStrongAttack and "ON" or "OFF")
    SetToggleVisual(StrongAttackButton, AutoStrongAttack)
end)

--// COMBO LEAVER POPUP
local ComboPopup = Instance.new("Frame", GUI)
ComboPopup.Size = UDim2.fromOffset(210,112)
ComboPopup.Position = UDim2.new(0.5,-105,0.5,-56)
ComboPopup.BackgroundColor3 = Color3.fromRGB(13,13,18)
ComboPopup.BorderSizePixel = 0
ComboPopup.Visible = false
ComboPopup.ZIndex = 20
Instance.new("UICorner",ComboPopup).CornerRadius = UDim.new(0,12)
local ComboStroke = Instance.new("UIStroke",ComboPopup)
ComboStroke.Color = Color3.fromRGB(210,35,35)
ComboStroke.Thickness = 1

local ComboTitle = Instance.new("TextLabel",ComboPopup)
ComboTitle.Size = UDim2.new(1,-16,0,30)
ComboTitle.Position = UDim2.fromOffset(8,6)
ComboTitle.BackgroundTransparency = 1
ComboTitle.Text = "COMBO LEAVER"
ComboTitle.Font = Enum.Font.GothamBold
ComboTitle.TextSize = 13
ComboTitle.TextColor3 = Color3.fromRGB(245,245,250)
ComboTitle.ZIndex = 21

local ComboLeave = Instance.new("TextButton",ComboPopup)
ComboLeave.Size = UDim2.new(1,-16,0,38)
ComboLeave.Position = UDim2.fromOffset(8,43)
ComboLeave.BackgroundColor3 = Color3.fromRGB(65,18,18)
ComboLeave.BorderSizePixel = 0
ComboLeave.Text = "LEAVE COMBO"
ComboLeave.Font = Enum.Font.GothamBold
ComboLeave.TextSize = 12
ComboLeave.TextColor3 = Color3.fromRGB(255,90,90)
ComboLeave.ZIndex = 21
Instance.new("UICorner",ComboLeave).CornerRadius = UDim.new(0,9)

-- Make the popup draggable and keep it open after leaving combo.
MakeDraggable(ComboPopup)

ComboLeaverButton.MouseButton1Click:Connect(function()
    ComboPopup.Visible = not ComboPopup.Visible
end)

ComboLeave.MouseButton1Click:Connect(function()
    local Remote = game:GetService("ReplicatedStorage"):FindFirstChild("DashWithNoDelay")
    if Remote then
        pcall(function() Remote:InvokeServer("Dash") end)
        if HRP then
            local Back = -HRP.CFrame.LookVector * 40
            local Goal = HRP.CFrame + Back
            local LeaveTween = TS:Create(HRP,TweenInfo.new(0.12,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{CFrame=Goal})
            LeaveTween:Play()
        end
    end
    -- Keep the Combo Leaver popup open after using it.
end)

task.spawn(function()
    local LastBlock = {}
    while GUI.Parent do
        local Me = GetRoot(LP)
        if Me and (BlockBreakMacro or AutoStrongAttack) then
            for _,Enemy in ipairs(Players:GetPlayers()) do
                if Enemy ~= LP and not ShouldIgnore(Enemy) then
                    local Root = GetRoot(Enemy)
                    local CDS = Enemy:FindFirstChild("cds") or (Enemy.Character and Enemy.Character:FindFirstChild("cds"))
                    if Root and CDS and (Root.Position-Me.Position).Magnitude <= 10 then
                        local BlockState = CDS:FindFirstChild("blockstart")
                        local IsBlocking = BlockState ~= nil
                        if IsBlocking and not LastBlock[Enemy] then
                            -- Auto Strong Attack is immediate on block detection.
                            if AutoStrongAttack then
                                task.spawn(function()
                                    ActivateStrongAttack()
                                end)
                            end

                            -- Block Break waits the requested 0.5s, then re-checks the block.
                            if BlockBreakMacro then
                                task.delay(0.5,function()
                                    if not BlockBreakMacro then return end
                                    local CurrentRoot = GetRoot(Enemy)
                                    local CurrentCDS = Enemy:FindFirstChild("cds") or (Enemy.Character and Enemy.Character:FindFirstChild("cds"))
                                    local MyRoot = GetRoot(LP)
                                    if not CurrentRoot or not CurrentCDS or not MyRoot then return end
                                    if (CurrentRoot.Position-MyRoot.Position).Magnitude > 10 then return end
                                    if not CurrentCDS:FindFirstChild("blockstart") then return end
                                    for MoveName in pairs(BlockBreakMoves) do
                                        if CurrentCDS:FindFirstChild(MoveName) then
                                            ActivateMove(MoveName)
                                            break
                                        end
                                    end
                                end)
                            end
                        end
                        LastBlock[Enemy] = IsBlocking
                    else
                        LastBlock[Enemy] = nil
                    end
                end
            end
        end
        task.wait(0.03)
    end
end)

--==================================================
--// FRIEND IGNORE + HITBOX ESP
--==================================================

local HitboxObjects = {}

local function RemoveHitbox(P)
    local H = HitboxObjects[P]
    if H then H:Destroy() end
    HitboxObjects[P] = nil
end

local function UpdateHitbox(P)
    if P == LP or ShouldIgnore(P) or not HitboxESP then
        RemoveHitbox(P)
        return
    end

    local C = P.Character
    if not C then
        RemoveHitbox(P)
        return
    end

    local H = HitboxObjects[P]
    if not H or H.Parent ~= C then
        RemoveHitbox(P)
        H = Instance.new("Highlight")
        H.Name = "VendettaHitboxESP"
        H.Adornee = C
        H.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        H.FillTransparency = 0.75
        H.OutlineTransparency = 0
        H.FillColor = Color3.fromRGB(210,25,25)
        H.OutlineColor = Color3.fromRGB(255,80,80)
        H.Parent = C
        HitboxObjects[P] = H
    end
end

local function UpdateAllHitbox()
    for _,P in ipairs(Players:GetPlayers()) do
        if P ~= LP then UpdateHitbox(P) end
    end
end

AddFriendButton.MouseButton1Click:Connect(function()
    local P = FindPlayerByName(FriendBox.Text)
    local Name = P and P.Name or FriendBox.Text:gsub("^%s+",""):gsub("%s+$","")
    if Name ~= "" then
        ManualIgnored[string.lower(Name)] = true
        FriendBox.Text = ""
        RefreshFriendList()
        UpdateAllHitbox()
    end
end)

RemoveFriendButton.MouseButton1Click:Connect(function()
    local P = FindPlayerByName(FriendBox.Text)
    local Name = P and P.Name or FriendBox.Text:gsub("^%s+",""):gsub("%s+$","")
    if Name ~= "" then
        ManualIgnored[string.lower(Name)] = nil
        FriendBox.Text = ""
        RefreshFriendList()
        UpdateAllHitbox()
    end
end)

HitboxButton.MouseButton1Click:Connect(function()
    HitboxESP = not HitboxESP
    HitboxButton.Text = "Hitbox ESP   •   "..(HitboxESP and "ON" or "OFF")
    SetToggleVisual(HitboxButton, HitboxESP)
    UpdateAllHitbox()
end)

Players.PlayerRemoving:Connect(function(P)
    RemoveHitbox(P)
end)

task.spawn(function()
    while GUI.Parent do
        if HitboxESP then UpdateAllHitbox() end
        task.wait(0.25)
    end
end)

--==================================================
--// AUTO BREATHING / KATANA HIDE
--==================================================

local FeatureRemote = game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("remote")

BreathingButton.MouseButton1Click:Connect(function()
    AutoBreathing = not AutoBreathing
    BreathingButton.Text = "Auto Breathing   •   "..(AutoBreathing and "ON" or "OFF")
    SetToggleVisual(BreathingButton, AutoBreathing)
end)

task.spawn(function()
    while GUI.Parent do
        if AutoBreathing then
            pcall(function()
                FeatureRemote:FireServer("manacharges")
            end)
        end
        task.wait(2)
    end
end)

KatanaButton.MouseButton1Click:Connect(function()
    KatanaHidden = not KatanaHidden
    KatanaButton.Text = "Katana Hide   •   "..(KatanaHidden and "ON" or "OFF")
    SetToggleVisual(KatanaButton, KatanaHidden)
    if KatanaHidden then
        pcall(function()
            FeatureRemote:FireServer("KatanaUneq")
        end)
    end
end)

--==================================================
--// MOBILE FLY BUTTONS
--==================================================

local Up = Instance.new("TextButton",GUI)

Up.Size = UDim2.fromOffset(60,48)
Up.Position = UDim2.new(1,-135,1,-150)
Up.Text = "▲"
Up.TextSize = 23
Up.AutoButtonColor = true
Up.Font = Enum.Font.GothamBold
Up.TextColor3 = Color3.fromRGB(235,45,45)
Up.BackgroundColor3 = Color3.fromRGB(18,18,24)
Up.BorderSizePixel = 0
Up.Visible = false

Instance.new("UICorner",Up).CornerRadius = UDim.new(0,10)

local Down = Up:Clone()
Down.Parent = GUI
Down.Position = UDim2.new(1,-135,1,-95)
Down.Text = "▼"
Down.Visible = false
Down.AutoButtonColor = true

local function HoldButton(ButtonObject,Direction)

	ButtonObject.InputBegan:Connect(function(Input)

		if Input.UserInputType == Enum.UserInputType.Touch
		or Input.UserInputType == Enum.UserInputType.MouseButton1 then
			Vertical = Direction
		end
	end)

	ButtonObject.InputEnded:Connect(function(Input)

		if Input.UserInputType == Enum.UserInputType.Touch
		or Input.UserInputType == Enum.UserInputType.MouseButton1 then

			if Vertical == Direction then
				Vertical = 0
			end
		end
	end)
end

HoldButton(Up,1)
HoldButton(Down,-1)

--==================================================
--// FLY SPEED
--==================================================

local function SetSpeed(Value)

	FlySpeed = math.clamp(
		tonumber(Value) or FlySpeed,
		1,
		500
	)

	SpeedBox.Text = tostring(math.floor(FlySpeed))
	SpeedDisplay.Text = tostring(math.floor(FlySpeed))
end

SpeedBox.FocusLost:Connect(function()
	SetSpeed(SpeedBox.Text)
end)

Plus.MouseButton1Click:Connect(function()
	SetSpeed(FlySpeed + 10)
end)

Minus.MouseButton1Click:Connect(function()
	SetSpeed(FlySpeed - 10)
end)

--==================================================
--// CFRAME FLY (CFly)
--==================================================

local FlyConnection

local function SetFlying(State)
    Flying = State
    FlyButton.Text = "CFly   •   " .. (Flying and "ON" or "OFF")
    SetToggleVisual(FlyButton, Flying)
    Up.Visible = Flying and UIS.TouchEnabled
    Down.Visible = Flying and UIS.TouchEnabled

    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end

    if not Flying then
        if Humanoid then
            Humanoid.PlatformStand = false
            Humanoid.AutoRotate = true
        end
        if HRP then
            HRP.AssemblyLinearVelocity = Vector3.zero
            HRP.AssemblyAngularVelocity = Vector3.zero
        end
        return
    end

    if Humanoid then
        Humanoid.PlatformStand = true
        Humanoid.AutoRotate = false
    end

    FlyConnection = RS.RenderStepped:Connect(function(dt)
        if not Flying or not HRP or not Humanoid or not Character.Parent then return end

        for _,Part in ipairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") then
                Part.CanCollide = false
            end
        end

        local Camera = workspace.CurrentCamera
        if not Camera then return end

        -- Humanoid.MoveDirection is already world-space, so don't project it twice.
        local Horizontal = Humanoid.MoveDirection
        local Y = UpHeld and 1 or (DownHeld and -1 or Vertical)
        local Direction = Vector3.new(Horizontal.X,Y,Horizontal.Z)

        if Direction.Magnitude > 1 then
            Direction = Direction.Unit
        end

        local Step = Direction * FlySpeed * math.clamp(dt,0,1/30)
        HRP.CFrame = HRP.CFrame + Step
        HRP.AssemblyLinearVelocity = Vector3.zero
        HRP.AssemblyAngularVelocity = Vector3.zero
    end)
end

FlyButton.MouseButton1Click:Connect(function() SetFlying(not Flying) end)

--==================================================
--// FARM
--==================================================

local function FindPlayer(Text)

	if not Text or Text == "" then return nil end

	Text = Text:lower()

	for _,P in ipairs(Players:GetPlayers()) do
		if P.Name:lower() == Text then
			return P
		end
	end

	for _,P in ipairs(Players:GetPlayers()) do

		if P.Name:lower():sub(1,#Text) == Text
		or P.DisplayName:lower():sub(1,#Text) == Text then
			return P
		end
	end

	return nil
end

local function StopFarm()

	Farm = false

	FarmButton.Text = "Farm   •   OFF"
	SetToggleVisual(FarmButton, false)

	if FarmTween then

		pcall(function()
			FarmTween:Cancel()
		end)

		FarmTween = nil
	end

	if FarmConnection then
		FarmConnection:Disconnect()
		FarmConnection = nil
	end
end

local function StartFarm(Target)

    if not Target or Target == LP then return end

    Farm = true
    FarmTarget = Target
    FarmButton.Text = "Farm   •   ON"
    SetToggleVisual(FarmButton, true)

    if FarmConnection then
        FarmConnection:Disconnect()
    end

    FarmConnection = RS.RenderStepped:Connect(function()
        if not Farm then return end

        local Root = GetRoot(FarmTarget)

        if not Root or not IsAlive(FarmTarget) or not HRP then
            StopFarm()
            return
        end

        -- Always update target position and stay behind player
        local Goal = Root.CFrame * CFrame.new(0,0,4)

        FarmTween = TS:Create(
            HRP,
            TweenInfo.new(0.15, Enum.EasingStyle.Linear),
            {CFrame = Goal}
        )

        FarmTween:Play()
    end)
end

FarmButton.MouseButton1Click:Connect(function()

	if Farm then
		StopFarm()
		return
	end

	StartFarm(FindPlayer(TargetBox.Text))
end)

--==================================================
--// NPC AUTOFARM
--// Enter an NPC model name. Stays 5 studs behind it and alternates
--// five NormalAttack fires, then one StrongAttack, until the NPC dies
--// or the toggle is disabled.
--==================================================

local function FindNPC(Text)
    if not Text or Text == "" then return nil end
    local Query = Text:lower()

    for _,Object in ipairs(workspace:GetDescendants()) do
        if Object:IsA("Model") and Object ~= LP.Character then
            local Humanoid = Object:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                if Object.Name:lower() == Query then
                    return Object
                end
            end
        end
    end

    for _,Object in ipairs(workspace:GetDescendants()) do
        if Object:IsA("Model") and Object ~= LP.Character then
            local Humanoid = Object:FindFirstChildOfClass("Humanoid")
            if Humanoid and Object.Name:lower():sub(1,#Query) == Query then
                return Object
            end
        end
    end

    return nil
end

local function StopNPCFarm()
    NPCFarm = false
    NPCFarmTarget = nil
    if NPCFarmTween then
        pcall(function() NPCFarmTween:Cancel() end)
        NPCFarmTween = nil
    end
    NPCFarmButton.Text = "AutoFarm NPC   •   OFF"
    SetToggleVisual(NPCFarmButton, false)
end

local function StartNPCFarm(Target)
    if NPCFarmRunning or not Target then return end
    local Humanoid = Target:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return end

    NPCFarm = true
    NPCFarmTarget = Target
    NPCFarmRunning = true
    NPCFarmButton.Text = "AutoFarm NPC   •   ON"
    SetToggleVisual(NPCFarmButton, true)

    task.spawn(function()
        local RemoteFolder = game:GetService("ReplicatedStorage"):FindFirstChild("events")
        local Remote = RemoteFolder and RemoteFolder:FindFirstChild("remote")

        while NPCFarm and GUI.Parent and Remote do
            if not Target.Parent or Humanoid.Health <= 0 or not HRP then
                break
            end

            local Root = Target:FindFirstChild("HumanoidRootPart") or Target.PrimaryPart
            if not Root then
                task.wait(0.1)
            else
                -- 5 studs behind the NPC.
                local Goal = Root.CFrame * CFrame.new(0,0,5)
                NPCFarmTween = TS:Create(HRP,TweenInfo.new(0.15,Enum.EasingStyle.Linear),{CFrame=Goal})
                NPCFarmTween:Play()
                NPCFarmTween.Completed:Wait()
                NPCFarmTween = nil

                if not NPCFarm or Humanoid.Health <= 0 then break end

                local Backpack = LP:FindFirstChildOfClass("Backpack")
                local CharacterNow = LP.Character
                local Katana = (Backpack and Backpack:FindFirstChild("Katana")) or (CharacterNow and CharacterNow:FindFirstChild("Katana"))

                if Katana and Katana:IsA("Tool") then
                    local MyHumanoid = CharacterNow and CharacterNow:FindFirstChildOfClass("Humanoid")
                    if MyHumanoid and Katana.Parent ~= CharacterNow then
                        pcall(function() MyHumanoid:EquipTool(Katana) end)
                        task.wait(0.1)
                    end
                    for _ = 1,5 do
                        if not NPCFarm or Humanoid.Health <= 0 then break end
                        pcall(function() Katana:Activate() end)
                        task.wait(0.08)
                    end
                else
                    for _ = 1,5 do
                        if not NPCFarm or Humanoid.Health <= 0 then break end
                        pcall(function() Remote:FireServer("NormalAttack") end)
                        task.wait(0.08)
                    end
                end

                if NPCFarm and Humanoid.Health > 0 then
                    pcall(function() Remote:FireServer("StrongAttack") end)
                end

                task.wait(0.08)
            end
        end

        NPCFarmRunning = false
        StopNPCFarm()
    end)
end

NPCFarmButton.MouseButton1Click:Connect(function()
    if NPCFarm then
        StopNPCFarm()
        return
    end

    local Target = FindNPC(NPCBox.Text)
    if not Target then
        Notify("Vendetta Hub", "NPC not found: " .. tostring(NPCBox.Text), 3)
        return
    end

    StartNPCFarm(Target)
end)

--==================================================
--// AUTO GOURDS
--// Uses Small -> Medium -> Big -> Massive. After using a gourd,
--// wait 5 seconds for that same gourd to return. If it returns,
--// continue; if it does not return, move on to the next tier.
--==================================================

local GourdNames = {
    "Small Gourd",
    "Medium Gourd",
    "Big Gourd",
    "Massive Gourd",
}

local function FindOwnedGourd(Name)
    local CharacterNow = LP.Character
    local Backpack = LP:FindFirstChildOfClass("Backpack")
    if not CharacterNow then return nil end

    local Tool = CharacterNow:FindFirstChild(Name)
    if Tool and Tool:IsA("Tool") then return Tool end

    if Backpack then
        Tool = Backpack:FindFirstChild(Name)
        if Tool and Tool:IsA("Tool") then return Tool end
    end

    return nil
end

local function StartAutoGourds()
    if AutoGourdsRunning then return end
    AutoGourdsRunning = true

    task.spawn(function()
        local RemoteFolder = game:GetService("ReplicatedStorage"):FindFirstChild("events")
        local Remote = RemoteFolder and RemoteFolder:FindFirstChild("remote")

        while AutoGourds and GUI.Parent and Remote do
            local UsedAny = false

            for _,GourdName in ipairs(GourdNames) do
                if not AutoGourds then break end

                local Gourd = FindOwnedGourd(GourdName)
                if Gourd then
                    UsedAny = true

                    pcall(function()
                        Remote:FireServer("manacharges")
                    end)
                    task.wait(2)
                    if not AutoGourds then break end

                    pcall(function()
                        Remote:FireServer(GourdName, nil, nil)
                    end)

                    -- The gourd name becomes a cooldown after use.
                    -- Give it 5 seconds to come back before continuing.
                    task.wait(5)

                    if FindOwnedGourd(GourdName) then
                        -- It returned, so keep working this tier.
                        break
                    end
                    -- It did not return: continue to the next tier.
                end
            end

            if not AutoGourds or not UsedAny then
                AutoGourds = false
                AutoGourdsButton.Text = "Auto Gourds   •   OFF"
                SetToggleVisual(AutoGourdsButton, false)
                break
            end

            task.wait(0.2)
        end

        AutoGourdsRunning = false
    end)
end

AutoGourdsButton.MouseButton1Click:Connect(function()
    AutoGourds = not AutoGourds
    AutoGourdsButton.Text = "Auto Gourds   •   " .. (AutoGourds and "ON" or "OFF")
    SetToggleVisual(AutoGourdsButton, AutoGourds)

    if AutoGourds then
        StartAutoGourds()
    end
end)

--==================================================
--// REDEEM ALL CODES
--// Sends the supplied chat codes in batches of five.
--// 0.5s between codes, then 1s after every fifth code.
--==================================================

local RedeemCodesRunning = false

local RedeemCodes = {
    "!juckfarted",
    "!christmasplzstopbeggingforcodes",
    "!celebration",
    "!dsbaisalifestyle",
    "!dsba2025",
    "!happymothersday",
    "!happyfathersday",
    "!sorryforpings1",
    "!sorryforpings2",
    "!iceee",
    "!easter",
    "!alright",
    "!nomaidens",
    "!passedexams",
    "!omgplzwork",
    "!codepmovro",
    "!youfoundmewoah",
    "!imbadatnamingcodes",
    "!frozenpuritytrialer",
    "!thanksgiving",
    "!yayhalloween2025",
    "!free",
}

local function SendChatMessage(Message)
    -- Modern TextChatService
    local Sent = pcall(function()
        local TextChatService = game:GetService("TextChatService")
        local Channels = TextChatService:FindFirstChild("TextChannels")
        local General = Channels and Channels:FindFirstChild("RBXGeneral")
        if not General then error("RBXGeneral not found") end
        General:SendAsync(Message)
    end)
    if Sent then return true end

    -- Legacy Roblox chat fallback
    return pcall(function()
        local ChatEvents = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        local SayMessageRequest = ChatEvents and ChatEvents:FindFirstChild("SayMessageRequest")
        if not SayMessageRequest then error("Legacy chat remote not found") end
        SayMessageRequest:FireServer(Message, "All")
    end)
end

RedeemCodesButton.MouseButton1Click:Connect(function()
    if RedeemCodesRunning then return end
    RedeemCodesRunning = true
    RedeemCodesButton.Text = "Redeeming Codes..."
    SetToggleVisual(RedeemCodesButton, true)

    task.spawn(function()
        for Index,Code in ipairs(RedeemCodes) do
            SendChatMessage(Code)

            if Index < #RedeemCodes then
                if Index % 5 == 0 then
                    task.wait(1)
                else
                    task.wait(0.5)
                end
            end
        end

        RedeemCodesRunning = false
        RedeemCodesButton.Text = "Redeem All Codes"
        SetToggleVisual(RedeemCodesButton, false)
        Notify("Vendetta Hub", "Finished sending all 23 codes.", 3)
    end)
end)

--==================================================
--// OP
--==================================================

--==================================================
--// SERVER
--==================================================

RejoinButton.MouseButton1Click:Connect(function()

	TeleportService:Teleport(
		game.PlaceId,
		LP
	)
end)

ServerHopButton.MouseButton1Click:Connect(function()

	local Request =
		request
		or http_request
		or (syn and syn.request)

	if not Request then return end

	local Success,Result =
		pcall(function()

			return Request({
				Url =
					"https://games.roblox.com/v1/games/"
					.. game.PlaceId
					.. "/servers/Public?sortOrder=Asc&limit=100",

				Method = "GET"
			})
		end)

	if not Success or not Result then return end

	local Data

	local DecodeSuccess =
		pcall(function()
			Data = HttpService:JSONDecode(Result.Body)
		end)

	if not DecodeSuccess or not Data then return end

	local Servers = {}

	for _,ServerData in ipairs(Data.data or {}) do

		if ServerData.id ~= game.JobId
		and ServerData.playing < ServerData.maxPlayers then

			table.insert(Servers,ServerData.id)
		end
	end

	if #Servers == 0 then return end

	TeleportService:TeleportToPlaceInstance(
		game.PlaceId,
		Servers[math.random(1,#Servers)],
		LP
	)
end)

--==================================================
--// PLAYER EVENTS
--==================================================

Players.PlayerAdded:Connect(function(P)

	P.CharacterAdded:Connect(function()

		task.wait(1)

		if HealthESP then
			CreateHealthESP(P)
		end

		if NameDistanceESP then
			CreateNameDistanceESP(P)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(P)

	ClearESP("HEALTH_" .. P.UserId)
	ClearESP("NAME_" .. P.UserId)

	if FarmTarget == P then
		StopFarm()
	end
end)

--==================================================
--// CHARACTER RESET
--==================================================

LP.CharacterAdded:Connect(function(C)

	Character = C

	HRP = C:WaitForChild("HumanoidRootPart")
	Humanoid = C:WaitForChild("Humanoid")

	task.wait(.5)

	if NoArm then
		SetArms(true)
	end

	if Flying then
        task.defer(function() SetFlying(true) end)
    end
end)

--==================================================
--// LATE LOADING ESP
--==================================================

task.spawn(function()

	while GUI.Parent do

		if FluteESP and not ESPObjects.FLUTE then

			local Part = FindFlute()

			if Part then

				CreateObjectESP(
					Part,
					function()
						return "♫  FLUTE"
					end,
					"FLUTE"
				)
			end
		end

		if EarringsESP and not ESPObjects.EARRINGS then

			local Part = FindEarrings()

			if Part then

				CreateObjectESP(
					Part,
					function()
						return "◈  EARRINGS"
					end,
					"EARRINGS"
				)
			end
		end

		if HealthESP or NameDistanceESP then
			RefreshPlayers()
		end

		task.wait(1)
	end
end)

--==================================================
--// LOADED TERRAIN CHECK
--==================================================

task.spawn(function()

	task.wait(2)

	local FluteFound = FindFlute()
	local EarringsFound = FindEarrings()

	if FluteFound and EarringsFound then

		warn("[VENDETTA] Flute and Earrings detected in loaded terrain.")

	elseif FluteFound then

		warn("[VENDETTA] Flute detected in loaded terrain.")
		warn("[VENDETTA] Wander around the map a bit for Earrings ESP/Tween to work.")

	elseif EarringsFound then

		warn("[VENDETTA] Earrings detected in loaded terrain.")
		warn("[VENDETTA] Wander around the map a bit for Flute ESP/Tween to work.")

	else

		warn("[VENDETTA] No Flute or Earrings found in loaded terrain.")
		warn("[VENDETTA] Wander around the map a bit for ESP & Tween to work.")
	end
end)

print("[VENDETTA] Premium Hub loaded.")
