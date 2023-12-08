
class Card:
    possible_values = "AKQT98765432J"
    def __init__(self, value: str):
        if not self.possible_values.find(value) == -1:
            self.value = value
        else:
            raise ValueError("Can't create card")
        
    def __hash__(self):
        return hash(self.value)

    def __eq__(self, other) -> bool:
        if isinstance(other, Card):
            if other.value == self.value:
                return True
            return False

    def __gt__(self, other):
        if isinstance(other, Card):
            index_a = self.possible_values.find(self.value)
            index_b = self.possible_values.find(other.value)
            if index_a < index_b:
                return True
            return False
    
    def __repr__(self) -> str:
        return self.value
    

def build_card_pairs(hand: [Card]) -> [[Card]]:
    types = dict()

    for card in hand:
        if card in types:
            types[card].append(card)
        else:
            types[card] = [card]

    return list(types.values())

def matches_card_pair_pattern(card_pairs: [[Card]], pattern: [int]) -> True:
    pattern: list = list(pattern)
    for card_pair in card_pairs:
        length = len(card_pair)
        try:
            i = pattern.index(length)
            pattern.pop(i)
        except:
            return False
    return True

def is_five_of_a_kind(hand: [Card]) -> bool:
    return matches_card_pair_pattern(
        build_card_pairs(hand),
        [5]
    )

def is_four_of_a_kind(hand: [Card]) -> bool:
    return matches_card_pair_pattern(
        build_card_pairs(hand),
        [4,1]
    )

def is_full_house(hand: [Card]) -> bool:
    return matches_card_pair_pattern(
        build_card_pairs(hand),
        [3,2]
    )

def is_three_of_a_kind(hand: [Card]) -> bool:
    return matches_card_pair_pattern(
        build_card_pairs(hand),
        [3,1,1]
    )

def is_two_pair(hand: [Card]) -> bool:
    return matches_card_pair_pattern(
        build_card_pairs(hand),
        [2,2,1]
    )

def is_one_pair(hand: [Card]) -> bool:
    return matches_card_pair_pattern(
        build_card_pairs(hand),
        [2,1,1,1]
    )

def is_high_card(hand: [Card]) -> bool:
    return matches_card_pair_pattern(
        build_card_pairs(hand),
        [1,1,1,1,1]
    )

def find_hand_type(hand: [Card]) -> int:
    hand_types = [
        is_five_of_a_kind, is_four_of_a_kind,
        is_full_house, is_three_of_a_kind,
        is_two_pair, is_one_pair,
        is_high_card
    ]
    for i, hand_type in enumerate(hand_types):
        if hand_type(hand):
            return i
        

class Hand:

    def __init__(self, cards: str):
        self.cards = list(
            map(lambda c: Card(c), cards)
        )

    def __gt__(self, other):
        if isinstance(other, Hand):
            modified_self_cards = list(self.cards)
            modified_other_cards = list(other.cards)
            #check if contains j card
            if Card("J") in self.cards:
                # get highest amount of numbers
                pairs = filter(lambda c:c[0].value!="J",build_card_pairs(modified_self_cards))
                try:
                    j_is = sorted(pairs, key=lambda l:len(l))[-1][0]
                except:
                    j_is = "A"
                modified_self_cards = list(map(lambda c: j_is if c.value == "J" else c,modified_self_cards))
            #check if contains j card
            if Card("J") in other.cards:
                # get highest amount of numbers
                pairs = filter(lambda c:c[0].value!="J",build_card_pairs(modified_other_cards))
                try:
                    j_is = sorted(pairs, key=lambda l:len(l))[-1][0]
                except:
                    j_is = "A"
                modified_other_cards = list(map(lambda c: j_is if c.value == "J" else c,modified_other_cards))


            hand_type_self = find_hand_type(modified_self_cards)
            hand_type_other = find_hand_type(modified_other_cards)
            if hand_type_self < hand_type_other :

                return True
            if hand_type_self == hand_type_other:
                for i in range(0,len(other.cards)):
                    if self.cards[i] > other.cards[i]:
                        return True
                    if self.cards[i] < other.cards[i]:
                        return False
            return False
        
        
    def __repr__(self):
        return f"{self.cards}"
        


input_lines = open("input_1.txt","r").readlines()

hand_bit_lines = list(
    map(lambda line: line.split(" "),input_lines)
)

hand_bits = list(
    map(lambda line:(Hand(line[0]),int(line[1])), hand_bit_lines)
)

ranked_hands = list(
    enumerate(sorted(hand_bits,key=lambda el: el[0]), start=1)
)

result = sum(map(lambda ranked_hand: ranked_hand[0] * ranked_hand[1][1], ranked_hands))

print(result)