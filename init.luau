local ObsidianTypes = require("./Ilovetadc/Library.d")

return {
    Library = (require("./Ilovetadc/Library") :: any) :: ObsidianTypes.Library,
    Types = require("./Ilovetadc/Library.d"),
    SaveManager = require("./Ilovetadc/addons/SaveManager"),
    ThemeManager = require("./Ilovetadc/addons/ThemeManager")
}
