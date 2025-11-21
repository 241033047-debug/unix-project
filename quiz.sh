#!/bin/bash
QUESTIONS_FILE="questionspr.txt"
start_quiz() {
  score=0
  total=0

  if [[ ! -f "$QUESTIONS_FILE" ]]; then
    echo "Questions file '$QUESTIONS_FILE' not found!"
    return
  fi

  while IFS='|' read -r question options correct || [[ -n $question ]]
  do
    [[ -z "${question//[[:space:]]/}" ]] && continue

    question="${question%%$'\r'}"
    options="${options%%$'\r'}"
    correct="${correct%%$'\r'}"

    total=$((total + 1))
    echo ""
    echo "Q$total: $question"
    echo "$options"

    read -p "Answer: " answer </dev/tty
    answer="$(echo -n "$answer" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

    if [[ "$answer" == "$correct" ]]; then
      echo "Correct!"
      score=$((score + 1))
    else
      echo "Incorrect. Correct answer: $correct"
    fi

  done < "$QUESTIONS_FILE"

  echo ""
echo "Quiz complete!"
  echo "Your score: $score / $total"
}

instructions() {
  echo ""
  echo "=============== INSTRUCTIONS ==============="
  echo "1) Each question has options like:"
  echo "      question | option1 option2 ... | correct_number"
  echo ""
  echo "2) Enter only the correct option number."
  echo "3) Press ENTER after typing your answer."
  echo "============================================"
}

show_menu() {
  echo ""
  echo "=============== QUIZ MENU ================="
  echo "1) Start Quiz"
  echo "2) Instructions"
  echo "3) Exit"
  echo "============================================"
}

while true
do
  show_menu
  read -p "Enter your choice: " choice

  case "$choice" in
    1) start_quiz ;;
    2) instructions ;;
    3) echo "Goodbye!"; exit 0 ;;
    *) echo "Invalid choice. Try again." ;;
  esac
done