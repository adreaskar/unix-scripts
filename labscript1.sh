#!/bin/bash

# Έλεγχος για το αν υπάρχει όρισμα
if [ $# -eq 0 ]; then
    echo "Δεν δόθηκε αριθμητικό όρισμα."
    exit 1
fi

# Έλεγχος για το αν το όρισμα είναι ακέραιος αριθμός
if ! [[ $1 =~ ^[0-9]+$ ]]; then
    echo "Το όρισμα πρέπει να είναι ένας ακέραιος αριθμός."
    exit 1
fi

number=$1

# Έλεγχος για το αν ο αριθμός είναι μεγαλύτερος του 0 και μικρότερος ή ίσος του 24
if [ $number -le 0 ] || [ $number -gt 24 ]; then
    echo "Ο αριθμός πρέπει να είναι μεγαλύτερος του 0 και μικρότερος ή ίσος του 24."
    exit 1
fi

# Εύρεση αρχείων που δημιουργήθηκαν την ώρα που δηλώνει ο αριθμός
files=$(find . -maxdepth 1 -type f -newermt "$(date +%Y-%m-%d) $number:00:00" ! -newermt "$(date +%Y-%m-%d) $number:59:59")

# Έλεγχος για την ύπαρξη αρχείων
if [ -z "$files" ]; then
    echo "Δεν υπάρχουν αρχεία που να δημιουργήθηκαν μεταξύ $number:00 και $number:59."
    exit 1
fi

# Εγγραφή των αρχείων στο αρχείο timefile
echo "$files" > timefile
echo "Τα αρχεία που δημιουργήθηκαν μεταξύ $number:00 και $number:59 έχουν εγγραφεί στο αρχείο timefile."

