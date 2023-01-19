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
eval_hand() {
	declare -i value
	declare -i card_value
	local -n hand=$1
	values_only=()
	value=0
	for card in "${hand[@]}";
	do
		cutat="_of_"
		val=${card%%${cutat}*}
		values_only+=("$val")
		card_value=${string_to_value[$val]}
		value+=$card_value
	done

    	if [ $value -gt 21 ] && [[ " ${values_only[*]} " == *"ace"* ]]; then
		value=$value-9
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

check_if_bust() {
	declare -i score=$1
	oppo=$2
	if [ $score -gt 21 ];
	then
	    printf "\n \n WENT BUST WITH SCORE $score. $oppo wins \n \n"
	    exit 0
	fi
}



final_winner() {
	declare -i dealer_score=$1
	declare -i player_score=$2

	if [ "$dealer_score" -gt "$player_score" ] && [ "$dealer_score" -le 21 ]; then
		printf "\n \n dealer won! better luck next time \n \n"
	elif [ $player_score -gt $dealer_score ] && [ "$player_score" -le 21 ]; then
		printf "\n \n you won! omg well done <3 <3 \n \n"
	else
		printf "wtf \n"


	fi

}




round() {
	#shuffle deck
	shuffled_deck=( $(shuf -e "${deck[@]}") )



	#init hands
	stand=false
	dealers_hand=()
	players_hand=()
	draw_card shuffled_deck dealer_card_1 dealer_card_2
	#shuffle deck
	shuffled_deck=( $(shuf -e "${deck[@]}") )
	draw_card shuffled_deck player_card_1 player_card_2
	dealers_hand+=("$dealer_card_1")
	dealers_hand+=("$dealer_card_2")
	players_hand+=("$player_card_1")
	players_hand+=("$player_card_2")
	while ! $stand; do
	#display dealers first card and players hand, option to hit or stand if not blackjack
	printf " \n \ndealers face up card is ${dealers_hand[1]} \n"
	printf "your cards are ${players_hand[*]} \n \n"
	# check blackjack
	read -p "do you want to (h)it or (s)tay? : " response
	case $response in
	    H* | h* )
		    printf "\n dealer is drawing you another card... \n"
		    sleep 1
		    #shuffle deck
		    shuffled_deck=( $(shuf -e "${deck[@]}") )
		    draw_card shuffled_deck new_card
		    echo "you are given $new_card"
		    players_hand+=("$new_card")
		    #check for bust
		    player_eval=$(eval_hand players_hand)
		    check_if_bust player_eval "dealer"
		    ;;
	    S* | s*) printf "\n dealer's turn! \n"
		    sleep 1
		    stand=true
			;;
	     *) printf "\n Please type in h or s <3" ;;
	esac

	done
	echo "dealers hand is ${dealers_hand[*]}"
	dealer_eval=$(eval_hand dealers_hand)
	while [ "$dealer_eval" -le 17 ]; do
		#shuffle deck
		shuffled_deck=( $(shuf -e "${deck[@]}") )
		draw_card shuffled_deck new_dealer_card
		echo "dealer drew $new_dealer_card"
		dealers_hand+=("$new_dealer_card")
		dealer_eval=$(eval_hand dealers_hand)
		check_if_bust dealers_eval "player"
	done
	sleep 1
	echo "dealers score is now $(eval_hand dealers_hand)"


	player_scr=$(eval_hand players_hand)
	dealer_scr=$(eval_hand dealers_hand)
	echo "player score is $player_scr and dealer score is $dealer_scr"
	final_winner $dealer_scr $player_scr
	echo "Round finished"
	exit 0


}
round;
