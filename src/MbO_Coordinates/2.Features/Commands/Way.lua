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
            print("Cannot set waypoints on this map")
        end
    end
end

--
-- Разбор аргументов команды
--
function WayCommandHelper:_parseCommnandArguments(args)
    local mapId, xPos, yPos = nil, nil, nil;

    local tokens = {};
    for token in args:gmatch("%S+") do
        table.insert(tokens, token);
    end

    for _, token in pairs(tokens) do
        if mapId == nil and token:match("#%d+") ~= nil then        -- Проверка, что токен является идентификатором локации
            mapId = tonumber(token:match("%d+"));
        elseif xPos == nil and token:match("%d+%.*%d") ~= nil then -- Проверка, что токен является координатой X
            xPos = tonumber(token);
        elseif yPos == nil and token:match("%d+%.*%d") ~= nil then -- Проверка, что токен является координатой Y
            yPos = tonumber(token);
        end
    end

    return mapId, xPos, yPos;
end


-- Глобальное объявление команды
SLASH_WAY1 = "/way";
SlashCmdList["WAY"] = wayCommandHandler;