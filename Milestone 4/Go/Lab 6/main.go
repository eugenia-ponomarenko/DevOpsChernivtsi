package main

import (
	"fmt"
	"strings"
)

func main() {
	var str string

	fmt.Print("Enter some word to split it: ")
	fmt.Scan(&str)

	sep := strings.Split(str, "")

	for _, l := range sep {
		fmt.Println(l)
	}
}
