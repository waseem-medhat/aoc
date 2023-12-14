package main

type HandType int

type Hand struct {
	cards string
	bid   int
}

const (
	HighCard HandType = iota
	OnePair
	TwoPair
	ThreeOAK
	FullHouse
	FourOAK
	FiveOAK
)
