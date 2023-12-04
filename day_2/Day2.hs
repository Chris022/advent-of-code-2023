import Data.List.Split

-- Helpers
innerMap :: (a->b) -> [[a]] -> [[b]]
innerMap func = map (map func)

tupleMap :: (a->b) -> (a,a,a) -> (b,b,b)
tupleMap f (a,b,c) = (f a, f b, f c)

myMax :: [Int] -> Int
myMax [] = 0
myMax list = maximum list

-- Real Code

sumCubesByColor :: String -> [(Int,String)] -> Int
sumCubesByColor color = sum . map fst . filter (\(_,col)->col == color)

checkPossibleSet :: [(Int,String)] -> Bool
checkPossibleSet set = sum_red <= 12 && sum_green <= 13 && sum_blue <= 14
    where 
        sum_red = sumCubesByColor "red" set
        sum_blue = sumCubesByColor "blue" set
        sum_green = sumCubesByColor "green" set

checkPossibleRound :: [[(Int,String)]] -> Bool
checkPossibleRound = all checkPossibleSet

checkPossibleGames :: [(Int,[[(Int,String)]])] -> Int
checkPossibleGames = sum . map fst . filter (\(_,set)->checkPossibleRound set)



collectMaxCubesPerSet :: [(Int,String)] -> (Int,Int,Int)
collectMaxCubesPerSet list = (numRedCubes,numBlueCubes,numGreenCubes)
    where
        numRedCubes = myMax $ map fst $ filter ((== "red") . snd) list
        numGreenCubes = myMax $ map fst $ filter ((== "green") .snd) list
        numBlueCubes = myMax $ map fst $ filter ((== "blue") . snd) list

collectMaxCubesPerGame :: [[(Int,String)]] -> (Int,Int,Int)
collectMaxCubesPerGame game = tupleMap myMax $ unzip3 $ map collectMaxCubesPerSet game

collectMaxCubes :: [[[(Int,String)]]] -> Int
collectMaxCubes = sum . map (multi . collectMaxCubesPerGame)
    where
        multi (a,b,c) = a*b*c

input_1 = do
    contents <- readFile "input_1.txt"

    let input_1 = map (splitOn ": ") (lines contents)

    let input_2 = map (\[game,sets] -> (
                            read (last $ splitOn " " game)::Int,
                            innerMap (\el->(read(head $ splitOn " " el)::Int,last $ splitOn " " el))
                                (map (splitOn ", ") $ splitOn "; " sets)
                            )
                    ) input_1
    
    print (checkPossibleGames input_2)
    print (collectMaxCubes $ map snd input_2)