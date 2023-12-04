
def is_symbol(sym: str)-> bool:
    return not sym.isdigit() and not sym == "."

def is_gear_symbol(sym: str) -> bool:
    return sym == "*"

def check_adjacent(board: [[str]],checker, y: int, x: int) -> bool:
    """
    This function checks if there is a symbol adjacent e.g.:
    for the 1 it checks the fields with the X
    XXX
    X1X
    XXX
    """
    def check_adjacent_x(y:int, x: int) -> bool:
        if(x) > 1:
            if checker(board[y][x-1]): return True
        if checker(board[y][x]): return True
        if(x) < len(board[0])-1:
            if checker(board[y][x+1]): return True
        return False

    if(y > 1):
        if check_adjacent_x(y-1,x): return True
    if check_adjacent_x(y,x): return True
    if(y < len(board)-1):
        if check_adjacent_x(y+1,x): return True

def find_adjacent(board: [[str]], y: int, x: int) -> int:

    ratios = []

    def row(y: int):
        found = False
        num_per_row = "0"
        for x_i in range(0,len(board[y])):
            
            if board[y][x_i].isdigit():
                num_per_row += (board[y][x_i])
                if x-1 <= x_i <= x+1:
                    found = True
            else:
                if found:
                    ratios.append(int(num_per_row))
                    found = False
                num_per_row = "0"
        else:
            if found:
                ratios.append(int(num_per_row))


    # for line before
    if y >= 1:
        row(y-1)
    row(y)
    if y <= len(board):
        row(y+1)
    
    if len(ratios) == 2:
        return ratios[0]*ratios[1]
    return 0
    

    

# start by reading the input
input_file = open("input_1.txt","r")
input_text = input_file.read()

# split input into rows and columns
board = list(
    map(lambda row: list(row), input_text.split("\n"))
)

count = 0

for in_row,row in enumerate(board):
    found = False
    num_str = "0"
    for in_col,col in enumerate(row):
        if not board[in_row][in_col].isdigit():
            if found:
                count += int(num_str)
            found = False
            num_str = "0"
            continue
        else:
            num_str = num_str + board[in_row][in_col]
            if found:
                continue
            if check_adjacent(board, is_symbol, in_row, in_col):
                found = True
    else:
        if found:
            count += int(num_str)

print(f"Part 1: {count}")

gear_sum = 0
for in_row,row in enumerate(board):
    for in_col,col in enumerate(row):
        if is_gear_symbol(board[in_row][in_col]):
            gear_sum += find_adjacent(board,in_row,in_col)

print(f"Part 2: {gear_sum}")