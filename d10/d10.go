package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	maze, start := parseMaze("d10/test1.txt")
	fmt.Println(strings.Join(maze, "\n"))
	lookup(maze, start, 0)
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

func lookup(maze []string, point [2]int, steps int) {
	i := point[0]
	j := point[1]

	if i > 0 {
		fmt.Printf("Up: %c\n", maze[i-1][j])
	}

	if j > 0 {
		fmt.Printf("Left: %c\n", maze[i][j-1])
	}

	if i < len(maze)-1 {
		fmt.Printf("Down: %c\n", maze[i+1][j])
	}

	if j < len(maze[i])-1 {
		fmt.Printf("Right: %c\n", maze[i][j+1])
	}
}
