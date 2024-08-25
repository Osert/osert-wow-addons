local _, addon = ...;

local OptionsPage = {};
addon.OptionsPage = OptionsPage;


--
--  Иницилизировать страницу параметров модификации
--
function OptionsPage:init()
    local rootCategory = Settings.GetCategory("MbO_Options");

    if rootCategory == nil then
        print("\124cnRED_FONT_COLOR:OptionsPage:init -- ошибка загрузки виджета параметров");
        return;
    end

    -- DevHelper
    local devHelperFrame = _G["MbO_Options_DebugInfo"];
    local devHelperSubcategory = Settings.RegisterCanvasLayoutSubcategory(rootCategory, devHelperFrame, "DevHelper");

    -- Utils
    local utilsFrame = _G["MbO_Options_Utils"];
    Settings.RegisterCanvasLayoutSubcategory(devHelperSubcategory, utilsFrame, "Utils");
end
