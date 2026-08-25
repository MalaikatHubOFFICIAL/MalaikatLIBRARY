# 👼 MalaikatUI Library

[ 🇮🇩 Bahasa Indonesia ](#-bahasa-indonesia) | [ 🇬🇧 English ](#-english) | [ 🇲🇾 Bahasa Melayu ](#-bahasa-melayu)

---

## 🇮🇩 Bahasa Indonesia

**MalaikatUI** adalah library antarmuka (UI) Roblox modern bertema *Frosted Glass* yang dirancang untuk performa tinggi dan estetika yang bersih. Dilengkapi dengan sistem animasi berbasis *spring physics*, *dynamic notifications*, serta dukungan *Key System* yang fleksibel dan mudah dikonfigurasi.

### 🚀 Panduan Integrasi Skrip

```lua
-- 1. Import Library
local MalaikatLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/library.lua"))()

-- 2. Buat Window Utama (Konfigurasi Tabel)
local Window = MalaikatLib:CreateWindow({
    Title = "Malaikat HUB v2.0",
    KeySystem = true,                             -- Set 'false' untuk mematikan Key System
    Key = "Malaikat2026",                         -- Kunci akses utama
    KeyLink = "[https://linkvertise.com/your-link](https://linkvertise.com/your-link)" -- Link untuk mengambil kunci
})

-- 3. Buat Tab Navigasi
local MainTab = Window:CreateTab("Main Features")
local PlayerTab = Window:CreateTab("Player Settings")

-- 4. Tambahkan Komponen
MainTab:AddButton("Teleport Spawn", "Teleport", function()
    print("Teleported to spawn!")
end)

MainTab:AddToggle("Auto Farm Coins", false, function(Value)
    print("Auto Farm:", Value)
end)

PlayerTab:AddSlider("WalkSpeed Modifier", 16, 250, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)
```

### 💡 Konfigurasi Key System
Sistem keamanan dapat disesuaikan sepenuhnya saat menginisialisasi jendela UI:
* **Mengubah Link GetKey:** Cukup ganti nilai parameter `KeyLink` dengan URL tautan milikmu (Linkvertise, Lootlabs, Discord, dll).
* **Menonaktifkan Key System:** Ubah parameter `KeySystem = false`, maka UI akan langsung terbuka tanpa meminta kunci verifikasi.

### 👁️ Preview UI
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/PREVIEW.lua"))()
```

---

## 🇬🇧 English

**MalaikatUI** is a lightweight, modern Roblox UI Library powered by a custom frosted glass engine. It features fluid spring-lerp animations, ambient graphics, a dynamic island notification system, and an easily customizable Key System for script developers.

### 🚀 Integration Guide

```lua
-- 1. Import Library
local MalaikatLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/library.lua"))()

-- 2. Initialize Window (Table Configuration)
local Window = MalaikatLib:CreateWindow({
    Title = "Malaikat HUB v2.0",
    KeySystem = true,                             -- Set 'false' to disable Key System
    Key = "Malaikat2026",                         -- Access Key
    KeyLink = "[https://linkvertise.com/your-link](https://linkvertise.com/your-link)" -- Custom GetKey URL
})

-- 3. Create Navigation Tabs
local MainTab = Window:CreateTab("Main Features")
local PlayerTab = Window:CreateTab("Player Settings")

-- 4. Add Components
MainTab:AddButton("Teleport Spawn", "Teleport", function()
    print("Teleported to spawn!")
end)

MainTab:AddToggle("Auto Farm Coins", false, function(Value)
    print("Auto Farm:", Value)
end)

PlayerTab:AddSlider("WalkSpeed Modifier", 16, 250, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)
```

### 💡 Key System Flexibility
* **Custom GetKey Link:** Replace the `KeyLink` field with your monetization or community link.
* **Bypass Option:** Setting `KeySystem = false` bypasses authentication and opens the UI instantly.

### 👁️ Preview Script
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/PREVIEW.lua"))()
```

---

## 🇲🇾 Bahasa Melayu

**MalaikatUI** ialah library UI Roblox moden bertemakan *Frosted Glass* yang direka untuk kelancaran tinggi dan paparan yang bersih. Dilengkapi animasi *spring physics*, sistem pemberitahuan dinamik, serta sistem pengesahan kunci (Key System) yang boleh diubah suai mengikut keperluan pembangun.

### 🚀 Panduan Penggunaan

```lua
-- 1. Muat Turun Library
local MalaikatLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/library.lua"))()

-- 2. Cipta Window Utama (Tetapan Jadual)
local Window = MalaikatLib:CreateWindow({
    Title = "Malaikat HUB v2.0",
    KeySystem = true,                             -- Tetapkan 'false' untuk matikan Key System
    Key = "Malaikat2026",                         -- Kunci Akses
    KeyLink = "[https://linkvertise.com/your-link](https://linkvertise.com/your-link)" -- Pautan GetKey Pembangun
})

-- 3. Cipta Tab Navigasi
local MainTab = Window:CreateTab("Main Features")
local PlayerTab = Window:CreateTab("Player Settings")

-- 4. Tambah Komponen
MainTab:AddButton("Teleport Spawn", "Teleport", function()
    print("Teleported to spawn!")
end)

MainTab:AddToggle("Auto Farm Coins", false, function(Value)
    print("Auto Farm:", Value)
end)

PlayerTab:AddSlider("WalkSpeed Modifier", 16, 250, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)
```

### 💡 Fleksibiliti Key System
* **Tukar Pautan GetKey:** Masukkan URL anda sendiri pada ruang `KeyLink` (seperti pautan Monetisasi atau Discord).
* **Buka Secara Terus:** Nyahaktifkan Key System dengan meletakkan `KeySystem = false`.

### 👁️ Pratonton (Preview)
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MalaikatHubOFFICIAL/MalaikatLIBRARY/main/PREVIEW.lua"))()
```
