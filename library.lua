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
		}
	}

	local currentTheme = Themes.Dark

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

	-- Main Window API Handler
	local WindowAPI = {}

	loadMainUI = function()
		local MainFrame = Instance.new("Frame")
		MainFrame.Name = "MainFrame"
		MainFrame.Size = UDim2.new(0, 600, 0, 410)
		MainFrame.Position = UDim2.new(0.5, -300, 0.5, -205)
		MainFrame.BackgroundColor3 = currentTheme.MainBg
		MainFrame.BackgroundTransparency = currentTheme.MainBgTransparency
		MainFrame.BorderSizePixel = 0
		MainFrame.Parent = ScreenGui

		local MainCorner = Instance.new("UICorner")
		MainCorner.CornerRadius = UDim.new(0, 22)
		MainCorner.Parent = MainFrame

		local MainStroke = Instance.new("UIStroke")
		MainStroke.Color = currentTheme.Stroke
		MainStroke.Thickness = 1.2
		MainStroke.Transparency = currentTheme.StrokeTransparency
		MainStroke.Parent = MainFrame

		makeDraggable(MainFrame)

		-- Header Controls
		local TitleLbl = Instance.new("TextLabel")
		TitleLbl.Size = UDim2.new(0, 350, 0, 30)
		TitleLbl.Position = UDim2.new(0, 16, 0, 10)
		TitleLbl.BackgroundTransparency = 1
		TitleLbl.Text = Title
		TitleLbl.TextColor3 = currentTheme.TextPrimary
		TitleLbl.TextSize = 16
		TitleLbl.Font = Enum.Font.GothamBold
		TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
		TitleLbl.Parent = MainFrame

		local CloseBtn = Instance.new("TextButton")
		CloseBtn.Size = UDim2.new(0, 14, 0, 14)
		CloseBtn.Position = UDim2.new(1, -30, 0, 16)
		CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 69, 58)
		CloseBtn.Text = ""
		CloseBtn.Parent = MainFrame

		local CloseCorner = Instance.new("UICorner")
		CloseCorner.CornerRadius = UDim.new(1, 0)
		CloseCorner.Parent = CloseBtn

		local isOpen = true
		CloseBtn.MouseButton1Click:Connect(function()
			isOpen = not isOpen
			MainFrame.Visible = isOpen
		end)

		-- Sidebar & Content Area
		local Sidebar = Instance.new("Frame")
		Sidebar.Size = UDim2.new(0, 140, 1, -58)
		Sidebar.Position = UDim2.new(0, 12, 0, 44)
		Sidebar.BackgroundColor3 = currentTheme.SideBg
		Sidebar.BackgroundTransparency = 0.4
		Sidebar.Parent = MainFrame

		Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 16)

		local ButtonsContainer = Instance.new("Frame")
		ButtonsContainer.Size = UDim2.new(1, 0, 1, 0)
		ButtonsContainer.BackgroundTransparency = 1
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
		ContentArea.Parent = MainFrame

		local Tabs = {}
		local TabButtons = {}
		local currentTabName = ""
		local tabIndexCounter = 0

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
			TabBtn.Parent = ButtonsContainer

			local TabGroup = Instance.new("Frame")
			TabGroup.Size = UDim2.new(1, 0, 1, 0)
			TabGroup.BackgroundTransparency = 1
			TabGroup.Visible = isFirst
			TabGroup.Parent = ContentArea

			local Scroll = Instance.new("ScrollingFrame")
			Scroll.Size = UDim2.new(1, 0, 1, 0)
			Scroll.BackgroundTransparency = 1
			Scroll.ScrollBarThickness = 3
			Scroll.Parent = TabGroup

			local ScrollLayout = Instance.new("UIListLayout")
			ScrollLayout.Padding = UDim.new(0, 8)
			ScrollLayout.Parent = Scroll

			ScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				Scroll.CanvasSize = UDim2.new(0, 0, 0, ScrollLayout.AbsoluteContentSize.Y + 15)
			end)

			Tabs[tabName] = TabGroup
			TabButtons[tabName] = TabBtn

			if isFirst then
				currentTabName = tabName
			end

			TabBtn.MouseButton1Click:Connect(function()
				if currentTabName == tabName then return end
				Tabs[currentTabName].Visible = false
				currentTabName = tabName
				TabGroup.Visible = true
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
				Frame.Parent = Scroll

				Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)
				local Stroke = Instance.new("UIStroke", Frame)
				Stroke.Color = currentTheme.Stroke
				Stroke.Transparency = currentTheme.StrokeTransparency

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

				local Btn = Instance.new("TextButton")
				Btn.Size = UDim2.new(1, 0, 1, 0)
				Btn.BackgroundTransparency = 1
				Btn.Text = ""
				Btn.Parent = Frame

				Btn.MouseButton1Click:Connect(function()
					CreateRipple(Frame, Mouse.X, Mouse.Y)
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

				Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)
				local Stroke = Instance.new("UIStroke", Frame)
				Stroke.Color = currentTheme.Stroke
				Stroke.Transparency = currentTheme.StrokeTransparency

				AttachCardInteractivity(Frame, Stroke)

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

				Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

				local Circle = Instance.new("Frame")
				Circle.Size = UDim2.new(0, 20, 0, 20)
				Circle.Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
				Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Circle.Parent = ToggleBtn

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
	end

	-- Key System Execution
	if KeySystem then
		SubmitKeyBtn.MouseButton1Click:Connect(function()
			if KeyInputBox.Text == CorrectKey then
				KeyFrame:Destroy()
				loadMainUI()
			else
				Notify("Security", "Key Salah!", 2)
			end
		end)

		GetKeyBtn.MouseButton1Click:Connect(function()
			if setclipboard then setclipboard(KeyLink) end
			Notify("Key System", "Link disalin ke clipboard!", 2)
		end)
	else
		KeyFrame:Destroy()
		loadMainUI()
	end

	return WindowAPI
end

return MalaikatLib
