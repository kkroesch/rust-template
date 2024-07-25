use objects::rectangle::Rectangle;

#[test]
fn area() {
    let rect1 = Rectangle::new(3, 5);
    assert!(rect1.area() == 15);
}
