use std::fs;

fn main() {
    let test1 = fs::read_to_string("data/d01/test1.txt").unwrap();
    let (test1_p1, test1_p2) = count(&test1);

    let input = fs::read_to_string("data/d01/input.txt").unwrap();
    let (input_p1, input_p2) = count(&input);

    println!("p1, test: {}", test1_p1);
    println!("p1, input: {}", input_p1);

    println!("p2, test: {}", test1_p2);
    println!("p2, input: {}", input_p2);
}

fn count(input: &str) -> (i16, i16) {
    // acc tuple: (new_val, times ended at 0, times passed thru 0)
    let (_, ends_at_zero, passes_thru_zero) = input.lines().fold((50, 0, 0), |acc, line| {
        let (direction, rotation) = parse_line(line);

        let rotated = (acc.0 + (direction * rotation)) % 100;
        let new_val = if rotated < 0 { rotated + 100 } else { rotated };
        let passes = passes_thru_zero(acc.0, new_val, direction, rotation);

        if new_val == 0 {
            (new_val, acc.1 + 1, acc.2 + passes)
        } else {
            (new_val, acc.1, acc.2 + passes)
        }
    });

    (ends_at_zero, passes_thru_zero)
}

fn parse_line(line: &str) -> (i16, i16) {
    let mut chars = line.chars();
    let direction = match chars.next().unwrap() {
        'L' => -1,
        'R' => 1,
        _ => panic!("unexpected char"),
    };
    let rotation_str: String = chars.collect();
    let rotation: i16 = rotation_str.parse().expect("unexpected parse str");

    (direction, rotation)
}

fn passes_thru_zero(old_val: i16, new_val: i16, direction: i16, rotation: i16) -> i16 {
    let wrapped = (old_val != 0 && new_val > old_val && direction == -1)
        || (new_val < old_val && direction == 1);

    let full_rotations = rotation / 100;
    if (new_val == 0 && old_val != 0) || wrapped {
        full_rotations + 1
    } else {
        full_rotations
    }
}
