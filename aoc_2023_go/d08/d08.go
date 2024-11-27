package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"slices"
	"strings"
)

func main() {
	dirs, network := parseNetwork("d08/input.txt")

	// Part 1
	n := 0
	point := "AAA"
	for point != "ZZZ" {
		dir := getDirection(dirs, n)
		point = network[point][dir]
		n++
	}

	fmt.Println(n)

	// Part 2
	bgnPoints := []string{}
	endPoints := []string{}
	for p := range network {
		if strings.HasSuffix(p, "A") {
			bgnPoints = append(bgnPoints, p)
		}

		if strings.HasSuffix(p, "Z") {
			endPoints = append(endPoints, p)
		}
	}

	distance := 1
	for _, bp := range bgnPoints {
		p := bp
		var n = 0

		for {
			dir := getDirection(dirs, n)
			p = network[p][dir]
			n++
			if slices.Contains(endPoints, p) {
				break
			}
		}

		distance = LCM(distance, n)
	}

	fmt.Println(distance)
}

// func parseNetwork takes a file path and parses the direction line (as a
// string), the network (a map of string -> 2-string array), and the first
// point in the map
func parseNetwork(path string) (dirs string, network map[string][2]string) {
	f, _ := os.Open(path)
	defer f.Close()

	s := bufio.NewScanner(f)

	dirs = ""
	network = map[string][2]string{}

	re := regexp.MustCompile(`([A-Z]{3}) = \(([A-Z]{3}), ([A-Z]{3})\)`)

	for i := 0; s.Scan(); i++ {
		line := s.Text()

		if i == 0 {
			dirs = s.Text()
			continue
		}

		if i == 1 {
			continue
		}

		matches := re.FindStringSubmatch(line)
		network[matches[1]] = [2]string{matches[2], matches[3]}
	}

	return dirs, network
}

// func getDirection is a utility that takes an index and returns a direction,
// either left (0) or right (1). Note that 0 and 1 correspond to the indices of
// the 2-string array in the network map
func getDirection(dirs string, idx int) int {
	dirsLen := len(dirs)
	dir := rune(dirs[idx%dirsLen])

	switch dir {
	case 'L':
		return 0
	case 'R':
		return 1
	default:
		panic("Unexpected direction input!!")
	}
}

func GCD(a, b int) int {
	for b != 0 {
		t := b
		b = a % b
		a = t
	}
	return a
}

func LCM(a, b int) int {
	result := a * b / GCD(a, b)
	return result
}
