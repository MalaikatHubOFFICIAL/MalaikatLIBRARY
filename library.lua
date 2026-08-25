--==============================================================================
--          MALAIKAT UI - iOS 26 ULTRA INTERACTIVE GLASS EDITION
--==============================================================================

-- Services Definition
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Global State Management
local isSliderDragging = false
local isMinimized = false
local isDraggingMain = false
local dragStartPos = Vector2.zero
local frameStartPos = UDim2.new()

-- Clean Up Old Instances
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("MalaikatUIGui") then
	LocalPlayer.PlayerGui.MalaikatUIGui:Destroy()
end

-- Primary ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MalaikatUIGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Color Palettes Engine (iOS 26 Liquid Frosted Glass)
local Themes = {
	Dark = {
		MainBg = Color3.fromRGB(12, 13, 18),
		MainBgTransparency = 0.2,
		SideBg = Color3.fromRGB(8, 9, 13),
		CardBg = Color3.fromRGB(22, 23, 32),
		SelectorBg = Color3.fromRGB(0, 122, 255),
		TextPrimary = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(140, 145, 165),
		Stroke = Color3.fromRGB(255, 255, 255),
		StrokeTransparency = 0.88,
		InputBg = Color3.fromRGB(16, 17, 24),
		Accent = Color3.fromRGB(0, 122, 255),
		Success = Color3.fromRGB(52, 199, 89),
		Danger = Color3.fromRGB(255, 59, 48),
		Glow = Color3.fromRGB(0, 122, 255)
	},
	Light = {
		MainBg = Color3.fromRGB(245, 245, 250),
		MainBgTransparency = 0.1,
		SideBg = Color3.fromRGB(230, 230, 240),
		CardBg = Color3.fromRGB(255, 255, 255),
		SelectorBg = Color3.fromRGB(0, 122, 255),
		TextPrimary = Color3.fromRGB(10, 10, 15),
		TextSecondary = Color3.fromRGB(100, 105, 120),
		Stroke = Color3.fromRGB(0, 0, 0),
		StrokeTransparency = 0.9,
		InputBg = Color3.fromRGB(235, 235, 245),
		Accent = Color3.fromRGB(0, 122, 255),
		Success = Color3.fromRGB(52, 199, 89),
		Danger = Color3.fromRGB(255, 59, 48),
		Glow = Color3.fromRGB(0, 122, 255)
	}
}

local currentThemeName = "Dark"
local currentTheme = Themes.Dark

local ThemeElements = {
	Cards = {},
	Strokes = {},
	TextPrimary = {},
	TextSecondary = {},
	InputBoxes = {},
	ToggleBtns = {},
	Accents = {}
}

--==============================================================================
-- PHYSICS & ULTRA SMOOTH ANIMATION MATH ENGINE
--==============================================================================

local FastTweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local SpringTweenInfo = TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local UltraSmoothTweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

local function FastTween(instance, properties)
	local tween = TweenService:Create(instance, FastTweenInfo, properties)
	tween:Play()
	return tween
end

local function SmoothTween(instance, properties)
	local tween = TweenService:Create(instance, UltraSmoothTweenInfo, properties)
	tween:Play()
	return tween
end

local function SpringTween(instance, properties)
	local tween = TweenService:Create(instance, SpringTweenInfo, properties)
	tween:Play()
	return tween
end

-- Custom Interactive Ripple Surface Effect
local function CreateRipple(parentFrame, x, y)
	task.spawn(function()
		local ripple = Instance.new("Frame")
		ripple.Name = "RippleEffect"
		ripple.AnchorPoint = Vector2.new(0.5, 0.5)
		ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ripple.BackgroundTransparency = 0.6
		ripple.BorderSizePixel = 0
		ripple.ZIndex = 20

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = ripple

		local absolutePosition = parentFrame.AbsolutePosition
		ripple.Position = UDim2.new(0, x - absolutePosition.X, 0, y - absolutePosition.Y)
		ripple.Size = UDim2.new(0, 0, 0, 0)
		ripple.Parent = parentFrame

		local targetSize = math.max(parentFrame.AbsoluteSize.X, parentFrame.AbsoluteSize.Y) * 2
		local tween = TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, targetSize, 0, targetSize),
			BackgroundTransparency = 1
		})
		tween:Play()
		tween.Completed:Wait()
		ripple:Destroy()
	end)
end

-- Universal Hover Glow & Scale Interaction
local function AttachCardInteractivity(frame, stroke)
	frame.MouseEnter:Connect(function()
		FastTween(frame, {BackgroundTransparency = 0.25})
		FastTween(stroke, {Color = Color3.fromRGB(0, 122, 255), Transparency = 0.4})
	end)
	frame.MouseLeave:Connect(function()
		FastTween(frame, {BackgroundTransparency = 0.45})
		FastTween(stroke, {Color = currentTheme.Stroke, Transparency = currentTheme.StrokeTransparency})
	end)
end

--==============================================================================
-- DYNAMIC ISLAND NOTIFICATION QUEUE SYSTEM
--==============================================================================

local NotifHolder = Instance.new("Frame")
NotifHolder.Name = "NotifHolder"
NotifHolder.Size = UDim2.new(0, 290, 1, -20)
NotifHolder.Position = UDim2.new(1, -300, 0, 10)
NotifHolder.BackgroundTransparency = 1
NotifHolder.ZIndex = 1000
NotifHolder.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotifLayout.Padding = UDim.new(0, 10)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Parent = NotifHolder

local function Notify(title, message, duration)
	duration = duration or 3.5
	
	local Card = Instance.new("Frame")
	Card.Name = "NotifCard"
	Card.Size = UDim2.new(0, 0, 0, 58)
	Card.BackgroundColor3 = currentTheme.SideBg
	Card.BackgroundTransparency = 0.15
	Card.ClipsDescendants = true
	Card.Parent = NotifHolder

	local CardCorner = Instance.new("UICorner")
	CardCorner.CornerRadius = UDim.new(0, 18)
	CardCorner.Parent = Card

	local CardStroke = Instance.new("UIStroke")
	CardStroke.Color = currentTheme.Stroke
	CardStroke.Thickness = 1.2
	CardStroke.Transparency = 0.85
	CardStroke.Parent = Card

	local GlowBar = Instance.new("Frame")
	GlowBar.Size = UDim2.new(0, 4, 0, 26)
	GlowBar.Position = UDim2.new(0, 12, 0.5, -13)
	GlowBar.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
	GlowBar.Parent = Card

	local GlowCorner = Instance.new("UICorner")
	GlowCorner.CornerRadius = UDim.new(1, 0)
	GlowCorner.Parent = GlowBar

	local TitleLbl = Instance.new("TextLabel")
	TitleLbl.Size = UDim2.new(1, -30, 0, 18)
	TitleLbl.Position = UDim2.new(0, 26, 0, 10)
	TitleLbl.BackgroundTransparency = 1
	TitleLbl.Text = title
	TitleLbl.TextColor3 = currentTheme.TextPrimary
	TitleLbl.TextSize = 13
	TitleLbl.Font = Enum.Font.GothamBold
	TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
	TitleLbl.TextTransparency = 1
	TitleLbl.Parent = Card

	local MsgLbl = Instance.new("TextLabel")
	MsgLbl.Size = UDim2.new(1, -30, 0, 18)
	MsgLbl.Position = UDim2.new(0, 26, 0, 28)
	MsgLbl.BackgroundTransparency = 1
	MsgLbl.Text = message
	MsgLbl.TextColor3 = currentTheme.TextSecondary
	MsgLbl.TextSize = 11
	MsgLbl.Font = Enum.Font.Gotham
	MsgLbl.TextXAlignment = Enum.TextXAlignment.Left
	MsgLbl.TextTransparency = 1
	MsgLbl.Parent = Card

	SpringTween(Card, {Size = UDim2.new(1, 0, 0, 58)})
	FastTween(TitleLbl, {TextTransparency = 0})
	FastTween(MsgLbl, {TextTransparency = 0})

	task.delay(duration, function()
		local dismiss = SmoothTween(Card, {Size = UDim2.new(0, 0, 0, 58), BackgroundTransparency = 1})
		FastTween(TitleLbl, {TextTransparency = 1})
		FastTween(MsgLbl, {TextTransparency = 1})
		FastTween(CardStroke, {Transparency = 1})
		dismiss.Completed:Connect(function()
			Card:Destroy()
		end)
	end)
end

--==============================================================================
-- MAIN CONTAINER & AMBIENT GRAPHICS ENGINE
--==============================================================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 410)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -205)
MainFrame.BackgroundColor3 = currentTheme.MainBg
MainFrame.BackgroundTransparency = currentTheme.MainBgTransparency
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Parent = ScreenGui

local AmbientContainer = Instance.new("Frame")
AmbientContainer.Name = "AmbientContainer"
AmbientContainer.Size = UDim2.new(1, 0, 1, 0)
AmbientContainer.BackgroundTransparency = 1
AmbientContainer.ClipsDescendants = true
AmbientContainer.ZIndex = 0
AmbientContainer.Parent = MainFrame

local AmbientCorner = Instance.new("UICorner")
AmbientCorner.CornerRadius = UDim.new(0, 22)
AmbientCorner.Parent = AmbientContainer

local Orb1 = Instance.new("ImageLabel")
Orb1.Size = UDim2.new(0, 320, 0, 320)
Orb1.Position = UDim2.new(-0.2, 0, -0.2, 0)
Orb1.BackgroundTransparency = 1
Orb1.Image = "rbxassetid://5810228302"
Orb1.ImageColor3 = Color3.fromRGB(0, 122, 255)
Orb1.ImageTransparency = 0.55
Orb1.ZIndex = 0
Orb1.Parent = AmbientContainer

local Orb2 = Instance.new("ImageLabel")
Orb2.Size = UDim2.new(0, 340, 0, 340)
Orb2.Position = UDim2.new(0.6, 0, 0.5, 0)
Orb2.BackgroundTransparency = 1
Orb2.Image = "rbxassetid://5810228302"
Orb2.ImageColor3 = Color3.fromRGB(160, 0, 255)
Orb2.ImageTransparency = 0.6
Orb2.ZIndex = 0
Orb2.Parent = AmbientContainer

RunService.RenderStepped:Connect(function()
	local t = tick()
	Orb1.Position = UDim2.new(-0.2 + math.sin(t * 0.7) * 0.06, 0, -0.2 + math.cos(t * 0.5) * 0.06, 0)
	Orb2.Position = UDim2.new(0.6 + math.cos(t * 0.6) * 0.07, 0, 0.5 + math.sin(t * 0.8) * 0.06, 0)
end)

local MainShadow = Instance.new("ImageLabel")
MainShadow.Name = "MainShadow"
MainShadow.AnchorPoint = Vector2.new(0.5, 0.5)
MainShadow.Position = UDim2.new(0.5, 0, 0.5, 4)
MainShadow.Size = UDim2.new(1, 46, 1, 46)
MainShadow.BackgroundTransparency = 1
MainShadow.Image = "rbxassetid://6014261993"
MainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
MainShadow.ImageTransparency = 0.35
MainShadow.ScaleType = Enum.ScaleType.Slice
MainShadow.SliceCenter = Rect.new(49, 49, 49, 49)
MainShadow.ZIndex = 0
MainShadow.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 22)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = currentTheme.Stroke
MainStroke.Thickness = 1.2
MainStroke.Transparency = currentTheme.StrokeTransparency
MainStroke.Parent = MainFrame

--==============================================================================
-- HEADER & iOS TRAFFIC CONTROL SYSTEM
--==============================================================================

local TitleContainer = Instance.new("Frame")
TitleContainer.Size = UDim2.new(0, 350, 0, 30)
TitleContainer.Position = UDim2.new(0, 16, 0, 10)
TitleContainer.BackgroundTransparency = 1
TitleContainer.ZIndex = 2
TitleContainer.Parent = MainFrame

local TitleLayout = Instance.new("UIListLayout")
TitleLayout.FillDirection = Enum.FillDirection.Horizontal
TitleLayout.SortOrder = Enum.SortOrder.LayoutOrder
TitleLayout.Padding = UDim.new(0, 6)
TitleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TitleLayout.Parent = TitleContainer

local TitleMalaikat = Instance.new("TextLabel")
TitleMalaikat.Size = UDim2.new(0, 0, 1, 0)
TitleMalaikat.AutomaticSize = Enum.AutomaticSize.X
TitleMalaikat.BackgroundTransparency = 1
TitleMalaikat.Text = "MALAIKAT"
TitleMalaikat.TextColor3 = currentTheme.TextPrimary
TitleMalaikat.TextSize = 16
TitleMalaikat.Font = Enum.Font.GothamBold
TitleMalaikat.LayoutOrder = 1
TitleMalaikat.ZIndex = 2
TitleMalaikat.Parent = TitleContainer

local TitleSuffix = Instance.new("TextLabel")
TitleSuffix.Size = UDim2.new(0, 0, 1, 0)
TitleSuffix.AutomaticSize = Enum.AutomaticSize.X
TitleSuffix.BackgroundTransparency = 1
TitleSuffix.Text = "UI"
TitleSuffix.TextColor3 = Color3.fromRGB(0, 122, 255)
TitleSuffix.TextSize = 14
TitleSuffix.Font = Enum.Font.GothamMedium
TitleSuffix.LayoutOrder = 2
TitleSuffix.ZIndex = 2
TitleSuffix.Parent = TitleContainer

local WindowControls = Instance.new("Frame")
WindowControls.Name = "WindowControls"
WindowControls.Size = UDim2.new(0, 68, 0, 26)
WindowControls.Position = UDim2.new(1, -80, 0, 10)
WindowControls.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
WindowControls.BackgroundTransparency = 0.4
WindowControls.ZIndex = 2
WindowControls.Parent = MainFrame

local ControlCorner = Instance.new("UICorner")
ControlCorner.CornerRadius = UDim.new(1, 0)
ControlCorner.Parent = WindowControls

local ControlStroke = Instance.new("UIStroke")
ControlStroke.Color = Color3.fromRGB(255, 255, 255)
ControlStroke.Transparency = 0.85
ControlStroke.Thickness = 1
ControlStroke.Parent = WindowControls

local ControlLayout = Instance.new("UIListLayout")
ControlLayout.FillDirection = Enum.FillDirection.Horizontal
ControlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ControlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
ControlLayout.Padding = UDim.new(0, 8)
ControlLayout.Parent = WindowControls

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 14, 0, 14)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 179, 0)
MinimizeBtn.Text = ""
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.ZIndex = 3
MinimizeBtn.Parent = WindowControls

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1, 0)
MinCorner.Parent = MinimizeBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 14, 0, 14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 69, 58)
CloseBtn.Text = ""
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 3
CloseBtn.Parent = WindowControls

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
	SpringTween(CloseBtn, {Size = UDim2.new(0, 17, 0, 17), BackgroundColor3 = Color3.fromRGB(255, 90, 80)})
end)
CloseBtn.MouseLeave:Connect(function()
	FastTween(CloseBtn, {Size = UDim2.new(0, 14, 0, 14), BackgroundColor3 = Color3.fromRGB(255, 69, 58)})
end)

MinimizeBtn.MouseEnter:Connect(function()
	SpringTween(MinimizeBtn, {Size = UDim2.new(0, 17, 0, 17), BackgroundColor3 = Color3.fromRGB(255, 205, 60)})
end)
MinimizeBtn.MouseLeave:Connect(function()
	FastTween(MinimizeBtn, {Size = UDim2.new(0, 14, 0, 14), BackgroundColor3 = Color3.fromRGB(255, 179, 0)})
end)

local Sidebar = Instance.new("Frame")
local ContentArea = Instance.new("Frame")

MinimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	local targetHeight = isMinimized and 46 or 410

	if isMinimized then
		Sidebar.Visible = false
		ContentArea.Visible = false
	end

	local tween = SmoothTween(MainFrame, {Size = UDim2.new(0, 600, 0, targetHeight)})
	if not isMinimized then
		tween.Completed:Connect(function()
			if not isMinimized then
				Sidebar.Visible = true
				ContentArea.Visible = true
			end
		end)
	end
end)

--==============================================================================
-- FLOATING MOBILE BUTTON & PHYSICS DRAG ENGINE
--==============================================================================

local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Name = "FloatingMobileBtn"
FloatingBtn.Size = UDim2.new(0, 52, 0, 52)
FloatingBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
FloatingBtn.BackgroundColor3 = currentTheme.SideBg
FloatingBtn.Text = "iOS"
FloatingBtn.TextColor3 = currentTheme.TextPrimary
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.TextSize = 13
FloatingBtn.Visible = UserInputService.TouchEnabled
FloatingBtn.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(0, 18)
FloatCorner.Parent = FloatingBtn

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = currentTheme.Stroke
FloatStroke.Thickness = 1.2
FloatStroke.Transparency = 0.5
FloatStroke.Parent = FloatingBtn

table.insert(ThemeElements.Strokes, FloatStroke)
table.insert(ThemeElements.TextPrimary, FloatingBtn)

local function makeDraggable(frame)
	local dragging = false
	local dragInput, dragStart, startPos

	frame.InputBegan:Connect(function(input)
		if isSliderDragging then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging and not isSliderDragging then
			local delta = input.Position - dragStart
			local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			SmoothTween(frame, {Position = targetPos})
		end
	end)
end

makeDraggable(MainFrame)
makeDraggable(FloatingBtn)

--==============================================================================
-- SIDEBAR & NAVIGATION STRUCTURE
--==============================================================================

Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 140, 1, -58)
Sidebar.Position = UDim2.new(0, 12, 0, 44)
Sidebar.BackgroundColor3 = currentTheme.SideBg
Sidebar.BackgroundTransparency = 0.4
Sidebar.BorderSizePixel = 0
Sidebar.ClipsDescendants = true
Sidebar.ZIndex = 2
Sidebar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 16)
SideCorner.Parent = Sidebar

local SideStroke = Instance.new("UIStroke")
SideStroke.Color = currentTheme.Stroke
SideStroke.Thickness = 1
SideStroke.Transparency = currentTheme.StrokeTransparency
SideStroke.Parent = Sidebar

local TabSelector = Instance.new("Frame")
TabSelector.Name = "TabSelector"
TabSelector.Size = UDim2.new(1, -12, 0, 34)
TabSelector.Position = UDim2.new(0, 6, 0, 6)
TabSelector.BackgroundColor3 = currentTheme.SelectorBg
TabSelector.ZIndex = 1
TabSelector.Parent = Sidebar

local SelectorCorner = Instance.new("UICorner")
SelectorCorner.CornerRadius = UDim.new(0, 10)
SelectorCorner.Parent = TabSelector

local ButtonsContainer = Instance.new("Frame")
ButtonsContainer.Name = "ButtonsContainer"
ButtonsContainer.Size = UDim2.new(1, 0, 1, 0)
ButtonsContainer.BackgroundTransparency = 1
ButtonsContainer.ZIndex = 2
ButtonsContainer.Parent = Sidebar

local SideList = Instance.new("UIListLayout")
SideList.Padding = UDim.new(0, 4)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideList.SortOrder = Enum.SortOrder.LayoutOrder
SideList.Parent = ButtonsContainer

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0, 6)
SidePadding.Parent = ButtonsContainer

ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -172, 1, -58)
ContentArea.Position = UDim2.new(0, 160, 0, 44)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 2
ContentArea.Parent = MainFrame

--==============================================================================
-- TAB CONTROLLER & TRANSITION ENGINE
--==============================================================================

local Tabs = {}
local TabButtons = {}
local tabList = {"Preview", "Settings"}
local currentTab = "Preview"
local isTransitioning = false

local function updateTabSelector(tabName, immediate)
	local btn = TabButtons[tabName]
	if not btn then return end

	task.spawn(function()
		task.wait()
		local targetY = btn.AbsolutePosition.Y - Sidebar.AbsolutePosition.Y
		local targetSize = btn.AbsoluteSize.Y

		if immediate then
			TabSelector.Position = UDim2.new(0, 6, 0, targetY)
			TabSelector.Size = UDim2.new(1, -12, 0, targetSize)
		else
			SpringTween(TabSelector, {
				Position = UDim2.new(0, 6, 0, targetY),
				Size = UDim2.new(1, -12, 0, targetSize)
			})
		end
	end)
end

for idx, tabName in ipairs(tabList) do
	local TabBtn = Instance.new("TextButton")
	TabBtn.Name = tabName .. "Btn"
	TabBtn.Size = UDim2.new(1, -12, 0, 34)
	TabBtn.BackgroundTransparency = 1
	TabBtn.Text = tabName
	TabBtn.TextColor3 = (idx == 1) and Color3.fromRGB(255, 255, 255) or currentTheme.TextSecondary
	TabBtn.Font = Enum.Font.GothamMedium
	TabBtn.TextSize = 13
	TabBtn.LayoutOrder = idx
	TabBtn.ZIndex = 3
	TabBtn.Parent = ButtonsContainer

	local TabGroup = Instance.new("CanvasGroup")
	TabGroup.Name = tabName .. "Group"
	TabGroup.Size = UDim2.new(1, 0, 1, 0)
	TabGroup.Position = UDim2.new(0, 0, 0, 0)
	TabGroup.BackgroundTransparency = 1
	TabGroup.GroupTransparency = (idx == 1) and 0 or 1
	TabGroup.Visible = (idx == 1)
	TabGroup.Parent = ContentArea

	local Scroll = Instance.new("ScrollingFrame")
	Scroll.Size = UDim2.new(1, 0, 1, 0)
	Scroll.BackgroundTransparency = 1
	Scroll.ScrollBarThickness = 3
	Scroll.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 170)
	Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	Scroll.Parent = TabGroup

	local ScrollLayout = Instance.new("UIListLayout")
	ScrollLayout.Padding = UDim.new(0, 8)
	ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ScrollLayout.Parent = Scroll

	ScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Scroll.CanvasSize = UDim2.new(0, 0, 0, ScrollLayout.AbsoluteContentSize.Y + 15)
	end)

	Tabs[tabName] = {Group = TabGroup, Scroll = Scroll, Index = idx}
	TabButtons[tabName] = TabBtn

	TabBtn.MouseButton1Click:Connect(function()
		if currentTab == tabName or isTransitioning then return end
		isTransitioning = true

		local oldIdx = Tabs[currentTab].Index
		local newIdx = idx
		local isGoingNext = newIdx > oldIdx

		updateTabSelector(tabName, false)

		for name, btn in pairs(TabButtons) do
			FastTween(btn, {TextColor3 = currentTheme.TextSecondary})
		end
		FastTween(TabBtn, {TextColor3 = Color3.fromRGB(255, 255, 255)})

		local oldGroup = Tabs[currentTab].Group
		local slideOutPos = isGoingNext and UDim2.new(-0.8, 0, 0, 0) or UDim2.new(0.8, 0, 0, 0)

		local fadeOut = FastTween(oldGroup, {GroupTransparency = 1, Position = slideOutPos})
		fadeOut.Completed:Wait()
		oldGroup.Visible = false

		currentTab = tabName

		local newGroup = Tabs[tabName].Group
		local slideInStartPos = isGoingNext and UDim2.new(0.8, 0, 0, 0) or UDim2.new(-0.8, 0, 0, 0)
		newGroup.Position = slideInStartPos
		newGroup.GroupTransparency = 1
		newGroup.Visible = true

		local fadeIn = SmoothTween(newGroup, {GroupTransparency = 0, Position = UDim2.new(0, 0, 0, 0)})
		fadeIn.Completed:Wait()

		isTransitioning = false
	end)
end

task.delay(0.1, function()
	updateTabSelector("Preview", true)
end)

--==============================================================================
-- FULL API INTERACTIVE COMPONENTS ENGINE
--==============================================================================

local function addSectionHeader(parent, text)
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -5, 0, 20)
	Label.BackgroundTransparency = 1
	Label.Text = string.upper(text)
	Label.TextColor3 = currentTheme.TextSecondary
	Label.TextSize = 11
	Label.Font = Enum.Font.GothamBold
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = parent
	table.insert(ThemeElements.TextSecondary, Label)
end

local function addButton(parent, text, rightLabelText, callback)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -8, 0, 42)
	Frame.BackgroundColor3 = currentTheme.CardBg
	Frame.BackgroundTransparency = 0.45
	Frame.ClipsDescendants = true
	Frame.Parent = parent

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 12)
	Corner.Parent = Frame

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = currentTheme.Stroke
	Stroke.Thickness = 1
	Stroke.Transparency = currentTheme.StrokeTransparency
	Stroke.Parent = Frame

	AttachCardInteractivity(Frame, Stroke)

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(0.5, -10, 1, 0)
	Title.Position = UDim2.new(0, 12, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = text
	Title.TextColor3 = currentTheme.TextPrimary
	Title.Font = Enum.Font.GothamMedium
	Title.TextSize = 13
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Frame

	local RightLbl = Instance.new("TextLabel")
	RightLbl.Size = UDim2.new(0, 80, 1, 0)
	RightLbl.Position = UDim2.new(1, -92, 0, 0)
	RightLbl.BackgroundTransparency = 1
	RightLbl.Text = rightLabelText or "button"
	RightLbl.TextColor3 = Color3.fromRGB(0, 122, 255)
	RightLbl.Font = Enum.Font.GothamMedium
	RightLbl.TextSize = 11
	RightLbl.TextXAlignment = Enum.TextXAlignment.Right
	RightLbl.Parent = Frame

	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, 0, 1, 0)
	Btn.BackgroundTransparency = 1
	Btn.Text = ""
	Btn.Parent = Frame

	table.insert(ThemeElements.Cards, Frame)
	table.insert(ThemeElements.Strokes, Stroke)
	table.insert(ThemeElements.TextPrimary, Title)

	Btn.MouseButton1Click:Connect(function()
		CreateRipple(Frame, Mouse.X, Mouse.Y)
		SpringTween(Frame, {Size = UDim2.new(1, -14, 0, 39)})
		task.delay(0.1, function()
			SpringTween(Frame, {Size = UDim2.new(1, -8, 0, 42)})
		end)
		callback()
	end)
end

local ActiveStates = {}
local function addToggle(parent, id, text, defaultState, callback)
	ActiveStates[id] = defaultState
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -8, 0, 42)
	Frame.BackgroundColor3 = currentTheme.CardBg
	Frame.BackgroundTransparency = 0.45
	Frame.ClipsDescendants = true
	Frame.Parent = parent

	local FrameCorner = Instance.new("UICorner")
	FrameCorner.CornerRadius = UDim.new(0, 12)
	FrameCorner.Parent = Frame

	local FrameStroke = Instance.new("UIStroke")
	FrameStroke.Color = currentTheme.Stroke
	FrameStroke.Thickness = 1
	FrameStroke.Transparency = currentTheme.StrokeTransparency
	FrameStroke.Parent = Frame

	AttachCardInteractivity(Frame, FrameStroke)

	table.insert(ThemeElements.Cards, Frame)
	table.insert(ThemeElements.Strokes, FrameStroke)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -60, 1, 0)
	Label.Position = UDim2.new(0, 12, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = currentTheme.TextPrimary
	Label.Font = Enum.Font.GothamMedium
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Frame

	table.insert(ThemeElements.TextPrimary, Label)

	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Size = UDim2.new(0, 44, 0, 24)
	ToggleBtn.Position = UDim2.new(1, -54, 0.5, -12)
	ToggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(52, 199, 89) or Color3.fromRGB(120, 120, 128)
	ToggleBtn.Text = ""
	ToggleBtn.AutoButtonColor = false
	ToggleBtn.Parent = Frame

	local ToggleCorner = Instance.new("UICorner")
	ToggleCorner.CornerRadius = UDim.new(1, 0)
	ToggleCorner.Parent = ToggleBtn

	local Circle = Instance.new("Frame")
	Circle.Size = UDim2.new(0, 20, 0, 20)
	Circle.Position = defaultState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
	Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Circle.Parent = ToggleBtn

	local CircleCorner = Instance.new("UICorner")
	CircleCorner.CornerRadius = UDim.new(1, 0)
	CircleCorner.Parent = Circle

	local function setToggle(state)
		ActiveStates[id] = state
		if state then
			SmoothTween(ToggleBtn, {BackgroundColor3 = Color3.fromRGB(52, 199, 89)})
			SpringTween(Circle, {Position = UDim2.new(1, -22, 0.5, -10), Size = UDim2.new(0, 22, 0, 20)})
			task.delay(0.1, function()
				SpringTween(Circle, {Size = UDim2.new(0, 20, 0, 20)})
			end)
		else
			SmoothTween(ToggleBtn, {BackgroundColor3 = Color3.fromRGB(120, 120, 128)})
			SpringTween(Circle, {Position = UDim2.new(0, 2, 0.5, -10), Size = UDim2.new(0, 22, 0, 20)})
			task.delay(0.1, function()
				SpringTween(Circle, {Size = UDim2.new(0, 20, 0, 20)})
			end)
		end
		callback(state)
	end

	ToggleBtn.MouseButton1Click:Connect(function()
		CreateRipple(Frame, Mouse.X, Mouse.Y)
		setToggle(not ActiveStates[id])
	end)
end

local function addSlider(parent, text, min, max, defaultVal, callback)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -8, 0, 44)
	Frame.BackgroundColor3 = currentTheme.CardBg
	Frame.BackgroundTransparency = 0.45
	Frame.Parent = parent

	local FrameCorner = Instance.new("UICorner")
	FrameCorner.CornerRadius = UDim.new(0, 12)
	FrameCorner.Parent = Frame

	local FrameStroke = Instance.new("UIStroke")
	FrameStroke.Color = currentTheme.Stroke
	FrameStroke.Thickness = 1
	FrameStroke.Transparency = currentTheme.StrokeTransparency
	FrameStroke.Parent = Frame

	AttachCardInteractivity(Frame, FrameStroke)

	table.insert(ThemeElements.Cards, Frame)
	table.insert(ThemeElements.Strokes, FrameStroke)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.4, 0, 1, 0)
	Label.Position = UDim2.new(0, 12, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = currentTheme.TextPrimary
	Label.Font = Enum.Font.GothamMedium
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Frame

	table.insert(ThemeElements.TextPrimary, Label)

	local SliderBack = Instance.new("Frame")
	SliderBack.Size = UDim2.new(0, 180, 0, 22)
	SliderBack.Position = UDim2.new(1, -192, 0.5, -11)
	SliderBack.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
	SliderBack.Parent = Frame

	local BackCorner = Instance.new("UICorner")
	BackCorner.CornerRadius = UDim.new(1, 0)
	BackCorner.Parent = SliderBack

	local SliderFill = Instance.new("Frame")
	local percent = math.clamp((defaultVal - min) / (max - min), 0, 1)
	SliderFill.Size = UDim2.new(percent, 0, 1, 0)
	SliderFill.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
	SliderFill.Parent = SliderBack

	local FillCorner = Instance.new("UICorner")
	FillCorner.CornerRadius = UDim.new(1, 0)
	FillCorner.Parent = SliderFill

	local ValueLbl = Instance.new("TextLabel")
	ValueLbl.Size = UDim2.new(1, 0, 1, 0)
	ValueLbl.BackgroundTransparency = 1
	ValueLbl.Text = tostring(defaultVal)
	ValueLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	ValueLbl.Font = Enum.Font.GothamBold
	ValueLbl.TextSize = 11
	ValueLbl.Parent = SliderBack

	local isLocalDragging = false

	local function updateSlider(input)
		local barWidth = SliderBack.AbsoluteSize.X
		if barWidth == 0 then return end
		local posX = input.Position.X - SliderBack.AbsolutePosition.X
		local clampedPerc = math.clamp(posX / barWidth, 0, 1)
		local val = math.floor(min + (max - min) * clampedPerc)

		FastTween(SliderFill, {Size = UDim2.new(clampedPerc, 0, 1, 0)})
		ValueLbl.Text = tostring(val)
		callback(val)
	end

	SliderBack.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isLocalDragging = true
			isSliderDragging = true
			SpringTween(SliderBack, {Size = UDim2.new(0, 180, 0, 26), Position = UDim2.new(1, -192, 0.5, -13)})
			updateSlider(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if isLocalDragging then
				isLocalDragging = false
				isSliderDragging = false
				SpringTween(SliderBack, {Size = UDim2.new(0, 180, 0, 22), Position = UDim2.new(1, -192, 0.5, -11)})
			end
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if isLocalDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider(input)
		end
	end)
end

local function addDropdown(parent, text, options, defaultOpt, callback)
	local isOpen = false
	local currentSelected = defaultOpt or options[1]

	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -8, 0, 42)
	Frame.BackgroundColor3 = currentTheme.CardBg
	Frame.BackgroundTransparency = 0.45
	Frame.ClipsDescendants = true
	Frame.Parent = parent

	local FrameCorner = Instance.new("UICorner")
	FrameCorner.CornerRadius = UDim.new(0, 12)
	FrameCorner.Parent = Frame

	local FrameStroke = Instance.new("UIStroke")
	FrameStroke.Color = currentTheme.Stroke
	FrameStroke.Thickness = 1
	FrameStroke.Transparency = currentTheme.StrokeTransparency
	FrameStroke.Parent = Frame

	AttachCardInteractivity(Frame, FrameStroke)

	table.insert(ThemeElements.Cards, Frame)
	table.insert(ThemeElements.Strokes, FrameStroke)

	local HeaderBtn = Instance.new("TextButton")
	HeaderBtn.Size = UDim2.new(1, 0, 0, 42)
	HeaderBtn.BackgroundTransparency = 1
	HeaderBtn.Text = ""
	HeaderBtn.Parent = Frame

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.5, 0, 1, 0)
	Label.Position = UDim2.new(0, 12, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = currentTheme.TextPrimary
	Label.Font = Enum.Font.GothamMedium
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = HeaderBtn

	table.insert(ThemeElements.TextPrimary, Label)

	local ArrowIcon = Instance.new("ImageLabel")
	ArrowIcon.Size = UDim2.new(0, 16, 0, 16)
	ArrowIcon.Position = UDim2.new(1, -26, 0.5, -8)
	ArrowIcon.BackgroundTransparency = 1
	ArrowIcon.Image = "rbxassetid://6031091004"
	ArrowIcon.ImageColor3 = currentTheme.TextSecondary
	ArrowIcon.Parent = HeaderBtn

	local SelectedLbl = Instance.new("TextLabel")
	SelectedLbl.Size = UDim2.new(0, 100, 1, 0)
	SelectedLbl.Position = UDim2.new(1, -135, 0, 0)
	SelectedLbl.BackgroundTransparency = 1
	SelectedLbl.Text = currentSelected
	SelectedLbl.TextColor3 = Color3.fromRGB(0, 122, 255)
	SelectedLbl.Font = Enum.Font.GothamMedium
	SelectedLbl.TextSize = 11
	SelectedLbl.TextXAlignment = Enum.TextXAlignment.Right
	SelectedLbl.Parent = HeaderBtn

	table.insert(ThemeElements.TextSecondary, ArrowIcon)

	local OptionHolder = Instance.new("Frame")
	OptionHolder.Size = UDim2.new(1, -24, 0, 0)
	OptionHolder.Position = UDim2.new(0, 12, 0, 42)
	OptionHolder.BackgroundTransparency = 1
	OptionHolder.ClipsDescendants = true
	OptionHolder.Parent = Frame

	local OptionList = Instance.new("UIListLayout")
	OptionList.Padding = UDim.new(0, 4)
	OptionList.SortOrder = Enum.SortOrder.LayoutOrder
	OptionList.Parent = OptionHolder

	local function toggleDropdown()
		isOpen = not isOpen
		local totalHeight = isOpen and (42 + (#options * 30) + 8) or 42

		SpringTween(ArrowIcon, {Rotation = isOpen and 180 or 0})
		SmoothTween(OptionHolder, {Size = UDim2.new(1, -24, 0, isOpen and (#options * 30 + 4) or 0)})
		SmoothTween(Frame, {Size = UDim2.new(1, -8, 0, totalHeight)})
	end

	HeaderBtn.MouseButton1Click:Connect(toggleDropdown)

	for idx, opt in ipairs(options) do
		local OptBtn = Instance.new("TextButton")
		OptBtn.Size = UDim2.new(1, 0, 0, 26)
		OptBtn.BackgroundColor3 = currentTheme.InputBg
		OptBtn.Text = "  " .. opt
		OptBtn.TextColor3 = (opt == currentSelected) and Color3.fromRGB(0, 122, 255) or currentTheme.TextSecondary
		OptBtn.Font = Enum.Font.Gotham
		OptBtn.TextSize = 11
		OptBtn.TextXAlignment = Enum.TextXAlignment.Left
		OptBtn.LayoutOrder = idx
		OptBtn.Parent = OptionHolder

		local OptCorner = Instance.new("UICorner")
		OptCorner.CornerRadius = UDim.new(0, 8)
		OptCorner.Parent = OptBtn

		table.insert(ThemeElements.InputBoxes, OptBtn)

		OptBtn.MouseEnter:Connect(function()
			FastTween(OptBtn, {BackgroundColor3 = Color3.fromRGB(0, 122, 255)})
		end)
		OptBtn.MouseLeave:Connect(function()
			FastTween(OptBtn, {BackgroundColor3 = currentTheme.InputBg})
		end)

		OptBtn.MouseButton1Click:Connect(function()
			currentSelected = opt
			SelectedLbl.Text = opt
			callback(opt)
			toggleDropdown()
		end)
	end
end

local function addInput(parent, text, placeholderText, callback)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -8, 0, 42)
	Frame.BackgroundColor3 = currentTheme.CardBg
	Frame.BackgroundTransparency = 0.45
	Frame.Parent = parent

	local FrameCorner = Instance.new("UICorner")
	FrameCorner.CornerRadius = UDim.new(0, 12)
	FrameCorner.Parent = Frame

	local FrameStroke = Instance.new("UIStroke")
	FrameStroke.Color = currentTheme.Stroke
	FrameStroke.Thickness = 1
	FrameStroke.Transparency = currentTheme.StrokeTransparency
	FrameStroke.Parent = Frame

	AttachCardInteractivity(Frame, FrameStroke)

	table.insert(ThemeElements.Cards, Frame)
	table.insert(ThemeElements.Strokes, FrameStroke)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.5, 0, 1, 0)
	Label.Position = UDim2.new(0, 12, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = currentTheme.TextPrimary
	Label.Font = Enum.Font.GothamMedium
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Frame

	table.insert(ThemeElements.TextPrimary, Label)

	local InputBox = Instance.new("TextBox")
	InputBox.Size = UDim2.new(0, 140, 0, 28)
	InputBox.Position = UDim2.new(1, -152, 0.5, -14)
	InputBox.BackgroundColor3 = currentTheme.InputBg
	InputBox.PlaceholderText = placeholderText
	InputBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 150)
	InputBox.Text = ""
	InputBox.TextColor3 = currentTheme.TextPrimary
	InputBox.Font = Enum.Font.Gotham
	InputBox.TextSize = 11
	InputBox.Parent = Frame

	local InputCorner = Instance.new("UICorner")
	InputCorner.CornerRadius = UDim.new(0, 8)
	InputCorner.Parent = InputBox

	local InputStroke = Instance.new("UIStroke")
	InputStroke.Color = currentTheme.Stroke
	InputStroke.Thickness = 1
	InputStroke.Transparency = currentTheme.StrokeTransparency
	InputStroke.Parent = InputBox

	table.insert(ThemeElements.InputBoxes, InputBox)
	table.insert(ThemeElements.Strokes, InputStroke)

	InputBox.Focused:Connect(function()
		SpringTween(InputBox, {Size = UDim2.new(0, 150, 0, 28), Position = UDim2.new(1, -162, 0.5, -14)})
		FastTween(InputStroke, {Color = Color3.fromRGB(0, 122, 255), Transparency = 0.1})
	end)

	InputBox.FocusLost:Connect(function(enterPressed)
		SpringTween(InputBox, {Size = UDim2.new(0, 140, 0, 28), Position = UDim2.new(1, -152, 0.5, -14)})
		FastTween(InputStroke, {Color = currentTheme.Stroke, Transparency = currentTheme.StrokeTransparency})
		callback(InputBox.Text)
	end)
end

local function addColorPicker(parent, text, defaultColor, callback)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -8, 0, 42)
	Frame.BackgroundColor3 = currentTheme.CardBg
	Frame.BackgroundTransparency = 0.45
	Frame.Parent = parent

	local FrameCorner = Instance.new("UICorner")
	FrameCorner.CornerRadius = UDim.new(0, 12)
	FrameCorner.Parent = Frame

	local FrameStroke = Instance.new("UIStroke")
	FrameStroke.Color = currentTheme.Stroke
	FrameStroke.Thickness = 1
	FrameStroke.Transparency = currentTheme.StrokeTransparency
	FrameStroke.Parent = Frame

	AttachCardInteractivity(Frame, FrameStroke)

	table.insert(ThemeElements.Cards, Frame)
	table.insert(ThemeElements.Strokes, FrameStroke)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.5, 0, 1, 0)
	Label.Position = UDim2.new(0, 12, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = currentTheme.TextPrimary
	Label.Font = Enum.Font.GothamMedium
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Frame

	table.insert(ThemeElements.TextPrimary, Label)

	local ColorBox = Instance.new("TextButton")
	ColorBox.Size = UDim2.new(0, 38, 0, 22)
	ColorBox.Position = UDim2.new(1, -50, 0.5, -11)
	ColorBox.BackgroundColor3 = defaultColor or Color3.fromRGB(52, 199, 89)
	ColorBox.Text = ""
	ColorBox.Parent = Frame

	local ColorCorner = Instance.new("UICorner")
	ColorCorner.CornerRadius = UDim.new(0, 8)
	ColorCorner.Parent = ColorBox

	local colors = {
		Color3.fromRGB(52, 199, 89),
		Color3.fromRGB(0, 122, 255),
		Color3.fromRGB(255, 59, 48),
		Color3.fromRGB(255, 149, 0),
		Color3.fromRGB(175, 82, 222)
	}
	local colorIdx = 1

	ColorBox.MouseButton1Click:Connect(function()
		colorIdx = (colorIdx % #colors) + 1
		local newCol = colors[colorIdx]
		SpringTween(ColorBox, {BackgroundColor3 = newCol, Size = UDim2.new(0, 44, 0, 24)})
		task.delay(0.1, function()
			SpringTween(ColorBox, {Size = UDim2.new(0, 38, 0, 22)})
		end)
		callback(newCol)
	end)
end

local function addKeybind(parent, text, defaultKey, callback)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -8, 0, 42)
	Frame.BackgroundColor3 = currentTheme.CardBg
	Frame.BackgroundTransparency = 0.45
	Frame.Parent = parent

	local FrameCorner = Instance.new("UICorner")
	FrameCorner.CornerRadius = UDim.new(0, 12)
	FrameCorner.Parent = Frame

	local FrameStroke = Instance.new("UIStroke")
	FrameStroke.Color = currentTheme.Stroke
	FrameStroke.Thickness = 1
	FrameStroke.Transparency = currentTheme.StrokeTransparency
	FrameStroke.Parent = Frame

	AttachCardInteractivity(Frame, FrameStroke)

	table.insert(ThemeElements.Cards, Frame)
	table.insert(ThemeElements.Strokes, FrameStroke)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.5, 0, 1, 0)
	Label.Position = UDim2.new(0, 12, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = currentTheme.TextPrimary
	Label.Font = Enum.Font.GothamMedium
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Frame

	table.insert(ThemeElements.TextPrimary, Label)

	local KeyBtn = Instance.new("TextButton")
	KeyBtn.Size = UDim2.new(0, 36, 0, 24)
	KeyBtn.Position = UDim2.new(1, -48, 0.5, -12)
	KeyBtn.BackgroundColor3 = currentTheme.InputBg
	KeyBtn.Text = defaultKey or "T"
	KeyBtn.TextColor3 = Color3.fromRGB(0, 122, 255)
	KeyBtn.Font = Enum.Font.GothamBold
	KeyBtn.TextSize = 11
	KeyBtn.Parent = Frame

	local KeyCorner = Instance.new("UICorner")
	KeyCorner.CornerRadius = UDim.new(0, 8)
	KeyCorner.Parent = KeyBtn

	local KeyStroke = Instance.new("UIStroke")
	KeyStroke.Color = currentTheme.Stroke
	KeyStroke.Thickness = 1
	KeyStroke.Transparency = currentTheme.StrokeTransparency
	KeyStroke.Parent = KeyBtn

	table.insert(ThemeElements.InputBoxes, KeyBtn)
	table.insert(ThemeElements.Strokes, KeyStroke)

	local listening = false
	KeyBtn.MouseButton1Click:Connect(function()
		if listening then return end
		listening = true
		KeyBtn.Text = "..."
		SpringTween(KeyBtn, {Size = UDim2.new(0, 46, 0, 26)})
		local conn
		conn = UserInputService.InputBegan:Connect(function(input, gpe)
			if input.UserInputType == Enum.UserInputType.Keyboard then
				local keyStr = input.KeyCode.Name
				KeyBtn.Text = keyStr
				listening = false
				SpringTween(KeyBtn, {Size = UDim2.new(0, 36, 0, 24)})
				conn:Disconnect()
				callback(input.KeyCode)
			end
		end)
	end)
end

local Connections = {}

--==============================================================================
-- TAB 1: PREVIEW SYSTEM ELEMENTS
--==============================================================================

local previewScroll = Tabs["Preview"].Scroll

addSectionHeader(previewScroll, "Tab Elements")

addButton(previewScroll, "Button", "button", function()
	Notify("Button", "Pressed Button!", 2)
end)

addToggle(previewScroll, "preview_toggle", "Toggle", false, function(state)
	Notify("Toggle", "State: " .. tostring(state), 2)
end)

addSlider(previewScroll, "Slider", 0, 100, 50, function(val)
	-- Slider Ultra Smooth Callback
end)

addDropdown(previewScroll, "Dropdown", {"V1", "V2", "V3"}, "V1", function(selected)
	Notify("Dropdown", "Selected: " .. selected, 2)
end)

addInput(previewScroll, "Input", "placeholder", function(text)
	Notify("Input", "Submitted: " .. text, 2)
end)

addColorPicker(previewScroll, "Color Picker", Color3.fromRGB(52, 199, 89), function(col)
	Notify("Color Picker", "Color changed!", 2)
end)

addKeybind(previewScroll, "Keybind", "T", function(keyCode)
	Notify("Keybind", "Bound to " .. keyCode.Name, 2)
end)

--==============================================================================
-- TAB 2: SYSTEM INFORMATION & SETTINGS
--==============================================================================

local settingsScroll = Tabs["Settings"].Scroll

local function getDeviceName()
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		return "Mobile / Tablet"
	elseif UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled then
		return "Console"
	else
		return "PC / Laptop"
	end
end

local function getExecutorName()
	if identifyexecutor then
		local name, ver = identifyexecutor()
		return name .. (ver and (" " .. ver) or "")
	elseif getexecutorname then
		return getexecutorname()
	end
	return "Unknown Executor"
end

addSectionHeader(settingsScroll, "INFO")

local InfoCard = Instance.new("Frame")
InfoCard.Name = "PlayerInfoCard"
InfoCard.Size = UDim2.new(1, -8, 0, 95)
InfoCard.BackgroundColor3 = currentTheme.CardBg
InfoCard.BackgroundTransparency = 0.45
InfoCard.Parent = settingsScroll

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 14)
InfoCorner.Parent = InfoCard

local InfoStroke = Instance.new("UIStroke")
InfoStroke.Color = currentTheme.Stroke
InfoStroke.Thickness = 1
InfoStroke.Transparency = currentTheme.StrokeTransparency
InfoStroke.Parent = InfoCard

AttachCardInteractivity(InfoCard, InfoStroke)

table.insert(ThemeElements.Cards, InfoCard)
table.insert(ThemeElements.Strokes, InfoStroke)

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "AvatarImage"
AvatarImage.Size = UDim2.new(0, 75, 0, 75)
AvatarImage.Position = UDim2.new(0, 10, 0.5, -37)
AvatarImage.BackgroundTransparency = 1
AvatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
AvatarImage.Parent = InfoCard

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(0, 12)
AvatarCorner.Parent = AvatarImage

local AvatarStroke = Instance.new("UIStroke")
AvatarStroke.Color = currentTheme.Stroke
AvatarStroke.Thickness = 1
AvatarStroke.Transparency = currentTheme.StrokeTransparency
AvatarStroke.Parent = AvatarImage

table.insert(ThemeElements.Strokes, AvatarStroke)

local DetailsContainer = Instance.new("Frame")
DetailsContainer.Size = UDim2.new(1, -105, 1, -12)
DetailsContainer.Position = UDim2.new(0, 95, 0, 6)
DetailsContainer.BackgroundTransparency = 1
DetailsContainer.Parent = InfoCard

local DetailsList = Instance.new("UIListLayout")
DetailsList.Padding = UDim.new(0, 3)
DetailsList.SortOrder = Enum.SortOrder.LayoutOrder
DetailsList.Parent = DetailsContainer

local NameLabel = Instance.new("TextLabel")
NameLabel.Size = UDim2.new(1, 0, 0, 18)
NameLabel.BackgroundTransparency = 1
NameLabel.Text = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")"
NameLabel.TextColor3 = currentTheme.TextPrimary
NameLabel.Font = Enum.Font.GothamBold
NameLabel.TextSize = 13
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.LayoutOrder = 1
NameLabel.Parent = DetailsContainer

table.insert(ThemeElements.TextPrimary, NameLabel)

local DeviceLabel = Instance.new("TextLabel")
DeviceLabel.Size = UDim2.new(1, 0, 0, 16)
DeviceLabel.BackgroundTransparency = 1
DeviceLabel.Text = "Device: " .. getDeviceName()
DeviceLabel.TextColor3 = currentTheme.TextSecondary
DeviceLabel.Font = Enum.Font.Gotham
DeviceLabel.TextSize = 11
DeviceLabel.TextXAlignment = Enum.TextXAlignment.Left
DeviceLabel.LayoutOrder = 2
DeviceLabel.Parent = DetailsContainer

table.insert(ThemeElements.TextSecondary, DeviceLabel)

local RobloxVerLabel = Instance.new("TextLabel")
RobloxVerLabel.Size = UDim2.new(1, 0, 0, 16)
RobloxVerLabel.BackgroundTransparency = 1
RobloxVerLabel.Text = "Roblox: v" .. version()
RobloxVerLabel.TextColor3 = currentTheme.TextSecondary
RobloxVerLabel.Font = Enum.Font.Gotham
RobloxVerLabel.TextSize = 11
RobloxVerLabel.TextXAlignment = Enum.TextXAlignment.Left
RobloxVerLabel.LayoutOrder = 3
RobloxVerLabel.Parent = DetailsContainer

table.insert(ThemeElements.TextSecondary, RobloxVerLabel)

local ExecLabel = Instance.new("TextLabel")
ExecLabel.Size = UDim2.new(1, 0, 0, 16)
ExecLabel.BackgroundTransparency = 1
ExecLabel.Text = "Executor: " .. getExecutorName()
ExecLabel.TextColor3 = currentTheme.TextSecondary
ExecLabel.Font = Enum.Font.Gotham
ExecLabel.TextSize = 11
ExecLabel.TextXAlignment = Enum.TextXAlignment.Left
ExecLabel.LayoutOrder = 4
ExecLabel.Parent = DetailsContainer

table.insert(ThemeElements.TextSecondary, ExecLabel)

--==============================================================================
-- THEME ENGINE SWITCHER & DYNAMIC UI CONTROLS
--==============================================================================

local function applyTheme(themeName)
	currentThemeName = themeName
	currentTheme = Themes[themeName]

	SmoothTween(MainFrame, {BackgroundColor3 = currentTheme.MainBg, BackgroundTransparency = currentTheme.MainBgTransparency})
	SmoothTween(MainStroke, {Color = currentTheme.Stroke, Transparency = currentTheme.StrokeTransparency})
	SmoothTween(Sidebar, {BackgroundColor3 = currentTheme.SideBg})
	SmoothTween(SideStroke, {Color = currentTheme.Stroke, Transparency = currentTheme.StrokeTransparency})
	SmoothTween(TabSelector, {BackgroundColor3 = currentTheme.SelectorBg})
	SmoothTween(TitleMalaikat, {TextColor3 = currentTheme.TextPrimary})
	SmoothTween(FloatingBtn, {BackgroundColor3 = currentTheme.SideBg})

	for _, card in ipairs(ThemeElements.Cards) do
		SmoothTween(card, {BackgroundColor3 = currentTheme.CardBg, BackgroundTransparency = 0.45})
	end
	for _, stroke in ipairs(ThemeElements.Strokes) do
		SmoothTween(stroke, {Color = currentTheme.Stroke, Transparency = currentTheme.StrokeTransparency})
	end
	for _, text in ipairs(ThemeElements.TextPrimary) do
		if text:IsA("ImageLabel") then
			SmoothTween(text, {ImageColor3 = currentTheme.TextPrimary})
		else
			SmoothTween(text, {TextColor3 = currentTheme.TextPrimary})
		end
	end
	for _, text in ipairs(ThemeElements.TextSecondary) do
		if text:IsA("ImageLabel") then
			SmoothTween(text, {ImageColor3 = currentTheme.TextSecondary})
		else
			SmoothTween(text, {TextColor3 = currentTheme.TextSecondary})
		end
	end
	for _, box in ipairs(ThemeElements.InputBoxes) do
		SmoothTween(box, {BackgroundColor3 = currentTheme.InputBg, TextColor3 = currentTheme.TextPrimary})
	end
	for name, btn in pairs(TabButtons) do
		if name == currentTab then
			SmoothTween(btn, {TextColor3 = Color3.fromRGB(255, 255, 255)})
		else
			SmoothTween(btn, {TextColor3 = currentTheme.TextSecondary})
		end
	end
end

addSectionHeader(settingsScroll, "Theme & Options")

addButton(settingsScroll, "Switch Theme Mode", "Switch", function()
	local newTheme = (currentThemeName == "Dark") and "Light" or "Dark"
	applyTheme(newTheme)
	Notify("Theme Applied", "Switched to " .. newTheme .. " Mode", 2)
end)

addButton(settingsScroll, "Unload MalaikatUI", "Close", function()
	for _, conn in pairs(Connections) do conn:Disconnect() end
	ScreenGui:Destroy()
end)

-- Window Toggle System with Spring Scale
local isOpen = true
local function toggleUI()
	isOpen = not isOpen
	if isOpen then
		isMinimized = false
		Sidebar.Visible = true
		ContentArea.Visible = true
		MainFrame.Visible = true
		MainFrame.Size = UDim2.new(0, 0, 0, 0)
		MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		SpringTween(MainFrame, {
			Size = UDim2.new(0, 600, 0, 410),
			Position = UDim2.new(0.5, -300, 0.5, -205)
		})
		updateTabSelector(currentTab, true)
	else
		local tween = FastTween(MainFrame, {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		})
		tween.Completed:Connect(function()
			if not isOpen then MainFrame.Visible = false end
		end)
	end
end

CloseBtn.MouseButton1Click:Connect(toggleUI)
FloatingBtn.MouseButton1Click:Connect(toggleUI)

table.insert(Connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if UserInputService:GetFocusedTextBox() then return end
	if input.KeyCode == Enum.KeyCode.Slash then
		toggleUI()
	end
end))

-- Dynamic Typewriter Suffix Animation
task.spawn(function()
	local words = {"UI", "HUB", "v2.0"}
	local currentIdx = 1
	while true do
		task.wait(5)
		local targetSuffix = words[currentIdx]
		for i = #TitleSuffix.Text, 1, -1 do
			TitleSuffix.Text = string.sub(TitleSuffix.Text, 1, i - 1) .. "|"
			task.wait(0.04)
		end
		for i = 1, #targetSuffix do
			TitleSuffix.Text = string.sub(TitleSuffix.Text, 1, i) .. "|"
			task.wait(0.07)
		end
		TitleSuffix.Text = targetSuffix
		currentIdx = (currentIdx % #words) + 1
	end
end)

Notify("MalaikatUI", "Loaded! Press '/' to toggle UI", 4)
