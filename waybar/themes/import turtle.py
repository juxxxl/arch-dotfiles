card = [
    {"question": "What is the capital of France?", "answer": "Paris"},
    {"question": "", "answer": ""},
    {"question": "", "answer": ""}, 
    {"question": "", "answer": ""}, 
    {"question": "", "answer": ""},
    {"question": "", "answer": ""}, 
    {"question": "", "answer": ""}, 
    {"question": "", "answer": ""}, 
    {"question": "", "answer": ""}, 
    {"question": "", "answer": ""}, 
    {"question": "", "answer": ""}, 
]

def ask_one(card):
    print(card["question"])               # show the question
    user_answer = input("Your answer: ")  # get what user types
    if user_answer.strip().lower() == card["answer"].lower():
        print("✅ Correct!\n")
        return
    else:
        print(f"❌ Wrong. The right answer is {card['answer']}\n")
        return False


card_nr = 0

while True:
    cards = 2
    if cards > card_nr:
        currentcard = card[card_nr]
        ask_one(currentcard)
        card_nr += 1
    else:
        print("No more cards")
        break