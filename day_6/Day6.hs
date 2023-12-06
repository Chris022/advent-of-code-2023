import Data.List.Split (splitOn)
import Data.Char (isSpace)

strip :: String -> String
strip = filter (not . isSpace)

type Distance = Int
type Velocity = Int
type Time = Int

type Race = (Time,Distance)

calcTravelDistance:: Time -> Time -> Distance
calcTravelDistance buttonDuration raceDuration = travelDuration * buttonDuration
    where
        travelDuration = raceDuration - buttonDuration

getWinningButtonPressTimes:: Distance -> Time -> [Time]
getWinningButtonPressTimes recordDistance raceDuration = filter ((>recordDistance) . travelDistanceF) [1..raceDuration]
    where
        travelDistanceF buttonPressDuration = calcTravelDistance buttonPressDuration raceDuration

getNumberOfWinningButtonPressTimes:: Time -> Distance -> Int
getNumberOfWinningButtonPressTimes raceDuration recordDistance = length $ getWinningButtonPressTimes recordDistance raceDuration 

multiplyWinningButtonPressTimes:: [Race] -> Int
multiplyWinningButtonPressTimes races = product $ map (uncurry $ getNumberOfWinningButtonPressTimes) races

parseRaces:: String -> String -> [Race]
parseRaces timeLine distanceLine = zip (map read timeList) (map read distanceList)
    where
        timeList = filter (not . null) $ splitOn " " $ last $ splitOn ": " timeLine
        distanceList = filter (not . null) $ splitOn " " $ last $ splitOn ": " distanceLine

parseRace:: String -> String -> Race
parseRace timeLine distanceLine = (timeList, distanceList)
    where
        timeList = read $ strip $ last $ splitOn ": " timeLine
        distanceList = read $ strip $ last $ splitOn ": " distanceLine

exerciseA = do
    contents <- readFile "input_test.txt"
    let line1 = head $ lines contents
    let line2 = last $ lines contents
    let parsed_input = parseRaces line1 line2

    print $ multiplyWinningButtonPressTimes parsed_input

    let parsed_input = parseRace line1 line2
    let (time,dist) = parsed_input

    print $ getNumberOfWinningButtonPressTimes time dist