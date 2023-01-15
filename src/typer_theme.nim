import nimx / [ types, font, text_field, formatted_text ]

type TyperTheme* = ref object
  menuFont*: Font
  typerFont*: Font
  hintFont*: Font
  backgroundColor*: Color
  textColor*: Color

type 
  MenuLabel* = ref object of Label
  HintLabel* = ref object of Label
  TyperLabel* = ref object of Label
  TyperView* = ref object of View

proc defaultFonts(v: var TyperTheme) =
  v.menuFont = newFontWithFace("DejaVuSansMono", 40.0f) 
  v.typerFont = newFontWithFace("DejaVuSansMono-Bold", 40.0f)
  v.hintFont = newFontWithFace("DejaVuSansMono-Bold", 20.0f)
 
proc darkTheme*(): TyperTheme =
  result.new() 
  result.defaultFonts() 
  result.backgroundColor = blackColor()
  result.textColor = whiteColor()

proc whiteTheme*(): TyperTheme =
  result.new() 
  result.defaultFonts()
  result.backgroundColor = whiteColor()
  result.textColor = blackColor()

var gCurrentTheme{.threadvar.}: TyperTheme 

proc setCurrentTheme*(themeCreator: proc(): TyperTheme) =
  gCurrentTheme = themeCreator()

proc currentTheme*(): TyperTheme =
  if gCurrentTheme.isNil:
    gCurrentTheme = darkTheme() 
  result = gCurrentTheme

method setTheme*(v: View, theme: TyperTheme) {.base.} =
  for sv in v.subviews:
    sv.setTheme(theme)
  v.setNeedsDisplay()

method setTheme*(v: TyperView, theme: TyperTheme)  =
  v.backgroundColor = theme.backgroundColor
  procCall v.View.setTheme(theme)

method setTheme*(v: HintLabel, theme: TyperTheme) =
  v.font = theme.hintFont
  v.textColor = theme.textColor

method setTheme*(v: MenuLabel, theme: TyperTheme) =
  v.font = theme.menuFont
  v.textColor = theme.textColor

method setTheme*(v: TyperLabel, theme: TyperTheme) =
  v.font = theme.typerFont
  v.textColor = theme.textColor


proc setTheme*(v: View) =
  {.gcsafe.}:
    v.setTheme(currentTheme())