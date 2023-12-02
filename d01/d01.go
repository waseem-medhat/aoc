package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	var total int
	file, _ := os.Open("./d01/d01input.txt")
	defer file.Close()

	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := scanner.Text()

		digits := []int{}

		for i, char := range line {
			if d, err := strconv.Atoi(string(char)); err == nil {
				digits = append(digits, d)
			} else if d := findNumber(line, i); d > 0 {
				digits = append(digits, d)
			}
		}

		d1 := digits[0]
		d2 := digits[len(digits)-1]

		total += d1*10 + d2
	}

	fmt.Println(total)
}

func findNumber(line string, idx int) int {
	numbers := []string{
		"one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
	}

	for i, num := range numbers {
		if strings.Index(line[idx:], num) == 0 {
			return i + 1
		}
	}

	return -1
}
