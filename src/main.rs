mod rectangle;
use rectangle::Rectangle;

fn main() {
    let mut rect1 = Rectangle {
        width: 30,
        height: 50,
    };

    println!(
        "The area of the rectangle is {} square pixels.",
        rect1.area()
    );

    rect1.width = 2;
    println!(
        "The area of the rectangle is {} square pixels.",
        rect1.area()
    );
}
