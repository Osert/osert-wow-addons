local _, addon = ...;

local SettingsPage = {};
addon.SettingsPage = SettingsPage;


--
--  Иницилизировать страницу параметров модификации
--
function SettingsPage:init()
    local rootCategory = Settings.GetCategory("MbO_SettingsPage");

    if rootCategory == nil then
        print("\124cnRED_FONT_COLOR:SettingsPage:init -- ошибка загрузки корневого элемента настроек");
        return;
    end

    local frame = _G["MbO_DevHelper_SettingsPage"];
    frame.name = "MbO_DevHelper_SettingsPage";

    Settings.RegisterCanvasLayoutSubcategory(rootCategory, frame, "Dev-ассистент");
end
