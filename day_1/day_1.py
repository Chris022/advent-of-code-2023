
def get_calibration_value(line: str) -> int:

    digits = list(filter(lambda char: char.isdigit(),line))

    first_digit = digits[0]
    last_digit = digits[-1]

    return int(first_digit + last_digit)

def get_calibration_value_v2(line: str) -> int:
    numbers = ["one","two","three","four","five","six","seven","eight","nine"]

    digits = []

    for index,letter in enumerate(line):
        if letter.isdigit():
            digits.append(letter)
            continue
        
        for digit,txt_digit in enumerate(numbers):
            if len(line)-index < len(txt_digit):
                continue
            if line[index:index+len(txt_digit)] == txt_digit:
                digits.append(str(digit+1))
                break
    first_digit = digits[0]
    last_digit = digits[-1]

    return int(first_digit + last_digit)

def get_calibration_values(input: str) -> int:
    lines = input.split("\n")

    # part 1
    # values = map(lambda line: get_calibration_value(line),lines)

    # part 2
    values = map(lambda line: get_calibration_value_v2(line),lines)

    return sum(values)



# part 1

input_file = open("input_1.txt","r")
input_text = input_file.read()

print(f"Output of 1: {get_calibration_values(input_text)}")

# part 2