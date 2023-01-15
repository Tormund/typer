
import nimx / [ view, scroll_view, table_view, text_field, layout, window, linear_layout ]
import sequtils, intsets

import src / [ main_menu, typer ]

proc startApplication() =
  let mainWindow = newWindow(newRect(40, 40, 800, 600))
  mainWindow.title = "typ3r"
  mainWindow.makeLayout:
    -MainMenu as welcome:
      x == 5
      y == 5
      width == super.width - 10.0
      height == super.height - 10.0
  discard welcome.makeFirstResponder()
  # welcome.setup()
  # var view = new(WelcomeView, newRect(0,0,800,600))
  # mainWindow.addSubview(view)

runApplication:
  # echo "run"
  startApplication()
