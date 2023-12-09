package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
	"sync"
	"time"
)

func main() {
	start := time.Now()
	seeds, mappers := parseAlmanac("d05/d05input.txt")

	minSeed := seeds[0]
	var wg sync.WaitGroup

	for i := 0; i < len(seeds)-1; i += 2 {
		for seed := seeds[i]; seed < seeds[i]+seeds[i+1]; seed++ {

			wg.Add(1)
			go func(seed int) {
				defer wg.Done()

				for _, mapper := range mappers {
					seed = mapper(seed)
				}

				if seed < minSeed {
					minSeed = seed
				}
			}(seed)
		}
	}

	wg.Wait()
	fmt.Println(minSeed)
	fmt.Println(time.Since(start))
}

// getSeeds takes a the seeds line and parses the numbers
func getSeeds(line string) []int {
	seedNums := []int{}
	seedStrings := strings.Fields(line)[1:]

	for _, s := range seedStrings {
		seedNum, err := strconv.Atoi(s)
		if err != nil {
			fmt.Println("Unexpected seed string!")
			log.Fatal(err)
		}
		seedNums = append(seedNums, seedNum)
	}

	return seedNums
}

// getRule takes a line and builds a mapper rule from it
func getRule(line string) [3]int {
	lineFields := strings.Fields(line)

	dstStart, err := strconv.Atoi(lineFields[0])
	if err != nil {
		fmt.Println("Unexpected rule string!")
		log.Fatal(err)
	}

	srcStart, err := strconv.Atoi(lineFields[1])
	if err != nil {
		fmt.Println("Unexpected rule string!")
		log.Fatal(err)
	}

	length, err := strconv.Atoi(lineFields[2])
	if err != nil {
		fmt.Println("Unexpected rule string!")
		log.Fatal(err)
	}

	return [3]int{dstStart, srcStart, length}
}

// buildMapper takes a ruleset and makes a corresponding mapper function
func buildMapper(ruleset [][3]int) func(int) int {
	return func(n int) int {
		for _, rule := range ruleset {
			if n >= rule[1] && n < rule[1]+rule[2] {
				return n + rule[0] - rule[1]
			}
		}
		return n
	}
}

func parseAlmanac(path string) ([]int, []func(int) int) {
	f, _ := os.Open(path)
	defer f.Close()

	var seeds []int
	var ruleset [][3]int
	var mappers []func(int) int

	s := bufio.NewScanner(f)
	for s.Scan() {
		line := s.Text()

		if strings.HasPrefix(line, "seeds:") {
			seeds = getSeeds(line)
			continue
		}

		if strings.HasSuffix(line, "map:") {
			ruleset = [][3]int{}
			continue
		}

		if line == "" {
			mappers = append(mappers, buildMapper(ruleset))
			continue
		}

		ruleset = append(ruleset, getRule(line))
	}

	// has to be called separately at EOF due to the lack of empty line
	mappers = append(mappers, buildMapper(ruleset))

	return seeds, mappers
}
