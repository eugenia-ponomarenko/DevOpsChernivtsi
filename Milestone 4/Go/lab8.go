package main

import "fmt"

func findMinAndMax(arr [3]int) (min int, max int) {
	min = arr[0]
	max = arr[0]
	for _, value := range arr {
		if value < min {
			min = value
		}
		if value > max {
			max = value
		}
	}
	return min, max
}

func main() {

	var a, b, c int
	fmt.Print("Enter a: ")
	fmt.Scan(&a)

	fmt.Print("Enter b: ")
	fmt.Scan(&b)

	fmt.Print("Enter c: ")
	fmt.Scan(&c)

	var arr = [3]int{a, b, c}
	min, max := findMinAndMax(arr)
	fmt.Println("Min: ", min)
	fmt.Println("Max: ", max)
}
