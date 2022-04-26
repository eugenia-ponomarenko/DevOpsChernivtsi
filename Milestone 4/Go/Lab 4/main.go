package main

import (
	"fmt"
	"math"
)

func main() {

	var a, b, c float64
	fmt.Print("Enter a: ")
	fmt.Scan(&a)

	fmt.Print("Enter b: ")
	fmt.Scan(&b)

	fmt.Print("Enter c: ")
	fmt.Scan(&c)

	min1 := math.Min(a, b)
	min2 := math.Min(min1, c)

	max1 := math.Max(a, b)
	max2 := math.Max(max1, c)

	fmt.Println("Min: ", min2)
	fmt.Println("Max: ", max2)
}
