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

	numMap := map[int]int{}
	nums := []int{}

	scanner := bufio.NewScanner(f)
	for lineNum := 0; scanner.Scan(); lineNum++ {
		line := scanner.Text()

		if lineNum == 0 {
			nums = getSeeds(line)
			continue
		}

		if lineNum == 1 {
			continue
		}

		if strings.HasSuffix(line, "map:") {
			numMap = map[int]int{}
			continue
		}

		if line == "" {
			for i, num := range nums {
				if newNum, ok := numMap[num]; ok {
					nums[i] = newNum
				}
			}
			continue
		}

		numMap = buildMap(numMap, line)
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

func buildMap(numMap map[int]int, line string) map[int]int {
	var newMap = numMap

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

	for i := 0; i < length; i++ {
		newMap[srcStart+i] = dstStart + i
	}

	return newMap
}
