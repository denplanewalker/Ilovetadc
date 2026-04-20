local ObsidianTypes = require("./Ilovetadc/Library.d")

return {
    Library = (require("./Ilovetadc/Library") :: any) :: Ker0Types.Library,
    Types = require("./Ilovetadc/Library.d"),
    SaveManager = require("./Ilovetadc/addons/SaveManager"),
    ThemeManager = require("./Ilovetadc/addons/ThemeManager")
}
