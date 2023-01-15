import nimx / [ view, event, font, formatted_text, context, composition, button,
  gesture_detector, view_event_handling, layout, text_field ]

import times
import task_generator, typer_theme

const TaskLen = 10

type
  TaskResult = object
    task: string
    res: seq[bool]
    time: seq[float]
    difficulty: Difficulty

  GameRound = ref object
    task: string
    taskIndex: int
    cursorPos: int
    score: int
    prevInputTime: float
    difficulty: Difficulty
    cursor: Label
    field: Label
    scoreLabel: Label
    completedTasks: seq[TaskResult]

  LevelView* = ref object of TyperView
    round: GameRound
    font: Font
    selectedFont: Font
    smallFont: Font
  
method init*(v: LevelView, r: Rect) =
  procCall v.View.init(r)
  v.backgroundColor = blackColor() 
  v.font = newFontWithFace("DejaVuSansMono",40.0f)
  v.selectedFont = newFontWithFace("DejaVuSansMono-Bold", 40.0f)
  v.smallFont = newFontWithFace("DejaVuSansMono-Bold",20.0f)

proc setCursor(v: LevelView) =
  # echo "setting cursor at ", v.round.cursorPos
  if v.round.cursorPos >= TaskLen:
    v.setNeedsDisplay()
    return
  v.round.field.formatted_text.setFontInRange(v.round.cursorPos, v.round.cursorPos + 1, v.selectedFont)
  v.round.field.formatted_text.setTextAlphaInRange(max(0, v.round.cursorPos - 1), v.round.cursorPos, 0.5)
  v.setNeedsDisplay()

template currentTaskStats(v: LevelView): TaskResult = v.round.completedTasks[^1]

proc resetTextFields(v: LevelView) = 
  v.round.field.text = v.round.task
  v.round.field.formatted_text.setFontInRange(0, -1, v.font)
  v.round.field.formatted_text.setTextAlphaInRange(0, -1, 1.0)
  v.round.field.formatted_text.setTextColorInRange(0, -1, whiteColor())

proc setScore(v: LevelView, amount: int) =
  v.round.scoreLabel.text = "Score: " & $amount

proc incScore(v: LevelView, amount: int) =
  v.round.score += amount 
  v.setScore(v.round.score)

proc decScore(v: LevelView, amount: int) = 
  v.round.score -= amount
  v.setScore(v.round.score)

proc setTask(v: LevelView) =
  v.round.cursorPos = 0
  v.round.task = generateTask(v.round.difficulty, TaskLen)
  v.round.completedTasks.setLen(v.round.completedTasks.len + 1)
  v.currentTaskStats.res.setLen(TaskLen)
  v.currentTaskStats.time.setLen(TaskLen)
  v.currentTaskStats.task = v.round.task
  v.currentTaskStats.difficulty = v.round.difficulty
  v.resetTextFields() 

  inc v.round.taskIndex
  if v.round.taskIndex > 10 and v.round.difficulty != Difficulty.hard1:
    v.round.taskIndex = 0
    inc v.round.difficulty
  v.setCursor()

proc highlightInputChar(v: LevelView, index: int, isGood: bool) =
  var c = newColor(0.0, 1.0, 0.0, 1.0)
  if not isGood:
    c = newColor(1.0, 0.0, 0.0, 1.0)
  v.round.field.formatted_text.setTextColorInRange(index, index + 1, c)
  v.setNeedsDisplay()

proc onCharacter(v: LevelView, c: char) =
  var isGood = v.round.task[v.round.cursorPos] == c
  v.currentTaskStats.res[v.round.cursorPos] = isGood
  v.currentTaskStats.time[v.round.cursorPos] = epochTime() - v.round.prevInputTime
  v.highlightInputChar(v.round.cursorPos, isGood)
  if isGood:
    v.incScore(1)
  else:
    v.decScore(1)
  inc v.round.cursorPos
  v.setCursor()
  if v.round.cursorPos >= v.round.task.len:
    v.setTask()

proc start(v: LevelView) =
  v.removeAllSubviews()
  
  v.makeLayout:
    - Label as score:
      text: "Score: 99999"
      font: v.font
      textColor: newColor(0.1, 0.2, 1.0, 1.0)
      centerX == super
      y == 40
      width == super
      horizontalAlignment: haCenter

    - Label as field:
      text: "aa bb ss lll ;;;"
      font: v.font
      centerY == super
      centerX == super
      width == super
      horizontalAlignment: haCenter
    
    - Label as cursor:
      text: ""
      font: v.font
      centerX == super
      centerY == super + 10
      width == super
      horizontalAlignment: haCenter
  
  v.round.new()
  v.round.field = field
  v.round.cursor = cursor
  v.round.scoreLabel = score
  v.round.scoreLabel.text = "0"
  field.formatted_text.setTrackingInRange(0, -1, 10.0f)
  v.setTask()
  v.setScore(0)

proc setup*(v: LevelView) = 
  discard v.makeFirstResponder()
  v.makeLayout:
    - Label as welcomeLbl:
      text: "Welcome to Typer"
      font: v.font
      y == 50.0
      centerX == super
      height >= 25.0
      width == super
      horizontalAlignment: haCenter
      textColor: whiteColor()

    - Label:
      text: "hit Space to start"
      font: v.smallFont
      width == super
      centerX == super
      y == super.height - 30
      horizontalAlignment: haCenter
      textColor: whiteColor()

method onTextInput*(v: LevelView, s: string): bool {.gcsafe.} = 
  if v.round.isNil:
    if s == " ":
      v.start()
      v.round.prevInputTime = epochTime()
    return
  if s.len != 1:
    # echo "invalid input (", s, ")"
    return
  v.onCharacter(s[0])
  v.round.prevInputTime = epochTime()
  # echo "on input: ", s
