package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
)

func main() {
	dirs, network := parseNetwork("d08/input.txt")

    n := 0
    point := "AAA"
    for point != "ZZZ" {
        dir := getDirection(dirs, n)
        point = network[point][dir]
        n++
    }

    fmt.Println(n)
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
