package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"slices"
	"strconv"
	"strings"
)

func main() {
	// f, _ := os.Open("d05/d05test.txt")
	f, _ := os.Open("d05/d05input.txt")

	var nums []int
    var updated []bool

	scanner := bufio.NewScanner(f)
	for lineNum := 0; scanner.Scan(); lineNum++ {
		line := scanner.Text()

		if lineNum == 0 {
			nums = getSeeds(line)
			continue
		}

		if lineNum == 1 || strings.HasSuffix(line, "map:") || line == "" {
            updated = make([]bool, len(nums))
			continue
		}

		dstStart, srcStart, length := parseLine(line)
		diff := dstStart - srcStart

		for i, n := range nums {
			if !updated[i] && n >= srcStart && n < srcStart+length {
				nums[i] += diff
                updated[i] = true
			}
		}
	}

	fmt.Println(slices.Min(nums))
}

func getSeeds(line string) (seeds []int) {
	for _, seedStr := range strings.Fields(line)[1:] {
		seed, err := strconv.Atoi(seedStr)
		if err != nil {
			log.Fatal(err)
		}
		seeds = append(seeds, seed)
	}
	return seeds
}

func parseLine(line string) (int, int, int) {
	fields := strings.Fields(line)
	if len(fields) != 3 {
		log.Fatal("Unexpected input line while building a map")
	}

	dstStart, err := strconv.Atoi(fields[0])
	if err != nil {
		log.Fatal(err)
	}

	srcStart, err := strconv.Atoi(fields[1])
	if err != nil {
		log.Fatal(err)
	}

	length, err := strconv.Atoi(fields[2])
	if err != nil {
		log.Fatal(err)
	}

	return dstStart, srcStart, length
}
