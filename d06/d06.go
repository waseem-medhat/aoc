package main

import "fmt"

var tTest = []int{7, 15, 30}
var dTest = []int{9, 40, 200}

var tInput = []int{46, 82, 84, 79}
var dInput = []int{347, 1522, 1406, 1471}

var tTest2 = []int{71530}
var dTest2 = []int{940200}

var tInput2 = []int{46828479}
var dInput2 = []int{347152214061471}

var tSelected = tInput2
var dSelected = dInput2

func main() {
	wins := []int{}
	for raceIdx := 0; raceIdx < len(tSelected); raceIdx++ {
		nWins := 0

		for holdTime := 1; holdTime < tSelected[raceIdx]; holdTime++ {
			raceTime := tSelected[raceIdx] - holdTime
			if raceTime <= 0 {
				break
			}

			dist := raceTime * holdTime
			if dist > dSelected[raceIdx] {
				nWins++
			}
		}

		wins = append(wins, nWins)
	}

    winsMult := 1
    for _, w := range wins {
        winsMult *= w
    }

	fmt.Println(winsMult)
}
