#!/bin/bash

# establish PSQL value
PSQL="psql -X -A -U freecodecamp -d number_guess --tuples-only -c"

# prompt for username
echo -e "\nEnter your username:"
read USERNAME

#Check if username exists in db
USER_SELECTION_RESULT=$($PSQL "select username from users where username='$USERNAME';")
# if user doesn't exist
if [[ -z $USER_SELECTION_RESULT ]]
    then
        echo "Welcome, $USERNAME! It looks like this is your first time here."
        # insert user into table
        USER_INSERTION_RESULT=$($PSQL "insert into users(username) values('$USERNAME');")
    else
        #if does exist
        #query games_played
        GAMES_PLAYED=$($PSQL "select count(game_id) from games join users using(user_id) where username='$USERNAME';")
        #query best_game
        BEST_GAME=$($PSQL "select min(tries_num) from games join users using(user_id) where username='$USERNAME';")
        echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

#start the game
TRIES=0
SECRET=$(($RANDOM % 1000 + 1))
echo -e Guess the secret number between 1 and 1000:
read GUESS

until [[ $GUESS == $SECRET ]]
do

    #if GUESS is not number
    if [[ ! $GUESS =~ ^[0-9]+$ ]]
        then
            echo -e "\nThat is not an integer, guess again:"
            read GUESS
            # increment tries
            ((TRIES++))
        
        # if it's a number
        else
            if (( GUESS < SECRET ))
                then
                    echo "It's higher than that, guess again:"
                    read GUESS
                    ((TRIES++))
                else
                    echo "It's lower than that, guess again:"
                    read GUESS
                    ((TRIES++))
            fi
    fi
done

((TRIES++))

USER_ID=$($PSQL "select user_id from users where username='$USERNAME'")
RESULT=$($PSQL "insert into games(tries_num, user_id) values($TRIES, $USER_ID)")

echo "You guessed it in $TRIES tries. The secret number was $SECRET. Nice job!"