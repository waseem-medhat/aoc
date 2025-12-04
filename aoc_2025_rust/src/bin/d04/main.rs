use std::fs;

fn main() {
    let test1 = fs::read_to_string("data/d04/test1.txt").unwrap();
    let input = fs::read_to_string("data/d04/input.txt").unwrap();

    println!("p1, test1: {}", solve_p1(&parse(&test1)));
    println!("p1, input: {}", solve_p1(&parse(&input)));

    println!("p2, test1: {}", solve_p2(&mut parse(&test1)));
    println!("p2, input: {}", solve_p2(&mut parse(&input)));
}

type Map = Vec<Vec<char>>;

fn parse(input: &str) -> Map {
    input.lines().map(|line| line.chars().collect()).collect()
}

fn solve_p1(map: &Map) -> u16 {
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

fn solve_p2(map: &mut Map) -> u16 {
    let mut count = 0;
    loop {
        let mut removed_in_loop = 0;
        for i in 0..map.len() {
            let line = &map[i];
            for j in 0..line.len() {
                if map[i][j] == '@' && count_adjacent(map, i, j) < 4 {
                    map[i][j] = '.';
                    removed_in_loop += 1;
                }
            }
        }
        if removed_in_loop == 0 {
            break;
        }
        count += removed_in_loop;
    }
    count
}

fn count_adjacent(map: &Map, line_idx: usize, char_idx: usize) -> u16 {
    let last_line_idx = map.len() - 1;
    let last_char_idx = map[line_idx].len() - 1;

    // clamped indices to be used for top and bottom slices
    let clamped_left_idx = char_idx.saturating_sub(1);
    let clamped_right_idx = (char_idx + 1).min(last_char_idx);

    let mut count = 0;

    // top 3
    if line_idx != 0 {
        let top_slice = &map[line_idx - 1][clamped_left_idx..=clamped_right_idx];
        count += top_slice
            .iter()
            .map(|char| (*char == '@') as u16)
            .sum::<u16>()
    }

    // bottom 3
    if line_idx != last_line_idx {
        let bottom_slice = &map[line_idx + 1][clamped_left_idx..=clamped_right_idx];
        count += bottom_slice
            .iter()
            .map(|char| (*char == '@') as u16)
            .sum::<u16>()
    }

    // left
    count += (char_idx != 0 && map[line_idx][char_idx - 1] == '@') as u16;

    // right
    count += (char_idx != last_char_idx && map[line_idx][char_idx + 1] == '@') as u16;

    count
}
