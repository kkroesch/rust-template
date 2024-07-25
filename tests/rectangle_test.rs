use objects::rectangle::Rectangle;

#[test]
fn area() {
    let rect1 = Rectangle {
        width: 3,
        height: 5,
    };
    assert!(rect1.area() == 15);
}
