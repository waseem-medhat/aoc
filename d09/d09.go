package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	histories := parseHistories("d09/input.txt")

	fwExtSum := 0
	bwExtSum := 0

	for _, h := range histories {
		hSeqs := calcHistorySeqs(h)
		fwExtSum += extrapolateFw(hSeqs)
		bwExtSum += extrapolateBw(hSeqs)
	}

	fmt.Println(fwExtSum)
	fmt.Println(bwExtSum)

}

// extrapolateBw does the backward extrapolation (for part 2) of sequences
// generated from calcHistorySeqs and returns the final value of the
// extrapolation process
func extrapolateBw(historySeqs [][]int) int {
	firstVals := []int{}
	for _, seq := range historySeqs {
		firstVals = append(firstVals, seq[0])
	}

	extVal := 0
	for i := len(firstVals) - 2; i >= 0; i-- {
		extVal += firstVals[i]
	}

	return extVal
}

// extrapolateFw does the forward extrapolation (for part 1) of sequences
// generated from calcHistorySeqs and returns the final value of the
// extrapolation process
func extrapolateFw(historySeqs [][]int) int {
	lastVals := []int{}
	for _, seq := range historySeqs {
		lastVals = append(lastVals, seq[len(seq)-1])
	}

	extVal := 0
	for i := len(lastVals) - 2; i >= 0; i-- {
		extVal += lastVals[i]
	}

	return extVal
}

func calcHistorySeqs(history []int) [][]int {
	seqs := [][]int{history}

	allZeroes := false
	for !allZeroes {
		allZeroes = true
		seq := seqs[len(seqs)-1]
		newSeq := []int{}

		for i := 1; i < len(seq); i++ {
			num := seq[i] - seq[i-1]
			newSeq = append(newSeq, num)
			if num != 0 {
				allZeroes = false
			}
		}

		seqs = append(seqs, newSeq)
	}

	return seqs
}

func parseHistories(path string) [][]int {
	f, _ := os.Open(path)
	defer f.Close()

	histories := [][]int{}

	s := bufio.NewScanner(f)
	for s.Scan() {
		history := []int{}
		fields := strings.Fields(s.Text())
		for _, f := range fields {
			num, _ := strconv.Atoi(f)
			history = append(history, num)
		}
		histories = append(histories, history)
	}

	return histories
}
