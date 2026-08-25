--==============================================================================
--          MALAIKAT UI - LIBRARY ENGINE (iOS 26 ULTRA GLASS COMPLETE)
--==============================================================================

local MalaikatLib = {}

function MalaikatLib:CreateWindow(Settings)
	Settings = Settings or {}
	local Title = Settings.Title or "MALAIKAT UI"
	local KeySystem = Settings.KeySystem or false
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

	-- Color Palettes Engine
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
			InputBg = Color3.fromRGB(16, 17, 24)
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
			InputBg = Color3.fromRGB(235, 235, 245)
		}
	}

	local currentThemeName = "Dark"
	local currentTheme = Themes.Dark

	local ThemeElements = {
		Cards = {},
		Strokes = {},
		TextPrimary = {},
		TextSecondary = {},
		InputBoxes = {}
	}

	-- Animation Math Helpers
	local FastTweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	local SpringTweenInfo = TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local UltraSmoothTweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

	local function FastTween(inst, props)
		local t = TweenService:Create(inst, FastTweenInfo, props)
		t:Play()
		return t
	end

	local function SmoothTween(inst, props)
		local t = TweenService:Create(inst, UltraSmoothTweenInfo, props)
		t:Play()
		return t
	end

	local function SpringTween(inst, props)
		local t = TweenService:Create(inst, SpringTweenInfo, props)
		t:Play()
		return t
	end

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

	local function Notify(notifTitle, message, duration)
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
		TitleLbl.Text = notifTitle
		TitleLbl.TextColor3 = currentTheme.TextPrimary
		TitleLbl.TextSize = 13
		TitleLbl.Font = Enum.Font.GothamBold
		TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
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
		MsgLbl.Parent = Card

		SpringTween(Card, {Size = UDim2.new(1, 0, 0, 58)})
		task.delay(duration, function()
			local dismiss = SmoothTween(Card, {Size = UDim2.new(0, 0, 0, 58), BackgroundTransparency = 1})
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

	local loadMainUI

	-- Key System Dialog UI
	local KeyFrame = Instance.new("Frame")
	KeyFrame.Name = "KeySystemFrame"
	KeyFrame.Size = UDim2.new(0, 360, 0, 260)
	KeyFrame.Position = UDim2.new(0.5, -180, 0.5, -130)
	KeyFrame.BackgroundColor3 = currentTheme.MainBg
	KeyFrame.BackgroundTransparency = currentTheme.MainBgTransparency
	KeyFrame.Visible = KeySystem
	KeyFrame.ZIndex = 400
	KeyFrame.Parent = ScreenGui

	local KeyCorner = Instance.new("UICorner")
	KeyCorner.CornerRadius = UDim.new(0, 20)
	KeyCorner.Parent = KeyFrame

	local KeyStroke = Instance.new("UIStroke")
	KeyStroke.Color = currentTheme.Stroke
	KeyStroke.Thickness = 1.2
	KeyStroke.Transparency = currentTheme.StrokeTransparency
	KeyStroke.Parent = KeyFrame

	makeDraggable(KeyFrame)

	local KeyTitle = Instance.new("TextLabel")
	KeyTitle.Size = UDim2.new(1, 0, 0, 30)
	KeyTitle.Position = UDim2.new(0, 0, 0, 16)
	KeyTitle.BackgroundTransparency = 1
	KeyTitle.Text = "MALAIKAT UI - KEY SYSTEM"
	KeyTitle.TextColor3 = currentTheme.TextPrimary
	KeyTitle.TextSize = 16
	KeyTitle.Font = Enum.Font.GothamBold
	KeyTitle.Parent = KeyFrame

	local KeyTitleSub = Instance.new("TextLabel")
	KeyTitleSub.Size = UDim2.new(1, -30, 0, 18)
	KeyTitleSub.Position = UDim2.new(0, 15, 0, 46)
	KeyTitleSub.BackgroundTransparency = 1
	KeyTitleSub.Text = "MalaikatLIBRARY"
	KeyTitleSub.TextColor3 = Color3.fromRGB(130, 135, 150)
	KeyTitleSub.TextSize = 11
	KeyTitleSub.Font = Enum.Font.GothamMedium
	KeyTitleSub.Parent = KeyFrame

	local KeyInputBox = Instance.new("TextBox")
	KeyInputBox.Size = UDim2.new(1, -40, 0, 42)
	KeyInputBox.Position = UDim2.new(0, 20, 0, 80)
	KeyInputBox.BackgroundColor3 = currentTheme.InputBg
	KeyInputBox.PlaceholderText = "Masukkan Key..."
	KeyInputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
	KeyInputBox.Text = ""
	KeyInputBox.TextColor3 = currentTheme.TextPrimary
	KeyInputBox.Font = Enum.Font.Gotham
	KeyInputBox.TextSize = 13
	KeyInputBox.Parent = KeyFrame

	local KeyInputCorner = Instance.new("UICorner")
	KeyInputCorner.CornerRadius = UDim.new(0, 12)
	KeyInputCorner.Parent = KeyInputBox

	local SubmitKeyBtn = Instance.new("TextButton")
	SubmitKeyBtn.Size = UDim2.new(0.44, 0, 0, 40)
	SubmitKeyBtn.Position = UDim2.new(0, 20, 0, 138)
	SubmitKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
	SubmitKeyBtn.Text = "Submit Key"
	SubmitKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	SubmitKeyBtn.Font = Enum.Font.GothamBold
	SubmitKeyBtn.TextSize = 12
	SubmitKeyBtn.Parent = KeyFrame

	local SubmitCorner = Instance.new("UICorner")
	SubmitCorner.CornerRadius = UDim.new(0, 12)
	SubmitCorner.Parent = SubmitKeyBtn

	local GetKeyBtn = Instance.new("TextButton")
	GetKeyBtn.Size = UDim2.new(0.44, 0, 0, 40)
	GetKeyBtn.Position = UDim2.new(0.56, -20, 0, 138)
	GetKeyBtn.BackgroundColor3 = currentTheme.CardBg
	GetKeyBtn.Text = "Get Link"
	GetKeyBtn.TextColor3 = currentTheme.TextPrimary
	GetKeyBtn.Font = Enum.Font.GothamBold
	GetKeyBtn.TextSize = 12
	GetKeyBtn.Parent = KeyFrame

	local GetCorner = Instance.new("UICorner")
	GetCorner.CornerRadius = UDim.new(0, 12)
	GetCorner.Parent = GetKeyBtn

	local KeyInfoLbl = Instance.new("TextLabel")
	KeyInfoLbl.Size = UDim2.new(1, -40, 0, 30)
	KeyInfoLbl.Position = UDim2.new(0, 20, 0, 195)
	KeyInfoLbl.BackgroundTransparency = 1
	KeyInfoLbl.Text = "PW: " .. CorrectKey .. "\n(Klik 'Get Link' untuk mendapatkan link key)"
	KeyInfoLbl.TextColor3 = Color3.fromRGB(130, 135, 150)
	KeyInfoLbl.TextSize = 10
	KeyInfoLbl.Font = Enum.Font.Gotham
	KeyInfoLbl.Parent = KeyFrame

	-- Main Container Structure Setup inside loadMainUI function
	loadMainUI = function()
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

		local MainCorner = Instance.new("UICorner")
		MainCorner.CornerRadius = UDim.new(0, 22)
		MainCorner.Parent = MainFrame

		local MainStroke = Instance.new("UIStroke")
		MainStroke.Color = currentTheme.Stroke
		MainStroke.Thickness = 1.2
		MainStroke.Transparency = currentTheme.StrokeTransparency
		MainStroke.Parent = MainFrame

		-- Header Control System
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
		TitleMalaikat.Text = Title
		TitleMalaikat.TextColor3 = currentTheme.TextPrimary
		TitleMalaikat.TextSize = 16
		TitleMalaikat.Font = Enum.Font.GothamBold
		TitleMalaikat.LayoutOrder = 1
		TitleMalaikat.ZIndex = 2
		TitleMalaikat.Parent = TitleContainer

		local WindowControls = Instance.new("Frame")
		WindowControls.Size = UDim2.new(0, 68, 0, 26)
		WindowControls.Position = UDim2.new(1, -80, 0, 10)
		WindowControls.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
		WindowControls.BackgroundTransparency = 0.4
		WindowControls.ZIndex = 2
		WindowControls.Parent = MainFrame

		local ControlCorner = Instance.new("UICorner")
		ControlCorner.CornerRadius = UDim.new(1, 0)
		ControlCorner.Parent = WindowControls

		local ControlLayout = Instance.new("UIListLayout")
		ControlLayout.FillDirection = Enum.FillDirection.Horizontal
		ControlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		ControlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		ControlLayout.Padding = UDim.new(0, 8)
		ControlLayout.Parent = WindowControls

		local MinimizeBtn = Instance.new("TextButton")
		MinimizeBtn.Size = UDim2.new(0, 14, 0, 14)
		MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 179, 0)
		MinimizeBtn.Text = ""
		MinimizeBtn.Parent = WindowControls

		local MinCorner = Instance.new("UICorner")
		MinCorner.CornerRadius = UDim.new(1, 0)
		MinCorner.Parent = MinimizeBtn

		local CloseBtn = Instance.new("TextButton")
		CloseBtn.Size = UDim2.new(0, 14, 0, 14)
		CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 69, 58)
		CloseBtn.Text = ""
		CloseBtn.Parent = WindowControls

		local CloseCorner = Instance.new("UICorner")
		CloseCorner.CornerRadius = UDim.new(1, 0)
		CloseCorner.Parent = CloseBtn

		makeDraggable(MainFrame)

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

		makeDraggable(FloatingBtn)

		-- Sidebar & Content Structure
		local Sidebar = Instance.new("Frame")
		Sidebar.Size = UDim2.new(0, 140, 1, -58)
		Sidebar.Position = UDim2.new(0, 12, 0, 44)
		Sidebar.BackgroundColor3 = currentTheme.SideBg
		Sidebar.BackgroundTransparency = 0.4
		Sidebar.ZIndex = 2
		Sidebar.Parent = MainFrame

		local SideCorner = Instance.new("UICorner")
		SideCorner.CornerRadius = UDim.new(0, 16)
		SideCorner.Parent = Sidebar

		local TabSelector = Instance.new("Frame")
		TabSelector.Size = UDim2.new(1, -12, 0, 34)
		TabSelector.Position = UDim2.new(0, 6, 0, 6)
		TabSelector.BackgroundColor3 = currentTheme.SelectorBg
		TabSelector.ZIndex = 1
		TabSelector.Parent = Sidebar

		local SelectorCorner = Instance.new("UICorner")
		SelectorCorner.CornerRadius = UDim.new(0, 10)
		SelectorCorner.Parent = TabSelector

		local ButtonsContainer = Instance.new("Frame")
		ButtonsContainer.Size = UDim2.new(1, 0, 1, 0)
		ButtonsContainer.BackgroundTransparency = 1
		ButtonsContainer.ZIndex = 2
		ButtonsContainer.Parent = Sidebar

		local SideList = Instance.new("UIListLayout")
		SideList.Padding = UDim.new(0, 4)
		SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
		SideList.Parent = ButtonsContainer

		local ContentArea = Instance.new("Frame")
		ContentArea.Size = UDim2.new(1, -172, 1, -58)
		ContentArea.Position = UDim2.new(0, 160, 0, 44)
		ContentArea.BackgroundTransparency = 1
		ContentArea.ClipsDescendants = true
		ContentArea.ZIndex = 2
		ContentArea.Parent = MainFrame

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

		local isOpen = true
		local function toggleUI()
			isOpen = not isOpen
			if isOpen then
				MainFrame.Visible = true
				MainFrame.Size = UDim2.new(0, 0, 0, 0)
				SpringTween(MainFrame, {Size = UDim2.new(0, 600, 0, 410)})
			else
				local t = FastTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)})
				t.Completed:Connect(function()
					if not isOpen then MainFrame.Visible = false end
				end)
			end
		end

		CloseBtn.MouseButton1Click:Connect(toggleUI)
		FloatingBtn.MouseButton1Click:Connect(toggleUI)

		UserInputService.InputBegan:Connect(function(input, gpe)
			if gpe then return end
			if input.KeyCode == Enum.KeyCode.Slash then
				toggleUI()
			end
		end)

		local WindowAPI = {}
		local Tabs = {}
		local TabButtons = {}
		local currentTabName = ""
		local tabIndexCounter = 0

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
					SpringTween(TabSelector, {Position = UDim2.new(0, 6, 0, targetY), Size = UDim2.new(1, -12, 0, targetSize)})
				end
			end)
		end

		function WindowAPI:CreateTab(tabName)
			tabIndexCounter = tabIndexCounter + 1
			local isFirst = (tabIndexCounter == 1)

			local TabBtn = Instance.new("TextButton")
			TabBtn.Size = UDim2.new(1, -12, 0, 34)
			TabBtn.BackgroundTransparency = 1
			TabBtn.Text = tabName
			TabBtn.TextColor3 = isFirst and Color3.fromRGB(255, 255, 255) or currentTheme.TextSecondary
			TabBtn.Font = Enum.Font.GothamMedium
			TabBtn.TextSize = 13
			TabBtn.LayoutOrder = tabIndexCounter
			TabBtn.ZIndex = 3
			TabBtn.Parent = ButtonsContainer

			local TabGroup = Instance.new("CanvasGroup")
			TabGroup.Size = UDim2.new(1, 0, 1, 0)
			TabGroup.BackgroundTransparency = 1
			TabGroup.GroupTransparency = isFirst and 0 or 1
			TabGroup.Visible = isFirst
			TabGroup.Parent = ContentArea

			local Scroll = Instance.new("ScrollingFrame")
			Scroll.Size = UDim2.new(1, 0, 1, 0)
			Scroll.BackgroundTransparency = 1
			Scroll.ScrollBarThickness = 3
			Scroll.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 170)
			Scroll.Parent = TabGroup

			local ScrollLayout = Instance.new("UIListLayout")
			ScrollLayout.Padding = UDim.new(0, 8)
			ScrollLayout.Parent = Scroll

			ScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				Scroll.CanvasSize = UDim2.new(0, 0, 0, ScrollLayout.AbsoluteContentSize.Y + 15)
			end)

			Tabs[tabName] = {Group = TabGroup, Scroll = Scroll, Index = tabIndexCounter}
			TabButtons[tabName] = TabBtn

			if isFirst then
				currentTabName = tabName
				task.delay(0.1, function() updateTabSelector(tabName, true) end)
			end

			TabBtn.MouseButton1Click:Connect(function()
				if currentTabName == tabName then return end
				updateTabSelector(tabName, false)
				for name, btn in pairs(TabButtons) do FastTween(btn, {TextColor3 = currentTheme.TextSecondary}) end
				FastTween(TabBtn, {TextColor3 = Color3.fromRGB(255, 255, 255)})

				Tabs[currentTabName].Group.Visible = false
				Tabs[currentTabName].Group.GroupTransparency = 1
				currentTabName = tabName
				TabGroup.Visible = true
				SmoothTween(TabGroup, {GroupTransparency = 0})
			end)

			local TabAPI = {}

			function TabAPI:AddSectionHeader(text)
				local Label = Instance.new("TextLabel")
				Label.Size = UDim2.new(1, -5, 0, 20)
				Label.BackgroundTransparency = 1
				Label.Text = string.upper(text)
				Label.TextColor3 = currentTheme.TextSecondary
				Label.TextSize = 11
				Label.Font = Enum.Font.GothamBold
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = Scroll
			end

			function TabAPI:AddButton(text, rightLabel, callback)
				local Frame = Instance.new("Frame")
				Frame.Size = UDim2.new(1, -8, 0, 42)
				Frame.BackgroundColor3 = currentTheme.CardBg
				Frame.BackgroundTransparency = 0.45
				Frame.ClipsDescendants = true
				Frame.Parent = Scroll

				local Corner = Instance.new("UICorner")
				Corner.CornerRadius = UDim.new(0, 12)
				Corner.Parent = Frame

				local Stroke = Instance.new("UIStroke")
				Stroke.Color = currentTheme.Stroke
				Stroke.Thickness = 1
				Stroke.Transparency = currentTheme.StrokeTransparency
				Stroke.Parent = Frame

				AttachCardInteractivity(Frame, Stroke)

				local TitleLbl = Instance.new("TextLabel")
				TitleLbl.Size = UDim2.new(0.5, -10, 1, 0)
				TitleLbl.Position = UDim2.new(0, 12, 0, 0)
				TitleLbl.BackgroundTransparency = 1
				TitleLbl.Text = text
				TitleLbl.TextColor3 = currentTheme.TextPrimary
				TitleLbl.Font = Enum.Font.GothamMedium
				TitleLbl.TextSize = 13
				TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
				TitleLbl.Parent = Frame

				local RightLbl = Instance.new("TextLabel")
				RightLbl.Size = UDim2.new(0, 80, 1, 0)
				RightLbl.Position = UDim2.new(1, -92, 0, 0)
				RightLbl.BackgroundTransparency = 1
				RightLbl.Text = rightLabel or "button"
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

				Btn.MouseButton1Click:Connect(function()
					CreateRipple(Frame, Mouse.X, Mouse.Y)
					SpringTween(Frame, {Size = UDim2.new(1, -14, 0, 39)})
					task.delay(0.1, function() SpringTween(Frame, {Size = UDim2.new(1, -8, 0, 42)}) end)
					callback()
				end)
			end

			function TabAPI:AddToggle(text, defaultState, callback)
				local state = defaultState or false
				local Frame = Instance.new("Frame")
				Frame.Size = UDim2.new(1, -8, 0, 42)
				Frame.BackgroundColor3 = currentTheme.CardBg
				Frame.BackgroundTransparency = 0.45
				Frame.Parent = Scroll

				local FrameCorner = Instance.new("UICorner")
				FrameCorner.CornerRadius = UDim.new(0, 12)
				FrameCorner.Parent = Frame

				local FrameStroke = Instance.new("UIStroke")
				FrameStroke.Color = currentTheme.Stroke
				FrameStroke.Thickness = 1
				FrameStroke.Transparency = currentTheme.StrokeTransparency
				FrameStroke.Parent = Frame

				AttachCardInteractivity(Frame, FrameStroke)

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

				local ToggleBtn = Instance.new("TextButton")
				ToggleBtn.Size = UDim2.new(0, 44, 0, 24)
				ToggleBtn.Position = UDim2.new(1, -54, 0.5, -12)
				ToggleBtn.BackgroundColor3 = state and Color3.fromRGB(52, 199, 89) or Color3.fromRGB(120, 120, 128)
				ToggleBtn.Text = ""
				ToggleBtn.Parent = Frame

				local ToggleCorner = Instance.new("UICorner")
				ToggleCorner.CornerRadius = UDim.new(1, 0)
				ToggleCorner.Parent = ToggleBtn

				local Circle = Instance.new("Frame")
				Circle.Size = UDim2.new(0, 20, 0, 20)
				Circle.Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
				Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Circle.Parent = ToggleBtn

				local CircleCorner = Instance.new("UICorner")
				CircleCorner.CornerRadius = UDim.new(1, 0)
				CircleCorner.Parent = Circle

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

			function TabAPI:AddSlider(text, min, max, defaultVal, callback)
				local Frame = Instance.new("Frame")
				Frame.Size = UDim2.new(1, -8, 0, 44)
				Frame.BackgroundColor3 = currentTheme.CardBg
				Frame.BackgroundTransparency = 0.45
				Frame.Parent = Scroll

				local FrameCorner = Instance.new("UICorner")
				FrameCorner.CornerRadius = UDim.new(0, 12)
				FrameCorner.Parent = Frame

				local FrameStroke = Instance.new("UIStroke")
				FrameStroke.Color = currentTheme.Stroke
				FrameStroke.Thickness = 1
				FrameStroke.Transparency = currentTheme.StrokeTransparency
				FrameStroke.Parent = Frame

				AttachCardInteractivity(Frame, FrameStroke)

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
						updateSlider(input)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						isLocalDragging = false
						isSliderDragging = false
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if isLocalDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						updateSlider(input)
					end
				end)
			end

			function TabAPI:AddDropdown(text, options, defaultOpt, callback)
				local isOpen = false
				local currentSelected = defaultOpt or options[1]

				local Frame = Instance.new("Frame")
				Frame.Size = UDim2.new(1, -8, 0, 42)
				Frame.BackgroundColor3 = currentTheme.CardBg
				Frame.BackgroundTransparency = 0.45
				Frame.ClipsDescendants = true
				Frame.Parent = Scroll

				local FrameCorner = Instance.new("UICorner")
				FrameCorner.CornerRadius = UDim.new(0, 12)
				FrameCorner.Parent = Frame

				local FrameStroke = Instance.new("UIStroke")
				FrameStroke.Color = currentTheme.Stroke
				FrameStroke.Thickness = 1
				FrameStroke.Transparency = currentTheme.StrokeTransparency
				FrameStroke.Parent = Frame

				AttachCardInteractivity(Frame, FrameStroke)

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

				local SelectedLbl = Instance.new("TextLabel")
				SelectedLbl.Size = UDim2.new(0, 120, 1, 0)
				SelectedLbl.Position = UDim2.new(1, -132, 0, 0)
				SelectedLbl.BackgroundTransparency = 1
				SelectedLbl.Text = currentSelected
				SelectedLbl.TextColor3 = Color3.fromRGB(0, 122, 255)
				SelectedLbl.Font = Enum.Font.GothamMedium
				SelectedLbl.TextSize = 11
				SelectedLbl.TextXAlignment = Enum.TextXAlignment.Right
				SelectedLbl.Parent = HeaderBtn

				local OptionHolder = Instance.new("Frame")
				OptionHolder.Size = UDim2.new(1, -24, 0, 0)
				OptionHolder.Position = UDim2.new(0, 12, 0, 42)
				OptionHolder.BackgroundTransparency = 1
				OptionHolder.ClipsDescendants = true
				OptionHolder.Parent = Frame

				local OptionList = Instance.new("UIListLayout")
				OptionList.Padding = UDim.new(0, 4)
				OptionList.Parent = OptionHolder

				local function toggleDropdown()
					isOpen = not isOpen
					local totalHeight = isOpen and (42 + (#options * 30) + 8) or 42
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
					OptBtn.Parent = OptionHolder

					local OptCorner = Instance.new("UICorner")
					OptCorner.CornerRadius = UDim.new(0, 8)
					OptCorner.Parent = OptBtn

					OptBtn.MouseButton1Click:Connect(function()
						currentSelected = opt
						SelectedLbl.Text = opt
						callback(opt)
						toggleDropdown()
					end)
				end
			end

			function TabAPI:AddInput(text, placeholderText, callback)
				local Frame = Instance.new("Frame")
				Frame.Size = UDim2.new(1, -8, 0, 42)
				Frame.BackgroundColor3 = currentTheme.CardBg
				Frame.BackgroundTransparency = 0.45
				Frame.Parent = Scroll

				local FrameCorner = Instance.new("UICorner")
				FrameCorner.CornerRadius = UDim.new(0, 12)
				FrameCorner.Parent = Frame

				local FrameStroke = Instance.new("UIStroke")
				FrameStroke.Color = currentTheme.Stroke
				FrameStroke.Thickness = 1
				FrameStroke.Transparency = currentTheme.StrokeTransparency
				FrameStroke.Parent = Frame

				AttachCardInteractivity(Frame, FrameStroke)

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

				local InputBox = Instance.new("TextBox")
				InputBox.Size = UDim2.new(0, 140, 0, 28)
				InputBox.Position = UDim2.new(1, -152, 0.5, -14)
				InputBox.BackgroundColor3 = currentTheme.InputBg
				InputBox.PlaceholderText = placeholderText or "Type here..."
				InputBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 150)
				InputBox.Text = ""
				InputBox.TextColor3 = currentTheme.TextPrimary
				InputBox.Font = Enum.Font.Gotham
				InputBox.TextSize = 11
				InputBox.Parent = Frame

				local InputCorner = Instance.new("UICorner")
				InputCorner.CornerRadius = UDim.new(0, 8)
				InputCorner.Parent = InputBox

				InputBox.FocusLost:Connect(function(enterPressed)
					callback(InputBox.Text)
				end)
			end

			function TabAPI:AddColorPicker(text, defaultColor, callback)
				local Frame = Instance.new("Frame")
				Frame.Size = UDim2.new(1, -8, 0, 42)
				Frame.BackgroundColor3 = currentTheme.CardBg
				Frame.BackgroundTransparency = 0.45
				Frame.Parent = Scroll

				local FrameCorner = Instance.new("UICorner")
				FrameCorner.CornerRadius = UDim.new(0, 12)
				FrameCorner.Parent = Frame

				local FrameStroke = Instance.new("UIStroke")
				FrameStroke.Color = currentTheme.Stroke
				FrameStroke.Thickness = 1
				FrameStroke.Transparency = currentTheme.StrokeTransparency
				FrameStroke.Parent = Frame

				AttachCardInteractivity(Frame, FrameStroke)

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

				local ColorBox = Instance.new("TextButton")
				ColorBox.Size = UDim2.new(0, 38, 0, 22)
				ColorBox.Position = UDim2.new(1, -50, 0.5, -11)
				ColorBox.BackgroundColor3 = defaultColor or Color3.fromRGB(0, 122, 255)
				ColorBox.Text = ""
				ColorBox.Parent = Frame

				local ColorCorner = Instance.new("UICorner")
				ColorCorner.CornerRadius = UDim.new(0, 8)
				ColorCorner.Parent = ColorBox

				local colors = {
					Color3.fromRGB(0, 122, 255),
					Color3.fromRGB(52, 199, 89),
					Color3.fromRGB(255, 59, 48),
					Color3.fromRGB(255, 149, 0),
					Color3.fromRGB(175, 82, 222)
				}
				local colorIdx = 1

				ColorBox.MouseButton1Click:Connect(function()
					colorIdx = (colorIdx % #colors) + 1
					local newCol = colors[colorIdx]
					SpringTween(ColorBox, {BackgroundColor3 = newCol})
					callback(newCol)
				end)
			end

			function TabAPI:AddKeybind(text, defaultKey, callback)
				local Frame = Instance.new("Frame")
				Frame.Size = UDim2.new(1, -8, 0, 42)
				Frame.BackgroundColor3 = currentTheme.CardBg
				Frame.BackgroundTransparency = 0.45
				Frame.Parent = Scroll

				local FrameCorner = Instance.new("UICorner")
				FrameCorner.CornerRadius = UDim.new(0, 12)
				FrameCorner.Parent = Frame

				local FrameStroke = Instance.new("UIStroke")
				FrameStroke.Color = currentTheme.Stroke
				FrameStroke.Thickness = 1
				FrameStroke.Transparency = currentTheme.StrokeTransparency
				FrameStroke.Parent = Frame

				AttachCardInteractivity(Frame, FrameStroke)

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

				local listening = false
				KeyBtn.MouseButton1Click:Connect(function()
					if listening then return end
					listening = true
					KeyBtn.Text = "..."
					local conn
					conn = UserInputService.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.Keyboard then
							KeyBtn.Text = input.KeyCode.Name
							listening = false
							conn:Disconnect()
							callback(input.KeyCode)
						end
					end)
				end)
			end

			return TabAPI
		end

		return WindowAPI
	end

	-- Key System Execution Events
	if KeySystem then
		KeyFrame.Visible = true
		SpringTween(KeyFrame, {Size = UDim2.new(0, 360, 0, 260)})

		SubmitKeyBtn.MouseButton1Click:Connect(function()
			if KeyInputBox.Text == CorrectKey then
				Notify("Security", "Correct Key!", 2)
				local dismiss = SmoothTween(KeyFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
				dismiss.Completed:Connect(function()
					KeyFrame:Destroy()
					loadMainUI()
				end)
			else
				Notify("Security", "Invalid Key!", 2)
			end
		end)

		GetKeyBtn.MouseButton1Click:Connect(function()
			if setclipboard then
				setclipboard(KeyLink)
				Notify("Key System", "Link copied to clipboard!", 2)
			else
				Notify("Key System", "Buka browser: " .. KeyLink, 3)
			end
			if setrbxclipboard then
				setrbxclipboard(KeyLink)
			end
		end)
	else
		KeyFrame:Destroy()
		loadMainUI()
	end

	return WindowAPI
end

return MalaikatLib
