-- LocalScript / Library Module
-- MalaikatHUB Public UI Library Framework

local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local LocalPlayer       = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui         = LocalPlayer:WaitForChild("PlayerGui")

local isMobile = UserInputService.TouchEnabled

local MalaikatHUB = {}
MalaikatHUB.Flags = {}

-- ─── SETTINGS & THEMES ───────────────────────────────────────────────────────
local Themes = {
    ["Cyber Neon"]      = { MainBg = Color3.fromRGB(14, 16, 22), HeaderBg = Color3.fromRGB(22, 26, 36), SidebarBg = Color3.fromRGB(10, 12, 18), CardBg = Color3.fromRGB(22, 26, 36), Accent = Color3.fromRGB(99, 102, 241), AccentGlow = Color3.fromRGB(129, 140, 248), Stroke = Color3.fromRGB(50, 60, 85) },
    ["Midnight Blue"]   = { MainBg = Color3.fromRGB(10, 15, 26), HeaderBg = Color3.fromRGB(16, 24, 40), SidebarBg = Color3.fromRGB(7, 11, 20), CardBg = Color3.fromRGB(16, 24, 40), Accent = Color3.fromRGB(14, 165, 233), AccentGlow = Color3.fromRGB(56, 189, 248), Stroke = Color3.fromRGB(40, 55, 80) },
    ["Emerald Green"]   = { MainBg = Color3.fromRGB(12, 20, 16), HeaderBg = Color3.fromRGB(20, 32, 26), SidebarBg = Color3.fromRGB(8, 15, 12), CardBg = Color3.fromRGB(20, 32, 26), Accent = Color3.fromRGB(16, 185, 129), AccentGlow = Color3.fromRGB(52, 211, 153), Stroke = Color3.fromRGB(40, 75, 55) },
    ["Crimson Red"]     = { MainBg = Color3.fromRGB(20, 12, 15), HeaderBg = Color3.fromRGB(32, 18, 22), SidebarBg = Color3.fromRGB(15, 8, 10), CardBg = Color3.fromRGB(32, 18, 22), Accent = Color3.fromRGB(244, 63, 94), AccentGlow = Color3.fromRGB(251, 113, 133), Stroke = Color3.fromRGB(85, 40, 50) }
}

local CurrentTheme = Themes["Cyber Neon"]
local ThemeListeners = {}

local function RegisterTheme(callback)
    table.insert(ThemeListeners, callback)
    callback(CurrentTheme)
end

function MalaikatHUB:SetTheme(themeName)
    if Themes[themeName] then
        CurrentTheme = Themes[themeName]
        for _, cb in ipairs(ThemeListeners) do cb(CurrentTheme) end
    end
end

-- ─── CREATE WINDOW ───────────────────────────────────────────────────────────
function MalaikatHUB:CreateWindow(WindowTitle)
    WindowTitle = WindowTitle or "MalaikatHUB"

    -- Auto-unload old instance
    if getgenv().MalaikatHUB_Unload then
        getgenv().MalaikatHUB_Unload()
    end

    local CustomUI = Instance.new("ScreenGui")
    CustomUI.Name = "MalaikatHUB_UI"
    CustomUI.ResetOnSpawn = false
    CustomUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    if gethui then CustomUI.Parent = gethui()
    elseif syn and syn.protect_gui then syn.protect_gui(CustomUI) CustomUI.Parent = game:GetService("CoreGui")
    else CustomUI.Parent = game:GetService("CoreGui") or PlayerGui end

    local MainFrame = Instance.new("Frame", CustomUI)
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 580, 0, 390)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -195)
    MainFrame.ClipsDescendants = false
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Thickness = 1.5
    MainStroke.Transparency = 0.3

    local MainScale = Instance.new("UIScale", MainFrame)
    MainScale.Scale = isMobile and 0.80 or 1.00

    RegisterTheme(function(t)
        MainFrame.BackgroundColor3 = t.MainBg
        MainStroke.Color = t.Stroke
    end)

    -- TopBar
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 38)
    RegisterTheme(function(t) TopBar.BackgroundColor3 = t.HeaderBg end)

    local TopBarTitle = Instance.new("TextLabel", TopBar)
    TopBarTitle.Size = UDim2.new(1, -85, 1, 0)
    TopBarTitle.Position = UDim2.new(0, 14, 0, 0)
    TopBarTitle.BackgroundTransparency = 1
    TopBarTitle.Font = Enum.Font.GothamMedium
    TopBarTitle.TextSize = 12
    TopBarTitle.TextColor3 = Color3.fromRGB(240, 245, 255)
    TopBarTitle.TextXAlignment = Enum.TextXAlignment.Left
    TopBarTitle.Text = WindowTitle

    -- Close Button
    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, 22, 0, 22)
    CloseBtn.Position = UDim2.new(1, -30, 0, 8)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(32, 36, 48)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(200, 205, 220)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 11
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

    local IsHidden = false
    CloseBtn.MouseButton1Click:Connect(function()
        IsHidden = not IsHidden
        MainFrame.Visible = not IsHidden
    end)

    -- Floating Button (Mobile)
    local FloatingBtn = Instance.new("TextButton", CustomUI)
    FloatingBtn.Size = UDim2.new(0, 105, 0, 34)
    FloatingBtn.Position = UDim2.new(0, 15, 0.5, -17)
    FloatingBtn.Text = WindowTitle
    FloatingBtn.Font = Enum.Font.GothamMedium
    FloatingBtn.TextSize = 10.5
    FloatingBtn.Visible = isMobile
    Instance.new("UICorner", FloatingBtn).CornerRadius = UDim.new(1, 0)

    RegisterTheme(function(t)
        FloatingBtn.BackgroundColor3 = t.HeaderBg
        FloatingBtn.TextColor3 = t.AccentGlow
    end)

    FloatingBtn.MouseButton1Click:Connect(function()
        IsHidden = not IsHidden
        MainFrame.Visible = not IsHidden
    end)

    -- Sidebar & Content
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 135, 1, -38)
    Sidebar.Position = UDim2.new(0, 0, 0, 38)
    RegisterTheme(function(t) Sidebar.BackgroundColor3 = t.SidebarBg end)

    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.Padding = UDim.new(0, 5)
    local SidebarPadding = Instance.new("UIPadding", Sidebar)
    SidebarPadding.PaddingTop = UDim.new(0, 8)
    SidebarPadding.PaddingLeft = UDim.new(0, 6)
    SidebarPadding.PaddingRight = UDim.new(0, 6)

    local ContentContainer = Instance.new("Frame", MainFrame)
    ContentContainer.Size = UDim2.new(1, -135, 1, -38)
    ContentContainer.Position = UDim2.new(0, 135, 0, 38)
    ContentContainer.BackgroundTransparency = 1

    local WindowObj = {}
    local Groups, TabButtons = {}, {}

    -- ─── TAB CREATION ────────────────────────────────────────────────────────
    function WindowObj:CreateTab(TabName)
        local group = Instance.new("CanvasGroup", ContentContainer)
        group.Size = UDim2.new(1, 0, 1, 0)
        group.BackgroundTransparency = 1
        group.Visible = false

        local page = Instance.new("ScrollingFrame", group)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 4

        local pageLayout = Instance.new("UIListLayout", page)
        pageLayout.Padding = UDim.new(0, 8)
        local pagePadding = Instance.new("UIPadding", page)
        pagePadding.PaddingTop = UDim.new(0, 10)
        pagePadding.PaddingLeft = UDim.new(0, 10)
        pagePadding.PaddingRight = UDim.new(0, 14)

        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
        end)

        local tabBtn = Instance.new("TextButton", Sidebar)
        tabBtn.Size = UDim2.new(1, 0, 0, 30)
        tabBtn.Text = TabName
        tabBtn.Font = Enum.Font.GothamMedium
        tabBtn.TextSize = 10
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 5)

        tabBtn.MouseButton1Click:Connect(function()
            for _, g in pairs(Groups) do g.Visible = false end
            for _, b in pairs(TabButtons) do
                b.BackgroundColor3 = Color3.fromRGB(16, 20, 28)
                b.TextColor3 = Color3.fromRGB(160, 170, 190)
            end
            group.Visible = true
            tabBtn.BackgroundColor3 = CurrentTheme.HeaderBg
            tabBtn.TextColor3 = CurrentTheme.AccentGlow
        end)

        if #Groups == 0 then
            group.Visible = true
            tabBtn.BackgroundColor3 = CurrentTheme.HeaderBg
            tabBtn.TextColor3 = CurrentTheme.AccentGlow
        else
            tabBtn.BackgroundColor3 = Color3.fromRGB(16, 20, 28)
            tabBtn.TextColor3 = Color3.fromRGB(160, 170, 190)
        end

        table.insert(Groups, group)
        table.insert(TabButtons, tabBtn)

        local TabObj = {}

        -- Components API
        function TabObj:CreateButton(Text, Callback)
            local frame = Instance.new("Frame", page)
            frame.Size = UDim2.new(1, 0, 0, 38)
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
            RegisterTheme(function(t) frame.BackgroundColor3 = t.CardBg end)

            local lbl = Instance.new("TextLabel", frame)
            lbl.Size = UDim2.new(0.5, -10, 1, 0)
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextSize = 10
            lbl.TextColor3 = Color3.fromRGB(240, 245, 255)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Text = Text

            local btn = Instance.new("TextButton", frame)
            btn.Size = UDim2.new(0, 85, 0, 24)
            btn.Position = UDim2.new(1, -93, 0.5, -12)
            btn.BackgroundColor3 = Color3.fromRGB(40, 46, 60)
            btn.Text = "Execute"
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 9.5
            btn.TextColor3 = Color3.fromRGB(170, 178, 198)
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

            btn.MouseButton1Click:Connect(function()
                pcall(Callback)
            end)
        end

        function TabObj:CreateToggle(Text, DefaultState, Callback)
            local state = DefaultState or false
            local frame = Instance.new("Frame", page)
            frame.Size = UDim2.new(1, 0, 0, 38)
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
            RegisterTheme(function(t) frame.BackgroundColor3 = t.CardBg end)

            local lbl = Instance.new("TextLabel", frame)
            lbl.Size = UDim2.new(0.6, -10, 1, 0)
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextSize = 10
            lbl.TextColor3 = Color3.fromRGB(240, 245, 255)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Text = Text

            local btn = Instance.new("TextButton", frame)
            btn.Size = UDim2.new(0, 38, 0, 20)
            btn.Position = UDim2.new(1, -46, 0.5, -10)
            btn.Text = ""
            Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

            local dot = Instance.new("Frame", btn)
            dot.Size = UDim2.new(0, 16, 0, 16)
            dot.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

            RegisterTheme(function(t) btn.BackgroundColor3 = state and t.Accent or Color3.fromRGB(45, 50, 66) end)

            btn.MouseButton1Click:Connect(function()
                state = not state
                btn.BackgroundColor3 = state and CurrentTheme.Accent or Color3.fromRGB(45, 50, 66)
                dot.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                pcall(Callback, state)
            end)
        end

        return TabObj
    end

    getgenv().MalaikatHUB_Unload = function()
        if CustomUI then CustomUI:Destroy() end
    end

    return WindowObj
end

return MalaikatHUB
