package main

import "fmt"

func add(x, y float32) float32 {
	return x + y
}

func sub(x, y float32) float32 {
	return x - y
}

func mult(x, y float32) float32 {
	return x * y
}

func div(x, y float32) float32 {
	if y == 0 {
		panic("you can not divide to 0")
	}
	return x / y
}

func calculate(x float32, y float32, o float32) {
	switch o {
	case 1:
		fmt.Println(add(x, y))
		break
	case 2:
		fmt.Println(sub(x, y))
		break
	case 3:
		fmt.Println(mult(x, y))
		break
	case 4:
		fmt.Println(div(x, y))
		break
	}

}

func main() {

	var a, b float32
	var operation float32
	fmt.Print("Enter a: ")
	fmt.Scan(&a)

	fmt.Print("Enter b: ")
	fmt.Scan(&b)

	fmt.Print("Choose operation: 1 = add, 2 = sub, 3 = mult, 4 = div: ")
	fmt.Scan(&operation)

	calculate(a, b, operation)

}
