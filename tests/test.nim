import unittest, strutils, sets
import task_generator

test "Test tasks":
  for d in Difficulty.low .. Difficulty.high:
    echo "\ndifficulty: ", d
    for i in 0 ..< 10:
      echo generateTask(d, 10)

test "Task whitespace test":
  for i in 0 ..< 100_000:
    let t = generateTask(Difficulty.easy1, 10)
    check t[0] notin WhiteSpace 
    check t[^1] notin WhiteSpace