script_versiov('2')

local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local main_window_state = imgui.ImBool(false)
local sizeX, sizeY = getScreenResolution()
local active, status, cd, sd, ac = false, false, false, false, false



local dlstatus = require('moonloader').download_status

function update()
  local fpath = os.getenv('TEMP') .. '\\testing_version.json' -- куда будет качаться наш файлик для сравнения версии
  downloadUrlToFile('https://api.jsonbin.io/v3/b/6505d6798d92e126ae6d97f4', fpath, function(id, status, p1, p2) -- ссылку на ваш гитхаб где есть строчки которые я ввёл в теме или любой другой сайт
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
    local f = io.open(fpath, 'r') -- открывает файл
    if f then
      local info = decodeJson(f:read('*a')) -- читает
      updatelink = info.updateurl
      if info and info.latest then
        version = tonumber(info.latest) -- переводит версию в число
        if version > tonumber(thisScript().version) then -- если версия больше чем версия установленная то...
          lua_thread.create(goupdate) -- апдейт
        else -- если меньше, то
          update = false -- не даём обновиться
          sampAddChatMessage(('[Testing]: У вас и так последняя версия! Обновление отменено'), color)
        end
      end
    end
  end
end)
end
--скачивание актуальной версии
function goupdate()
sampAddChatMessage(('[Testing]: Обнаружено обновление. AutoReload может конфликтовать. Обновляюсь...'), color)
sampAddChatMessage(('[Testing]: Текущая версия: '..thisScript().version..". Новая версия: "..version), color)
wait(300)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23) -- качает ваш файлик с latest version
  if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
  sampAddChatMessage(('[Testing]: Обновление завершено!'), color)
  thisScript():reload()
end
end)
end

-- ВСЁ!

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end
    sampRegisterChatCommand('bhelp', function ()  main_window_state.v = not  main_window_state.v end)
    while true do
        wait(0)
        imgui.Process =  main_window_state.v
        imgui.ShowCursor =  main_window_state.v
    end
end

function imgui.OnDrawFrame()
    if main_window_state.v then 
      imgui.SetNextWindowSize(imgui.ImVec2(600, 270), imgui.Cond.FirstUseEver) 
      imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.Begin('Information for bot', main_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar)
      imgui.Text(u8'Команды бота: /all - Реклама бота. /ch - Включит cchas 1 раз ')
      imgui.Text(u8'/ch2 - Включит cchas 2 раза. /aopra - Включит Авто-Опру, ')
      imgui.Text(u8'/autorep - Авто-Ловля репорта, /rekl - Реклама групп арены, /agm - Включит ГМ.')
      imgui.Text(u8'/awh - Включит WallHack (names, bones, all)')
      imgui.Separator()
      imgui.PushItemWidth(150)
      imgui.Text(u8'Справка бот реагирует на слова: бот слап, бот лопату, бот спавн')
      imgui.Text(u8'бот машину, бот люкс, бот нрг, бот флип, бот аб, бот цр, бот цб')
      imgui.Text(u8'бот хп, бот унфриз, бот маверик, бот шамал, бот гидру, бот правила рп/чата')
      if imgui.Button("Random Code", imgui.ImVec2(100, 25)) then
        addcode()
      end
      imgui.SameLine()
        if imgui.Button("Random Adm", imgui.ImVec2(100, 25)) then
          CodeAdm()
      end
      imgui.SameLine()
      if imgui.Button("Cchas x1", imgui.ImVec2(100, 25)) then
          cchas()
        end
        imgui.SameLine()
        if imgui.Button("Cchas x2", imgui.ImVec2(100, 25)) then
          cx2()
        end
      imgui.End()
    end
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

  function getRandomWord(length)
      local word = ''
      for i = 1, length do
          word = word .. string.char(math.random(97, 122))
      end
      return word
  end
  function random(min, max)
      kf = math.random(min, max)
      math.randomseed(os.time() * kf)
      rand = math.random(min, max)
      return tonumber(rand)
  end
  function theme()
      imgui.SwitchContext()
  local style = imgui.GetStyle()
  local colors = style.Colors
  local clr = imgui.Col
  local ImVec4 = imgui.ImVec4
  local ImVec2 = imgui.ImVec2
  
  style.WindowPadding = ImVec2(15, 15)
  style.WindowRounding = 6.0
  style.FramePadding = ImVec2(5, 5)
  style.FrameRounding = 4.0
  style.ItemSpacing = ImVec2(12, 8)
  style.ItemInnerSpacing = ImVec2(8, 6)
  style.IndentSpacing = 25.0
  style.ScrollbarSize = 15.0
  style.ScrollbarRounding = 9.0
  style.GrabMinSize = 5.0
  style.GrabRounding = 3.0
  
  colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
  colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
  colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
  colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
  colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
  colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
  colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
  colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.TitleBg] = ImVec4(0.76, 0.31, 0.00, 1.00)
  colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
  colors[clr.TitleBgActive] = ImVec4(0.80, 0.33, 0.00, 1.00)
  colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
  colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
  colors[clr.CheckMark] = ImVec4(1.00, 0.42, 0.00, 0.53)
  colors[clr.SliderGrab] = ImVec4(1.00, 0.42, 0.00, 0.53)
  colors[clr.SliderGrabActive] = ImVec4(1.00, 0.42, 0.00, 1.00)
  colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
  colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
  colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
  colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
  colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
  colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
  colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
  colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
  colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
  colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
  colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
  end
  theme()
  
