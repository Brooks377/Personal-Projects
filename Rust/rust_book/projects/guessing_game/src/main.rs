use rand::Rng;
use std::cmp::Ordering;
use std::io;
use std::io::Write;

fn main() {
    let secret_number = rand::thread_rng().gen_range(1..=100);

    loop {
        println!("Guess the number!");
        print!("Please input your guess: ");
        // ensure that the stdout doesn't buffer until eol (necessary for print! but not println!)
        io::stdout() // fmt comment
            .flush()
            .expect("Failed to flush");

        let mut guess = String::new();
        io::stdin()
            .read_line(&mut guess)
            .expect("Failed to read line");

        let guess = match guess.trim().parse::<u32>() {
            Ok(num) => num,
            Err(_) => {
                if guess.trim().eq_ignore_ascii_case("quit") {
                    println!("Thanks for playing! Goodbye!");
                    break;
                } else {
                    println!("\nYou must enter an int in 1..=100.\n");
                    continue;
                }
            }
        };

        println!("You guessed: {}", guess);

        match guess.cmp(&secret_number) {
            Ordering::Less => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal => {
                println!("You win!!");
                break;
            }
        }
        println!();
    }
}
