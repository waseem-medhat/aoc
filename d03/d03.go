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
			if len(num) == 1 {
				if checkLeft(f, i) || checkTopLeft(f, i) || checkBottomLeft(f, i) {
					isPartNum = true
				}
			}

			// middle of number, check its top and bottom
			if checkTop(f, i) || checkBottom(f, i) {
				isPartNum = true
			}

		} else if len(num) > 0 {
			// we're at the right of a number
			if checkRight(f, i-1) || checkTopRight(f, i-1) || checkBottomRight(f, i-1) {
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

// checkTop takes a file (byte slice) and an index and checks if the character
// on top of the ith character (if any) is a symbol, returning a bool
func checkTop(f []byte, i int) bool {
	tChar := dot
	if i > lineWidth {
		tChar = f[i-lineWidth]
	}
	return isSymbol(tChar)
}

// checkBottom takes a file (byte slice) and an index and checks if the
// character below the ith character (if any) is a symbol, returning a bool
func checkBottom(f []byte, i int) bool {
	bChar := dot
	if (i + lineWidth) < (len(f) - 1) {
		bChar = f[i+lineWidth]
	}
	return isSymbol(bChar)
}

// checkLeft takes a file (byte slice) and an index and checks if the character
// to the left of the ith characte is a symbol, returning a bool
func checkLeft(f []byte, i int) bool {
	lChar := dot
	if i > 0 {
		lChar = f[i-1]
	}
	return isSymbol(lChar)
}

// checkTopLeft takes a file (byte slice) and an index and checks if the
// character on the top left of the ith character is a symbol, returning a bool
func checkTopLeft(f []byte, i int) bool {
	tlChar := dot
	if i > lineWidth {
		tlChar = f[i-lineWidth-1]
	}
	return isSymbol(tlChar)
}

// checkBottomLeft takes a file (byte slice) and an index and checks if the
// character on the bottome left of the ith character is a symbol, returning a
// bool
func checkBottomLeft(f []byte, i int) bool {
	blChar := dot
	if (i + lineWidth) < (len(f) - 1) {
		blChar = f[i+lineWidth-1]
	}
	return isSymbol(blChar)
}

// checkRight takes a file (byte slice) and an index and checks if the
// character on the right of the ith character is a symbol, returning a bool
func checkRight(f []byte, i int) bool {
	rChar := dot
	if i < len(f)-1 {
		rChar = f[i+1]
	}
	return isSymbol(rChar)
}

// checkTopRight takes a file (byte slice) and an index and checks if the
// character on the top right of the ith character is a symbol, returning a
// bool
func checkTopRight(f []byte, i int) bool {
	trChar := dot
	if i > lineWidth {
		trChar = f[i-lineWidth+1]
	}
	return isSymbol(trChar)
}

// checkBottomRight takes a file (byte slice) and an index and checks if the
// character on the bottom right of the ith character is a symbol, returning a
// bool
func checkBottomRight(f []byte, i int) bool {
	brChar := dot
	if (i + lineWidth) < (len(f) - 1) {
		brChar = f[i+lineWidth+1]
	}
	return isSymbol(brChar)
}

func isDigit(b byte) bool {
	return b >= zero && b <= nine
}

func isSymbol(b byte) bool {
	return !(isDigit(b) || b == dot)
}

func isAsterisk(b byte) bool {
	return b == asterisk
}
