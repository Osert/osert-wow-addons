local _, addon = ...;

WorldMapCoordinatesBarMixin = {};


-- Задержка таймера в секундах
local _delay = 0.2;
-- 1 миллиарда итераций хватит на более 27000 часов работы
local _maxIterations = 1000000;


--
-- Функция-обработчик события onLoad
--
function WorldMapCoordinatesBarMixin:onLoad()
    C_Timer.NewTicker(_delay, self._updatePlayerPosition, _maxIterations);
    C_Timer.NewTicker(_delay, self._updateCursorPosition, _maxIterations);
end

--
-- Обновить координаты игрока в виджете
--
function WorldMapCoordinatesBarMixin:_updatePlayerPosition()

    local x, y = WorldMapCoordinatesBarMixin:_getPlayerPosition();

    local targetFrame = _G["WorldMapFrame"].CoordinatesBar.PlayerPos;

    -- Отображение координат
    targetFrame.X:SetText(x == nil and "---" or string.format("%.1f", x));
    targetFrame.Y:SetText(y == nil and "---" or string.format("%.1f", y));
end

--
-- Обновить координаты курсора в виджете
--
function WorldMapCoordinatesBarMixin:_updateCursorPosition()

    local x, y = WorldMapCoordinatesBarMixin:_getCursorPosition();

    local targetFrame = _G["WorldMapFrame"].CoordinatesBar.CursorPos;

    -- Отображение координат
    targetFrame.X:SetText(x == nil and "---" or string.format("%.1f", x));
    targetFrame.Y:SetText(y == nil and "---" or string.format("%.1f", y));
end

--
-- Получить позицию игрока
--
function WorldMapCoordinatesBarMixin:_getPlayerPosition()
    -- Определение локации игрока
    local mapId = C_Map.GetBestMapForUnit("player");
    if mapId ~= nil then
        -- Определение позиции в локации
        local mapPosition = C_Map.GetPlayerMapPosition(mapId, "player");
        if mapPosition ~= nil then
            -- Умножение на 100 для формата XX.X
            return mapPosition.x * 100, mapPosition.y * 100;
        end
    end

    return nil, nil;
end

--
-- Получить координты курсора на карте мира
--
function WorldMapCoordinatesBarMixin:_getCursorPosition()
    local worldMapFrame = _G["WorldMapFrame"];
    if worldMapFrame ~= nil then
        -- Определение позиции курсора на карте мира
        local normX, normY = worldMapFrame:GetNormalizedCursorPosition();
        if 0 < normX and normX < 1 and 0 < normY and normY < 1 then
            -- Умножение на 100 для формата XX.X
            return normX * 100, normY * 100;
        end
    end

    return nil, nil;
end
