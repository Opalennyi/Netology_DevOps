package main

const (
	limit   = 100 // Upper limit for the numbers
	divider = 3   // The divider of all the returned values
)

func main() {
	for i := 1; i <= limit; i++ {
		if i%divider == 0 {
			println(i)
		}
	}
}
