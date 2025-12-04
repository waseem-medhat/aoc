use std::fs;

fn main() {
    let test1 = fs::read_to_string("data/d04/test1.txt").unwrap();
    let input = fs::read_to_string("data/d04/input.txt").unwrap();

    println!("p1, test1: {}", solve(&parse(&test1)));
    println!("p1, input: {}", solve(&parse(&input)));

    // println!("p2, test1: {}", solve(&test1));
    // println!("p2, input: {}", input_p2);
}

type Map = Vec<Vec<char>>;

fn parse(input: &str) -> Map {
    input.lines().map(|line| line.chars().collect()).collect()
}

fn solve(map: &Map) -> u16 {
    let mut count = 0;
    for i in 0..map.len() {
        let line = &map[i];
        for j in 0..line.len() {
            if map[i][j] == '@' && count_adjacent(map, i, j) < 4 {
                count += 1;
            }
        }
    }
    count
}

fn count_adjacent(map: &Map, line_idx: usize, char_idx: usize) -> u16 {
    let last_line_idx = map.len() - 1;
    let last_char_idx = map[line_idx].len() - 1;

    let top = (line_idx != 0 && map[line_idx - 1][char_idx] == '@') as u16;

    let top_left =
        (line_idx != 0 && char_idx != 0 && map[line_idx - 1][char_idx - 1] == '@') as u16;

    let top_right = (line_idx != 0
        && char_idx != last_char_idx
        && map[line_idx - 1][char_idx + 1] == '@') as u16;

    let bottom = (line_idx != last_line_idx && map[line_idx + 1][char_idx] == '@') as u16;

    let bottom_left = (line_idx != last_line_idx
        && char_idx != 0
        && map[line_idx + 1][char_idx - 1] == '@') as u16;

    let bottom_right = (line_idx != last_line_idx
        && char_idx != last_char_idx
        && map[line_idx + 1][char_idx + 1] == '@') as u16;

    let left = (char_idx != 0 && map[line_idx][char_idx - 1] == '@') as u16;

    let right = (char_idx != last_char_idx && map[line_idx][char_idx + 1] == '@') as u16;

    top + top_left + top_right + bottom + bottom_left + bottom_right + left + right
}
