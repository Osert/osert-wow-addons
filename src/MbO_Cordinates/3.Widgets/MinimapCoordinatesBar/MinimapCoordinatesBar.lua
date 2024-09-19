local _, addon = ...;

MinimapCoordinatesBarMixin = {};


--
-- Функция-обработчик события onLoad
--
function MinimapCoordinatesBarMixin:onLoad()
    addon.PositionMonitor:start();
    addon.PositionMonitor:addOnPlayerPositionChangedListener(
        "MinimapCoordinatesBarMixin",
        self.onPlayerPositionChanged
    );
end

--
-- Функция-обработчик события onTick
--
function MinimapCoordinatesBarMixin:onPlayerPositionChanged(x, y)
    local targetFrame = _G["MinimapCluster"].CoordinatesBar.PlayerPos;

    -- Отображение координат игрока
    targetFrame.X:SetText(x == nil and "---" or string.format("%.1f", x));
    targetFrame.Y:SetText(y == nil and "---" or string.format("%.1f", y));
end
