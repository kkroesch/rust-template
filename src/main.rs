mod rectangle;

fn main() {
    let rect1 = rectangle::Rectangle::new(30, 50);

    println!(
        "The area of the rectangle is {} square pixels.",
        rect1.area()
    );
}
