from math import sqrt
from time import sleep
from os import system, name
from enum import Enum



class Operators(Enum):          # used to simplify later operations
    sqrt = 0
    exp = 1
    div = 2
    mul = 3
    sum = 4
    sub = 5

def clear():            # allows to clear the terminal
    system('cls' if name == 'nt' else 'clear')

def wait():
    input("\npress enter to continue. ")

def end(string):         # used for convenience (these 3 lines will be used a lot, as this is a terminal managed program)
    clear()
    print(string)
    wait()
    return



def check_syntax(expression):           # initially thought to be a more complex function, it only checks parenthesys 
    def check_parenthesys(expression):
        count = 0
    
        for char in expression:         # uses a counter. whenever it goes below zero, an error occurs
            if char == '(':
                count += 1
            elif char == ')':
                count -= 1
            if count < 0:
                return False
        
        return count == 0

    return check_parenthesys(expression)
    


def get_indexes(list, c):       # returns a list of indexes
    indexes = []

    for i in range(len(list)):
        if list[i] == c:
            indexes.append(i)
    
    return indexes



def get_ops_indexes(expression):  # returns a multidimensional list that contains the inedexes of the list that contain operators
    ops_dict = {
        'v': get_indexes(expression, 'v'), '^': get_indexes(expression, '^'),
        '/': get_indexes(expression, '/'), '*': get_indexes(expression, '*'),
        '+': get_indexes(expression, '+'), '-': get_indexes(expression, '-'),
    }

    indexes = []
    for item, val in ops_dict.items():
        try:
            expression.index(item)
            indexes.append(val)
        except ValueError:
            indexes.append([])

    return indexes



def find_precedences(string):       # returns the index of the list of the operator that has highest precedence
    try:
        string.index('(')
    except ValueError:          # no parenthesis in the expression inputted by the user
        indexes = get_ops_indexes(string)

        for i in range(len(indexes)):
            if i != Operators.div.value and i != Operators.mul.value and len(indexes[i]):
                return indexes[i][0]
            elif i == Operators.div.value or i == Operators.mul.value:
                if len(indexes[Operators.div.value]) and len(indexes[Operators.mul.value]):
                    return min(indexes[Operators.div.value][0], indexes[Operators.mul.value][0])
                if len(indexes[Operators.div.value]) and not len(indexes[Operators.mul.value]):
                    return indexes[Operators.div.value][0]
                if not len(indexes[Operators.div.value]) and len(indexes[Operators.mul.value]):
                    return indexes[Operators.mul.value][0]
    else:           # expression includes parenthesis
        open_brackets_indexes = get_indexes(string, '(')    # list containing indexes where open brackets can be found
        closed_brackets_indexes = get_indexes(string, ')')      # same, but with closed brackets
        length_open = len(open_brackets_indexes)

        right = closed_brackets_indexes[0]      # right and left used to identify the length of the inside-brackets expression

        if length_open == 1:
            left = open_brackets_indexes[0]
        else:
            for i in range(length_open):
                if i == length_open - 1:
                    left = open_brackets_indexes[i]
                    break
                elif open_brackets_indexes[i] > right:
                    left = open_brackets_indexes[i - 1]
                    break

        for char in "v^*/+-":   # returns the highets precedence operator in the "substring" obtained
            try:
                pos = left + string[left:right + 1].index(char)
                return pos
            except ValueError:
                if char == '-':
                    return -1



def solve_op(string, pos):  # solves operation a given operation
    match string[pos]:
        case '+':
            return float(string[pos - 1]) + float(string[pos + 1])
        case '-':
            return float(string[pos - 1]) - float(string[pos + 1])
        case '*':
            return float(string[pos - 1]) * float(string[pos + 1])
        case '/':
            try:
                return float(string[pos - 1]) / float(string[pos + 1])
            except ZeroDivisionError:
                end("error: division by zero.")
                exit()
        case '^':
            return float(string[pos - 1]) ** float(string[pos + 1])


def sqrt_to_exp(list):      # transforms square roots into exponentials (simplification)
    while 'v' in list:      # at the beginning, every "sqrt" in the list is translated in 'v'
        for i in range(len(list)):
            element = []
            if list[i] == 'v':
                sublist = list[i + 1:]
                p = 0
                counter = 0
                if sublist[0] == '(':
                    for j in range(len(sublist)):
                        if sublist[j] == '(':
                            p += 1
                        elif sublist[j] == ')':
                            p -= 1
                        
                        element.append(sublist[j]) 
                        counter += 1

                        if not p:
                            break
                else:
                    element.append(sublist[0])
                    counter = 1
                list = list[:i] + element + ['^', 0.5] + list[i + counter + 1:]
    return list


def build_list(user_input):     # gets the user input and casts it into a list, removing unsupported characters
    symbols = "()+-*/^v"
    digits = "0123456789"
    expression = []
    
    user_input = user_input.replace("sqrt", 'v')
    
    i = 0
    while i < len(user_input):
        if user_input[i] in symbols:
            expression.append(user_input[i])
            i += 1
        elif user_input[i] in digits:
            counter = 0
            j = i
            while True:
                if j >= len(user_input):
                    break

                if user_input[j] in digits:
                    counter += 1
                    j += 1
                else:
                    break
                

            number = 0
            while counter > 0:
                number += int(user_input[i]) * (10 ** (counter - 1))
                i += 1
                counter -= 1
            
            expression.append(number)
        elif user_input[i] == ' ':
            i += 1
        else:
            end("error: invalid syntax.")
            return [-1]
    
    expression = sqrt_to_exp(expression)

    return expression

def substitute(list, val, pos):     # gets the result of the single operation and substitutes it into the original list
    symbols = "()+-*/^v"

    left = 0
    if pos > 0:
        for i in reversed(range(0, pos - 1)):
            if i == 0 or str(list[i]) in "()":
                left = i
                break
            elif str(list[i]) in "+-*/^v":
                left = i + 1
                break

    for i in range(pos + 1, len(list)):
        if i == len(list) - 1 or str(list[i] )in "()":
            right = i
            break
        elif str(list[i]) in "+-*/^v":
            right = i - 1
            break

    if list[left] == '(' and list[right] != ')':
        left += 1
    if list[left] != '(' and list[right] == ')':
        right -= 1
    
    return list[0:left] + [val] + list[right + 1:]


def operator_in_string(list):  # checks whether there are still operations in the list
    for op in "+-*/v^":
        try:
            list.index(op)
        except ValueError:
            pass
        else:
            return True

    return False




def main():
    while True:
        clear()
        # gains user input
        user_input = input("expression = ")

        # removes all not-supported characters and returns error if syntax is not good
        expression = build_list(user_input)
        if expression == [-1]:
            clear()
            return

        # checks the syntax of the inputted expression
        if not check_syntax(expression):
            end("error: invalid syntax.")
            clear()
            return

        # solves one operation every iteration and substitues the result in the original expression
        while operator_in_string(expression):
            pos = find_precedences(expression)          # finds the position of the operation with highest precedence
            if pos != -1:           # pos == -1 if and only if there is no more operators in the expression 
                expression = substitute(expression, solve_op(expression, pos), pos)

        print(f"result = {round(expression[0], 2)}")
        wait()



main()

