--==============================================================================
--        MALAIKAT UI - iOS 26 ULTRA INTERACTIVE GLASS EDITION (LIBRARY)
--==============================================================================

local MalaikatLib = {}

function MalaikatLib:CreateWindow(Settings)
	Settings = Settings or {}
	local WindowTitle = Settings.Title or "MALAIKAT UI"
	local UseKeySystem = Settings.KeySystem or false
	local CorrectKey = Settings.Key or "malaikatui"
	local KeyLink = Settings.KeyLink or "dsc.gg/mahub"

	-- Services Definition
	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local Mouse = LocalPlayer:GetMouse()

	-- Global State Management
	local isSliderDragging = false
	local isMinimized = false

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
	local ThemeElements = {Cards = {}, Strokes = {}, TextPrimary = {}, TextSecondary = {}, InputBoxes = {}}

	-- Physics & Animation Math Engine
	local FastTweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	local SpringTweenInfo = TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local UltraSmoothTweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

	local function FastTween(inst, props) return TweenService:Create(inst, FastTweenInfo, props):Play() end
	local function SmoothTween(inst, props) return TweenService:Create(inst, UltraSmoothTweenInfo, props):Play() end
	local function SpringTween(inst, props) return TweenService:Create(inst, SpringTweenInfo, props):Play() end

	-- Dynamic Island Notification Queue System
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
		Card.Size = UDim2.new(0, 0, 0, 58)
		Card.BackgroundColor3 = currentTheme.SideBg
		Card.BackgroundTransparency = 0.15
		Card.ClipsDescendants = true
		Card.Parent = NotifHolder

		local CardCorner = Instance.new("UICorner", Card)
		CardCorner.CornerRadius = UDim.new(0, 18)

		local CardStroke = Instance.new("UIStroke", Card)
		CardStroke.Color = currentTheme.Stroke
		CardStroke.Thickness = 1.2
		CardStroke.Transparency = 0.85

		local GlowBar = Instance.new("Frame", Card)
		GlowBar.Size = UDim2.new(0, 4, 0, 26)
		GlowBar.Position = UDim2.new(0, 12, 0.5, -13)
		GlowBar.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
		Instance.new("UICorner", GlowBar).CornerRadius = UDim.new(1, 0)

		local TitleLbl = Instance.new("TextLabel", Card)
		TitleLbl.Size = UDim2.new(1, -30, 0, 18)
		TitleLbl.Position = UDim2.new(0, 26, 0, 10)
		TitleLbl.BackgroundTransparency = 1
		TitleLbl.Text = title
		TitleLbl.TextColor3 = currentTheme.TextPrimary
		TitleLbl.TextSize = 13
		TitleLbl.Font = Enum.Font.GothamBold
		TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

		local MsgLbl = Instance.new("TextLabel", Card)
		MsgLbl.Size = UDim2.new(1, -30, 0, 18)
		MsgLbl.Position = UDim2.new(0, 26, 0, 28)
		MsgLbl.BackgroundTransparency = 1
		MsgLbl.Text = message
		MsgLbl.TextColor3 = currentTheme.TextSecondary
		MsgLbl.TextSize = 11
		MsgLbl.Font = Enum.Font.Gotham
		MsgLbl.TextXAlignment = Enum.TextXAlignment.Left

		TweenService:Create(Card, SpringTweenInfo, {Size = UDim2.new(1, 0, 0, 58)}):Play()

		task.delay(duration, function()
			local dismiss = TweenService:Create(Card, UltraSmoothTweenInfo, {Size = UDim2.new(0, 0, 0, 58), BackgroundTransparency = 1})
			dismiss:Play()
			dismiss.Completed:Connect(function() Card:Destroy() end)
		end)
	end

	-- Drag Helper Function
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
					if input.UserInputState == Enum.UserInputState.End then dragging = false end
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
				SmoothTween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)})
			end
		end)
	end

	local loadMainUI

	-- Key System Implementation
	local KeyFrame = Instance.new("Frame")
	KeyFrame.Size = UDim2.new(0, 360, 0, 260)
	KeyFrame.Position = UDim2.new(0.5, -180, 0.5, -130)
	KeyFrame.BackgroundColor3 = currentTheme.MainBg
	KeyFrame.BackgroundTransparency = currentTheme.MainBgTransparency
	KeyFrame.Visible = UseKeySystem
	KeyFrame.Parent = ScreenGui

	Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 20)
	local KeyStroke = Instance.new("UIStroke", KeyFrame)
	KeyStroke.Color = currentTheme.Stroke
	KeyStroke.Transparency = currentTheme.StrokeTransparency
	makeDraggable(KeyFrame)

	local KeyTitle = Instance.new("TextLabel", KeyFrame)
	KeyTitle.Size = UDim2.new(1, 0, 0, 30)
	KeyTitle.Position = UDim2.new(0, 0, 0, 16)
	KeyTitle.BackgroundTransparency = 1
	KeyTitle.Text = "MALAIKAT UI - KEY SYSTEM"
	KeyTitle.TextColor3 = currentTheme.TextPrimary
	KeyTitle.TextSize = 16
	KeyTitle.Font = Enum.Font.GothamBold

	local KeyInput = Instance.new("TextBox", KeyFrame)
	KeyInput.Size = UDim2.new(1, -40, 0, 42)
	KeyInput.Position = UDim2.new(0, 20, 0, 80)
	KeyInput.BackgroundColor3 = currentTheme.InputBg
	KeyInput.PlaceholderText = "Masukkan Key..."
	KeyInput.Text = ""
	KeyInput.TextColor3 = currentTheme.TextPrimary
	KeyInput.Font = Enum.Font.Gotham
	KeyInput.TextSize = 13
	Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 12)

	local SubmitBtn = Instance.new("TextButton", KeyFrame)
	SubmitBtn.Size = UDim2.new(0.44, 0, 0, 40)
	SubmitBtn.Position = UDim2.new(0, 20, 0, 138)
	SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
	SubmitBtn.Text = "Submit Key"
	SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	SubmitBtn.Font = Enum.Font.GothamBold
	SubmitBtn.TextSize = 12
	Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 12)

	local GetLinkBtn = Instance.new("TextButton", KeyFrame)
	GetLinkBtn.Size = UDim2.new(0.44, 0, 0, 40)
	GetLinkBtn.Position = UDim2.new(0.56, -20, 0, 138)
	GetLinkBtn.BackgroundColor3 = currentTheme.CardBg
	GetLinkBtn.Text = "Get Link"
	GetLinkBtn.TextColor3 = currentTheme.TextPrimary
	GetLinkBtn.Font = Enum.Font.GothamBold
	GetLinkBtn.TextSize = 12
	Instance.new("UICorner", GetLinkBtn).CornerRadius = UDim.new(0, 12)

	-- Window API Wrapper
	local WindowAPI = {}

	loadMainUI = function()
		local MainFrame = Instance.new("Frame", ScreenGui)
		MainFrame.Name = "MainFrame"
		MainFrame.Size = UDim2.new(0, 600, 0, 410)
		MainFrame.Position = UDim2.new(0.5, -300, 0.5, -205)
		MainFrame.BackgroundColor3 = currentTheme.MainBg
		MainFrame.BackgroundTransparency = currentTheme.MainBgTransparency
		MainFrame.ClipsDescendants = false
		Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 22)

		local MainStroke = Instance.new("UIStroke", MainFrame)
		MainStroke.Color = currentTheme.Stroke
		MainStroke.Transparency = currentTheme.StrokeTransparency

		-- Ambient Glass Orbs
		local AmbientContainer = Instance.new("Frame", MainFrame)
		AmbientContainer.Size = UDim2.new(1, 0, 1, 0)
		AmbientContainer.BackgroundTransparency = 1
		AmbientContainer.ClipsDescendants = true
		AmbientContainer.ZIndex = 0

		local Orb1 = Instance.new("ImageLabel", AmbientContainer)
		Orb1.Size = UDim2.new(0, 320, 0, 320)
		Orb1.Position = UDim2.new(-0.2, 0, -0.2, 0)
		Orb1.BackgroundTransparency = 1
		Orb1.Image = "rbxassetid://5810228302"
		Orb1.ImageColor3 = Color3.fromRGB(0, 122, 255)
		Orb1.ImageTransparency = 0.55
		Orb1.ZIndex = 0

		local Orb2 = Instance.new("ImageLabel", AmbientContainer)
		Orb2.Size = UDim2.new(0, 340, 0, 340)
		Orb2.Position = UDim2.new(0.6, 0, 0.5, 0)
		Orb2.BackgroundTransparency = 1
		Orb2.Image = "rbxassetid://5810228302"
		Orb2.ImageColor3 = Color3.fromRGB(160, 0, 255)
		Orb2.ImageTransparency = 0.6
		Orb2.ZIndex = 0

		RunService.RenderStepped:Connect(function()
			local t = tick()
			Orb1.Position = UDim2.new(-0.2 + math.sin(t * 0.7) * 0.06, 0, -0.2 + math.cos(t * 0.5) * 0.06, 0)
			Orb2.Position = UDim2.new(0.6 + math.cos(t * 0.6) * 0.07, 0, 0.5 + math.sin(t * 0.8) * 0.06, 0)
		end)

		-- Header Controls
		local TitleContainer = Instance.new("Frame", MainFrame)
		TitleContainer.Size = UDim2.new(0, 350, 0, 30)
		TitleContainer.Position = UDim2.new(0, 16, 0, 10)
		TitleContainer.BackgroundTransparency = 1
		TitleContainer.ZIndex = 2

		local TitleLayout = Instance.new("UIListLayout", TitleContainer)
		TitleLayout.FillDirection = Enum.FillDirection.Horizontal
		TitleLayout.SortOrder = Enum.SortOrder.LayoutOrder
		TitleLayout.Padding = UDim.new(0, 6)
		TitleLayout.VerticalAlignment = Enum.VerticalAlignment.Center

		local TitleMalaikat = Instance.new("TextLabel", TitleContainer)
		TitleMalaikat.Size = UDim2.new(0, 0, 1, 0)
		TitleMalaikat.AutomaticSize = Enum.AutomaticSize.X
		TitleMalaikat.BackgroundTransparency = 1
		TitleMalaikat.Text = WindowTitle
		TitleMalaikat.TextColor3 = currentTheme.TextPrimary
		TitleMalaikat.TextSize = 16
		TitleMalaikat.Font = Enum.Font.GothamBold

		local WindowControls = Instance.new("Frame", MainFrame)
		WindowControls.Size = UDim2.new(0, 68, 0, 26)
		WindowControls.Position = UDim2.new(1, -80, 0, 10)
		WindowControls.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
		WindowControls.BackgroundTransparency = 0.4
		WindowControls.ZIndex = 2
		Instance.new("UICorner", WindowControls).CornerRadius = UDim.new(1, 0)

		local ControlLayout = Instance.new("UIListLayout", WindowControls)
		ControlLayout.FillDirection = Enum.FillDirection.Horizontal
		ControlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		ControlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		ControlLayout.Padding = UDim.new(0, 8)

		local MinimizeBtn = Instance.new("TextButton", WindowControls)
		MinimizeBtn.Size = UDim2.new(0, 14, 0, 14)
		MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 179, 0)
		MinimizeBtn.Text = ""
		Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(1, 0)

		local CloseBtn = Instance.new("TextButton", WindowControls)
		CloseBtn.Size = UDim2.new(0, 14, 0, 14)
		CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 69, 58)
		CloseBtn.Text = ""
		Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

		local FloatingBtn = Instance.new("TextButton", ScreenGui)
		FloatingBtn.Name = "FloatingMobileBtn"
		FloatingBtn.Size = UDim2.new(0, 52, 0, 52)
		FloatingBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
		FloatingBtn.BackgroundColor3 = currentTheme.SideBg
		FloatingBtn.Text = "iOS"
		FloatingBtn.TextColor3 = currentTheme.TextPrimary
		FloatingBtn.Font = Enum.Font.GothamBold
		FloatingBtn.TextSize = 13
		FloatingBtn.Visible = UserInputService.TouchEnabled
		Instance.new("UICorner", FloatingBtn).CornerRadius = UDim.new(0, 18)

		makeDraggable(MainFrame)
		makeDraggable(FloatingBtn)

		-- Sidebar Navigation System
		local Sidebar = Instance.new("Frame", MainFrame)
		Sidebar.Size = UDim2.new(0, 140, 1, -58)
		Sidebar.Position = UDim2.new(0, 12, 0, 44)
		Sidebar.BackgroundColor3 = currentTheme.SideBg
		Sidebar.BackgroundTransparency = 0.4
		Sidebar.ZIndex = 2
		Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 16)

		local TabSelector = Instance.new("Frame", Sidebar)
		TabSelector.Size = UDim2.new(1, -12, 0, 34)
		TabSelector.Position = UDim2.new(0, 6, 0, 6)
		TabSelector.BackgroundColor3 = currentTheme.SelectorBg
		TabSelector.ZIndex = 1
		Instance.new("UICorner", TabSelector).CornerRadius = UDim.new(0, 10)

		local ButtonsContainer = Instance.new("Frame", Sidebar)
		ButtonsContainer.Size = UDim2.new(1, 0, 1, 0)
		ButtonsContainer.BackgroundTransparency = 1
		ButtonsContainer.ZIndex = 2

		local SideList = Instance.new("UIListLayout", ButtonsContainer)
		SideList.Padding = UDim.new(0, 4)
		SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
		SideList.SortOrder = Enum.SortOrder.LayoutOrder

		local ContentArea = Instance.new("Frame", MainFrame)
		ContentArea.Size = UDim2.new(1, -172, 1, -58)
		ContentArea.Position = UDim2.new(0, 160, 0, 44)
		ContentArea.BackgroundTransparency = 1
		ContentArea.ClipsDescendants = true
		ContentArea.ZIndex = 2

		local Tabs = {}
		local TabButtons = {}
		local currentTabName = ""
		local tabIndexCounter = 0

		local function updateTabSelector(tabName)
			local btn = TabButtons[tabName]
			if not btn then return end
			task.spawn(function()
				task.wait()
				local targetY = btn.AbsolutePosition.Y - Sidebar.AbsolutePosition.Y
				SpringTween(TabSelector, {Position = UDim2.new(0, 6, 0, targetY), Size = UDim2.new(1, -12, 0, btn.AbsoluteSize.Y)})
			end)
		end

		function WindowAPI:CreateTab(tabName)
			tabIndexCounter = tabIndexCounter + 1
			local isFirst = (tabIndexCounter == 1)

			local TabBtn = Instance.new("TextButton", ButtonsContainer)
			TabBtn.Size = UDim2.new(1, -12, 0, 34)
			TabBtn.BackgroundTransparency = 1
			TabBtn.Text = tabName
			TabBtn.TextColor3 = isFirst and Color3.fromRGB(255, 255, 255) or currentTheme.TextSecondary
			TabBtn.Font = Enum.Font.GothamMedium
			TabBtn.TextSize = 13
			TabBtn.LayoutOrder = tabIndexCounter
			TabBtn.ZIndex = 3

			local TabGroup = Instance.new("CanvasGroup", ContentArea)
			TabGroup.Size = UDim2.new(1, 0, 1, 0)
			TabGroup.BackgroundTransparency = 1
			TabGroup.GroupTransparency = isFirst and 0 or 1
			TabGroup.Visible = isFirst

			local Scroll = Instance.new("ScrollingFrame", TabGroup)
			Scroll.Size = UDim2.new(1, 0, 1, 0)
			Scroll.BackgroundTransparency = 1
			Scroll.ScrollBarThickness = 3
			Scroll.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 170)

			local ScrollLayout = Instance.new("UIListLayout", Scroll)
			ScrollLayout.Padding = UDim.new(0, 8)
			ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder

			ScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				Scroll.CanvasSize = UDim2.new(0, 0, 0, ScrollLayout.AbsoluteContentSize.Y + 15)
			end)

			Tabs[tabName] = {Group = TabGroup, Index = tabIndexCounter}
			TabButtons[tabName] = TabBtn

			if isFirst then
				currentTabName = tabName
				task.delay(0.1, function() updateTabSelector(tabName) end)
			end

			TabBtn.MouseButton1Click:Connect(function()
				if currentTabName == tabName then return end
				updateTabSelector(tabName)

				for name, btn in pairs(TabButtons) do
					FastTween(btn, {TextColor3 = currentTheme.TextSecondary})
				end
				FastTween(TabBtn, {TextColor3 = Color3.fromRGB(255, 255, 255)})

				local oldGroup = Tabs[currentTabName].Group
				FastTween(oldGroup, {GroupTransparency = 1})
				oldGroup.Visible = false

				currentTabName = tabName
				TabGroup.GroupTransparency = 1
				TabGroup.Visible = true
				SmoothTween(TabGroup, {GroupTransparency = 0})
			end)

			local TabAPI = {}

			function TabAPI:AddSectionHeader(text)
				local Label = Instance.new("TextLabel", Scroll)
				Label.Size = UDim2.new(1, -5, 0, 20)
				Label.BackgroundTransparency = 1
				Label.Text = string.upper(text)
				Label.TextColor3 = currentTheme.TextSecondary
				Label.TextSize = 11
				Label.Font = Enum.Font.GothamBold
				Label.TextXAlignment = Enum.TextXAlignment.Left
			end

			function TabAPI:AddButton(text, rightLabel, callback)
				local Frame = Instance.new("Frame", Scroll)
				Frame.Size = UDim2.new(1, -8, 0, 42)
				Frame.BackgroundColor3 = currentTheme.CardBg
				Frame.BackgroundTransparency = 0.45
				Frame.ClipsDescendants = true
				Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

				local Stroke = Instance.new("UIStroke", Frame)
				Stroke.Color = currentTheme.Stroke
				Stroke.Transparency = currentTheme.StrokeTransparency

				local Title = Instance.new("TextLabel", Frame)
				Title.Size = UDim2.new(0.5, -10, 1, 0)
				Title.Position = UDim2.new(0, 12, 0, 0)
				Title.BackgroundTransparency = 1
				Title.Text = text
				Title.TextColor3 = currentTheme.TextPrimary
				Title.Font = Enum.Font.GothamMedium
				Title.TextSize = 13
				Title.TextXAlignment = Enum.TextXAlignment.Left

				local RightLbl = Instance.new("TextLabel", Frame)
				RightLbl.Size = UDim2.new(0, 80, 1, 0)
				RightLbl.Position = UDim2.new(1, -92, 0, 0)
				RightLbl.BackgroundTransparency = 1
				RightLbl.Text = rightLabel or "button"
				RightLbl.TextColor3 = Color3.fromRGB(0, 122, 255)
				RightLbl.Font = Enum.Font.GothamMedium
				RightLbl.TextSize = 11
				RightLbl.TextXAlignment = Enum.TextXAlignment.Right

				local Btn = Instance.new("TextButton", Frame)
				Btn.Size = UDim2.new(1, 0, 1, 0)
				Btn.BackgroundTransparency = 1
				Btn.Text = ""

				Btn.MouseButton1Click:Connect(function()
					callback()
				end)
			end

			function TabAPI:AddToggle(text, defaultState, callback)
				local state = defaultState or false
				local Frame = Instance.new("Frame", Scroll)
				Frame.Size = UDim2.new(1, -8, 0, 42)
				Frame.BackgroundColor3 = currentTheme.CardBg
				Frame.BackgroundTransparency = 0.45
				Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

				local Stroke = Instance.new("UIStroke", Frame)
				Stroke.Color = currentTheme.Stroke
				Stroke.Transparency = currentTheme.StrokeTransparency

				local Label = Instance.new("TextLabel", Frame)
				Label.Size = UDim2.new(1, -60, 1, 0)
				Label.Position = UDim2.new(0, 12, 0, 0)
				Label.BackgroundTransparency = 1
				Label.Text = text
				Label.TextColor3 = currentTheme.TextPrimary
				Label.Font = Enum.Font.GothamMedium
				Label.TextSize = 13
				Label.TextXAlignment = Enum.TextXAlignment.Left

				local ToggleBtn = Instance.new("TextButton", Frame)
				ToggleBtn.Size = UDim2.new(0, 44, 0, 24)
				ToggleBtn.Position = UDim2.new(1, -54, 0.5, -12)
				ToggleBtn.BackgroundColor3 = state and Color3.fromRGB(52, 199, 89) or Color3.fromRGB(120, 120, 128)
				ToggleBtn.Text = ""
				Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

				local Circle = Instance.new("Frame", ToggleBtn)
				Circle.Size = UDim2.new(0, 20, 0, 20)
				Circle.Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
				Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

				ToggleBtn.MouseButton1Click:Connect(function()
					state = not state
					if state then
						SmoothTween(ToggleBtn, {BackgroundColor3 = Color3.fromRGB(52, 199, 89)})
						SpringTween(Circle, {Position = UDim2.new(1, -22, 0.5, -10)})
					else
						SmoothTween(ToggleBtn, {BackgroundColor3 = Color3.fromRGB(120, 120, 128)})
						SpringTween(Circle, {Position = UDim2.new(0, 2, 0.5, -10)})
					end
					callback(state)
				end)
			end

			return TabAPI
		end

		-- Window Minimizing / Closing Engine
		MinimizeBtn.MouseButton1Click:Connect(function()
			isMinimized = not isMinimized
			local targetHeight = isMinimized and 46 or 410
			Sidebar.Visible = not isMinimized
			ContentArea.Visible = not isMinimized
			SmoothTween(MainFrame, {Size = UDim2.new(0, 600, 0, targetHeight)})
		end)

		local isOpen = true
		local function toggleUI()
			isOpen = not isOpen
			MainFrame.Visible = isOpen
		end

		CloseBtn.MouseButton1Click:Connect(toggleUI)
		FloatingBtn.MouseButton1Click:Connect(toggleUI)
	end

	-- Run Key System Check
	if UseKeySystem then
		SubmitBtn.MouseButton1Click:Connect(function()
			if KeyInput.Text == CorrectKey then
				Notify("Success", "Key Benar!", 2)
				KeyFrame:Destroy()
				loadMainUI()
			else
				Notify("Error", "Key Salah!", 2)
			end
		end)
		GetLinkBtn.MouseButton1Click:Connect(function()
			if setclipboard then setclipboard(KeyLink) end
			Notify("Get Link", "Link disalin ke clipboard!", 3)
		end)
	else
		KeyFrame:Destroy()
		loadMainUI()
	end

	return WindowAPI
end

return MalaikatLib
