
karten = [
    {"question": "Wie hieß elias früher (spitzname)?", "answer": "Felix"},
    {"question": "wie hieß amar früher?", "answer": "Mehmet"},
    {"question": "Wie viele freundinnen hatte david?", "answer": "weiß der kuckuck"}
]

def ask (karten):
    print(karten["question"])
    antwort =  input("Deine Antwort:")
    if antwort.strip().lower() == karten["answer"]:
        print("Richtig du schwanz")
        return True
    else:
        print(f"falsch du schwanz, richtig wäre {karten["answer"]}")
        return False
    
karten_nr = 0

while True:
    karta = 2
    if karta > karten_nr:
        jetzkarte = karten[karten_nr]
        ask(jetzkarte)
        karten_nr += 1 
    else:
        print("keine fragen mehr ):")
        break
