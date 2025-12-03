use std::fs;

fn main() {
    let test1 = fs::read_to_string("data/d03/test1.txt").unwrap();
    let input = fs::read_to_string("data/d03/input.txt").unwrap();

    println!("p1, test1: {}", solve(&test1));
    println!("p1, input: {}", solve(&input));

    // println!("p2, test1: {}", test1_p2);
    // println!("p2, input: {}", input_p2);
}

fn solve(input: &str) -> u32 {
    input
        .lines()
        .map(|l| calc_max_jolt(l.chars().collect()))
        .sum()
}

fn calc_max_jolt(digits: Vec<char>) -> u32 {
    let mut max_digit_1 = digits[0];
    let mut max_digit_2 = digits[0];

    for i in 0..digits.len() {
        if digits[i] > max_digit_1 && i < digits.len() - 1 {
            max_digit_1 = digits[i];
            max_digit_2 = digits[i + 1];
        } else if digits[i] == max_digit_1 || digits[i] > max_digit_2 {
            max_digit_2 = digits[i]
        }
    }

    format!("{max_digit_1}{max_digit_2}").parse().unwrap()
}
