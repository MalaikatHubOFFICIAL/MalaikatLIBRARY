# 👼 MalaikatUI Library

[ 🇮🇩 Bahasa Indonesia ](#-bahasa-indonesia) | [ 🇬🇧 English ](#-english) | [ 🇲🇾 Bahasa Melayu ](#-bahasa-melayu)

---

## 🇮🇩 Bahasa Indonesia

**MalaikatUI** adalah library antarmuka (UI) Roblox modern bertema *Frosted Glass Engine*. Library ini dirancang untuk memberikan tampilan visual yang elegan, performa responsif, animasi *spring physics* yang mulus, serta dilengkapi fitur *Key System* yang fleksibel.

### 📌 Fitur Utama
* **Desain Frosted Glass:** Tampilan transparan yang modern dan bersih.
* **Animasi Lerp Spring:** Pergerakan antarmuka dan tombol terasa sangat halus.
* **Dynamic Island Notification:** Sistem antrean notifikasi melayang yang interaktif.
* **Key System Fleksibel:** Sistem verifikasi kunci akses yang mudah diatur atau dimatikan.
* **Komponen Lengkap:** Mendukung Button, Toggle, Slider, Dropdown, Input Box, Color Picker, Keybind, dan Section Header.
* **Dukungan Lintas Platform:** Stabil digunakan pada PC maupun Executor Mobile.

---

### 🚀 Panduan Inisialisasi

```lua
local MalaikatLib = loadstring(game:HttpGet("[https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/refs/heads/main/library.lua](https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/refs/heads/main/library.lua)"))

local Window = MalaikatLib:CreateWindow({
    Title = "Malaikat HUB v2.0",
    KeySystem = true,
    Key = "Malaikat2026",
    KeyLink = "[https://github.com/MalaikatHubOFFICIAL/MalaikatLIBRARY](https://github.com/MalaikatHubOFFICIAL/MalaikatLIBRARY)"
})
```

---

### 🧩 Panduan Komponen UI

#### 1. Membuat Tab Navigasi & Judul Bagian
```lua
local MainTab = Window:CreateTab("Main Features")
local SettingsTab = Window:CreateTab("Settings")

MainTab:AddSectionHeader("Fitur Utama")
```

#### 2. Tombol (Button)
```lua
MainTab:AddButton("Teleport ke Spawn", "Teleport", function()
    print("Berhasil teleport ke spawn!")
end)
```

#### 3. Sakelar (Toggle)
```lua
MainTab:AddToggle("Auto Farm Coins", false, function(Value)
    print("Status Auto Farm:", Value)
end)
```

#### 4. Penggeser Angka (Slider)
```lua
MainTab:AddSlider("Pengatur WalkSpeed", 16, 250, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)
```

#### 5. Menu Pilihan (Dropdown)
```lua
MainTab:AddDropdown("Pilih Senjata", {"Sword", "Bow", "Magic Staff"}, "Sword", function(Selected)
    print("Senjata yang dipilih:", Selected)
end)
```

#### 6. Kotak Teks (Input Box)
```lua
MainTab:AddInput("Teleport ke Pemain", "Ketik Username...", function(Text)
    print("Menuju ke pemain:", Text)
end)
```

#### 7. Pemilih Warna (Color Picker)
```lua
SettingsTab:AddColorPicker("Warna Overlay ESP", Color3.fromRGB(0, 122, 255), function(Color)
    print("Warna ESP diubah:", Color)
end)
```

#### 8. Pengatur Tombol Kunci (Keybind)
```lua
SettingsTab:AddKeybind("Tombol Toggle UI", "T", function(KeyCode)
    print("UI diatur ke tombol:", KeyCode.Name)
end)
```

---

### 👁️ Skrip Preview
```lua
loadstring(game:HttpGet("[https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/refs/heads/main/PREVIEW.lua](https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/refs/heads/main/PREVIEW.lua)"))()
```

---

## 🇬🇧 English

**MalaikatUI** is a lightweight, modern Roblox UI Library powered by a custom Frosted Glass Engine. Built for clean visuals, ultra-smooth spring physics, high performance, and an adaptable Key System.

### 📌 Core Features
* **Frosted Glass Aesthetic:** Elegant and clean semi-transparent user interface.
* **Ultra Smooth Physics:** Powered by lerp spring algorithms for seamless interactions.
* **Dynamic Island Notifications:** Sleek floating notification queue system.
* **Flexible Key System:** Toggle key verification on or off effortlessly.
* **Full Component Suite:** Supports Buttons, Toggles, Sliders, Dropdowns, Input Boxes, Color Pickers, Keybinds, and Section Headers.
* **Cross-Platform Support:** Fully optimized for both Mobile and Desktop Executors.

---

### 🚀 Quick Start Guide

```lua
local MalaikatLib = loadstring(game:HttpGet("[https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/refs/heads/main/library.lua](https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/refs/heads/main/library.lua)"))

local Window = MalaikatLib:CreateWindow({
    Title = "Malaikat HUB v2.0",
    KeySystem = true,
    Key = "Malaikat2026",
    KeyLink = "[https://github.com/MalaikatHubOFFICIAL/MalaikatLIBRARY](https://github.com/MalaikatHubOFFICIAL/MalaikatLIBRARY)"
})
```

---

### 🧩 UI Components Guide

#### 1. Creating Tabs & Section Headers
```lua
local MainTab = Window:CreateTab("Main Features")
local SettingsTab = Window:CreateTab("Settings")

MainTab:AddSectionHeader("Main Options")
```

#### 2. Action Button
```lua
MainTab:AddButton("Teleport Spawn", "Teleport", function()
    print("Teleported to spawn!")
end)
```

#### 3. State Toggle
```lua
MainTab:AddToggle("Auto Farm Coins", false, function(Value)
    print("Auto Farm status:", Value)
end)
```

#### 4. Value Slider
```lua
MainTab:AddSlider("WalkSpeed Modifier", 16, 250, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)
```

#### 5. Dropdown Menu
```lua
MainTab:AddDropdown("Select Weapon", {"Sword", "Bow", "Magic Staff"}, "Sword", function(Selected)
    print("Weapon selected:", Selected)
end)
```

#### 6. Text Input Box
```lua
MainTab:AddInput("Teleport to Player", "Enter Username...", function(Text)
    print("Teleporting to:", Text)
end)
```

#### 7. Color Picker
```lua
SettingsTab:AddColorPicker("ESP Color Overlay", Color3.fromRGB(0, 122, 255), function(Color)
    print("ESP Color changed:", Color)
end)
```

#### 8. Keybind Setup
```lua
SettingsTab:AddKeybind("Toggle UI Keybind", "T", function(KeyCode)
    print("Keybound to:", KeyCode.Name)
end)
```

---

### 👁️ Preview Script
```lua
loadstring(game:HttpGet("[https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/refs/heads/main/PREVIEW.lua](https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/refs/heads/main/PREVIEW.lua)"))()
```

---

## 🇲🇾 Bahasa Melayu

**MalaikatUI** ialah library UI Roblox moden berkuasakan *Frosted Glass Engine*. Direka khas untuk memberikan paparan yang kemas, prestasi tinggi, animasi *spring physics* yang lancar, serta dilengkapi fungsi *Key System* yang fleksibel.

### 📌 Ciri-Ciri Utama
* **Reka Bentuk Frosted Glass:** Paparan lut sinar yang moden dan elegan.
* **Animasi Lerp Spring:** Pergerakan antaramuka dan butang terasa sangat lancar.
* **Dynamic Island Notification:** Sistem notifikasi terapung yang responsif.
* **Sistem Kunci Boleh Disesuaikan:** Pengesahan kunci yang mudah diaktifkan atau dimatikan.
* **Set Komponen Lengkap:** Menyokong Button, Toggle, Slider, Dropdown, Input Box, Color Picker, Keybind, dan Section Header.
* **Sokongan Pelbagai Peranti:** Stabil digunakan pada peranti PC dan Telefon Pintar.

---

### 🚀 Panduan Penggunaan Pantas

```lua
local MalaikatLib = loadstring(game:HttpGet("[https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/refs/heads/main/library.lua](https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/refs/heads/main/library.lua)"))

local Window = MalaikatLib:CreateWindow({
    Title = "Malaikat HUB v2.0",
    KeySystem = true,
    Key = "Malaikat2026",
    KeyLink = "[https://github.com/MalaikatHubOFFICIAL/MalaikatLIBRARY](https://github.com/MalaikatHubOFFICIAL/MalaikatLIBRARY)"
})
