local MalaikatLib = {}

function MalaikatLib:CreateWindow(HubTitle, KeySystemEnabled, CorrectKey)
	HubTitle = HubTitle or "MALAIKAT UI"
	KeySystemEnabled = (KeySystemEnabled == nil) and true or KeySystemEnabled
	CorrectKey = CorrectKey or "Malaikat2026"

	-- Services Definition
	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local Mouse = LocalPlayer:GetMouse()

	local isSliderDragging = false
	local isMinimized = false
	local isKeyVerified = not KeySystemEnabled -- Jika KeySystem = false, langsung terverifikasi

	-- Cleanup Instance Lama
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

	-- Theme Definition
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

	-- Animations Helper
	local function FastTween(inst, props)
		local t = TweenService:Create(inst, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
		t:Play()
		return t
	end

	local function SmoothTween(inst, props)
		local t = TweenService:Create(inst, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), props)
		t:Play()
		return t
	end

	local function SpringTween(inst, props)
		local t = TweenService:Create(inst, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out), props)
		t:Play()
		return t
	end

	-- Notifications System
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
	NotifLayout.Parent = NotifHolder

	local function Notify(title, message, duration)
		duration = duration or 3.5
		local Card = Instance.new("Frame")
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

		local TitleLbl = Instance.new("TextLabel")
		TitleLbl.Size = UDim2.new(1, -30, 0, 18)
		TitleLbl.Position = UDim2.new(0, 26, 0, 10)
		TitleLbl.BackgroundTransparency = 1
		TitleLbl.Text = title
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

	-- Key System Interface (Hanya Muncul jika KeySystemEnabled = true)
	local KeyFrame = Instance.new("Frame")
	KeyFrame.Name = "KeySystemFrame"
	KeyFrame.Size = UDim2.new(0, 360, 0, 220)
	KeyFrame.Position = UDim2.new(0.5, -180, 0.5, -110)
	KeyFrame.BackgroundColor3 = currentTheme.MainBg
	KeyFrame.BackgroundTransparency = 0.15
	KeyFrame.Visible = false
	KeyFrame.ZIndex = 400
	KeyFrame.Parent = ScreenGui

	local KeyCorner = Instance.new("UICorner")
	KeyCorner.CornerRadius = UDim.new(0, 22)
	KeyCorner.Parent = KeyFrame

	local KeyStroke = Instance.new("UIStroke")
	KeyStroke.Color = currentTheme.Stroke
	KeyStroke.Thickness = 1.2
	KeyStroke.Transparency = currentTheme.StrokeTransparency
	KeyStroke.Parent = KeyFrame

	local KeyTitle = Instance.new("TextLabel")
	KeyTitle.Size = UDim2.new(1, 0, 0, 24)
	KeyTitle.Position = UDim2.new(0, 0, 0, 20)
	KeyTitle.BackgroundTransparency = 1
	KeyTitle.Text = "KEY SYSTEM VERIFICATION"
	KeyTitle.TextColor3 = currentTheme.TextPrimary
	KeyTitle.TextSize = 15
	KeyTitle.Font = Enum.Font.GothamBold
	KeyTitle.Parent = KeyFrame

	local KeyInputBox = Instance.new("TextBox")
	KeyInputBox.Size = UDim2.new(0, 300, 0, 38)
	KeyInputBox.Position = UDim2.new(0.5, -150, 0, 88)
	KeyInputBox.BackgroundColor3 = currentTheme.InputBg
	KeyInputBox.PlaceholderText = "Enter key here..."
	KeyInputBox.Text = ""
	KeyInputBox.TextColor3 = currentTheme.TextPrimary
	KeyInputBox.Font = Enum.Font.Gotham
	KeyInputBox.TextSize = 12
	KeyInputBox.Parent = KeyFrame

	local SubmitKeyBtn = Instance.new("TextButton")
	SubmitKeyBtn.Size = UDim2.new(0, 140, 0, 36)
	SubmitKeyBtn.Position = UDim2.new(0.5, -70, 0, 142)
	SubmitKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
	SubmitKeyBtn.Text = "Submit Key"
	SubmitKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	SubmitKeyBtn.Font = Enum.Font.GothamBold
	SubmitKeyBtn.TextSize = 12
	SubmitKeyBtn.Parent = KeyFrame

	-- Main Window Setup
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 600, 0, 410)
	MainFrame.Position = UDim2.new(0.5, -300, 0.5, -205)
	MainFrame.BackgroundColor3 = currentTheme.MainBg
	MainFrame.BackgroundTransparency = currentTheme.MainBgTransparency
	MainFrame.Visible = false
	MainFrame.Parent = ScreenGui

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 22)
	MainCorner.Parent = MainFrame

	local MainStroke = Instance.new("UIStroke")
	MainStroke.Color = currentTheme.Stroke
	MainStroke.Thickness = 1.2
	MainStroke.Transparency = currentTheme.StrokeTransparency
	MainStroke.Parent = MainFrame

	-- Header Title
	local TitleMalaikat = Instance.new("TextLabel")
	TitleMalaikat.Size = UDim2.new(0, 200, 0, 30)
	TitleMalaikat.Position = UDim2.new(0, 16, 0, 10)
	TitleMalaikat.BackgroundTransparency = 1
	TitleMalaikat.Text = HubTitle
	TitleMalaikat.TextColor3 = currentTheme.TextPrimary
	TitleMalaikat.TextSize = 16
	TitleMalaikat.Font = Enum.Font.GothamBold
	TitleMalaikat.TextXAlignment = Enum.TextXAlignment.Left
	TitleMalaikat.Parent = MainFrame

	-- Sidebar Navigation
	local Sidebar = Instance.new("Frame")
	Sidebar.Size = UDim2.new(0, 140, 1, -58)
	Sidebar.Position = UDim2.new(0, 12, 0, 44)
	Sidebar.BackgroundColor3 = currentTheme.SideBg
	Sidebar.BackgroundTransparency = 0.4
	Sidebar.Parent = MainFrame

	local SideCorner = Instance.new("UICorner")
	SideCorner.CornerRadius = UDim.new(0, 16)
	SideCorner.Parent = Sidebar

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
	ContentArea.Parent = MainFrame

	local WindowAPI = {}
	local Tabs = {}
	local FirstTab = true

	-- FUNGSI UNTUK MEMBUAT TAB BARU
	function WindowAPI:CreateTab(TabName)
		local TabBtn = Instance.new("TextButton")
		TabBtn.Size = UDim2.new(1, -12, 0, 34)
		TabBtn.BackgroundTransparency = 1
		TabBtn.Text = TabName
		TabBtn.TextColor3 = FirstTab and Color3.fromRGB(255, 255, 255) or currentTheme.TextSecondary
		TabBtn.Font = Enum.Font.GothamMedium
		TabBtn.TextSize = 13
		TabBtn.Parent = ButtonsContainer

		local Scroll = Instance.new("ScrollingFrame")
		Scroll.Size = UDim2.new(1, 0, 1, 0)
		Scroll.BackgroundTransparency = 1
		Scroll.ScrollBarThickness = 3
		Scroll.Visible = FirstTab
		Scroll.Parent = ContentArea

		local ScrollLayout = Instance.new("UIListLayout")
		ScrollLayout.Padding = UDim.new(0, 8)
		ScrollLayout.Parent = Scroll

		ScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Scroll.CanvasSize = UDim2.new(0, 0, 0, ScrollLayout.AbsoluteContentSize.Y + 15)
		end)

		TabBtn.MouseButton1Click:Connect(function()
			for _, t in pairs(Tabs) do
				t.Scroll.Visible = false
				FastTween(t.Btn, {TextColor3 = currentTheme.TextSecondary})
			end
			Scroll.Visible = true
			FastTween(TabBtn, {TextColor3 = Color3.fromRGB(255, 255, 255)})
		end)

		FirstTab = false
		table.insert(Tabs, {Scroll = Scroll, Btn = TabBtn})

		local TabAPI = {}

		-- 1. ADD BUTTON
		function TabAPI:AddButton(text, rightText, callback)
			local Frame = Instance.new("Frame")
			Frame.Size = UDim2.new(1, -8, 0, 42)
			Frame.BackgroundColor3 = currentTheme.CardBg
			Frame.BackgroundTransparency = 0.45
			Frame.Parent = Scroll

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 12)
			Corner.Parent = Frame

			local Title = Instance.new("TextLabel")
			Title.Size = UDim2.new(0.5, 0, 1, 0)
			Title.Position = UDim2.new(0, 12, 0, 0)
			Title.BackgroundTransparency = 1
			Title.Text = text
			Title.TextColor3 = currentTheme.TextPrimary
			Title.Font = Enum.Font.GothamMedium
			Title.TextSize = 13
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.Parent = Frame

			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(1, 0, 1, 0)
			Btn.BackgroundTransparency = 1
			Btn.Text = ""
			Btn.Parent = Frame

			Btn.MouseButton1Click:Connect(function()
				SpringTween(Frame, {Size = UDim2.new(1, -12, 0, 40)})
				task.delay(0.1, function()
					SpringTween(Frame, {Size = UDim2.new(1, -8, 0, 42)})
				end)
				callback()
			end)
		end

		-- 2. ADD TOGGLE
		function TabAPI:AddToggle(text, defaultState, callback)
			local state = defaultState or false
			local Frame = Instance.new("Frame")
			Frame.Size = UDim2.new(1, -8, 0, 42)
			Frame.BackgroundColor3 = currentTheme.CardBg
			Frame.BackgroundTransparency = 0.45
			Frame.Parent = Scroll

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 12)
			Corner.Parent = Frame

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

		-- 3. ADD SLIDER
		function TabAPI:AddSlider(text, min, max, defaultVal, callback)
			local Frame = Instance.new("Frame")
			Frame.Size = UDim2.new(1, -8, 0, 44)
			Frame.BackgroundColor3 = currentTheme.CardBg
			Frame.BackgroundTransparency = 0.45
			Frame.Parent = Scroll

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, 12)
			Corner.Parent = Frame

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
					updateSlider(input)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					isLocalDragging = false
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if isLocalDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					updateSlider(input)
				end
			end)
		end

		return TabAPI
	end

	-- Logic Inisialisasi UI
	local function OpenMainUI()
		MainFrame.Visible = true
		MainFrame.Size = UDim2.new(0, 0, 0, 0)
		MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		SpringTween(MainFrame, {
			Size = UDim2.new(0, 600, 0, 410),
			Position = UDim2.new(0.5, -300, 0.5, -205)
		})
		Notify("MalaikatUI", "UI Loaded Successfully!", 3)
	end

	if KeySystemEnabled then
		KeyFrame.Visible = true
		SubmitKeyBtn.MouseButton1Click:Connect(function()
			if KeyInputBox.Text == CorrectKey then
				isKeyVerified = true
				KeyFrame:Destroy()
				OpenMainUI()
			else
				Notify("Key System", "Wrong Key!", 2)
			end
		end)
	else
		OpenMainUI()
	end

	return WindowAPI
end

return MalaikatLib
