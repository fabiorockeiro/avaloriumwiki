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
