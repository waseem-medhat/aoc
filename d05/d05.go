package main

import (
	"bufio"
	"fmt"
	"log"
	"math"
	"os"
	"strconv"
	"strings"
)

func main() {
	// f, _ := os.Open("d05/d05test.txt")
	f, _ := os.Open("d05/d05input.txt")

	var nums []int
	maps := map[string][][3]int{}

	newMap := [][3]int{}
	newMapName := ""

	scanner := bufio.NewScanner(f)
	scanning := true
	for lineNum := 0; scanning; lineNum++ {
		scanning = scanner.Scan()
		line := scanner.Text()

		if lineNum == 0 {
			nums = getSeeds(line)
			continue
		}

		if lineNum == 1 {
			continue
		}

		if strings.HasSuffix(line, "map:") {
			newMapName = strings.Fields(line)[0]
			newMap = [][3]int{}
			continue
		}

		if line == "" || !scanning {
			maps[newMapName] = newMap
			continue
		}

		newMap = append(newMap, parseLine(line))
	}

	mapSeq := []string{
		"seed-to-soil",
		"soil-to-fertilizer",
		"fertilizer-to-water",
		"water-to-light",
		"light-to-temperature",
		"temperature-to-humidity",
		"humidity-to-location",
	}

	minLocation := math.Inf(1)
	for seedNumIdx := 0; seedNumIdx < len(nums)-1; seedNumIdx += 2 {
		firstNum := nums[seedNumIdx]
		lastNum := firstNum + nums[seedNumIdx+1]

		for num := firstNum; num < lastNum; num++ {
			fmt.Println("Checking seed num: ", num)

			// number updating
            updatedNum := num
		mapLoop:
			for _, mapName := range mapSeq {
				for _, row := range maps[mapName] {
					dstStart := row[0]
					srcStart := row[1]
					length := row[2]
					diff := dstStart - srcStart

					if updatedNum >= srcStart && updatedNum < srcStart+length {
						updatedNum += diff
						continue mapLoop
					}
				}
			}

			// number finished updating: check location
			if float64(updatedNum) < minLocation {
				minLocation = float64(updatedNum)
			}
		}
	}

    fmt.Println(minLocation)
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

func parseLine(line string) [3]int {
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

	return [3]int{dstStart, srcStart, length}
}
