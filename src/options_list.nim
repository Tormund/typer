import nimx / [ text_field ]
import typer_theme

type OptionList* = ref object of HintLabel
  options: seq[string]
  selected: int

proc updateText(v: OptionList) = 
  v.text = ""
  for i, o in v.options:
    if i != v.selected:
      v.text = v.text & "[ ] " & o & "\n"
    else:
      v.text = v.text & "[x] " & o & "\n"

proc selectedOption*(v: OptionList): string = v.options[v.selected]

proc select*(v: OptionList, idx: int) =
  v.selected = clamp(idx, 0, v.options.len - 1)
  v.updateText()

proc selectNext*(v: OptionList) =
  inc v.selected
  if v.selected >= v.options.len:
    v.selected = 0
  v.updateText()

proc selectPrev*(v: OptionList) =
  dec v.selected
  if v.selected < 0:
    v.selected = high(v.options)
  v.updateText()

proc setOptions*(v: OptionList, options: seq[string]) = 
  v.options = options
  v.selected = 0
  v.updateText()

