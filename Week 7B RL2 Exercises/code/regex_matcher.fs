module RegexMatcher

open System
open System.Text.RegularExpressions

let pattern = @"^([abc]*c[abc]*|[abc]*b[abc]*b[abc]*)$"
let regex = Regex(pattern)

let generateStrings () =
    let alphabet = ['a'; 'b'; 'c']
    let length0 = [""]
    let length1 = [for x in alphabet -> string x]
    let length2 = [for x in alphabet do for y in alphabet -> String([|x; y|])]
    let length3 = [for x in alphabet do for y in alphabet do for z in alphabet -> String([|x; y; z|])]
    length0 @ length1 @ length2 @ length3

generateStrings()
|> List.filter regex.IsMatch
|> String.concat " "
|> printfn "%s"
