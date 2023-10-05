#!/bin/bash
PSQL="psql -X -A -U freecodecamp -d number_guess --tuples-only -c"


echo -e "Enter your username:"
read username
rand=$(($RANDOM % 1000))
# if not exist
SEL_USER=$($PSQL "select * from users where username='$username';")
if [[ -z $SEL_USER ]]
# create user in database with 0 games played and
then
    CREATE_USER=$($PSQL "insert into users(username) values('$username');")
    if [[ $CREATE_USER = "INSERT 0 1" ]]
    then echo "Welcome, $username! It looks like this is your first time here."
    fi
else
    # query database to get games played and best_game
    games=$($PSQL "select games_num from users where username='$username';")
    best=$($PSQL "select min(tries_num) from games join users\
    using(user_id) where username='$username';")
    echo "Welcome back, $username! You have played $games games, and your best game took $best guesses."
fi
user_id=$($PSQL "select user_id from users where username='$username';")
# create game with 0 tries
CREATE_GAME=$($PSQL "insert into games(tries_num, user_id) values(0, $user_id);")
INCR_GAME=$($PSQL "update users set games_num = games_num + 1 where user_id=$user_id;")
CURR_GAME_ID=$($PSQL "select max(game_id) from games;")

echo "Guess the secret number between 1 and 1000:"
GAME() {
    if [[ $1 ]]
    then echo $1
    fi
    read guess

    # if guess is not number
    re='^[0-9]+$'
    if ! [[ $guess =~ $re ]]
    then
    GAME "That is not an integer, guess again:"
    else 
        if [[ $guess != $rand ]]
        then
        #tries +1
            INCREMENT=$($PSQL "update games set tries_num = tries_num + 1 where game_id = $CURR_GAME_ID")
                if [[ $guess > $rand ]]
                then
                    GAME "It's lower than that, guess again:"
                else
                GAME "It's higher than that, guess again:"
                fi
        else
        tries=$($PSQL "select tries_num from games where game_id = $CURR_GAME_ID;")
        echo "You guessed it in $tries tries. The secret number was $rand. Nice job!"
        fi
    fi
}

GAME