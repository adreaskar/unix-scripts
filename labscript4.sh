#!/bin/bash

# Ελέγχουμε εάν ο χρήστης δεν έχει δώσει όρισμα
if [ $# -eq 0 ]; then
    echo "Παρακαλώ δώστε έναν δεκαδικό αριθμό ή έναν ρωμαϊκό αριθμό ως όρισμα."
    exit 1
fi

# Συνάρτηση για μετατροπή δεκαδικού σε ρωμαϊκό
function decimal_to_roman {
    local num=$1
    local roman=""
    local decimals=(1000 900 500 400 100 90 50 40 10 9 5 4 1)
    local romans=("M" "CM" "D" "CD" "C" "XC" "L" "XL" "X" "IX" "V" "IV" "I")

    for (( i=0; i<${#decimals[@]}; i++ )); do
        while (( num >= decimals[i] )); do
            roman+=${romans[i]}
            num=$((num - decimals[i]))
        done
    done

    echo $roman
}

# Συνάρτηση για μετατροπή ρωμαϊκού σε δεκαδικό
function roman_to_decimal {

    declare -A roman_numerals=( ["I"]=1 ["V"]=5 ["X"]=10 ["L"]=50 ["C"]=100 ["D"]=500 ["M"]=1000 )

    local roman=$1
    local decimal_number=0
    local previous_value=0

    # Διατρέχει τους χαρακτήρες του ρωμαϊκού αριθμού ανάποδα
    for (( i=${#roman}-1; i>=0; i-- )); do
        local current_digit=${roman:i:1}
        local current_value=${roman_numerals[$current_digit]}

        # Ελέγχει αν το τρέχον ψηφίο είναι μικρότερο του προηγούμενου
        if (( current_value < previous_value )); then
            decimal_number=$(( decimal_number - current_value ))
        else
            decimal_number=$(( decimal_number + current_value ))
            previous_value=$current_value
        fi
    done

    echo "$decimal_number"
}

# Ελέγχουμε εάν το όρισμα είναι δεκαδικό ή ρωμαϊκό
# και εκτελούμε την αντίστοιχη μετατροπή
input=$1

# Εάν το όρισμα είναι αριθμητικό, το μετατρέπουμε σε ρωμαϊκό
if [[ $input =~ ^[0-9]+$ ]]; then
    roman=$(decimal_to_roman $input)
    echo "Ο ρωμαϊκός αριθμός για τον αριθμό $input είναι: $roman"
else
    decimal=$(roman_to_decimal "$input")
    echo "Ο δεκαδικός αριθμός για τον ρωμαϊκό αριθμό $input είναι: $decimal"
fi