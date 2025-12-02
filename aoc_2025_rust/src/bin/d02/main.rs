use std::fs;

#[derive(Debug)]
struct Range(u64, u64);

fn main() {
    let test1_ranges = parse(&fs::read_to_string("data/d02/test1.txt").unwrap());
    let input_ranges = parse(&fs::read_to_string("data/d02/input.txt").unwrap());

    let test1_p1: u64 = test1_ranges.iter().map(sum_invalid_ids_p1).sum();
    let input_p1: u64 = input_ranges.iter().map(sum_invalid_ids_p1).sum();

    println!("p1, test1: {}", test1_p1);
    println!("p1, input: {}", input_p1);

    let test1_p2: u64 = test1_ranges.iter().map(sum_invalid_ids_p2).sum();
    let input_p2: u64 = input_ranges.iter().map(sum_invalid_ids_p2).sum();

    println!("p2, test1: {}", test1_p2);
    println!("p2, input: {}", input_p2);
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

fn sum_invalid_ids_p1(range: &Range) -> u64 {
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

fn sum_invalid_ids_p2(range: &Range) -> u64 {
    (range.0..=range.1).filter(is_invalid_id_p2).sum()
}

fn is_invalid_id_p2(id: &u64) -> bool {
    let id_str = id.to_string();
    (1..=(id_str.len() / 2)).any(|window_len| is_invalid_windowed(&id_str, window_len, ""))
}

fn is_invalid_windowed(id_str: &str, window_len: usize, seq: &str) -> bool {
    if window_len > id_str.len() {
        return false;
    }

    let (new_seq, rest) = id_str.split_at(window_len);

    if seq.is_empty() {
        is_invalid_windowed(rest, window_len, new_seq)
    } else if window_len == id_str.len() {
        new_seq == seq
    } else if seq != new_seq {
        false
    } else {
        seq == new_seq && is_invalid_windowed(rest, window_len, seq)
    }
}
