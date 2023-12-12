package main

import "fmt"

func applyRuleset(rng numRange, rs []rule) []numRange {
	calcRanges := []numRange{}
	for _, r := range rs {
		match, pass := applyRule(rng, r)

		if pass == (numRange{0, 0}) {
			calcRanges = append(calcRanges, match)
			return calcRanges
		}

		if match == (numRange{0, 0}) {
			continue
		}

		calcRanges = append(calcRanges, match)
		rng = pass
	}

	if rng != (numRange{0, 0}) {
		calcRanges = append(calcRanges, rng)
	}

	return calcRanges
}

// applyRule takes a range and a single rule, applies the rule if it matches,
// and returns the matched range and the passed range
func applyRule(rng numRange, rule rule) (match numRange, pass numRange) {
	diff := rule.dstStart - rule.srcStart

	if rng.start >= rule.srcStart && rng.end <= rule.srcEnd {
		fmt.Println("Range", rng, "contained in rule", rule)

		match = numRange{
			start: rng.start + diff,
			end:   rng.end + diff,
		}

		return match, pass
	}

	if rng.start >= rule.srcStart && rng.start <= rule.srcEnd {
		fmt.Println("Range", rng, "left is overlapping with rule", rule)

		match = numRange{
			start: rng.start + diff,
			end:   rule.srcEnd + diff,
		}

		pass = numRange{
			start: rule.srcEnd + 1,
			end:   rng.end,
		}

		return match, pass
	}

	if rng.end >= rule.srcStart && rng.end <= rule.srcEnd {
		fmt.Println("Range", rng, "right is overlapping with rule", rule)

		pass = numRange{
			start: rng.start,
			end:   rule.srcStart - 1,
		}

		match = numRange{
			start: rule.srcStart + diff,
			end:   rng.end + diff,
		}

		return match, pass
	}

	pass = rng
	return match, pass
}
