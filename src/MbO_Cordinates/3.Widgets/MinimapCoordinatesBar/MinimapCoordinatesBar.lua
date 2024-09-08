MinimapCoordinatesBarMixin = {};

-- Счетчик времени для уменьшения частоты пересчета координат
MinimapCoordinatesBarMixin.TimeSinceLastUpdate = 0;

-- Период обновления данных - 500мс
local updatePeriod = 0.5;


--
-- Функция-обработчик события onUpdate
--
function MinimapCoordinatesBarMixin:onUpdate(elapsed)
    -- Обработка происходит только после истечения таймера
    self.TimeSinceLastUpdate = self.TimeSinceLastUpdate - elapsed;

    if self.TimeSinceLastUpdate <= 0
    then
        -- Обновление координат
        self:_updatePlayerCoordinates();

        -- Восстановление таймера следующего обновления
        self.TimeSinceLastUpdate = updatePeriod;
    end
end

--
-- Обновить координаты на панели
--
function MinimapCoordinatesBarMixin:_updatePlayerCoordinates()
    -- Получение позиции
    local x, y = self:_getPlayerPosition();

    self.PlayerPos.X:SetText(x == nil and "---" or string.format("%.1f", x));
    self.PlayerPos.Y:SetText(y == nil and "---" or string.format("%.1f", y));
end

--
-- Получить координаты игрока в локации
--
function MinimapCoordinatesBarMixin:_getPlayerPosition()
    -- Определение локации игрока
    local mapId = C_Map.GetBestMapForUnit("player");
    if mapId == nil
    then
        return nil, nil;
    end

    -- Определение позиции в локации
    local mapPosition = C_Map.GetPlayerMapPosition(mapId, "player");
    if mapPosition == nil
    then
        return nil, nil;
    end

    -- Умножение на 100 для формата XX.X
    return mapPosition.x * 100, mapPosition.y * 100;
end
