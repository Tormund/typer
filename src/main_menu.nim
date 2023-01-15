import nimx / [ view, event, font, layout, text_field, formatted_text, view_event_handling ]
import typer_theme, options_list, typer

type 
  MainMenu* = ref object of TyperView
    options: OptionList
    hint: Label

proc updateStartHint(v: MainMenu) =
  let s = v.options.selectedOption()
  v.hint.text = "Start the " & s & " mode"
  v.setNeedsDisplay()

method init*(v: MainMenu, r: Rect) {.gcsafe.} =
  procCall v.View.init(r)
  v.makeLayout:
    - HintLabel as hint:
      text: ""
      width == super
      centerX == super
      y == super.height - 30
      horizontalAlignment: haCenter

    - MenuLabel as welcomeLbl:
      text: "Welcome to Typer"
      y == 50.0
      centerX == super
      height >= 25.0
      width == super
      horizontalAlignment: haCenter
    
    - HintLabel:
      text: "Controls:\nj k - navigate\nw d - theme\nspace - to start"
      centerY == super
      x == 10
      width == 250
      horizontalAlignment: haJustify
      

    - OptionList as options:
      centerY == super
      x == super.width * 0.5 - 50
      width == super
      horizontalAlignment: haLeft
  v.hint = hint
  v.options = options
  v.options.setOptions(@["carear", "infinity", "etc"])
  v.updateStartHint() 
  v.setTheme()

method onTextInput*(v: MainMenu, s: string): bool =
  # echo "mainMenu on text: ", s
  case s
    of "d":
      setCurrentTheme(darkTheme)
      v.setTheme()
      # echo "set dark theme"
    of "w":
      setCurrentTheme(whiteTheme)
      v.setTheme()
      # echo "set light theme"
    of "k":
      v.options.selectPrev()
      v.updateStartHint()
    of "j":
      v.options.selectNext()
      v.updateStartHint()
    of " ":
      v.window.makeLayout:
        - LevelView as level:
          x == 5
          y == 5
          width == super.width - 10.0
          height == super.height - 10.0
      discard level.makeFirstResponder()
      # v.removeFromSuperview()
    else:
      discard
