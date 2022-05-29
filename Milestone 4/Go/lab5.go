package main

import "fmt"

func main() {
	var a, b, c int

	fmt.Print("Enter 3 nums: ")
	fmt.Scan(&a, &b, &c)

	arr := [3]int{a, b, c}

	for i := 0; i < len(arr); i++ {
		if arr[i] > -5 && arr[i] < 5 {
			fmt.Println("OK")
		} else {
			fmt.Println("Wrong")
		}
	}

}
