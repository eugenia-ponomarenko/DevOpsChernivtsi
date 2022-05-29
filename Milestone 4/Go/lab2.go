package main

import (
	"fmt"
	"strconv"
)

func main() {
	fmt.Print("Enter something: ")
	var input string
	fmt.Scan(&input)
	if _, err := strconv.Atoi(input); err == nil {
		fmt.Printf("OK")
	} else {
		fmt.Print("Not int")
	}
}
