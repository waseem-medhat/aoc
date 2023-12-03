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
	foundAsterisks := []int{}

	asterisks := map[int][]int{}
    ratioSum := 0

	for i, b := range f {
		if isDigit(b) {
			num = append(num, b)

			// start of a number, check its left (and diagonal left)
			if len(num) == 1 {
				lIsSym, lIsAst := checkLeft(f, i)
				tlIsSym, tlIsAst := checkTopLeft(f, i)
				blIsSym, blIsAst := checkBottomLeft(f, i)

				if lIsSym || tlIsSym || blIsSym {
					isPartNum = true
				}

				if lIsAst {
					foundAsterisks = append(foundAsterisks, i-1)
				}

				if tlIsAst {
					foundAsterisks = append(foundAsterisks, i-lineWidth-1)
				}

                if blIsAst {
					foundAsterisks = append(foundAsterisks, i+lineWidth-1)
                }
			}

			// middle of number, check its top and bottom
			tIsSym, tIsAst := checkTop(f, i)
			bIsSym, bIsAst := checkBottom(f, i)

			if tIsSym || bIsSym {
				isPartNum = true
			}

            if tIsAst {
                foundAsterisks = append(foundAsterisks, i-lineWidth)
            }

            if bIsAst {
                foundAsterisks = append(foundAsterisks, i+lineWidth)
            }

		} else if len(num) > 0 {
			// we're at the right of a number
			rIsSym, rIsAst := checkRight(f, i-1)
			trIsSym, trIsAst := checkTopRight(f, i-1)
			brIsSym, brIsAst := checkBottomRight(f, i-1)

			if rIsSym || trIsSym || brIsSym {
				isPartNum = true
			}

            if rIsAst {
                foundAsterisks = append(foundAsterisks, i)
            }

            if trIsAst {
                foundAsterisks = append(foundAsterisks, i-lineWidth)
            }

            if brIsAst {
                foundAsterisks = append(foundAsterisks, i+lineWidth)
            }

            numInt, _ := strconv.Atoi(string(num))

			if isPartNum {
				partNumSum += numInt
			}

            for _, a := range foundAsterisks {
                asterisks = addAst(asterisks, a, numInt)
            }

			num = []byte{}
			isPartNum = false
            foundAsterisks = []int{}
		}
	}

    for _, nums := range asterisks {
        if len(nums) == 2 {
            ratio := nums[0] * nums[1]
            ratioSum += ratio
        }
    }

	fmt.Println(partNumSum)
	fmt.Println(ratioSum)
}

// checkTop takes a file (byte slice) and an index and checks if the character
// on top of the ith character (if any) is a symbol and if that symbol is an
// asterisk, returning a bool for each check
func checkTop(f []byte, i int) (bool, bool) {
	tChar := dot
	if i > lineWidth {
		tChar = f[i-lineWidth]
	}
	return isSymbol(tChar), isAsterisk(tChar)
}

// checkBottom takes a file (byte slice) and an index and checks if the
// character below the ith character (if any) is a symbol, returning a bool
func checkBottom(f []byte, i int) (bool, bool) {
	bChar := dot
	if (i + lineWidth) < (len(f) - 1) {
		bChar = f[i+lineWidth]
	}
	return isSymbol(bChar), isAsterisk(bChar)
}

// checkLeft takes a file (byte slice) and an index and checks if the character
// to the left of the ith characte is a symbol, returning a bool
func checkLeft(f []byte, i int) (bool, bool) {
	lChar := dot
	if i > 0 {
		lChar = f[i-1]
	}
	return isSymbol(lChar), isAsterisk(lChar)
}

// checkTopLeft takes a file (byte slice) and an index and checks if the
// character on the top left of the ith character is a symbol, returning a bool
func checkTopLeft(f []byte, i int) (bool, bool) {
	tlChar := dot
	if i > lineWidth {
		tlChar = f[i-lineWidth-1]
	}
	return isSymbol(tlChar), isAsterisk(tlChar)
}

// checkBottomLeft takes a file (byte slice) and an index and checks if the
// character on the bottome left of the ith character is a symbol, returning a
// bool
func checkBottomLeft(f []byte, i int) (bool, bool) {
	blChar := dot
	if (i + lineWidth) < (len(f) - 1) {
		blChar = f[i+lineWidth-1]
	}
	return isSymbol(blChar), isAsterisk(blChar)
}

// checkRight takes a file (byte slice) and an index and checks if the
// character on the right of the ith character is a symbol, returning a bool
func checkRight(f []byte, i int) (bool, bool) {
	rChar := dot
	if i < len(f)-1 {
		rChar = f[i+1]
	}
	return isSymbol(rChar), isAsterisk(rChar)
}

// checkTopRight takes a file (byte slice) and an index and checks if the
// character on the top right of the ith character is a symbol, returning a
// bool
func checkTopRight(f []byte, i int) (bool, bool) {
	trChar := dot
	if i > lineWidth {
		trChar = f[i-lineWidth+1]
	}
	return isSymbol(trChar), isAsterisk(trChar)
}

// checkBottomRight takes a file (byte slice) and an index and checks if the
// character on the bottom right of the ith character is a symbol, returning a
// bool
func checkBottomRight(f []byte, i int) (bool, bool) {
	brChar := dot
	if (i + lineWidth) < (len(f) - 1) {
		brChar = f[i+lineWidth+1]
	}
	return isSymbol(brChar), isAsterisk(brChar)
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
	return b >= zero && b <= nine
}

func isSymbol(b byte) bool {
	return !(isDigit(b) || b == dot)
}

func isAsterisk(b byte) bool {
	return b == asterisk
}
