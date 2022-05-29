package main

import "fmt"

func main() {
	fmt.Println("How are you?")

	fmt.Print("Enter an answer: ")
	var input string
	fmt.Scan(&input)

	fmt.Println("You are", input)
}
