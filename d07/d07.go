package main

import (
	"bufio"
	"fmt"
	"os"
	"slices"
	"strconv"
	"strings"
)

func main() {
	// hands := []Hand{{"32T3K", 765}, {"T55J5", 684}, {"KK677", 28}, {"KTJJT", 220}, {"QQQJA", 483}}
	hands := parseInput("d07/input.txt")

	slices.SortFunc(hands, cmpHands)

	winnings := 0
	for i, c := range hands {
		winnings += (i + 1) * c.bid
	}

	fmt.Println(winnings)
}

// func parseInput takes the input file path and parses the list of hands
func parseInput(path string) []Hand {
	f, _ := os.Open(path)
	defer f.Close()

	hands := []Hand{}

	s := bufio.NewScanner(f)
	for s.Scan() {
		lineFields := strings.Fields(s.Text())
		cards := lineFields[0]
		bid, _ := strconv.Atoi(lineFields[1])
		hands = append(hands, Hand{cards, bid})
	}

	return hands
}

// func cmpCards is a utility that compares relative strengths of cards
func cmpCards(a, b string) int {
	cardTypes := "J23456789TQKA"

	diff := strings.Index(cardTypes, a) - strings.Index(cardTypes, b)

	if diff > 0 {
		return 1
	} else if diff < 0 {
		return -1
	} else {
		return 0
	}
}

// func cmpHands is a utility that compares relative strengths of hands
func cmpHands(a, b Hand) int {
	if handType(a) > handType(b) {
		return 1
	} else if handType(a) < handType(b) {
		return -1
	}

	for i := 0; i < 5; i++ {
		cardCmp := cmpCards(string(a.cards[i]), string(b.cards[i]))
		if cardCmp != 0 {
			return cardCmp
		}
	}

	return 0
}

// func handTypes determines the type of a given hand (e.g., full house)
func handType(hand Hand) HandType {
	freqs := map[rune]int{}

	if len(hand.cards) != 5 {
		return 0
	}

	// calculate frequencies
	for _, char := range hand.cards {
		freqs[char]++
	}

	// get card with max freq
	var maxCard rune
	var maxFreq int
	for card, freq := range freqs {
		if card != 'J' && freq > maxFreq {
			maxFreq = freq
			maxCard = card
		}
	}

	freqs[maxCard] += freqs['J']
	delete(freqs, 'J')

	switch len(freqs) {
	case 1:
		return FiveOAK
	case 2:
		for _, f := range freqs {
			if f == 4 {
				return FourOAK
			} else if f == 3 {
				return FullHouse
			}
		}
	case 3:
		for _, f := range freqs {
			if f == 3 {
				return ThreeOAK
			} else if f == 2 {
				return TwoPair
			}
		}
	case 4:
		return OnePair
	case 5:
		return HighCard
	}

	return 0
}
