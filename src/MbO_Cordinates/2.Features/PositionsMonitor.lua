local _, addon = ...;

local PositionMonitor = {};
addon.PositionMonitor = PositionMonitor;


-- Флаг статуса работы монитора
local _isRuning = false;

-- Максимальное значение итераций таймера
local _timerMaxIterations = 1000000;


-- Дескриптор таймера
local _playerPositionTimerHandler = nil;
-- Период повтора выполненеия операции
local _playerPositionTimerPeriod = 0.2;
-- Счетчик таймера
local _playerPositionTimerCounter = 0;
-- Таблица подписчиков события onPlayerPositionChanged
local _onPlayerPositionChangedListenersTable = {};
-- Значения X и Y позиции игрока
local _playerPositionX, _playerPositionY = nil, nil;

-- Дескриптор таймера
local _worldMapCursorPositionTimerHandler = nil;
-- Период повтора выполненеия операции
local _worldMapCursorPositionTimerPeriod = 0.2;
-- Таблица подписчиков события onWorldMapCursorPositionChanged
local _onWorldMapCursorPositionChangedListenersTable = {};
-- Счетчик таймера
local _worldMapCursorPositionTimerCounter = 0;
-- Значения X и Y позиции курсора на миникарте
local _worldMapCursorPositionX, _worldMapCursorPositionY = nil, nil;


--
-- Запустить монитор
--
function PositionMonitor:start()
    if _isRuning then
        return;
    end

    _isRuning = true;

    self:_initPlayerPositionTimer();
    self:_initWorldMapCursorPositionTimer();
end

--
-- Остановить монитор
--
function PositionMonitor:stop()
    if _playerPositionTimerHandler then
        _playerPositionTimerHandler:Cancel();
    end

    if _worldMapCursorPositionTimerHandler then
        _worldMapCursorPositionTimerHandler:Cancel();
    end

    _isRuning = false;
end

--
-- Добавить подписчика события onPlayerPositionChanged
--
function PositionMonitor:addOnPlayerPositionChangedListener(id, callback)
    _onPlayerPositionChangedListenersTable[id] = callback;
end

--
-- Добавить подписчика события onWorldMapCursorPositionChanged
--
function PositionMonitor:addOnWorldMapCursorPositionChangedListener(id, callback)
    _onWorldMapCursorPositionChangedListenersTable[id] = callback;
end

--
-- Инициировать таймер для мониторингапозиции игрока
--
function PositionMonitor:_initPlayerPositionTimer()
    -- Обнуление счетчика для работы
    _playerPositionTimerCounter = 0;

    -- Функция-контейнер, вызываемая по таймеру
    local fc = C_FunctionContainers.CreateCallback(
        function()
            _playerPositionTimerCounter = _playerPositionTimerCounter + 1;

            local x, y = self:_getPlayerPosition();

            if x ~= _playerPositionX or y ~= _playerPositionY then
                -- Вызов подписчиков события
                for _, callback in pairs(_onPlayerPositionChangedListenersTable) do
                    callback(self, x, y);
                end
            end

            -- Перезапуск таймера после выполнения максимального количества итераций
            if _playerPositionTimerCounter == _timerMaxIterations then
                PositionMonitor:_initPlayerPositionTimer();
            end
        end
    )

    _playerPositionTimerHandler = C_Timer.NewTicker(_playerPositionTimerPeriod, fc, _timerMaxIterations);
end

--
-- Инициировать таймер для мониторинга позиции курсора мыши на карте мира
--
function PositionMonitor:_initWorldMapCursorPositionTimer()
    -- Обнуление счетчика для работы
    _worldMapCursorPositionTimerCounter = 0;

    -- Функция-контейнер, вызываемая по таймеру
    local fc = C_FunctionContainers.CreateCallback(
        function()
            _worldMapCursorPositionTimerCounter = _worldMapCursorPositionTimerCounter + 1;

            local x, y = self:_getWorldMapCursorPosition();

            if x ~= _worldMapCursorPositionX or y ~= _worldMapCursorPositionY then
                -- Вызов подписчиков события
                for _, callback in pairs(_onWorldMapCursorPositionChangedListenersTable) do
                    callback(self, x, y);
                end
            end

            -- Перезапуск таймера после выполнения максимального количества итераций
            if _worldMapCursorPositionTimerCounter == _timerMaxIterations then
                PositionMonitor:_initWorldMapCursorPositionTimer();
            end
        end
    )

    _worldMapCursorPositionTimerHandler = C_Timer.NewTicker(_worldMapCursorPositionTimerPeriod, fc, _timerMaxIterations);
end

--
-- Получить позицию игрока
--
function PositionMonitor:_getPlayerPosition()
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
function PositionMonitor:_getWorldMapCursorPosition()
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
