package main

import "fmt"

func main() {
	var x = []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}

	var min = x[0]

	for _, i := range x[1:] {
		if i < min {
			min = i
		}
	}

	fmt.Println("The minimal value is ", min)
}
