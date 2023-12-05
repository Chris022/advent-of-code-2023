import Data.List.Split (splitOn)
import Data.List (elem)

listToTuple :: [a] -> (a,a)
listToTuple [a,b,r] = (a,b)
listToTuple [a,b] = (a,b)

mapT2 :: (a->b, c->d) -> (a,c) -> (b,d)
mapT2 (f, g) (a,b) = (f a, g b)

lastOrNull :: [Int] -> Int
lastOrNull [] = 0
lastOrNull list = last list


type Card = ([Int],[Int])
type NumberedCard = (Int,Card)
type CopiedNumberedCard = (Int,Card, Int)

toCard :: CopiedNumberedCard -> Card
toCard (a,b,c) = b

toCopiedNumberedCards :: [NumberedCard] -> [CopiedNumberedCard]
toCopiedNumberedCards = map (\(a,b)->(a,b,1))

getCopies :: CopiedNumberedCard -> Int
getCopies (a,b,c) = c

addCopy :: Int -> CopiedNumberedCard -> CopiedNumberedCard
addCopy by (a,b,c) = (a,b,c+by)

winningNumbers :: Card -> [Int]
winningNumbers = fst

gameNumbers :: Card -> [Int]
gameNumbers = snd

isNumberWinner :: Card -> Int -> Bool
isNumberWinner card number = elem number $ winningNumbers $ card

winners :: Card -> [Int]
winners card = filter (isNumberWinner card) $ gameNumbers card

doubleSeries :: [Int] -> Int
doubleSeries = lastOrNull . map (2^) . flip take (iterate (+1) 0) . length

updateCopies :: [CopiedNumberedCard] -> Int -> Int ->[CopiedNumberedCard]
updateCopies [] _ _ = []
updateCopies list 0 _= list
updateCopies list n by = (++) (map (addCopy by) $ take n list) $ drop n list

processWinner :: [CopiedNumberedCard] -> [CopiedNumberedCard]
processWinner [] = []
processWinner [t] = [t]
processWinner (h:t) = h : processWinner (updateCopies t (length $ winners $ toCard h) $ getCopies h)

countCards :: [CopiedNumberedCard] -> Int
countCards = sum . map getCopies

parseNumberedCard :: String -> NumberedCard
parseNumberedCard = parseCardBody
    where
        parseCardBody = mapT2 (parseCardNum,listToTuple . map parseNumbers . parseCardNumbers) . listToTuple . splitOn ": "
        parseCardNumbers = splitOn " | "
        parseCardNum = read . last . splitOn " "
        parseNumbers = map read . filter (/="") . splitOn " "

parseCard :: String -> Card
parseCard = listToTuple .map parseNumbers . parseCardBody
    where
        parseCardBody = splitOn " | " . last . splitOn ": "
        parseNumbers = map read . filter (/="") . splitOn " "
        
run = do
    contents <- readFile "input_1.txt"
    let parsed_input_1 = map parseCard $ lines contents
    let parsed_input_2 = toCopiedNumberedCards $ map parseNumberedCard $ lines contents

    let points = map (doubleSeries . winners) parsed_input_1
    print $ sum points

    print $ countCards $ processWinner parsed_input_2