use std::fs;

#[derive(Debug)]
struct Range(u64, u64);

fn main() {
    let test1 = fs::read_to_string("data/d02/test1.txt").unwrap();
    let input = fs::read_to_string("data/d02/input.txt").unwrap();

    let test1_p1: u64 = parse(&test1).iter().map(count_invalid_ids).sum();
    let input_p1: u64 = parse(&input).iter().map(count_invalid_ids).sum();

    println!("p1, test: {}", test1_p1);
    println!("p1, input: {}", input_p1);

    // println!("p2, test: {}", test1_p2);
    // println!("p2, input: {}", input_p2);
}

fn parse(input: &str) -> Vec<Range> {
    input
        .trim()
        .split(',')
        .map(|range_str| match range_str.split_once('-') {
            None => panic!("couldn't parse range {}", range_str),
            Some((a, b)) => Range(
                a.parse().expect("couldn't parse"),
                b.parse().expect("couldn't parse"),
            ),
        })
        .collect()
}

fn count_invalid_ids(range: &Range) -> u64 {
    (range.0..=range.1).filter(is_invalid_id_p1).sum()
}

fn is_invalid_id_p1(id: &u64) -> bool {
    let id_str = id.to_string();
    if id_str.len() % 2 == 1 {
        return false;
    }
    let (a, b) = id_str.split_at(id_str.len() / 2);
    a == b
}
