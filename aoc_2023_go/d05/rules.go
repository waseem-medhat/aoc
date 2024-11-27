package main

import "fmt"

func applyRuleset(rng numRange, rs []rule) []numRange {
	calcRanges := []numRange{}
	toCheck := []numRange{rng}

	fmt.Println("---")
	for len(toCheck) > 0 {
		rng = toCheck[0]
		toCheck = toCheck[1:]

		for _, r := range rs {
			match, passes := applyRule(rng, r)

			// no passes, so matching is done
			if len(passes) == 0 {
				calcRanges = append(calcRanges, match)
				return calcRanges
			}

			// no match, try next rule
			if match == (numRange{0, 0}) {
				continue
			}

			// match with >=1 passes
			calcRanges = append(calcRanges, match)
			toCheck = append(toCheck, passes...)

			rng = passes[0]
			toCheck = toCheck[1:]
		}
	}

	if rng != (numRange{0, 0}) {
		calcRanges = append(calcRanges, rng)
	}

	return calcRanges
}

// applyRule takes a range and a single rule, applies the rule if it matches,
// and returns the matched range and the passed range
func applyRule(rng numRange, rule rule) (match numRange, passes []numRange) {
	diff := rule.dstStart - rule.srcStart

	if rng.start >= rule.srcStart && rng.end <= rule.srcEnd {
		fmt.Println("Range", rng, "contained in rule", rule)

		match = numRange{
			start: rng.start + diff,
			end:   rng.end + diff,
		}

		return match, passes
	}

	if rng.start >= rule.srcStart && rng.start <= rule.srcEnd {
		fmt.Println("Range", rng, "left is overlapping with rule", rule)

		match = numRange{
			start: rng.start + diff,
			end:   rule.srcEnd + diff,
		}

		passes = append(passes, numRange{
			start: rule.srcEnd + 1,
			end:   rng.end,
		})

		return match, passes
	}

	if rng.end >= rule.srcStart && rng.end <= rule.srcEnd {
		fmt.Println("Range", rng, "right is overlapping with rule", rule)

		passes = append(passes, numRange{
			start: rng.start,
			end:   rule.srcStart - 1,
		})

		match = numRange{
			start: rule.srcStart + diff,
			end:   rng.end + diff,
		}

		return match, passes
	}

	return match, []numRange{rng}
}
