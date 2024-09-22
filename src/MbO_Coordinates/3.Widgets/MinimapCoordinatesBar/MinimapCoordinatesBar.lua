local _, addon = ...;

MinimapCoordinatesBarMixin = {};


-- Задержка таймера в секундах
local _delay = 0.2;
-- 1 миллиарда итераций хватит на более 27000 часов работы
local _maxIterations = 1000000;


--
-- Функция-обработчик события onLoad
--
function MinimapCoordinatesBarMixin:onLoad()
    C_Timer.NewTicker(_delay, self._updatePlayerPosition, _maxIterations);
end

--
-- Обновить координаты игрока в виджете
--
function MinimapCoordinatesBarMixin:_updatePlayerPosition()

    local x, y = MinimapCoordinatesBarMixin:_getPlayerPosition();

    local targetFrame = _G["MinimapCluster"].CoordinatesBar.PlayerPos;

    -- Отображение координат
    targetFrame.X:SetText(x == nil and "---" or string.format("%.1f", x));
    targetFrame.Y:SetText(y == nil and "---" or string.format("%.1f", y));
end

--
-- Получить координаты игрока
--
function MinimapCoordinatesBarMixin:_getPlayerPosition()
    -- Определение локации игрока
    local mapId = C_Map.GetBestMapForUnit("player");
    if mapId ~= nil then
        -- Определение координат в локации
        local mapPosition = C_Map.GetPlayerMapPosition(mapId, "player");
        if mapPosition ~= nil then
            -- Умножение на 100 для формата XX.X
            return mapPosition.x * 100, mapPosition.y * 100;
        end
    end

    return nil, nil;
end
