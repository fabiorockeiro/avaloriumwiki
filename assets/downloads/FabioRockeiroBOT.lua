-- FabioRockeiroBOT
-- Arquivo unico consolidado para ZeroBot/Avalorium OT.
-- Gerado a partir do FabioUI e dos modulos legados do Fabio Rockeiro.

if not HUD then
    pcall(function() dofile("core/lib.lua") end)
end

if FabioUI and FabioUI.clear then
    pcall(function() FabioUI.clear() end)
end
FabioUI = nil

-- =========================
-- FabioUI Hub embutido
-- =========================
-- FabioUI Hub
-- Central HUD for Fabio Rockeiro scripts using only ZeroBot item HUDs.

FabioUI = FabioUI or {}

if not FabioUI.__libraryLoaded then
local UI = FabioUI
UI.__libraryLoaded = true
UI.version = "2026-06-03-premium-03"
UI.scriptDisplayName = "FabioRockeiroBOT"
UI.entryScriptName = UI.scriptDisplayName

UI.configPath = "FabioUI/fabio_ui.config.json"
UI.captures = {}
UI.modules = {}
UI.moduleState = {
    craftPage = 1,
}

UI.defaults = {
    window = {
        x = 420,
        y = 70,
        expanded = true,
        activeTab = "task",
        logoItemId = 50786,
    },
    autoParty = {
        enabled = false,
        intervalMs = 500,
        candidates = { "Jefimsz" },
    },
    fungo = {
        enabled = false,
    },
}

UI.colors = {
    title = { 255, 224, 128 },
    active = { 80, 255, 140 },
    inactive = { 255, 90, 90 },
    info = { 150, 210, 255 },
    neutral = { 220, 230, 240 },
    muted = { 155, 165, 180 },
    warning = { 255, 205, 100 },
    white = { 255, 255, 255 },
}

UI.tabs = {
    { key = "task", label = "Task", icon = 63053 },
    { key = "rune", label = "Rune", icon = 63052 },
    { key = "arrow", label = "Arrow", icon = 63050 },
    { key = "forge", label = "Forja", icon = 63054 },
    { key = "follow", label = "Follow", icon = 3079 },
    { key = "reset", label = "Reset FPS", icon = 63135 },
    { key = "craft", label = "Craft", icon = 63257 },
    { key = "fungo", label = "Pisar no Fungo", icon = 39176 },
    { key = "party", label = "Party", icon = 63680 },
}

UI.itemSkinAssets = {
    -- Fundo unico e escuro. Evita mosaico/patchwork visual.
    panelFill = 8811,
    panelSoft = 8811,

    -- Bordas sugeridas pelo Fabio para montar uma janela custom estilo mapper.
    edgeLeft = 24287,
    edgeTop = 24286,
    edgeRight = 24289,
    edgeBottom = 24288,

    -- Efeito bonito atras do icone selecionado.
    selectedGlow = 63157,

    -- Pequenos detalhes neutros. Podem ser trocados sem mexer na logica.
    rowBack = 8811,
    contentBack = 8811,
    divider = 24286,

    -- Aliases de compatibilidade usados pelos paineis modais antigos.
    shadow = 8811,
    panel = 8811,
    glass = 8811,
    tabActive = 63157,
    tabIdle = 8811,
    rail = 24286,
    accent = 50786,

    -- Mantidos como fallback para quem quiser voltar para status por sprite.
    statusOn = 37341,
    statusOff = 37338,
    statusIdle = 37340,

    -- Icone principal do script.
    logoFallback = 50786,
}

UI.layout = {
    -- Multiples of 32 keep the item-sprite border pieces connected.
    width = 640,
    height = 448,

    -- O launcher virou o icone principal do header e tambem e o ponto de arraste.
    dragOffsetX = 76,
    dragOffsetY = 42,
    headerIconX = 76,
    headerIconY = 42,
    expandedHeaderIconX = 96,
    expandedHeaderIconY = 32,
    minimizedHeaderIconY = 32,
    headerTextX = 138,
    headerTitleY = 30,
    headerSubY = 52,
    headerHintX = 330,
    headerHintY = 34,
    headerHint2Y = 52,
    logoScale = 1.42,
    minimizedLogoScale = 1.34,

    tabX = 54,
    tabGlowX = 54,
    tabTextX = 96,
    tabBadgeX = 202,
    tabY = 118,
    tabStep = 36,

    menuRightX = 256,
    contentX = 294,
    contentY = 126,
    contentLineStep = 16,

    -- Mantidos para compatibilidade, mas o rodape foi removido visualmente.
    statusY = 392,
    helpY = 410,
}

local noop = function() end

local function lower(value)
    return string.lower(tostring(value or ""))
end

local function trim(value)
    value = tostring(value or "")
    return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function shallowCopy(list)
    local copy = {}
    if type(list) ~= "table" then return copy end
    for i, value in ipairs(list) do
        copy[i] = value
    end
    return copy
end

local function copyDefaults()
    return {
        window = {
            x = UI.defaults.window.x,
            y = UI.defaults.window.y,
            expanded = UI.defaults.window.expanded,
            activeTab = UI.defaults.window.activeTab,
            logoItemId = UI.defaults.window.logoItemId,
        },
        autoParty = {
            enabled = UI.defaults.autoParty.enabled,
            intervalMs = UI.defaults.autoParty.intervalMs,
            candidates = shallowCopy(UI.defaults.autoParty.candidates),
        },
        fungo = {
            enabled = UI.defaults.fungo.enabled,
        },
    }
end

local function mergeConfig(base, loaded)
    if type(loaded) ~= "table" then return base end

    if type(loaded.window) == "table" then
        for key, value in pairs(loaded.window) do
            base.window[key] = value
        end
    end

    if type(loaded.autoParty) == "table" then
        for key, value in pairs(loaded.autoParty) do
            base.autoParty[key] = value
        end
    end

    if type(base.autoParty.candidates) ~= "table" then
        base.autoParty.candidates = shallowCopy(UI.defaults.autoParty.candidates)
    end

    if type(loaded.fungo) == "table" then
        for key, value in pairs(loaded.fungo) do
            base.fungo[key] = value
        end
    end

    return base
end

function UI.log(message)
    print("[FabioUI] " .. tostring(message))
end

function UI.showMessage(message)
    UI.log(message)
    if Client and Client.showMessage then
        Client.showMessage("[FabioUI]\n" .. tostring(message))
    end
end

function UI.safe(label, fn, ...)
    local ok, result = pcall(fn, ...)
    if not ok then
        UI.log("Erro em " .. tostring(label) .. ": " .. tostring(result))
        return nil
    end
    return result
end

function UI.readTextFile(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read("*a")
    file:close()
    return content
end

function UI.writeTextFile(path, content)
    local file = io.open(path, "w")
    if not file then return false end
    file:write(tostring(content or ""))
    file:close()
    return true
end

function UI.loadConfig()
    if not JSON then
        pcall(function() dofile("core/json.lua") end)
    end

    local config = copyDefaults()
    local raw = UI.readTextFile(UI.configPath)
    if raw and raw ~= "" and JSON and JSON.decode then
        local ok, decoded = pcall(function()
            return JSON.decode(raw)
        end)
        if ok then
            config = mergeConfig(config, decoded)
        end
    end

    UI.config = config
    return config
end

function UI.saveConfig()
    if not UI.config then return end
    if not JSON then return end

    local ok, encoded = pcall(function()
        return JSON.encode(UI.config)
    end)

    if ok and encoded then
        UI.writeTextFile(UI.configPath, encoded)
    end
end

local function methodCall(method, self, ...)
    if method then
        return method(self, ...)
    end
end

function UI.patchHud()
    if UI.__hudPatched then return end
    if not HUD or not HUD.new then
        UI.log("HUD API nao encontrada.")
        return
    end

    UI.__hudPatched = true
    UI.__hudNew = HUD.new
    UI.__hudMethods = {
        setText = HUD.setText,
        setItemId = HUD.setItemId,
        setColor = HUD.setColor,
        setFontSize = HUD.setFontSize,
        setScale = HUD.setScale,
        setOpacity = HUD.setOpacity,
        setZIndex = HUD.setZIndex,
        setPhantom = HUD.setPhantom,
        setPos = HUD.setPos,
        getPos = HUD.getPos,
        setDraggable = HUD.setDraggable,
        setCallback = HUD.setCallback,
        show = HUD.show,
        hide = HUD.hide,
        destroy = HUD.destroy,
    }

    HUD.new = function(x, y, value, newFeatures)
        local obj = UI.__hudNew(x, y, value, newFeatures)
        if UI.__captureKey then
            UI.captureHud(obj, x, y, value, newFeatures)
        end
        return obj
    end
end

function UI.captureHud(obj, x, y, value, newFeatures)
    local capture = UI.captures[UI.__captureKey]
    if not capture then return obj end

    local meta = {
        source = UI.__captureKey,
        index = #capture.elements + 1,
        hud = obj,
        x = x,
        y = y,
        value = value,
        newFeatures = newFeatures,
        isItem = type(value) == "number",
        isText = type(value) ~= "number",
        itemId = type(value) == "number" and value or nil,
        text = type(value) ~= "number" and tostring(value or "") or "",
        visible = true,
        callback = nil,
        color = { 255, 255, 255 },
    }

    obj.__fabioMeta = meta
    table.insert(capture.elements, meta)

    local methods = UI.__hudMethods

    obj.setText = function(self, text)
        meta.text = tostring(text or "")
        return methodCall(methods.setText, self, text)
    end

    obj.setItemId = function(self, itemId)
        meta.itemId = itemId
        return methodCall(methods.setItemId, self, itemId)
    end

    obj.setColor = function(self, r, g, b)
        meta.color = { r or 255, g or 255, b or 255 }
        return methodCall(methods.setColor, self, r, g, b)
    end

    obj.setScale = function(self, scale)
        meta.scale = scale
        return methodCall(methods.setScale, self, scale)
    end

    obj.setOpacity = function(self, opacity)
        meta.opacity = opacity
        return methodCall(methods.setOpacity, self, opacity)
    end

    obj.setZIndex = function(self, zIndex)
        meta.zIndex = zIndex
        return methodCall(methods.setZIndex, self, zIndex)
    end

    obj.setPos = function(self, posX, posY)
        meta.x = posX
        meta.y = posY
        return methodCall(methods.setPos, self, posX, posY)
    end

    obj.setCallback = function(self, callback)
        meta.callback = callback
        return methodCall(methods.setCallback, self, callback)
    end

    obj.show = function(self)
        meta.visible = true
        if UI.suppressLegacyHud ~= false then
            return methodCall(methods.hide, self)
        end
        return methodCall(methods.show, self)
    end

    obj.hide = function(self)
        meta.visible = false
        return methodCall(methods.hide, self)
    end

    if UI.suppressLegacyHud ~= false then
        methodCall(methods.hide, obj)
        if methods.setOpacity then
            pcall(function() methods.setOpacity(obj, 0.0) end)
        end
    end

    return obj
end

function UI.loadEmbeddedLegacyScript(key, loader)
    UI.patchHud()
    UI.captures[key] = {
        key = key,
        path = "embedded:" .. tostring(key),
        elements = {},
        loaded = false,
        error = nil,
    }

    UI.__captureKey = key
    local ok, err = pcall(loader)
    UI.__captureKey = nil

    UI.captures[key].loaded = ok
    UI.captures[key].error = ok and nil or tostring(err)

    UI.hideCapture(key)

    if ok then
        UI.log("Modulo embutido carregado: " .. tostring(key))
    else
        UI.showMessage("Falha ao carregar modulo embutido " .. tostring(key) .. ": " .. tostring(err))
    end

    return ok
end

function UI.hideCapture(key)
    local capture = UI.captures[key]
    if not capture then return end
    for _, meta in ipairs(capture.elements) do
        if meta.hud and UI.__hudMethods and UI.__hudMethods.hide then
            pcall(function() UI.__hudMethods.hide(meta.hud) end)
        end
    end
end

function UI.hideAllCaptured()
    for key, _ in pairs(UI.captures) do
        UI.hideCapture(key)
    end
end

local function textElements(group)
    local result = {}
    for _, meta in ipairs(group or {}) do
        if meta.isText then
            table.insert(result, meta)
        end
    end
    return result
end

local function itemElements(group)
    local result = {}
    for _, meta in ipairs(group or {}) do
        if meta.isItem then
            table.insert(result, meta)
        end
    end
    return result
end

local function findItem(group, itemId, skipFirst)
    local skipped = false
    for _, meta in ipairs(group or {}) do
        if meta.isItem and meta.itemId == itemId then
            if skipFirst and not skipped then
                skipped = true
            else
                return meta
            end
        end
    end
    return nil
end

local function findFirstCallback(group)
    for _, meta in ipairs(group or {}) do
        if meta.callback then return meta end
    end
    return nil
end

function UI.groupAvalorium()
    local capture = UI.captures.avalorium
    if not capture then return {} end

    local anchorsById = {
        [63053] = "task",
        [63052] = "rune",
        [63054] = "forge",
        [63050] = "arrow",
    }
    local anchors = {}

    for index, meta in ipairs(capture.elements) do
        if meta.isItem and anchorsById[meta.itemId] then
            table.insert(anchors, {
                key = anchorsById[meta.itemId],
                index = index,
            })
        end
    end

    table.sort(anchors, function(a, b) return a.index < b.index end)

    local groups = {}
    for i, anchor in ipairs(anchors) do
        local nextAnchor = anchors[i + 1]
        local lastIndex = nextAnchor and (nextAnchor.index - 1) or #capture.elements
        groups[anchor.key] = {}
        for index = anchor.index, lastIndex do
            table.insert(groups[anchor.key], capture.elements[index])
        end
    end

    return groups
end

function UI.firstCaptureGroup(key)
    local capture = UI.captures[key]
    if not capture then return {} end
    return capture.elements or {}
end

function UI.buildLegacyModules()
    local groups = UI.groupAvalorium()
    local modules = {}

    local taskText = textElements(groups.task)
    modules.task = {
        key = "task",
        label = "Task Book",
        iconId = 63053,
        icon = groups.task and groups.task[1],
        title = taskText[1],
        status = taskText[2],
        selected = taskText[3],
        progress = taskText[4],
        menu = taskText[5],
        toggle = taskText[6],
        check = taskText[7],
    }

    local runeText = textElements(groups.rune)
    modules.rune = {
        key = "rune",
        label = "Rune Refill",
        iconId = 63052,
        icon = groups.rune and groups.rune[1],
        title = runeText[1],
        status = runeText[2],
        selected = runeText[3],
        toggle = runeText[2],
        runes = {
            { label = "Avalanche", meta = findItem(groups.rune, 3161) },
            { label = "GFB", meta = findItem(groups.rune, 3191) },
            { label = "Thunder", meta = findItem(groups.rune, 3202) },
            { label = "Stone", meta = findItem(groups.rune, 3175) },
        },
    }

    local forgeText = textElements(groups.forge)
    modules.forge = {
        key = "forge",
        label = "Auto Forja",
        iconId = 63054,
        icon = groups.forge and groups.forge[1],
        title = forgeText[1],
        status = forgeText[2],
        maxDust = forgeText[3],
        maxDustState = forgeText[4],
        sliver = findItem(groups.forge, 37109),
        sliverState = forgeText[5],
        exalted = findItem(groups.forge, 37110),
        exaltedState = forgeText[6],
    }

    local arrowText = textElements(groups.arrow)
    modules.arrow = {
        key = "arrow",
        label = "Arrow Refill",
        iconId = 63050,
        icon = groups.arrow and groups.arrow[1],
        title = arrowText[1],
        status = arrowText[2],
        selected = arrowText[3],
        toggle = arrowText[2],
        diamond = findItem(groups.arrow, 35901),
        spectral = findItem(groups.arrow, 35902),
        others = arrowText[6],
    }

    local resetGroup = UI.firstCaptureGroup("resetfps")
    local resetText = textElements(resetGroup)
    modules.reset = {
        key = "reset",
        label = "Reset FPS",
        iconId = 63135,
        icon = findItem(resetGroup, 63135) or resetGroup[1],
        title = resetText[1],
        status = resetText[2],
        timer = resetText[3],
        vocation = resetText[4],
        now = resetText[5],
        last = resetText[6],
    }

    local craftGroup = UI.firstCaptureGroup("crafthouse")
    local craftText = textElements(craftGroup)
    local stationDefs = {
        { id = 63257, label = "SD" },
        { id = 63261, label = "GFB" },
        { id = 63263, label = "Avalanche" },
        { id = 63255, label = "Thunder" },
        { id = 63256, label = "Stone" },
        { id = 63253, label = "UH" },
        { id = 63258, label = "Supreme HP" },
        { id = 63264, label = "Berserk" },
        { id = 63250, label = "USP" },
        { id = 63254, label = "UMP" },
        { id = 63259, label = "Mastermind" },
        { id = 63262, label = "Bullseye" },
        { id = 63252, label = "Spectral" },
        { id = 63251, label = "Diamond" },
    }
    local craftStations = {}
    for _, station in ipairs(stationDefs) do
        table.insert(craftStations, {
            id = station.id,
            label = station.label,
            meta = findItem(craftGroup, station.id, station.id == 63257),
        })
    end

    modules.craft = {
        key = "craft",
        label = "Craft House",
        iconId = 63257,
        icon = craftGroup[1],
        title = craftText[1],
        status = craftText[2],
        selected = craftText[3],
        refill = craftText[4],
        min = craftText[5],
        max = craftText[6],
        toggle = craftText[7],
        stations = craftStations,
    }

    local followGroup = UI.firstCaptureGroup("follow")
    local followText = textElements(followGroup)
    modules.follow = {
        key = "follow",
        label = "Follow",
        iconId = 3079,
        title = followText[1],
        status = followText[1],
        config = findFirstCallback(followGroup),
    }

    modules.fungo = {
        key = "fungo",
        label = "Pisar no Fungo",
        iconId = 39176,
    }

    modules.party = {
        key = "party",
        label = "Auto Party",
        iconId = 63680,
    }

    UI.modules = modules
    return modules
end

local function setHudColor(item, color)
    if not item or not color then return end
    if item.setColor then
        item:setColor(color[1], color[2], color[3])
    end
end

local function setHudText(item, text)
    if item and item.setText then
        item:setText(tostring(text or ""))
    end
end

local function setHudVisible(item, visible)
    if not item then return end
    if visible then
        item:show()
    else
        item:hide()
    end
end

local function setHudPos(item, x, y)
    if item and item.setPos then
        item:setPos(x, y)
    end
end

local function setHudCallback(item, callback)
    if item and item.setCallback then
        item:setCallback(callback or noop)
    end
end

local function shorten(text, maxLength)
    text = tostring(text or "")
    maxLength = maxLength or 44
    if #text <= maxLength then return text end
    return text:sub(1, math.max(1, maxLength - 3)) .. "..."
end

function UI.metaText(meta, fallback)
    if not meta then return fallback or "-" end
    local text = tostring(meta.text or "")
    if text == "" then return fallback or "-" end
    return text
end

function UI.metaColor(meta, fallback)
    if meta and meta.color then return meta.color end
    return fallback or UI.colors.neutral
end

function UI.textLines(text)
    local lines = {}
    text = tostring(text or "")
    text = text:gsub("\r\n", "\n"):gsub("\r", "\n")
    for rawLine in (text .. "\n"):gmatch("(.-)\n") do
        local cleanedLine = trim(rawLine)
        if cleanedLine ~= "" then
            table.insert(lines, cleanedLine)
        end
    end
    return lines
end

function UI.addMetaLines(lines, meta, color, limit)
    local parsed = UI.textLines(UI.metaText(meta, ""))
    limit = limit or #parsed
    local added = 0
    for _, line in ipairs(parsed) do
        if added >= limit then break end
        UI.addLine(lines, line, color or UI.metaColor(meta, UI.colors.neutral))
        added = added + 1
    end
    return added
end

function UI.statusColor(text)
    local value = lower(text)
    if value:find("inativo", 1, true)
        or value:find("[off]", 1, true)
        or value:find("desativ", 1, true)
        or value:find("paus", 1, true)
        or value:find("erro", 1, true)
    then
        return UI.colors.inactive
    end

    if value:find("[on]", 1, true)
        or value:find("ativo", 1, true)
        or value:find("rodando", 1, true)
        or value:find("on:", 1, true)
    then
        return UI.colors.active
    end

    return UI.colors.neutral
end

function UI.moduleStatusText(key)
    if key == "party" then
        return UI.config and UI.config.autoParty and UI.config.autoParty.enabled and "[ON]" or "[OFF]"
    end
    if key == "fungo" then
        local fungo = UI.fungoConfig and UI.fungoConfig() or nil
        return fungo and fungo.enabled and "[ON]" or "[OFF]"
    end

    local module = UI.modules and UI.modules[key] or nil
    if not module then return "--" end

    if key == "forge" then
        return UI.metaText(module.status or module.maxDustState or module.sliverState, "--")
    end
    if key == "craft" then
        return UI.metaText(module.status, "--")
    end
    if key == "follow" then
        local text = UI.metaText(module.status, "")
        if UI.statusColor(text) == UI.colors.neutral then
            return "[OFF]"
        end
        return text
    end

    return UI.metaText(module.status, "--")
end

function UI.moduleStatusIcon(key)
    local color = UI.statusColor(UI.moduleStatusText(key))
    if color == UI.colors.active then
        return UI.itemSkinAssets.statusOn
    end
    if color == UI.colors.inactive then
        return UI.itemSkinAssets.statusOff
    end
    return UI.itemSkinAssets.statusIdle
end

function UI.invoke(meta)
    if not meta or not meta.callback then
        UI.showMessage("Controle ainda nao disponivel.")
        return
    end

    UI.safe("hud callback", meta.callback)
    UI.hideAllCaptured()
    UI.render()
end

function UI.createText(x, y, text, color, callback)
    local item = HUD.new(x, y, text or "", true)
    if item.setFontSize then item:setFontSize(9) end
    if item.setZIndex then item:setZIndex(900) end
    setHudColor(item, color or UI.colors.neutral)
    setHudCallback(item, callback)
    return item
end

function UI.createItem(x, y, itemId, callback, scale)
    local item = HUD.new(x, y, itemId, true)
    if item.setScale then item:setScale(scale or 1.0) end
    if item.setZIndex then item:setZIndex(905) end
    setHudCallback(item, callback)
    return item
end

function UI.createDecorItem(x, y, itemId, scale, opacity, zIndex)
    local item = UI.createItem(x, y, itemId, noop, scale or 1.0)
    if item.setOpacity then item:setOpacity(opacity or 1.0) end
    if item.setZIndex then item:setZIndex(zIndex or 760) end
    if item.setPhantom then item:setPhantom(true) end
    return item
end

function UI.logoItemId()
    return UI.itemSkinAssets.logoFallback
end

function UI.createItemFallbackSkin(x, y)
    if UI.config and UI.config.window and UI.config.window.useItemSkin == false then
        return nil
    end

    local assets = UI.itemSkinAssets
    local layout = UI.layout
    local skin = {
        body = {},
        edges = {},
        tabBacks = {},
        header = {},
        content = {},
        accents = {},
    }

    local function add(list, dx, dy, itemId, scale, opacity, zIndex)
        local entry = {
            dx = dx,
            dy = dy,
            itemId = itemId,
            scale = scale,
            opacity = opacity,
            zIndex = zIndex,
            hud = UI.createDecorItem(x + dx, y + dy, itemId, scale, opacity, zIndex),
        }
        table.insert(list, entry)
        return entry
    end

    local tile = 32

    local function tileCount(size)
        return math.max(1, math.floor(size / tile))
    end

    local function createTiledArea(list, left, top, width, height, itemId, opacity, zIndex)
        local cols = tileCount(width)
        local rows = tileCount(height)
        for row = 0, rows - 1 do
            for col = 0, cols - 1 do
                add(list, left + (col * tile), top + (row * tile), itemId, 1.0, opacity, zIndex)
            end
        end
    end

    local function createHorizontalEdge(list, left, top, width, itemId, opacity, zIndex)
        local cols = tileCount(width)
        for col = 0, cols - 1 do
            add(list, left + (col * tile), top, itemId, 1.0, opacity, zIndex)
        end
    end

    local function createVerticalEdge(list, left, top, height, itemId, opacity, zIndex)
        local rows = tileCount(height)
        for row = 0, rows - 1 do
            add(list, left, top + (row * tile), itemId, 1.0, opacity, zIndex)
        end
    end

    local function createBorder(list, left, top, width, height, opacity, zIndex)
        createHorizontalEdge(list, left, top, width, assets.edgeTop, opacity, zIndex)
        createHorizontalEdge(list, left, top + height - tile, width, assets.edgeBottom, opacity, zIndex)
        createVerticalEdge(list, left, top, height, assets.edgeLeft, opacity, zIndex + 1)
        createVerticalEdge(list, left + width - tile, top, height, assets.edgeRight, opacity, zIndex + 1)
    end

    -- Fundo unico dentro da borda. Nada e desenhado fora dos limites internos.
    createTiledArea(
        skin.body,
        16,
        16,
        layout.width - 32,
        layout.height - 32,
        assets.panelFill,
        0.74,
        735
    )

    -- Frame externo com as quatro pecas informadas pelo prompt.
    createBorder(skin.edges, 0, 0, layout.width, layout.height, 1.0, 760)

    -- Separadores internos: header, menu lateral e painel de conteudo.
    createHorizontalEdge(skin.header, 16, 76, layout.width - 32, assets.edgeBottom, 0.58, 790)
    createVerticalEdge(skin.edges, layout.menuRightX, 96, 352, assets.edgeLeft, 0.62, 792)

    -- O topo e a lateral esquerda do painel direito ja sao definidos pela moldura principal.
    createVerticalEdge(skin.content, 592, 96, 352, assets.edgeRight, 0.46, 786)

    -- Apenas a aba ativa exibe o glow 63157 atras do icone.
    for index, _ in ipairs(UI.tabs) do
        local tabY = layout.tabY + ((index - 1) * layout.tabStep)
        skin.tabBacks[index] = add(skin.tabBacks, layout.tabGlowX, tabY, assets.selectedGlow, 0.28, 0.82, 770)
    end

    return skin
end

function UI.updateItemFallbackSkin(skin, x, y, expanded, activeKey)
    if not skin then return end

    local visible = expanded
    local frameDirty = skin.lastX ~= x or skin.lastY ~= y or skin.lastVisible ~= visible
    local tabsDirty = frameDirty or skin.lastActiveKey ~= activeKey
    if not frameDirty and not tabsDirty then
        return
    end

    local function updateList(list)
        for _, entry in ipairs(list or {}) do
            local item = entry.hud
            setHudVisible(item, visible)
            if visible then
                setHudPos(item, x + entry.dx, y + entry.dy)
                if item.setItemId then item:setItemId(entry.itemId) end
                if item.setScale then item:setScale(entry.scale or 1.0) end
                if item.setOpacity then item:setOpacity(entry.opacity or 1.0) end
                if item.setZIndex then item:setZIndex(entry.zIndex or 760) end
                if item.setPhantom then item:setPhantom(true) end
            end
        end
    end

    if frameDirty then
        updateList(skin.body)
        updateList(skin.edges)
        updateList(skin.header)
        updateList(skin.content)
        updateList(skin.accents)
    end

    if tabsDirty then
        for index, entry in ipairs(skin.tabBacks or {}) do
            local tab = UI.tabs[index]
            local active = tab and tab.key == activeKey
            local item = entry.hud
            setHudVisible(item, visible and active)
            if visible and active then
                -- Glow 63157 somente atras do icone da aba selecionada.
                setHudPos(item, x + entry.dx, y + entry.dy)
                if item.setItemId then
                    item:setItemId(UI.itemSkinAssets.selectedGlow)
                end
                if item.setScale then item:setScale(entry.scale or 1.12) end
                if item.setOpacity then item:setOpacity(entry.opacity or 0.94) end
                if item.setZIndex then item:setZIndex(780) end
                if item.setPhantom then item:setPhantom(true) end
            end
        end
    end

    skin.lastX = x
    skin.lastY = y
    skin.lastVisible = visible
    skin.lastActiveKey = activeKey
end

function UI.destroyItemFallbackSkin(skin)
    if not skin then return end

    local function destroyList(list)
        for _, entry in ipairs(list or {}) do
            local item = entry.hud
            if item and item.destroy then
                pcall(function() item:destroy() end)
            end
        end
    end

    destroyList(skin.body)
    destroyList(skin.edges)
    destroyList(skin.header)
    destroyList(skin.content)
    destroyList(skin.accents)
    destroyList(skin.tabBacks)
end

function UI.destroyModal()
    local modal = UI.modal
    if not modal then return end

    local function destroy(item)
        if item and item.destroy then
            pcall(function() item:destroy() end)
        end
    end

    for _, item in ipairs(modal.decor or {}) do destroy(item) end
    for _, item in ipairs(modal.items or {}) do destroy(item) end
    UI.modal = nil
end

function UI.modalText(x, y, text, color, callback, zIndex)
    local item = UI.createText(x, y, text, color, callback)
    if item.setZIndex then item:setZIndex(zIndex or 1150) end
    return item
end

function UI.modalItem(x, y, itemId, callback, scale, zIndex)
    local item = UI.createItem(x, y, itemId, callback, scale)
    if item.setZIndex then item:setZIndex(zIndex or 1160) end
    return item
end

function UI.openActionPanel(title, iconId, actions)
    UI.destroyModal()

    local x, y = UI.basePosition()
    local assets = UI.itemSkinAssets
    local modal = {
        decor = {},
        items = {},
    }
    UI.modal = modal

    local mx = x + 82
    local my = y + 86
    local width = 384
    local height = math.min(318, math.max(206, 78 + (#(actions or {}) * 29)))

    local function addDecor(dx, dy, itemId, scale, opacity, zIndex)
        local item = UI.createDecorItem(mx + dx, my + dy, itemId, scale, opacity, zIndex or 1100)
        table.insert(modal.decor, item)
        return item
    end

    local rows = math.ceil(height / 40)
    for row = 0, rows do
        for col = 0, 8 do
            addDecor(-6 + (col * 42), -8 + (row * 40), assets.shadow, 1.94, 0.86, 1100)
        end
    end
    for row = 0, rows do
        for col = 0, 8 do
            addDecor(8 + (col * 40), 8 + (row * 38), assets.panel, 1.40, 0.18, 1104)
        end
    end
    for row = 0, rows do
        addDecor(-18, -6 + (row * 40), assets.edgeLeft, 1.06, 0.92, 1112)
        addDecor(width - 10, -6 + (row * 40), assets.edgeRight, 1.06, 0.92, 1112)
    end
    addDecor(19, 19, assets.tabActive, 0.44, 0.76, 1124)
    addDecor(54, 20, assets.glass, 4.50, 0.68, 1118)

    table.insert(modal.items, UI.modalItem(mx + 20, my + 18, iconId or UI.logoItemId(), noop, 0.82, 1160))
    table.insert(modal.items, UI.modalText(mx + 54, my + 18, title, UI.colors.title, noop, 1150))
    table.insert(modal.items, UI.modalText(mx + width - 34, my + 17, "X", UI.colors.inactive, function()
        UI.destroyModal()
    end, 1160))

    local buttonY = my + 52
    for index, action in ipairs(actions or {}) do
        local by = buttonY + ((index - 1) * 29)
        local isPrimary = action.primary == true
        local bg = addDecor(24, by - my - 7, isPrimary and assets.tabActive or assets.tabIdle, isPrimary and 0.42 or 1.16, isPrimary and 0.82 or 0.34, 1120)
        if bg.setPhantom then bg:setPhantom(true) end
        if action.iconId then
            table.insert(modal.items, UI.modalItem(mx + 28, by - 2, action.iconId, action.callback, 0.54, 1160))
        end
        table.insert(modal.items, UI.modalText(mx + 56, by, action.label or "-", action.color or (isPrimary and UI.colors.active or UI.colors.info), action.callback, 1160))
    end
end

function UI.taskLevels()
    if type(FabioTaskLevelOptions) == "table" then
        return FabioTaskLevelOptions
    end
    return { "Easy", "Medium", "Hard", "Nightmare", "Master" }
end

function UI.taskCatalog(level)
    if type(FabioTaskCatalog) == "table" and type(FabioTaskCatalog[level]) == "table" then
        return FabioTaskCatalog[level]
    end
    return {}
end

function UI.writeTaskPanelConfig(data)
    if not JSON then
        pcall(function() dofile("core/json.lua") end)
    end
    if not JSON or not JSON.encode then
        UI.showMessage("JSON indisponivel para salvar task.")
        return false
    end

    data = data or {}
    data.updatedAt = os.time()
    local ok, encoded = pcall(function()
        return JSON.encode(data)
    end)
    if ok and encoded then
        UI.writeTextFile("TaskBookController.config.json", encoded)
        return true
    end
    UI.showMessage("Falha ao salvar config da task.")
    return false
end

function UI.selectTask(level, task)
    if not task then return end
    UI.writeTaskPanelConfig({
        level = level,
        task = task.name,
        match = task.match or task.name,
    })
    UI.destroyModal()
    UI.showMessage("Task selecionada: " .. tostring(level) .. " / " .. tostring(task.name))
end

function UI.openTaskLevelPanel()
    local actions = {}
    for _, level in ipairs(UI.taskLevels()) do
        table.insert(actions, {
            label = level,
            iconId = 63053,
            color = UI.colors.info,
            callback = function()
                UI.openTaskListPanel(level, 1)
            end,
        })
    end
    table.insert(actions, {
        label = "Voltar",
        iconId = 6529,
        color = UI.colors.warning,
        callback = function() UI.openTaskPanel() end,
    })
    UI.openActionPanel("Escolher nivel", 63053, actions)
end

function UI.openTaskListPanel(level, page)
    local tasks = UI.taskCatalog(level)
    if #tasks == 0 then
        UI.showMessage("Sem catalogo para " .. tostring(level))
        UI.openTaskLevelPanel()
        return
    end

    page = tonumber(page) or 1
    local perPage = 5
    local totalPages = math.max(1, math.ceil(#tasks / perPage))
    if page < 1 then page = totalPages end
    if page > totalPages then page = 1 end

    local actions = {}
    local first = ((page - 1) * perPage) + 1
    local last = math.min(#tasks, first + perPage - 1)
    for index = first, last do
        local task = tasks[index]
        table.insert(actions, {
            label = tostring(index) .. ". " .. tostring(task.name),
            iconId = 63053,
            color = UI.colors.info,
            callback = function()
                UI.selectTask(level, task)
            end,
        })
    end

    table.insert(actions, {
        label = "Pagina " .. tostring(page) .. "/" .. tostring(totalPages) .. "  >",
        iconId = 3533,
        color = UI.colors.warning,
        callback = function() UI.openTaskListPanel(level, page + 1) end,
    })
    table.insert(actions, {
        label = "< Voltar niveis",
        iconId = 6529,
        color = UI.colors.warning,
        callback = function() UI.openTaskLevelPanel() end,
    })

    UI.openActionPanel("Tasks: " .. tostring(level), 63053, actions)
end

function UI.openTaskPanel()
    local m = UI.modules.task
    if not m then
        UI.showMessage("Task Book nao carregado.")
        return
    end

    UI.openActionPanel("FabioRockeiro Task", UI.tabIcon(UI.tabs[1]) or 63053, {
        {
            label = UI.metaText(m.toggle, "Ativar / Pausar"),
            iconId = 63053,
            color = UI.colors.warning,
            primary = true,
            callback = function()
                UI.invoke(m.toggle)
                UI.destroyModal()
            end,
        },
        {
            label = "Checar agora",
            iconId = 63053,
            color = UI.colors.info,
            callback = function()
                UI.invoke(m.check)
                UI.destroyModal()
            end,
        },
        {
            label = "Selecionar task / nivel",
            iconId = 63053,
            color = UI.colors.info,
            callback = function()
                UI.openTaskLevelPanel()
            end,
        },
        {
            label = "Fechar painel",
            iconId = 6529,
            color = UI.colors.inactive,
            callback = function()
                UI.destroyModal()
            end,
        },
    })
end

function UI.createHubHud()
    if UI.elements then
        UI.destroyHubHud()
    end

    local config = UI.config or UI.loadConfig()
    local x = tonumber(config.window.x) or UI.defaults.window.x
    local y = tonumber(config.window.y) or UI.defaults.window.y
    local elements = {
        tabs = {},
        lines = {},
    }
    UI.elements = elements
    elements.itemSkin = UI.createItemFallbackSkin(x, y)

    local layout = UI.layout

    -- Icone principal: agora fica no header, faz sentido visual e continua arrastavel.
    local initialExpanded = config.window.expanded ~= false
    local initialHeaderIconX = initialExpanded and layout.expandedHeaderIconX or layout.headerIconX
    local initialHeaderIconY = initialExpanded and layout.expandedHeaderIconY or layout.minimizedHeaderIconY
    elements.launcher = UI.createItem(x + initialHeaderIconX, y + initialHeaderIconY, UI.logoItemId(), function()
        UI.toggleExpanded()
    end, initialExpanded and layout.logoScale or layout.minimizedLogoScale)
    elements.launcher:setDraggable(true)

    elements.brand = UI.createText(x + layout.headerTextX, y + layout.headerTitleY, UI.scriptDisplayName, UI.colors.title, function()
        UI.toggleExpanded()
    end)
    if elements.brand.setFontSize then elements.brand:setFontSize(12) end

    elements.sub = UI.createText(x + layout.headerTextX, y + layout.headerSubY, "Avalorium Hub", UI.colors.muted, function()
        UI.toggleExpanded()
    end)
    if elements.sub.setFontSize then elements.sub:setFontSize(8) end

    elements.hint = UI.createText(x + layout.headerHintX, y + layout.headerHintY, "Clique no Icone do Mago para Minimizar", UI.colors.muted, function()
        UI.toggleExpanded()
    end)
    if elements.hint.setFontSize then elements.hint:setFontSize(7) end

    elements.hint2 = UI.createText(x + layout.headerHintX, y + layout.headerHint2Y, "e arraste pra qualquer canto da tela", UI.colors.muted, function()
        UI.toggleExpanded()
    end)
    if elements.hint2.setFontSize then elements.hint2:setFontSize(7) end

    -- Sem botao [_] desenhado na tela. Clicar no icone/titulo minimiza.
    elements.minimize = nil

    for index, tab in ipairs(UI.tabs) do
        local tabY = y + layout.tabY + ((index - 1) * layout.tabStep)
        local icon = UI.createItem(x + layout.tabX, tabY, tab.icon, function()
            UI.setActiveTab(tab.key)
        end, 0.78)
        local label = UI.createText(x + layout.tabTextX, tabY + 4, tab.label, UI.colors.neutral, function()
            UI.setActiveTab(tab.key)
        end)
        local badge = UI.createText(x + layout.tabBadgeX, tabY + 4, "--", UI.colors.muted, function()
            UI.setActiveTab(tab.key)
        end)
        if label.setFontSize then label:setFontSize(9) end
        if badge.setFontSize then badge:setFontSize(8) end
        elements.tabs[index] = {
            icon = icon,
            label = label,
            stateBadge = badge,
            tab = tab,
        }
    end

    elements.contentTitle = UI.createText(x + layout.contentX + 42, y + layout.contentY, "", UI.colors.title)
    if elements.contentTitle.setFontSize then elements.contentTitle:setFontSize(12) end
    elements.contentIcon = UI.createItem(x + layout.contentX, y + layout.contentY + 8, 63053, noop, 0.96)
    elements.contentStateIcon = nil

    for index = 1, 14 do
        elements.lines[index] = UI.createText(x + layout.contentX + 42, y + layout.contentY + 34 + ((index - 1) * layout.contentLineStep), "", UI.colors.neutral)
        if elements.lines[index].setFontSize then elements.lines[index]:setFontSize(8) end
    end

    -- Rodape antigo removido: os estados agora ficam nos badges do menu.
    elements.status = UI.createText(x, y, "", UI.colors.muted)
    elements.help = UI.createText(x, y, "", UI.colors.info)
    setHudVisible(elements.status, false)
    setHudVisible(elements.help, false)
end

function UI.destroyHubHud()
    local elements = UI.elements
    if not elements then return end
    UI.destroyModal()

    local function destroy(item)
        if item and item.destroy then
            pcall(function() item:destroy() end)
        end
    end

    destroy(elements.launcher)
    destroy(elements.brand)
    destroy(elements.sub)
    destroy(elements.hint)
    destroy(elements.hint2)
    destroy(elements.minimize)
    destroy(elements.contentTitle)
    destroy(elements.contentIcon)
    destroy(elements.contentStateIcon)
    destroy(elements.status)
    destroy(elements.help)

    UI.destroyItemFallbackSkin(elements.itemSkin)

    for _, tab in ipairs(elements.tabs or {}) do
        destroy(tab.icon)
        destroy(tab.stateIcon)
        destroy(tab.stateBadge)
        destroy(tab.label)
    end

    for _, line in ipairs(elements.lines or {}) do
        destroy(line)
    end

    UI.elements = nil
end

function UI.toggleExpanded()
    UI.destroyModal()
    UI.config.window.expanded = not UI.config.window.expanded
    UI.saveConfig()
    UI.render()
end

function UI.setActiveTab(key)
    UI.destroyModal()
    UI.config.window.activeTab = key
    UI.config.window.expanded = true
    UI.saveConfig()
    UI.render()
end

function UI.basePosition()
    local x = tonumber(UI.config.window.x) or UI.defaults.window.x
    local y = tonumber(UI.config.window.y) or UI.defaults.window.y
    local layout = UI.layout

    local launcher = UI.elements and UI.elements.launcher
    if launcher and launcher.getPos then
        local pos = launcher:getPos()
        if pos and pos.x and pos.y and (pos.x ~= 0 or pos.y ~= 0) then
            local expanded = UI.config.window.expanded ~= false
            local fallbackOffsetX = expanded and layout.expandedHeaderIconX or layout.headerIconX
            local fallbackOffsetY = expanded and layout.expandedHeaderIconY or layout.minimizedHeaderIconY
            local offsetX = UI.lastLauncherOffsetX or fallbackOffsetX
            local offsetY = UI.lastLauncherOffsetY or fallbackOffsetY
            x = pos.x - offsetX
            y = pos.y - offsetY
            UI.config.window.x = x
            UI.config.window.y = y
        end
    end

    return x, y
end

function UI.currentTabDef()
    local activeKey = UI.config.window.activeTab or UI.defaults.window.activeTab
    for _, tab in ipairs(UI.tabs) do
        if tab.key == activeKey then return tab end
    end
    return UI.tabs[1]
end

function UI.tabIcon(tab)
    local module = UI.modules[tab.key]
    if module and module.icon and module.icon.itemId then
        return module.icon.itemId
    end
    return module and module.iconId or tab.icon
end

function UI.addLine(lines, text, color, callback)
    table.insert(lines, {
        text = text,
        color = color or UI.colors.neutral,
        callback = callback,
    })
end

function UI.linesTask(lines)
    local m = UI.modules.task
    if not m or not m.status then
        UI.addLine(lines, "Task Book nao carregado.", UI.colors.inactive)
        return
    end
    UI.addLine(lines, UI.metaText(m.status), UI.statusColor(UI.metaText(m.status)))
    UI.addLine(lines, UI.metaText(m.selected), UI.colors.neutral)
    UI.addLine(lines, UI.metaText(m.progress), UI.colors.info)
    UI.addLine(lines, UI.metaText(m.toggle, "[Ativar/Pausar]"), UI.colors.warning, function() UI.invoke(m.toggle) end)
    UI.addLine(lines, "[Painel custom da task]", UI.colors.info, function() UI.openTaskPanel() end)
    UI.addLine(lines, "[Checar agora]", UI.colors.info, function() UI.invoke(m.check) end)
end

function UI.linesRune(lines)
    local m = UI.modules.rune
    if not m or not m.status then
        UI.addLine(lines, "Rune Refill nao carregado.", UI.colors.inactive)
        return
    end
    UI.addLine(lines, UI.metaText(m.status), UI.statusColor(UI.metaText(m.status)))
    UI.addLine(lines, UI.metaText(m.selected), UI.colors.neutral)
    UI.addLine(lines, "[Ativar/Pausar compra]", UI.colors.warning, function() UI.invoke(m.toggle) end)
    UI.addLine(lines, "Runas rapidas:", UI.colors.muted)
    for _, rune in ipairs(m.runes or {}) do
        UI.addLine(lines, "[" .. rune.label .. "]", UI.colors.info, function() UI.invoke(rune.meta) end)
    end
end

function UI.linesArrow(lines)
    local m = UI.modules.arrow
    if not m or not m.status then
        UI.addLine(lines, "Arrow Refill nao carregado.", UI.colors.inactive)
        return
    end
    UI.addLine(lines, UI.metaText(m.status), UI.statusColor(UI.metaText(m.status)))
    UI.addLine(lines, UI.metaText(m.selected), UI.colors.neutral)
    UI.addLine(lines, "[Ativar/Pausar compra]", UI.colors.warning, function() UI.invoke(m.toggle) end)
    UI.addLine(lines, "[Diamond Arrow]", UI.colors.info, function() UI.invoke(m.diamond) end)
    UI.addLine(lines, "[Spectral Bolt]", UI.colors.info, function() UI.invoke(m.spectral) end)
    UI.addLine(lines, UI.metaText(m.others, "[Outros]"), UI.colors.info, function() UI.invoke(m.others) end)
end

function UI.linesForge(lines)
    local m = UI.modules.forge
    if not m or not m.status then
        UI.addLine(lines, "Auto Forja nao carregada.", UI.colors.inactive)
        return
    end
    UI.addLine(lines, UI.metaText(m.status), UI.colors.info)
    UI.addLine(lines, "Max Dust: " .. UI.metaText(m.maxDustState, "OFF"), UI.statusColor(UI.metaText(m.maxDustState)), function() UI.invoke(m.maxDust or m.maxDustState) end)
    UI.addLine(lines, "Sliver: " .. UI.metaText(m.sliverState, "OFF"), UI.statusColor(UI.metaText(m.sliverState)), function() UI.invoke(m.sliver or m.sliverState) end)
    UI.addLine(lines, "Exalted Core: " .. UI.metaText(m.exaltedState, "OFF"), UI.statusColor(UI.metaText(m.exaltedState)), function() UI.invoke(m.exalted or m.exaltedState) end)
end

function UI.talkType()
    return (Enums and Enums.TalkTypes and Enums.TalkTypes.TALKTYPE_SAY) or 1
end

function UI.linesFollow(lines)
    local m = UI.modules.follow
    if m and m.status then
        local count = UI.addMetaLines(lines, m.status, UI.colors.neutral, 4)
        if count == 0 then
            UI.addLine(lines, "Follow aguardando alvo.", UI.colors.neutral)
        end
    else
        UI.addLine(lines, "Follow carregado em modo comando.", UI.colors.neutral)
    end
    UI.addLine(lines, "[Abrir configuracao]", UI.colors.info, function() UI.invoke(m and m.config) end)
    UI.addLine(lines, "[Parar follow]", UI.colors.warning, function()
        if Game and Game.talk then
            Game.talk("!follow", UI.talkType())
        end
    end)
    UI.addLine(lines, "Use: !follow Nome", UI.colors.muted)
    UI.addLine(lines, "Duplo ESC continua desativando.", UI.colors.muted)
end

function UI.linesReset(lines)
    local m = UI.modules.reset
    if not m or not m.status then
        UI.addLine(lines, "Reset FPS nao carregado.", UI.colors.inactive)
        return
    end
    UI.addLine(lines, UI.metaText(m.status), UI.statusColor(UI.metaText(m.status)))
    UI.addLine(lines, UI.metaText(m.timer), UI.colors.info)
    UI.addLine(lines, UI.metaText(m.last), UI.colors.neutral)
    UI.addLine(lines, "[Ativar/Pausar]", UI.colors.warning, function() UI.invoke(m.status or m.title) end)
    UI.addLine(lines, UI.metaText(m.vocation, "[Vocacao/config]"), UI.colors.info, function() UI.invoke(m.vocation) end)
    UI.addLine(lines, UI.metaText(m.now, "[Usar agora]"), UI.colors.info, function() UI.invoke(m.now or m.timer) end)
end

function UI.linesCraft(lines)
    local m = UI.modules.craft
    if not m or not m.status then
        UI.addLine(lines, "Craft House nao carregado.", UI.colors.inactive)
        return
    end

    UI.addLine(lines, UI.metaText(m.status), UI.statusColor(UI.metaText(m.status)))
    UI.addLine(lines, UI.metaText(m.selected), UI.colors.neutral)
    UI.addLine(lines, UI.metaText(m.refill), UI.colors.info)
    UI.addLine(lines, UI.metaText(m.toggle, "[Ativar/Pausar]"), UI.colors.warning, function() UI.invoke(m.toggle or m.status) end)
    UI.addLine(lines, UI.metaText(m.min, "[MIN]"), UI.colors.warning, function() UI.invoke(m.min) end)
    UI.addLine(lines, UI.metaText(m.max, "[MAX]"), UI.colors.warning, function() UI.invoke(m.max) end)

    local page = UI.moduleState.craftPage or 1
    local perPage = 6
    local startIndex = ((page - 1) * perPage) + 1
    local endIndex = math.min(#(m.stations or {}), startIndex + perPage - 1)
    UI.addLine(lines, "Mesas " .. tostring(startIndex) .. "-" .. tostring(endIndex) .. ":", UI.colors.muted)
    for index = startIndex, endIndex do
        local station = m.stations[index]
        if station then
            UI.addLine(lines, "[" .. station.label .. "]", UI.colors.info, function() UI.invoke(station.meta) end)
        end
    end

    local totalPages = math.max(1, math.ceil(#(m.stations or {}) / perPage))
    UI.addLine(lines, "[Proxima pagina " .. tostring(page) .. "/" .. tostring(totalPages) .. "]", UI.colors.warning, function()
        UI.moduleState.craftPage = (page % totalPages) + 1
        UI.render()
    end)
end

function UI.partyListText()
    local party = UI.config and UI.config.autoParty or UI.defaults.autoParty
    local candidates = party.candidates or {}
    if #candidates == 0 then return "Lista vazia" end
    return table.concat(candidates, ", ")
end

function UI.linesParty(lines)
    local party = UI.config.autoParty
    UI.addLine(lines, party.enabled and "Auto Party: ON" or "Auto Party: OFF", party.enabled and UI.colors.active or UI.colors.inactive)
    UI.addLine(lines, "Players: " .. shorten(UI.partyListText(), 46), UI.colors.neutral)
    UI.addLine(lines, UI.autoPartyLastStatus or "Aguardando comandos.", UI.colors.muted)
    UI.addLine(lines, party.enabled and "[Desativar]" or "[Ativar]", UI.colors.warning, function()
        party.enabled = not party.enabled
        UI.autoPartyLastStatus = party.enabled and "Auto Party ativada." or "Auto Party pausada."
        UI.saveConfig()
        UI.render()
    end)
    UI.addLine(lines, "[Listar players]", UI.colors.info, function()
        UI.showMessage("Auto Party: " .. UI.partyListText())
    end)
    UI.addLine(lines, "Comandos:", UI.colors.muted)
    UI.addLine(lines, ".party add Nome", UI.colors.muted)
    UI.addLine(lines, ".party remove Nome", UI.colors.muted)
    UI.addLine(lines, ".party clear / list / on / off", UI.colors.muted)
end

function UI.linesFungo(lines)
    local fungo = UI.fungoConfig()
    local active = fungo.enabled == true
    local toggle = function() UI.toggleFungoStepper() end

    UI.addLine(lines, active and "Pisar no Fungo: ON" or "Pisar no Fungo: OFF", active and UI.colors.active or UI.colors.inactive, toggle)
    UI.addLine(lines, "Ative para que ele pise nos fungos da Gnoprona.", UI.colors.neutral)
    UI.addLine(lines, UI.fungoLastStatus or "Aguardando ativacao.", UI.colors.muted)
    UI.addLine(lines, active and "[Desativar]" or "[Ativar]", UI.colors.warning, toggle)
end

function UI.currentLines()
    local tab = UI.currentTabDef()
    local lines = {}
    if tab.key == "task" then UI.linesTask(lines)
    elseif tab.key == "rune" then UI.linesRune(lines)
    elseif tab.key == "arrow" then UI.linesArrow(lines)
    elseif tab.key == "forge" then UI.linesForge(lines)
    elseif tab.key == "follow" then UI.linesFollow(lines)
    elseif tab.key == "reset" then UI.linesReset(lines)
    elseif tab.key == "craft" then UI.linesCraft(lines)
    elseif tab.key == "fungo" then UI.linesFungo(lines)
    elseif tab.key == "party" then UI.linesParty(lines)
    end
    return lines
end

function UI.statusStrip()
    local parts = {}
    local function add(key, label, meta)
        local text = UI.metaText(meta, "-")
        if UI.statusColor(text) == UI.colors.active then
            table.insert(parts, label .. " ON")
        elseif UI.statusColor(text) == UI.colors.inactive then
            table.insert(parts, label .. " OFF")
        else
            table.insert(parts, label .. " --")
        end
    end

    add("task", "Task", UI.modules.task and UI.modules.task.status)
    add("rune", "Rune", UI.modules.rune and UI.modules.rune.status)
    add("arrow", "Arrow", UI.modules.arrow and UI.modules.arrow.status)
    add("reset", "Reset", UI.modules.reset and UI.modules.reset.status)
    table.insert(parts, (UI.fungoConfig().enabled and "Fungo ON" or "Fungo OFF"))
    table.insert(parts, (UI.config.autoParty.enabled and "Party ON" or "Party OFF"))
    return table.concat(parts, " | ")
end

function UI.badgeTextAndColor(key)
    local status = UI.moduleStatusText(key)
    local color = UI.statusColor(status)
    if color == UI.colors.active then return "ON", UI.colors.active end
    if color == UI.colors.inactive then return "OFF", UI.colors.inactive end
    return "--", UI.colors.muted
end

function UI.panelTitle(tab)
    if not tab then return "Modulo" end
    if tab.key == "party" then return "Party Module" end
    if tab.key == "task" then return "Task Module" end
    if tab.key == "rune" then return "Rune Module" end
    if tab.key == "arrow" then return "Arrow Module" end
    if tab.key == "forge" then return "Forja Module" end
    if tab.key == "follow" then return "Follow Module" end
    if tab.key == "reset" then return "Reset FPS Module" end
    if tab.key == "craft" then return "Craft Module" end
    if tab.key == "fungo" then return "Pisar no Fungo" end
    return tostring(tab.label or "Modulo") .. " Module"
end

function UI.updateHeader(e, x, y, expanded, tab)
    local layout = UI.layout
    local launcherX = expanded and layout.expandedHeaderIconX or layout.headerIconX
    local launcherY = expanded and layout.expandedHeaderIconY or layout.minimizedHeaderIconY

    setHudVisible(e.launcher, true)
    setHudPos(e.launcher, x + launcherX, y + launcherY)
    UI.lastLauncherOffsetX = launcherX
    UI.lastLauncherOffsetY = launcherY
    if e.launcher.setItemId then e.launcher:setItemId(UI.logoItemId()) end
    if e.launcher.setScale then e.launcher:setScale(expanded and layout.logoScale or layout.minimizedLogoScale) end
    if e.launcher.setOpacity then e.launcher:setOpacity(expanded and 1.0 or 0.96) end

    setHudPos(e.brand, expanded and (x + layout.headerTextX) or (x + layout.headerIconX + 38), expanded and (y + layout.headerTitleY) or (y + layout.headerIconY - 8))
    setHudPos(e.sub, expanded and (x + layout.headerTextX) or (x + layout.headerIconX + 38), expanded and (y + layout.headerSubY) or (y + layout.headerIconY + 10))
    setHudPos(e.hint, x + layout.headerHintX, y + layout.headerHintY)
    setHudPos(e.hint2, x + layout.headerHintX, y + layout.headerHint2Y)
    setHudVisible(e.brand, true)
    setHudVisible(e.sub, true)
    setHudVisible(e.hint, expanded)
    setHudVisible(e.hint2, expanded)
    setHudVisible(e.minimize, false)

    setHudText(e.brand, UI.scriptDisplayName)
    setHudText(e.sub, expanded and ("Avalorium Hub | " .. tab.label) or "Clique para abrir")
    setHudText(e.hint, "Clique no Icone do Mago para Minimizar")
    setHudText(e.hint2, "e arraste pra qualquer canto da tela")
end

function UI.updateStatusBadges(tabEntry)
    if not tabEntry then return end

    local badgeText, badgeColor = UI.badgeTextAndColor(tabEntry.tab.key)
    setHudText(tabEntry.stateBadge, badgeText)
    setHudColor(tabEntry.stateBadge, badgeColor)
end

function UI.updateMenu(e, x, y, expanded, activeTab)
    local layout = UI.layout

    for index, tabEntry in ipairs(e.tabs or {}) do
        local active = tabEntry.tab.key == activeTab.key
        local tabY = y + layout.tabY + ((index - 1) * layout.tabStep)
        setHudPos(tabEntry.icon, x + layout.tabX, tabY)
        setHudPos(tabEntry.label, x + layout.tabTextX, tabY + 4)
        setHudPos(tabEntry.stateBadge, x + layout.tabBadgeX, tabY + 4)
        setHudVisible(tabEntry.icon, expanded)
        setHudVisible(tabEntry.label, expanded)
        setHudVisible(tabEntry.stateIcon, false)
        setHudVisible(tabEntry.stateBadge, expanded)

        if tabEntry.icon.setItemId then tabEntry.icon:setItemId(UI.tabIcon(tabEntry.tab) or tabEntry.tab.icon) end
        if tabEntry.icon.setScale then tabEntry.icon:setScale(active and 0.92 or 0.76) end
        if tabEntry.icon.setOpacity then tabEntry.icon:setOpacity(active and 1.0 or 0.78) end

        setHudText(tabEntry.label, tabEntry.tab.label)
        setHudColor(tabEntry.label, active and UI.colors.title or UI.colors.neutral)

        UI.updateStatusBadges(tabEntry)
    end
end

function UI.updateContent(e, x, y, expanded, tab)
    local layout = UI.layout

    setHudVisible(e.contentTitle, expanded)
    setHudVisible(e.contentIcon, expanded)
    setHudVisible(e.contentStateIcon, false)
    setHudVisible(e.status, false)
    setHudVisible(e.help, false)

    setHudPos(e.contentTitle, x + layout.contentX + 42, y + layout.contentY)
    setHudPos(e.contentIcon, x + layout.contentX, y + layout.contentY + 8)
    setHudPos(e.status, x, y)
    setHudPos(e.help, x, y)

    if e.contentIcon.setItemId then e.contentIcon:setItemId(UI.tabIcon(tab) or tab.icon) end
    if e.contentIcon.setScale then e.contentIcon:setScale(0.96) end
    if e.contentIcon.setOpacity then e.contentIcon:setOpacity(1.0) end

    setHudText(e.contentTitle, UI.panelTitle(tab))
    setHudColor(e.contentTitle, UI.colors.title)
    setHudText(e.status, "")
    setHudText(e.help, "")

    local lines = UI.currentLines()
    for index, lineHud in ipairs(e.lines or {}) do
        local data = lines[index]
        setHudPos(lineHud, x + layout.contentX + 42, y + layout.contentY + 34 + ((index - 1) * layout.contentLineStep))
        setHudVisible(lineHud, expanded and data ~= nil)
        if data then
            setHudText(lineHud, shorten(data.text, 54))
            setHudColor(lineHud, data.color or UI.colors.neutral)
            setHudCallback(lineHud, data.callback)
        else
            setHudText(lineHud, "")
            setHudCallback(lineHud, noop)
        end
    end
end

function UI.updateHub()
    if not UI.elements then return end
    local e = UI.elements
    local x, y = UI.basePosition()
    local expanded = UI.config.window.expanded ~= false
    local tab = UI.currentTabDef()

    UI.hideAllCaptured()
    UI.updateItemFallbackSkin(e.itemSkin, x, y, expanded, tab.key)
    UI.updateHeader(e, x, y, expanded, tab)
    UI.updateMenu(e, x, y, expanded, tab)
    UI.updateContent(e, x, y, expanded, tab)
end

function UI.render()
    UI.updateHub()
end

function UI.clear()
    UI.destroyHubHud()
end

function UI.persistPosition()
    if not UI.elements then return end
    UI.basePosition()
    UI.saveConfig()
end

function UI.installAutoParty()
    if UI.autoPartyInstalled then return end
    UI.autoPartyInstalled = true
    UI.autoPartyLastStatus = UI.autoPartyLastStatus or "Auto Party pronta."

    if Game and Game.registerEvent and Game.Events and Game.Events.TALK then
        Game.registerEvent(Game.Events.TALK, function(authorName, authorLevel, talkType, x, y, z, text, channelId)
            UI.handlePartyCommand(authorName, text)
        end)
    end

    Timer("fabioUiAutoParty", function()
        UI.runAutoParty()
    end, (UI.config and UI.config.autoParty and UI.config.autoParty.intervalMs) or 500)
end

function UI.isOwnTalk(authorName)
    if not Player or not Player.getName then return true end
    local ownName = Player.getName()
    if not ownName or ownName == "" then return true end
    return lower(authorName) == lower(ownName)
end

function UI.findCandidate(name)
    local candidates = UI.config.autoParty.candidates or {}
    for index, candidate in ipairs(candidates) do
        if lower(candidate) == lower(name) then
            return index
        end
    end
    return nil
end

function UI.addPartyCandidate(name)
    name = trim(name)
    if name == "" then return false end
    if UI.findCandidate(name) then
        UI.autoPartyLastStatus = name .. " ja esta na lista."
        return false
    end
    table.insert(UI.config.autoParty.candidates, name)
    UI.autoPartyLastStatus = "Adicionado: " .. name
    UI.saveConfig()
    return true
end

function UI.removePartyCandidate(name)
    name = trim(name)
    local index = UI.findCandidate(name)
    if not index then
        UI.autoPartyLastStatus = name .. " nao encontrado."
        return false
    end
    table.remove(UI.config.autoParty.candidates, index)
    UI.autoPartyLastStatus = "Removido: " .. name
    UI.saveConfig()
    return true
end

function UI.handlePartyCommand(authorName, text)
    text = tostring(text or "")
    if not UI.isOwnTalk(authorName) then return end

    local lowerText = lower(text)
    local prefix = lowerText:match("^([!.]party)")
    if not prefix then return end

    local escapedPrefix = prefix:gsub("%.", "%%.")
    local command = lowerText:match("^" .. escapedPrefix .. "%s+(%S+)")
    local rawRest = text:match("^" .. escapedPrefix .. "%s+%S+%s*(.*)$") or ""

    if command == "add" then
        UI.addPartyCandidate(rawRest)
    elseif command == "remove" or command == "rem" or command == "del" then
        UI.removePartyCandidate(rawRest)
    elseif command == "clear" then
        UI.config.autoParty.candidates = {}
        UI.autoPartyLastStatus = "Lista limpa."
        UI.saveConfig()
    elseif command == "list" or not command then
        UI.showMessage("Auto Party: " .. UI.partyListText())
    elseif command == "on" then
        UI.config.autoParty.enabled = true
        UI.autoPartyLastStatus = "Auto Party ativada."
        UI.saveConfig()
    elseif command == "off" then
        UI.config.autoParty.enabled = false
        UI.autoPartyLastStatus = "Auto Party pausada."
        UI.saveConfig()
    else
        UI.showMessage("Comandos: .party add Nome | remove Nome | clear | list | on | off")
    end

    UI.render()
end

function UI.partyExcludedIcons()
    local icons = Enums and Enums.PartyIcons or {}
    local excluded = {}
    local function mark(value)
        if value ~= nil then excluded[value] = true end
    end
    mark(icons.SHIELD_GRAY)
    mark(icons.SHIELD_BLUE)
    mark(icons.SHIELD_YELLOW)
    mark(icons.SHIELD_BLUE_SHAREDEXP)
    mark(icons.SHIELD_YELLOW_SHAREDEXP)
    mark(icons.SHIELD_BLUE_NOSHAREDEXP_BLINK)
    mark(icons.SHIELD_YELLOW_NOSHAREDEXP_BLINK)
    mark(icons.SHIELD_BLUE_NOSHAREDEXP)
    mark(icons.SHIELD_YELLOW_NOSHAREDEXP)
    return excluded
end

function UI.isCandidateName(name)
    return UI.findCandidate(name) ~= nil
end

function UI.runAutoParty()
    local party = UI.config and UI.config.autoParty
    if not party or not party.enabled then return end
    if Client and Client.isConnected and not Client.isConnected() then return end
    if not Map or not Map.getCreatureIds then return end

    local candidates = party.candidates or {}
    if #candidates == 0 then
        UI.autoPartyLastStatus = "Lista vazia."
        return
    end

    local excluded = UI.partyExcludedIcons()
    local players = Map.getCreatureIds(true, true) or {}

    for _, playerId in ipairs(players) do
        local player = Creature(playerId)
        if player and player.getName and player.getId then
            local name = player:getName()
            if name and UI.isCandidateName(name) then
                local icon = player.getPartyIcon and player:getPartyIcon() or nil
                if icon and not excluded[icon] and Player and Player.inviteParty then
                    Player.inviteParty(player:getId())
                    UI.autoPartyLastStatus = "Invite: " .. name
                end

                local icons = Enums and Enums.PartyIcons or {}
                if icon == icons.SHIELD_WHITEYELLOW and Player and Player.joinParty then
                    Player.joinParty(player:getId())
                    UI.autoPartyLastStatus = "Entrando na party de " .. name
                end
            end
        end
    end

    if Player and Player.getId and Player.enableSharedExpParty then
        local ownCreature = Creature(Player.getId())
        local icons = Enums and Enums.PartyIcons or {}
        local ownIcon = ownCreature and ownCreature.getPartyIcon and ownCreature:getPartyIcon() or nil
        if ownIcon and ownIcon ~= icons.SHIELD_NONE then
            Player.enableSharedExpParty(true)
        end
    end
end

UI.fungoItemIds = { 39176, 39533 }
UI.fungoRange = 8
UI.fungoLastStatus = UI.fungoLastStatus or "Aguardando ativacao."

function UI.fungoConfig()
    UI.config = UI.config or copyDefaults()
    UI.config.fungo = UI.config.fungo or {
        enabled = UI.defaults.fungo.enabled,
    }
    return UI.config.fungo
end

function UI.setFungoStepperEnabled(enabled)
    local fungo = UI.fungoConfig()
    fungo.enabled = enabled == true
    UI.fungoLastStatus = fungo.enabled and "Procurando fungos." or "Pausado."
    UI.saveConfig()
    UI.render()
end

function UI.toggleFungoStepper()
    local fungo = UI.fungoConfig()
    UI.setFungoStepperEnabled(not fungo.enabled)
end

function UI.fungoDistance(pos1, pos2)
    return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
end

function UI.isFungoItemId(itemId)
    for _, id in ipairs(UI.fungoItemIds or {}) do
        if tonumber(itemId) == id then
            return true
        end
    end
    return false
end

function UI.hasFungoOnGround(posX, posY, posZ)
    if not Map or not Map.getThings then return false end

    local items = Map.getThings(posX, posY, posZ)
    if not items then return false end

    for _, item in ipairs(items) do
        if item and UI.isFungoItemId(item.id) then
            return true
        end
    end

    return false
end

function UI.findNearestFungo()
    if not Map or not Map.getCameraPosition then return nil end

    local playerPos = Map.getCameraPosition()
    if not playerPos or not playerPos.x or not playerPos.y or not playerPos.z then
        return nil
    end

    local found = {}
    local range = tonumber(UI.fungoRange) or 5

    for dx = -range, range do
        for dy = -range, range do
            local pos = {
                x = playerPos.x + dx,
                y = playerPos.y + dy,
                z = playerPos.z,
            }

            if UI.hasFungoOnGround(pos.x, pos.y, pos.z) then
                table.insert(found, {
                    position = pos,
                    distance = UI.fungoDistance(playerPos, pos),
                })
            end
        end
    end

    if #found == 0 then return nil end

    table.sort(found, function(a, b)
        return a.distance < b.distance
    end)

    return found[1].position
end

function UI.runFungoStepper()
    local fungo = UI.fungoConfig()
    if not fungo.enabled then return end
    if Client and Client.isConnected and not Client.isConnected() then return end
    if not Map or not Map.goTo then
        UI.fungoLastStatus = "Map.goTo indisponivel."
        return
    end

    local target = UI.findNearestFungo()
    if not target then
        UI.fungoLastStatus = "Nenhum fungo no alcance."
        return
    end

    Map.goTo(target.x, target.y, target.z)
    UI.fungoLastStatus = "Indo ate o fungo mais perto."
end

function UI.installFungoStepper()
    if UI.fungoStepperInstalled then return end
    UI.fungoStepperInstalled = true

    Timer("fabioUiFungoStepper", function()
        UI.safe("pisar no fungo", UI.runFungoStepper)
    end, 100)
end

function UI.build()
    UI.loadConfig()
    UI.buildLegacyModules()
    UI.createHubHud()
    UI.installAutoParty()
    UI.installFungoStepper()

    Timer("fabioUiHubRender", function()
        UI.render()
    end, 300)

    Timer("fabioUiHubPersist", function()
        UI.persistPosition()
    end, 3000)

    Timer("fabioUiHideLegacy", function()
        UI.hideAllCaptured()
    end, 500)

    UI.render()
    UI.showMessage("Hub carregado. Use somente " .. UI.entryScriptName .. " como entrada.")
end

end


-- =========================
-- Entrada unica
-- =========================
FabioUI.suppressLegacyHud = true
FabioUI.loadConfig()

FabioRockeiroBOT = {
    version = "1.8.0-unificado",
    author = "Fabio Rockeiro",
    running = false,
}

function FabioRockeiroBOT.loadModules()
    local success = true
    local modules = {
        { key = "avalorium", loader = FabioRockeiroBOT.loadAvaloriumModule },
        { key = "follow", loader = FabioRockeiroBOT.loadFollowModule },
        { key = "resetfps", loader = FabioRockeiroBOT.loadResetFpsModule },
        { key = "crafthouse", loader = FabioRockeiroBOT.loadCraftHouseModule },
    }

    for _, module in ipairs(modules) do
        local ok = FabioUI.loadEmbeddedLegacyScript(module.key, module.loader)
        if not ok then
            success = false
        end
    end

    FabioUI.hideAllCaptured()
    return success
end

function FabioRockeiroBOT.initialize()
    if FabioRockeiroBOT.running then return end
    FabioRockeiroBOT.running = true

    FabioRockeiroBOT.loadModules()
    FabioUI.hideAllCaptured()
    FabioUI.build()
    FabioUI.showMessage("FabioRockeiroBOT v" .. FabioRockeiroBOT.version .. " carregado. Use somente este script.")
end

function FabioRockeiroBOT.shutdown()
    FabioRockeiroBOT.running = false
    FabioUI.saveConfig()
end

-- =========================
-- Modulo embutido: Avalorium/Task/Rune/Arrow/Forja
-- =========================
function FabioRockeiroBOT.loadAvaloriumModule()
--[[
=========================================================
 AVALORIUM OT SCRIPT - Fabio Rockeiro
=========================================================
HUDs minimizados para Task Book, Rune Refill, Arrow Refill
e Auto Forja.

Fluxo:
1) Clique em cada icone para abrir/fechar o painel completo.
2) No Task Book, escolha o nivel e a task no menu.
3) Ative o que quiser usar.
4) O Task usa o book, verifica o progresso, entrega quando
   completar e pega a mesma task novamente.

Criado por Fábio Rockeiro
=========================================================
]]

do

-- =========================
-- CONFIGURACAO
-- =========================
local taskBookItemId = 63053
local checkIntervalSeconds = 60
local reopenAfterCompleteSeconds = 4
local modalFlowTimeoutSeconds = 20

local hudStartX = 420
local hudStartY = 70
local tasksPerPage = 8 -- UI melhorada: menos botoes por pagina
local panelConfigPath = "TaskBookController.config.json"
local panelStatusPath = "TaskBookController.status.json"

local levelOptions = { "Easy", "Medium", "Hard", "Nightmare", "Master" }

local taskCatalog = {
    Easy = {
        { name = "Rotworm Caves" },
        { name = "Troll Caves" },
        { name = "Dwarf Mines" },
        { name = "Orc Caves" },
        { name = "Demon Skeleton Caves" },
        { name = "Elf Caves" },
        { name = "Kongra Banuta" },
        { name = "Bonelord Caves" },
        { name = "Salamander Caves" },
        { name = "Tortoise Islands" },
        { name = "Yalahary Humans Caves", match = "Yalahary Humans" },
        { name = "Dwarf Caves" },
        { name = "Chakoya Iceberg" },
        { name = "Scarab Lair" },
        { name = "Bog Raider Cave" },
        { name = "Vampire Crypts" },
        { name = "The Orc Cults" },
        { name = "The Minotaur Cults" },
        { name = "The Human Cults" },
        { name = "Corym Dungeons" },
        { name = "Earth Elemental Cave" },
        { name = "Tarantula Caves" },
        { name = "Giant Spider Caves" },
        { name = "Brimstone Bug Cave" },
        { name = "Barbarian Caves" },
        { name = "Stonefiner Caves" },
        { name = "Stampor Caves" },
        { name = "Djins Quarters" },
        { name = "Amazon Camp" },
        { name = "Mutated Human Caves" },
        { name = "Minotaur Lair" },
        { name = "Cyclops Caves" },
        { name = "Worker Golem Caves" },
        { name = "Nargor Pirates" },
        { name = "Necromancer Yalahari" },
    },

    Medium = {
        { name = "Pirat Rascacoon" },
        { name = "Exotic's Cave" },
        { name = "Hydra Caves" },
        { name = "Frost Dragon Caves" },
        { name = "Quara Caves" },
        { name = "Crystal Spider Caves" },
        { name = "Nightmare Caves" },
        { name = "Iksupan Cave" },
        { name = "Medusa Caves" },
        { name = "Ogre Savage Caves" },
        { name = "Asura's Palace" },
        { name = "Book World Bramble", match = "Book World" },
        { name = "Chocolate Mines Nibblers", match = "Chocolate Mines" },
        { name = "Feyrist Weakened", match = "Feyrist Weakened" },
        { name = "The Hive Waspoid", match = "The Hive" },
        { name = "Lava Lurker Deep" },
        { name = "Behemoth Lands" },
        { name = "Sea Serpent Area" },
        { name = "Draken Walls & Chosen" },
        { name = "Putrid Mummy Caves" },
        { name = "Minotaur Oramond Cave", match = "Minotaur Oramond" },
        { name = "Glooth Factory" },
        { name = "Glooth Bandit Caves" },
        { name = "Dragon Caves" },
        { name = "Dragon Lord Caves" },
        { name = "Wyrm Caves" },
        { name = "Hero Fortress" },
        { name = "Carnivoras Rock" },
        { name = "Werecrocodile Cave" },
        { name = "Weretiger Cave" },
        { name = "Wereboar Caves" },
        { name = "Werelion Caves" },
        { name = "Werehyaena Caves" },
        { name = "Barkless Devotee" },
    },

    Hard = {
        { name = "Ripper & Gazer & Burster", match = "Ripper & Gazer" },
        { name = "Bashmu Cave" },
        { name = "Girtablilu's Cave" },
        { name = "Priestess Of The Wild Sun", match = "Priestess Of The Wild" },
        { name = "Ogre Sage Cave" },
        { name = "Warlock Cave" },
        { name = "Crypt Warden Cave" },
        { name = "Skeleton Elite Warrior Cave", match = "Skeleton Elite Warrior" },
        { name = "Rotthing Nutshell Cave" },
        { name = "Quara Plunderer Cave" },
        { name = "Wardragon Cave" },
        { name = "Sineater Inferniarch Cave", match = "Sineater Inferniarch" },
        { name = "Norcferatu Nightweaver Cave", match = "Norcferatu Nightweav" },
        { name = "Bulltaur Alchemist Cave", match = "Bulltaur Alchemist" },
        { name = "Elite Draken's Cave" },
        { name = "Dark Carnisylvan Cave", match = "Dark Carnisylvan" },
        { name = "Roshamuul Caves" },
        { name = "Prison Cave" },
        { name = "Two-Headed Turtle Cave", match = "Two-Headed Turtle" },
        { name = "Naga Archer Caves" },
        { name = "Ingol Caves" },
        { name = "The Void Breach Brood", match = "The Void" },
        { name = "Ghastly Dragon Cave" },
        { name = "True Dawnfire Asura Cave", match = "True Dawnfire Asura" },
        { name = "Ferumbras Ascendant Cave", match = "Ferumbras Ascendant" },
        { name = "Crazed Winter Vanguard", match = "Crazed Winter Vangua" },
        { name = "Crazed Summer Vanguard", match = "Crazed Summer Vangu" },
        { name = "Cobra Caves" },
        { name = "Falcon Caves" },
        { name = "Flimsy Lost Soul Cave" },
        { name = "Rathleton Catacombs" },
        { name = "Adult Goanna" },
        { name = "Warzone 1" },
        { name = "Warzone 2" },
        { name = "Warzone 3" },
        { name = "Warzone 4" },
        { name = "Warzone 5" },
        { name = "Warzone 6" },
        { name = "Warzone 7" },
        { name = "Warzone 8" },
        { name = "Warzone 9" },
        { name = "Ice Library" },
        { name = "Fire Library" },
        { name = "Energy Library" },
        { name = "Earth Library" },
    },

    Nightmare = {
        { name = "Claustrophobic Inferno" },
        { name = "Rotten Wasteland" },
        { name = "Ebb and Flow" },
        { name = "Furious Crater" },
        { name = "Monster Graveyard" },
        { name = "Crystal Enigma" },
        { name = "Sparkling Pools" },
        { name = "Darklight Core" },
        { name = "Gloom Pillars" },
        { name = "Mirrored Nightmare" },
        { name = "Pyramid of Azhr'khal - True Custom" },
        { name = "Outer Void" },
        { name = "Netherbound" },
        { name = "Frezee & Firen" },
    },

    Master = {
        { name = "The Fallen Usurpers" },
    },
}

FabioTaskLevelOptions = levelOptions
FabioTaskCatalog = taskCatalog

-- =========================
-- ESTADO INTERNO
-- =========================
local selectedLevelIndex = 4
local selectedTaskIndex = 10
local taskPage = 1

local enabled = false
local manualCheckPending = false
local estado = "idle"
local nextCheckAt = 0
local completedCount = 0
local taskIsActive = false
local taskCompletionPending = false

local nomeDaTask = ""
local nivelDaTask = ""
local lastStatus = "Desativado"
local lastProgressCurrent = nil
local lastProgressTotal = nil
local lastProgressText = "sem leitura"
local lastBookOpen = 0
local lastPanelConfigRaw = nil
local lastPanelCheckNow = nil

-- =========================
-- HELPERS
-- =========================
local function lower(text)
    return string.lower(text or "")
end

local function contains(text, part)
    return lower(text):find(lower(part), 1, true) ~= nil
end

local function log(msg)
    print("[TASK-BOOK] " .. msg)
end

local function show(msg)
    log(msg)
    if Client and Client.showMessage then
        Client.showMessage("[TASK BOOK] " .. msg)
    end
end

local function clampIndex(index, minValue, maxValue)
    if maxValue < minValue then return minValue end
    if index < minValue then return maxValue end
    if index > maxValue then return minValue end
    return index
end

local function getCurrentLevel()
    return levelOptions[selectedLevelIndex]
end

local function getCurrentTasks()
    return taskCatalog[getCurrentLevel()] or {}
end

local function getCurrentTask()
    local tasks = getCurrentTasks()
    if #tasks == 0 then
        return { name = "Sem tasks" }
    end

    selectedTaskIndex = clampIndex(selectedTaskIndex, 1, #tasks)
    return tasks[selectedTaskIndex]
end

local function getCurrentTaskMatcher()
    local task = getCurrentTask()
    return task.match or task.name
end

local function refreshSelectedTask(clearProgress)
    local task = getCurrentTask()
    nomeDaTask = task.name
    nivelDaTask = getCurrentLevel()

    if clearProgress then
        lastProgressCurrent = nil
        lastProgressTotal = nil
        lastProgressText = "aguardando leitura"
        taskIsActive = false
        taskCompletionPending = false
    end
end

local function setSelectedLevel(index)
    selectedLevelIndex = clampIndex(index, 1, #levelOptions)
    selectedTaskIndex = 1
    taskPage = 1
    refreshSelectedTask(true)
    lastStatus = enabled and "Ativo" or "Desativado"
end

local function setSelectedTask(index)
    local tasks = getCurrentTasks()
    selectedTaskIndex = clampIndex(index, 1, #tasks)
    refreshSelectedTask(true)
    lastStatus = enabled and "Ativo" or "Desativado"
end

local function progressPercent()
    if not lastProgressCurrent or not lastProgressTotal or lastProgressTotal <= 0 then
        return nil
    end

    return math.floor((lastProgressCurrent / lastProgressTotal) * 100)
end

local function progressLine()
    if lastProgressCurrent and lastProgressTotal then
        local pct = progressPercent()
        return string.format("%d/%d%s", lastProgressCurrent, lastProgressTotal, pct and (" (" .. pct .. "%)") or "")
    end

    return lastProgressText
end

local function isProgressComplete()
    return lastProgressCurrent and lastProgressTotal and lastProgressTotal > 0 and lastProgressCurrent >= lastProgressTotal
end

local function shouldPauseAutomaticChecks()
    return taskIsActive and not taskCompletionPending and not isProgressComplete()
end

local function secondsUntilNextCheck()
    if not enabled then return 0 end
    if shouldPauseAutomaticChecks() then return 0 end
    local left = nextCheckAt - os.time()
    if left < 0 then left = 0 end
    return left
end

local function checkScheduleLine()
    if not enabled then
        return "Bot pausado"
    end

    if shouldPauseAutomaticChecks() then
        return "Checagem: aguardando 100%"
    end

    return "Proxima checagem: " .. secondsUntilNextCheck() .. "s"
end

local function getModalBody(d)
    return d.message or d.text or d.info or d.description or ""
end

local function findChoiceByText(d, texto, parcial)
    if not d.choices then return nil, nil end

    for i = 1, #d.choices do
        local c = d.choices[i]
        local choiceText = c.text or ""

        if parcial then
            if contains(choiceText, texto) then
                return c.id, choiceText
            end
        else
            if lower(choiceText) == lower(texto) then
                return c.id, choiceText
            end
        end
    end

    return nil, nil
end

local function findTaskChoice(d)
    local task = getCurrentTask()
    local candidates = { task.match or task.name, task.name }

    for _, candidate in ipairs(candidates) do
        local choiceId, choiceText = findChoiceByText(d, candidate, true)
        if choiceId then
            return choiceId, choiceText
        end
    end

    return nil, nil
end

local function findButton(d, texto)
    if not d.buttons then return nil end

    for i = 1, #d.buttons do
        local b = d.buttons[i]
        if lower(b.text) == lower(texto) then
            return b.id
        end
    end

    return nil
end

local function scheduleNextCheck(delaySeconds)
    if enabled then
        nextCheckAt = os.time() + (delaySeconds or checkIntervalSeconds)
    else
        nextCheckAt = 0
    end
end

local function finishCycle(status, delaySeconds)
    estado = "idle"
    manualCheckPending = false
    lastStatus = status or (enabled and "Ativo" or "Desativado")

    if enabled and shouldPauseAutomaticChecks() then
        nextCheckAt = 0
    else
        scheduleNextCheck(delaySeconds)
    end
end

local function markTaskCompleteForBookCheck(status)
    taskIsActive = true
    taskCompletionPending = true

    if not enabled then return end

    lastStatus = status or "Task 100%, checando book"
    if estado == "idle" then
        scheduleNextCheck(1)
    end
end

local function clickButton(d, buttonText, choiceId)
    local buttonId = findButton(d, buttonText)
    if not buttonId then
        finishCycle("Botao nao encontrado: " .. buttonText)
        log("Botao nao encontrado: " .. buttonText)
        return false
    end

    Game.modalWindowAnswer(d.id, buttonId, choiceId or 0)
    lastBookOpen = os.time()
    log("Clicou em: " .. buttonText)
    return true
end

local function parseTaskProgressFromChoice(choiceText)
    if not choiceText then return nil, nil end

    local atual, total = choiceText:match("%[(%d+)%s*/%s*(%d+)")
    if atual and total then
        return tonumber(atual), tonumber(total)
    end

    atual, total = choiceText:match("(%d+)%s*/%s*(%d+)")
    if atual and total then
        return tonumber(atual), tonumber(total)
    end

    return nil, nil
end

local function parseTaskPercent(text)
    if not text then return nil end

    local pct = text:match("(%d+)%%")
    if pct then
        return tonumber(pct)
    end

    return nil
end

local function parseTaskProgressFromDetails(text)
    if not text then return nil, nil end

    local atual, total = text:match("Progress:%s*(%d+)%s*of%s*(%d+)")
    if atual and total then
        return tonumber(atual), tonumber(total)
    end

    atual, total = text:match("%[Progress:%s*(%d+)%s*of%s*(%d+)%s*%]")
    if atual and total then
        return tonumber(atual), tonumber(total)
    end

    atual, total = text:match("(%d+)%s*/%s*(%d+)")
    if atual and total then
        return tonumber(atual), tonumber(total)
    end

    return nil, nil
end

local function saveProgress(atual, total, fallbackText)
    if atual and total then
        lastProgressCurrent = atual
        lastProgressTotal = total
        lastProgressText = tostring(atual) .. "/" .. tostring(total)
        return
    end

    if fallbackText and fallbackText ~= "" then
        lastProgressText = fallbackText
    end
end

local function canHandleTaskBook()
    return enabled or manualCheckPending or estado ~= "idle"
end

local function openTaskBook()
    lastBookOpen = os.time()
    lastStatus = "Abrindo Task Book"
    Game.useItem(taskBookItemId)
    return true
end

local function requestBookCheck(status)
    if estado ~= "idle" then
        lastStatus = "Aguardando fluxo atual"
        return
    end

    manualCheckPending = true
    lastStatus = status or "Checando Task Book"
    if enabled then
        scheduleNextCheck(checkIntervalSeconds)
    end
    openTaskBook()
end

local function toggleEnabled()
    enabled = not enabled
    if enabled then
        taskIsActive = false
        taskCompletionPending = false
        lastStatus = "Ativo"
        scheduleNextCheck(1)
        show("Ativado: " .. nivelDaTask .. " / " .. nomeDaTask)
    else
        finishCycle("Desativado")
        show("Desativado.")
    end
end

-- =========================
-- PONTE COM PAINEL EXTERNO
-- =========================
local function readTextFile(path)
    local file = io.open(path, "r")
    if not file then return nil end

    local content = file:read("*a")
    file:close()
    return content
end

local function writeTextFile(path, content)
    local file = io.open(path, "w")
    if not file then return false end

    file:write(content)
    file:close()
    return true
end

local function findLevelIndex(levelName)
    for i, level in ipairs(levelOptions) do
        if lower(level) == lower(levelName) then
            return i
        end
    end

    return nil
end

local function findTaskIndex(levelName, taskName)
    local tasks = taskCatalog[levelName] or {}
    local taskLower = lower(taskName)

    for i, task in ipairs(tasks) do
        if lower(task.name) == taskLower or lower(task.match or "") == taskLower then
            return i
        end
    end

    return nil
end

local function applyPanelConfig(config)
    if type(config) ~= "table" then return end
    local selectionChanged = false

    local newBookId = tonumber(config.taskBookItemId)
    if newBookId and newBookId > 0 then
        taskBookItemId = newBookId
    end

    local newInterval = tonumber(config.checkIntervalSeconds)
    if newInterval and newInterval >= 5 then
        checkIntervalSeconds = newInterval
    end

    local newReopenDelay = tonumber(config.reopenAfterCompleteSeconds)
    if newReopenDelay and newReopenDelay >= 1 then
        reopenAfterCompleteSeconds = newReopenDelay
    end

    if config.level then
        local levelIndex = findLevelIndex(config.level)
        if levelIndex and levelIndex ~= selectedLevelIndex then
            selectedLevelIndex = levelIndex
            selectedTaskIndex = 1
            taskPage = 1
            selectionChanged = true
        end
    end

    local levelName = getCurrentLevel()
    if config.task and config.task ~= "" then
        local taskIndex = findTaskIndex(levelName, config.task)

        if not taskIndex then
            table.insert(taskCatalog[levelName], {
                name = tostring(config.task),
                match = tostring(config.match or config.task),
            })
            taskIndex = #taskCatalog[levelName]
        end

        if taskIndex ~= selectedTaskIndex then
            selectedTaskIndex = taskIndex
            selectionChanged = true
        end

        if config.match and config.match ~= "" then
            taskCatalog[levelName][selectedTaskIndex].match = tostring(config.match)
        end
    end

    refreshSelectedTask(selectionChanged)

    if selectionChanged and enabled and estado == "idle" then
        lastStatus = "Task alterada, checando"
        scheduleNextCheck(1)
    end

    if config.enabled ~= nil then
        local panelEnabled = config.enabled == true
        if panelEnabled ~= enabled then
            enabled = panelEnabled
            if enabled then
                taskIsActive = false
                taskCompletionPending = false
                lastStatus = "Ativo pelo painel"
                scheduleNextCheck(1)
            else
                finishCycle("Desativado pelo painel")
            end
        end
    end

    if config.checkNow ~= nil then
        local checkNow = tostring(config.checkNow)
        if lastPanelCheckNow == nil then
            lastPanelCheckNow = checkNow
        elseif checkNow ~= "" and checkNow ~= lastPanelCheckNow then
            lastPanelCheckNow = checkNow
            requestBookCheck("Checagem pelo painel")
        end
    end
end

local function syncPanelConfig()
    local raw = readTextFile(panelConfigPath)
    if not raw or raw == "" or raw == lastPanelConfigRaw then return end

    local ok, decoded = pcall(function()
        return JSON.decode(raw)
    end)

    if not ok then
        lastStatus = "Config externa invalida"
        log("Config externa invalida: " .. tostring(decoded))
        return
    end

    lastPanelConfigRaw = raw
    applyPanelConfig(decoded)
end

local function writePanelStatus()
    local data = {
        enabled = enabled,
        level = nivelDaTask,
        task = nomeDaTask,
        status = lastStatus,
        state = estado,
        progress = progressLine(),
        completedCount = completedCount,
        nextCheckIn = secondsUntilNextCheck(),
        taskActive = taskIsActive,
        waitingForCompletion = shouldPauseAutomaticChecks(),
        completionPending = taskCompletionPending,
        taskBookItemId = taskBookItemId,
        updatedAt = os.time(),
    }

    if lastProgressCurrent then data.progressCurrent = lastProgressCurrent end
    if lastProgressTotal then data.progressTotal = lastProgressTotal end

    local ok, encoded = pcall(function()
        return JSON.encode(data)
    end)

    if ok and encoded then
        writeTextFile(panelStatusPath, encoded)
    end
end

-- =========================
-- HUD / PAINEL - UI MELHORADA
-- =========================
-- Observacao: esta API nao renderiza PNG/SVG local no HUD.
-- Para mudar o icone, use um item/sprite existente no cliente e troque o ID abaixo.
local brandName = "FABIO ROCKEIRO TASK BOT"
local brandSignature = "FABIO ROCKEIRO TASK BOT"
local brandIconItemId = taskBookItemId -- troque por um item/sprite custom do seu cliente

local hud = {}
local taskHudExpanded = false
local hudOffsets = {
    icon = { x = 0, y = 0 },
    title = { x = 36, y = 0 },
    status = { x = 36, y = 16 },
    task = { x = 36, y = 32 },
    progress = { x = 36, y = 48 },
    menu = { x = 0, y = 70 },
    toggle = { x = 70, y = 70 },
    check = { x = 162, y = 70 },
}

local function setHudTextColor(item, r, g, b)
    if item then item:setColor(r, g, b) end
end

local function setHudVisible(item, visible)
    if not item then return end
    if visible then
        item:show()
    else
        item:hide()
    end
end

local function shortenText(text, maxLength)
    text = tostring(text or "")
    if #text <= maxLength then return text end
    return text:sub(1, maxLength - 3) .. "..."
end

local function makeHudText(key, text, r, g, b, callback)
    local offset = hudOffsets[key]
    local item = HUD.new(hudStartX + offset.x, hudStartY + offset.y, text, true)
    item:setColor(r or 255, g or 255, b or 255)
    item:setFontSize(9)
    if callback then item:setCallback(callback) end
    hud[key] = item
    return item
end

local function modalDescription()
    return table.concat({
        "Status: " .. (enabled and "ATIVO" or "DESATIVADO"),
        "Nivel: " .. tostring(nivelDaTask),
        "Task: " .. tostring(nomeDaTask),
        "Progresso: " .. tostring(progressLine()),
        checkScheduleLine(),
        "Entregues: " .. tostring(completedCount),
    }, "\n")
end

local mainModal = nil
local function destroyMainModal()
    if mainModal then
        mainModal:destroy()
        mainModal = nil
    end
end

local openMainModal
local openLevelModal
local openTaskModal

local function updateHudPositions()
    if not hud.icon then return end
    local pos = hud.icon:getPos()
    if not pos or not pos.x or not pos.y then return end
    if pos.x == 0 and pos.y == 0 then return end

    for key, item in pairs(hud) do
        if key ~= "icon" and hudOffsets[key] then
            item:setPos(pos.x + hudOffsets[key].x, pos.y + hudOffsets[key].y)
        end
    end
end

local function updateHudVisibility()
    for key, item in pairs(hud) do
        if key ~= "icon" then
            setHudVisible(item, taskHudExpanded)
        end
    end
end

local function updateHud()
    if not hud.icon then return end

    hud.icon:setItemId(brandIconItemId)
    hud.title:setText(brandSignature)
    hud.status:setText(enabled and "[ON] Rodando" or "[OFF] Pausado")
    hud.task:setText(shortenText(nivelDaTask .. " / " .. nomeDaTask, 34))
    hud.progress:setText("Prog: " .. shortenText(progressLine(), 26))
    hud.menu:setText("[Menu]")
    hud.toggle:setText(enabled and "[Pausar]" or "[Ativar]")
    hud.check:setText("[Checar]")

    setHudTextColor(hud.title, 255, 224, 128)
    setHudTextColor(hud.status, enabled and 80 or 255, enabled and 255 or 90, enabled and 140 or 90)
    setHudTextColor(hud.task, 220, 230, 240)
    setHudTextColor(hud.progress, 140, 220, 255)
    setHudTextColor(hud.menu, 150, 210, 255)
    setHudTextColor(hud.toggle, enabled and 255 or 80, enabled and 130 or 255, enabled and 130 or 140)
    setHudTextColor(hud.check, 170, 230, 255)
    updateHudVisibility()
end

local function addModalButton(modal, actions, text, action)
    actions[modal:addButton(text)] = action
end

local function taskButtonLabel(index, task)
    local selected = index == selectedTaskIndex and "[OK] " or ""
    return selected .. index .. ". " .. task.name
end

openMainModal = function()
    destroyMainModal()
    refreshSelectedTask(false)

    local modal = CustomModalWindow.new(brandName, modalDescription())
    modal:setCaption(brandName)
    modal:setDescription(modalDescription())
    mainModal = modal

    local actions = {}
    addModalButton(modal, actions, enabled and "Pausar bot" or "Ativar bot", "toggle")
    addModalButton(modal, actions, "Checar agora", "check")
    addModalButton(modal, actions, "Selecionar task", "tasks")
    addModalButton(modal, actions, "Trocar nivel", "levels")
    addModalButton(modal, actions, "Fechar", "close")

    modal:setCallback(function(buttonId)
        local action = actions[buttonId]

        if action == "levels" then
            destroyMainModal()
            openLevelModal()
        elseif action == "tasks" then
            destroyMainModal()
            openTaskModal()
        elseif action == "toggle" then
            toggleEnabled()
            updateHud()
            destroyMainModal()
        elseif action == "check" then
            requestBookCheck("Checagem manual")
            updateHud()
            destroyMainModal()
        elseif action == "close" then
            destroyMainModal()
        end
    end)
end

openLevelModal = function()
    destroyMainModal()

    local modal = CustomModalWindow.new("Selecionar nivel", "Escolha a categoria da task.")
    modal:setCaption("Nivel da task")
    modal:setDescription("Atual: " .. tostring(nivelDaTask))
    mainModal = modal

    local actions = {}
    for i, level in ipairs(levelOptions) do
        local marker = i == selectedLevelIndex and "[OK] " or ""
        addModalButton(modal, actions, marker .. level, "level:" .. i)
    end
    addModalButton(modal, actions, "Voltar", "back")

    modal:setCallback(function(buttonId)
        local action = actions[buttonId] or ""
        local levelIndex = tonumber(action:match("^level:(%d+)$"))

        if levelIndex then
            setSelectedLevel(levelIndex)
            updateHud()
            destroyMainModal()
            openTaskModal()
        elseif action == "back" then
            destroyMainModal()
            openMainModal()
        end
    end)
end

openTaskModal = function()
    destroyMainModal()

    local tasks = getCurrentTasks()
    local totalTasks = math.max(1, #tasks)
    selectedTaskIndex = clampIndex(selectedTaskIndex, 1, totalTasks)

    local currentTask = tasks[selectedTaskIndex] or { name = "Sem tasks" }
    local previousTask = tasks[clampIndex(selectedTaskIndex - 1, 1, totalTasks)]
    local nextTask = tasks[clampIndex(selectedTaskIndex + 1, 1, totalTasks)]

    local description = table.concat({
        "TASK SELECIONADA",
        "",
        ">>> " .. tostring(currentTask.name) .. " <<<",
        "",
        "Nivel: " .. tostring(nivelDaTask),
        "Task " .. tostring(selectedTaskIndex) .. " de " .. tostring(totalTasks),
        "",
        "Anterior: " .. shortenText(previousTask and previousTask.name or "-", 44),
        "Proxima: " .. shortenText(nextTask and nextTask.name or "-", 44)
    }, "\n")

    local modal = CustomModalWindow.new("Escolher Task", description)
    modal:setCaption("TASK SELECIONADA")
    modal:setDescription(description)
    mainModal = modal

    local actions = {}

    addModalButton(modal, actions, "Selecionar", "select")
    addModalButton(modal, actions, "Anterior", "prev")
    addModalButton(modal, actions, "Proxima", "next")
    addModalButton(modal, actions, "Trocar Nivel", "levels")

    modal:setCallback(function(buttonId)
        local action = actions[buttonId] or ""

        if action == "select" then
            setSelectedTask(selectedTaskIndex)
            lastStatus = enabled and "Task selecionada, checando" or "Task selecionada"
            if enabled and estado == "idle" then
                scheduleNextCheck(1)
            end
            updateHud()
            destroyMainModal()
            openMainModal()
        elseif action == "prev" then
            selectedTaskIndex = clampIndex(selectedTaskIndex - 1, 1, totalTasks)
            refreshSelectedTask(true)
            updateHud()
            destroyMainModal()
            openTaskModal()
        elseif action == "next" then
            selectedTaskIndex = clampIndex(selectedTaskIndex + 1, 1, totalTasks)
            refreshSelectedTask(true)
            updateHud()
            destroyMainModal()
            openTaskModal()
        elseif action == "levels" then
            destroyMainModal()
            openLevelModal()
        end
    end)
end


hud.icon = HUD.new(hudStartX + hudOffsets.icon.x, hudStartY + hudOffsets.icon.y, brandIconItemId, true)
hud.icon:setDraggable(true)
hud.icon:setCallback(function()
    taskHudExpanded = not taskHudExpanded
    updateHudPositions()
    updateHud()
end)
hud.icon:setScale(1.15)

makeHudText("title", "", 255, 215, 90, openMainModal)
makeHudText("status", "", 255, 80, 80, openMainModal)
makeHudText("task", "", 230, 230, 230, openTaskModal)
makeHudText("progress", "", 170, 230, 255, function()
    requestBookCheck("Checagem manual")
    updateHud()
end)
makeHudText("menu", "", 150, 210, 255, openMainModal)
makeHudText("toggle", "", 80, 255, 120, function()
    toggleEnabled()
    updateHud()
end)
makeHudText("check", "", 170, 230, 255, function()
    requestBookCheck("Checagem manual")
    updateHud()
end)

refreshSelectedTask(true)
syncPanelConfig()
updateHud()
writePanelStatus()

Timer("taskBookControllerHud", function()
    updateHudPositions()
    updateHud()
end, 500)

Timer("taskBookPanelSync", function()
    syncPanelConfig()
    writePanelStatus()
end, 1000)

-- =========================
-- TIMER DE CHECAGEM
-- =========================
Timer("taskBookControllerCheck", function()
    if not enabled then return end
    if estado ~= "idle" then
        if lastBookOpen > 0 and os.time() - lastBookOpen >= modalFlowTimeoutSeconds then
            log("Fluxo sem resposta do Task Book. Tentando novamente.")
            finishCycle("Sem resposta, tentando novamente", reopenAfterCompleteSeconds)
        end
        return
    end
    if shouldPauseAutomaticChecks() then return end
    if nextCheckAt <= 0 then return end
    if nextCheckAt > 0 and os.time() < nextCheckAt then return end

    requestBookCheck("Checagem automatica")
end, 1000)

-- =========================
-- EVENTOS DE TEXTO
-- =========================
Game.registerEvent(Game.Events.TEXT_MESSAGE, function(messageData)
    if not messageData or not messageData.text then return end
    if not enabled and not manualCheckPending then return end

    local text = messageData.text
    local textLower = lower(text)

    if not contains(textLower, lower(getCurrentTaskMatcher())) and not contains(textLower, "task") then
        return
    end

    local atual, total = parseTaskProgressFromDetails(text)
    if atual and total then
        saveProgress(atual, total)
        if atual >= total then
            markTaskCompleteForBookCheck("Task 100%, entregando")
        end
        return
    end

    local pct = parseTaskPercent(text)
    if pct and pct >= 100 then
        lastProgressText = "100%"
        markTaskCompleteForBookCheck("Task 100%, entregando")
    end
end)

-- =========================
-- HANDLER DAS MODAIS DO TASK BOOK
-- =========================
Game.registerEvent(Game.Events.MODAL_WINDOW, function(d)
    local ok, err = pcall(function()
        local title = lower(d.title or "")
        local body = getModalBody(d)

        local isActiveTasks = contains(title, "active tasks")
        local isChooseCat = contains(title, "choose category")
        local isAvailable = contains(title, "available tasks")
        local isTaskDetails = contains(title, "task details")

        if not (isActiveTasks or isChooseCat or isAvailable or isTaskDetails) then
            return
        end

        if not canHandleTaskBook() then
            return
        end

        lastStatus = "Janela: " .. (d.title or "sem titulo")
        log("Janela detectada: " .. (d.title or "sem titulo") .. " | estado: " .. estado)

        -- ACTIVE TASKS
        if isActiveTasks then
            if estado == "voltar_e_fechar" then
                clickButton(d, "Close", 0)
                if taskCompletionPending then
                    finishCycle("Aguardando liberar entrega", reopenAfterCompleteSeconds)
                else
                    finishCycle("Task em andamento", checkIntervalSeconds)
                end
                return
            end

            local choiceId, choiceText = findTaskChoice(d)

            if choiceId then
                taskIsActive = true
                local atual, total = parseTaskProgressFromChoice(choiceText)
                saveProgress(atual, total, choiceText)

                if atual and total then
                    log("Task ativa encontrada: " .. atual .. "/" .. total)

                    if atual >= total then
                        taskCompletionPending = true
                    end

                    if atual >= total or taskCompletionPending then
                        estado = "detalhes_task_existente"
                        lastStatus = "Task completa, abrindo detalhes"
                        clickButton(d, "Details", choiceId)
                        return
                    end

                    clickButton(d, "Close", 0)
                    finishCycle("Task em andamento", checkIntervalSeconds)
                    return
                end

                estado = "detalhes_task_existente"
                lastStatus = "Confirmando progresso"
                clickButton(d, "Details", choiceId)
                return
            end

            taskIsActive = false
            taskCompletionPending = false
            estado = "escolher_categoria"
            lastStatus = "Task nao ativa, criando nova"
            clickButton(d, "New", 0)
            return
        end

        -- CHOOSE CATEGORY
        if isChooseCat then
            if estado ~= "escolher_categoria" then
                return
            end

            local choiceId = select(1, findChoiceByText(d, nivelDaTask, false))
            if not choiceId then
                taskIsActive = false
                taskCompletionPending = false
                finishCycle("Categoria nao encontrada: " .. nivelDaTask)
                log("Categoria nao encontrada: " .. nivelDaTask)
                return
            end

            estado = "escolher_task"
            lastStatus = "Categoria: " .. nivelDaTask
            clickButton(d, "OK", choiceId)
            return
        end

        -- AVAILABLE TASKS
        if isAvailable then
            if estado ~= "escolher_task" then
                return
            end

            local choiceId, choiceText = findTaskChoice(d)
            if not choiceId then
                taskIsActive = false
                taskCompletionPending = false
                finishCycle("Task nao encontrada: " .. nomeDaTask)
                log("Task nao encontrada na lista: " .. nomeDaTask)
                return
            end

            saveProgress(nil, nil, choiceText)
            estado = "iniciar_task_nova"
            lastStatus = "Selecionando task"
            clickButton(d, "Select", choiceId)
            return
        end

        -- TASK DETAILS
        if isTaskDetails then
            if estado == "detalhes_task_existente" then
                local atual, total = parseTaskProgressFromDetails(body)
                saveProgress(atual, total, body)

                if atual and total then
                    log("Details da task ativa: " .. atual .. "/" .. total)

                    if atual >= total then
                        taskCompletionPending = true
                    end

                    if atual >= total or (taskCompletionPending and findButton(d, "Complete")) then
                        if clickButton(d, "Complete", 0) then
                            completedCount = completedCount + 1
                            taskIsActive = false
                            taskCompletionPending = false
                            lastProgressCurrent = nil
                            lastProgressTotal = nil
                            lastProgressText = "task entregue"
                            finishCycle("Entregue " .. completedCount .. "x. Reabrindo", reopenAfterCompleteSeconds)
                        end
                        return
                    end

                    estado = "voltar_e_fechar"
                    lastStatus = taskCompletionPending and "Aguardando liberar entrega" or "Task em andamento"
                    if findButton(d, "Back") then
                        clickButton(d, "Back", 0)
                    else
                        if taskCompletionPending then
                            finishCycle("Aguardando liberar entrega", reopenAfterCompleteSeconds)
                        else
                            finishCycle("Task em andamento", checkIntervalSeconds)
                        end
                    end
                    return
                end

                if taskCompletionPending and findButton(d, "Complete") then
                    if clickButton(d, "Complete", 0) then
                        completedCount = completedCount + 1
                        taskIsActive = false
                        taskCompletionPending = false
                        lastProgressCurrent = nil
                        lastProgressTotal = nil
                        lastProgressText = "task entregue"
                        finishCycle("Entregue " .. completedCount .. "x. Reabrindo", reopenAfterCompleteSeconds)
                    end
                    return
                end

                estado = "voltar_e_fechar"
                lastStatus = taskCompletionPending and "Aguardando liberar entrega" or "Nao li o progresso"
                if findButton(d, "Back") then
                    clickButton(d, "Back", 0)
                else
                    if taskCompletionPending then
                        finishCycle("Aguardando liberar entrega", reopenAfterCompleteSeconds)
                    else
                        finishCycle("Nao li o progresso", checkIntervalSeconds)
                    end
                end
                return
            end

            if estado == "iniciar_task_nova" then
                if clickButton(d, "Start", 0) then
                    local atual, total = parseTaskProgressFromDetails(body)
                    taskIsActive = true
                    taskCompletionPending = false
                    lastProgressCurrent = atual or 0
                    lastProgressTotal = total
                    lastProgressText = total and (tostring(lastProgressCurrent) .. "/" .. tostring(total)) or "task iniciada"
                    finishCycle("Task iniciada", checkIntervalSeconds)
                end
                return
            end
        end
    end)

    if not ok then
        log("ERRO: " .. tostring(err))
        finishCycle("Erro: " .. tostring(err))
    end
end)

end

--[[
=========================================================
 RUNE REFIL - FABIO ROCKEIRO
=========================================================
Integrado ao Task Bot no mesmo arquivo.
HUD inicia minimizado: clique no icone do Refil Rune para
abrir/fechar o painel completo com status e selecao de runas.
=========================================================
]]

do

local SCRIPT_NAME = "RUNE REFIL - FABIO ROCKEIRO"

local refillAt = 200 -- quantidade minima de runas para comprar de novo
local refillItemId = 63052 -- item Refil Rune
local checkInterval = 10000 -- intervalo de checagem em ms

local hudStartX = 420
local hudStartY = 165

local runes = {
    { id = 3161, name = "avalanche rune", label = "Avalanche" },
    { id = 3191, name = "great fireball rune", label = "Great Fireball" },
    { id = 3202, name = "thunderstorm rune", label = "Thunderstorm" },
    { id = 3175, name = "stone shower rune", label = "Stone Shower" },
}

local selectedRuneIndex = nil
local autoRefillEnabled = false
local runeHudExpanded = false

local hud = { runes = {} }
local attachedHudElements = {}

local colorActive = { 0, 255, 0 }
local colorInactive = { 255, 80, 80 }
local colorNeutral = { 210, 210, 210 }
local colorTitle = { 255, 255, 255 }

local function lower(value)
    return string.lower(tostring(value or ""))
end

local function showMessage(message)
    print("[RUNE REFIL] " .. message)

    if Client and Client.showMessage then
        Client.showMessage("[RUNE REFIL]\n" .. message)
    end
end

local function getSelectedRune()
    return selectedRuneIndex and runes[selectedRuneIndex] or nil
end

local function setHudColor(item, color)
    if item then
        item:setColor(color[1], color[2], color[3])
    end
end

local function setHudVisible(item, visible)
    if not item then return end
    if visible then
        item:show()
    else
        item:hide()
    end
end

local function updateHudVisibility()
    for _, element in ipairs(attachedHudElements) do
        setHudVisible(element.item, runeHudExpanded)
    end
end

local function attachHudElement(item, offsetX, offsetY)
    table.insert(attachedHudElements, {
        item = item,
        offsetX = offsetX,
        offsetY = offsetY,
    })
end

local function createText(offsetX, offsetY, text, color, callback)
    local item = HUD.new(hudStartX + offsetX, hudStartY + offsetY, text, true)
    item:setDraggable(false)
    setHudColor(item, color or colorNeutral)

    if callback then
        item:setCallback(callback)
    end

    attachHudElement(item, offsetX, offsetY)
    return item
end

local function createItem(offsetX, offsetY, itemId, callback)
    local item = HUD.new(hudStartX + offsetX, hudStartY + offsetY, itemId, true)
    item:setDraggable(false)

    if callback then
        item:setCallback(callback)
    end

    attachHudElement(item, offsetX, offsetY)
    return item
end

local function updateHud()
    local selectedRune = getSelectedRune()
    local selectedCount = selectedRune and (Game.getItemCount(selectedRune.id) or 0) or 0
    local refillCount = Game.getItemCount(refillItemId) or 0

    hud.title:setText(SCRIPT_NAME)

    if autoRefillEnabled and not selectedRune then
        autoRefillEnabled = false
    end

    if autoRefillEnabled then
        hud.status:setText("Compra: ATIVO | Refil: " .. refillCount .. " | Min: " .. refillAt)
        setHudColor(hud.status, colorActive)
    else
        hud.status:setText("Compra: INATIVO | Refil: " .. refillCount .. " | Min: " .. refillAt)
        setHudColor(hud.status, colorInactive)
    end

    hud.selected:setText("Selecionada: " .. (selectedRune and selectedRune.label or "--") .. " | Qtd: " .. selectedCount)
    setHudColor(hud.selected, autoRefillEnabled and colorActive or colorNeutral)

    for index, _ in ipairs(runes) do
        local state = index == selectedRuneIndex and "ON" or "OFF"
        local entry = hud.runes[index]

        entry.text:setText(state)
        setHudColor(entry.text, index == selectedRuneIndex and colorActive or colorInactive)
    end

    updateHudVisibility()
end

local function toggleRuneHud()
    runeHudExpanded = not runeHudExpanded
    updateHud()
end

local function toggleAutoRefill()
    if not autoRefillEnabled and not getSelectedRune() then
        showMessage("Selecione uma runa antes de ativar.")
        updateHud()
        return
    end

    autoRefillEnabled = not autoRefillEnabled
    updateHud()

    if autoRefillEnabled then
        showMessage("Compra automatica ATIVA.")
    else
        showMessage("Compra automatica INATIVA.")
    end
end

local function selectRune(index)
    if not runes[index] then return end

    selectedRuneIndex = index
    updateHud()
    showMessage(runes[index].label .. " selecionada para o refil.")
end

local function findChoiceByText(choices, text)
    if not choices then return nil end

    local wantedText = lower(text)

    for i = 1, #choices do
        local choice = choices[i]

        if lower(choice.text) == wantedText then
            return choice.id
        end
    end

    for i = 1, #choices do
        local choice = choices[i]

        if lower(choice.text):find(wantedText, 1, true) then
            return choice.id
        end
    end

    return nil
end

local function findButtonByText(buttons, text)
    if not buttons then return nil end

    local wantedText = lower(text)

    for i = 1, #buttons do
        local button = buttons[i]

        if lower(button.text) == wantedText then
            return button.id
        end
    end

    for i = 1, #buttons do
        local button = buttons[i]

        if lower(button.text):find(wantedText, 1, true) then
            return button.id
        end
    end

    return nil
end

local function handleRefillModal(data)
    if not autoRefillEnabled then return end

    local selectedRune = getSelectedRune()
    if not selectedRune then return end

    local choiceId = findChoiceByText(data.choices, selectedRune.name)
    if not choiceId then return end

    local buttonId = findButtonByText(data.buttons, "Buy")
        or findButtonByText(data.buttons, "Select")
        or findButtonByText(data.buttons, "OK")

    if not buttonId then return end

    Game.modalWindowAnswer(data.id, buttonId, choiceId)
end

hud.anchor = HUD.new(hudStartX, hudStartY, refillItemId, true)
hud.anchor:setDraggable(true)
hud.anchor:setCallback(toggleRuneHud)

hud.title = createText(38, -8, SCRIPT_NAME, colorTitle, toggleAutoRefill)
hud.status = createText(38, 8, "", colorActive, toggleAutoRefill)
hud.selected = createText(38, 24, "", colorActive, toggleAutoRefill)

for index, rune in ipairs(runes) do
    local runeX = (index - 1) * 42
    local runeY = 58
    local currentIndex = index

    hud.runes[index] = {
        icon = createItem(runeX, runeY, rune.id, function()
            selectRune(currentIndex)
        end),
        text = createText(runeX + 3, runeY + 22, "", colorNeutral, function()
            selectRune(currentIndex)
        end),
    }
end

Timer("runeRefilFabioCombinedHud", function()
    local pos = hud.anchor:getPos()
    if pos and (pos.x ~= 0 or pos.y ~= 0) then
        for _, element in ipairs(attachedHudElements) do
            element.item:setPos(pos.x + element.offsetX, pos.y + element.offsetY)
        end
    end

    updateHud()
end, 500)

Timer("runeRefilFabioCombinedCheck", function()
    if not autoRefillEnabled then return end

    if Client and Client.isConnected and not Client.isConnected() then
        return
    end

    local selectedRune = getSelectedRune()
    if not selectedRune then return end

    if (Game.getItemCount(refillItemId) or 0) <= 0 then
        updateHud()
        return
    end

    if (Game.getItemCount(selectedRune.id) or 0) <= refillAt then
        Game.useItem(refillItemId)
    end

    updateHud()
end, checkInterval)

Game.registerEvent(Game.Events.MODAL_WINDOW, handleRefillModal)

updateHud()
showMessage("Script iniciado. Clique no item " .. refillItemId .. " para abrir/fechar o painel.")

end

--[[
=========================================================
 Auto Forja - Fabio Rockeiro
=========================================================
HUD minimizado: clique no icone da forja para abrir/fechar.
Max Dust, Sliver e Exalted ficam em botoes com ON/OFF.
=========================================================
]]

do

local SCRIPT_NAME = "Auto Forja - Fabio Rockeiro"

local aumentar_limite = false
local transformar_exalted_core = false
local transformar_sliver = false
local tempo_entre_checagens = 2 -- em segundos

local forgeIconItemId = 63054
local sliverItemId = 37109
local exaltedCoreItemId = 37110

local hudStartX = 420
local hudStartY = 355

local forgeHudExpanded = false
local forgeSupported = true

local hud = {}
local attachedHudElements = {}

local colorActive = { 0, 255, 0 }
local colorInactive = { 255, 80, 80 }
local colorNeutral = { 210, 210, 210 }
local colorInfo = { 150, 210, 255 }
local colorTitle = { 255, 224, 128 }

local function showMessage(message)
    print("[AUTO FORJA] " .. message)

    if Client and Client.showMessage then
        Client.showMessage("[AUTO FORJA]\n" .. message)
    end
end

local function getBotVersion()
    if not Engine or not Engine.getBotVersion then return 0 end

    local numbers = {}
    local versionText = tostring(Engine.getBotVersion() or "")
    for number in versionText:gmatch("%d+") do
        table.insert(numbers, number)
    end

    return tonumber(table.concat(numbers, "")) or 0
end

if getBotVersion() < 1715 then
    forgeSupported = false
    showMessage("Atualize o ZeroBot para usar a Auto Forja.")
end

local function setHudColor(item, color)
    if item then
        item:setColor(color[1], color[2], color[3])
    end
end

local function setHudVisible(item, visible)
    if not item then return end
    if visible then
        item:show()
    else
        item:hide()
    end
end

local function attachHudElement(item, offsetX, offsetY)
    table.insert(attachedHudElements, {
        item = item,
        offsetX = offsetX,
        offsetY = offsetY,
    })
end

local function updateHudVisibility()
    for _, element in ipairs(attachedHudElements) do
        setHudVisible(element.item, forgeHudExpanded)
    end
end

local function createText(offsetX, offsetY, text, color, callback)
    local item = HUD.new(hudStartX + offsetX, hudStartY + offsetY, text, true)
    item:setDraggable(false)
    setHudColor(item, color or colorNeutral)

    if callback then
        item:setCallback(callback)
    end

    attachHudElement(item, offsetX, offsetY)
    return item
end

local function createItem(offsetX, offsetY, itemId, callback)
    local item = HUD.new(hudStartX + offsetX, hudStartY + offsetY, itemId, true)
    item:setDraggable(false)

    if callback then
        item:setCallback(callback)
    end

    attachHudElement(item, offsetX, offsetY)
    return item
end

local function currentDustText()
    local dust = Player and Player.getDusts and (Player.getDusts() or 0) or 0
    local maxDust = Player and Player.getDustsMaximum and (Player.getDustsMaximum() or 0) or 0
    local slivers = Game.getItemCount(sliverItemId) or 0
    local cores = Game.getItemCount(exaltedCoreItemId) or 0

    return "Dust: " .. dust .. "/" .. maxDust .. " | Sliver: " .. slivers .. " | Core: " .. cores
end

local function updateToggleText(item, enabled)
    if not item then return end

    item:setText(enabled and "ON" or "OFF")
    setHudColor(item, enabled and colorActive or colorInactive)
end

local function updateHud()
    hud.title:setText(SCRIPT_NAME)
    setHudColor(hud.title, colorTitle)

    if forgeSupported then
        hud.status:setText(currentDustText())
        setHudColor(hud.status, colorInfo)
    else
        hud.status:setText("ZeroBot precisa ser atualizado")
        setHudColor(hud.status, colorInactive)
    end

    hud.maxDustLabel:setText("MAX DUST")
    setHudColor(hud.maxDustLabel, aumentar_limite and colorActive or colorNeutral)
    updateToggleText(hud.maxDustState, aumentar_limite)

    updateToggleText(hud.sliverState, transformar_sliver)
    updateToggleText(hud.exaltedState, transformar_exalted_core)

    updateHudVisibility()
end

local function toggleForgeHud()
    forgeHudExpanded = not forgeHudExpanded
    updateHud()
end

local function toggleMaxDust()
    aumentar_limite = not aumentar_limite
    updateHud()
    showMessage("Max Dust " .. (aumentar_limite and "ON" or "OFF") .. ".")
end

local function toggleSliver()
    transformar_sliver = not transformar_sliver
    updateHud()
    showMessage("Sliver " .. (transformar_sliver and "ON" or "OFF") .. ".")
end

local function toggleExalted()
    transformar_exalted_core = not transformar_exalted_core
    updateHud()
    showMessage("Exalted Core " .. (transformar_exalted_core and "ON" or "OFF") .. ".")
end

local function autoForge()
    if not forgeSupported then return end

    local selfDust = Player.getDusts() or 0
    local selfMaxDust = Player.getDustsMaximum() or 0

    if aumentar_limite and selfDust > 0 and selfDust > (selfMaxDust - 75) then
        Game.forgeIncreaseLimit()
        wait(1000)
        Client.sendHotkey(16777216, 0)
    end

    if transformar_sliver and selfDust >= 60 then
        Game.forgeConvertDust()
        wait(1000)
        Client.sendHotkey(16777216, 0)
    end

    if transformar_exalted_core and Game.getItemCount(sliverItemId) >= 50 then
        Game.forgeConvertSlivers()
        wait(1000)
        Client.sendHotkey(16777216, 0)
    end
end

hud.anchor = HUD.new(hudStartX, hudStartY, forgeIconItemId, true)
hud.anchor:setDraggable(true)
hud.anchor:setCallback(toggleForgeHud)
hud.anchor:setScale(1.15)

hud.title = createText(38, -8, SCRIPT_NAME, colorTitle, toggleForgeHud)
hud.status = createText(38, 8, "", colorInfo, toggleForgeHud)

hud.maxDustLabel = createText(0, 58, "MAX DUST", colorNeutral, toggleMaxDust)
hud.maxDustState = createText(14, 76, "", colorInactive, toggleMaxDust)

hud.sliverIcon = createItem(90, 50, sliverItemId, toggleSliver)
hud.sliverState = createText(92, 76, "", colorInactive, toggleSliver)

hud.exaltedIcon = createItem(150, 50, exaltedCoreItemId, toggleExalted)
hud.exaltedState = createText(152, 76, "", colorInactive, toggleExalted)

Timer("autoForjaFabioHud", function()
    local pos = hud.anchor:getPos()
    if pos and (pos.x ~= 0 or pos.y ~= 0) then
        for _, element in ipairs(attachedHudElements) do
            element.item:setPos(pos.x + element.offsetX, pos.y + element.offsetY)
        end
    end

    updateHud()
end, 500)

Timer("autoForjaFabioCheck", autoForge, tempo_entre_checagens * 1000)

updateHud()
showMessage("Script iniciado. Clique no item " .. forgeIconItemId .. " para abrir/fechar o painel.")

end

--[[
=========================================================
 ARROW REFIL - FABIO ROCKEIRO
=========================================================
Integrado ao Task Bot no mesmo arquivo.
HUD inicia minimizado: clique no icone do Arrow Refill para
abrir/fechar o painel completo com status e selecao de ammo.
=========================================================
]]

do

local SCRIPT_NAME = "ARROW REFIL - FABIO ROCKEIRO"

local refillAt = 100 -- quantidade minima de municao para comprar de novo
local refillItemId = 63050 -- item Arrow Refill
local checkInterval = 10000 -- intervalo de checagem em ms

local hudStartX = 420
local hudStartY = 260

local ammunition = {
    { id = 3447, name = "arrow", label = "Arrow" },
    { id = 3449, name = "burst arrow", label = "Burst Arrow" },
    { id = 15793, name = "crystalline arrow", label = "Crystalline Arrow" },
    { id = 35901, name = "diamond arrow", label = "Diamond Arrow", quick = true },
    { id = 774, name = "earth arrow", label = "Earth Arrow" },
    { id = 16143, name = "envenomed arrow", label = "Envenomed Arrow" },
    { id = 763, name = "flaming arrow", label = "Flaming Arrow" },
    { id = 761, name = "flash arrow", label = "Flash Arrow" },
    { id = 7365, name = "onyx arrow", label = "Onyx Arrow" },
    { id = 762, name = "shiver arrow", label = "Shiver Arrow" },
    { id = 7364, name = "sniper arrow", label = "Sniper Arrow" },
    { id = 14251, name = "tarsal arrow", label = "Tarsal Arrow" },
    { id = 3446, name = "bolt", label = "Bolt" },
    { id = 16142, name = "drill bolt", label = "Drill Bolt" },
    { id = 6528, name = "infernal bolt", label = "Infernal Bolt" },
    { id = 7363, name = "piercing bolt", label = "Piercing Bolt" },
    { id = 3450, name = "power bolt", label = "Power Bolt" },
    { id = 16141, name = "prismatic bolt", label = "Prismatic Bolt" },
    { id = 35902, name = "spectral bolt", label = "Spectral Bolt", quick = true },
    { id = 14252, name = "vortex bolt", label = "Vortex Bolt" },
}

local selectedAmmoIndex = nil
local autoRefillEnabled = false
local ammoModal = nil
local arrowHudExpanded = false

local hud = { quick = {} }
local attachedHudElements = {}

local colorActive = { 0, 255, 0 }
local colorInactive = { 255, 80, 80 }
local colorNeutral = { 210, 210, 210 }
local colorInfo = { 150, 210, 255 }
local colorTitle = { 255, 224, 128 }

local function lower(value)
    return string.lower(tostring(value or ""))
end

local function showMessage(message)
    print("[ARROW REFIL] " .. message)

    if Client and Client.showMessage then
        Client.showMessage("[ARROW REFIL]\n" .. message)
    end
end

local function getSelectedAmmo()
    return selectedAmmoIndex and ammunition[selectedAmmoIndex] or nil
end

local function isQuickAmmo(ammo)
    return ammo and (ammo.name == "diamond arrow" or ammo.name == "spectral bolt")
end

local function setHudColor(item, color)
    if item then
        item:setColor(color[1], color[2], color[3])
    end
end

local function setHudVisible(item, visible)
    if not item then return end
    if visible then
        item:show()
    else
        item:hide()
    end
end

local function updateHudVisibility()
    for _, element in ipairs(attachedHudElements) do
        setHudVisible(element.item, arrowHudExpanded)
    end
end

local function attachHudElement(item, offsetX, offsetY)
    table.insert(attachedHudElements, {
        item = item,
        offsetX = offsetX,
        offsetY = offsetY,
    })
end

local function createText(offsetX, offsetY, text, color, callback)
    local item = HUD.new(hudStartX + offsetX, hudStartY + offsetY, text, true)
    item:setDraggable(false)
    setHudColor(item, color or colorNeutral)

    if callback then
        item:setCallback(callback)
    end

    attachHudElement(item, offsetX, offsetY)
    return item
end

local function createItem(offsetX, offsetY, itemId, callback)
    local item = HUD.new(hudStartX + offsetX, hudStartY + offsetY, itemId, true)
    item:setDraggable(false)

    if callback then
        item:setCallback(callback)
    end

    attachHudElement(item, offsetX, offsetY)
    return item
end

local function findAmmoIndexByName(name)
    local wantedName = lower(name)

    for index, ammo in ipairs(ammunition) do
        if lower(ammo.name) == wantedName then
            return index
        end
    end

    return nil
end

local function updateHud()
    local selectedAmmo = getSelectedAmmo()
    local selectedCount = selectedAmmo and (Game.getItemCount(selectedAmmo.id) or 0) or 0
    local refillCount = Game.getItemCount(refillItemId) or 0

    hud.title:setText(SCRIPT_NAME)

    if autoRefillEnabled and not selectedAmmo then
        autoRefillEnabled = false
    end

    if autoRefillEnabled then
        hud.status:setText("Compra: ATIVO | Refil: " .. refillCount .. " | Min: " .. refillAt)
        setHudColor(hud.status, colorActive)
    else
        hud.status:setText("Compra: INATIVO | Refil: " .. refillCount .. " | Min: " .. refillAt)
        setHudColor(hud.status, colorInactive)
    end

    hud.selected:setText("Selecionada: " .. (selectedAmmo and selectedAmmo.label or "--") .. " | Qtd: " .. selectedCount)
    setHudColor(hud.selected, autoRefillEnabled and colorActive or colorNeutral)

    for _, entry in ipairs(hud.quick) do
        local selected = entry.ammoIndex == selectedAmmoIndex
        entry.text:setText(selected and "ON" or "OFF")
        setHudColor(entry.text, selected and colorActive or colorInactive)
    end

    if not selectedAmmo then
        hud.others:setText("[OUTROS]")
        setHudColor(hud.others, colorInfo)
    elseif isQuickAmmo(selectedAmmo) then
        hud.others:setText("[OUTROS]")
        setHudColor(hud.others, colorInfo)
    else
        hud.others:setText("[OUTROS: ON]")
        setHudColor(hud.others, colorActive)
    end

    updateHudVisibility()
end

local function toggleArrowHud()
    arrowHudExpanded = not arrowHudExpanded
    updateHud()
end

local function toggleAutoRefill()
    if not autoRefillEnabled and not getSelectedAmmo() then
        showMessage("Selecione uma arrow/bolt antes de ativar.")
        updateHud()
        return
    end

    autoRefillEnabled = not autoRefillEnabled
    updateHud()

    if autoRefillEnabled then
        showMessage("Compra automatica ATIVA.")
    else
        showMessage("Compra automatica INATIVA.")
    end
end

local function selectAmmo(index)
    if not ammunition[index] then return end

    selectedAmmoIndex = index
    updateHud()
    showMessage(ammunition[index].label .. " selecionado para o refil.")
end

local function destroyAmmoModal()
    if ammoModal then
        ammoModal:destroy()
        ammoModal = nil
    end
end

local function addModalButton(modal, actions, text, action)
    actions[modal:addButton(text)] = action
end

local function openAmmoModal()
    destroyAmmoModal()

    local selectedAmmo = getSelectedAmmo()
    local modal = CustomModalWindow.new("OUTROS - ARROW REFIL", "Selecione a municao para o Arrow Refill.")
    modal:setCaption("OUTROS - ARROW REFIL")
    modal:setDescription("Atual: " .. (selectedAmmo and selectedAmmo.label or "--"))
    ammoModal = modal

    local actions = {}
    for index, ammo in ipairs(ammunition) do
        local marker = index == selectedAmmoIndex and "[ON] " or ""
        addModalButton(modal, actions, marker .. ammo.label, index)
    end

    modal:setCallback(function(buttonId)
        local action = actions[buttonId]
        if action then
            selectAmmo(action)
        end

        destroyAmmoModal()
    end)
end

local function findChoiceByText(choices, text)
    if not choices then return nil end

    local wantedText = lower(text)

    for i = 1, #choices do
        local choice = choices[i]

        if lower(choice.text) == wantedText then
            return choice.id
        end
    end

    for i = 1, #choices do
        local choice = choices[i]

        if lower(choice.text):find(wantedText, 1, true) then
            return choice.id
        end
    end

    return nil
end

local function findButtonByText(buttons, text)
    if not buttons then return nil end

    local wantedText = lower(text)

    for i = 1, #buttons do
        local button = buttons[i]

        if lower(button.text) == wantedText then
            return button.id
        end
    end

    for i = 1, #buttons do
        local button = buttons[i]

        if lower(button.text):find(wantedText, 1, true) then
            return button.id
        end
    end

    return nil
end

local function handleRefillModal(data)
    if not autoRefillEnabled then return end

    local selectedAmmo = getSelectedAmmo()
    if not selectedAmmo then return end

    local choiceId = findChoiceByText(data.choices, selectedAmmo.name)
    if not choiceId then return end

    local buttonId = findButtonByText(data.buttons, "Buy")
        or findButtonByText(data.buttons, "Select")
        or findButtonByText(data.buttons, "OK")

    if not buttonId then return end

    Game.modalWindowAnswer(data.id, buttonId, choiceId)
end

hud.anchor = HUD.new(hudStartX, hudStartY, refillItemId, true)
hud.anchor:setDraggable(true)
hud.anchor:setCallback(toggleArrowHud)

hud.title = createText(38, -8, SCRIPT_NAME, colorTitle, toggleAutoRefill)
hud.status = createText(38, 8, "", colorActive, toggleAutoRefill)
hud.selected = createText(38, 24, "", colorActive, toggleAutoRefill)

local quickAmmoNames = { "diamond arrow", "spectral bolt" }
for index, ammoName in ipairs(quickAmmoNames) do
    local ammoIndex = findAmmoIndexByName(ammoName)
    local ammo = ammunition[ammoIndex]
    local quickX = (index - 1) * 50
    local quickY = 58

    hud.quick[index] = {
        ammoIndex = ammoIndex,
        icon = createItem(quickX, quickY, ammo.id, function()
            selectAmmo(ammoIndex)
        end),
        text = createText(quickX + 4, quickY + 22, "", colorNeutral, function()
            selectAmmo(ammoIndex)
        end),
    }
end

hud.others = createText(104, 65, "[OUTROS]", colorInfo, openAmmoModal)

Timer("arrowRefilFabioCombinedHud", function()
    local pos = hud.anchor:getPos()
    if pos and (pos.x ~= 0 or pos.y ~= 0) then
        for _, element in ipairs(attachedHudElements) do
            element.item:setPos(pos.x + element.offsetX, pos.y + element.offsetY)
        end
    end

    updateHud()
end, 500)

Timer("arrowRefilFabioCombinedCheck", function()
    if not autoRefillEnabled then return end

    if Client and Client.isConnected and not Client.isConnected() then
        return
    end

    local selectedAmmo = getSelectedAmmo()
    if not selectedAmmo then return end

    if (Game.getItemCount(refillItemId) or 0) <= 0 then
        updateHud()
        return
    end

    if (Game.getItemCount(selectedAmmo.id) or 0) <= refillAt then
        Game.useItem(refillItemId)
    end

    updateHud()
end, checkInterval)

Game.registerEvent(Game.Events.MODAL_WINDOW, handleRefillModal)

updateHud()
showMessage("Script iniciado. Clique no item " .. refillItemId .. " para abrir/fechar o painel.")

end

end

-- =========================
-- Modulo embutido: Follow
-- =========================
function FabioRockeiroBOT.loadFollowModule()
--[[ By CaioEduT ]]--

-- [[ Settings ]]

-- You can set follow settings by clicking on the HUD.

-- set custom telport ids.
-- eg.: { 1020, 3304, 63206 }
local TELPORT_IDS = {63206, 63118}

-- set ids to not walk on.
-- ATTENTION: this only applies to the destination SQM, it does not work on the path SQMs (sqms in the way of "map click")
-- eg.: { 1020, 3304 }
local DONT_WALK_IDS = {  }

--[[ PT-BR
    HUD ARRASTÁVEL

    Há duas formas de ativar o "follow":
    - Opção 1: siga um jogador
    - Opção 2: use o comando !follow nome

    Há duas formas de cancelar o "follow":
    - Opção 1: Pressione ESC duas vezes rápido
    - Opção 2: use o comando (sem nome) !follow

    Segue o jogador em:
    - Escadas (comuns)
    - Escadas e esgotos (dar use)
    - Teleports
    - Usa corda
    - Desce buracos
]]

--[[ EN
    DRAGGABLE HUD

    There are two ways to activate "follow":
    - Option 1: Follow a player
    - Option 2: Use the command !follow name

    There are two ways to cancel "follow":
    - Option 1: Press ESC twice quickly
    - Option 2: Use the command (empty) !follow

    Follows the player on:
    - Stairs (common)
    - Ladders and sewers (use action)
    - Teleports
    - Use rope
    - Down holes
]]--

---------------------------------------------------------------
-------------------- DON'T CHANGE BELOW -----------------------
---------------------------------------------------------------

--[[
 .____                  ________ ___.    _____                           __
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|
         \/          \/         \/    \/                \/     \/     \/
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib

]]--

local v0=string.char;local v1=string.byte;local v2=string.sub;local v3=bit32 or bit ;local v4=v3.bxor;local v5=table.concat;local v6=table.insert;local function v7(v31,v32) local v33={};for v98=1, #v31 do v6(v33,v0(v4(v1(v2(v31,v98,v98 + 1 )),v1(v2(v32,1 + (v98% #v32) ,1 + (v98% #v32) + 1 )))%256 ));end return v5(v33);end local v8={{[v7("\221\194\217\32\234","\126\177\163\187\69\134\219\167")]=v7("\20\204\38\206\188\14\194\46\192","\156\67\173\74\165"),[v7("\34\182\69\3\185","\38\84\215\41\118\220\70")]=v7("\84\19\36\19\235\92\2","\158\48\118\66\114"),[v7("\164\52\4\63\124\171\232","\155\203\68\112\86\19\197")]={v7("\66\216\48\253\85\116\241","\152\38\189\86\156\32\24\133"),v7("\254\82\175\79\242\83","\38\156\55\199"),v7("\174\111\115\38\7","\35\200\29\28\72\115\20\154"),v7("\21\186\215\203","\84\121\223\177\191\237\76"),v7("\169\95\206\168\46","\161\219\54\169\192\90\48\80"),v7("\90\86\1\38\66","\69\41\34\96")}},{[v7("\176\194\213\15\14","\75\220\163\183\106\98")]=v7("\38\179\152\35\216\12\185\142","\185\98\218\235\87"),[v7("\221\61\43\243\219","\202\171\92\71\134\190")]=1662 -(1477 + 184) ,[v7("\38\209\56\129\38\207\63","\232\73\161\76")]={1 + 0 ,858 -(564 + 292) ,8 -5 ,4 + 0 ,1006 -(938 + 63) ,6}},{[v7("\183\216\64\88\18","\126\219\185\34\61")]=v7("\63\215\80\113\48\55\215\238\30\203\93\102\119\120\253","\135\108\174\62\18\30\23\147"),[v7("\160\232\38\222\29","\167\214\137\74\171\120\206\83")]=v7("\133\255","\199\235\144\82\61\152"),[v7("\8\6\173\34\8\24\170","\75\103\118\217")]={v7("\222\81\99","\126\167\52\16\116\217"),v7("\198\33","\156\168\78\64\224\212\121")}},{[v7("\11\239\167\203\11","\174\103\142\197")]=v7("\119\36\75\61\55\80\249\66\45\31\112\122\23\184\22\104\31\12\42\89\255\90\45\76\120\39\91\236\65\45\90\54\101\92\253\95\38\88\120\38\82\247\69\45\31\55\55\30\252\95\59\75\57\43\74\184\89\46\31\44\45\91\184\66\41\77\63\32\74\184\95\46\31\44\45\91\234\83\104\86\43\101\95\184\85\58\90\57\49\75\234\83\104\80\54\101\77\251\68\45\90\54","\152\54\72\63\88\69\62"),[v7("\194\197\226\73\209","\60\180\164\142")]=v7("\86\81","\114\56\62\101\73\71\141"),[v7("\183\249\207\205\183\231\200","\164\216\137\187")]={v7("\203\227\34","\107\178\134\81\210\198\158"),v7("\54\1","\202\88\110\226\166")}}};local v9=1148 -(782 + 356) ;local v10=372 -(176 + 91) ;local v11;local v12;local v13=0 -0 ;local v14=0 -0 ;local v15=1092 -(975 + 117) ;local v16={x=1875 -(157 + 1718) ,y=0 + 0 ,z=0 -0 };local v17={x=0 -0 ,y=0,z=0};function getSettings() local v34=1018 -(697 + 321) ;local v35;local v36;local v37;local v38;while true do if (v34==1) then v37=((v8[7 -4 ].value==v7("\218\10\145","\170\163\111\226\151")) and true) or false ;v38=((v8[8 -4 ].value==v7("\8\53\161","\73\113\80\210\88\46\87")) and true) or false ;v34=2;end if (v34==(0 -0)) then local v118=0 + 0 ;while true do if (v118==0) then v35=v8[1 -0 ].value;v36=v8[5 -3 ].value;v118=1;end if ((1228 -(322 + 905))==v118) then v34=612 -(602 + 9) ;break;end end end if (v34==(1191 -(449 + 740))) then return v35,v36,v37,v38;end end end function getFollowText() local v39,v40,v41,v42=getSettings();return v7("\167\35\193\30\232\150\37\195\21\189\193","\135\225\76\173\114")   .. (v12 or v7("\87\160\245","\199\122\141\216\208\204\221")):upper()   .. "\n"   .. v7("\128\210\20\245\34\182","\150\205\189\112\144\24")   .. v39:gsub(v7("\27\193\179","\112\69\228\223\44\100\232\113"),string.upper)   .. v7("\148\87","\230\180\127\103\179\214\28")   .. v40   .. v7("\159\20\82","\128\236\101\63\38\132\33")   .. ")\n"   .. v7("\159\176\31\71\248\171\235\165\187\75\4","\175\204\201\113\36\214\139")   .. ((v41 and v7("\126\201\38","\100\39\172\85\188")) or v7("\131\119","\83\205\24\217\224"))   .. "\n"   .. v7("\199\201\217\56\244\203\204\41\227\159\141","\93\134\165\173")   .. ((v42 and v7("\135\247\210","\30\222\146\161\162\90\174\210")) or v7("\203\65","\106\133\46\16")) ;end local v18=HUD.new(v9,v10,getFollowText(),true);v18:setDraggable(true);v18:setColor(1127 -(826 + 46) ,255,1202 -(245 + 702) );v18:setCallback(function() renderConfigModal();end);table._includes=function(v43,v44) local v45=0;local v46;while true do if (v45==0) then v46=0;while true do if (v46==(0 -0)) then for v151,v152 in pairs(v43) do if (v152==v44) then return true;end end return false;end end break;end end end;table._merge=function(v47) local v48=0 + 0 ;local v49;while true do if (v48==(1899 -(260 + 1638))) then return v49;end if (v48==(440 -(382 + 58))) then v49={};for v122,v123 in ipairs(v47) do for v133,v134 in pairs(v123) do table.insert(v49,v134);end end v48=3 -2 ;end end end;math._carousel=function(v50,v51,v52) if (v50<v51) then v50=v52;end if (v50>v52) then v50=v51;end return v50;end;local function v22(v53,v54) local v55=0;while true do if (v55==(1 + 0)) then Client.showMessage(v53);break;end if (v55==0) then v53=(v53 or "")   .. "" ;if (v53~="") then local v135=0 -0 ;while true do if (v135==(0 -0)) then if  not v54 then v53="[FOLLOW]\n"   .. v53 ;end v53="\n\n\n\n\n\n\n\n"   .. v53 ;break;end end end v55=1206 -(902 + 303) ;end end end function renderConfigModal() local v56=CustomModalWindow.new(v7("\126\47\127\240\85\87\24\19\118\232\78\73\86\39\96","\32\56\64\19\156\58"),v7("\111\219\224\22\27\244\143\86\196\234\65\26\201\142\91\197\224\107\26\230\143\26\219\241\87\72\230\192\92\199\233\90\85\229\137\84\207\171","\224\58\168\133\54\58\146"));for v99,v100 in ipairs(v8) do v56:addButton(" "   .. v100.label );v56:addButton(((type(v100.options[1 -0 ])==v7("\87\67\70\255\112\148","\107\57\54\43\157\21\230\231")) and "-") or "<" );v56:addButton((v100.value   .. ""):upper());v56:addButton(((type(v100.options[2 -1 ])==v7("\213\158\28\247\188\206","\175\187\235\113\149\217\188")) and "+") or ">" );end v56:setCallback(function(v101) local v102=0 + 0 ;local v103;local v104;local v105;local v106;while true do if (v102==(1692 -(1121 + 569))) then for v136,v137 in ipairs(v105.options) do if (v137==v105.value) then v106=v136;break;end end if (v104==(215 -(22 + 192))) then v106=math._carousel(v106-(684 -(483 + 200)) ,1464 -(1404 + 59) , #v105.options);end v102=8 -5 ;end if (v102==0) then v103=math.ceil((v101 + (1 -0))/(769 -(468 + 297)) );v104=math.fmod(v101,566 -(334 + 228) );v102=3 -2 ;end if (v102==3) then if (v104==(6 -3)) then v106=math._carousel(v106 + (1 -0) ,1 + 0 , #v105.options);end v105.value=v105.options[v106];v102=4;end if (v102==(240 -(141 + 95))) then v56:destroy();renderConfigModal();break;end if ((1 + 0)==v102) then local v126=0;while true do if (v126==0) then v105=v8[v103];v106=2 -1 ;v126=2 -1 ;end if (v126==1) then v102=1 + 1 ;break;end end end end end);end Game.registerEvent(Game.Events.HOTKEY_SHORTCUT_PRESS,function(v57,v58) if ((v58>(0 -0)) or (v57~=HotkeyManager.keyMapping.escape)) then return;end if ( not v11 or (v11==0)) then return;end if ((os.time() -v13)==(0 + 0)) then local v117=0;while true do if (v117==0) then v11=nil;v12=nil;v117=1;end if ((1 + 0)==v117) then v22(v7("\26\160\141\64\236\110\56\63\174\143\79\230\117\125\56\225","\24\92\207\225\44\131\25"));break;end end end v13=os.time();end);Game.registerEvent(Game.Events.HOTKEY_SHORTCUT_PRESS,function(v59,v60) if ((v60~=(0 -0)) and (v60~=(5 + 3))) then return;end if ((v59==HotkeyManager.keyMapping.w) or (v59==HotkeyManager.keyMapping.a) or (v59==HotkeyManager.keyMapping.s) or (v59==HotkeyManager.keyMapping.d) or (v59==HotkeyManager.keyMapping.q) or (v59==HotkeyManager.keyMapping.e) or (v59==HotkeyManager.keyMapping.z) or (v59==HotkeyManager.keyMapping.c) or (v59==HotkeyManager.keyMapping.up) or (v59==HotkeyManager.keyMapping.down) or (v59==HotkeyManager.keyMapping.left) or (v59==HotkeyManager.keyMapping.right)) then v15=os.time() + 1 ;end end);Game.registerEvent(Game.Events.TALK,function(v61,v62,v62,v62,v62,v62,v63) local v64=163 -(92 + 71) ;local v65;while true do if (v64==(1 + 0)) then v65=string.sub(v63,14 -5 );if ( not v65 or (v65=="")) then v65=nil;end v64=767 -(574 + 191) ;end if (0==v64) then if (string.lower(v61 or "" )~=string.lower(Player.getName() or "0" )) then return;end if (string.sub(v63,1 + 0 ,17 -10 )~=v7("\10\213\183\64\23\114\92","\29\43\179\216\44\123")) then return;end v64=1 + 0 ;end if (v64==2) then v11=nil;v12=v65;v64=852 -(254 + 595) ;end if (v64==3) then v18:setText(getFollowText());if v12 then targetByNameTimer:start();end break;end end end);local v23={1948,3758 -(573 + 1217) ,422 + 5120 ,7771,26640 -17524 ,24021 -6791 ,20474,21281 -(118 + 688) ,21365,21374,23261 -(927 + 959) ,96596 -67940 ,60091 -28962 ,31130,31547 -(175 + 110) ,33770,168895 -134652 ,37704 -(503 + 1293) ,121134 -77760 ,48493,49555 -(810 + 251) ,50122,15383 + 34740 };local v24={435,8283 -(43 + 490) ,21221,82384 -61086 ,2102 + 6606 };local v25={26 + 360 ,421,9506 -(1344 + 400) ,12202,6926 + 6009 ,12936,13381,14644 -(183 + 223) ,17238,26163 -4662 ,7905 + 14060 ,15297 + 6669 ,7321 + 14646 ,22417 -(108 + 341) ,23363,33051};local v26={173 + 212 ,1887 -(711 + 782) ,1062 -(270 + 199) ,2413 -(580 + 1239) ,580 + 26 ,607,265 + 343 ,1589 -980 ,615,2034 -(645 + 522) ,868 + 0 ,2561 -1687 ,5731,19614 -11865 ,7755,13777 -(1281 + 293) ,12728,17731 -(1381 + 178) ,15170 + 1003 ,8172 + 10985 ,9958 + 9262 ,20344,14433 + 6908 ,22498 -(1074 + 82) ,23164 -(214 + 1570) };local v27=table._merge({{775,1949,1959,5022,2186 + 2837 ,19941 -14874 ,5694 -(512 + 114) ,5069,6116,21284 -15167 ,1659 + 7200 ,30694 -21594 ,12309 -(1269 + 200) ,20780 -9938 ,11553,12369 -(98 + 717) ,12796,15320,19387,25666 -5343 ,20362,3109 + 17937 ,21047,3458 + 17590 ,21049,71147 -49812 ,8686 + 12650 ,15607 + 5856 ,21740,10151 + 11590 ,21810,23725 -(1427 + 192) ,22761,23154,10684 + 12890 ,23808 -(192 + 134) ,13069 + 10414 ,21707 + 1777 ,25483 -(83 + 468) ,116924 -91877 ,25048,25374 -(45 + 280) ,21886 + 3164 ,9148 + 15903 ,25052,46391 -21338 ,9882 + 15172 ,68848 -43793 ,26090 -(125 + 909) ,27005 -(1096 + 852) ,25058,25740,24968 + 773 ,27825 -(46 + 190) ,27685 -(51 + 44) ,27658,27701,29990 -(1114 + 203) ,30705 -(228 + 498) ,29980,32627,85919 -52940 ,33004,34910 -(830 + 1075) ,34275 -(231 + 1038) ,34169 -(171 + 991) ,140549 -106445 ,34105,34106,34107,27301 + 6810 ,102398 -66902 ,109731 -74234 ,36746 -(111 + 1137) ,35499,35658 -(91 + 67) ,8858 + 26643 ,35502,258 + 36489 ,19272 + 17701 ,161467 -124467 ,82431 -45430 ,37776 -(530 + 181) ,38918 -(614 + 267) ,38054,92122 -52590 ,10271 + 29276 ,39725,45772 -(1293 + 519) ,89828 -45801 ,49042,49888,49889,211547 -162488 ,51277,10462 + 40816 ,143971 -82008 ,37278,12385 + 24894 ,37280,37281,37282,37283},TELPORT_IDS});local v28={2745 -1890 ,856,3202 -1255 ,1458 + 492 ,480 + 1472 ,3835 -1881 ,1956,3241 -(1040 + 243) ,3807 -(559 + 1288) ,2416 -(13 + 441) ,5144 -3180 ,9791 -7825 ,1969,1971,701 + 1272 ,866 + 1109 ,1977,3637 -1659 ,1450 + 742 ,2194,2196,2151 + 47 ,15179 -9922 ,2077 + 3181 ,5259,3616 + 3293 ,6911,6913,4274 + 2641 ,8209 -(89 + 578) ,15683 -8139 ,8595 -(572 + 477) ,4530 + 3018 ,7967 -(84 + 2) ,5682 + 2205 ,8730 -(497 + 345) ,1464 + 7193 ,6301 + 2529 ,8831,43283 -31576 ,11709,36962 -23621 ,13831 -(457 + 32) ,13559,14963 -(832 + 570) ,3538 + 10026 ,13567,13570,13573,36590 -23014 ,13579,28434 -14852 ,7877 + 5708 ,15477 -(1569 + 320) ,13591,13716,2607 + 11111 ,14325 -(316 + 289) ,634 + 13088 ,16385 -(666 + 787) ,15359 -(360 + 65) ,14936,23554 -8616 ,11790 + 3318 ,29099 -13989 ,15293 -(92 + 89) ,15114,8963 + 6181 ,2282 + 14398 ,38036 -21354 ,14557 + 2127 ,50819 -34133 ,25449 -8761 ,38618 -21928 ,17881 -(442 + 747) ,17640 -(88 + 858) ,17394,5302 + 12093 ,769 + 17881 ,18652,92089 -73435 ,49152 -30496 ,20663 -(1036 + 37) ,13890 + 5701 ,15831 + 4293 ,21622 -(641 + 839) ,20143,20224,21909 -(1466 + 218) ,21401 -(556 + 592) ,21062 -(329 + 479) ,69599 -49344 ,14463 + 5793 ,1800 + 18533 ,21811 -(29 + 1448) ,20335,20336,95675 -75184 ,20492,21068 -(102 + 472) ,11366 + 9130 ,20750,20751,12698 + 8055 ,22612 -(821 + 1038) ,2270 + 18485 ,7723 + 13032 ,53447 -31883 ,1372 + 20194 ,5536 + 16032 ,33416 -11846 ,5918 + 16238 ,22879 -(112 + 250) ,56531 -33966 ,12928 + 9638 ,11765 + 10984 ,11830 + 12028 ,17726 + 6134 ,23862,23864,25898 -(244 + 638) ,25711 -(627 + 66) ,25020,25022,26952 -(1665 + 241) ,11462 + 13950 ,25413,43007 -17593 ,28728 -(35 + 1064) ,60670 -32313 ,114 + 28245 ,29620 -(233 + 1026) ,28363,28433 + 676 ,8648 + 20463 ,29113,29115,29358 -(55 + 166) ,2931 + 26208 ,29141,29440 -(36 + 261) ,53789 -23032 ,11825 + 18934 ,30761,30784 -(20 + 1) ,30820,31955 -(549 + 584) ,30824,31794 -(478 + 490) ,32076 -(786 + 386) ,32285 -(1055 + 324) ,30908,32250 -(1093 + 247) ,27470 + 3442 ,3251 + 27663 ,30916,30918,108285 -76378 ,33175,83370 -50193 ,33179,33181,127916 -94712 ,114453 -81247 ,84926 -51718 ,33210,79746 -46513 ,139066 -105831 ,33237,34507 -(1249 + 19) ,129449 -96193 ,34344 -(686 + 400) ,33260,158 + 33104 ,34165,111108 -76888 ,36444,36446,67109 -30661 ,6612 + 29838 ,904 + 37060 ,75482 -37516 ,126350 -88382 ,39963 -(1238 + 755) ,41255 -(709 + 825) ,73198 -33476 ,40783 -(196 + 668) ,82693 -42772 ,40756 -(171 + 662) ,40018 -(4 + 89) ,40262,176844 -136581 ,41765 -(35 + 1451) ,40281,41749 -(28 + 1425) ,38641 + 1657 ,41814 -(822 + 692) ,18984 + 21318 ,40001 + 427 ,98391 -57963 ,40430,40430,51808 -11376 ,25775 + 14657 ,40434,40434,44354 -(556 + 1407) ,43599 -(741 + 465) ,22338 + 20057 ,104383 -61986 ,42619,35332 + 7289 ,27335 + 15288 ,24142 + 18490 ,11492 + 31473 ,42965,163723 -120756 ,42967,42969,212768 -169799 ,42971,42971,98190 -55060 ,144752 -101622 ,43132,42426 + 706 ,43445 -(309 + 2) ,44372 -(1090 + 122) ,43160,43162,144959 -101797 ,43164,44282 -(628 + 490) ,106870 -63706 ,45045 -(431 + 343) ,44273,128085 -83810 ,5664 + 38613 ,46255 -(556 + 1139) ,44896,23001 + 21897 ,17391 + 27509 ,31802 + 13100 ,44942,158227 -113284 ,142118 -97172 ,46211 -(668 + 595) ,9105 + 36049 ,123144 -77988 ,45158,45547 -(371 + 16) ,45197,85976 -40581 ,45517 -(88 + 30) ,46172 -(720 + 51) ,51433 -(421 + 1355) ,81924 -32265 ,49661,181549 -131886 ,50376 -(397 + 42) ,50739 -(24 + 776) ,49941,110041 -60098 };local v29={293,2092 -(690 + 1108) ,305 + 64 ,61 + 309 ,411,412,219 + 194 ,414,278 + 150 ,1180 -748 ,987 -554 ,434,13 + 424 ,168 + 270 ,469,980 -505 ,1531 -1055 ,482,1016 -533 ,1365 -(581 + 300) ,1151 -666 ,1801 -(1030 + 205) ,567,881 -(156 + 130) ,1011 -411 ,601,160 + 444 ,605,610,859,4274 -3406 ,877,2281 -(369 + 846) ,283 + 784 ,1067,3025 -(1036 + 909) ,1813 -733 ,1359 -(11 + 192) ,4823,11687 -6863 ,4825,7234 -2408 ,5257 -(50 + 126) ,15437 -9893 ,7104 -(1233 + 180) ,7184 -(107 + 1314) ,18669 -12542 ,12168 -6040 ,8039 -(716 + 1194) ,657 + 5473 ,6172,3060 + 3113 ,4894 + 2023 ,6918,21330 -14411 ,7353 -(279 + 154) ,5446 + 1475 ,3733 + 3189 ,2559 + 4364 ,6924,30137 -23084 ,8659 -(1058 + 125) ,7477,8453 -(815 + 160) ,17753 -10274 ,22592 -14863 ,9628 -(41 + 1857) ,7731,19983 -12251 ,8915 -(229 + 953) ,9313 -(874 + 705) ,1083 + 6652 ,5279 + 2457 ,7767,219 + 7549 ,1975 + 6683 ,21818 -13128 ,20654 -11722 ,11747 -(718 + 823) ,7152 + 4213 ,36236 -23437 ,12961,30766 -17805 ,31236 -16091 ,12003 + 3143 ,5910 + 10355 ,16266,43070 -26803 ,16268,15711 + 558 ,48588 -32318 ,17105 -(64 + 770) ,36938 -20666 ,16696,17940 -(157 + 1086) ,73132 -56434 ,22791 -6092 ,17519 -(599 + 220) ,18632 -(1813 + 118) ,17919 -(841 + 376) ,3881 + 12822 ,17644 -(464 + 395) ,16786,16787,16788,34694 -17905 ,57556 -40766 ,39065 -22274 ,18074 -(74 + 1208) ,81757 -64518 ,18909 -(14 + 376) ,32123 -13603 ,18564,18565,17780 + 862 ,54626 -35983 ,18644,18645,12443 + 6203 ,28912 -10265 ,19549 -(652 + 249) ,49907 -31258 ,21991 -(708 + 1160) ,20259,20260,20261,20289 -(10 + 17) ,20263,22060 -(1400 + 332) ,22237 -(242 + 1666) ,7451 + 12879 ,21271 -(850 + 90) ,20332,21752 -(360 + 1030) ,20469,57777 -37307 ,20471,20472,22134 -(909 + 752) ,37510 -17022 ,20731 -(6 + 236) ,12910 + 7580 ,49606 -28572 ,22272 -(1076 + 57) ,3511 + 17833 ,21741,1735 + 20236 ,19427 + 2545 ,22380 -(174 + 233) ,38888 -16731 ,23922 -(663 + 511) ,20844 + 2520 ,5341 + 19256 ,15247 + 9930 ,60951 -35773 ,25179,25180,2526 + 25102 ,29245 -(478 + 244) ,28655,29303,30452,32009 -(655 + 901) ,23862 + 7306 ,128996 -96976 ,116667 -82501 ,137765 -103510 ,80038 -45703 ,6260 + 32571 ,16244 + 22588 ,39817,43372,43372,47251 + 1910 ,155701 -105795 ,50069,8708 + 41362 ,30721 + 19350 ,143186 -93114 ,51457 -(1140 + 235) ,50083,50084,12854 + 37231 };local v30=table._merge({v28,v29,v26,v27});DONT_WALK_IDS=table._merge({DONT_WALK_IDS,v30});function isTileSafeWalkable(v66,v67,v68) local v69=0 -0 ;local v70;while true do local v107=0;while true do if (v107==(0 + 0)) then if (v69==(690 -(586 + 103))) then return v70;end if (v69==0) then local v149=0 + 0 ;while true do if (v149==0) then v70=Map.isTileWalkable(v66,v67,v68,{[v7("\180\222\46\67\175\220\2\64\178\218\43\124\188\205\40","\44\221\185\64")]=true,[v7("\8\224\70\80\97\4\202\73\88\122\2\193\65\90\127\5","\19\97\135\40\63")]=true,[v7("\167\91\61\52\61\52\136\80\60\52\61\18\166\93\61\60\42","\81\206\60\83\91\79")]=false,[v7("\71\172\222\125\61\198\96\171\64\184\196\119\61\208","\196\46\203\176\18\79\163\45")]=false,[v7("\177\37\112\17\54\254\193\168\33\109","\143\216\66\30\126\68\155")]=false});if v70 then for v181,v182 in ipairs(Map.getThings(v66,v67,v68) or {} ) do for v204,v205 in ipairs(DONT_WALK_IDS) do if (v182.id==v205) then v70=false;break;end end if  not v70 then break;end end end v149=2 -1 ;end if (v149==1) then v69=1;break;end end end break;end end end end targetByNameTimer=Timer.new(v7("\158\201\31\204\192\183\245\248\132\201\0\206\241\170\218\228\184","\129\202\168\109\171\165\195\183"),function() local v71=1488 -(1309 + 179) ;while true do if (v71==(0 -0)) then if v11 then local v138=0 + 0 ;while true do if (v138==(0 -0)) then targetByNameTimer:stop();return;end end end v22(v7("\21\89\62\204\215\26\225\98","\134\66\56\87\184\190\116")   .. v12   .. v7("\124\52\7\175\28\249\97\58\50\113\26\184\11\238\36\59\114\127\71","\85\92\81\105\219\121\139\65") );v71=1 + 0 ;end if (v71==(1 -0)) then for v127,v128 in ipairs(Map.getCreatureIds(false,false) or {} ) do local v129=Creature.new(v128);if ((v129:getName() or ""):lower()==(v12 or ""):lower()) then v22();v11=v129:getId();break;end end break;end end end,996 -496 ,false);followTimer=Timer.new(v7("\219\188\92\73\115\200\201\186\93\64\110","\191\157\211\48\37\28"),function() local v72=0;local v73;local v74;local v75;local v76;local v77;local v78;local v79;local v80;local v81;local v82;local v83;local v84;local v85;while true do if (v72==1) then v78=(v77>(609 -(295 + 314))) and (v77~=v11) ;v18:setText(getFollowText());v11=((v77>(0 -0)) and v77) or v11 ;v72=1964 -(1300 + 662) ;end if (2==v72) then if ( not v11 or (v11<=(0 -0))) then return;end v79=Creature.new(v11);if ( not v79 or (v79:getId()==(1755 -(1178 + 577)))) then return;end v72=3;end if (v72==(3 + 1)) then local v119=0 -0 ;while true do if ((1406 -(851 + 554))==v119) then if v76 then if Player.getState(Enums.States.STATE_PIGEON) then v74=1 + 0 ;else local v168=0 -0 ;local v169;while true do if (v168==(1 -0)) then if (v169==(302 -(115 + 187))) then v74=1;end break;end if (0==v168) then v169=0 + 0 ;for v206,v207 in ipairs(Map.getCreatureIds(true,false) or {} ) do local v208=Creature.new(v207);if (v208 and (v208:getType()==Enums.CreatureTypes.CREATURETYPE_MONSTER)) then v169=v169 + 1 ;break;end end v168=1 + 0 ;end end end end v72=19 -14 ;break;end if (v119==(1161 -(160 + 1001))) then v82=os.time()<=v15 ;if ( not v82 and v75 and (v14<(os.time() -1))) then if (v81~=creatureGetDirection(Player.getId())) then local v170=0 + 0 ;local v171;while true do if (v170==0) then v171=0 + 0 ;while true do if (v171==(0 -0)) then v14=os.time();Game.turn(v81);break;end end break;end end end end v119=359 -(237 + 121) ;end end end if (v72==(903 -(525 + 372))) then if v78 then v22(v7("\249\16\248\16\53\200\22\250\27\122","\90\191\127\148\124")   .. string.upper(v12)   .. ".\nPress ESC (2x fast) to cancel." );end if ((v80.x~=v16.x) or (v80.y~=v16.y) or (v80.z~=v16.z)) then local v139=0 -0 ;while true do if (v139==0) then v17=v16;v16=v80;break;end end end v83=Map.getCameraPosition();v72=22 -15 ;end if ((150 -(96 + 46))==v72) then local v120=777 -(643 + 134) ;while true do if (v120==1) then if ((v80.z==v83.z) and (v17.x>(0 + 0)) and (v17.y>(0 -0))) then if ((math.abs(v80.x-v17.x )>=4) or (math.abs(v80.y-v17.y )>=4)) then if walkFloorChange(v17,v27) then return;end end end v72=9;break;end if (0==v120) then if v82 then return;end if (v80.z~=v83.z) then local v162=0 -0 ;local v163;local v164;local v165;while true do if (v162==(0 + 0)) then v163=0;v164=nil;v162=1;end if (v162==(1 -0)) then v165=nil;while true do if ((0 -0)==v163) then local v209=0;while true do if (v209==(719 -(316 + 403))) then v164=v80.z<v17.z ;v165=v80.z>v17.z ;v209=1;end if (v209==1) then v163=1 + 0 ;break;end end end if ((5 -3)==v163) then if walkFloorChange(v17,v27) then return;end break;end if (v163==(1 + 0)) then if v164 then local v221=0 -0 ;while true do if (v221==(0 + 0)) then if walkLadder(v17) then return;end if walkRope(v17) then return;end v221=1 + 0 ;end if (v221==(3 -2)) then if walkFloorChange(v17,v28) then return;end break;end end end if v165 then local v222=0 -0 ;while true do if (v222==(1 -0)) then if walkFloorChange(v17,v29) then return;end break;end if (v222==0) then if walkSewer(v17) then return;end if walkFloorChange(v17,v26) then return;end v222=1 + 0 ;end end end v163=3 -1 ;end end break;end end end v120=1;end end end if (v72==(1 + 6)) then v84=math.abs(v80.x-v83.x );v85=math.abs(v80.y-v83.y );if ((v73==v7("\124\130\40\22\109\139\58","\119\24\231\78")) and (v80.z==v83.z)) then local v140=0 -0 ;local v141;local v142;while true do if (v140==(18 -(12 + 5))) then if (v141 or v142) then return;end break;end if (v140==(0 -0)) then v141=(v84==v74) and (v85<=v74) ;v142=(v84<=v74) and (v85==v74) ;v140=1 -0 ;end end end v72=16 -8 ;end if (v72==(0 -0)) then if  not Client.isConnected() then return;end v73,v74,v75,v76=getSettings();v77=Player.getFollowId();v72=1;end if (v72==(2 + 7)) then if (v80.z==v83.z) then local v143;local v144;if (v73==v7("\145\57\164\73\215","\113\226\77\197\42\188\32")) then v143=v80.x;v144=v80.y;end if (v73==v7("\62\19\242\180\47\26\224","\213\90\118\148")) then if ((v84==0) and (v85==(1973 -(1656 + 317))) and (v80.z==v83.z)) then return;end local v156=math.huge;for v166= -v74,v74 do for v167= -v74,v74 do if ((math.abs(v166)==v74) or (math.abs(v167)==v74)) then local v173=v80.x + v166 ;local v174=v80.y + v167 ;local v175=math.abs(v173-v83.x ) + math.abs(v174-v83.y ) ;if ((v175<v156) and isTileSafeWalkable(v173,v174,v80.z)) then v143=v173;v144=v174;v156=v175;end end end end end if (v73==v7("\89\43\188\95\67\95","\45\59\78\212\54")) then local v157=0;while true do if (v157==(0 + 0)) then if (v81==Enums.Directions.NORTH) then v143=v80.x;v144=v80.y + v74 ;end if (v81==Enums.Directions.SOUTH) then v143=v80.x;v144=v80.y-v74 ;end v157=1 + 0 ;end if ((2 -1)==v157) then if (v81==Enums.Directions.WEST) then local v185=0 -0 ;while true do if (v185==(354 -(5 + 349))) then v143=v80.x + v74 ;v144=v80.y;break;end end end if (v81==Enums.Directions.EAST) then v143=v80.x-v74 ;v144=v80.y;end break;end end end if (v73==v7("\22\68\140\133\146","\144\112\54\227\235\230\78\205")) then local v158=0 -0 ;while true do if (v158==1) then if (v81==Enums.Directions.WEST) then local v187=1271 -(266 + 1005) ;local v188;while true do if (v187==0) then v188=0 + 0 ;while true do if ((0 -0)==v188) then v143=v80.x-v74 ;v144=v80.y;break;end end break;end end end if (v81==Enums.Directions.EAST) then v143=v80.x + v74 ;v144=v80.y;end break;end if (v158==(0 -0)) then if (v81==Enums.Directions.NORTH) then local v190=1696 -(561 + 1135) ;local v191;while true do if (v190==(0 -0)) then v191=0;while true do if ((0 -0)==v191) then v143=v80.x;v144=v80.y-v74 ;break;end end break;end end end if (v81==Enums.Directions.SOUTH) then v143=v80.x;v144=v80.y + v74 ;end v158=1;end end end if (v73==v7("\191\45\9\232","\59\211\72\111\156\176")) then local v159=1066 -(507 + 559) ;while true do if (v159==0) then if (v81==Enums.Directions.NORTH) then local v193=0;while true do if (v193==(0 -0)) then v143=v80.x-v74 ;v144=v80.y;break;end end end if (v81==Enums.Directions.SOUTH) then local v194=0;local v195;while true do if (v194==(0 -0)) then v195=0;while true do if (v195==(388 -(212 + 176))) then v143=v80.x + v74 ;v144=v80.y;break;end end break;end end end v159=906 -(250 + 655) ;end if (v159==(2 -1)) then if (v81==Enums.Directions.WEST) then local v196=0 -0 ;while true do if (v196==0) then v143=v80.x;v144=v80.y + v74 ;break;end end end if (v81==Enums.Directions.EAST) then local v197=0;while true do if (v197==(0 -0)) then v143=v80.x;v144=v80.y-v74 ;break;end end end break;end end end if (v73==v7("\92\142\228\37\90","\77\46\231\131")) then local v160=0;while true do if (v160==(1957 -(1869 + 87))) then if (v81==Enums.Directions.WEST) then local v198=0 -0 ;while true do if (v198==0) then v143=v80.x;v144=v80.y-v74 ;break;end end end if (v81==Enums.Directions.EAST) then local v199=1901 -(484 + 1417) ;local v200;while true do if (v199==0) then v200=0 -0 ;while true do if (v200==0) then v143=v80.x;v144=v80.y + v74 ;break;end end break;end end end break;end if (v160==(0 -0)) then if (v81==Enums.Directions.NORTH) then local v201=773 -(48 + 725) ;local v202;while true do if (v201==0) then v202=0 -0 ;while true do if (v202==0) then v143=v80.x + v74 ;v144=v80.y;break;end end break;end end end if (v81==Enums.Directions.SOUTH) then local v203=0;while true do if (v203==(0 -0)) then v143=v80.x-v74 ;v144=v80.y;break;end end end v160=1;end end end if (v143 and v144) then if ((v73==v7("\169\64\183\67\177","\32\218\52\214")) or isTileSafeWalkable(v143,v144,v80.z)) then Map.goTo(v143,v144,v80.z);end end end break;end if ((2 + 1)==v72) then v12=v79:getName() or "" ;v80=v79:getPosition();v81=v79:getDirection();v72=10 -6 ;end if (v72==5) then local v121=0;while true do if ((0 + 0)==v121) then if ( not v82 and  not v80 and (v16.x>0) and (v16.y>(0 + 0)) and (v16.z>0) and  not Map.getPlayerOnScreen(v11)) then if walkSewer(v16) then return;end if walkFloorChange(v16,v26) then return;end if walkFloorChange(v16,v29) then return;end if walkFloorChange(v16,v27) then return;end end if  not v80 then return;end v121=854 -(152 + 701) ;end if (v121==(1312 -(430 + 881))) then v18:setText(getFollowText());v72=6;break;end end end end end,100,true);function walkWith(v86,v87,v88) local v89=0 + 0 ;local v90;while true do if (v89==(895 -(557 + 338))) then v90=0 + 0 ;while true do if (v90==(0 -0)) then local v150=0 -0 ;while true do if (v150==(0 -0)) then for v172= -(2 -1),802 -(499 + 302)  do for v176= -(867 -(39 + 827)),2 -1  do local v177=0;local v178;local v179;local v180;while true do if (v177==(2 -1)) then v180=v86.z;for v219,v220 in ipairs(Map.getThings(v178,v179,v180) or {} ) do if (v220.id and table._includes(v87,tonumber(v220.id))) then local v223=0 -0 ;while true do if (v223==(0 -0)) then local v229=0 + 0 ;while true do if (v229==(0 -0)) then v88(v178,v179,v180,v220);return true;end end end end end end break;end if (v177==(0 + 0)) then local v211=0 -0 ;local v212;while true do if (v211==0) then v212=0;while true do if (v212==1) then v177=105 -(103 + 1) ;break;end if ((554 -(475 + 79))==v212) then v178=v86.x + v172 ;v179=v86.y + v176 ;v212=1;end end break;end end end end end end return false;end end end end break;end end end function walkFloorChange(v91,v92) return walkWith(v91,v92,function(v108,v109,v110) Map.goTo(v108,v109,v110);end);end function walkLadder(v93) return walkWith(v93,v23,function(v111,v112,v113) Game.useItemFromGround(v111,v112,v113);end);end function walkSewer(v94) return walkWith(v94,v24,function(v114,v115,v116) Game.useItemFromGround(v114,v115,v116);end);end function walkRope(v95) local v96=0;local v97;while true do if ((0 -0)==v96) then v97={389 + 2614 ,646,11097 -(1395 + 108) ,9596,10802 -(7 + 1197) };return walkWith(v95,v25,function(v130,v131,v132) for v145,v146 in ipairs(v97) do if (Game.getItemCount(v146)>(0 + 0)) then local v161=0 + 0 ;while true do if (v161==(319 -(27 + 292))) then Game.useItemOnGround(v146,v130,v131,v132);return true;end end end end end);end end end

end

-- =========================
-- Modulo embutido: Reset FPS
-- =========================
function FabioRockeiroBOT.loadResetFpsModule()
--[[
=========================================================
 RESET FPS - Fabio Rockeiro - AvaloriumOT
=========================================================
 Faz RESET FPS com X-Log nativo automaticamente com preparacao por vocacao.

 Vocacoes:
 - Mage (MS/ED): usa utamo vita antes do X-Log
 - RP/MK: equipa energy ring id 3051 antes do X-Log
 - EK: usa utamo tempo antes do X-Log

 Clique no icone para minimizar/expandir.
 Clique no status para ligar/desligar.
 Clique em [VOC] para escolher a vocacao.
 Clique no cronometro para forcar o logout agora.
=========================================================
]]

do
local SCRIPT_NAME = "RESET FPS - Fabio Rockeiro - AvaloriumOT"

-- =========================
-- CONFIG
-- =========================
local Config = {
    enabled = false,              -- true = inicia ligado, false = inicia desligado
    intervalMinutes = 30,         -- tempo em minutos para executar RESET FPS
    selectedVocation = "MAGE",    -- MAGE, RPMK ou EK

    logoutHotkey = "ctrl+l",      -- fallback caso Client.XLog nao exista
    logoutLabel = "RESET FPS",
    iconItemId = 63135,
    energyRingId = 3051,
    energyRingEquippedIds = { 3051, 3088 }, -- adicione aqui outro id se o ring equipado mudar no seu OT

    hudStartX = 420,
    hudStartY = 560,

    preActionDelayMs = 900,       -- espera entre preparacao e X-Log
    checkIntervalMs = 500,        -- atualizacao do cronometro
}

-- =========================
-- ESTADO
-- =========================
local hud = {}
local attachedHudElements = {}
local vocationModal = nil
local nextRunAt = 0
local lastStatus = "Aguardando"
local running = false
local parsedLogoutHotkey = nil
local hudMinimized = false

local colors = {
    title = { 255, 224, 128 },
    active = { 80, 255, 140 },
    inactive = { 255, 90, 90 },
    info = { 150, 210, 255 },
    neutral = { 220, 220, 220 },
}

local vocations = {
    MAGE = {
        label = "Mage MS/ED",
        short = "Mage",
        action = "spell",
        words = "utamo vita",
    },
    RPMK = {
        label = "RP/MK",
        short = "RP/MK",
        action = "ring",
        itemId = Config.energyRingId,
    },
    EK = {
        label = "EK",
        short = "EK",
        action = "spell",
        words = "utamo tempo",
    },
}

local function talkType()
    if Enums and Enums.TalkTypes and Enums.TalkTypes.TALKTYPE_SAY then
        return Enums.TalkTypes.TALKTYPE_SAY
    end

    return 1
end

local function setColor(item, color)
    if item and color then
        item:setColor(color[1], color[2], color[3])
    end
end

local function log(message)
    print("[RESET FPS] " .. tostring(message))
end

local function showMessage(message)
    log(message)

    if Client and Client.showMessage then
        Client.showMessage("[RESET FPS]\n" .. tostring(message))
    end
end

local function safeCall(label, fn)
    local ok, err = pcall(fn)
    if not ok then
        lastStatus = "Erro: " .. tostring(label)
        log("ERRO " .. tostring(label) .. ": " .. tostring(err))
        return false
    end

    return true
end

local function intervalSeconds()
    local minutes = tonumber(Config.intervalMinutes) or 1
    if minutes < 1 then minutes = 1 end
    return minutes * 60
end

local function resetCountdown()
    nextRunAt = os.time() + intervalSeconds()
end

local function secondsLeft()
    if not Config.enabled then return 0 end

    local left = nextRunAt - os.time()
    if left < 0 then left = 0 end
    return left
end

local function formatTimer(totalSeconds)
    totalSeconds = math.max(0, tonumber(totalSeconds) or 0)

    local minutes = math.floor(totalSeconds / 60)
    local seconds = totalSeconds % 60

    return string.format("%02d:%02d", minutes, seconds)
end

local function selectedVocation()
    return vocations[Config.selectedVocation] or vocations.MAGE
end

local function attachHudElement(item, offsetX, offsetY)
    table.insert(attachedHudElements, {
        item = item,
        offsetX = offsetX,
        offsetY = offsetY,
    })
end

local function createText(offsetX, offsetY, text, color, callback)
    local item = HUD.new(Config.hudStartX + offsetX, Config.hudStartY + offsetY, text, true)
    item:setDraggable(false)
    setColor(item, color or colors.neutral)

    if callback then
        item:setCallback(callback)
    end

    attachHudElement(item, offsetX, offsetY)
    return item
end

local function castWords(words)
    if not words or words == "" then return false end

    Game.talk(words, talkType())
    return true
end

local function ringEquipped(itemId)
    if not Player or not Player.getInventorySlot then return false end
    if not Enums or not Enums.InventorySlot then return false end

    local slot = Player.getInventorySlot(Enums.InventorySlot.CONST_SLOT_RING)
    if not slot then return false end

    for _, equippedId in ipairs(Config.energyRingEquippedIds or { itemId }) do
        if tonumber(slot.id) == tonumber(equippedId) then
            return true
        end
    end

    return false
end

local function equipRing(itemId)
    if ringEquipped(itemId) then
        return true
    end

    if not Game or not Game.equipItem then
        return false
    end

    Game.equipItem(itemId, 0)
    return true
end

local function parseLogoutHotkey()
    if HotkeyManager and HotkeyManager.parseKeyCombination then
        local success, modifiers, key = HotkeyManager.parseKeyCombination(Config.logoutHotkey)
        if success and key then
            parsedLogoutHotkey = {
                key = tonumber(key) or key,
                modifiers = modifiers or 0,
            }
            return true
        end
    end

    if HotkeyManager and HotkeyManager.keyMapping and Enums and Enums.FlagModifiers then
        parsedLogoutHotkey = {
            key = HotkeyManager.keyMapping.l,
            modifiers = Enums.FlagModifiers.CONTROL,
        }
        return true
    end

    return false
end

local function prepareByVocation()
    local vocation = selectedVocation()

    if vocation.action == "spell" then
        lastStatus = "Usando " .. vocation.words
        return castWords(vocation.words)
    end

    if vocation.action == "ring" then
        lastStatus = "Equipando ring " .. tostring(vocation.itemId)
        return equipRing(vocation.itemId)
    end

    return true
end

local function sendResetFpsAction()
    lastStatus = "Executando " .. Config.logoutLabel

    if Client and Client.XLog then
        Client.XLog()
        return true
    end

    if not parsedLogoutHotkey and not parseLogoutHotkey() then
        lastStatus = "X-Log/hotkey indisponivel"
        return false
    end

    if not Client or not Client.sendHotkey then
        lastStatus = "Client.sendHotkey indisponivel"
        return false
    end

    if Client.focus then
        Client.focus()
    end

    if wait then
        wait(150)
    end

    Client.sendHotkey(parsedLogoutHotkey.key, parsedLogoutHotkey.modifiers)
    return true
end

local function runLogoutCycle(manual)
    if running then return end

    if Client and Client.isConnected and not Client.isConnected() then
        lastStatus = "Cliente desconectado"
        return
    end

    running = true

    safeCall(manual and "logout manual" or "logout automatico", function()
        prepareByVocation()

        if wait then
            wait(Config.preActionDelayMs)
        end

        if sendResetFpsAction() then
            lastStatus = manual and "Manual enviado" or "Auto enviado"
            resetCountdown()
        end
    end)

    running = false
end

local function setHudVisible(item, visible)
    if not item then return end

    if visible then
        item:show()
    else
        item:hide()
    end
end

local function applyHudMode(iconPos)
    if hudMinimized then
        setHudVisible(hud.title, false)
        setHudVisible(hud.status, false)
        setHudVisible(hud.voc, false)
        setHudVisible(hud.now, false)
        setHudVisible(hud.last, false)
        setHudVisible(hud.timer, true)

        local timerX = Config.hudStartX - 6
        local timerY = Config.hudStartY + 36

        if iconPos and (iconPos.x ~= 0 or iconPos.y ~= 0) then
            timerX = iconPos.x - 6
            timerY = iconPos.y + 36
        end

        hud.timer:setPos(timerX, timerY)

        return
    end

    setHudVisible(hud.title, true)
    setHudVisible(hud.status, true)
    setHudVisible(hud.timer, true)
    setHudVisible(hud.voc, true)
    setHudVisible(hud.now, true)
    setHudVisible(hud.last, true)
end

local function updateHud()
    local pos = hud.icon:getPos()
    if pos and (pos.x ~= 0 or pos.y ~= 0) then
        for _, element in ipairs(attachedHudElements) do
            element.item:setPos(pos.x + element.offsetX, pos.y + element.offsetY)
        end
    end

    local vocation = selectedVocation()
    local statusText = Config.enabled and "[ON]" or "[OFF]"
    local statusColor = Config.enabled and colors.active or colors.inactive

    hud.title:setText(SCRIPT_NAME)
    hud.status:setText(statusText .. " " .. vocation.short .. " | " .. tostring(Config.intervalMinutes) .. " min")
    hud.timer:setText(formatTimer(secondsLeft()) .. " " .. Config.logoutLabel)
    hud.voc:setText("[VOC] " .. vocation.label)
    hud.now:setText("[USAR AGORA]")
    hud.last:setText(lastStatus)

    setColor(hud.status, statusColor)
    setColor(hud.timer, Config.enabled and colors.active or colors.neutral)
    setColor(hud.voc, colors.info)
    setColor(hud.now, colors.info)
    setColor(hud.last, colors.neutral)

    if hud.icon and hud.icon.setOpacity then
        hud.icon:setOpacity(Config.enabled and 1.0 or 0.55)
    end

    applyHudMode(pos)
end

local function toggleHudMinimized()
    hudMinimized = not hudMinimized
    updateHud()
end

local function toggleEnabled()
    Config.enabled = not Config.enabled

    if Config.enabled then
        lastStatus = "Ativado"
        resetCountdown()
        showMessage("Ativado. Proximo RESET FPS em " .. tostring(Config.intervalMinutes) .. " min.")
    else
        lastStatus = "Pausado"
        showMessage("Pausado.")
    end

    updateHud()
end

local function destroyVocationModal()
    if vocationModal then
        vocationModal:destroy()
        vocationModal = nil
    end
end

local function addModalButton(modal, actions, text, action)
    actions[modal:addButton(text)] = action
end

local function openVocationModal()
    destroyVocationModal()

    local modal = CustomModalWindow.new("RESET FPS", "Escolha a vocacao/config.")
    local actions = {}
    vocationModal = modal

    addModalButton(modal, actions, (Config.selectedVocation == "MAGE" and "[ON] " or "") .. "Mage MS/ED", function()
        Config.selectedVocation = "MAGE"
        lastStatus = "Voc: Mage"
    end)

    addModalButton(modal, actions, (Config.selectedVocation == "RPMK" and "[ON] " or "") .. "RP/MK", function()
        Config.selectedVocation = "RPMK"
        lastStatus = "Voc: RP/MK"
    end)

    addModalButton(modal, actions, (Config.selectedVocation == "EK" and "[ON] " or "") .. "EK", function()
        Config.selectedVocation = "EK"
        lastStatus = "Voc: EK"
    end)

    addModalButton(modal, actions, Config.enabled and "Desativar" or "Ativar", function()
        Config.enabled = not Config.enabled
        lastStatus = Config.enabled and "Ativado" or "Pausado"
        if Config.enabled then resetCountdown() end
    end)

    addModalButton(modal, actions, "-1 min", function()
        Config.intervalMinutes = math.max(1, Config.intervalMinutes - 1)
        resetCountdown()
        lastStatus = "Min: " .. tostring(Config.intervalMinutes)
    end)

    addModalButton(modal, actions, "+1 min", function()
        Config.intervalMinutes = Config.intervalMinutes + 1
        resetCountdown()
        lastStatus = "Min: " .. tostring(Config.intervalMinutes)
    end)

    addModalButton(modal, actions, "Usar agora", function()
        runLogoutCycle(true)
    end)

    modal:setCallback(function(buttonId)
        local action = actions[buttonId]
        if action then
            action()
        end

        destroyVocationModal()
        updateHud()
    end)
end

-- =========================
-- HUD
-- =========================
hud.icon = HUD.new(Config.hudStartX, Config.hudStartY, Config.iconItemId, true)
hud.icon:setDraggable(true)
hud.icon:setScale(1.15)
hud.icon:setCallback(toggleHudMinimized)

hud.title = createText(38, -8, SCRIPT_NAME, colors.title, toggleEnabled)
hud.status = createText(38, 8, "", colors.inactive, toggleEnabled)
hud.timer = createText(38, 24, "", colors.neutral, function()
    runLogoutCycle(true)
end)
hud.voc = createText(38, 42, "", colors.info, openVocationModal)
hud.now = createText(38, 60, "", colors.info, function()
    runLogoutCycle(true)
end)
hud.last = createText(150, 60, "", colors.neutral, openVocationModal)

resetCountdown()
parseLogoutHotkey()
updateHud()

Timer("logoutFabioRockeiroHud", function()
    safeCall("hud", updateHud)
end, Config.checkIntervalMs)

Timer("logoutFabioRockeiroAuto", function()
    safeCall("timer", function()
        if not Config.enabled then return end
        if running then return end

        if nextRunAt > 0 and os.time() >= nextRunAt then
            runLogoutCycle(false)
        end
    end)
end, 1000)

showMessage("Script carregado. Icone minimiza/expande. Status liga/desliga. [VOC] configura.")

end

end

-- =========================
-- Modulo embutido: Craft House
-- =========================
function FabioRockeiroBOT.loadCraftHouseModule()
--[[
=========================================================
 CRAFT HOUSE AVALORIUM - Fabio Rockeiro - V6 USE GROUND STATION
=========================================================
Script para ZeroBot / OTC-style Lua API.
Versao blindada + conversa com NPC + uso real da mesa no chao.

Fluxo:
1) Clique no icone lateral grande para abrir/fechar o painel.
2) Clique em uma mesinha pequena para ATIVAR o craft dela.
3) A mesinha ativada vira o icone lateral grande.
4) O bot verifica o refill necessario na backpack.
5) Se estiver abaixo do MIN, fala com o NPC da house e compra ate o MAX.
6) Usa a mesinha para iniciar/continuar o craft.
7) Se a mesa disser que ja esta em uso, o bot nao faz nada e aguarda.

Criado por: Fabio Rockeiro
=========================================================
]]

do

-- =========================
-- CONFIGURACAO GERAL
-- =========================
local SCRIPT_NAME = "CRAFT HOUSE AVALORIUM - Fabio Rockeiro"
local SCRIPT_VERSION = "V6 USE GROUND STATION"

-- posicao inicial do HUD
local hudStartX = 420
local hudStartY = 455

-- tamanhos dos icones
local bigIconScale = 2.25
local smallIconScale = 1.35
local selectedSmallIconScale = 1.55

-- intervalos
local checkIntervalMs = 5000          -- checagem geral
local afterUseDelayMs = 8000          -- tempo para tentar usar a mesa novamente
local afterBuyDelayMs = 1500          -- tempo depois de comprar
local stationSearchRadius = 7          -- quantos SQMs ao redor procurar pela mesa
local npcTalkDelayMs = 700            -- delay entre falas no NPC
local npcFirstReplyDelayMs = 1200      -- delay maior depois do hi, pois abre a aba/chat do NPC
local TALKTYPE_NPC = (Enums and Enums.TalkTypes and Enums.TalkTypes.TALKTYPE_PRIVATE_PN) or 12 -- chat de NPC

-- quantidades padrao
local minRefillAmount = 100           -- se tiver <= isso, compra
local maxRefillAmount = 300           -- tenta completar ate isso
local minStep = 50                    -- clique no MIN muda de 50 em 50
local maxStep = 50                    -- clique no MAX muda de 50 em 50

-- icone inicial antes de selecionar mesa
local defaultIconItemId = 63257

-- falas do NPC de house
local npcMessages = {
    "hi",
    "service",
    "goods",
    "tools",
}

-- Ordem informada do NPC:
-- 1 = black ammo refill
-- 2 = black flask refill
-- 3 = black rune refill
local refillItems = {
    ammo =  { id = 63223, name = "black ammo refill",  npcOrder = 1 },
    flask = { id = 63225, name = "black flask refill", npcOrder = 2 },
    rune =  { id = 63224, name = "black rune refill",  npcOrder = 3 },
}

local stations = {
    -- RUNES - usa black rune refill 63224
    { id = 63257, label = "SD",            fullName = "enhanced sudden death rune station",       refillType = "rune" },
    { id = 63261, label = "GFB",           fullName = "enhanced great fireball rune station",      refillType = "rune" },
    { id = 63263, label = "Avalanche",     fullName = "enhanced avalanche rune station",           refillType = "rune" },
    { id = 63255, label = "Thunder",       fullName = "enhanced thunderstorm rune station",        refillType = "rune" },
    { id = 63256, label = "Stone",         fullName = "enhanced stone shower rune station",        refillType = "rune" },
    { id = 63253, label = "UH",            fullName = "enhanced ultimate healing rune station",    refillType = "rune" },

    -- POTIONS - usa black flask refill 63225
    { id = 63258, label = "Supreme HP",    fullName = "enhanced supreme health potion station",    refillType = "flask" },
    { id = 63264, label = "Berserk",       fullName = "enhanced berserk potion station",           refillType = "flask" },
    { id = 63250, label = "USP",           fullName = "enhanced ultimate spirit potion station",   refillType = "flask" },
    { id = 63254, label = "UMP",           fullName = "enhanced ultimate mana potion station",     refillType = "flask" },
    { id = 63259, label = "Mastermind",    fullName = "enhanced mastermind potion station",        refillType = "flask" },
    { id = 63262, label = "Bullseye",      fullName = "enhanced bullseye potion station",          refillType = "flask" },

    -- AMMO - usa black ammo refill 63223
    { id = 63252, label = "Spectral",      fullName = "enhanced spectral bolt station",            refillType = "ammo" },
    { id = 63251, label = "Diamond",       fullName = "enhanced diamond arrow station",            refillType = "ammo" },
}

-- =========================
-- ESTADO
-- =========================
local enabled = false
local expanded = false
local selectedStationIndex = nil

local lastActionAt = 0
local nextActionAt = 0
local isBuying = false
local lastStatus = "Desativado"
local lastNpcStepAt = 0
local npcStepIndex = 0
local pendingBuyType = nil

local hud = { stationEntries = {} }
local attachedHudElements = {}

-- =========================
-- HELPERS
-- =========================
local function nowMs()
    return math.floor(os.clock() * 1000)
end

local function lower(value)
    return string.lower(tostring(value or ""))
end

local function log(message)
    print("[CRAFT HOUSE AVALORIUM] " .. tostring(message))
end

local function showMessage(message)
    log(message)
    if Client and Client.showMessage then
        Client.showMessage("[CRAFT HOUSE]\n" .. tostring(message))
    end
end

local function safeCall(label, fn)
    local ok, err = pcall(fn)
    if not ok then
        lastStatus = "Erro: " .. tostring(label)
        log("ERRO em " .. tostring(label) .. ": " .. tostring(err))
        if Client and Client.showMessage then
            Client.showMessage("[CRAFT HOUSE]\nErro em " .. tostring(label) .. "\n" .. tostring(err))
        end
    end
    return ok
end

local function safeSetText(item, text)
    if item and item.setText then item:setText(tostring(text or "")) end
end

local function safeSetItemId(item, itemId)
    if item and item.setItemId and itemId then item:setItemId(itemId) end
end

local function safeSetScale(item, scale)
    if item and item.setScale then item:setScale(scale) end
end


local function getSelectedStation()
    if not selectedStationIndex then return nil end
    return stations[selectedStationIndex]
end

local function getRefillForStation(station)
    if not station then return nil end
    return refillItems[station.refillType]
end

local function getItemCount(itemId)
    if Game and Game.getItemCount then
        return Game.getItemCount(itemId) or 0
    end

    return 0
end

local function setHudColor(item, r, g, b)
    if item then item:setColor(r, g, b) end
end

local function setHudVisible(item, visible)
    if not item then return end

    if visible then
        item:show()
    else
        item:hide()
    end
end

local function attachHudElement(item, offsetX, offsetY)
    table.insert(attachedHudElements, {
        item = item,
        offsetX = offsetX,
        offsetY = offsetY,
    })
end

local function createText(offsetX, offsetY, text, r, g, b, callback)
    local item = HUD.new(hudStartX + offsetX, hudStartY + offsetY, text, true)
    item:setDraggable(false)
    item:setColor(r or 255, g or 255, b or 255)

    if callback then
        item:setCallback(callback)
    end

    attachHudElement(item, offsetX, offsetY)
    return item
end

local function createItem(offsetX, offsetY, itemId, callback)
    local item = HUD.new(hudStartX + offsetX, hudStartY + offsetY, itemId, true)
    item:setDraggable(false)

    if callback then
        item:setCallback(callback)
    end

    attachHudElement(item, offsetX, offsetY)
    return item
end

local function updateHudVisibility()
    for _, element in ipairs(attachedHudElements) do
        setHudVisible(element.item, expanded)
    end
end

local function sendNpcText(text)
    text = tostring(text or "")
    if text == "" then return false end

    -- IMPORTANTE:
    -- No ZeroBot, fala de NPC usa TALKTYPE_PRIVATE_PN (12).
    -- Isso faz o texto ir para a aba/chat do NPC depois do "hi".
    local function try(label, fn)
        local ok, err = pcall(fn)
        if ok then
            return true
        end
        log("Falha ao falar NPC via " .. tostring(label) .. ": " .. tostring(err))
        return false
    end

    if Game and Game.talk then
        if try("Game.talk(text, TALKTYPE_PRIVATE_PN)", function()
            Game.talk(text, TALKTYPE_NPC)
        end) then return true end
    end

    -- Fallbacks apenas para nao travar em versoes diferentes.
    -- O fluxo correto continua sendo o TALKTYPE_PRIVATE_PN acima.
    if Npc and Npc.say then
        if try("Npc.say", function() Npc.say(text) end) then return true end
    end

    if NPC and NPC.say then
        if try("NPC.say", function() NPC.say(text) end) then return true end
    end

    if Client and Client.sendMessage then
        if try("Client.sendMessage", function() Client.sendMessage(text) end) then return true end
    end

    return false
end

local function tryNpcBuy(itemId, amount)
    itemId = tonumber(itemId or 0) or 0
    amount = tonumber(amount or 0) or 0
    if itemId <= 0 or amount <= 0 then return false end

    local function try(label, fn)
        local ok, err = pcall(fn)
        if ok then
            log("Compra tentou via " .. tostring(label))
            return true
        end
        log("Falha compra via " .. tostring(label) .. ": " .. tostring(err))
        return false
    end

    -- Varia conforme a API do bot. As tentativas ficam protegidas para nao remover o script.
    -- Na documentacao atual do ZeroBot, o namespace correto e Npc.buy.
    if Npc and Npc.buy then
        if try("Npc.buy(id, qtd, false, false)", function() Npc.buy(itemId, amount, false, false) end) then return true end
        if try("Npc.buy(id, qtd)", function() Npc.buy(itemId, amount) end) then return true end
    end

    -- Compatibilidade com scripts antigos que usam NPC maiusculo.
    if NPC and NPC.buy then
        if try("NPC.buy(id, qtd, false, false)", function() NPC.buy(itemId, amount, false, false) end) then return true end
        if try("NPC.buy(id, qtd)", function() NPC.buy(itemId, amount) end) then return true end
    end

    if Game and Game.npcBuy then
        if try("Game.npcBuy(id, qtd, false, false)", function() Game.npcBuy(itemId, amount, false, false) end) then return true end
        if try("Game.npcBuy(id, qtd)", function() Game.npcBuy(itemId, amount) end) then return true end
    end

    if Game and Game.buyItem then
        if try("Game.buyItem(id, qtd)", function() Game.buyItem(itemId, amount) end) then return true end
        if try("Game.buyItem(id, qtd, false, false)", function() Game.buyItem(itemId, amount, false, false) end) then return true end
    end

    if NPC and NPC.buyItem then
        if try("NPC.buyItem(id, qtd)", function() NPC.buyItem(itemId, amount) end) then return true end
        if try("NPC.buyItem(id, qtd, false, false)", function() NPC.buyItem(itemId, amount, false, false) end) then return true end
    end

    return false
end

local scheduleNext

local function getPlayerPosition()
    local function try(label, fn)
        local ok, result = pcall(fn)
        if ok and result and result.x and result.y and result.z then
            return result
        end
        if not ok then
            log("Falha pegando posicao via " .. tostring(label) .. ": " .. tostring(result))
        end
        return nil
    end

    if Player and Player.getId and Creature and Creature.new then
        local pos = try("Creature.new(Player.getId()):getPosition", function()
            local creature = Creature.new(Player.getId())
            return creature and creature:getPosition()
        end)
        if pos then return pos end
    end

    if Player and Player.getId and Creature then
        local pos = try("Creature(Player.getId()):getPosition", function()
            local creature = Creature(Player.getId())
            return creature and creature:getPosition()
        end)
        if pos then return pos end
    end

    if Map and Map.getCameraPosition then
        local pos = try("Map.getCameraPosition", function()
            return Map.getCameraPosition()
        end)
        if pos then return pos end
    end

    return nil
end

local function getThingId(thing)
    if type(thing) ~= "table" then return nil end

    local candidates = {
        thing.id,
        thing.itemId,
        thing.itemid,
        thing.clientId,
        thing.clientID,
        thing.type,
        thing.typeId,
        thing.typeID,
    }

    for _, value in ipairs(candidates) do
        local id = nil
        if type(value) == "number" then
            id = value
        elseif type(value) == "string" then
            id = tonumber(value)
        end
        if id and id > 0 then return id end
    end

    if thing.item and type(thing.item) == "table" then
        return getThingId(thing.item)
    end

    return nil
end

local function tileHasItemId(x, y, z, itemId)
    if not Map or not Map.getThings then return false end

    local ok, things = pcall(function()
        return Map.getThings(x, y, z)
    end)

    if not ok or not things then return false end

    for _, thing in pairs(things) do
        local id = getThingId(thing)
        if id == itemId then
            return true
        end
    end

    return false
end

local function findStationPosition(stationId)
    stationId = tonumber(stationId or 0) or 0
    if stationId <= 0 then return nil end

    local playerPos = getPlayerPosition()
    if not playerPos then
        lastStatus = "Nao consegui ler posicao"
        return nil
    end

    -- Primeiro tenta pelo Map.getThings em volta do personagem.
    if Map and Map.getThings then
        for radius = 0, stationSearchRadius do
            for dx = -radius, radius do
                for dy = -radius, radius do
                    if math.max(math.abs(dx), math.abs(dy)) == radius then
                        local x = playerPos.x + dx
                        local y = playerPos.y + dy
                        local z = playerPos.z
                        if tileHasItemId(x, y, z, stationId) then
                            return { x = x, y = y, z = z }
                        end
                    end
                end
            end
        end
    end

    -- Fallback: tenta vasculhar tiles visiveis, se a API trouxer things/position no retorno.
    if Map and Map.getTiles then
        local ok, tiles = pcall(function()
            return Map.getTiles()
        end)

        if ok and tiles then
            for _, tile in pairs(tiles) do
                local pos = tile.position or tile.pos or tile
                local things = tile.things or tile.items or tile

                if pos and pos.x and pos.y and pos.z and things then
                    for _, thing in pairs(things) do
                        local id = getThingId(thing)
                        if id == stationId then
                            return { x = pos.x, y = pos.y, z = pos.z }
                        end
                    end
                end
            end
        end
    end

    return nil
end

local function useGroundAtPosition(itemId, pos)
    if not pos then return false end

    local function try(label, fn)
        local ok, result = pcall(fn)
        if ok and result ~= false then
            log("Usou mesa via " .. tostring(label) .. " em " .. pos.x .. "," .. pos.y .. "," .. pos.z)
            return true
        end
        if not ok then
            log("Falha use ground via " .. tostring(label) .. ": " .. tostring(result))
        end
        return false
    end

    -- Botao direito/use diretamente no item que esta no chao.
    if Game and Game.useItemFromGround then
        if try("Game.useItemFromGround(x,y,z)", function()
            return Game.useItemFromGround(pos.x, pos.y, pos.z)
        end) then return true end
    end

    -- Fallback: usa o ID informado na coordenada do chao.
    if Game and Game.useItemOnGround then
        if try("Game.useItemOnGround(id,x,y,z)", function()
            return Game.useItemOnGround(itemId, pos.x, pos.y, pos.z)
        end) then return true end
    end

    return false
end

local function useSelectedStationOnGround()
    local station = getSelectedStation()
    if not station then
        lastStatus = "Selecione uma mesa"
        scheduleNext(checkIntervalMs)
        return
    end

    local pos = findStationPosition(station.id)
    if not pos then
        lastStatus = "Mesa nao encontrada perto"
        showMessage("Nao encontrei a mesa " .. station.label .. " perto do personagem. Chegue perto dela ou aumente stationSearchRadius.")
        scheduleNext(checkIntervalMs)
        return
    end

    lastStatus = "Usando mesa no chao: " .. station.label
    if useGroundAtPosition(station.id, pos) then
        lastActionAt = nowMs()
        scheduleNext(afterUseDelayMs)
    else
        lastStatus = "Falha ao usar mesa no chao"
        scheduleNext(checkIntervalMs)
    end
end

scheduleNext = function(delayMs)
    nextActionAt = nowMs() + (delayMs or checkIntervalMs)
end

local function selectedRefillCount()
    local station = getSelectedStation()
    local refill = getRefillForStation(station)
    if not refill then return 0 end
    return getItemCount(refill.id)
end

local function getBuyAmount()
    local current = selectedRefillCount()
    local amount = maxRefillAmount - current
    if amount < 1 then amount = 0 end
    return amount
end

local function needBuy()
    local station = getSelectedStation()
    local refill = getRefillForStation(station)
    if not station or not refill then return false end

    return getItemCount(refill.id) <= minRefillAmount
end

local function startNpcBuyFlow()
    local station = getSelectedStation()
    local refill = getRefillForStation(station)

    if not station or not refill then
        lastStatus = "Nenhuma mesa selecionada"
        return
    end

    local amount = getBuyAmount()
    if amount <= 0 then
        lastStatus = "Qtd atual acima do MAX"
        scheduleNext(checkIntervalMs)
        return
    end

    isBuying = true
    pendingBuyType = station.refillType
    npcStepIndex = 1
    lastNpcStepAt = 0
    lastStatus = "Falando no chat NPC"
    showMessage("Comprando " .. amount .. "x " .. refill.name .. " pelo chat do NPC...")
end

local function processNpcBuyFlow()
    if not isBuying then return end

    local time = nowMs()
    local requiredDelay = npcTalkDelayMs

    -- Depois do "hi", da um tempo maior para o cliente abrir a aba/chat do NPC.
    if npcStepIndex == 2 then
        requiredDelay = npcFirstReplyDelayMs
    end

    if lastNpcStepAt > 0 and time - lastNpcStepAt < requiredDelay then
        return
    end

    lastNpcStepAt = time

    if npcStepIndex <= #npcMessages then
        local msg = npcMessages[npcStepIndex]
        if sendNpcText(msg) then
            lastStatus = "NPC: " .. msg
            npcStepIndex = npcStepIndex + 1
        else
            lastStatus = "Nao consegui falar com NPC"
            showMessage("Nao consegui enviar fala para o NPC. Confira a API de talk do bot.")
            isBuying = false
            pendingBuyType = nil
            npcStepIndex = 0
            scheduleNext(checkIntervalMs)
        end
        return
    end

    local station = getSelectedStation()
    local refill = getRefillForStation(station)
    local amount = getBuyAmount()

    if refill and amount > 0 then
        local ok = tryNpcBuy(refill.id, amount)

        if ok then
            lastStatus = "Compra enviada: " .. amount .. "x"
            showMessage("Compra enviada: " .. amount .. "x " .. refill.name)
        else
            lastStatus = "API de compra nao encontrada"
            showMessage("Nao encontrei a funcao de compra do NPC nesta API. O dialogo foi aberto, mas talvez precise clicar manual ou ajustar NPC.buy/Game.buyItem.")
        end
    else
        lastStatus = "Nao precisa comprar"
    end

    isBuying = false
    pendingBuyType = nil
    npcStepIndex = 0
    scheduleNext(afterBuyDelayMs)
end

local function useSelectedStation()
    -- Nao usa Game.useItem(station.id), porque isso tenta usar item da BP pelo ID.
    -- Aqui e botao direito/use na mesa que esta no chao perto do personagem.
    useSelectedStationOnGround()
end

local function selectStation(index)
    selectedStationIndex = index
    enabled = true
    expanded = true

    local station = getSelectedStation()
    if station then
        safeSetItemId(hud.anchor, station.id)
        safeSetScale(hud.anchor, bigIconScale)
        lastStatus = "ON: " .. station.label
        showMessage("Craft ativado: " .. station.fullName)
    end

    scheduleNext(500)
end

local function toggleEnabled()
    enabled = not enabled

    if enabled then
        if not selectedStationIndex then
            selectedStationIndex = 1
        end

        local station = getSelectedStation()
        if station then
            safeSetItemId(hud.anchor, station.id)
        end

        safeSetScale(hud.anchor, bigIconScale)
        lastStatus = "Ativado"
        scheduleNext(500)
        showMessage("Craft House ativado.")
    else
        isBuying = false
        pendingBuyType = nil
        lastStatus = "Desativado"
        showMessage("Craft House desativado.")
    end
end

local function toggleExpanded()
    expanded = not expanded
end

local function changeMin()
    minRefillAmount = minRefillAmount + minStep
    if minRefillAmount > 1000 then
        minRefillAmount = 0
    end

    if maxRefillAmount <= minRefillAmount then
        maxRefillAmount = minRefillAmount + maxStep
    end

    lastStatus = "MIN: " .. minRefillAmount
end

local function changeMax()
    maxRefillAmount = maxRefillAmount + maxStep
    if maxRefillAmount > 2000 then
        maxRefillAmount = minRefillAmount + maxStep
    end

    lastStatus = "MAX: " .. maxRefillAmount
end

local function updateHud()
    local station = getSelectedStation()
    local refill = getRefillForStation(station)
    local refillCount = refill and getItemCount(refill.id) or 0

    if station then
        safeSetItemId(hud.anchor, station.id)
    else
        safeSetItemId(hud.anchor, defaultIconItemId)
    end

    safeSetScale(hud.anchor, bigIconScale)

    safeSetText(hud.title, SCRIPT_NAME .. " " .. SCRIPT_VERSION)
    setHudColor(hud.title, 255, 224, 128)

    safeSetText(hud.status, (enabled and "[ON] " or "[OFF] ") .. lastStatus)
    if enabled then
        setHudColor(hud.status, 80, 255, 140)
    else
        setHudColor(hud.status, 255, 90, 90)
    end

    safeSetText(hud.selected, "Mesa: " .. (station and station.label or "nenhuma"))
    setHudColor(hud.selected, 220, 230, 240)

    safeSetText(hud.refill, "Refill: " .. (refill and refill.name or "-") .. " | BP: " .. refillCount)
    setHudColor(hud.refill, 150, 210, 255)

    safeSetText(hud.min, "[MIN " .. minRefillAmount .. "]")
    setHudColor(hud.min, 255, 210, 120)

    safeSetText(hud.max, "[MAX " .. maxRefillAmount .. "]")
    setHudColor(hud.max, 255, 210, 120)

    safeSetText(hud.toggle, enabled and "[PAUSAR]" or "[ATIVAR]")
    setHudColor(hud.toggle, enabled and 255 or 80, enabled and 120 or 255, enabled and 120 or 140)

    for index, entry in ipairs(hud.stationEntries) do
        local currentStation = stations[index]
        local selected = index == selectedStationIndex

        safeSetItemId(entry.icon, currentStation.id)
        safeSetScale(entry.icon, selected and selectedSmallIconScale or smallIconScale)

        safeSetText(entry.text, currentStation.label)
        setHudColor(entry.text, selected and 80 or 210, selected and 255 or 210, selected and 140 or 210)

        safeSetText(entry.state, selected and "ON" or "OFF")
        if selected then
            setHudColor(entry.state, 80, 255, 140)
        else
            setHudColor(entry.state, 255, 80, 80)
        end
    end

    updateHudVisibility()
end

-- =========================
-- HUD
-- =========================
hud.anchor = HUD.new(hudStartX, hudStartY, defaultIconItemId, true)
hud.anchor:setDraggable(true)
safeSetScale(hud.anchor, bigIconScale)
hud.anchor:setCallback(function() safeCall("toggleExpanded", toggleExpanded) end)

hud.title = createText(60, -14, SCRIPT_NAME, 255, 224, 128, function() safeCall("toggleExpanded", toggleExpanded) end)
hud.status = createText(60, 4, "", 255, 90, 90, function() safeCall("toggleEnabled", toggleEnabled) end)
hud.selected = createText(60, 22, "", 220, 230, 240, function() safeCall("toggleExpanded", toggleExpanded) end)
hud.refill = createText(60, 40, "", 150, 210, 255, function() safeCall("toggleExpanded", toggleExpanded) end)
hud.min = createText(60, 62, "", 255, 210, 120, function() safeCall("changeMin", changeMin) end)
hud.max = createText(145, 62, "", 255, 210, 120, function() safeCall("changeMax", changeMax) end)
hud.toggle = createText(230, 62, "", 80, 255, 140, function() safeCall("toggleEnabled", toggleEnabled) end)

-- grade de mesinhas pequenas
local cols = 7
local startX = 0
local startY = 112
local spacingX = 54
local spacingY = 72

for index, station in ipairs(stations) do
    local col = (index - 1) % cols
    local row = math.floor((index - 1) / cols)
    local x = startX + (col * spacingX)
    local y = startY + (row * spacingY)
    local currentIndex = index

    local icon = createItem(x, y, station.id, function()
        safeCall("selectStation", function() selectStation(currentIndex) end)
    end)
    safeSetScale(icon, smallIconScale)

    local text = createText(x - 4, y + 28, station.label, 210, 210, 210, function()
        safeCall("selectStation", function() selectStation(currentIndex) end)
    end)

    local state = createText(x + 4, y + 44, "OFF", 255, 80, 80, function()
        safeCall("selectStation", function() selectStation(currentIndex) end)
    end)

    hud.stationEntries[index] = {
        icon = icon,
        text = text,
        state = state,
    }
end

-- =========================
-- MODAL HANDLER
-- =========================
local function findButtonByText(buttons, text)
    if not buttons then return nil end
    local wanted = lower(text)

    for i = 1, #buttons do
        local b = buttons[i]
        if lower(b.text) == wanted then
            return b.id
        end
    end

    for i = 1, #buttons do
        local b = buttons[i]
        if lower(b.text):find(wanted, 1, true) then
            return b.id
        end
    end

    return nil
end

local function clickModalButton(data, buttonText)
    local buttonId = findButtonByText(data.buttons, buttonText)
    if not buttonId then return false end

    Game.modalWindowAnswer(data.id, buttonId, 0)
    return true
end

Game.registerEvent(Game.Events.MODAL_WINDOW, function(data)
    safeCall("modal", function()
    if not data then return end

    local title = lower(data.title or "")
    local body = lower(data.message or data.text or data.info or data.description or "")

    -- Protecao generica: se a mesa informar que ja esta usando/craftando, aguarda.
    if title:find("station", 1, true)
        or body:find("already", 1, true)
        or body:find("ja esta", 1, true)
        or body:find("já está", 1, true)
        or body:find("using", 1, true)
        or body:find("craft", 1, true)
    then
        if body:find("already", 1, true)
            or body:find("using", 1, true)
            or body:find("ja esta", 1, true)
            or body:find("já está", 1, true)
        then
            lastStatus = "Mesa ja esta em uso"
            clickModalButton(data, "Close")
            scheduleNext(checkIntervalMs)
            return
        end
    end

    -- Se abrir uma janela com Start, aperta Start automaticamente.
    if findButtonByText(data.buttons, "Start") then
        lastStatus = "Iniciando craft"
        clickModalButton(data, "Start")
        scheduleNext(afterUseDelayMs)
        return
    end

    -- Fechamento basico para mensagens informativas.
    if findButtonByText(data.buttons, "Close") then
        clickModalButton(data, "Close")
    end
    end)
end)

-- =========================
-- TIMER PRINCIPAL
-- =========================
Timer("craftHouseAvaloriumHud", function()
    safeCall("hudTimer", function()
    local pos = hud.anchor:getPos()

    if pos and (pos.x ~= 0 or pos.y ~= 0) then
        for _, element in ipairs(attachedHudElements) do
            element.item:setPos(pos.x + element.offsetX, pos.y + element.offsetY)
        end
    end

    updateHud()
    end)
end, 500)

Timer("craftHouseAvaloriumMain", function()
    safeCall("mainTimer", function()
    if isBuying then
        processNpcBuyFlow()
        return
    end

    if not enabled then return end

    if not getSelectedStation() then
        lastStatus = "Selecione uma mesa"
        return
    end

    if nextActionAt > 0 and nowMs() < nextActionAt then
        return
    end

    if needBuy() then
        startNpcBuyFlow()
        return
    end

    useSelectedStation()
    end)
end, checkIntervalMs)

-- inicializacao
expanded = true
updateHud()
showMessage("Script iniciado. Clique em uma mesinha para ativar. A mesa ON vira o icone lateral grande. Ele usa a MESA NO CHAO, nao o refill da BP.")

end

end

if registerEventListener then
    registerEventListener(EVENT.LOGIN, function()
        FabioRockeiroBOT.initialize()
    end)

    registerEventListener(EVENT.LOGOUT, function()
        FabioRockeiroBOT.shutdown()
    end)
end

if Player and Player.getName then
    FabioRockeiroBOT.initialize()
end

FabioUI.log("FabioRockeiroBOT pronto v" .. FabioRockeiroBOT.version)
