package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"slices"
	"strings"
)

const numStart = 10

func main() {
	f, _ := os.Open("d04/d04input.txt")
	scanner := bufio.NewScanner(f)

	score := 0.0
	dups := map[int]int{}
    nCards := 0

	for i := 1; scanner.Scan(); i++ {
        dups[i]++
		line := scanner.Text()

		numSets := strings.Split(line[numStart:], " | ")
		winning := strings.Split(numSets[0], " ")
		hand := strings.Split(numSets[1], " ")

		matches := 0
		for _, n := range hand {
			if slices.Contains(winning, n) && n != "" {
				matches++
			}
		}

		if matches >= 1 {
			handScore := math.Pow(2.0, float64(matches-1))
			score += handScore
		}

		for j := 1; j <= matches; j++ {
			dups[i+j] += dups[i]
		}
	}

    for _, n := range dups {
        nCards += n
    }

	fmt.Println(score)
	fmt.Println(nCards)
}
