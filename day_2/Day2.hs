import Data.List.Split

type Color = String
type Cubes = (Int, Color) -- n times color
type Set = [Cubes]
type Game = (Int, [Set])

-- Helpers
innerMap :: (a->b) -> [[a]] -> [[b]]
innerMap func = map (map func)

tuple2Map :: (a->b, c->d) -> (a,c) -> (b,d)
tuple2Map (f, g) (a,b) = (f a, g b)

tuple3Map :: (a->d,b->f,c->g) -> (a,b,c) -> (d,f,g)
tuple3Map (f,g,h) (a,b,c) = (f a, g b, h c)

tuplify2 :: [a] -> (a,a)
tuplify2 [x,y] = (x,y)

myMax :: [Int] -> Int
myMax [] = 0
myMax list = maximum list

triple :: a -> (a,a,a)
triple a = (a,a,a)

-- Real Code

sumFilteredNumberedPair :: ((Int, a) -> Bool) -> [(Int,a)] -> Int
sumFilteredNumberedPair func = sum . map fst . filter func

sumCubesByColor :: String -> Set -> Int
sumCubesByColor color = sumFilteredNumberedPair ((== color) . snd)

checkPossibleSet :: Set -> Bool
checkPossibleSet set = sum_red <= 12 && sum_green <= 13 && sum_blue <= 14
    where 
        sum_red = sumCubesByColor "red" set
        sum_blue = sumCubesByColor "blue" set
        sum_green = sumCubesByColor "green" set

checkPossibleRound :: [Set] -> Bool
checkPossibleRound = all checkPossibleSet

checkPossibleGames :: [Game] -> Int
checkPossibleGames = sumFilteredNumberedPair (checkPossibleRound . snd)


collectMaxCubesPerSet :: Set -> (Int,Int,Int)
collectMaxCubesPerSet list = tuple3Map (triple numColoredCubes) ("red", "green", "blue")
    where
        numColoredCubes color = myMax $ map fst $ filter ((== color) . snd) list
        
collectMaxCubesPerGame :: [Set] -> (Int,Int,Int)
collectMaxCubesPerGame game = tuple3Map (triple myMax) $ unzip3 $ map collectMaxCubesPerSet game

collectMaxCubes :: [[Set]] -> Int
collectMaxCubes = sum . map (multi . collectMaxCubesPerGame)
    where
        multi (a,b,c) = a*b*c



parseCubes :: String -> Cubes
parseCubes = tuple2Map (read, id) . tuplify2 . splitOn " "

parseSet :: String -> Set
parseSet = map parseCubes . splitOn ", "

parseSets :: String -> [Set]
parseSets = map parseSet . splitOn "; "

parseGame :: String -> Game
parseGame = tuple2Map (read, parseSets) . tuplify2 . splitOn ": "

parseFullGame :: String -> [Game]
parseFullGame = map parseGame . lines

input_1 = do
    contents <- readFile "input_1.txt"

    let parsed_input = parseFullGame contents
    
    print $ checkPossibleGames parsed_input
    print $ collectMaxCubes $ map snd parsed_input