local _, addon = ...;

WorldMapCoordinatesBarMixin = {};


--
-- Функция-обработчик события onLoad
--
function WorldMapCoordinatesBarMixin:onLoad()
    addon.PositionMonitor:addOnPlayerPositionChangedListener(
        "WorldMapCoordinatesBarMixin",
        self.onPlayerPositionChanged
    );
    addon.PositionMonitor:addOnWorldMapCursorPositionChangedListener(
        "WorldMapCoordinatesBarMixin",
        self.onWorldMapCursorPositionChanged
    );
    addon.PositionMonitor:start();
end

--
-- Функция-обработчик события onTick
--
function WorldMapCoordinatesBarMixin:onPlayerPositionChanged(x, y)
    local targetFrame = _G["WorldMapFrame"].CoordinatesBar.PlayerPos;

    -- Отображение координат игрока
    targetFrame.X:SetText(x == nil and "---" or string.format("%.1f", x));
    targetFrame.Y:SetText(y == nil and "---" or string.format("%.1f", y));
end

--
-- Обновить координаты указателя мыши
--
function WorldMapCoordinatesBarMixin:onWorldMapCursorPositionChanged(x, y)
    local targetFrame = _G["WorldMapFrame"].CoordinatesBar.CursorPos;

    targetFrame.X:SetText(x == nil and "---" or string.format("%.1f", x));
    targetFrame.Y:SetText(y == nil and "---" or string.format("%.1f", y));
end
