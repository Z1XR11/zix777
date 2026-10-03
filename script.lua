--[[
    ============================================================
    ALPHA SANDBOX ULTRA ++ [PREMIUM FULL EDITION]
    Version: 5.1 (Themes Fix • Items Tab • Spawner Stub • Window Stub)
    ============================================================
    ЧТО НОВОГО В V5.1:
    - ТЕМЫ ПОЧИНЕНЫ: перекраска по ролям (BgKey/TextKey/StrokeKey),
      а не по совпадению цветов — работает Чёрная/Белая/Прозрачная
    - ПОДСВЕТКА: при закрытии меню снимается, при открытии снова
      подсвечивается выбранная машина/предмет
    - ВКЛАДКА "ЛУТ" переименована в "ПРЕДМЕТЫ", ищет ТОЛЬКО модели
      (звуки/аудио исключены)
    - НОВАЯ ВКЛАДКА "СПАВНЕР" (каркас, заполняется позже)
    - ИГРОКИ: кнопка "ОКНО" (заглушка, окно сделаем позже)
    - Кнопки больше не уменьшаются при клике
    ============================================================
]]

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Очистка старых версий интерфейса
for _, oldName in ipairs({"AlphaPremiumUI_V3", "AlphaPremiumUI_V4", "AlphaPremiumUI_V5"}) do
    local old = CoreGui:FindFirstChild(oldName)
    if old then old:Destroy() end
end

-- ==========================================
-- ТЕМЫ: 3 палитры (чёрная / белая / прозрачная)
-- Theme — активная палитра. Все элементы читают Theme.* при создании,
-- поэтому смена темы = перекраска по точному совпадению цвета.
-- ==========================================
local Theme = {
    Background = Color3.fromRGB(12, 14, 20),
    Header = Color3.fromRGB(18, 21, 30),
    Sidebar = Color3.fromRGB(15, 17, 25),
    Footer = Color3.fromRGB(15, 17, 25),
    TabUnselected = Color3.fromRGB(24, 27, 38),
    TabSelected = Color3.fromRGB(124, 92, 255),
    ElementBg = Color3.fromRGB(22, 25, 35),
    ElementHover = Color3.fromRGB(32, 36, 50),
    Text = Color3.fromRGB(240, 242, 248),
    TextDim = Color3.fromRGB(140, 145, 160),
    Accent = Color3.fromRGB(124, 92, 255),
    AccentHover = Color3.fromRGB(146, 118, 255),
    Outline = Color3.fromRGB(40, 44, 60),
    Red = Color3.fromRGB(255, 70, 70),
    RedHover = Color3.fromRGB(255, 95, 95),
    Green = Color3.fromRGB(45, 215, 90),
    GreenHover = Color3.fromRGB(70, 230, 110),
    Gold = Color3.fromRGB(255, 200, 60),
    DeepBg = Color3.fromRGB(14, 16, 22),
    SwitchOff = Color3.fromRGB(55, 58, 70),
    KnobBg = Color3.fromRGB(255, 255, 255),
    Ripple = Color3.fromRGB(255, 255, 255)
}

local Palettes = {
    black = {
        Background = Color3.fromRGB(12, 14, 20), Header = Color3.fromRGB(18, 21, 30),
        Sidebar = Color3.fromRGB(15, 17, 25), Footer = Color3.fromRGB(15, 17, 25),
        TabUnselected = Color3.fromRGB(24, 27, 38), TabSelected = Color3.fromRGB(124, 92, 255),
        ElementBg = Color3.fromRGB(22, 25, 35), ElementHover = Color3.fromRGB(32, 36, 50),
        Text = Color3.fromRGB(240, 242, 248), TextDim = Color3.fromRGB(140, 145, 160),
        Accent = Color3.fromRGB(124, 92, 255), AccentHover = Color3.fromRGB(146, 118, 255),
        Outline = Color3.fromRGB(40, 44, 60),
        Red = Color3.fromRGB(255, 70, 70), RedHover = Color3.fromRGB(255, 95, 95),
        Green = Color3.fromRGB(45, 215, 90), GreenHover = Color3.fromRGB(70, 230, 110),
        Gold = Color3.fromRGB(255, 200, 60), DeepBg = Color3.fromRGB(14, 16, 22),
        SwitchOff = Color3.fromRGB(55, 58, 70), KnobBg = Color3.fromRGB(255, 255, 255),
        Ripple = Color3.fromRGB(255, 255, 255)
    },
    white = {
        Background = Color3.fromRGB(245, 245, 249), Header = Color3.fromRGB(255, 255, 255),
        Sidebar = Color3.fromRGB(238, 239, 244), Footer = Color3.fromRGB(238, 239, 244),
        TabUnselected = Color3.fromRGB(229, 231, 238), TabSelected = Color3.fromRGB(124, 92, 255),
        ElementBg = Color3.fromRGB(255, 255, 255), ElementHover = Color3.fromRGB(238, 239, 244),
        Text = Color3.fromRGB(28, 29, 38), TextDim = Color3.fromRGB(120, 122, 135),
        Accent = Color3.fromRGB(124, 92, 255), AccentHover = Color3.fromRGB(146, 118, 255),
        Outline = Color3.fromRGB(205, 208, 218),
        Red = Color3.fromRGB(230, 60, 60), RedHover = Color3.fromRGB(245, 90, 90),
        Green = Color3.fromRGB(40, 190, 80), GreenHover = Color3.fromRGB(60, 210, 100),
        Gold = Color3.fromRGB(214, 150, 20), DeepBg = Color3.fromRGB(230, 231, 237),
        SwitchOff = Color3.fromRGB(200, 203, 212), KnobBg = Color3.fromRGB(255, 255, 255),
        Ripple = Color3.fromRGB(140, 142, 155)
    },
    transparent = {
        Background = Color3.fromRGB(10, 12, 18), Header = Color3.fromRGB(16, 19, 28),
        Sidebar = Color3.fromRGB(13, 15, 23), Footer = Color3.fromRGB(13, 15, 23),
        TabUnselected = Color3.fromRGB(24, 27, 38), TabSelected = Color3.fromRGB(124, 92, 255),
        ElementBg = Color3.fromRGB(22, 25, 35), ElementHover = Color3.fromRGB(34, 38, 52),
        Text = Color3.fromRGB(240, 242, 248), TextDim = Color3.fromRGB(150, 155, 170),
        Accent = Color3.fromRGB(124, 92, 255), AccentHover = Color3.fromRGB(146, 118, 255),
        Outline = Color3.fromRGB(60, 66, 88),
        Red = Color3.fromRGB(255, 70, 70), RedHover = Color3.fromRGB(255, 95, 95),
        Green = Color3.fromRGB(45, 215, 90), GreenHover = Color3.fromRGB(70, 230, 110),
        Gold = Color3.fromRGB(255, 200, 60), DeepBg = Color3.fromRGB(12, 14, 20),
        SwitchOff = Color3.fromRGB(55, 58, 70), KnobBg = Color3.fromRGB(255, 255, 255),
        Ripple = Color3.fromRGB(255, 255, 255)
    }
}

local CurrentTheme = "black"
local MainBaseTransparency = 0
local PanelBaseTransparency = 0

-- ==========================================
-- ЯЗЫКИ: русский (исходник) / English / Українська
-- Ключи — русские строки-исходники. T() возвращает перевод.
-- ==========================================
local I18N = {
    en = {
        ["ВКЛАДКИ"] = "TABS",
        ["АВТО"] = "AUTO", ["ПРЕДМЕТЫ"] = "ITEMS", ["СПАВНЕР"] = "SPAWNER", ["ИГРОКИ"] = "PLAYERS",
        ["ТЕЛЕПОРТ"] = "TELEPORT", ["НАСТРОЙКИ"] = "SETTINGS",
        ["ПКМ CTRL — полёт • Y — зомби • P — детонатор • L — активатор • CTRL+ЛКМ — телепорт"] = "R-CTRL — fly • Y — zombie • P — detonator • L — activator • CTRL+CLICK — teleport",
        ["🔍 НАЙТИ МАШИНЫ В МИРЕ"] = "🔍 FIND CARS IN WORLD",
        ["🔍 НАЙТИ ПРЕДМЕТЫ И МОТОРЫ"] = "🔍 FIND ITEMS & ENGINES",
        [" ЗНАЧЕНИЯ (VALUES)"] = " VALUES",
        [" ФИЗИКА КОЛЁС"] = " WHEEL PHYSICS",
        ["Трение (Friction)"] = "Friction",
        ["Плотность (Density)"] = "Density",
        ["Упругость (Elasticity)"] = "Elasticity",
        ["Вес трения (F. Weight)"] = "Friction Weight",
        ["Вес упруг. (E. Weight)"] = "Elasticity Weight",
        [" ПОДВЕСКА"] = " SUSPENSION",
        ["Высота"] = "Height",
        ["Все"] = "All", ["Пер"] = "Front", ["Зад"] = "Rear",
        ["ПЛ"] = "FL", ["ПП"] = "FR", ["ЗЛ"] = "RL", ["ЗП"] = "RR",
        [" ЧИТЫ"] = " CHEATS",
        ["Нет голода"] = "No Hunger",
        ["Нет стамины"] = "No Stamina",
        ["Нет регдолла"] = "No Ragdoll",
        ["Бессмертие"] = "God Mode",
        ["Бессмертие машины"] = "God Car",
        [" ПОЛЕТ (БЕЗ ГРАВИТАЦИИ): ПРАВЫЙ CTRL"] = " FLIGHT (NO GRAVITY): RIGHT CTRL",
        ["Удалятор (debugui)"] = "Deleter (debugui)",
        ["Угол обзора (FOV)"] = "Field of View (FOV)",
        ["Детонатор (Кнопка P)"] = "Detonator (Key P)",
        ["Активатор (Кнопка L)"] = "Activator (Key L)",
        ["Спавн зомби (Зажатие Y)"] = "Spawn Zombie (Hold Y)",
        ["Телепорт по клику (Зажать Ctrl + Левый Клик мышкой)"] = "Teleport on click (Hold Ctrl + Left Click)",
        ["ОЖИДАНИЕ ДАННЫХ..."] = "WAITING FOR DATA...",
        ["ИГРОКОВ НА СЕРВЕРЕ: "] = "PLAYERS ON SERVER: ",
        ["🚀 ТЕЛЕПОРТ К ИГРОКУ"] = "🚀 TELEPORT TO PLAYER",
        ["🔄 ОБНОВИТЬ СПИСОК"] = "🔄 REFRESH LIST",
        ["🚀 ТЕЛЕПОРТ К: "] = "🚀 TELEPORT TO: ",
        ["💻 ЗАПУСТИТЬ Infinite Yield (Консоль)"] = "💻 LOAD Infinite Yield (Console)",
        ["📖 ГОРЯЧИЕ КЛАВИШИ"] = "📖 HOTKEYS",
        ["ТЕМА"] = "THEME", ["ЯЗЫК"] = "LANGUAGE", ["КНОПКА МЕНЮ"] = "MENU BUTTON",
        ["Чёрная"] = "Black", ["Белая"] = "White", ["Прозрачная"] = "Transparent",
        ["Круглая (углы и края)"] = "Round (corners & edges)",
        ["Плоская (верх и низ)"] = "Flat (top & bottom)",
        [": ВКЛ"] = ": ON", [": ВЫКЛ"] = ": OFF",
        ["Полёт включён (ПКМ CTRL — переключить)"] = "Flight ON (R-CTRL to toggle)",
        ["Полёт выключен"] = "Flight OFF",
        ["Телепорт к "] = "Teleport to ",
        [" выполнен"] = " done",
        ["Сначала выбери игрока"] = "Select a player first",
        ["Выбрана машина: "] = "Car selected: ",
        ["Выбран предмет: "] = "Item selected: ",
        ["Сканирование мира завершено"] = "World scan complete",
        ["Сканирование завершено"] = "Scan complete",
        ["Infinite Yield запущен"] = "Infinite Yield loaded",
        [" загружен"] = " loaded",
        ["Игрок зашёл: "] = "Player joined: ",
        ["Игрок вышел: "] = "Player left: ",
        ["• Правый CTRL — вкл/выкл полёт (WASD + Space/Shift)"] = "• Right CTRL — toggle fly (WASD + Space/Shift)",
        ["• CTRL + Левый Клик — телепорт (вкл. во вкладке ТЕЛЕПОРТ)"] = "• CTRL + Left Click — teleport (enable in TELEPORT)",
        ["• Y (зажать) — спавн зомби (вкл. в ИГРОКАХ)"] = "• Y (hold) — spawn zombie (enable in PLAYERS)",
        ["• P — детонатор: активирует tnt/bomb/firework/подарки"] = "• P — detonator: fires tnt/bomb/firework/gifts",
        ["• L — активатор: запускает турбины (TRUST)"] = "• L — activator: starts turbines (TRUST)",
        ["• Кнопка меню (3 полоски) — открыть меню после закрытия"] = "• Menu button (3 stripes) — reopen the menu",
        ["Все функции доступны сразу во вкладке ИГРОКИ."] = "All functions are available right away in PLAYERS."
    },
    ua = {
        ["ВКЛАДКИ"] = "ВКЛАДКИ",
        ["АВТО"] = "АВТО", ["ПРЕДМЕТЫ"] = "ПРЕДМЕТИ", ["СПАВНЕР"] = "СПАВНЕР", ["ИГРОКИ"] = "ГРАВЦІ",
        ["ТЕЛЕПОРТ"] = "ТЕЛЕПОРТ", ["НАСТРОЙКИ"] = "НАЛАШТУВАННЯ",
        ["ПКМ CTRL — полёт • Y — зомби • P — детонатор • L — активатор • CTRL+ЛКМ — телепорт"] = "ПКМ CTRL — політ • Y — зомбі • P — детонатор • L — активатор • CTRL+ЛКМ — телепорт",
        ["🔍 НАЙТИ МАШИНЫ В МИРЕ"] = "🔍 ЗНАЙТИ АВТО У СВІТІ",
        ["🔍 НАЙТИ ПРЕДМЕТЫ И МОТОРЫ"] = "🔍 ЗНАЙТИ ПРЕДМЕТИ І МОТОРИ",
        [" ЗНАЧЕНИЯ (VALUES)"] = " ЗНАЧЕННЯ (VALUES)",
        [" ФИЗИКА КОЛЁС"] = " ФІЗИКА КОЛІС",
        ["Трение (Friction)"] = "Тертя (Friction)",
        ["Плотность (Density)"] = "Щільність (Density)",
        ["Упругость (Elasticity)"] = "Пружність (Elasticity)",
        ["Вес трения (F. Weight)"] = "Вага тертя (F. Weight)",
        ["Вес упруг. (E. Weight)"] = "Вага пружн. (E. Weight)",
        [" ПОДВЕСКА"] = " ПІДВІСКА",
        ["Высота"] = "Висота",
        ["Все"] = "Всі", ["Пер"] = "Пер", ["Зад"] = "Зад",
        ["ПЛ"] = "ПЛ", ["ПП"] = "ПП", ["ЗЛ"] = "ЗЛ", ["ЗП"] = "ЗП",
        [" ЧИТЫ"] = " ЧІТИ",
        ["Нет голода"] = "Немає голоду",
        ["Нет стамины"] = "Немає витривалості",
        ["Нет регдолла"] = "Немає регдолла",
        ["Бессмертие"] = "Безсмертя",
        ["Бессмертие машины"] = "Безсмертя машини",
        [" ПОЛЕТ (БЕЗ ГРАВИТАЦИИ): ПРАВЫЙ CTRL"] = " ПОЛІТ (БЕЗ ГРАВІТАЦІЇ): ПРАВИЙ CTRL",
        ["Удалятор (debugui)"] = "Видалятор (debugui)",
        ["Угол обзора (FOV)"] = "Кут огляду (FOV)",
        ["Детонатор (Кнопка P)"] = "Детонатор (Клавіша P)",
        ["Активатор (Кнопка L)"] = "Активатор (Клавіша L)",
        ["Спавн зомби (Зажатие Y)"] = "Спавн зомбі (Затиск Y)",
        ["Телепорт по клику (Зажать Ctrl + Левый Клик мышкой)"] = "Телепорт по кліку (Затиск Ctrl + Лівий клік)",
        ["ОЖИДАНИЕ ДАННЫХ..."] = "ОЧІКУВАННЯ ДАНИХ...",
        ["ИГРОКОВ НА СЕРВЕРЕ: "] = "ГРАВЦІВ НА СЕРВЕРІ: ",
        ["🚀 ТЕЛЕПОРТ К ИГРОКУ"] = "🚀 ТЕЛЕПОРТ ДО ГРАВЦЯ",
        ["🔄 ОБНОВИТЬ СПИСОК"] = "🔄 ОНОВИТИ СПИСОК",
        ["🚀 ТЕЛЕПОРТ К: "] = "🚀 ТЕЛЕПОРТ ДО: ",
        ["💻 ЗАПУСТИТЬ Infinite Yield (Консоль)"] = "💻 ЗАПУСТИТИ Infinite Yield (Консоль)",
        ["📖 ГОРЯЧИЕ КЛАВИШИ"] = "📖 ГАРЯЧІ КЛАВІШІ",
        ["ТЕМА"] = "ТЕМА", ["ЯЗЫК"] = "МОВА", ["КНОПКА МЕНЮ"] = "КНОПКА МЕНЮ",
        ["Чёрная"] = "Чорна", ["Белая"] = "Біла", ["Прозрачная"] = "Прозора",
        ["Круглая (углы и края)"] = "Кругла (кути і краї)",
        ["Плоская (верх и низ)"] = "Плоска (верх і низ)",
        [": ВКЛ"] = ": УВІМК", [": ВЫКЛ"] = ": ВИМК",
        ["Полёт включён (ПКМ CTRL — переключить)"] = "Політ увімкнено (ПКМ CTRL — перемкнути)",
        ["Полёт выключен"] = "Політ вимкнено",
        ["Телепорт к "] = "Телепорт до ",
        [" выполнен"] = " виконано",
        ["Сначала выбери игрока"] = "Спочатку обери гравця",
        ["Выбрана машина: "] = "Обрано авто: ",
        ["Выбран предмет: "] = "Обрано предмет: ",
        ["Сканирование мира завершено"] = "Сканування світу завершено",
        ["Сканирование завершено"] = "Сканування завершено",
        ["Infinite Yield запущен"] = "Infinite Yield запущено",
        [" загружен"] = " завантажено",
        ["Игрок зашёл: "] = "Гравець зайшов: ",
        ["Игрок вышел: "] = "Гравець вийшов: ",
        ["• Правый CTRL — вкл/выкл полёт (WASD + Space/Shift)"] = "• Правий CTRL — увімк/вимк політ (WASD + Space/Shift)",
        ["• CTRL + Левый Клик — телепорт (вкл. во вкладке ТЕЛЕПОРТ)"] = "• CTRL + Лівий клік — телепорт (увімк. у вкладці ТЕЛЕПОРТ)",
        ["• Y (зажать) — спавн зомби (вкл. в ИГРОКАХ)"] = "• Y (затиснути) — спавн зомбі (увімк. у ГРАВЦЯХ)",
        ["• P — детонатор: активирует tnt/bomb/firework/подарки"] = "• P — детонатор: активує tnt/bomb/firework/подарунки",
        ["• L — активатор: запускает турбины (TRUST)"] = "• L — активатор: запускає турбіни (TRUST)",
        ["• Кнопка меню (3 полоски) — открыть меню после закрытия"] = "• Кнопка меню (3 смужки) — відкрити меню після закриття",
        ["Все функции доступны сразу во вкладке ИГРОКИ."] = "Усі функції доступні одразу у вкладці ГРАВЦІ."
    }
}

local curLang = "ru"

local function T(s)
    local d = I18N[curLang]
    if d and d[s] then return d[s] end
    return s
end

local AnimInfo = {
    Fast = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
}

local SCRIPT_VERSION = "V5.1"

-- ==========================================
-- УТИЛИТЫ ДЛЯ СОЗДАНИЯ ИНТЕРФЕЙСА
-- ==========================================
local function Create(className, properties)
    local inst = Instance.new(className)
    for k, v in pairs(properties) do
        pcall(function() inst[k] = v end)
    end
    if (className == "TextLabel" or className == "TextButton" or className == "TextBox") and inst.Text ~= nil and inst:GetAttribute("SrcText") == nil then
        inst:SetAttribute("SrcText", inst.Text)
    end
    if inst:IsA("GuiObject") then
        if inst.BackgroundColor3 and inst.BackgroundTransparency ~= 1 then
            for k, v in pairs(Theme) do
                if v == inst.BackgroundColor3 then inst:SetAttribute("BgKey", k); break end
            end
        end
    end
    if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
        for k, v in pairs(Theme) do
            if v == inst.TextColor3 then inst:SetAttribute("TextKey", k); break end
        end
    end
    if inst:IsA("UIStroke") then
        for k, v in pairs(Theme) do
            if v == inst.Color then inst:SetAttribute("StrokeKey", k); break end
        end
    end
    return inst
end

local function AddCorner(parent, radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius), Parent = parent})
end

local function AddStroke(parent, color, thickness)
    return Create("UIStroke", {
        Color = color,
        Thickness = thickness,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

-- СИСТЕМА УВЕДОМЛЕНИЙ (ТОСТЫ)
-- ==========================================
local NotifyHolder = Create("Frame", {
    Name = "NotifyHolder",
    Size = UDim2.new(0, 300, 1, -20),
    Position = UDim2.new(1, -310, 0, 10),
    BackgroundTransparency = 1,
    Parent = nil
})

Create("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    Parent = NotifyHolder
})

local notifyId = 0

local function Notify(text, color)
    notifyId = notifyId + 1
    local Card = Create("Frame", {
        Name = "Notify_" .. notifyId,
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = Theme.Header,
        BorderSizePixel = 0,
        Parent = NotifyHolder
    })
    AddCorner(Card, 10)
    AddStroke(Card, color or Theme.Accent, 1.5)

    Create("TextLabel", {
        Size = UDim2.new(1, -24, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextWrapped = true,
        Parent = Card
    })

    Card.Size = UDim2.new(1, 0, 0, 0)
    TweenService:Create(Card, AnimInfo.Bounce, {Size = UDim2.new(1, 0, 0, 42)}):Play()

    task.delay(3, function()
        pcall(function()
            local out = TweenService:Create(Card, AnimInfo.Fast, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
            out:Play()
            out.Completed:Wait()
            Card:Destroy()
        end)
    end)
end

-- ==========================================
-- КНОПКИ (V4: Ripple + атрибутные цвета)
-- ==========================================
local function PlayRipple(btn, input)
    pcall(function()
        local w = btn.AbsoluteSize.X
        local diameter = math.max(w * 1.6, 80)
        local localX = input.Position.X - btn.AbsolutePosition.X
        local localY = input.Position.Y - btn.AbsolutePosition.Y

        local ripple = Create("Frame", {
            Size = UDim2.new(0, 10, 0, 10),
            Position = UDim2.new(0, localX, 0, localY),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Theme.Ripple,
            BackgroundTransparency = 0.82,
            BorderSizePixel = 0,
            ZIndex = btn.ZIndex + 5,
            Parent = btn
        })
        AddCorner(ripple, 100)

        TweenService:Create(ripple, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, diameter, 0, diameter),
            BackgroundTransparency = 1
        }):Play()

        task.delay(0.5, function()
            pcall(function() ripple:Destroy() end)
        end)
    end)
end

local function CreateButtonEx(parent, text, baseColor, hoverColor, callback)
    local cBase = baseColor or Theme.ElementBg
    local cHover = hoverColor or Theme.ElementHover

    local baseKey = "ElementBg"
    local hoverKey = "ElementHover"
    for k, v in pairs(Theme) do
        if v == cBase then baseKey = k end
        if v == cHover then hoverKey = k end
    end

    local Btn = Create("TextButton", {
        Size = UDim2.new(0.98, 0, 0, 40),
        BackgroundColor3 = cBase,
        Text = text,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        AutoButtonColor = false,
        ClipsDescendants = true,
        Parent = parent
    })
    Btn:SetAttribute("BaseColor", cBase)
    Btn:SetAttribute("HoverColor", cHover)
    Btn:SetAttribute("BaseKey", baseKey)
    Btn:SetAttribute("HoverKey", hoverKey)

    AddCorner(Btn, 10)
    local stroke = AddStroke(Btn, Theme.Outline, 1)

    Btn.MouseEnter:Connect(function()
        local hoverCol = Theme[Btn:GetAttribute("HoverKey") or "ElementHover"]
        TweenService:Create(Btn, AnimInfo.Fast, {BackgroundColor3 = hoverCol or cHover}):Play()
        if not baseColor then
            TweenService:Create(stroke, AnimInfo.Fast, {Color = Theme.Accent}):Play()
        end
    end)

    Btn.MouseLeave:Connect(function()
        local baseCol = Theme[Btn:GetAttribute("BaseKey") or "ElementBg"]
        TweenService:Create(Btn, AnimInfo.Fast, {BackgroundColor3 = baseCol or cBase}):Play()
        if not baseColor then
            TweenService:Create(stroke, AnimInfo.Fast, {Color = Theme.Outline}):Play()
        end
    end)

    Btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            PlayRipple(Btn, input)
        end
    end)

    if callback then
        Btn.MouseButton1Click:Connect(function()
            callback(Btn)
        end)
    end
    return Btn
end

local function CreateToggle(parent, text, default, callback)
    local ToggleFrame = Create("Frame", {
        Size = UDim2.new(0.98, 0, 0, 42),
        BackgroundColor3 = Theme.ElementBg,
        BorderSizePixel = 0,
        Parent = parent
    })
    AddCorner(ToggleFrame, 10)
    AddStroke(ToggleFrame, Theme.Outline, 1)

    Create("TextLabel", {
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ToggleFrame
    })

    local SwitchBg = Create("Frame", {
        Size = UDim2.new(0, 46, 0, 26),
        Position = UDim2.new(1, -60, 0.5, -13),
        BackgroundColor3 = default and Theme.Green or Theme.SwitchOff,
        BorderSizePixel = 0,
        Parent = ToggleFrame
    })
    AddCorner(SwitchBg, 13)

    local SwitchKnob = Create("Frame", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(0, default and 22 or 2, 0.5, -11),
        BackgroundColor3 = Theme.KnobBg,
        BorderSizePixel = 0,
        Parent = SwitchBg
    })
    AddCorner(SwitchKnob, 11)

    local Btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = ToggleFrame
    })

    local state = default
    local function ApplyState(newState)
        state = newState
        TweenService:Create(SwitchBg, AnimInfo.Fast, {BackgroundColor3 = state and Theme.Green or Theme.SwitchOff}):Play()
        TweenService:Create(SwitchKnob, AnimInfo.Bounce, {Position = UDim2.new(0, state and 22 or 2, 0.5, -11)}):Play()
        if callback then callback(state) end
    end

    Btn.MouseButton1Click:Connect(function()
        ApplyState(not state)
    end)

    return ToggleFrame, function(newState)
        state = newState
        TweenService:Create(SwitchBg, AnimInfo.Fast, {BackgroundColor3 = state and Theme.Green or Theme.SwitchOff}):Play()
        TweenService:Create(SwitchKnob, AnimInfo.Bounce, {Position = UDim2.new(0, state and 22 or 2, 0.5, -11)}):Play()
    end
end

-- Реестр слайдеров для перевода их подписей при смене языка
local sliderRegistry = {}

local function Slider(parent, text, min, max, step, default, callback)
    local container = Create("Frame", {
        Size = UDim2.new(0.98, 0, 0, 50),
        BackgroundColor3 = Theme.ElementBg,
        BorderSizePixel = 0,
        Parent = parent
    })
    AddCorner(container, 10)
    AddStroke(container, Theme.Outline, 1)

    local curVal = default

    local label = Create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 20),
        Position = UDim2.new(0, 12, 0, 6),
        BackgroundTransparency = 1,
        Text = T(text) .. ": " .. tostring(default),
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local track = Create("Frame", {
        Size = UDim2.new(1, -24, 0, 8),
        Position = UDim2.new(0, 12, 0, 32),
        BackgroundColor3 = Theme.DeepBg,
        BorderSizePixel = 0,
        Parent = container
    })
    AddCorner(track, 4)

    local fill = Create("Frame", {
        Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = track
    })
    AddCorner(fill, 4)

    local knob = Create("TextButton", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(1, -9, 0.5, -9),
        BackgroundColor3 = Theme.KnobBg,
        Text = "",
        BorderSizePixel = 0,
        Parent = fill
    })
    AddCorner(knob, 9)

    local dragging = false
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local val = tonumber(string.format("%.2f", math.floor((min + ((max - min) * pos)) / step + 0.5) * step))
            curVal = val
            fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
            label.Text = T(text) .. ": " .. tostring(val)
            callback(val)
        end
    end)

    table.insert(sliderRegistry, {label = label, baseKey = text, getVal = function() return curVal end})

    return container
end

-- ==========================================
-- ИНИЦИАЛИЗАЦИЯ ГЛАВНОГО ИНТЕРФЕЙСА (V5)
-- ==========================================
local ScreenGui = Create("ScreenGui", {Name = "AlphaPremiumUI_V5", Parent = CoreGui, ResetOnSpawn = false, DisplayOrder = 100})
NotifyHolder.Parent = ScreenGui

-- КНОПКА-ГАМБУРГЕР (круглая/плоская, перетаскивается с прилипанием)
local OpenBtn = Create("TextButton", {
    Size = UDim2.new(0, 56, 0, 56),
    Position = UDim2.new(1, -72, 1, -72),
    BackgroundColor3 = Theme.Accent,
    Text = "",
    AutoButtonColor = false,
    ClipsDescendants = true,
    Visible = false,
    Parent = ScreenGui
})
local openBtnCorner = AddCorner(OpenBtn, 28)
AddStroke(OpenBtn, Theme.Text, 1.5)

local stripes = {}
for i = 0, 2 do
    local s = Create("Frame", {
        Size = UDim2.new(0, 24, 0, 3),
        BackgroundColor3 = Theme.KnobBg,
        BorderSizePixel = 0,
        Parent = OpenBtn
    })
    table.insert(stripes, s)
end

local MainFrame = Create("Frame", {
    Size = UDim2.new(0, 920, 0, 580),
    Position = UDim2.new(0.5, -460, 0.5, -290),
    BackgroundColor3 = Theme.Background,
    Active = true,
    BorderSizePixel = 0,
    Parent = ScreenGui
})
AddCorner(MainFrame, 14)
AddStroke(MainFrame, Theme.Outline, 1.5)

local MainScale = Create("UIScale", {Scale = 1, Parent = MainFrame})

-- Реестр подсветок (ESP) — создаётся до OpenMenu/CloseMenu,
-- чтобы закрытие меню могло снимать подсветку со всего.
local HighlightRegistry = {}
local SelectedTargets = {}

local function ClearAllHighlights()
    for i, hl in ipairs(HighlightRegistry) do
        pcall(function() if hl.Parent then hl:Destroy() end end)
    end
    HighlightRegistry = {}
end

local function RestoreAllHighlights()
    ClearAllHighlights()
    for _, entry in ipairs(SelectedTargets) do
        local t = entry and entry[1]
        local color = entry and entry[2]
        pcall(function()
            if t and t.Parent then
                local hl = Instance.new("Highlight")
                hl.Name = "EditorESP"
                hl.FillColor = color or Theme.Accent
                hl.OutlineColor = Color3.new(1, 1, 1)
                hl.FillTransparency = 0.5
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = t
                table.insert(HighlightRegistry, hl)
            end
        end)
    end
end

-- ШАПКА
local Header = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 52),
    BackgroundColor3 = Theme.Header,
    BorderSizePixel = 0,
    Parent = MainFrame
})
AddCorner(Header, 14)
Create("Frame", {Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -14), BackgroundColor3 = Theme.Header, BorderSizePixel = 0, Parent = Header})

Create("TextLabel", {
    Size = UDim2.new(0, 40, 1, 0),
    Position = UDim2.new(0, 14, 0, 0),
    BackgroundTransparency = 1,
    Text = "⚡",
    TextColor3 = Theme.Accent,
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    Parent = Header
})

local Title = Create("TextLabel", {
    Size = UDim2.new(1, -110, 1, 0),
    Position = UDim2.new(0, 52, 0, 0),
    BackgroundTransparency = 1,
    Text = "ALPHA SANDBOX ULTRA ++",
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Header
})

Create("TextLabel", {
    Size = UDim2.new(1, -110, 0, 14),
    Position = UDim2.new(0, 52, 0, 30),
    BackgroundTransparency = 1,
    Text = "PREMIUM FULL EDITION • " .. SCRIPT_VERSION,
    TextColor3 = Theme.TextDim,
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Header
})

local CloseBtn = Create("TextButton", {
    Size = UDim2.new(0, 46, 0, 46),
    Position = UDim2.new(1, -50, 0, 3),
    BackgroundTransparency = 1,
    Text = "✕",
    TextColor3 = Theme.TextDim,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    Parent = Header
})
CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, AnimInfo.Fast, {TextColor3 = Theme.Red}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, AnimInfo.Fast, {TextColor3 = Theme.TextDim}):Play()
end)

-- ФУТЕР
local Footer = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 1, -30),
    BackgroundColor3 = Theme.Footer,
    BorderSizePixel = 0,
    Parent = MainFrame
})
AddCorner(Footer, 14)
Create("Frame", {Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Theme.Footer, BorderSizePixel = 0, Parent = Footer})

Create("TextLabel", {
    Size = UDim2.new(1, -90, 1, 0),
    Position = UDim2.new(0, 14, 0, 0),
    BackgroundTransparency = 1,
    Text = "ПКМ CTRL — полёт • Y — зомби • P — детонатор • L — активатор • CTRL+ЛКМ — телепорт",
    TextColor3 = Theme.TextDim,
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Footer
})

Create("TextLabel", {
    Size = UDim2.new(0, 80, 1, 0),
    Position = UDim2.new(1, -90, 0, 0),
    BackgroundTransparency = 1,
    Text = SCRIPT_VERSION .. " PREMIUM",
    TextColor3 = Theme.Accent,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Right,
    Parent = Footer
})

-- БОКОВАЯ ПАНЕЛЬ
local Sidebar = Create("Frame", {
    Size = UDim2.new(0, 195, 1, -52 - 30),
    Position = UDim2.new(0, 0, 0, 52),
    BackgroundColor3 = Theme.Sidebar,
    BorderSizePixel = 0,
    Parent = MainFrame
})

Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 28),
    Position = UDim2.new(0, 14, 0, 8),
    BackgroundTransparency = 1,
    Text = "ВКЛАДКИ",
    TextColor3 = Theme.TextDim,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Sidebar
})

local TabHolder = Create("Frame", {
    Size = UDim2.new(1, 0, 1, -44),
    Position = UDim2.new(0, 0, 0, 44),
    BackgroundTransparency = 1,
    Parent = Sidebar
})

Create("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    Parent = TabHolder
})

local PageContainer = Create("Frame", {
    Size = UDim2.new(1, -195 - 24, 1, -52 - 30 - 20),
    Position = UDim2.new(0, 195 + 12, 0, 52 + 10),
    BackgroundTransparency = 1,
    Parent = MainFrame
})

-- ==========================================
-- СИСТЕМА ВКЛАДОК (AutomaticCanvasSize — быстрая прокрутка)
-- ==========================================
local Tabs = {}
local Pages = {}
local SelectTab

local function CreateTab(icon, name)
    local tabIndex = #Tabs + 1

    local TabBtn = Create("TextButton", {
        Size = UDim2.new(1, -16, 0, 46),
        BackgroundColor3 = Theme.TabUnselected,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = tabIndex,
        BorderSizePixel = 0,
        Parent = TabHolder
    })
    AddCorner(TabBtn, 10)
    local tabStroke = AddStroke(TabBtn, Theme.Outline, 1)

    local Icon = Create("TextLabel", {
        Size = UDim2.new(0, 34, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = icon,
        TextColor3 = Theme.TextDim,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = TabBtn
    })

    local Label = Create("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 44, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Theme.TextDim,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TabBtn
    })

    local Page = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 5,
        ScrollBarImageColor3 = Theme.Accent,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ElasticBehavior = Enum.ElasticBehavior.Never,
        Visible = false,
        Parent = PageContainer
    })
    Create("UIListLayout", {Padding = UDim.new(0, 8), HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Parent = Page})

    table.insert(Tabs, {Btn = TabBtn, Icon = Icon, Label = Label, Stroke = tabStroke})
    table.insert(Pages, Page)

    TabBtn.MouseButton1Click:Connect(function()
        SelectTab(tabIndex)
    end)

    TabBtn.MouseEnter:Connect(function()
        if not Page.Visible then
            TweenService:Create(TabBtn, AnimInfo.Fast, {BackgroundColor3 = Theme.ElementHover}):Play()
        end
    end)
    TabBtn.MouseLeave:Connect(function()
        if not Page.Visible then
            TweenService:Create(TabBtn, AnimInfo.Fast, {BackgroundColor3 = Theme.TabUnselected}):Play()
        end
    end)

    return Page
end

SelectTab = function(index)
    for i, t in ipairs(Tabs) do
        local active = (i == index)
        TweenService:Create(t.Btn, AnimInfo.Fast, {BackgroundColor3 = active and Theme.TabSelected or Theme.TabUnselected}):Play()
        TweenService:Create(t.Label, AnimInfo.Fast, {TextColor3 = active and Color3.fromRGB(255, 255, 255) or Theme.TextDim}):Play()
        TweenService:Create(t.Icon, AnimInfo.Fast, {TextColor3 = active and Color3.fromRGB(255, 255, 255) or Theme.TextDim}):Play()
        TweenService:Create(t.Stroke, AnimInfo.Fast, {Color = active and Theme.Accent or Theme.Outline}):Play()
        Pages[i].Visible = active
        if active then
            task.spawn(function()
                pcall(function() Pages[i].CanvasPosition = Vector2.new(0, 0) end)
            end)
        end
    end
end

local PageAuto = CreateTab("🚗", "АВТО")
local PageItems = CreateTab("📦", "ПРЕДМЕТЫ")
local PageSpawner = CreateTab("➕", "СПАВНЕР")
local PagePlayers = CreateTab("👤", "ИГРОКИ")
local PageTeleport = CreateTab("🌌", "ТЕЛЕПОРТ")
local PageSettings = CreateTab("⚙️", "НАСТРОЙКИ")

SelectTab(1)

-- ==========================================
-- КНОПКА-ГАМБУРГЕР: стили, прилипание, перетаскивание
-- ==========================================
local ButtonStyle = "round"

local function SnapButton()
    local size = OpenBtn.AbsoluteSize
    local anchors
    if ButtonStyle == "flat" then
        anchors = {
            UDim2.new(0.5, -size.X / 2, 0, 16),
            UDim2.new(0.5, -size.X / 2, 1, -size.Y - 16)
        }
    else
        anchors = {
            UDim2.new(0, 16, 0, 16), UDim2.new(1, -size.X - 16, 0, 16),
            UDim2.new(0, 16, 1, -size.Y - 16), UDim2.new(1, -size.X - 16, 1, -size.Y - 16),
            UDim2.new(0.5, -size.X / 2, 0, 16), UDim2.new(0.5, -size.X / 2, 1, -size.Y - 16),
            UDim2.new(0, 16, 0.5, -size.Y / 2), UDim2.new(1, -size.X - 16, 0.5, -size.Y / 2)
        }
    end
    local viewport = Workspace.CurrentCamera.ViewportSize
    local center = OpenBtn.AbsolutePosition + size / 2
    local best, bestD
    for _, a in ipairs(anchors) do
        local px = a.X.Scale * viewport.X + a.X.Offset + size.X / 2
        local py = a.Y.Scale * viewport.Y + a.Y.Offset + size.Y / 2
        local d = (Vector2.new(px, py) - center).Magnitude
        if not best or d < bestD then best, bestD = a, d end
    end
    TweenService:Create(OpenBtn, AnimInfo.Bounce, {Position = best}):Play()
end

local function SetButtonStyle(style)
    ButtonStyle = style
    if style == "round" then
        OpenBtn.Size = UDim2.new(0, 56, 0, 56)
        openBtnCorner.CornerRadius = UDim.new(0, 28)
        local ys = {20, 27, 34}
        for i, s in ipairs(stripes) do
            s.Size = UDim2.new(0, 24, 0, 3)
            s.Position = UDim2.new(0.5, -12, 0, ys[i])
        end
    else
        OpenBtn.Size = UDim2.new(0, 120, 0, 46)
        openBtnCorner.CornerRadius = UDim.new(0, 23)
        local ys = {15, 22, 29}
        for i, s in ipairs(stripes) do
            s.Size = UDim2.new(0, 22, 0, 3)
            s.Position = UDim2.new(0.5, -11, 0, ys[i])
        end
    end
    SnapButton()
end

local function RestorePanelTransparency()
    MainFrame.BackgroundTransparency = MainBaseTransparency
    Header.BackgroundTransparency = PanelBaseTransparency
    Sidebar.BackgroundTransparency = PanelBaseTransparency
    Footer.BackgroundTransparency = PanelBaseTransparency
end

local savedTransparencies = {}
local savedTextTransparencies = {}

local function OpenMenu()
    OpenBtn.Visible = false
    MainFrame.Visible = true
    MainScale.Scale = 0.88
    RestorePanelTransparency()
    RestoreAllHighlights()
    for _, obj in ipairs(MainFrame:GetDescendants()) do
        if obj:IsA("GuiObject") then
            local saved = savedTransparencies[obj]
            if saved ~= nil then obj.BackgroundTransparency = saved end
        end
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            local t = savedTextTransparencies[obj]
            obj.TextTransparency = t or 0
        end
    end
    savedTransparencies = {}
    savedTextTransparencies = {}
    TweenService:Create(MainScale, AnimInfo.Bounce, {Scale = 1}):Play()
end

local function CloseMenu()
    ClearAllHighlights()
    for _, obj in ipairs(MainFrame:GetDescendants()) do
        if obj:IsA("GuiObject") then
            savedTransparencies[obj] = obj.BackgroundTransparency
            obj.BackgroundTransparency = 1
        end
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            savedTextTransparencies[obj] = obj.TextTransparency
            obj.TextTransparency = 1
        end
    end
    TweenService:Create(MainScale, AnimInfo.Smooth, {Scale = 0.8}):Play()
    task.wait(0.3)
    MainFrame.Visible = false
    OpenBtn.Visible = true
end

CloseBtn.MouseButton1Click:Connect(CloseMenu)

-- Перетаскивание гамбургера: перетащил — прилип, кликнул — открыть
local btnDragging = false
local btnDragStart = nil
local btnStartPos = nil
local btnMoved = false

OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = true
        btnMoved = false
        btnDragStart = input.Position
        btnStartPos = OpenBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                btnDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - btnDragStart
        if delta.Magnitude > 4 then btnMoved = true end
        OpenBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
    end
end)

OpenBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if btnMoved then
            SnapButton()
        else
            OpenMenu()
        end
    end
end)

-- Перетаскивание окна за шапку
local draggingWindow = false
local dragStartPos = nil
local windowStartPos = nil

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingWindow = true
        dragStartPos = input.Position
        windowStartPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingWindow = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingWindow and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartPos
        MainFrame.Position = UDim2.new(
            windowStartPos.X.Scale, windowStartPos.X.Offset + delta.X,
            windowStartPos.Y.Scale, windowStartPos.Y.Offset + delta.Y
        )
    end
end)

-- Ресайз окна
local Resizer = Create("TextButton", {
    Size = UDim2.new(0, 25, 0, 25), Position = UDim2.new(1, -25, 1, -25), BackgroundTransparency = 1,
    Text = "◢", TextColor3 = Theme.TextDim, Font = Enum.Font.Gotham, TextSize = 16, Parent = MainFrame
})
local isResizing = false
Resizer.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = true end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = false end end)
UserInputService.InputChanged:Connect(function(input)
    if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local minW, minH = 780, 500
        local w = math.clamp(input.Position.X - MainFrame.AbsolutePosition.X + 12, minW, 1500)
        local h = math.clamp(input.Position.Y - MainFrame.AbsolutePosition.Y + 12, minH, 950)
        MainFrame.Size = UDim2.new(0, w, 0, h)
    end
end)

-- ==========================================
-- УНИВЕРСАЛЬНЫЕ БЭКЕНД ФУНКЦИИ (ИЗ DMM.TXT — СОХРАНЕНО)
-- ==========================================
local function TryFire(eventName, ...)
    local args = {...}
    pcall(function()
        for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
            if obj.Name:lower() == eventName:lower() then
                if obj:IsA("RemoteEvent") then obj:FireServer(unpack(args))
                elseif obj:IsA("RemoteFunction") then obj:InvokeServer(unpack(args)) end
            end
        end
    end)
end

local function FireToggle(targetObj)
    pcall(function()
        if not targetObj then return end
        for _, child in pairs(targetObj:GetDescendants()) do
            if child:IsA("ProximityPrompt") then
                child.MaxActivationDistance = math.huge
                child.RequiresLineOfSight = false
                fireproximityprompt(child)
            elseif child:IsA("ClickDetector") then
                child.MaxActivationDistance = math.huge
                fireclickdetector(child)
            end
        end
        local toggleEvent = ReplicatedStorage:FindFirstChild("toggle", true)
        if toggleEvent then
            if toggleEvent:IsA("RemoteEvent") then
                toggleEvent:FireServer(targetObj, true); toggleEvent:FireServer(targetObj, 1); toggleEvent:FireServer(targetObj)
            elseif toggleEvent:IsA("RemoteFunction") then
                toggleEvent:InvokeServer(targetObj, true); toggleEvent:InvokeServer(targetObj, 1); toggleEvent:InvokeServer(targetObj)
            end
        else
            TryFire("toggle", targetObj, true)
        end
    end)
end

-- Реестр bool-значений для перевода их подписей при смене языка
local valButtons = {}

-- ИСПРАВЛЕННАЯ ФУНКЦИЯ ДЛЯ ЗНАЧЕНИЙ (цвета через атрибуты, фикс чёрных кнопок)
local function Val(parent, v, name)
    if v:IsA("BoolValue") then
        local startColor = v.Value and Theme.Green or Theme.Red
        local hoverColor = v.Value and Theme.GreenHover or Theme.RedHover

        local b = CreateButtonEx(parent, name .. (v.Value and T(": ВКЛ") or T(": ВЫКЛ")), startColor, hoverColor, function(btn)
            v.Value = not v.Value
        end)
        table.insert(valButtons, {btn = b, name = name, valueObj = v})

        v.Changed:Connect(function(x)
            local newBase = x and Theme.Green or Theme.Red
            local newHover = x and Theme.GreenHover or Theme.RedHover

            b:SetAttribute("BaseColor", newBase)
            b:SetAttribute("HoverColor", newHover)
            TweenService:Create(b, AnimInfo.Fast, {BackgroundColor3 = newBase}):Play()
            b.Text = name .. (x and T(": ВКЛ") or T(": ВЫКЛ"))
        end)

    elseif v:IsA("NumberValue") or v:IsA("IntValue") or v:IsA("StringValue") then
        local r = Create("Frame", {Size = UDim2.new(0.98, 0, 0, 36), BackgroundColor3 = Theme.ElementBg, BorderSizePixel = 0, Parent = parent})
        AddCorner(r, 8)
        AddStroke(r, Theme.Outline, 1)

        Create("TextLabel", {Size = UDim2.new(0.5, -5, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = name .. ":", TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = r})

        local tb = Create("TextBox", {Size = UDim2.new(0.45, 0, 0, 24), Position = UDim2.new(0.5, 0, 0, 6), BackgroundColor3 = Theme.DeepBg, TextColor3 = Theme.Accent, Text = tostring(v.Value), Font = Enum.Font.Gotham, TextSize = 12, ClearTextOnFocus = false, Parent = r})
        AddCorner(tb, 6)
        AddStroke(tb, Theme.Outline, 1)

        tb.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                if v:IsA("StringValue") then v.Value = tb.Text
                else v.Value = tonumber(tb.Text) or v.Value end
            end
        end)
        v.Changed:Connect(function(x)
            if not tb:IsFocused() then tb.Text = tostring(x) end
        end)
    end
end

-- ==========================================
-- ВКЛАДКА "ТЕЛЕПОРТ"
-- ==========================================
local tpCtrlEnabled = false
CreateToggle(PageTeleport, "Телепорт по клику (Зажать Ctrl + Левый Клик мышкой)", false, function(val)
    tpCtrlEnabled = val
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and tpCtrlEnabled then
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Mouse.Hit then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end
    end
end)

local StatLabel = Create("TextLabel", {
    Size = UDim2.new(0.98, 0, 0, 30), BackgroundTransparency = 1, Text = T("ОЖИДАНИЕ ДАННЫХ..."), TextColor3 = Theme.Green, Font = Enum.Font.GothamBold, TextSize = 14, Parent = PageTeleport
})

local tpLayoutCont = Create("Frame", {Size = UDim2.new(1, 0, 1, -88), BackgroundTransparency = 1, Parent = PageTeleport})
local tpLayoutLeft = Create("ScrollingFrame", {Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent, AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, ElasticBehavior = Enum.ElasticBehavior.Never, Parent = tpLayoutCont})
local tpLayoutRight = Create("ScrollingFrame", {Size = UDim2.new(0.48, 0, 1, 0), Position = UDim2.new(0.52, 0, 0, 0), BackgroundTransparency = 1, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent, AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, ElasticBehavior = Enum.ElasticBehavior.Never, Parent = tpLayoutCont})

Create("UIListLayout", {Padding = UDim.new(0, 6), Parent = tpLayoutLeft})
Create("UIListLayout", {Padding = UDim.new(0, 6), Parent = tpLayoutRight})

local targetTpPlayer = nil
local TpTargetBtn = CreateButtonEx(tpLayoutRight, T("🚀 ТЕЛЕПОРТ К ИГРОКУ"), Theme.ElementBg, Theme.ElementHover, function()
    if targetTpPlayer and targetTpPlayer.Character and targetTpPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetTpPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4)
            Notify(T("Телепорт к ") .. targetTpPlayer.Name .. T(" выполнен"), Theme.Accent)
        end
    else
        Notify(T("Сначала выбери игрока"), Theme.Red)
    end
end)
TpTargetBtn.Size = UDim2.new(1, 0, 0, 46)
TpTargetBtn.TextColor3 = Theme.Gold

local function updateTpList()
    for _, c in pairs(tpLayoutLeft:GetChildren()) do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end

    local players = Players:GetPlayers()
    StatLabel.Text = T("ИГРОКОВ НА СЕРВЕРЕ: ") .. tostring(#players)

    for _, plr in ipairs(players) do
        if plr ~= LocalPlayer then
            CreateButtonEx(tpLayoutLeft, plr.Name, Theme.ElementBg, Theme.ElementHover, function()
                targetTpPlayer = plr
                TpTargetBtn.Text = T("🚀 ТЕЛЕПОРТ К: ") .. plr.Name
            end)
        end
    end
end

CreateButtonEx(tpLayoutRight, T("🔄 ОБНОВИТЬ СПИСОК"), Theme.ElementBg, Theme.ElementHover, updateTpList)

task.spawn(function()
    while task.wait(1) do
        local plrs = Players:GetPlayers()
        StatLabel.Text = T("ИГРОКОВ НА СЕРВЕРЕ: ") .. tostring(#plrs)
    end
end)
Players.PlayerAdded:Connect(updateTpList)
Players.PlayerRemoving:Connect(updateTpList)
updateTpList()

-- ==========================================
-- ВКЛАДКА "СПАВНЕР" (каркас, заполняется позже)
-- ==========================================
local SpawnerBtn = CreateButtonEx(PageSpawner, "🛠 СПАВНЕР ПРЕДМЕТОВ (скоро)", Theme.Accent, Theme.AccentHover, function() end)
SpawnerBtn.Size = UDim2.new(0.98, 0, 0, 46)
Create("TextLabel", {
    Size = UDim2.new(0.98, 0, 0, 80), BackgroundTransparency = 1,
    Text = "Здесь будет спавнер предметов.\nПока пусто — заготовка на будущее.",
    TextColor3 = Theme.TextDim, Font = Enum.Font.Gotham, TextSize = 13,
    TextWrapped = true, Parent = PageSpawner
})

-- ==========================================
-- ВКЛАДКА "АВТО" (кнопка наверху, таблицы на всю высоту)
-- ==========================================
local FindCarsBtn = CreateButtonEx(PageAuto, T("🔍 НАЙТИ МАШИНЫ В МИРЕ"), Theme.Accent, Theme.AccentHover, function() end)
FindCarsBtn.LayoutOrder = 1
FindCarsBtn.Size = UDim2.new(0.98, 0, 0, 46)
FindCarsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local AutoLayoutCont = Create("Frame", {Size = UDim2.new(1, 0, 1, -62), BackgroundTransparency = 1, LayoutOrder = 2, Parent = PageAuto})
local cL = Create("ScrollingFrame", {Size = UDim2.new(0.35, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent, AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, ElasticBehavior = Enum.ElasticBehavior.Never, Parent = AutoLayoutCont})
local cT = Create("ScrollingFrame", {Size = UDim2.new(0.63, 0, 1, 0), Position = UDim2.new(0.37, 0, 0, 0), BackgroundTransparency = 1, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent, AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, ElasticBehavior = Enum.ElasticBehavior.Never, Parent = AutoLayoutCont})

Create("UIListLayout", {Padding = UDim.new(0, 6), Parent = cL})
Create("UIListLayout", {Padding = UDim.new(0, 6), Parent = cT})

local sCar = nil
local cBts = {}
local sCarHL = nil

local function applyHighlight(target, color)
    SelectedTargets = {}
    ClearAllHighlights()
    if target then
        if target:FindFirstChildOfClass("Highlight") then
            return nil
        end
        local hl = Instance.new("Highlight")
        hl.Name = "EditorESP"
        hl.FillColor = color
        hl.OutlineColor = Color3.new(1, 1, 1)
        hl.FillTransparency = 0.5
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = target
        table.insert(HighlightRegistry, hl)
        table.insert(SelectedTargets, {target, color})
        return hl
    end
    return nil
end

FindCarsBtn.MouseButton1Click:Connect(function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
            local n = obj.Name:lower()
            if (n:match("car") or n:match("van") or n:match("bus") or n:match("buggy") or n:match("moped") or n:match("2105") or n:match("2109") or n:match("машина") or n:match("lada") or obj:FindFirstChild("Wheels") or obj:FindFirstChild("wheels")) and not cBts[obj] then

                cBts[obj] = CreateButtonEx(cL, obj.Name, Theme.ElementBg, Theme.ElementHover, function()
                    sCar = (sCar == obj) and nil or obj
                    sCarHL = applyHighlight(sCar, Theme.Accent)

                    for _, c in pairs(cT:GetChildren()) do
                        if not c:IsA("UIListLayout") then c:Destroy() end
                    end

                    if sCar then
                        Notify(T("Выбрана машина: ") .. obj.Name, Theme.Accent)

                        local vals = sCar:FindFirstChild("Values") or sCar:FindFirstChild("values")
                        if vals then
                            Create("TextLabel", {Size = UDim2.new(0.98, 0, 0, 24), BackgroundTransparency = 1, Text = T(" ЗНАЧЕНИЯ (VALUES)"), TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = cT})
                            for _, v in pairs(vals:GetDescendants()) do
                                if v:IsA("ValueBase") then Val(cT, v, v.Name) end
                            end
                        end

                        Create("TextLabel", {Size = UDim2.new(0.98, 0, 0, 24), BackgroundTransparency = 1, Text = T(" ФИЗИКА КОЛЁС"), TextColor3 = Theme.Green, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = cT})

                        local function updateWheelPhysics(prop, value)
                            if not sCar then return end
                            local wheels = sCar:FindFirstChild("Wheels") or sCar:FindFirstChild("wheels")
                            if wheels then
                                for _, w in pairs(wheels:GetChildren()) do
                                    if w:IsA("BasePart") then
                                        local currentPhys = w.CustomPhysicalProperties or PhysicalProperties.new(w.Material)
                                        local d, f, e, fw, ew = currentPhys.Density, currentPhys.Friction, currentPhys.Elasticity, currentPhys.FrictionWeight, currentPhys.ElasticityWeight
                                        if prop == "Density" then d = value
                                        elseif prop == "Friction" then f = value
                                        elseif prop == "Elasticity" then e = value
                                        elseif prop == "FrictionWeight" then fw = value
                                        elseif prop == "ElasticityWeight" then ew = value
                                        end
                                        w.CustomPhysicalProperties = PhysicalProperties.new(d, f, e, fw, ew)
                                    end
                                end
                            end
                        end

                        Slider(cT, "Трение (Friction)", 0, 10, 0.1, 1, function(v) updateWheelPhysics("Friction", v) end)
                        Slider(cT, "Плотность (Density)", 0, 10, 0.1, 0.1, function(v) updateWheelPhysics("Density", v) end)
                        Slider(cT, "Упругость (Elasticity)", 0, 1, 0.05, 0.5, function(v) updateWheelPhysics("Elasticity", v) end)
                        Slider(cT, "Вес трения (F. Weight)", 0, 100, 1, 1, function(v) updateWheelPhysics("FrictionWeight", v) end)
                        Slider(cT, "Вес упруг. (E. Weight)", 0, 100, 1, 1, function(v) updateWheelPhysics("ElasticityWeight", v) end)

                        Create("TextLabel", {Size = UDim2.new(0.98, 0, 0, 24), BackgroundTransparency = 1, Text = T(" ПОДВЕСКА"), TextColor3 = Theme.Gold, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = cT})

                        local suspTarget = "all"
                        local stFrame = Create("Frame", {Size = UDim2.new(0.98, 0, 0, 28), BackgroundTransparency = 1, Parent = cT})
                        local btnsSt = {
                            {t = "all", n = "Все"}, {t = "front", n = "Пер"}, {t = "rear", n = "Зад"}, {t = "fl", n = "ПЛ"}, {t = "fr", n = "ПП"}, {t = "rl", n = "ЗЛ"}, {t = "rr", n = "ЗП"}
                        }

                        local swidth = 1 / #btnsSt
                        local stBtnRefs = {}

                        for i, inf in ipairs(btnsSt) do
                            local b = Create("TextButton", {
                                Size = UDim2.new(swidth - 0.02, 0, 1, 0), Position = UDim2.new((i - 1) * swidth, 0, 0, 0),
                                Text = T(inf.n), BackgroundColor3 = (inf.t == "all" and Theme.Accent or Theme.ElementBg),
                                TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.Gotham, TextSize = 11, BorderSizePixel = 0, Parent = stFrame
                            })
                            AddCorner(b, 6)
                            b.MouseButton1Click:Connect(function()
                                suspTarget = inf.t
                                for refT, refB in pairs(stBtnRefs) do
                                    TweenService:Create(refB, AnimInfo.Fast, {BackgroundColor3 = (refT == inf.t and Theme.Accent or Theme.ElementBg)}):Play()
                                end
                            end)
                            stBtnRefs[inf.t] = b
                        end

                        Slider(cT, "Высота", 2.4, 4.5, 0.1, 3.45, function(val)
                            if not sCar then return end
                            for _, obj2 in pairs(sCar:GetDescendants()) do
                                if obj2:IsA("SpringConstraint") or obj2:IsA("PrismaticConstraint") then
                                    local n1 = obj2.Name:lower()
                                    local n2 = obj2.Parent and obj2.Parent.Name:lower() or ""
                                    local n3 = (obj2:IsA("Constraint") and obj2.Attachment0 and obj2.Attachment0.Parent) and obj2.Attachment0.Parent.Name:lower() or ""
                                    local n4 = (obj2:IsA("Constraint") and obj2.Attachment1 and obj2.Attachment1.Parent) and obj2.Attachment1.Parent.Name:lower() or ""

                                    local isF, isR, isFL, isFR, isRL, isRR = false, false, false, false, false, false
                                    for _, nm in ipairs({n1, n2, n3, n4}) do
                                        if nm == "fl" or nm == "f_l" or nm:match("frontleft") then isF, isFL = true, true end
                                        if nm == "fr" or nm == "f_r" or nm:match("frontright") then isF, isFR = true, true end
                                        if nm == "rl" or nm == "r_l" or nm:match("rearleft") then isR, isRL = true, true end
                                        if nm == "rr" or nm == "r_r" or nm:match("rearright") then isR, isRR = true, true end
                                        if nm:match("front") or nm:match("^f$") or nm:match("fwheel") then isF = true end
                                        if nm:match("rear") or nm:match("back") or nm:match("^r$") or nm:match("rwheel") then isR = true end
                                    end

                                    local apply = (suspTarget == "all") or (suspTarget == "front" and isF) or (suspTarget == "rear" and isR) or (suspTarget == "fl" and isFL) or (suspTarget == "fr" and isFR) or (suspTarget == "rl" and isRL) or (suspTarget == "rr" and isRR)

                                    if apply then
                                        if obj2:IsA("SpringConstraint") then obj2.FreeLength = math.abs(val)
                                        elseif obj2:IsA("PrismaticConstraint") then obj2.TargetPosition = val end
                                    end
                                end
                            end
                        end)
                    end

                    for x, b in pairs(cBts) do
                        if x.Parent then
                            if x == sCar then TweenService:Create(b, AnimInfo.Fast, {BackgroundColor3 = Theme.Accent}):Play()
                            else TweenService:Create(b, AnimInfo.Fast, {BackgroundColor3 = Theme.ElementBg}):Play() end
                        else
                            b:Destroy(); cBts[x] = nil
                        end
                    end
                end)
            end
        end
    end
    Notify(T("Сканирование мира завершено"), Theme.Green)
end)

-- ==========================================
-- ВКЛАДКА "ЛУТ" (кнопка наверху, таблицы на всю высоту)
-- ==========================================
local FindItemsBtn = CreateButtonEx(PageItems, T("🔍 НАЙТИ ПРЕДМЕТЫ И МОТОРЫ"), Theme.Accent, Theme.AccentHover, function() end)
FindItemsBtn.LayoutOrder = 1
FindItemsBtn.Size = UDim2.new(0.98, 0, 0, 46)
FindItemsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local ItemsLayoutCont = Create("Frame", {Size = UDim2.new(1, 0, 1, -62), BackgroundTransparency = 1, LayoutOrder = 2, Parent = PageItems})
local iL = Create("ScrollingFrame", {Size = UDim2.new(0.35, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent, AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, ElasticBehavior = Enum.ElasticBehavior.Never, Parent = ItemsLayoutCont})
local iT = Create("ScrollingFrame", {Size = UDim2.new(0.63, 0, 1, 0), Position = UDim2.new(0.37, 0, 0, 0), BackgroundTransparency = 1, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent, AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, ElasticBehavior = Enum.ElasticBehavior.Never, Parent = ItemsLayoutCont})

Create("UIListLayout", {Padding = UDim.new(0, 6), Parent = iL})
Create("UIListLayout", {Padding = UDim.new(0, 6), Parent = iT})

local sIt = nil
local iBts = {}
local sItHL = nil

FindItemsBtn.MouseButton1Click:Connect(function()
    for _, o in pairs(Workspace:GetDescendants()) do
        local n = o.Name:lower()
        local isSound = o:IsA("Sound") or o:IsA("AudioPlayer") or n:match("sound") or n:match("audio")
        local isEngine = n:match("engine")
        local isItem = o:IsA("Model") and (o:FindFirstChild("chance") or o:FindFirstChild("id") or o:FindFirstChild("Values") or o:FindFirstChild("values"))

        if not isSound and not iBts[o] and (isItem or (o:IsA("Model") and isEngine)) then

            iBts[o] = CreateButtonEx(iL, o.Name, Theme.ElementBg, Theme.ElementHover, function()
                sIt = (sIt == o) and nil or o
                sItHL = applyHighlight(sIt, Theme.Gold)

                for _, c in pairs(iT:GetChildren()) do
                    if not c:IsA("UIListLayout") then c:Destroy() end
                end

                if sIt then
                    Notify(T("Выбран предмет: ") .. o.Name, Theme.Gold)
                    local vals = sIt:FindFirstChild("Values") or sIt:FindFirstChild("values") or sIt
                    for _, v in pairs(vals:GetDescendants()) do
                        if v:IsA("ValueBase") then Val(iT, v, v.Name) end
                    end
                end

                for x, b in pairs(iBts) do
                    if x.Parent then
                        if x == sIt then TweenService:Create(b, AnimInfo.Fast, {BackgroundColor3 = Theme.Accent}):Play()
                        else TweenService:Create(b, AnimInfo.Fast, {BackgroundColor3 = Theme.ElementBg}):Play() end
                    else
                        b:Destroy(); iBts[x] = nil
                    end
                end
            end)
        end
    end
    Notify(T("Сканирование завершено"), Theme.Green)
end)

-- ==========================================
-- ВКЛАДКА "ИГРОКИ И ЧИТЫ" (V5: БЕЗ выбора игрока — всё сразу на себя)
-- ==========================================
local states = {}
local flyActive = false
local flySpeed = 50
local flyKeys = {W = false, A = false, S = false, D = false, Space = false, Shift = false}
local IYFlyBG, IYFlyBV = nil, nil
local detonatorActive = false
local activatorActive = false

local function getDebugUi()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then for _, gui in pairs(pg:GetChildren()) do if gui.Name:lower() == "debugui" then return gui end end end
    for _, gui in pairs(CoreGui:GetChildren()) do if gui.Name:lower() == "debugui" then return gui end end
    return nil
end

local function toggleIYFly()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if flyActive then
        flyActive = false
        Notify(T("Полёт выключен"), Theme.Red)
        if IYFlyBG then IYFlyBG:Destroy() IYFlyBG = nil end
        if IYFlyBV then IYFlyBV:Destroy() IYFlyBV = nil end
        if hum then hum.PlatformStand = false end
    else
        flyActive = true
        Notify(T("Полёт включён (ПКМ CTRL — переключить)"), Theme.Green)
        if hum then hum.PlatformStand = true end

        IYFlyBG = Instance.new("BodyGyro")
        IYFlyBG.P = 9e4
        IYFlyBG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        IYFlyBG.cframe = hrp.CFrame
        IYFlyBG.Parent = hrp

        IYFlyBV = Instance.new("BodyVelocity")
        IYFlyBV.velocity = Vector3.new(0,0,0)
        IYFlyBV.maxForce = Vector3.new(9e9, 9e9, 9e9)
        IYFlyBV.Parent = hrp

        task.spawn(function()
            while flyActive and char and char:FindFirstChild("HumanoidRootPart") do
                local cam = Workspace.CurrentCamera
                IYFlyBG.cframe = cam.CFrame

                local moveDir = Vector3.zero
                if flyKeys.W then moveDir = moveDir + cam.CFrame.LookVector end
                if flyKeys.S then moveDir = moveDir - cam.CFrame.LookVector end
                if flyKeys.A then moveDir = moveDir - cam.CFrame.RightVector end
                if flyKeys.D then moveDir = moveDir + cam.CFrame.RightVector end
                if flyKeys.Space then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if flyKeys.Shift then moveDir = moveDir - Vector3.new(0, 1, 0) end

                if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
                IYFlyBV.velocity = moveDir * flySpeed
                RunService.RenderStepped:Wait()
            end
            if IYFlyBG then IYFlyBG:Destroy() IYFlyBG = nil end
            if IYFlyBV then IYFlyBV:Destroy() IYFlyBV = nil end
            if hum then hum.PlatformStand = false end
        end)
    end
end

Create("TextLabel", {Size = UDim2.new(0.98, 0, 0, 26), BackgroundTransparency = 1, Text = T(" ЧИТЫ"), TextColor3 = Theme.Green, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = PagePlayers})

local function PlayerToggle(text, remoteName, stateKey, callback)
    local st = states[stateKey] or false
    CreateToggle(PagePlayers, text, st, function(newState)
        states[stateKey] = newState
        if callback then callback(newState) end
        if remoteName then task.spawn(function() TryFire(remoteName, LocalPlayer, newState) end) end
    end)
end

PlayerToggle("Нет голода", "nohunger", "nohunger")
PlayerToggle("Нет стамины", "nostamina", "nostamina")
PlayerToggle("Нет регдолла", "noragdoll", "noragdoll")
PlayerToggle("Бессмертие", "godmode", "godmode")
PlayerToggle("Бессмертие машины", "godcar", "godcar")

CreateButtonEx(PagePlayers, "📂 ОКНО (скоро)", Theme.ElementBg, Theme.ElementHover, function()
    Notify("Окно игроков — в разработке", Theme.Gold)
end)

Create("TextLabel", {Size = UDim2.new(0.98, 0, 0, 24), BackgroundTransparency = 1, Text = T(" ПОЛЕТ (БЕЗ ГРАВИТАЦИИ): ПРАВЫЙ CTRL"), TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = PagePlayers})

PlayerToggle("Удалятор (debugui)", nil, "deleter", function(state)
    local dbg = getDebugUi()
    if dbg then
        if dbg:IsA("ScreenGui") then dbg.Enabled = state
        elseif dbg:IsA("GuiObject") then dbg.Visible = state end
    end
end)

local curFov = math.clamp(math.floor(Workspace.CurrentCamera.FieldOfView), 60, 120)
Slider(PagePlayers, "Угол обзора (FOV)", 60, 120, 1, curFov, function(val) Workspace.CurrentCamera.FieldOfView = val end)

PlayerToggle("Детонатор (Кнопка P)", nil, "detonator", function(state) detonatorActive = state end)
PlayerToggle("Активатор (Кнопка L)", nil, "activator", function(state) activatorActive = state end)
PlayerToggle("Спавн зомби (Зажатие Y)", nil, "spawnzombie", function() end)

-- ==========================================
-- ВВОД КЛАВИШ (ПОЛЕТ И ДЕТОНАТОРЫ — СОХРАНЕНО)
-- ==========================================
local isYDown = false
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then flyKeys.W = true end
    if input.KeyCode == Enum.KeyCode.A then flyKeys.A = true end
    if input.KeyCode == Enum.KeyCode.S then flyKeys.S = true end
    if input.KeyCode == Enum.KeyCode.D then flyKeys.D = true end
    if input.KeyCode == Enum.KeyCode.Space then flyKeys.Space = true end
    if input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Shift = true end
    if input.KeyCode == Enum.KeyCode.RightControl then toggleIYFly() end

    if input.KeyCode == Enum.KeyCode.Y then
        if states.spawnzombie then
            isYDown = true
            task.spawn(function()
                while isYDown do
                    pcall(function()
                        local Event = ReplicatedStorage:FindFirstChild("sandboxconnection") and ReplicatedStorage.sandboxconnection:FindFirstChild("spawnzombie")
                        if Event then
                            if Event:IsA("RemoteFunction") then Event:InvokeServer()
                            elseif Event:IsA("RemoteEvent") then Event:FireServer() end
                        end
                    end)
                    task.wait()
                end
            end)
        end
    elseif input.KeyCode == Enum.KeyCode.P and detonatorActive then
        task.spawn(function()
            for _, obj in pairs(game:GetDescendants()) do
                local n = obj.Name
                if n == "tnt" or n == "bomb" then
                    local part = obj:FindFirstChild("Part")
                    if part then FireToggle(part) end
                elseif n == "firework" then
                    local model = obj:FindFirstChild("Model") or obj:FindFirstChild("model")
                    if model then
                        local main = model:FindFirstChild("main")
                        if main then FireToggle(main) end
                    end
                elseif n == "Gift1" or n == "Gift2" or n == "Gift3" then
                    local ma = obj:FindFirstChild("ma")
                    if ma then FireToggle(ma) end
                end
            end
        end)
    elseif input.KeyCode == Enum.KeyCode.L and activatorActive then
        task.spawn(function()
            for _, obj in pairs(game:GetDescendants()) do
                if obj.Name == "turbine" then
                    local trust = obj:FindFirstChild("TRUST")
                    if trust then FireToggle(trust) end
                end
            end
        end)
    end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.Y then isYDown = false end
    if input.KeyCode == Enum.KeyCode.W then flyKeys.W = false end
    if input.KeyCode == Enum.KeyCode.A then flyKeys.A = false end
    if input.KeyCode == Enum.KeyCode.S then flyKeys.S = false end
    if input.KeyCode == Enum.KeyCode.D then flyKeys.D = false end
    if input.KeyCode == Enum.KeyCode.Space then flyKeys.Space = false end
    if input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Shift = false end
end)

-- ==========================================
-- ПРИМЕНЕНИЕ ТЕМЫ / ЯЗЫКА
-- ==========================================
local hotkeyCardLabel = nil

local function RefreshValButtons()
    for _, e in ipairs(valButtons) do
        e.btn.Text = e.name .. (e.valueObj.Value and T(": ВКЛ") or T(": ВЫКЛ"))
    end
end

local function RefreshSliders()
    for _, e in ipairs(sliderRegistry) do
        e.label.Text = T(e.baseKey) .. ": " .. tostring(e.getVal())
    end
end

local function RefreshHotkeys()
    if not hotkeyCardLabel then return end
    hotkeyCardLabel.Text = table.concat({
        T("• Правый CTRL — вкл/выкл полёт (WASD + Space/Shift)"),
        T("• CTRL + Левый Клик — телепорт (вкл. во вкладке ТЕЛЕПОРТ)"),
        T("• Y (зажать) — спавн зомби (вкл. в ИГРОКАХ)"),
        T("• P — детонатор: активирует tnt/bomb/firework/подарки"),
        T("• L — активатор: запускает турбины (TRUST)"),
        T("• Кнопка меню (3 полоски) — открыть меню после закрытия"),
        "",
        T("Все функции доступны сразу во вкладке ИГРОКИ.")
    }, "\n")
end

local function ApplyTheme(name)
    local pal = Palettes[name] or Palettes.black
    local directMap = {
        [MainFrame] = pal.Background,
        [Header] = pal.Header,
        [Sidebar] = pal.Sidebar,
        [Footer] = pal.Footer,
        [OpenBtn] = pal.Accent
    }
    for _, obj in ipairs(ScreenGui:GetDescendants()) do
        if obj:IsA("GuiObject") then
            if directMap[obj] ~= nil then
                obj.BackgroundColor3 = directMap[obj]
            end
            local bgKey = obj:GetAttribute("BgKey")
            if bgKey and pal[bgKey] then
                obj.BackgroundColor3 = pal[bgKey]
            end
            local txtKey = obj:GetAttribute("TextKey")
            if txtKey and pal[txtKey] then
                obj.TextColor3 = pal[txtKey]
            end
            local baseKeyA = obj:GetAttribute("BaseKey")
            if baseKeyA and pal[baseKeyA] then
                obj:SetAttribute("BaseColor", pal[baseKeyA])
                obj.BackgroundColor3 = pal[baseKeyA]
            end
            local hoverKeyA = obj:GetAttribute("HoverKey")
            if hoverKeyA and pal[hoverKeyA] then
                obj:SetAttribute("HoverColor", pal[hoverKeyA])
            end
        elseif obj:IsA("UIStroke") then
            local strokeKey = obj:GetAttribute("StrokeKey")
            if strokeKey and pal[strokeKey] then
                obj.Color = pal[strokeKey]
            end
        end
    end
    Theme = pal
    CurrentTheme = name
    local glass = (name == "transparent")
    MainBaseTransparency = glass and 0.3 or 0
    PanelBaseTransparency = glass and 0.15 or 0
    if MainFrame.Visible then
        RestorePanelTransparency()
    end
end

local function ApplyLanguage(lang)
    curLang = lang
    for _, obj in ipairs(ScreenGui:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            local src = obj:GetAttribute("SrcText")
            if src then
                local tr = I18N[lang] and I18N[lang][src]
                obj.Text = tr or src
            end
        end
    end
    StatLabel.Text = T("ИГРОКОВ НА СЕРВЕРЕ: ") .. tostring(#Players:GetPlayers())
    if targetTpPlayer then
        TpTargetBtn.Text = T("🚀 ТЕЛЕПОРТ К: ") .. targetTpPlayer.Name
    else
        TpTargetBtn.Text = T("🚀 ТЕЛЕПОРТ К ИГРОКУ")
    end
    RefreshValButtons()
    RefreshSliders()
    RefreshHotkeys()
end

-- ==========================================
-- ВКЛАДКА НАСТРОЙКИ (темы / языки / кнопка меню)
-- ==========================================
CreateButtonEx(PageSettings, T("💻 ЗАПУСТИТЬ Infinite Yield (Консоль)"), Theme.ElementBg, Theme.ElementHover, function()
    pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
    Notify(T("Infinite Yield запущен"), Theme.Gold)
end)

local function BuildSelector(parent, sectionLabel, options, defaultIndex, onSelect)
    Create("TextLabel", {Size = UDim2.new(0.98, 0, 0, 22), BackgroundTransparency = 1, Text = sectionLabel, TextColor3 = Theme.TextDim, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = parent})
    local refs = {}
    for i, opt in ipairs(options) do
        local sel = (i == defaultIndex)
        local b = CreateButtonEx(parent, opt.label, sel and Theme.Accent or Theme.ElementBg, sel and Theme.AccentHover or Theme.ElementHover, function()
            for j, r in ipairs(refs) do
                local active = (j == i)
                r:SetAttribute("BaseColor", active and Theme.Accent or Theme.ElementBg)
                r:SetAttribute("HoverColor", active and Theme.AccentHover or Theme.ElementHover)
                TweenService:Create(r, AnimInfo.Fast, {BackgroundColor3 = active and Theme.Accent or Theme.ElementBg}):Play()
                TweenService:Create(r, AnimInfo.Fast, {TextColor3 = active and Color3.fromRGB(255, 255, 255) or Theme.Text}):Play()
            end
            onSelect(opt.value)
        end)
        if sel then
            b:SetAttribute("BaseColor", Theme.Accent)
            b:SetAttribute("HoverColor", Theme.AccentHover)
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        refs[i] = b
    end
    return refs
end

BuildSelector(PageSettings, "ТЕМА", {
    {label = "Чёрная", value = "black"},
    {label = "Белая", value = "white"},
    {label = "Прозрачная", value = "transparent"}
}, 1, ApplyTheme)

BuildSelector(PageSettings, "ЯЗЫК", {
    {label = "Русский", value = "ru"},
    {label = "English", value = "en"},
    {label = "Українська", value = "ua"}
}, 1, ApplyLanguage)

BuildSelector(PageSettings, "КНОПКА МЕНЮ", {
    {label = "Круглая (углы и края)", value = "round"},
    {label = "Плоская (верх и низ)", value = "flat"}
}, 1, SetButtonStyle)

-- Информационная карточка с горячими клавишами
local InfoCard = Create("Frame", {
    Size = UDim2.new(0.98, 0, 0, 190),
    BackgroundColor3 = Theme.ElementBg,
    BorderSizePixel = 0,
    Parent = PageSettings
})
AddCorner(InfoCard, 10)
AddStroke(InfoCard, Theme.Outline, 1)

Create("TextLabel", {
    Size = UDim2.new(1, -24, 0, 24),
    Position = UDim2.new(0, 12, 0, 8),
    BackgroundTransparency = 1,
    Text = T("📖 ГОРЯЧИЕ КЛАВИШИ"),
    TextColor3 = Theme.Accent,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = InfoCard
})

hotkeyCardLabel = Create("TextLabel", {
    Size = UDim2.new(1, -24, 1, -40),
    Position = UDim2.new(0, 12, 0, 34),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = Theme.TextDim,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    Parent = InfoCard
})
RefreshHotkeys()

-- ==========================================
-- ФИНАЛИЗАЦИЯ: захват исходных текстов, стиль кнопки, приветствие
-- ==========================================
local function CaptureSourceText()
    for _, obj in ipairs(ScreenGui:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            obj:SetAttribute("SrcText", obj.Text)
        end
    end
end

SetButtonStyle("round")
CaptureSourceText()
Notify("ALPHA SANDBOX ULTRA ++ " .. SCRIPT_VERSION .. T(" загружен"), Theme.Accent)
