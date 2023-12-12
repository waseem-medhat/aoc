package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
	"time"
)

type rule struct {
	srcStart int
	srcEnd   int
	dstStart int
	dstEnd   int
}

type numRange struct {
	start int
	end   int
}

func main() {
	start := time.Now()
	seeds, rulesets := parseAlmanac("d05/d05test.txt")
	// seeds, mappers := parseAlmanac("d05/d05input.txt")

	// build ranges from seed numebrs
	ranges := []numRange{}
	for i := 0; i < len(seeds)-1; i += 2 {
		ranges = append(ranges, numRange{seeds[i], seeds[i] + seeds[i+1] - 1})
	}

    fmt.Println(rulesets[4])
	fmt.Println(
		matchRuleset(numRange{74, 87}, rulesets[4]),
	)
	os.Exit(0)

	calcRanges := []numRange{}
	// for len(ranges) > 0 {
	// 	// pop off a seed range
	// 	sr := ranges[0]
	// 	ranges = ranges[1:]
	//
	// 	// intermediate to apply every ruleset
	// 	intmRanges := []numRange{sr}
	// 	fmt.Println("Starting with intm ranges:", intmRanges)
	//
	// 	for _, rs := range rulesets {
	// 		fmt.Println(intmRanges, "before next calc")
	// 		newIntmRanges := []numRange{}
	//
	// 		// rule matching
	//
	// 		newIntmRanges = append(newIntmRanges, tempIntmRanges...)
	//
	// 		// temp didn't receive new ranges, so no matching to be done
	// 		if len(tempIntmRanges) == 0 || len(toCheck) == 0 {
	// 			intmRanges = newIntmRanges
	// 			break
	// 		}
	//
	// 		fmt.Println("Ruleset end, intm ranges:", intmRanges)
	// 	}
	//
	// 	calcRanges = append(calcRanges, intmRanges...)
	// }

	var min int
	for i, r := range calcRanges {
		if i == 0 || r.start < min {
			min = r.start
		}
	}

	fmt.Println("\nmin:", min)
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

func matchRuleset(rng numRange, rs []rule) []numRange {
	newRanges := []numRange{}
	toCheck := rng

	done := false
	for !done {
		done = true
		for _, r := range rs {
			diff := r.dstStart - r.srcStart

			if toCheck.start >= r.srcStart && toCheck.end <= r.srcEnd {
				fmt.Println("Range", toCheck, "contained in rule", r)

				newRanges = append(newRanges, numRange{
					start: toCheck.start + diff,
					end:   toCheck.end + diff,
				})

				break
			}

			if toCheck.start >= r.srcStart && toCheck.start <= r.srcEnd {
				fmt.Println("Range", toCheck, "left is overlapping with rule", r)

				newRanges = append(newRanges, numRange{
					start: toCheck.start + diff,
					end:   r.srcEnd + diff,
				})

				toCheck = numRange{
					start: r.srcEnd + 1,
					end:   toCheck.end,
				}

				done = false
			}

			if toCheck.end >= r.srcStart && toCheck.end <= r.srcEnd {
				fmt.Println("Range", toCheck, "right is overlapping with rule", r)

				toCheck = numRange{
					start: toCheck.start,
					end:   r.srcStart - 1,
				}

				newRanges = append(newRanges, numRange{
					start: r.srcStart + diff,
					end:   toCheck.end + diff,
				})

				done = false
			}
		}
	}

	if len(newRanges) == 0 {
        return []numRange{rng}
	} else {
		return newRanges
    }
}
