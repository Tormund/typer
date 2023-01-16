import nimx / [ view, event, font, formatted_text, view_event_handling, text_field, layout ]

import task_generator, typer_theme

type 
  LevelCareer* = ref object of BaseLevelView

method init*(v: LevelCareer, r: Rect) =
  procCall v.View.init(r)

  v.setTheme()

method onKeyDown*(v: LevelCareer, e: var Event): bool =
  if e.keyCode == VirtualKey.F5:
    v.onComplete()
    v.onComplete = nil