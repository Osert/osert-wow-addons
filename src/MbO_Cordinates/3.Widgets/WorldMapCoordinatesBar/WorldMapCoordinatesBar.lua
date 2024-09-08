WorldMapCoordinatesBarMixin = {};

-- Счетчик времени для уменьшения частоты пересчета координат
WorldMapCoordinatesBarMixin.TimeSinceLastUpdate = 0;

-- Период обновления данных - 200мс
local updatePeriod = 0.2;


--
-- Функция-обработчик события onUpdate
--
function WorldMapCoordinatesBarMixin:onUpdate(elapsed)
    -- Обработка происходит только после истечения таймера
    self.TimeSinceLastUpdate = self.TimeSinceLastUpdate - elapsed;

    if self.TimeSinceLastUpdate <= 0
    then
        -- Обновление координат игрока
        self:_updatePlayerCoordinates();

        -- Обновление координат курсора
        self:_updateCursorCoordinates();

        -- Восстановление таймера следующего обновления
        self.TimeSinceLastUpdate = updatePeriod;
    end
end

--
-- Отобразить координаты игрока
--
function WorldMapCoordinatesBarMixin:_updatePlayerCoordinates()
    local x, y = self:_getPlayerPosition();

    self.PlayerPos.X:SetText(x == nil and "---" or string.format("%.1f", x));
    self.PlayerPos.Y:SetText(y == nil and "---" or string.format("%.1f", y));
end

--
-- Обновить координаты указателя мыши
--
function WorldMapCoordinatesBarMixin:_updateCursorCoordinates()
    local cursorPosX, cursorPosY = self:_getCursorPosition();

    self.CursorPos.X:SetText(cursorPosX == nil and "---" or string.format("%.1f", cursorPosX));
    self.CursorPos.Y:SetText(cursorPosY == nil and "---" or string.format("%.1f", cursorPosY));
end

--
-- Получить координаты игрока в локации
--
function WorldMapCoordinatesBarMixin:_getPlayerPosition()
    -- Определение локации игрока
    local mapId = C_Map.GetBestMapForUnit("player");
    if mapId == nil
    then
        return nil, nil;
    end

    -- Определение позиции в локации
    local position = C_Map.GetPlayerMapPosition(mapId, "player");
    if position == nil
    then
        return nil, nil;
    end

    -- Умножение на 100 для формата XX.X
    return position.x * 100, position.y * 100;
end

--
-- Получить координты под курсором на карте
--
function WorldMapCoordinatesBarMixin:_getCursorPosition()
    local worldMapFrame = _G["WorldMapFrame"];
    if worldMapFrame == nil
    then
        return nil, nil;
    end

    -- Определение позиции курсора на фрейме карты мира
    local normX, normY = worldMapFrame:GetNormalizedCursorPosition();

    if 0 < normX and normX < 1 and 0 < normY and normY < 1
    then
        -- Умножение на 100 для формата XX.X
        return normX * 100, normY * 100;
    else
        return nil, nil;
    end
end
