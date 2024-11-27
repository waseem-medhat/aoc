package main

import (
	"fmt"
	"os"
	"strings"
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

var pipes = map[rune]func([2]int, Direction, int, int) ([2]int, Direction){
	'|': func(point [2]int, dir Direction, iMax, _ int) ([2]int, Direction) {
		i := point[0]
		j := point[1]
		if dir == S && i < iMax {
			return [2]int{i + 1, j}, S
		}
		if dir == N && i > 0 {
			return [2]int{i - 1, j}, N
		}
		return [2]int{-1, -1}, Stop
	},

	'-': func(point [2]int, dir Direction, _, jMax int) ([2]int, Direction) {
		i := point[0]
		j := point[1]
		if dir == E && j < jMax {
			return [2]int{i, j + 1}, E
		}
		if dir == W && j > 0 {
			return [2]int{i, j - 1}, W
		}
		return [2]int{-1, -1}, Stop
	},

	'L': func(point [2]int, dir Direction, _, jMax int) ([2]int, Direction) {
		i := point[0]
		j := point[1]
		if dir == S && j < jMax {
			return [2]int{i, j + 1}, E
		}
		if dir == W && i > 0 {
			return [2]int{i - 1, j}, N
		}
		return [2]int{-1, -1}, Stop
	},

	'J': func(point [2]int, dir Direction, _, _ int) ([2]int, Direction) {
		i := point[0]
		j := point[1]
		if dir == S && j > 0 {
			return [2]int{i, j - 1}, W
		}
		if dir == E && i > 0 {
			return [2]int{i - 1, j}, N
		}
		return [2]int{-1, -1}, Stop
	},

	'7': func(point [2]int, dir Direction, iMax, _ int) ([2]int, Direction) {
		i := point[0]
		j := point[1]
		if dir == N && j > 0 {
			return [2]int{i, j - 1}, W
		}
		if dir == E && i < iMax {
			return [2]int{i + 1, j}, S
		}
		return [2]int{-1, -1}, Stop
	},

	'F': func(point [2]int, dir Direction, iMax, jMax int) ([2]int, Direction) {
		i := point[0]
		j := point[1]
		if dir == N && j < jMax {
			return [2]int{i, j + 1}, E
		}
		if dir == W && i < iMax {
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

func traverse(maze []string, start [2]int, distances map[int]map[int]int, initDir Direction) {
	iMax := len(maze) - 1
	jMax := len(maze[0]) - 1

	dir := initDir
	point := start

	switch initDir {
	case N:
		point = [2]int{point[0] - 1, point[1]}
	case E:
		point = [2]int{point[0], point[1] + 1}
	case S:
		point = [2]int{point[0] + 1, point[1]}
	case W:
		point = [2]int{point[0], point[1] - 1}
	}

	for dist := 1; dir != Stop; dist++ {
		i := point[0]
		j := point[1]

		if _, ok := distances[i]; !ok {
			distances[i] = map[int]int{}
		}

		if _, ok := distances[i][j]; !ok || dist < distances[i][j] {
			distances[i][j] = dist
		}

		fmt.Printf("%c\n", maze[point[0]][point[1]])
		pipe := rune(maze[point[0]][point[1]])
		pipeFn, ok := pipes[pipe]
		if !ok {
			break
		}
		point, dir = pipeFn(point, dir, iMax, jMax)
	}
}

func main() {
	maze, start := parseMaze("d10/test1.txt")

	fmt.Println(strings.Join(maze, "\n"))
	fmt.Println(start)

	distances := map[int]map[int]int{}
	distances[start[0]] = map[int]int{}
	distances[start[0]][start[1]] = 0

	traverse(maze, start, distances, E)
	traverse(maze, start, distances, S)

	fmt.Printf("%+v\n", distances)
}
