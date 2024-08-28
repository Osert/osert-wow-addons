local _, addon = ...;

local OptionsTree = {};
addon.OptionsTree = OptionsTree;


--
--  Иницилизировать страницу параметров модификации
--
function OptionsTree:init()
    local optionsTreeRootFrame = _G["MbO_Options"];
    local rootCategory = Settings.RegisterCanvasLayoutCategory(optionsTreeRootFrame, "Made by Osert");
    Settings.RegisterAddOnCategory(rootCategory);
end
