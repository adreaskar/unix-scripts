#!/bin/bash

# Έλεγχος για την παρουσία των δύο αριθμητικών ορισμάτων
if [ $# -lt 2 ]; then
    echo "Σφάλμα: Απαιτούνται δύο ακέραιοι αριθμοί ως όρισματα."
    exit 1
fi

# Λήψη των αριθμών
num1=$1
num2=$2

# Αρχικοποίηση μεταβλητών
total_files=0
total_files_changed=0
total_subdirectories=0
total_pipe_socket_files=0
total_empty_files=0
summary=""

# Συνάρτηση για εμφάνιση των αποτελεσμάτων για έναν κατάλογο
show_results() {
  echo ""
  echo "***********************************************************"
  echo "-> Αρχεία με εξουσιοδοτήσεις $num1:"
  echo ""
  echo "$1"
  echo "-> Αριθμός αρχείων: $2"
  echo "***********************************************************"
  
  echo "-> Αρχεία που άλλαξαν περιεχόμενα τις τελευταίες $num2 μέρες:"
  echo ""
  echo "$4"
  echo "-> Αριθμός αρχείων: $5"
  echo "***********************************************************"
  
  echo "-> Υποκατάλογοι που προσπελάστηκαν τις τελευταίες $num2 μέρες:"
  echo ""
  echo "$6"
  echo "-> Αριθμός υποκαταλόγων: $7"
  echo "***********************************************************"
  
  echo "-> Αρχεία τύπου pipe ή socket:"
  echo ""
  echo "$8"
  echo "-> Αριθμός αρχείων: $9"
  echo "***********************************************************"
  
  echo "-> Κενά αρχεία:"
  echo ""
  echo "${10}"
  echo "-> Αριθμός αρχείων: ${11}"
  echo "***********************************************************"
}

# Συνάρτηση για εμφάνιση της ανακεφαλαίωσης συνολικά
show_summary() {
  echo ""
  echo "Συνολικά αποτελέσματα:"
  echo "-----------------------------------------------------------------"
  echo "$summary"
}

while true; do
  # Ζητάμε από το χρήστη το όνομα ενός καταλόγου
  read -p "Δώστε το όνομα ενός καταλόγου (ή 'exit' για έξοδο): " directory
  
  # Έλεγχος για τερματισμό του προγράμματος
  if [[ "$directory" == "exit" ]]; then
    break
  fi
  
  # Έλεγχος αν ο κατάλογος υπάρχει
  if [[ ! -d "$directory" ]]; then
    echo "Ο κατάλογος δεν υπάρχει."
    continue
  fi

  # Λειτουργία 1: Αρχεία με εξουσιοδοτήσεις τον πρώτο αριθμό
  files=$(find "$directory" -type f -perm "$num1" -print)
  files_count=$(find "$directory" -type f -perm "$num1" | wc -l)
  
  # Λειτουργία 2: Αρχεία που άλλαξαν περιεχόμενα τις 'x' τελευταίες μέρες
  files_changed=$(find "$directory" -type f -mtime "-$num2" -print)
  files_changed_count=$(find "$directory" -type f -mtime -$num2 | wc -l)
  
  # Λειτουργία 3: Υποκατάλογοι που προσπελάστηκαν τις 'x' τελευταίες μέρες
  subdirectories=$(find "$directory" -type d -mtime "-$num2" -print)
  subdirectories_count=$(find "$directory" -type d -mtime -$num2 | wc -l)
  
  # Λειτουργία 4: Αρχεία τύπου pipe ή socket
  pipe_socket_files=$(find "$directory" \( -type p -o -type s \) -print)
  pipe_socket_files_count=$(find "$directory" \( -type p -o -type s \) | wc -l)
  
  # Λειτουργία 5: Κενά αρχεία
  empty_files=$(find "$directory" -type f -empty -print)
  empty_files_count=$(find "$directory" -type f -empty | wc -l)
  
  show_results "$files" "$files_count" "$num2" "$files_changed" "$files_changed_count" "$subdirectories" "$subdirectories_count" "$pipe_socket_files" "$pipe_socket_files_count" "$empty_files" "$empty_files_count"
  
  # Ανανέωση των συνολικών αποτελεσμάτων
  total_files=$((total_files + files_count))
  total_files_changed=$((total_files_changed + files_changed_count))
  total_subdirectories=$((total_subdirectories + subdirectories_count))
  total_pipe_socket_files=$((total_pipe_socket_files + pipe_socket_files_count))
  total_empty_files=$((total_empty_files + empty_files_count))
  
  # Ανανέωση του ιστορικού/ανακεφαλαίωσης για τον τρέχοντα κατάλογο
  summary+="Κατάλογος: $directory"$'\n'
  summary+="Αρχεία με εξουσιοδοτήσεις $num1: $files_count"$'\n'
  summary+="Αρχεία που άλλαξαν περιεχόμενα τις τελευταίες $num2 μέρες: $files_changed_count"$'\n'
  summary+="Υποκατάλογοι που προσπελάστηκαν τις τελευταίες $num2 μέρες: $subdirectories_count"$'\n'
  summary+="Αρχεία τύπου pipe ή socket: $pipe_socket_files_count"$'\n'
  summary+="Κενά αρχεία: $empty_files_count"$'\n'
  summary+=$'\n'
done

show_summary
