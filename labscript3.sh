#!/bin/bash

target=$((RANDOM % 100 + 1))  # Τυχαίος αριθμός από 1 έως 100
max_attempts=10  # Ορίζουμε τον μέγιστο αριθμό προσπαθειών

echo "Καλώς ήρθες στο παιχνίδι 'Μάντεψε τον Αριθμό'!"
echo "Προσπάθησε να βρεις τον αριθμό που έχω σκεφτεί απο 1 εως 100."
echo "Έχεις $max_attempts προσπάθειες."
echo ""

for ((attempt=1; attempt<=max_attempts; attempt++))
do
    read -p "Μάντεψε έναν αριθμό: " guess

    if [[ $guess -eq $target ]]; then
        echo "Συγχαρητήρια! Βρήκες τον αριθμό σωστά μετά από $attempt προσπάθειες."
        exit 0
    elif [[ $guess -lt $target ]]; then
        echo "Λάθος! Ο αριθμός που μάντεψες είναι μικρότερος απο τον στόχο."
    else
        echo "Λάθος! Ο αριθμός που μάντεψες είναι μεγαλύτερος απο τον στόχο."
    fi
done

echo "Δυστυχώς, ξεπέρασες τον μέγιστο αριθμό προσπαθειών."
echo "Ο αριθμός που έπρεπε να μαντέψεις ήταν: $target"
exit 0
