package main

import (
	"fmt"
	"os"
	"strconv"
)

const lineWidth = 140

const zero = byte('0')
const nine = byte('9')
const dot = byte('.')
const newLine = byte('\n')
const asterisk = byte('*')

func main() {
	fPre, _ := os.ReadFile("d03/d03input.txt")
	f := []byte{}
	for _, b := range fPre {
		if b != newLine {
			f = append(f, b)
		}
	}

	num := []byte{}
	isPartNum := false
	partNumSum := 0

	for i, b := range f {
		if isDigit(b) {
			num = append(num, b)

			// start of a number, check its left (and diagonal left)
			if len(num) == 1 && checkLeft(f, i) {
				isPartNum = true
			}

			// middle of number, check its top and bottom
			if checkTopBottom(f, i) {
				isPartNum = true
			}

		} else if len(num) > 0 {
			// we're at the right of a number
			if checkRight(f, i-1) {
				isPartNum = true
			}

			if isPartNum {
				numInt, _ := strconv.Atoi(string(num))
				partNumSum += numInt
			}

			num = []byte{}
			isPartNum = false
		}
	}

	fmt.Println(partNumSum)
}

// checkTopBottom takes a file (byte slice) and an index and checks if any of
// characters on the top and bottom of the ith character (if any) is a symbol,
// returning a bool
func checkTopBottom(f []byte, i int) bool {
	// default values are dots to evaluate to false in the last comparison
	tChar := dot
	bChar := dot

	// top
	if i > lineWidth {
		tChar = f[i-lineWidth]
	}

	// bottom left
	if (i + lineWidth) < (len(f) - 1) {
		bChar = f[i+lineWidth]
	}

	return isSymbol(tChar) || isSymbol(bChar)
}

// checkLeft takes a file (byte slice) and an index and checks if any of
// characters on the left of the ith character (including top left and bottom
// left if any) is a symbol, returning a bool
func checkLeft(f []byte, i int) bool {
	// default values are dots to evaluate to false in the last comparison
	lChar := dot
	tlChar := dot
	blChar := dot

	// left
	if i > 0 {
		lChar = f[i-1]
	}

	// top left
	if i > lineWidth {
		tlChar = f[i-lineWidth-1]
	}

	// bottom left
	if (i + lineWidth) < (len(f) - 1) {
		blChar = f[i+lineWidth-1]
	}

	return isSymbol(lChar) || isSymbol(tlChar) || isSymbol(blChar)
}

// checkRight takes a file (byte slice) and an index and checks if any of
// characters on the right of the ith character (including top right and bottom
// right if any) is a symbol, returning a bool
func checkRight(f []byte, i int) bool {
	// default values are dots to evaluate to false in the last comparison
	rChar := dot
	trChar := dot
	brChar := dot

	// right
	if i < len(f)-1 {
		rChar = f[i+1]
	}

	// top right
	if i > lineWidth {
		trChar = f[i-lineWidth+1]
	}

	// bottom right
	if (i + lineWidth) < (len(f) - 1) {
		brChar = f[i+lineWidth+1]
	}

	return isSymbol(rChar) || isSymbol(trChar) || isSymbol(brChar)
}

func isDigit(b byte) bool {
	return b >= zero && b <= nine
}

func isSymbol(b byte) bool {
	return !(isDigit(b) || b == dot)
}
