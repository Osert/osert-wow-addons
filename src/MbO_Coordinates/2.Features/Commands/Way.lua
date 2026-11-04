local _, addon = ...;

local WayCommandHelper = {};
addon.WayCommand = WayCommandHelper;

--
-- Обработчик команды /way
--
local function wayCommandHandler(msg, editBox)
    local mapId, xPos, yPos = WayCommandHelper:_parseCommnandArguments(msg);

    if xPos == nil or yPos == nil then
        return;
    end

    if mapId == nil then
        -- Определение идентификатора локации игрока, если она не задана в команде
        mapId = C_Map.GetBestMapForUnit("player");
    end

    if mapId ~= nil then
        -- Путевые точки работают только в локациях открытого мира
        if C_Map.CanSetUserWaypointOnMap(mapId) then
            local position = CreateVector2D(xPos / 100, yPos / 100);
            -- Создание объекта точки на карте
            local mapPoint = UiMapPoint.CreateFromVector2D(mapId, position);
            -- Установка путевой точки на карте
            C_Map.SetUserWaypoint(mapPoint);
            C_SuperTrack.SetSuperTrackedUserWaypoint(true);
        else
            print("Нельзя установить точку на карте")
        end
    end
end

--
-- Разбор аргументов команды
--
function WayCommandHelper:_parseCommnandArguments(args)

    if not args or args == "" then
        print(string.format("Команда [%s]: неверный формат", args));
        return;
    end

    -- Ищем пару координат
    -- Сначала пробуем формат с запятой: "x, y" или "x,y"
    local xPos, yPos = args:match("(%d+%.?%d*)%s*,%s*(%d+%.?%d*)");
    
    -- Если не нашли, пробуем формат с пробелом: "x y"
    if not xPos then
        xPos, yPos = args:match("(%d+%.?%d*)%s+(%d+%.?%d*)");
    end
    
    if not xPos then
        print(string.format("Команда [%s]: координаты не найдены", args));
        return;
    end
    
    xPos = tonumber(xPos);
    yPos = tonumber(yPos);
    
    -- Находим позиции чисел в строке для извлечения префикса
    local _, pos = args:find("%d+%.?%d*");
    
    -- Извлекаем часть до координат (с обрезкой пробелов)
    local prefix = args:sub(1, pos - 1):match("^%s*(.-)%s*$");
    
    -- Определяем наличие ID зоны в префиксе
    local mapId = nil;
    
    if prefix:match("^#%d+$") then
        mapId = tonumber(prefix:match("^#(%d+)$"));
    end

    return mapId, xPos, yPos;
end


-- Глобальное объявление команды
SLASH_WAY1 = "/way";
SlashCmdList["WAY"] = wayCommandHandler;