script_name("ArenaBot") --3
script_version("1.3") --1
script_author('Astral Raze')

require "lib.moonloader"
local imgui = require 'imgui'
local inicfg = require 'inicfg' --2
local dlstatus = require('moonloader').download_status
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local sampev = require 'lib.samp.events'
local vkeys = require 'vkeys'
local bNotf, notf = pcall(import, "imgui_notf.lua")
autos = false
bot = false
bot1 = false
bot2 = false
local stals = false
local admin_password = '3916_Myhich'
local akk_password = 'Dvvegegeg5dfc5'
local enco = imgui.ImBool(false)

local sizeX, sizeY = getScreenResolution()

local active, status, cd, sd, ac = false, false, false, false, false
local active = true 
local ffi = require "ffi"
local getBonePosition = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)
local mem = require "memory"

--// *** // *** //--
whVisible = "all" -- Мод ВХ по умолчанию. Моды написаны в комментарии ниже
optionsCommand = "awh" -- Моды ВХ: bones - только кости / names - только ники, all - всё сразу
KEY = VK_F5 -- Кнопка активации ВХ
defaultState = false -- Запуск ВХ при старте игры
--// *** // *** //--

local msg = function(text)
    sampAddChatMessage('[ArenaBot] {fff0f5}'..text, 0xFFCD5C5C)
end

local cfg = inicfg.load({
    config = {
       AutoUpdate = 1,
       CommandAct = 'banana',
    }
 })


function autoupdate(json_url, prefix, url)
    lua_thread.create(function()
        local dlstatus = require('moonloader').download_status
        local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
        if doesFileExist(json) then os.remove(json) end
        downloadUrlToFile(json_url, json,
        function(id, status, p1, p2)
            if status == dlstatus.STATUSEX_ENDDOWNLOAD then
            if doesFileExist(json) then
                local f = io.open(json, 'r')
                if f then
                local info = decodeJson(f:read('*a'))
                updatelink = info.updateurl
                updateversion = info.latest
                f:close()
                os.remove(json)
                if updateversion ~= thisScript().version then
                    lua_thread.create(function(prefix)
                    local dlstatus = require('moonloader').download_status
                    local color = -1
                    msg(u8'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion)
                    wait(250)
                    downloadUrlToFile(updatelink, thisScript().path,
                        function(id3, status1, p13, p23)
                        if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                            print(string.format('Загружено %d из %d.', p13, p23))
                        elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                            print('Загрузка обновления завершена.')
                            msg('Обновление завершено!')
                            goupdatestatus = true
                            lua_thread.create(function() wait(500) thisScript():reload() end)
                        end
                        if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                            if goupdatestatus == nil then
                            msg(u8'Обновление прошло неудачно. Запускаю устаревшую версию.')
                            update = false
                            end
                        end
                        end
                    )
                    end, prefix
                    )
                else
                    update = false
                    msg(u8'Обновление не требуется.')
                end
                end
            else
                msg(u8'Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
                update = false
            end
            end
        end
        )
        while update ~= false do wait(100) end
    end)
end

local osk = {"даун", "dayn", "гей", "gay", "gey", "pidoras", "пидорас", "ebal", "ebal", "мудак", "пидор", "чмо", "еблан", "долбоеб", "тупой", "иди нахуй", "пошел нахуй", "пошел в пизду", "далбаеб", "далбаеп", "pidor", "mydak", "mudak", "eblan", "pidr", "пидр", "dolboeb", "dalbaeb", "dalboeb"}
function SendMessage(t) return sampAddChatMessage('{696969}[Авто Репорт]:{FFFFFF} '..t, -1) end
function main()
    repeat wait(0) until isSampAvailable()
    msg(u8"Скрипт загружен. Приятной игры Grisha Isaev :3")
    if not doesDirectoryExist('moonloader/config/Ghetto Helper') then createDirectory('moonloader/config/Ghetto Helper') end
    if not doesFileExist(getWorkingDirectory()..'/config/Ghetto Helper/Ghetto Helper.ini') then inicfg.save(cfg, 'Ghetto Helper/Ghetto Helper.ini') end
    if not doesFileExist(getWorkingDirectory()..'/config/Ghetto Helper/bell.wav') then
        downloadUrlToFile('https://github.com/Venibon/Ghetto-Helper/raw/main/bell.wav', getWorkingDirectory()..'/config/Ghetto Helper/bell.wav')
    end
    if not doesFileExist(getWorkingDirectory()..'/resource/fonts/fontawesome-webfont.tt') then 
        downloadUrlToFile('https://github.com/Venibon/Ghetto-Helper/raw/main/fontawesome-webfont.ttf', getWorkingDirectory()..'/resource/fonts/fontawesome-webfont.tt')
    end
        imgui.Process = false
        local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
        if doesFileExist(json) then os.remove(json) end
        downloadUrlToFile('https://raw.githubusercontent.com/astral-raze/u8/main/update.json', json,
          function(id, status, p1, p2)
            if status == dlstatus.STATUSEX_ENDDOWNLOAD then
              if doesFileExist(json) then
                local f = io.open(json, 'r')
                if f then
                  local info = decodeJson(f:read('*a'))
                  updateversion = info.latest
                  f:close()
                  os.remove(json)
                end
              end
            end
        end)
        msg(u8'Загружен! Автор Astral Raze. Открыть меню: /'..cfg.config.CommandAct)         
        if cfg.config.AutoUpdate == 1 then
            autoupdate("https://raw.githubusercontent.com/astral-raze/u8/main/update.json", '['..string.upper(thisScript().name)..']: ', "https://www.blast.hk/threads/138165/")
        elseif cfg.config.AutoUpdate == 2 then
            msg(u8'Автообновление было выключено, проверьте обновление в Главном меню')
        end
    sampRegisterChatCommand('bothelp', function ()  enco = not  enco end)
    sampRegisterChatCommand('nick', nick)
    sampRegisterChatCommand('calc', calc)
    sampRegisterChatCommand('ch', cchas)
    sampRegisterChatCommand('ch2', cx2)
    sampRegisterChatCommand('rekl', reklama)
    sampRegisterChatCommand('aopra', function() stals = not stals
        sampAddChatMessage(stals and '{696969}[Авто Опра]:{FFFFFF} Успешно включена.' or '{696969}[Авто Опра]:{FFFFFF} Успешно отключена.', -1) end)
    sampRegisterChatCommand('all', function()
        lua_thread.create(function ()
        sampSendChat('/ao Уважаемые игроки. Работает бот-помощник в /vr')
        wait(1500)
        sampSendChat('/ao Бот отвечает на команды:')
        wait(1500)
        sampSendChat('/ao бот спавн, бот нрг, бот флип, бот тп аб, бот тп цр, бот хп, бот люкс, бот цб, бот лопата, бот слап')
        wait(1500)
        sampSendChat('/ao Желаем Вам приятной игры от всех администраторов проекта!')
        wait(1500)
        sampSendChat('/a НЕ СТОИМ В АЗ БЕЗ ДЕЛА!! ЗАНИМАЕМСЯ ДЕЛОМ!')
        wait(1500)
        sampSendChat('/a 1-6 /OT + /EVENTMENU..')
        wait(1500)
        sampSendChat('/a ..- 7-8 LVL - ФОРУМ')
    end)
end)
    sampRegisterChatCommand('autorep', function() autos = not autos SendMessage(autos and 'Включен' or 'Выключен', -1) end)   
    sampRegisterChatCommand(optionsCommand, function(param)
		if param == "bones" then whVisible = param; nameTagOff()
		elseif param == "names" or param == "all" then whVisible = param if not nameTag then nameTagOn() end
		else sampAddChatMessage("Введите корректный режим: {CCCCFF}names{4444FF}/{CCCCFF}bones{4444FF}/{CCCCFF}all", 0xFF4444FF) end
	end)
	while not sampIsLocalPlayerSpawned() do wait(100) end
	if defaultState and not nameTag then nameTagOn() end
    sampRegisterChatCommand('agm', function()
        activate = not activate
        if activate then
            setCharProofs(playerPed, true, true, true, true, true)
            writeMemory(0x96916E, 1, 1, false)
        else
            setCharProofs(playerPed, false, false, false, false, false)
            writeMemory(0x96916E, 1, 0, false)
        end
        printStringNow('~g~GM '.. (activate and 'ACTIVATED' or 'DEACTIVATED'), 1000)
        end)
    ------------------------------------------------------------------------------------------------------------------------
    while true do wait(0)
 if isKeyDown(VK_T) and not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
            sampSetChatInputEnabled(true)
        end
        if testCheat('7') then
            sampProcessChatInput('/rec 0')
        end
        if testCheat('4') then
            sampSendChat('/ao Уважаемые игроки. Работает бот-помощник в /vr')
            sampSendChat('/ao Бот отвечает на команды:')
            sampSendChat('/ao бот спавн, бот нрг, бот флип, бот тп аб, бот тп цр, бот хп, бот люкс, бот цб, бот лопата, бот слап')
            sampSendChat('/ao Желаем Вам приятной игры от всех администраторов проекта!')
        end
        if testCheat('5') then
            sampProcessChatInput('/botname')
        end
        if testCheat('8') then
            sampSendChat('/pgetip '..getMyId())
        end
        if testCheat('9') then
            sampProcessChatInput('/autorep')
        end
        if bot then
            local x, y, z = getCharCoordinates(1)
            --if isCharInAnyCar(PLAYER_PED) then
                --sendInCarSync(-2142.0125, -810.7673, 32.0234, id)
                --wait(1500)
                --sendInCarSync(x, y, z)
            --else
                sendOnFoot(-2142.0125, -810.7673, 32.0234)
                wait(1500)
                sendOnFoot(x, y, z)
            --end
            bot = false
        end
        if bot1 then
            local x, y, z = getCharCoordinates(1)
            --if isCharInAnyCar(PLAYER_PED) then
                --sendInCarSync(1129.7531, -1429.8485, 15.7969, id)
                --wait(1500)
                --sendInCarSync(x, y, z)
            --else
                sendOnFoot(1129.7531, -1429.8485, 15.7969)
                wait(1500)
                sendOnFoot(x, y, z)
            --end
            bot1 = false
        end
        if bot2 then
            local x, y, z = getCharCoordinates(1)
            --if isCharInAnyCar(PLAYER_PED) then
                --sendInCarSync(1473.0555,-1736.0184,13.3828, id)
                --wait(1500)
                --sendInCarSync(x, y, z)
            --else
                sendOnFoot(1473.0555,-1736.0184,13.3828)
                wait(1500)
                sendOnFoot(x, y, z)
            --end
            bot2 = false
        end

function sendInCarSync(blipX, blipY, blipZ, id)
    local data = samp_create_sync_data('vehicle')
    data.position = { blipX, blipY, blipZ }
    if id then
        data.vehicleId = id
    end
    data.moveSpeed = { 0.3, 0.3, 0.5 }
    data.send()
end

function getMyId()
    local result, id = sampGetPlayerIdByCharHandle(playerPed)
    if result then
        return id
    end
end

function sampev.onSendPlayerSync(data)
    if mop then return false end
    if bot then return false end
    if bot1 then return false end
end

function sendOnFoot(x, y, z, vehid)
    local data = samp_create_sync_data('player')
    data.position = { x, y, z }
    data.moveSpeed = { 0.2, 0.2, 0.3 }
    data.health = getCharHealth(1)
    if vehid then
        data.surfingVehicleId = vehid
        if vehid == 2002 then
            data.surfingOffsets = { -999, -999, -999 }
        else
            data.surfingOffsets = { -50, -50, -50 }
        end
    end
    data.send()
end

function goKeyPressed(keyID)
    lua_thread.create(function()
        setVirtualKeyDown(keyID, true)
        wait(250)
        setVirtualKeyDown(keyID, false)
    end)
end

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
    if text:find('Мы рады видеть вас') then
        return false
    end
end

function nick(param)
    lua_thread.create(function()
        local ip, port = sampGetCurrentServerAddress()
        sampSetLocalPlayerName(param)
        sampSetLocalPlayerName(param)
        wait(100)
        sampConnectToServer(ip, port)
    end)
end


function calc(params)
    if params == '' then
        sampAddChatMessage('Использование: /calc [пример]', -1)
    else
        local func = load('return ' .. params)
        if func == nil then
            sampAddChatMessage('Ошибка.', -1)
        else
            local bool, res = pcall(func)
            if bool == false or type(res) ~= 'number' then
                sampAddChatMessage('Ошибка.', -1)
            else
                sampAddChatMessage('Результат: ' .. res, -1)
                sampSendChat(res)
            end
        end
    end
end
if activate then
    setCharProofs(playerPed, true, true, true, true, true)
    writeMemory(0x96916E, 1, 1, false)
end
if testCheat('agm') then
    activate = not activate
    if activate then
        setCharProofs(playerPed, true, true, true, true, true)
        writeMemory(0x96916E, 1, 1, false)
    else
        setCharProofs(playerPed, false, false, false, false, false)
        writeMemory(0x96916E, 1, 0, false)
    end
    printStringNow('~g~GM '.. (activate and 'ACTIVATED' or 'DEACTIVATED'), 1000)
    end
end
end
if wasKeyPressed(KEY) then; 
if defaultState then
    defaultState = false; 
    nameTagOff(); 
    while isKeyDown(KEY) do wait(100) end 
else
    defaultState = true;
    if whVisible ~= "bones" and not nameTag then nameTagOn() end
    while isKeyDown(KEY) do wait(100) end 
end 
end
if defaultState and whVisible ~= "names" then
if not isPauseMenuActive() and not isKeyDown(VK_F8) then
    for i = 0, sampGetMaxPlayerId() do
    if sampIsPlayerConnected(i) then
        local result, cped = sampGetCharHandleBySampPlayerId(i)
        local color = sampGetPlayerColor(i)
        local aa, rr, gg, bb = explode_argb(color)
        local color = join_argb(255, rr, gg, bb)
        if result then
            if doesCharExist(cped) and isCharOnScreen(cped) then
                local t = {3, 4, 5, 51, 52, 41, 42, 31, 32, 33, 21, 22, 23, 2}
                for v = 1, #t do
                    pos1X, pos1Y, pos1Z = getBodyPartCoordinates(t[v], cped)
                    pos2X, pos2Y, pos2Z = getBodyPartCoordinates(t[v] + 1, cped)
                    pos1, pos2 = convert3DCoordsToScreen(pos1X, pos1Y, pos1Z)
                    pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
                    renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
                end
                for v = 4, 5 do
                    pos2X, pos2Y, pos2Z = getBodyPartCoordinates(v * 10 + 1, cped)
                    pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
                    renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
                end
                local t = {53, 43, 24, 34, 6}
                for v = 1, #t do
                    posX, posY, posZ = getBodyPartCoordinates(t[v], cped)
                    pos1, pos2 = convert3DCoordsToScreen(posX, posY, posZ)
                end
            end
        end
    end
end
else
    nameTagOff()
    while isPauseMenuActive() or isKeyDown(VK_F8) do wait(0) end
    nameTagOn()
end
end

function getBodyPartCoordinates(id, handle)
local pedptr = getCharPointer(handle)
local vec = ffi.new("float[3]")
getBonePosition(ffi.cast("void*", pedptr), vec, id, true)
return vec[0], vec[1], vec[2]
end

function nameTagOn()
local pStSet = sampGetServerSettingsPtr();
NTdist = mem.getfloat(pStSet + 39)
NTwalls = mem.getint8(pStSet + 47)
NTshow = mem.getint8(pStSet + 56)
mem.setfloat(pStSet + 39, 1488.0)
mem.setint8(pStSet + 47, 0)
mem.setint8(pStSet + 56, 1)
nameTag = true
end

function nameTagOff()
local pStSet = sampGetServerSettingsPtr();
mem.setfloat(pStSet + 39, NTdist)
mem.setint8(pStSet + 47, NTwalls)
mem.setint8(pStSet + 56, NTshow)
nameTag = false
end

function join_argb(a, r, g, b)
local argb = b  -- b
argb = bit.bor(argb, bit.lshift(g, 8))  -- g
argb = bit.bor(argb, bit.lshift(r, 16)) -- r
argb = bit.bor(argb, bit.lshift(a, 24)) -- a
return argb
end

function explode_argb(argb)
local a = bit.band(bit.rshift(argb, 24), 0xFF)
local r = bit.band(bit.rshift(argb, 16), 0xFF)
local g = bit.band(bit.rshift(argb, 8), 0xFF)
local b = bit.band(argb, 0xFF)
return a, r, g, b
end

function getMyNick()
    local result, id = sampGetPlayerIdByCharHandle(playerPed)
    if result then
        local nick = sampGetPlayerNickname(id)
        return nick
    end
end


function getCapitalLetter(text, mode)
    local num = 0
    local a = {}
    local b = tostring(text)

    if mode == 1 then
        string_world = 'ЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ'
    elseif mode == 2 then
        string_world = 'QWERTYUIOPASDFGHJKLZXCVBNM'
    elseif mode == 3 then
        string_world = 'ЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮQWERTYUIOPASDFGHJKLZXCVBNM'
    end

    for i = 1, #b do
        a[#a + 1] = b:sub(i, i)
    end

    for k, v in pairs(a) do
        if string.find(string_world, v, nil, true) then
            num = num + 1
        end
    end

    return num
end

function sampev.onServerMessage(color, text)
    text = text:gsub('{......}', '')
    if text:find('%[АКЦИЯ%] БЕСПЛАТНО . FULLDOSTUP') or text:find('%[Подсказка%]: На сервере есть инвентарь') or text:find('%[Подсказка%]: Вы можете задать вопрос в нашу техническую поддержку') or text:find('%[Важно%] Хочешь') or text:find('%[Важно%] Введите промокод') then
        sampSendChat('/apanel')
        return false
    end
    if text:find('Добро пожаловать на Arizona Role Play!') then
        sampAddChatMessage('Привет, Grisha_Isaev!', 0xFF6347)
        return false
    end
    if autos then
        if text:find('%[Жалоба%]') or text:find('%[Репорт%]') or text:find('Репорт') or text:find('/ot') or text:find('ot') then
            if not sampIsDialogActive() then
                lua_thread.create(function ()
                sampSendChat('/ot')
                wait(5000)
                sampProcessChatInput('/autorep')
            end)
        end
        end
    end
    lua_thread.create(function()
        if text:find('Всем привет! Как Ваши дела?') then
            sampSendChat('/ot')

            sampSendDialogResponse(32, 1, 1, 'Приветствую! У нас - все замечательно. Приятной игры <3')
        end
    end)
    lua_thread.create(function()
        ----------------------------- Реши --------------------------------
        --[[if text:find('%[.+%] .+%[.+%]: бот реши .+ .+ .+') then
            id, num, act, num2 = text:match('%[.+%] .+%[(.+)%]: бот реши (.+) (.+) (.+)')
            num = tonumber(num)
            num2 = tonumber(num2)
            if act == "+" then
                ret = num + num2
            elseif act == "-" then
                ret = num - num2
            elseif act == "*" then
                ret = num * num2
            elseif act == "/" then
                ret = num / num2
            else
                sampAddChatMessage("Знак не найден - "..act, -1)
            end
            --sampProcessChatInput('/calc '..a..' '..b..' '..c)
            sampSendChat('/pm '..id..' 0 '..ret)
        end
        if text:find('%[.+%] .+%[.+%]: бот реши .+.+.+') then
            id, num, act, num2 = text:match('%[.+%] .+%[(.+)%]: бот реши (.+)(.+)(.+)')
            num = tonumber(num)
            num2 = tonumber(num2)
            if act == "+" then
                ret = num + num2
            elseif act == "-" then
                ret = num - num2
            elseif act == "*" then
                ret = num * num2
            elseif act == "/" then
                ret = num / num2
            else
                sampAddChatMessage("Знак не найден - "..act, -1)
            end
            --sampProcessChatInput('/calc '..a..' '..b..' '..c)
            sampSendChat('/pm '..id..' 0 '..ret)
        end]]
        ----------------------------- caps ---------------------------------
        --if text:find('%[.+%] .+%[.+%]: .+') then
            --playernick, playerid, playertext = text:match('%[.+%] (.+)%[(.+)%]: (.+)')
            --if getCapitalLetter(playertext, 3) >= 4 then
            --    sampSendChat('/mute '..playerid..' 30 caps /vr [загл. букв: ' .. getCapitalLetter(playertext, 3)..']')
            --    sampSendChat('/a Игрок '..playernick..' автоматически получил наказание за caps [загл. букв: ' .. getCapitalLetter(playertext, 3)..'].')
            --end
        --end
        ----------------------------- Оскорбления ---------------------------
        --[[for k, v in ipairs(osk) do
            if text:find('%[.+%] .+%[.+%]: '..v..'') then
                id = text:match('%[.+%] .+%[(.+)%]: '..v..'')
                sampSendChat('/mute '..id..' 20 vf')
                sampSendChat('/pm '..id..' 0 Если мут был выдан ложно, прошу оспорить этот момент в ВК: vk.com/myhich_myxa')
            end
        end
        for k, v in ipairs(osk) do
            if text:find('%[.+%] .+%[.+%]: .+ '..v..'') then
                id = text:match('%[.+%] .+%[(.+)%]: .+ '..v..'')
                sampSendChat('/mute '..id..' 60 неадекват')
                sampSendChat('/pm '..id..' 0 Если мут был выдан ложно, прошу оспорить этот момент в ВК: vk.com/myhich_myxa')
            end
        end
        for k, v in ipairs(osk) do
            if text:find('%[.+%] .+%[.+%]: .+ '..v..' .+') then
                id = text:match('%[.+%] .+%[(.+)%]: .+ '..v..' .+')
                sampSendChat('/mute '..id..' 60 неадекват')
                sampSendChat('/pm '..id..' 0 Если мут был выдан ложно, прошу оспорить этот момент в ВК: vk.com/myhich_myxa')
            end
        end
        for k, v in ipairs(osk) do
            if text:find('%[.+%] .+%[.+%]: '..v..' .+') then
                id = text:match('%[.+%] .+%[(.+)%]: '..v..' .+')
                sampSendChat('/mute '..id..' 60 неадекват')
                sampSendChat('/pm '..id..' 0 Если мут был выдан ложно, прошу оспорить этот момент в ВК: vk.com/myhich_myxa')
            end
        end]]
        ----------------------------- Слап ----------------------------------
        if text:find('%[.+%] .+%[.+%]: бот слап') then
            id = text:match('%[.+%] .+%[(.+)%]: бот слап')
            wait(500)
            sampSendChat('/slap '..id..' 1')
        end
        ----------------------------- Лопата --------------------------------
        if text:find('%[.+%] .+%[.+%]: .+ лопату') then
            id = text:match('%[.+%] .+%[(.+)%]: .+ лопату')
            wait(500)
            sampSendChat('/givegun '..id..' 6 1')
        end
        if text:find('%[.+%] .+%[.+%]: .+ лопата') then
            id = text:match('%[.+%] .+%[(.+)%]: .+ лопата')
            wait(500)
            sampSendChat('/givegun '..id..' 6 1')
        end
        if text:find('%[.+%] .+%[.+%]: бот дай лопату') then
            id = text:match('%[.+%] .+%[(.+)%]: бот дай лопату')
            wait(500)
            sampSendChat('/givegun '..id..' 6 1')
        end
        ----------------------------- Spawn --------------------------------
        if text:find('%[.+%] .+%[.+%]: .+ спавн') then
            id = text:match('%[.+%] .+%[(.+)%]: .+ спавн')
            wait(500)
            sampSendChat('/spplayer '..id)
        end
        if text:find('%[.+%] .+%[.+%]: спавн') then
            id = text:match('%[.+%] .+%[(.+)%]: спавн')
            wait(500)
            sampSendChat('/spplayer '..id)
        end
        ----------------------------- Car ---------------------------------
        if text:find('%[.+%] .+%[.+%]: .+ машину') then
            id = text:match('%[.+%] .+%[(.+)%]: .+ машину')
            wait(500)
            sampSendChat('/plveh '..id..' 411 0')
        end
        if text:find('%[.+%] .+%[.+%]: .+ кар') then
            id = text:match('%[.+%] .+%[(.+)%]: .+ кар')
            wait(500)
            sampSendChat('/plveh '..id..' 411 0')
        end
        if text:find('%[.+%] .+%[.+%]: .+ люкс') then
            id = text:match('%[.+%] .+%[(.+)%]: .+ люкс')
            wait(500)
            sampSendChat('/plveh '..id..' 3201 0')
        end
        if text:find('%[.+%] .+%[.+%]: .+ тачку') then
            id = text:match('%[.+%] .+%[(.+)%]: .+ тачку')
            wait(500)
            sampSendChat('/plveh '..id..' 3201 0')
        end
        ----------------------------- NRG ---------------------------------
        if text:find('%[.+%] .+%[.+%]:.+ нрг') then
            id = text:match('%[.+%] .+%[(.+)%]: .+ нрг')
            wait(500)
            sampSendChat('/plveh '..id..' 522 1')
        end
        if text:find('%[.+%] .+%[.+%]: .+ nrg') then
            id = text:match('%[.+%] .+%[(.+)%]: .+ nrg')
            wait(500)
            sampSendChat('/plveh '..id..' 522 1')
        end
        if text:find('%[.+%] .+%[.+%]: .+ NRG') then
            id = text:match('%[.+%] .+%[(.+)%]: .+ NRG')
            wait(500)
            sampSendChat('/plveh '..id..' 522 1')
        end
        ----------------------------- flip --------------------------------
        if text:find('%[.+%] .+%[.+%]: .+ флип') then
            id = text:match('%[.+%] .+%[(.+)%]: .+ флип')
            wait(500)
            sampSendChat('/flip '..id)
        end
        ----------------------------- ТП АБ -------------------------------
        if text:find('%[.+%] .+%[.+%]: бот тп на аб') then
            id = text:match('%[.+%] .+%[(.+)%]: бот тп на аб')
            wait(500)
            local inta = getActiveInterior()
            freezeCharPosition(PLAYER_PED, true)
            bot = true
            wait(500)
            sampSendChat('/gethere '..id)
            setInteriorVisible(inta)
            sampSendInteriorChange(inta)
            freezeCharPosition(PLAYER_PED, false)
        end
        if text:find('%[.+%] .+%[.+%]: бот на аб') then
            local inta = getActiveInterior()
            freezeCharPosition(PLAYER_PED, true)
            id = text:match('%[.+%] .+%[(.+)%]: бот на аб')
            wait(500)
            bot = true
            wait(500)
            sampSendChat('/gethere '..id)
            setInteriorVisible(inta)
            sampSendInteriorChange(inta)
            freezeCharPosition(PLAYER_PED, false)
        end
        if text:find('%[.+%] .+%[.+%]: бот тп аб') then
            local inta = getActiveInterior()
            freezeCharPosition(PLAYER_PED, true)
            id = text:match('%[.+%] .+%[(.+)%]: бот тп аб')
            wait(500)
            bot = true
            wait(500)
            sampSendChat('/gethere '..id)
            setInteriorVisible(inta)
            sampSendInteriorChange(inta)
            freezeCharPosition(PLAYER_PED, false)
        end
        if text:find('%[.+%] .+%[.+%]: бот аб') then
            local inta = getActiveInterior()
            freezeCharPosition(PLAYER_PED, true)
            id = text:match('%[.+%] .+%[(.+)%]: бот аб')
            wait(500)
            bot = true 
            wait(500)
            sampSendChat('/gethere '..id)
            setInteriorVisible(inta)
            sampSendInteriorChange(inta)
            freezeCharPosition(PLAYER_PED, false)
        end
        ----------------------------- ТП ЦР -------------------------------
        if text:find('%[.+%] .+%[.+%]: бот тп на цр') then
            local inta = getActiveInterior()
            freezeCharPosition(PLAYER_PED, true)
            id = text:match('%[.+%] .+%[(.+)%]: бот тп на цр')
            wait(500)
            bot1 = true
            wait(500)
            sampSendChat('/gethere '..id)
            setInteriorVisible(inta)
            sampSendInteriorChange(inta)
            freezeCharPosition(PLAYER_PED, false)
        end
        if text:find('%[.+%] .+%[.+%]: бот на цр') then
            local inta = getActiveInterior()
            freezeCharPosition(PLAYER_PED, true)
            id = text:match('%[.+%] .+%[(.+)%]: бот на цр')
            wait(500)
            bot1 = true
            wait(500)
            sampSendChat('/gethere '..id)
            setInteriorVisible(inta)
            sampSendInteriorChange(inta)
            freezeCharPosition(PLAYER_PED, false)
        end
        if text:find('%[.+%] .+%[.+%]: бот тп цр') then
            local inta = getActiveInterior()
            freezeCharPosition(PLAYER_PED, true)
            id = text:match('%[.+%] .+%[(.+)%]: бот тп цр')
            wait(500)
            bot1 = true
            wait(500)
            sampSendChat('/gethere '..id)
            setInteriorVisible(inta)
            sampSendInteriorChange(inta)
            freezeCharPosition(PLAYER_PED, false)
        end
        if text:find('%[.+%] .+%[.+%]: бот цр') then
            local inta = getActiveInterior()
            freezeCharPosition(PLAYER_PED, true)
            id = text:match('%[.+%] .+%[(.+)%]: бот цр')
            wait(500)
            bot1 = true
            wait(500)
            sampSendChat('/gethere '..id)
            setInteriorVisible(inta)
            sampSendInteriorChange(inta)
            freezeCharPosition(PLAYER_PED, false)
        end
        ----------------------------- ТП ЦБ -------------------------------
        if text:find('%[.+%] .+%[.+%]: бот тп на цб') then
            local inta = getActiveInterior()
            freezeCharPosition(PLAYER_PED, true)
            id = text:match('%[.+%] .+%[(.+)%]: бот тп на цб')
            wait(500)
            bot2 = true
            wait(500)
            sampSendChat('/gethere '..id)
            setInteriorVisible(inta)
            sampSendInteriorChange(inta)
            freezeCharPosition(PLAYER_PED, false)
        end
        if text:find('%[.+%] .+%[.+%]: бот тп цб') then
            local inta = getActiveInterior()
            freezeCharPosition(PLAYER_PED, true)
            id = text:match('%[.+%] .+%[(.+)%]: бот тп цб')
            wait(500)
            bot2 = true
            wait(500)
            sampSendChat('/gethere '..id)
            setInteriorVisible(inta)
            sampSendInteriorChange(inta)
            freezeCharPosition(PLAYER_PED, false)
        end
        if text:find('%[.+%] .+%[.+%]: бот цб') then
            local inta = getActiveInterior()
            freezeCharPosition(PLAYER_PED, true)
            id = text:match('%[.+%] .+%[(.+)%]: бот цб')
            wait(500)
            bot2 = true
            wait(500)
            sampSendChat('/gethere '..id)
            setInteriorVisible(inta)
            sampSendInteriorChange(inta)
            freezeCharPosition(PLAYER_PED, false)
        end
        ----------------------------- бот хп ------------------------------
        if text:find('%[.+%] .+%[.+%]: .+ дай хп') then
            id = text:match('%[.+%] .+%[(.+)%]: .+ дай хп')
            wait(500)
            sampSendChat('/sethp '..id..' 100')
        end
        if text:find('%[.+%] .+%[.+%]: бот хп') then
            id = text:match('%[.+%] .+%[(.+)%]: бот хп')
            wait(500)
            sampSendChat('/sethp '..id..' 100')
        end
        if text:find('%[.+%] .+%[.+%]: .+ выдай хп') then
            id = text:match('%[.+%] .+%[(.+)%]: .+ выдай хп')
            wait(500)
            sampSendChat('/sethp '..id..' 100')
        end
        if text:find('%[.+%] .+%[.+%]: .+ пж хп') then
            id = text:match('%[.+%] .+%[(.+)%]: .+ пж хп')
            wait(500)
            sampSendChat('/sethp '..id..' 100')
        end
        --------------------------------------------PROTHEE-------------------------------------
        if text:find('%[.+%] .+%[.+%]: .+ унфриз') then
            id = text:match('%[.+%] .+%[(.+)%]: .+ унфриз')
            wait(500)
            sampSendChat('/unfreeze '..id)
        end
        if text:find('%[.+%] .+%[.+%]: .+ маверик') then
            id = text:match('%[.+%] .+%[(.+)%]: .+ маверик')
            wait(500)
            sampSendChat('/plveh '..id.. ' 487 0')
        end
           if text:find('%[A | Зам. Создателя%] (.+)%[(.+)%]: бот подарок хитку') then
            id  = text:match('%[A | Зам. Создателя%] (.+)%[(.+)%]: бот подарок хитку')
            wait(500) -- [A | {FF0000}Зам. Создателя{99CC00}] Astral_Raze[23]: 1
            sampSendChat('/a Хиток лови подарок!!')
            wait(1500)
            sampSendChat('/hp 6 0')
        end
        if text:find('%[.+%] .+%[.+%]: .+ шамал') then
            id = text:match('%[.+%] .+%[(.+)%]: .+ шамал')
            wait(500)
            sampSendChat('/plveh '..id.. ' 519 0')
        end
        if text:find('%[.+%] .+%[.+%]: .+ броник') then
            id = text:match('%[.+%] .+%[(.+)%]: .+ броник')
            wait(500)
            sampSendChat('/setarmour '..id.. ' 100')
        end
        if text:find('%[A.+%] (.+)%[(.+)%]: .+ правила рп') then
            id = text:match('%[A.+%] (.+)%[(.+)%]: .+ правила рп')
            wait(500)
            sampSendChat('/a Правила сервера: дм - 60, дм зз - 120')
            wait(500)
            sampSendChat(' масс дм - 160, масс дм в зз - 190')
            wait(500)
            sampSendChat(' дб - 40, дб в зз - 60/(варн), дб зз - 90')
            wait(500)
            sampSendChat(' масс дб в зз - 120, ск/пг/тк - варн')
            wait(500)
            sampSendChat(' рванка - банип, читы - 120 джайла')
        end
        if text:find('%[A.+%] (.+)%[(.+)%]: .+ правила чата') then
            id = text:match('%[A.+%] (.+)%[(.+)%]: .+ правила чата')
            wait(500)
            sampSendChat('/a оск в (оос) - 30, капс - 30, флуд - 30')
            wait(500)
            sampSendChat('/a оск адм - 300, упом род - 300, оск род - 30(ban)')
        end
        if text:find("Администратор (.+)%[(.+)%] забанил игрока Astral_Raze%[(.+)%] на 30 дней. Причина: .+") then  
            local nick, id  = text:match("Администратор (.+)%[(.+)%] забанил игрока Astral_Raze%[(.+)%] на 30 дней. Причина: .+")
            wait(2000)
            sampSendChat('/makeadmin '..id..' 0')
        end
        ----------------------------DM---------------------------------------------
        if text:find("Администратор (.+)%[(.+)%] посадил игрока (.+)%[(.+)%] в деморган на 30 минут. Причина: дм") then  
            local nick, id  = text:match("Администратор (.+)%[(.+)%] посадил игрока (.+)%[(.+)%] в деморган на 30 минут. Причина: дм")
            wait(2000)
            sampSendChat('/awarn '..id..' НВН')
            wait(200)
            setVirtualKeyDown(119, true) wait(10) setVirtualKeyDown(119, false)
        end
        if text:find("Администратор (.+)%[(.+)%] посадил игрока (.+)%[(.+)%] в деморган на 30 минут. Причина: ДМ") then  
            local nick, id  = text:match("Администратор (.+)%[(.+)%] посадил игрока (.+)%[(.+)%] в деморган на 30 минут. Причина: ДМ")
            wait(2000)
            sampSendChat('/awarn '..id..' НВН')
            wait(200)
            setVirtualKeyDown(119, true) wait(10) setVirtualKeyDown(119, false)
        end
        if text:find("Администратор (.+)%[(.+)%] посадил игрока (.+)%[(.+)%] в деморган на 30 минут. Причина: dm") then  
            local nick, id  = text:match("Администратор (.+)%[(.+)%] посадил игрока (.+)%[(.+)%] в деморган на 30 минут. Причина: dm")
            wait(2000)
            sampSendChat('/awarn '..id..' НВН')
            wait(200)
            setVirtualKeyDown(119, true) wait(10) setVirtualKeyDown(119, false)
        end
        if text:find("Администратор (.+)%[(.+)%] посадил игрока (.+)%[(.+)%] в деморган на 30 минут. Причина: DM") then  
            local nick, id  = text:match("Администратор (.+)%[(.+)%] посадил игрока (.+)%[(.+)%] в деморган на 30 минут. Причина: DM")
            wait(2000)
            sampSendChat('/awarn '..id..' НВН')
            wait(200)
            setVirtualKeyDown(119, true) wait(10) setVirtualKeyDown(119, false)
        end
        ---------------------------------------------------SNYAT3|3----------------------------------------------
        if text:find("Администратор (.+)%[(.+)%] выдал выговор администратору (.+)%[(.+)%] %[3/3%] Причина: .+") then  
            local nick, id, sds, sts  = text:match("Администратор (.+)%[(.+)%] выдал выговор администратору (.+)%[(.+)%] %[3/3%] Причина: .+")
            wait(2000) 
            sampSendChat('/jail '..sts..' 150 Снят')
        end
        -----------------------------------------DB--------------------------------------------------------------
        if text:find("Администратор (.+)%[(.+)%] посадил игрока (.+)%[(.+)%] в деморган на 30 минут. Причина: дб") then  
            local nick, id  = text:match("Администратор (.+)%[(.+)%] посадил игрока (.+)%[(.+)%] в деморган на 30 минут. Причина: дб")
            wait(2000)
            sampSendChat('/awarn '..id..' НВН')
            wait(200)
            setVirtualKeyDown(119, true) wait(10) setVirtualKeyDown(119, false)
    end
    if text:find("Администратор (.+)%[(.+)%] посадил игрока (.+)%[(.+)%] в деморган на 30 минут. Причина: ДБ") then  
        local nick, id  = text:match("Администратор (.+)%[(.+)%] посадил игрока (.+)%[(.+)%] в деморган на 30 минут. Причина: ДБ")
        wait(2000)
        sampSendChat('/awarn '..id..' НВН')
        wait(200)
        setVirtualKeyDown(119, true) wait(10) setVirtualKeyDown(119, false)
    end
    if text:find("Администратор (.+)%[(.+)%] посадил игрока (.+)%[(.+)%] в деморган на 30 минут. Причина: db") then  
        local nick, id  = text:match("Администратор (.+)%[(.+)%] посадил игрока (.+)%[(.+)%] в деморган на 30 минут. Причина: db")
        wait(2000)
        sampSendChat('/awarn '..id..' НВН')
        wait(200)
        setVirtualKeyDown(119, true) wait(10) setVirtualKeyDown(119, false)
    end
    if text:find("Администратор (.+)%[(.+)%] посадил игрока (.+)%[(.+)%] в деморган на 30 минут. Причина: DB") then  
        local nick, id  = text:match("Администратор (.+)%[(.+)%] посадил игрока (.+)%[(.+)%] в деморган на 30 минут. Причина: DB")
        wait(2000)
        sampSendChat('/awarn '..id..' НВН')
        wait(200)
        setVirtualKeyDown(119, true) wait(10) setVirtualKeyDown(119, false)
    end
    ----------------------------------------------АВТО ОПРА----------------------------------------------
    if stals then
    if text:find("(.+)%[(.+)%] купил дом ID: (%d+)(.+)") then  
        local nick, id, dom  = text:match("(.+)%[(.+)%] купил дом ID: (%d+)(.+)")
        wait(2000)
        sampSendChat('/jail '..id.. ' 3000 Опра дом '..dom)
end
if text:find("(.+)%[(.+)%] купил бизнес ID: (%d+)(.+)") then  
    local nick, id, biz  = text:match("(.+)%[(.+)%] купил бизнес ID: (%d+)(.+)")
    wait(2000)
    sampSendChat('/jail '..id.. ' 3000 Опра бизнес '..biz)
end
----------------------------------------MUTE OSYJDAUUU-------------------------------------------
if text:find('%[.+%] .+%[.+%]: mq') then
    id = text:match('%[.+%] .+%[(.+)%]: mq')
    wait(500)
    sampSendChat('/mute '..id..' 300 упоминание родных')
end
if text:find('%[.+%] .+%[.+%]: MQ') then
    id = text:match('%[.+%] .+%[(.+)%]: MQ')
    wait(500)
    sampSendChat('/mute '..id..' 300 упоминание родных')
end
if text:find('%[.+%] .+%[.+%]: mq .+') then
    id = text:match('%[.+%] .+%[(.+)%]: mq .+')
    wait(500)
    sampSendChat('/mute '..id..' 300 упоминание родных')
end
if text:find('%[.+%] .+%[.+%]: MQ .+') then
    id = text:match('%[.+%] .+%[(.+)%]: MQ .+')
    wait(500)
    sampSendChat('/mute '..id..' 300 упоминание родных')
end
end
end)
end
function samp_create_sync_data(sync_type, copy_from_player)
    local ffi = require 'ffi'
    local sampfuncs = require 'sampfuncs'
    local raknet = require 'samp.raknet'

    copy_from_player = copy_from_player or true
    local sync_traits = {
        player = {'PlayerSyncData', raknet.PACKET.PLAYER_SYNC, sampStorePlayerOnfootData},
        vehicle = {'VehicleSyncData', raknet.PACKET.VEHICLE_SYNC, sampStorePlayerIncarData},
        passenger = {'PassengerSyncData', raknet.PACKET.PASSENGER_SYNC, sampStorePlayerPassengerData},
        aim = {'AimSyncData', raknet.PACKET.AIM_SYNC, sampStorePlayerAimData},
        trailer = {'TrailerSyncData', raknet.PACKET.TRAILER_SYNC, sampStorePlayerTrailerData},
        unoccupied = {'UnoccupiedSyncData', raknet.PACKET.UNOCCUPIED_SYNC, nil},
        bullet = {'BulletSyncData', raknet.PACKET.BULLET_SYNC, nil},
        spectator = {'SpectatorSyncData', raknet.PACKET.SPECTATOR_SYNC, nil}
    }
    local sync_info = sync_traits[sync_type]
    local data_type = 'struct ' .. sync_info[1]
    local data = ffi.new(data_type, {})
    local raw_data_ptr = tonumber(ffi.cast('uintptr_t', ffi.new(data_type .. '*', data)))
    if copy_from_player then
        local copy_func = sync_info[3]
        if copy_func then
            local _, player_id
            if copy_from_player == true then
                _, player_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            else
                player_id = tonumber(copy_from_player)
            end
            copy_func(player_id, raw_data_ptr)
        end
    end
    local func_send = function()
        local bs = raknetNewBitStream()
        raknetBitStreamWriteInt8(bs, sync_info[2])
        raknetBitStreamWriteBuffer(bs, raw_data_ptr, ffi.sizeof(data))
        raknetSendBitStreamEx(bs, sampfuncs.HIGH_PRIORITY, sampfuncs.UNRELIABLE_SEQUENCED, 1)
        raknetDeleteBitStream(bs)
    end
    local mt = {
        __index = function(t, index)
            return data[index]
        end,
        __newindex = function(t, index, value)
            data[index] = value
        end
    }
    return setmetatable({send = func_send}, mt)
end

function sampev.onShowDialog(dialogId, dialogStyle, dialogTitle, okButtonText, cancelButtonText, dialogText)
	if dialogId == 2 and akk_password then
		if dialogText:find('Добро пожаловать') then
			sampSendDialogResponse(2, 1, 65535, akk_password)
			return false
		end
    end
end
function onReceiveRpc(id,bitStream)
    if id == 61 then
        dialogId = raknetBitStreamReadInt16(bitStream)
        style = raknetBitStreamReadInt8(bitStream)
        str = raknetBitStreamReadInt8(bitStream)
        title = raknetBitStreamReadString(bitStream, str)
        if title:find("Авторизация") then sampSendDialogResponse(dialogId,1,0,admin_password) end
    end
end

function cchas()
    lua_thread.create(function ()
        sampSendChat('/givechass')
        wait(1500)
        sampSendChat('/ao Включил команду /cchas')
        wait(10000)
        sampSendChat('/givechass')
        wait(1500)
        sampSendChat('/ao Выключил команду /cchas')
    end)
end

function cx2()
    lua_thread.create(function ()
        sampSendChat('/givechass')
        wait(1500)
        sampSendChat('/ao Включил команду /cchas на 5 секунд (х1)')
        wait(5000)
        sampSendChat('/givechass')
        wait(1500)
        sampSendChat('/ao Выключил /cchas. (х1) ')
        wait(1500)
        sampSendChat('/givechass')
        wait(1500)
        sampSendChat('/ao Включил команду /cchas на 5 секунд (х2)')
        wait(5000)
        sampSendChat('/givechass')
        wait(1500)
        sampSendChat('/ao Выключил /cchas. (х2)')
    end)
end


function reklama()
    lua_thread.create(function ()
        sampSendChat("/ao Уважаемые игроки, напоминаем про наш Telegram канал, в котором регулярно проходят розыгрыши."); wait(2000)
            sampSendChat("/ao Именно тут мы зачастую рассылаем уникальные и редкие коды, присоединяйся – t.me/arena_rp!"); wait(5000)
            sampSendChat("/ao Уважаемые игроки, у нас есть группа ВК, в которой регулярно проходят розыгрыши."); wait(2000)
            sampSendChat("/ao Присоединяйтесь к дружному сообществу игроков сервера – vk.com/arp_666!"); wait(5000)
            sampSendChat("/ao Уважаемые игроки, напоминаю, что все амнистии, обжалования наказаний, подача опровержений,"); wait(2000)
            sampSendChat("/ao подачи заявлений на пост лидера, администратора проходят через наш форум – forum.rp-arena.ru!")
    end)
end


function addcode()
	cd = true
	lua_thread.create(function()
		local code, act, cd = getRandomWord(7), random(1, 8), true
		prize = random(100, 300)
		sampSendChat(string.format("/addcode %s %d", code, act))
        wait(2000)
        sampSendChat(string.format("/ao Создал код %s [Активаций: %d] с призом %d AZ-RUB.", code, act, prize))
		wait(15000)
		sampSendChat(string.format("/dellcode %s", code))
    end)
end

function CodeAdm()
	cd = true
	lua_thread.create(function()
		local code, act, cd = getRandomWord(7), random(1, 8), true
		prize = random(100, 300)
		sampSendChat(string.format("/addcode %s %d", code, act))
        wait(2000)
        sampSendChat(string.format("/a Создал код %s [Активаций: %d] с призом %d AZ-RUB.", code, act, prize))
		wait(15000)
		sampSendChat(string.format("/dellcode %s", code))
    end)
end
