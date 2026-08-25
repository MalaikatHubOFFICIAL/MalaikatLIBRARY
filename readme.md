# 👼 MalaikatUI Library

[ 🇮🇩 Bahasa Indonesia ] | [ 🇬🇧 English ] | [ 🇲🇾 Bahasa Melayu ]

---

## 🇮🇩 BAHASA INDONESIA

Library UI Roblox modern dengan tampilan **Frosted Glass Engine** yang dilengkapi animasi super smooth, physics-engine dragging, key system, dan loading screen.

### 🚀 Cara Menggunakan (Quick Start)

Panggil library ini di script Roblox kamu menggunakan kode berikut:

```lua
-- 1. Import Library
local MalaikatLib = loadstring(game:HttpGet("[https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/library.lua](https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/library.lua)"))()

-- 2. Buat Window Utama
local Window = MalaikatLib:CreateWindow("Malaikat HUB", true, "Malaikat2026")

-- 3. Buat Tab
local MainTab = Window:CreateTab("Main")
local SettingsTab = Window:CreateTab("Settings")

-- 4. Tambahkan Komponen
MainTab:AddButton("Test Button", "Click", function()
    print("Button Clicked!")
end)

MainTab:AddToggle("preview_toggle", "Auto Farm", false, function(Value)
    print("Toggle State:", Value)
end)

MainTab:AddSlider("Walkspeed", 16, 200, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)
