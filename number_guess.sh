#!/bin/bash
PSQL="psql -X -U freecodecamp -d number_guess"


echo -e "Enter your username:"
read username
rand=$RANDOM % 1000
# if not exist
# create user in database with 0 games played and
# echo Welcome, <username>! It looks like this is your first time here.

# else
# query database to get games played and best_game
# echo Welcome back, <username>! You have played <games_played> games, and your best game took <best_game> guesses.

# create game with 0 tries

# echo Guess the secret number between 1 and 1000:
# read guess variable
# if guess is not number
# echo That is not an integer, guess again:
# goto GAME
# else 
    # if guess != rand
        # if > rand
        # echo It's lower than that, guess again:
        # tries += 1
        # goto GAME
        # else
        # echo It's higher than that, guess again:
        # tries += 1
        # goto GAME
    # else
    # echo You guessed it in <number_of_guesses> tries. The secret number was <secret_number>. Nice job!
