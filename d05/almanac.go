package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

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
func getRule(line string) rule {
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

	return rule{
		srcStart: srcStart,
		srcEnd:   srcStart + length - 1,
		dstStart: dstStart,
		dstEnd:   dstStart + length - 1,
	}
}

func parseAlmanac(path string) ([]int, [][]rule) {
	f, _ := os.Open(path)
	defer f.Close()

	var seeds []int
	var ruleset []rule
	// var mappers []func(int) int
	var rulesets [][]rule

	s := bufio.NewScanner(f)
	for s.Scan() {
		line := s.Text()

		if strings.HasPrefix(line, "seeds:") {
			seeds = getSeeds(line)
			s.Scan() // skip the next (empty) line
			continue
		}

		if strings.HasSuffix(line, "map:") {
			ruleset = []rule{}
			continue
		}

		if line == "" {
			// mappers = append(mappers, buildMapper(ruleset))
			rulesets = append(rulesets, ruleset)
			continue
		}

		ruleset = append(ruleset, getRule(line))
	}

	// has to be called separately at EOF due to the lack of empty line
	// mappers = append(mappers, buildMapper(ruleset))
	rulesets = append(rulesets, ruleset)

	return seeds, rulesets
}
