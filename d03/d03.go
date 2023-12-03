package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

type Coord struct {
	num string
	i   int
	j   int
}

func main() {
	f, _ := os.Open("d03/d03input.txt")
	defer f.Close()

	nums, lines := getPartCoords(f)
	partNumSum := checkAdjCoords(nums, lines)

	fmt.Println(partNumSum)
}

// getPartCoords takes a *os.File (returned from os.Open()), extracts the part
// numbers and returns a map from part number to its coordinates [row, col] in
// the file. It also returns the file lines which will be used for lookup in
// the later step.
func getPartCoords(f *os.File) ([]Coord, []string) {
	coords := []Coord{}
	lines := []string{}

	scanner := bufio.NewScanner(f)
	for i := 0; scanner.Scan(); i++ {
		line := scanner.Text()
		lines = append(lines, line)

		var newNum []rune
		for j, char := range line {
			if isDigit(char) {
				newNum = append(newNum, char)
			} else if len(newNum) > 0 {
				// coords[string(newNum)] = [2]int{i, j - len(newNum)}
				coords = append(coords, Coord{
					num: string(newNum),
					i:   i,
					j:   j - len(newNum),
				})
				newNum = []rune{}
			}
		}
	}

	return coords, lines
}

// checkAdjCoords takes partCoords and a slice of lines (returned from
// getPartCoords()) and returns true if the number is adjacent to a symbol in
// any direction or even diagonally, and false otherwise.
func checkAdjCoords(partCoords []Coord, lines []string) int {
	partNumSum := 0

outer:
	for _, coord := range partCoords {
		cLine := coord.i
		cStart := coord.j
		cEnd := cStart + len(coord.num) - 1

		fmt.Println(coord.num, cLine, cStart)

		var adjCoords [][2]int
		var i int
		var j int

		// left, same line
		if cStart > 0 {
			i = cLine
			j = cStart - 1
			if checkChar(lines, i, j) {
				// fmt.Printf("%c\n", lines[i][j])
				numInt, _ := strconv.Atoi(coord.num)
				partNumSum += numInt
				continue
			}
			adjCoords = append(adjCoords, [2]int{i, j})
		}

		// upper left
		if cStart > 0 && cLine > 0 {
			i = cLine - 1
			j = cStart - 1
			if checkChar(lines, i, j) {
				// fmt.Printf("%c\n", lines[i][j])
				numInt, _ := strconv.Atoi(coord.num)
                fmt.Println(numInt)
				partNumSum += numInt
				continue
			}
			adjCoords = append(adjCoords, [2]int{i, j})
		}

		// lower left
		if cStart > 0 && cLine < len(lines)-1 {
			i = cLine + 1
			j = cStart - 1
			if checkChar(lines, i, j) {
				// fmt.Printf("%c\n", lines[i][j])
				numInt, _ := strconv.Atoi(coord.num)
                fmt.Println(numInt)
				partNumSum += numInt
				continue
			}
			adjCoords = append(adjCoords, [2]int{i, j})
		}

		// right, same line
		if cEnd < len(lines[cLine])-1 {
			i = cLine
			j = cEnd + 1
			if checkChar(lines, i, j) {
				// fmt.Printf("%c\n", lines[i][j])
				numInt, _ := strconv.Atoi(coord.num)
                fmt.Println(numInt)
				partNumSum += numInt
				continue
			}
			adjCoords = append(adjCoords, [2]int{i, j})
		}

		// upper right
		if cEnd < len(lines[cLine])-1 && cLine > 0 {
			i = cLine - 1
			j = cEnd + 1
			if checkChar(lines, i, j) {
				// fmt.Printf("%c\n", lines[i][j])
				numInt, _ := strconv.Atoi(coord.num)
                fmt.Println(numInt)
				partNumSum += numInt
				continue
			}
			adjCoords = append(adjCoords, [2]int{i, j})
		}

		// lower right
		if cEnd < len(lines[cLine])-1 && cLine < len(lines)-1 {
			i = cLine + 1
			j = cEnd + 1
			if checkChar(lines, i, j) {
				// fmt.Printf("%c\n", lines[i][j])
				numInt, _ := strconv.Atoi(coord.num)
                fmt.Println(numInt)
				partNumSum += numInt
				continue
			}
			adjCoords = append(adjCoords, [2]int{i, j})
		}

		for j := cStart; j < cStart+len(coord.num); j++ {
			// upper
			if cLine > 0 {
				i = cLine - 1
				if checkChar(lines, i, j) {
					// fmt.Printf("%c\n", lines[i][j])
					numInt, _ := strconv.Atoi(coord.num)
                    fmt.Println(numInt)
					partNumSum += numInt
					continue outer
				}
				adjCoords = append(adjCoords, [2]int{i, j})
			}

			// lower
			if cLine < len(lines)-1 {
				i = cLine + 1
				if checkChar(lines, i, j) {
					// fmt.Printf("%c\n", lines[i][j])
					numInt, _ := strconv.Atoi(coord.num)
                    fmt.Println(numInt)
					partNumSum += numInt
					continue outer
				}
				adjCoords = append(adjCoords, [2]int{i, j})
			}
		}
		// fmt.Println(adjCoords)
	}

	return partNumSum
}

// checkCoord is a helper function for checkAdjCoords it takes a line slice and
// checks if the jth character in the ith line is a symbol, returning a bool
func checkChar(lines []string, i int, j int) bool {
	c := rune(lines[i][j])
	return !isDigit(c) && c != '.'
}

// isDigit is a simple helper that checks if a certain character (rune) is a
// digit
func isDigit(r rune) bool {
	return r >= '0' && r <= '9'
}
