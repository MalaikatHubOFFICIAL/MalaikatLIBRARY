local MalaikatLib = {}

function MalaikatLib:CreateWindow(HubTitle, KeySystemEnabled, CorrectKey)
	HubTitle = HubTitle or "MALAIKAT UI"
	CorrectKey = CorrectKey or "Malaikat2026"

	-- Services & Logic UI Kamu Dipasang Di Sini
	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer

	-- Cleanup Instance Lama
	if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("MalaikatUIGui") then
		LocalPlayer.PlayerGui.MalaikatUIGui:Destroy()
	end

	-- ScreenGui Base
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "MalaikatUIGui"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

	-- Object Window Yang Akan Dikembalikan
	local WindowAPI = {}

	-- [FUNGSI BIKIN TAB BARU]
	function WindowAPI:CreateTab(TabName)
		local TabAPI = {}
		
		-- Logic membuat Container Tab & ScrollingFrame...
		
		function TabAPI:AddButton(ButtonTitle, Callback)
			-- Logic menambahkan Button dinamis
		end

		function TabAPI:AddToggle(ToggleTitle, DefaultState, Callback)
			-- Logic menambahkan Toggle dinamis
		end

		function TabAPI:AddSlider(SliderTitle, Min, Max, Default, Callback)
			-- Logic menambahkan Slider dinamis
		end

		return TabAPI
	end

	return WindowAPI
end

return MalaikatLib
