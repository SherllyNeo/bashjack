#!/bin/bash

declare -A string_to_value=( [ace]=10 [2]=2 [3]=3 [4]=4 [5]=5 [6]=6 [7]=7 [8]=8 [9]=9 [10]=10 [king]=10 [queen]=10 [jack]=10)

draw_card() {
    declare -n _array=$1
    shift
    declare _n=0
    for _v ; do
        declare -n _var=$_v
        let ++_n
        _var=${_array[-_n]}
    done
    array=("${_array[@]:0:$((${#_array[@]}-_n))}")
}
evaluate_hand() {
	declare -i value
	declare -i card_value
	local -n hand=$1
	values_only=()
	value=0
	for card in "${hand[@]}";
	do
		echo "$card"
		cutat="_of_"
		val=${card%%${cutat}*}
		values_only+=("$val")
		card_value=${string_to_value[$val]}
		value+=$card_value
	done
	echo "${values_only[*]}"
	if [ "$value" -gt 21 ] && [ ];
then
		value=$(($value-9))
	fi
	echo $value
}





#make deck in order
deck=()

suits=( 'hearts' 'diamonds' 'spades' 'clubs' )
values=( 'ace' '2' '3' '4' '5' '6' '7' '8' '9' '10' 'jack' 'king' 'queen' )

for suit in "${suits[@]}";
do
	for value in "${values[@]}";
	do
		deck+=("${value}_of_$suit")
	done

done





#round() {
#	#shuffle deck
#	shuffled_deck=( $(shuf -e "${deck[@]}") )
#
#
#
#	#init hands
#	stand=false
#	dealers_hand=()
#	players_hand=()
#	while ! $stand; do
#	#display dealers first card and players hand, option to hit or stand if not blackjack
#
#	#if player stands - we move
#
#	#if player hits, deal, chck for blackjack / bust
#	#then keep going if those didn't happen
#
#
#	done
#	#after player stands, we go here.
#	#shows all cards and reveal dealers card
#	#then while dealers hand is below 17 they will hit
#	#once dealers hand is > 17, we calculate the value of both hands and then say who won
#
#}



























#start round

#deal two dealer cards. Hide one.


#Deal two cards to player - check if blackjack - check if dealer has blackjack

#ask hit or stay

#deal one card

#if stay, show dealer face down card

#keep going and check who won



shuffled_deck=( $(shuf -e "${deck[@]}") )
echo "original shuffled deck is ${shuffled_deck[*]}  \n \n"
dealers_hand=()
draw_card shuffled_deck card1 card2 card3
dealers_hand+=("$card1")
dealers_hand+=("$card2")
dealers_hand+=("$card3")
echo "${dealers_hand[*]}"
dealers_hand_value=$(evaluate_hand dealers_hand)
echo "dealers hand value is $dealers_hand_value"
