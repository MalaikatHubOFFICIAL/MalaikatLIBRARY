# 👼 MalaikatUI Library

[ 🇮🇩 Bahasa Indonesia ](#-bahasa-indonesia) | [ 🇬🇧 English ](#-english) | [ 🇲🇾 Bahasa Melayu ](#-bahasa-melayu)

---

## 🇮🇩 Bahasa Indonesia

Library UI Roblox modern dengan tampilan **Frosted Glass Engine** yang dilengkapi animasi super smooth, physics-engine dragging, key system, dan loading screen.

### 🚀 Cara Menggunakan (Quick Start)

Panggil library ini di script Roblox kamu menggunakan kode berikut:

```lua
-- 1. Import Library
local MalaikatLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/library.lua"))()

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
```

### 📌 Fitur Utama MalaikatUI
* **Frosted Glass UI:** Tampilan transparan yang elegan, modern, dan bersih.
* **Ultra Smooth Physics:** Pergerakan UI dan elemen menggunakan lerp spring animation.
* **Built-in Key System:** Sistem keamanan verifikasi kunci akses sebelum membuka UI.
* **Loading Screen:** Intro animasi progresif sebelum masuk ke menu utama.
* **Lengkap & Kompatibel:** Mendukung Button, Toggle, Slider, Dropdown, Input Box, Color Picker, dan Keybind.

### 👁️ Preview MalaikatUI
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/PREVIEW.lua"))()
```

---

## 🇬🇧 English

A modern Roblox UI Library powered by a **Frosted Glass Engine**, featuring ultra-smooth animations, physics-based dragging, a built-in key system, and an intro loading screen.

### 🚀 Quick Start Guide

Call this library in your Roblox script using the following code:

```lua
-- 1. Import Library
local MalaikatLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/library.lua"))()

-- 2. Create Main Window
local Window = MalaikatLib:CreateWindow("Malaikat HUB", true, "Malaikat2026")

-- 3. Create Tabs
local MainTab = Window:CreateTab("Main")
local SettingsTab = Window:CreateTab("Settings")

-- 4. Add Components
MainTab:AddButton("Test Button", "Click", function()
    print("Button Clicked!")
end)

MainTab:AddToggle("preview_toggle", "Auto Farm", false, function(Value)
    print("Toggle State:", Value)
end)

MainTab:AddSlider("Walkspeed", 16, 200, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)
```

### 📌 MalaikatUI Key Features
* **Frosted Glass UI:** An elegant, clean, and modern transparent design.
* **Ultra Smooth Physics:** Elements and UI movement driven by fluid lerp spring physics.
* **Built-in Key System:** Access verification security before entering the main UI.
* **Loading Screen:** Progressive intro animation before launching the interface.
* **Full Component Suite:** Supports Buttons, Toggles, Sliders, Dropdowns, Input Boxes, Color Pickers, and Keybinds.

### 👁️ Preview MalaikatUI
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/PREVIEW.lua"))()
```

---

## 🇲🇾 Bahasa Melayu

Library UI Roblox moden berkuasakan **Frosted Glass Engine** yang dilengkapi dengan animasi super lancar, physics-engine dragging, sistem kunci (key system), dan skrin pemuatan (loading screen).

### 🚀 Cara Penggunaan (Pantas)

Panggil library ini dalam skrip Roblox anda dengan menggunakan kod berikut:

```lua
-- 1. Import Library
local MalaikatLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/library.lua"))()

-- 2. Cipta Window Utama
local Window = MalaikatLib:CreateWindow("Malaikat HUB", true, "Malaikat2026")

-- 3. Cipta Tab
local MainTab = Window:CreateTab("Main")
local SettingsTab = Window:CreateTab("Settings")

-- 4. Tambah Komponen
MainTab:AddButton("Test Button", "Click", function()
    print("Button Clicked!")
end)

MainTab:AddToggle("preview_toggle", "Auto Farm", false, function(Value)
    print("Toggle State:", Value)
end)

MainTab:AddSlider("Walkspeed", 16, 200, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)
```

### 📌 Ciri-Ciri Utama MalaikatUI
* **Frosted Glass UI:** Paparan lut sinar yang elegan, moden, dan kemas.
* **Ultra Smooth Physics:** Pergerakan UI dan elemen menggunakan animasi lerp spring.
* **Built-in Key System:** Sistem keselamatan pengesahan kunci akses sebelum membuka UI.
* **Skrin Pemuatan (Loading Screen):** Intro animasi progresif sebelum masuk ke paparan utama.
* **Lengkap & Kompatibel:** Menyokong Button, Toggle, Slider, Dropdown, Input Box, Color Picker, dan Keybind.

### 👁️ Pratonton (Preview) MalaikatUI
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/PREVIEW.lua"))()
```
