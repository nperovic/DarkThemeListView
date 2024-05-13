# DarkThemeListView
An AutoHotkey script that applies a dark theme to the `ListView` control. This script is compatible with AutoHotkey v2.1-alpha.9 or later.

## Features
- Applies a dark theme to the ListView control.
- Compatible with [AutoHotkey v2.1-alpha.9](https://github.com/AutoHotkey/AutoHotkeyDocs/tree/alpha) or later.
- Learn more about the ahk v2.1-alpha: [Click here](https://github.com/AutoHotkey/AutoHotkeyDocs/tree/alpha)

![UIAViewer.ahk applied dark theme](https://github.com/nperovic/DarkThemeListView/assets/122501303/6f84f932-ca64-45d7-853c-939e33b8fea5)


## Usage
1. Download the [DarkListView.ahk](DarkListView.ahk) file.
2. Include the [DarkListView.ahk](DarkListView.ahk) file in your script.
3. Implement dark theme by using the `SetDarkMode` method.

## Example
```HS
#requires AutoHotkey v2.1-alpha.9
#include <DarkListView>

myGui := Gui(, "My ListView"), myGui.BackColor := 0x202020
lv    := myGui.AddListView("Count100 LV0x8000 R10 W400 cWhite Background" myGui.BackColor, ["Select", "Number", "Description"])
lv.SetDarkMode() 
```

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

