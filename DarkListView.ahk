/************************************************************************
 * @description Apply a dark theme to the ListView control. Note: This script requires AutoHotkey version 2.1-alpha.9 or later.
 * @file DarkListView.ahk
 * @author Nikola Perovic
 * @see https://github.com/nperovic/DarkThemeListView
 * @date 10 APR 2024
 * @version 1.0.0
 ***********************************************************************/

#requires AutoHotkey v2.1-alpha.9

/**
 * Apply a dark theme to the ListView control.
 * @example
 * myGui := Gui()
 * lv    := myGui.AddListView("Count100 LV0x8000 R10 W400 cWhite Background" (myGui.BackColor := 0x202020), ["Select", "Number", "Description"])
 * lv.SetDarkMode() 
 */
class _DarkListView extends Gui.ListView
{
    class tagNMHDR {
        hwndFrom: uptr
        idFrom  : uptr
        code    : i32
    }
    
    class tagNMCUSTOMDRAWINFO {
        hdr        : _DarkListView.tagNMHDR
        dwDrawStage: u32
        hdc        : uptr
        rc         : this.RECT
        dwItemSpec : uptr
        uItemState : u32
        lItemlParam: iptr

        class RECT {
            left: i32, top: i32, right: i32, bottom: i32
        }
    }

    static __New() => super.Prototype.DefineProp("SetDarkMode", {Call: this.SetDarkMode.Bind(this)})  
    
    /**
     * @param {Gui.ListView} _lv "This" object.
     */
    static SetDarkMode(_lv, style := "Explorer")
    {
        static LVS_EX_DOUBLEBUFFER := 0x10000

        _lv.Header        := SendMessage(0x101F,,, _lv)
        _lv._SubClassProc := CallbackCreate(SubClassProc)
        _lv.Opt("LV" LVS_EX_DOUBLEBUFFER)

        SetWindowTheme(_lv.Hwnd, "DarkMode_" style)
        SetWindowTheme(_lv.Header, "DarkMode_ItemsView")
        SetWindowSubclass(_lv.hwnd, _lv._SubClassProc)

        SubClassProc(hWnd, uMsg, wParam, lParam, uIdSubclass, dwRefData)
        {
            static CDRF_NEWFONT        := 0x2
            static CDRF_NOTIFYITEMDRAW := 0x20
            static CDDS_ITEMPREPAINT   := 0x10001
            static CDDS_PREPAINT       := 1
            static NM_CUSTOMDRAW       := -12
            static WM_DESTROY          := 0x2
            static WM_NOTIFY           := 0x4E

            Critical(-1)

            if (uMsg == WM_DESTROY) 
                RemoveWindowSubclass(hWnd, _lv._SubClassProc), CallbackFree(_lv._SubClassProc)
            else if (uMsg == WM_NOTIFY)
                tNMHDR := StructFromPtr(this.tagNMHDR, lParam)
                        
            if !((tNMHDR??0) && tNMHDR.hWndFrom == _lv.Header && tNMHDR.Code == NM_CUSTOMDRAW)
                return DefSubclassProc()
                
            switch (tNMCD := StructFromPtr(this.tagNMCUSTOMDRAWINFO, lParam)).dwDrawStage {
            case CDDS_PREPAINT    : return CDRF_NOTIFYITEMDRAW
            case CDDS_ITEMPREPAINT: return (SetTextColor(tNMCD.hDC, 0xFFFFFF), CDRF_NEWFONT)
            default: return DefSubclassProc()
            }

            DefSubclassProc() => DllCall("DefSubclassProc", "Ptr", hWnd, "UInt", uMsg, "Ptr", wParam, "Ptr", lParam, "Ptr")
        }

        SetTextColor(hdc, color)                  => DllCall("SetTextColor", "Ptr", hdc, "UInt", color)
        SetWindowSubclass(hwnd, callback)         => DllCall("SetWindowSubclass", "Ptr", hWnd, "Ptr", callback, "Ptr", hWnd, "Ptr", 0)
        RemoveWindowSubclass(hwnd, callback, *)   => DllCall("RemoveWindowSubclass", "Ptr", hWnd, "Ptr", callback, "Ptr", hWnd)
        SetWindowTheme(hwnd, appName, subIdList?) => DllCall("uxtheme\SetWindowTheme", "ptr", hwnd, "ptr", StrPtr(appName), "ptr", subIdList ?? 0)
    }
}
