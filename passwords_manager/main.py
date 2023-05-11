from passwords import *


accounts_list = []          # list of accounts that will be used to store saved accounts
dirty = False           # will be used for saving reasons



def main():
    global accounts_list
    global dirty

    initialize(accounts_list)          # to manage saved data

    while True:         # main loop for menu
        open_menu()
        choice = get_choice()           # asks for user to choose what to do

        match choice:
            case "show":
                show_accounts(accounts_list)
            case "search":
                search_account(accounts_list)
            case "add":
                dirty = add_account(accounts_list, dirty)
            case "edit":
                dirty = edit_account(accounts_list, dirty)
            case "delete":
                dirty = delete_account(accounts_list, dirty)
            case "save":
                if not dirty:           # no need to enter the saving procedure if not dirty
                    end("no data to save to disk.")
                else:
                    dirty = save_to_disk(accounts_list)          # saves to disk
                    end("data saved to disk.")
            case "exit":
                clear()
                if dirty:
                    print("save the changes? (y/n)", end="\n> ")            # double checks for user's will
                    answer = get_yes_no()

                    if answer == "y":
                        dirty = save_to_disk(accounts_list)
                        end("changes saved.")
                    else:
                        end("changes not saved.")
                clear()
                break


main()