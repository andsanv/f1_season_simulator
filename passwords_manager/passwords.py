from os import system, name



# classes

class account:          # class containing account informations
    site = None
    username = None
    email = None
    password = None

    def __init__(self , s="", u="", e="", p=""):
        self.site = s
        self.username = u
        self.email = e
        self.password = p
        return
    
    def print_fast(self):           # 3 different printing modes (used for different reasons) 
        print(f'[{self.site}, {self.username}, {self.email}, {self.password}]')

    def print_elegant(self):
        if self.site != "": print(f"- site: {self.site}")
        if self.username != "": print(f"- username: {self.username}")
        if self.email != "": print(f"- email: {self.email}")
        if self.password != "": print(f"- password: {self.password}")

    def print_full(self):
        print(f"- site: {self.site}")
        print(f"- username: {self.username}")
        print(f"- email: {self.email}")
        print(f"- password: {self.password}")



# terminal input/output management

def clear():            # allows to clear the terminal
    system('cls' if name == 'nt' else 'clear')


def get_yes_no():           # function to manage user input when asked a (y/n) question
    helper = False
    
    while True:
        string = input().lower()
        if string == "y" or string == "n":
            return string
        else:
            if helper:
                print("\033[A\x1b[2K> ", end="")
            else:
                print("\033[A\x1b[2Kplease, enter either 'y' for 'yes' or 'n' for 'no'\n> ", end="")
                helper = True


def get_choice():           # used for main menu
    possible_choices = ("show", "search", "add", "edit", "delete", "save", "exit")
    already_done = False            # helps to format output (will be used more times in the program)
    
    while True:
        string = input().lower()
        if string in possible_choices:
            return string
        else:
            if already_done:
                print("\033[A\x1b[2K> ", end="")
            else:
                print("\033[A\x1b[2Kplease, enter one of the options above\n> ", end="")
                already_done = True


def wait():         # allows the user to read the output
    input("\npress enter to continue.\n")


def end(string):            # used for convenience (these 3 lines will be used a lot, as this is a terminal managed program)
    clear()
    print(string)
    wait()
    return



# small helper functions

def is_present(obj, list):          # checks if an item is present in the list
    for item in list:
        if obj.site == item.site and obj.username == item.username and obj.email == item.email:
            return True         # no "password" in the if condition as this program does not allow to save two accounts with the same site, user and email
        
    return False


def find_indexes(to_find, list):          # allows to find the index of all the occurrencies of {to_find} in the list
    indexes = []

    for index in range(0, len(list)):
        if to_find.lower() == list[index].site.lower():
            indexes.append(index)

    return indexes


def order_list(list):           # list sorter put in a different function for aestethic reasons
    list.sort(key=lambda x : (x.site, x.username, x.email))         # orders the list first by site, then by username and finally by email

    return list



# actual scripts

def open_menu():            # main menu
    clear()

    print("type:")
    print("- 'show' to visualize the saved accounts")
    print("- 'search' to search for an account")
    print("- 'add' to create an account")
    print("- 'edit' to modify an account")
    print("- 'delete' to remove an account")
    print("- 'save' to save changes to disk")
    print("- 'exit' to quit the prorgam")
    print("> ", end="")


def show_accounts(list):            # puts out the list of all the accounts saved
    clear()
    print("showing the accounts\n")

    if len(list) == 0:
        print("there is no account saved yet. enter an account using the 'add' operation in menu.")
    else:
        for account in list:
            account.print_fast()
    
    wait()
    return


def search_account(list):           # allows the user to search an account among all the saved ones
    clear()
    print("searching an account\n")

    if len(list) == 0:
        print("there is no account saved yet. enter an account using the 'add' operation in menu.")
    else:
        print("enter the site name of the account you want to find.\n> ", end="")
        already_done = False
        while True:
            to_search = input()
            if to_search == "quit":         # "quit" is an escape word the user can use whenever he/she wants
                end("operation cancelled.")
                return
            if to_search == "":         # in case user enters a void name
                if not already_done:
                    print("\033[A\x1b[2K\033[A\x1b[2Kenter the site name of the account you want to find (name must be at least 1 character).\n> ", end="")
                    already_done = True
                else:
                    print("\033[A\x1b[2K> ", end="")

            else:
                break

        indexes = find_indexes(to_search, list)
        
        if len(indexes) == 0:
            print("\nno accounts for the entered site name were found.")
        else:
            clear()
            if len(indexes) > 1:
                print("here are the accounts you were looking for:", end = "\n\n")
            else:
                print("here is the account you were looking for:", end="\n\n")
            for index in indexes:
                list[index].print_fast()
    
    wait()


def add_account(list, d):       # creates an account and adds it to the list
    temp = account()
    dirty = d
    
    clear()
    print("creating new account\n")
    print("enter your credentials (enter 'quit' at any time to exit the current process or press enter for blank)")
    
    print("site: ", end="")         # gets account site name
    while True:
        temp.site = input()
        if temp.site == "quit":         # "quit" is an escape word the user can use whenever he/she wants
            end("operation cancelled.")
            return
        if len(temp.site) == 0:         # in case user enters a void name
            print("\033[A\x1b[2Ksite (length must be at least 1 character): ", end="")      # those characters are for output formatting
        else:
            break
    
    already_done = False                  # gets user and email associated to the account
    while True:                     
        if not already_done:
            print("username: ", end="")
        temp.username = input()
        if(temp.username == "quit"):
            end("operation cancelled.")
            return
        
        print("email: ", end="")
        temp.email = input()
        if(temp.email == "quit"):
            end("operation cancelled.")
            return
        
        if len(temp.username) == 0 and len(temp.email) == 0:       # program does not allow to have both username and email as empty strings
            print("\033[A\x1b[2K\033[A\x1b[2Kusername (at least one between username and email needed): ", end="")
            already_done = True
        else:
            break
    
    if is_present(temp, list):       # checks if that profile already exists
        end("this account already exists. use the 'show' option to check your account.")     
    else:
        print("password: ", end="")         # gets account password
        while True:
            temp.password = input()
            if temp.password == "quit":
                end("operation cancelled.")
                return
            if len(temp.password) == 0:
                print("\033[A\x1b[2Kpassword (length must be at least 1 character): ", end="")
            else:
                break

        clear()
        print(f"here's your '{temp.site}' account: ", end="\n\n")
        temp.print_elegant()
        print("\ndo you want to save it? (y/n)\n> ", end="")            # double checks user's will
        answer = get_yes_no()

        if answer == "y":           # if user confirms, account is added to the list, and the list is sorted
            list.append(temp)
            order_list(list)

            dirty = True
            end("data saved.")
        else:
            end("data not saved.")
    
    return dirty


def edit_account(list, d):         # function that allows to edit an already-existing account
    possible_choices = ("site", "username", "email", "password")            # possible parameters of an account that can be modified (used later)
    dirty = d
    temp = account()

    clear()
    print("editing an account.", end="\n\n")
    
    try:
        indexes, choice = get_account(list, "edit")           # finds the account the user wants to edit
    except TypeError:           # case where get_account() functions returns nothing as there are no accounts saved/found
        return False

    temp.site = list[indexes[choice]].site          # copying selected account in case user decides to cancel editing
    temp.username = list[indexes[choice]].username
    temp.email = list[indexes[choice]].email
    temp.password = list[indexes[choice]].password
    
    clear()
    print("here is the account you were looking for:", end="\n\n")
    list[indexes[choice]].print_full()

    print("\nenter the parameters (site, username, email, password) you want to change, separated by space\n> ", end="")
    already_done = False
    while True:         # this whole section is to manage user input to gain infos on which parameters of the account the user wants to edit
        choices = input()

        if choices == "quit":
            end("operation cancelled.")
            return False
        
        choices = choices.split(sep=" ")            # user will enter a string of words divided by spaces, we want to divide it into single words
        valid_parameters = True         # used to know whether user entered wrong parameters
        
        for parameter in choices:
            if parameter not in possible_choices and valid_parameters:          # checks every parameter entered by user
                if not already_done:
                    print("\033[A\x1b[2Kinvalid parameter: please enter one or more of the parameters above\n> ", end="")
                    already_done = True
                else:
                    print("\033[A\x1b[2K\033[A\x1b[2Kinvalid parameter: please enter one or more of the parameters above\n> ", end="")
                valid_parameters = False
        
        if valid_parameters:
            break
    
    clear()         
    if "site" in choices:   # gets account new site name if site was in the parameters specified by user
        print("new site: ", end="")         
        while True:
            site = input()
            if temp.site == "quit":
                end("operation cancelled.")
                return False
            if len(temp.site) == 0:
                print("\033[A\x1b[2Knew site (length must be at least 1 character): ", end="")          # again, for output formatting reasons
            else:
                break

    while True:         # again, the program does not allow to have an account with no user and email (since it's not possible in real life)
        if "username" in choices:           # gets new user and/or new email if specified by user
            print("new username: ", end="")
            temp.username = input()
            if(temp.username == "quit"):
                end("operation cancelled.")
                return False
        
        if "email" in choices:
            print("new email: ", end="")
            temp.email = input()
            if(temp.email == "quit"):
                end("operation cancelled.")
                return False
        
        if len(temp.username) == 0 and len(temp.email) == 0:       # checks if user entered both username and email as empty strings
            clear()
            print("at least one between username and email needed to create the account.")          # !!
        else:
            break
    
    if "password" in choices:           # gets new account password if specified by user
        print("new password: ", end="")         
        while True:
            temp.password = input()
            if temp.password == "quit":
                end("operation cancelled.")
                return False
            if len(temp.password) == 0:
                print("\033[A\x1b[2Knew password (length must be at least 1 character): ", end="")
            else:
                break
    
    clear()
    print("updated account:")
    temp.print_full()
    print("\nsave the edited account? (y/n)\n> ", end="")           # checks if user actually wants to do it
    answer = get_yes_no()
    if answer == "y":
        list[indexes[choice]] = temp
        dirty = True       # we want to remember if something in the list of accounts has changed, so we will ask the user to save data when exiting the program
        order_list(list)           # reorders the list as something might have changed
        end("data saved.")
    else:
        end("data not saved.")

    
    return dirty


def delete_account(list, d):           # function that allows the user to delete an accountclear()
    dirty = d

    clear()
    print("deleting an account.", end="\n\n")

    try:
        indexes, choice = get_account(list, "delete")         # same as the edit_account() function, gets the account the user wants to delete
    except TypeError:       # case where get_account() functions returns nothing as there are no accounts saved/found
        return False

    print("here is the account you were looking for:", end="\n\n")
    list[indexes[choice]].print_full()         # prints the account

    print("\nare you sure you want to delete the account? (y/n)\n> ", end="")           # double checks the user's will
    answer = get_yes_no()
    if answer == "y":       # no need to order the list as deletion does not change alphabetically any account
        del(list[indexes[choice]])
        
        dirty = True            # dirty notification as one account was deleted
        end("account deleted.")
    else:
        end("account not deleted.")
    
    return dirty
    


def get_account(list, mode):          # helper function for edit and delete modes. briefly, this code was shared between the two, so it's better to optimize and unify
    if len(list) == 0:         # empty list means no account stored, so does not make any sense to search for one account
        print("there is no account saved yet. enter an account using the 'add' operation in menu.")
        wait()
        return
    
    print("enter the site name of the account you want to ", end="")            
    print("edit." if mode == "edit" else "delete.", end="\n> ")         # as the code is shared between delete and edit mode, this will be encountered many times

    while True:         # gets the site of the account the user wants to find
        to_find = input()
        if to_find == "quit":
            end("operation cancelled.")
            return
        if to_find == "":
            print("\033[A\x1b[2Ksite (length must be at least 1 character): ", end="")
        else:
            break
    
    indexes = find_indexes(to_find, list)         # gets the indexes of the occurrencies in the list

    if len(indexes) == 0:           # case where no account was found with the entered-by-user site name
        print("\nno accounts for the entered site name were found.")
        wait()
        return
    elif len(indexes) == 1:         # case where only one account was found
        choice = 1          # choice put to 1 for optimization reasons (only one return statement needed)
    else:           # case where there are more accounts for the same site
        clear()
        print("multiple accounts were found.", end="\n\n")          # lists the account found
        for i in range(0, len(indexes)):
            print(f"{i + 1} - ", end="")
            list[indexes[i]].print_fast()

        print("\nenter the number (the one on the left) of the account you want to ", end="")
        print("edit." if mode == "edit" else "delete.", end="\n> ")

        already_done = False
        while True:
            choice = input()        # as the program lists the account and asks the user to choose, this is the way he/she tells the program which he/she wants
            if choice == "quit":
                end("operation cancelled.")
                return
            else:
                try:            # asks the user for an integer, that will be used as index for the "indexes" list
                    choice = int(choice)
                except ValueError:
                    if not already_done:
                        print("\033[A\x1b[2Kinput must be an integer", end="\n> ")
                        already_done = True
                    else:
                        print("\033[A\x1b[2K\033[A\x1b[2Kinput must be an integer", end="\n> ")
                else:
                    if choice < 1 or choice > len(indexes):
                        if not already_done:
                            print(f"\033[A\x1b[2Kinput must be a number between 1 and {len(indexes)}.", end="\n> ")
                            already_done = True
                        else:
                            print(f"\033[A\x1b[2K\033[A\x1b[2Kinput must be a number between 1 and {len(indexes)}.", end="\n> ")
                    else:
                        break
    
    clear()
    return (indexes, choice - 1)            # returns the indexes list and the choice made by user



def initialize(list):         # series of statements to load from disk the saved accounts
    clear()
    print("initialization.\n\nlooking for backup files...")
    try:
        fd = open("backup.txt", 'r')            # checks if the save file is already there
    except FileNotFoundError:
        print("no backup file found. creating new file...")         # if it's not, it creates one
        fd = open("backup.txt", "w")
        print("new backup file succesfully created. ", end="\n")
        fd.close()
    else:
        print("backup file found. ", end="\n\n")            # if it is, it starts "pulling" the accounts
        print("gaining data...")
        fd = open("backup.txt", 'r')
        while True:
            line_read = fd.readline()           # reads one line per time
            line_read = line_read.strip('\n')           # deletes the newline characters

            if line_read == '':             # EOF in python
                break
            else:
                words = line_read.split(sep=",")            # on disk, accounts are saved in csv    
                list.append(account(words[0], words[1], words[2], words[3]))           # transferring data from disk to list

        fd.close()
        print("data reading finished.")
    finally:
        wait()


def save_to_disk(list):         # function to save data on disk, so that we can store accounts between one session and another
    fd = open("backup.txt",'w')         # if opened in write, a non-existing file will be created. so no exception handling needed

    for acc in list:           # writes on disk in csv
        fd.write(','.join([acc.site, acc.username, acc.email, acc.password]))
        fd.write('\n')
    
    fd.close()
    dirty = False           # as we "pushed" all the updates on disk, structures in memory are no more dirty as they correspond to the ones on disk
    return dirty