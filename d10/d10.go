package main

import (
	"fmt"
	"os"
	"strings"
	"time"
)

type Direction int

const (
	N Direction = iota
	W
	S
	E
	Stop
)

type Link int

const (
	NS Link = iota // |
	EW             // -
	NE             // L
	NW             // J
	SW             // 7
	SE             // F
)

var pipes = map[rune]func([2]int, Direction) ([2]int, Direction){
	'|': func(point [2]int, dir Direction) ([2]int, Direction) {
		i := point[0]
		j := point[1]
		if dir == S {
			return [2]int{i + 1, j}, S
		}
		if dir == N {
			return [2]int{i - 1, j}, N
		}
		return [2]int{-1, -1}, Stop
	},

	'-': func(point [2]int, dir Direction) ([2]int, Direction) {
		i := point[0]
		j := point[1]
		if dir == E {
			return [2]int{i, j + 1}, E
		}
		if dir == W {
			return [2]int{i, j - 1}, W
		}
		return [2]int{-1, -1}, Stop
	},

	'L': func(point [2]int, dir Direction) ([2]int, Direction) {
		i := point[0]
		j := point[1]
		if dir == S {
			return [2]int{i, j + 1}, E
		}
		if dir == W {
			return [2]int{i - 1, j}, N
		}
		return [2]int{-1, -1}, Stop
	},

	'J': func(point [2]int, dir Direction) ([2]int, Direction) {
		i := point[0]
		j := point[1]
		if dir == S {
			return [2]int{i, j - 1}, W
		}
		if dir == E {
			return [2]int{i - 1, j}, N
		}
		return [2]int{-1, -1}, Stop
	},

	'7': func(point [2]int, dir Direction) ([2]int, Direction) {
		i := point[0]
		j := point[1]
		if dir == N {
			return [2]int{i, j - 1}, W
		}
		if dir == E {
			return [2]int{i + 1, j}, S
		}
		return [2]int{-1, -1}, Stop
	},

	'F': func(point [2]int, dir Direction) ([2]int, Direction) {
		i := point[0]
		j := point[1]
		if dir == N {
			return [2]int{i, j + 1}, E
		}
		if dir == W {
			return [2]int{i + 1, j}, S
		}
		return [2]int{-1, -1}, Stop
	},
}

// func parseMaze reads the file and parses the maze
func parseMaze(path string) (lines []string, start [2]int) {
	f, _ := os.ReadFile(path)
	lines = strings.Split(string(f), "\n")

	for i, l := range lines {
		for j, c := range l {
			if c == 'S' {
				start = [2]int{i, j}
				return lines, start
			}
		}
	}

	return lines, start
}

func tryMove(a, b [2]int, dir Direction) {
}

func main() {
	maze, start := parseMaze("d10/test1.txt")
	fmt.Println(strings.Join(maze, "\n"))
	fmt.Println(start)
	point := [2]int{1, 2}
	dir := E
	for {
		pipe := rune(maze[point[0]][point[1]])
		pipeFn, ok := pipes[pipe]
		if !ok {
			return
		}
		point, dir = pipeFn(point, dir)
		fmt.Printf("%c\n", maze[point[0]][point[1]])
		time.Sleep(1 * time.Second)
	}
}
