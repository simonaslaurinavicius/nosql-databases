import re

from queries import (
    get_player,
    get_player_friends,
    get_player_ability_points,
    get_player_bought_abilities,
    get_player_unlocked_abilities,
    get_shortest_path_between_abilities,
)

MENU_MESSAGE = """
  Welcome to Thief game!

  Options:

    1 - Get player by name
    2 - Get player friends
    3 - Get player ability points
    4 - Get player bought abilities
    5 - Get player unlocked abilities
    6 - Get shortest path between abilities
    7 - Exit
"""

EXIT_COMMAND = "exit"

OPTIONS = {
    "1": get_player,
    "2": get_player_friends,
    "3": get_player_ability_points,
    "4": get_player_bought_abilities,
    "5": get_player_unlocked_abilities,
    "6": get_shortest_path_between_abilities,
    "7": EXIT_COMMAND,
}


def exit_program():
    print("Shutting down..")
    sleep(0.5)
    exit(0)


def show_menu():
    print(MENU_MESSAGE)

    option = ""
    option = input("Please choose an option number: ")
    while not re.match(r"^[1-7]$", option):
        option = input("Option range between 1 and 7, please choose an option: ")
    if OPTIONS[option] == EXIT_COMMAND:
        exit_program

    OPTIONS[option]()
