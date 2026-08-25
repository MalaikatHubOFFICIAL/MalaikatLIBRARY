# 👼 MalaikatUI Library

[ 🇮🇩 Bahasa Indonesia ](#-bahasa-indonesia) | [ 🇬🇧 English ](#-english) | [ 🇲🇾 Bahasa Melayu ](#-bahasa-melayu)

---

## 🇮🇩 Bahasa Indonesia

**MalaikatUI** adalah library UI Roblox yang dirancang untuk memberikan pengalaman eksekusi skrip terbaik dengan antarmuka bertema *Frosted Glass*. Library ini berfokus pada responsivitas tinggi, kestabilan elemen, dan animasi berbasis *spring physics* yang sangat mulus tanpa membebani performa game.

### 🚀 Panduan Penggunaan Lengkap

```lua
-- Import Library
local MalaikatLib = loadstring(game:HttpGet("[https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/library.lua](https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/library.lua)"))()

-- Buat Window Utama
-- Parameter: (Judul UI, Aktifkan Key System?, Kunci Akses)
local Window = MalaikatLib:CreateWindow("Malaikat HUB", true, "Malaikat2026")

-- Buat Tab Baru
local MainTab = Window:CreateTab("Main Features")
local PlayerTab = Window:CreateTab("Player Stats")

-- 1. Tombol (Button)
MainTab:AddButton("Teleport to Spawn", "Teleport", function()
    print("Teleporting player...")
end)

-- 2. Sakelar (Toggle)
MainTab:AddToggle("Auto Farm Kills", false, function(Value)
    print("Auto Farm status:", Value)
end)

-- 3. Penggeser Angka (Slider)
PlayerTab:AddSlider("WalkSpeed Modifier", 16, 250, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)

-- 4. Menu Pilihan (Dropdown)
MainTab:AddDropdown("Select Weapon", {"Sword", "Bow", "Magic Staff"}, "Sword", function(Selected)
    print("Weapon selected:", Selected)
end)

-- 5. Kotak Teks (Input Box)
MainTab:AddInput("Custom Teleport Player", "Enter username...", function(Text)
    print("Teleport target:", Text)
end)

-- 6. Pemilih Warna (Color Picker)
MainTab:AddColorPicker("ESP Color Overlay", Color3.fromRGB(0, 122, 255), function(Color)
    print("Selected Color:", Color)
end)

-- 7. Pengatur Tombol (Keybind)
MainTab:AddKeybind("Toggle UI Keybind", "T", function(KeyCode)
    print("UI Keybind pressed:", KeyCode.Name)
end)
```

### 💡 Fleksibilitas Key System

Jika kamu **tidak ingin menggunakan Key System**, kamu cukup mengubah argumen kedua menjadi `false`:

```lua
-- Key System dinonaktifkan (Langsung terbuka)
local Window = MalaikatLib:CreateWindow("Malaikat HUB", false)
```

### 📌 Keunggulan Antarmuka
* **Fluid Animation Physics:** Pergerakan UI dan efek tombol menggunakan lerp spring yang halus.
* **Responsive Layout:** Penataan elemen rapi dan otomatis menyesuaikan ukuran konten.
* **Cross-Device Ready:** Nyaman digunakan baik di PC maupun perangkat Mobile.

### 👁️ Preview UI
```lua
loadstring(game:HttpGet("[https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/PREVIEW.lua](https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/PREVIEW.lua)"))()
```

---

## 🇬🇧 English

**MalaikatUI** is a lightweight, modern Roblox UI Library built for developers who demand high performance and clean aesthetics. Powered by a custom frosted glass engine, it delivers responsive controls, smooth spring physics, and zero interface lag.

### 🚀 Complete Integration Guide

```lua
-- Load the Library
local MalaikatLib = loadstring(game:HttpGet("[https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/library.lua](https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/library.lua)"))()

-- Initialize Main Window
-- Syntax: CreateWindow("Title", UseKeySystem, "CorrectKey")
local Window = MalaikatLib:CreateWindow("Malaikat HUB", true, "Malaikat2026")

-- Create Navigation Tabs
local MainTab = Window:CreateTab("Main Features")
local PlayerTab = Window:CreateTab("Player Stats")

-- 1. Action Button
MainTab:AddButton("Teleport to Spawn", "Teleport", function()
    print("Teleporting player...")
end)

-- 2. State Toggle
MainTab:AddToggle("Auto Farm Kills", false, function(Value)
    print("Auto Farm status:", Value)
end)

-- 3. Value Slider
PlayerTab:AddSlider("WalkSpeed Modifier", 16, 250, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)

-- 4. Selection Dropdown
MainTab:AddDropdown("Select Weapon", {"Sword", "Bow", "Magic Staff"}, "Sword", function(Selected)
    print("Weapon selected:", Selected)
end)

-- 5. Text Input Box
MainTab:AddInput("Custom Teleport Player", "Enter username...", function(Text)
    print("Teleport target:", Text)
end)

-- 6. Color Picker
MainTab:AddColorPicker("ESP Color Overlay", Color3.fromRGB(0, 122, 255), function(Color)
    print("Selected Color:", Color)
end)

-- 7. Keybind
MainTab:AddKeybind("Toggle UI Keybind", "T", function(KeyCode)
    print("UI Keybind pressed:", KeyCode.Name)
end)
```

### 💡 Bypassing Key Verification

If your script **does not require key validation**, set the second argument to `false`:

```lua
-- Directly launches the UI window without key prompt
local Window = MalaikatLib:CreateWindow("Malaikat HUB", false)
```

### 📌 Core Features
* **Fluid Animation Physics:** Built using spring lerping algorithms for silky smooth transitions.
* **Clean UI Hierarchy:** Automated content layout ensures immaculate component alignment.
* **Cross-Platform Support:** Fully optimized for mobile execution and desktop controls.

### 👁️ UI Preview Script
```lua
loadstring(game:HttpGet("[https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/PREVIEW.lua](https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/PREVIEW.lua)"))()
```

---

## 🇲🇾 Bahasa Melayu

**MalaikatUI** ialah library UI Roblox moden yang direka khas untuk pembangun skrip yang mengutamakan kelancaran dan reka bentuk elegan. Dijana dengan kesan *Frosted Glass*, antarmuka ini memberikan pergerakan elemen yang ultra-smooth serta ringan tanpa menjejaskan prestasi permainan.

### 🚀 Panduan Penggunaan Lengkap

```lua
-- Muat Turun Library
local MalaikatLib = loadstring(game:HttpGet("[https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/library.lua](https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/library.lua)"))()

-- Cipta Tingkap Utama
-- Format: CreateWindow("Tajuk UI", GunaKeySystem?, "KunciAkses")
local Window = MalaikatLib:CreateWindow("Malaikat HUB", true, "Malaikat2026")

-- Cipta Tab Navigasi
local MainTab = Window:CreateTab("Main Features")
local PlayerTab = Window:CreateTab("Player Stats")

-- 1. Butang (Button)
MainTab:AddButton("Teleport to Spawn", "Teleport", function()
    print("Teleporting player...")
end)

-- 2. Suis (Toggle)
MainTab:AddToggle("Auto Farm Kills", false, function(Value)
    print("Auto Farm status:", Value)
end)

-- 3. Pengelongsor (Slider)
PlayerTab:AddSlider("WalkSpeed Modifier", 16, 250, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)

-- 4. Pilihan Menu (Dropdown)
MainTab:AddDropdown("Select Weapon", {"Sword", "Bow", "Magic Staff"}, "Sword", function(Selected)
    print("Weapon selected:", Selected)
end)

-- 5. Kotak Teks (Input Box)
MainTab:AddInput("Custom Teleport Player", "Enter username...", function(Text)
    print("Teleport target:", Text)
end)

-- 6. Pemilih Warna (Color Picker)
MainTab:AddColorPicker("ESP Color Overlay", Color3.fromRGB(0, 122, 255), function(Color)
    print("Selected Color:", Color)
end)

-- 7. Tetapan Kunci (Keybind)
MainTab:AddKeybind("Toggle UI Keybind", "T", function(KeyCode)
    print("UI Keybind pressed:", KeyCode.Name)
end)
```

### 💡 Matikan Sistem Kunci (Key System)

Sekiranya anda **tidak memerlukan pengesahan kunci**, tukarkan nilai kedua kepada `false`:

```lua
-- Buka UI secara terus tanpa prompt kunci
local Window = MalaikatLib:CreateWindow("Malaikat HUB", false)
```

### 📌 Ciri-Ciri Utama
* **Animasi Ultra Lancar:** Pergerakan tetingkap dan butang dikawal oleh formula spring physics yang sangat responsif.
* **Susun Atur Automatik:** Komponen disusun secara automatik mengikut Saiz kandungan dengan kemas.
* **Mesra Peranti:** Berfungsi dengan stabil pada peranti Mudah Alih (Mobile) dan PC.

### 👁️ Skrip Pratonton (Preview)
```lua
loadstring(game:HttpGet("[https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/PREVIEW.lua](https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/PREVIEW.lua)"))()
```
