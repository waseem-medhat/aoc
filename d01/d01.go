package main

import (
	"fmt"
	"os"
	"strconv"
)

const newline = byte(10)

func main() {
	var total int
	f, _ := os.ReadFile("./d01/d01input.txt")

	digits := []int{}
	for _, char := range f {
		if char == newline {
			d1 := digits[0]
			d2 := digits[len(digits)-1]

			total += d1*10 + d2
			digits = []int{}
		} else if d, err := strconv.Atoi(string(char)); err == nil {
			digits = append(digits, d)
		}
	}

	fmt.Println(total)
}
