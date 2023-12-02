package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

const maxRed = 12
const maxGreen = 13
const maxBlue = 14

type MostCubes struct {
	red   int
	green int
	blue  int
}

func main() {
	f, _ := os.Open("./d02/d02input.txt")
	defer f.Close()
	var idSum int
	var powerSum int

	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		line := scanner.Text()

		words := strings.Fields(line)
		gameId := getGameId(words)
		m := getMostCubes(words[2:])

		if m.red <= maxRed && m.green <= maxGreen && m.blue <= maxBlue {
			idSum += gameId
		}

		powerSum += m.red * m.blue * m.green
	}

	fmt.Println(idSum)
	fmt.Println(powerSum)
}

// getGameId takes a slice of words (returned from strings.Fields) and returns
// the ID of the game as an int
func getGameId(words []string) int {
	if words[0] != "Game" {
		panic("Line does not start with 'Game'")
	}

	idWithColon := words[1]
	idString := idWithColon[:len(idWithColon)-1]
	if d, err := strconv.Atoi(idString); err == nil {
		return d
	}

	return 0
}

// getMostCubes takes a slice of words containing only the cube numbers and
// returns a MostCubes struct with the highest number of cubes found in the
// game for each color
func getMostCubes(cubesLine []string) MostCubes {
	var mostCubes MostCubes

	for i, w := range cubesLine {
		switch w {
		case "red", "red,", "red;":
			r, err := strconv.Atoi(cubesLine[i-1])
			if err != nil {
				panic("Unexpected value before red")
			}
			if r > mostCubes.red {
				mostCubes.red = r
			}

		case "blue", "blue,", "blue;":
			b, err := strconv.Atoi(cubesLine[i-1])
			if err != nil {
				panic("Unexpected value before blue")
			}
			if b > mostCubes.blue {
				mostCubes.blue = b
			}

		case "green", "green,", "green;":
			g, err := strconv.Atoi(cubesLine[i-1])
			if err != nil {
				panic("Unexpected value before green")
			}
			if g > mostCubes.green {
				mostCubes.green = g
			}
		}
	}

	return mostCubes
}
