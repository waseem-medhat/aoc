package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

const newline = byte(10)

func main() {
	var total int
	file, _ := os.Open("./d01/d01input.txt")
	defer file.Close()

	// numbers := []string{
	// 	"one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
	// }

	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := scanner.Text()
		fmt.Println(line)

		digits := []int{}
		for _, c := range line {
			if d, err := strconv.Atoi(string(c)); err == nil {
				digits = append(digits, d)
			}
		}

		d1 := digits[0]
		d2 := digits[len(digits)-1]

		total += d1*10 + d2
		digits = []int{}
	}

	fmt.Println(total)
}
