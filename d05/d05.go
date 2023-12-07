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
	f, _ := os.Open("d05/d05test.txt")
	// f, _ := os.Open("d05/d05input.txt")
    
    // fmt.Println(math.MaxUint32)
    // fmt.Println(math.MaxInt)
    // os.Exit(0)

	nums, maps := parseAlmanac(f)
	minLocation := math.Inf(1)

	for seedNumIdx := 0; seedNumIdx < len(nums)-1; seedNumIdx += 2 {
		firstNum := nums[seedNumIdx]
		lastNum := firstNum + nums[seedNumIdx+1]

		for num := firstNum; num < lastNum; num++ {

            updatedNum := lookupNum(num, &maps)

			// number finished updating: check location
			if float64(updatedNum) < minLocation {
				minLocation = float64(updatedNum)
			}
		}
	}

	fmt.Println(minLocation)
}

func getSeeds(line string) (seeds []uint32) {
	for _, seedStr := range strings.Fields(line)[1:] {
		seed, err := strconv.ParseUint(seedStr, 10, 0)
		if err != nil {
			log.Fatal(err)
		}
		seeds = append(seeds, uint32(seed))
	}
	return seeds
}

func parseLine(line string) [3]uint32 {
	fields := strings.Fields(line)
	if len(fields) != 3 {
		log.Fatal("Unexpected input line while building a map")
	}

	dstStart, err := strconv.ParseUint(fields[0], 10, 0)
	if err != nil {
		log.Fatal(err)
	}

	srcStart, err := strconv.ParseUint(fields[1], 10, 0)
	if err != nil {
		log.Fatal(err)
	}

	length, err := strconv.ParseUint(fields[2], 10, 0)
	if err != nil {
		log.Fatal(err)
	}

	return [3]uint32{uint32(dstStart), uint32(srcStart), uint32(length)}
}

func parseAlmanac(f *os.File) ([]uint32, map[string][][3]uint32) {
	nums := []uint32{}
	maps := map[string][][3]uint32{}
	newMap := [][3]uint32{}
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
			newMap = [][3]uint32{}
			continue
		}

		if line == "" || !scanning {
			maps[newMapName] = newMap
			continue
		}

		newMap = append(newMap, parseLine(line))
	}

	return nums, maps
}

func lookupNum(num uint32, maps *map[string][][3]uint32) uint32 {
    fmt.Println("Checking seed num: ", num)

	// number updating
	mapSeq := []string{
		"seed-to-soil",
		"soil-to-fertilizer",
		"fertilizer-to-water",
		"water-to-light",
		"light-to-temperature",
		"temperature-to-humidity",
		"humidity-to-location",
	}

mapLoop:
	for _, mapName := range mapSeq {
		for _, row := range (*maps)[mapName] {
			dstStart := row[0]
			srcStart := row[1]
			length := row[2]
			diff := dstStart - srcStart

			if num >= srcStart && num < srcStart+length {
				num += diff
				continue mapLoop
			}
		}
	}

	return num
}
