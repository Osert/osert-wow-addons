local _, addon = ...;

local SettingsPage = {};
addon.SettingsPage = SettingsPage;


--
--  Иницилизировать страницу параметров модификации
--
function SettingsPage:init()


    local frame = _G["MbO_SettingsPage"];
    frame.name = "MbO_SettingsPage";

    local category = Settings.RegisterCanvasLayoutCategory(frame, "Made by Osert");
    category.ID = frame.name;

    Settings.RegisterAddOnCategory(category);
end
