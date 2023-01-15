import random, oids, strutils, sequtils

const easy0 = {'a','s','d','f','j','k','l',';'}
const easy1 = easy0 + {'g','h',' '}
const medium0 = {'a' .. 'z'} 
const medium1 = Letters + {';',' '}
const medium2 = medium1 + Digits + {'-', '=', ',', '.', '/', '\\'}
const hard0 = medium2 + {'!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+'}
const hard1 = hard0 + {'{', '}', '<', '>', '\'', '`', ':', '\"'}

const charsets = [
    easy0, easy1, medium0, medium1, medium2, hard0, hard1
]

type Difficulty* {.pure.} = enum
    easy0, easy1, medium0, medium1, medium2, hard0, hard1

var r = initRand(genOid().hash.int64)

proc charset(d: Difficulty): seq[char] =
    toSeq(charsets[d.int])

proc randomChar(charset: seq[char]): char =
    let c = r.rand(charset.len - 1)
    result = charset[c]

proc generateTask*(d: Difficulty, tlen: int): string =
    discard d.charset
    var charset = d.charset
    for i in 0 ..< tlen:
        result.add(charset.randomChar)
    while result[0] in Whitespace:
        result[0] = charset.randomChar
    while result[^1] in Whitespace:
        result[^1] = charset.randomChar
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
