package main

import (
	"fmt"
	"os"
	"strconv"
)

const lineWidth = 140
const newLine = byte('\n')

func main() {
	fPre, _ := os.ReadFile("d03/d03input.txt")
	f := []byte{}
	for _, b := range fPre {
		if b != newLine {
			f = append(f, b)
		}
	}

	num := []byte{}            // number will "form" byte by byte during iteration
	isPartNum := false         // will be checked after a number is formed
	toCheck := []int{}         // indices of characters around a formed number
	astData := map[int][]int{} // maps from asterisk position to numbers adjacent to it

	partNumSum := 0 // targets
	ratioSum := 0

	for i, b := range f {

		if isDigit(b) {
			num = append(num, b)

			// start of a number, add left indices (incl. diagonal)
			if len(num) == 1 {
				if i > 0 {
					toCheck = append(toCheck, i-1)
				}
				if i > lineWidth {
					toCheck = append(toCheck, i-lineWidth-1)
				}
				if (i + lineWidth) < (len(f) - 1) {
					toCheck = append(toCheck, i+lineWidth-1)
				}
			}

			// middle of number, add top and bottom indices
			if i > lineWidth {
				toCheck = append(toCheck, i-lineWidth)
			}
			if (i + lineWidth) < (len(f) - 1) {
				toCheck = append(toCheck, i+lineWidth)
			}

		} else if len(num) > 0 {
			// right of a formed number, add right indices (incl. diagonal)
			if i < len(f)-1 {
				toCheck = append(toCheck, i)
			}
			if i > lineWidth {
				toCheck = append(toCheck, i-lineWidth)
			}
			if (i + lineWidth) < (len(f) - 1) {
				toCheck = append(toCheck, i+lineWidth)
			}

			// number is formed, start checks, calculate, then reset
			numInt, _ := strconv.Atoi(string(num))

			for _, iCheck := range toCheck {
				if isSymbol(f[iCheck]) {
					isPartNum = true
				}

				if isAsterisk(f[iCheck]) {
					astData = addAst(astData, iCheck, numInt)
				}
			}

			if isPartNum {
				partNumSum += numInt
			}

			num = []byte{}
			isPartNum = false
			toCheck = []int{}
		}
	}

	for _, nums := range astData {
		if len(nums) == 2 {
			ratio := nums[0] * nums[1]
			ratioSum += ratio
		}
	}

	fmt.Println(partNumSum)
	fmt.Println(ratioSum)
}

// addAst takes the asterisks data and adds to it. This abstracts simple logic
// that checks if any data already exists before appending new numbers.
func addAst(asterisks map[int][]int, key int, val int) map[int][]int {
	_, ok := asterisks[key]
	if !ok {
		asterisks[key] = []int{val}
	} else {
		asterisks[key] = append(asterisks[key], val)
	}
	return asterisks
}

func isDigit(b byte) bool {
	const zero = byte('0')
	const nine = byte('9')
	return b >= zero && b <= nine
}

func isSymbol(b byte) bool {
	const dot = byte('.')
	return !(isDigit(b) || b == dot)
}

func isAsterisk(b byte) bool {
	const asterisk = byte('*')
	return b == asterisk
}
