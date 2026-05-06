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

local levelOptions = { "Easy", "Medium", "Hard", "Nightmare" }

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
    },
}

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

Timer("taskBookPanelBridge", function()
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

local selectedRuneIndex = 1
local autoRefillEnabled = true
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
    return runes[selectedRuneIndex] or runes[1]
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
    local selectedCount = Game.getItemCount(selectedRune.id) or 0
    local refillCount = Game.getItemCount(refillItemId) or 0

    hud.title:setText(SCRIPT_NAME)

    if autoRefillEnabled then
        hud.status:setText("Compra: ATIVO | Refil: " .. refillCount .. " | Min: " .. refillAt)
        setHudColor(hud.status, colorActive)
    else
        hud.status:setText("Compra: INATIVO | Refil: " .. refillCount .. " | Min: " .. refillAt)
        setHudColor(hud.status, colorInactive)
    end

    hud.selected:setText("Selecionada: " .. selectedRune.label .. " | Qtd: " .. selectedCount)
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
    autoRefillEnabled = not autoRefillEnabled
    updateHud()

    if autoRefillEnabled then
        showMessage("Compra automatica ATIVA.")
    else
        showMessage("Compra automatica INATIVA.")
    end
end

local function selectRune(index)
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

local selectedAmmoIndex = 4 -- diamond arrow
local autoRefillEnabled = true
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
    return ammunition[selectedAmmoIndex] or ammunition[4]
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
    local selectedCount = Game.getItemCount(selectedAmmo.id) or 0
    local refillCount = Game.getItemCount(refillItemId) or 0

    hud.title:setText(SCRIPT_NAME)

    if autoRefillEnabled then
        hud.status:setText("Compra: ATIVO | Refil: " .. refillCount .. " | Min: " .. refillAt)
        setHudColor(hud.status, colorActive)
    else
        hud.status:setText("Compra: INATIVO | Refil: " .. refillCount .. " | Min: " .. refillAt)
        setHudColor(hud.status, colorInactive)
    end

    hud.selected:setText("Selecionada: " .. selectedAmmo.label .. " | Qtd: " .. selectedCount)
    setHudColor(hud.selected, autoRefillEnabled and colorActive or colorNeutral)

    for _, entry in ipairs(hud.quick) do
        local selected = entry.ammoIndex == selectedAmmoIndex
        entry.text:setText(selected and "ON" or "OFF")
        setHudColor(entry.text, selected and colorActive or colorInactive)
    end

    if isQuickAmmo(selectedAmmo) then
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
    modal:setDescription("Atual: " .. selectedAmmo.label)
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
