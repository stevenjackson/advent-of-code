package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
)

func main() {
	data, err := readFile("input.txt")
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Result Freq", Result(data))
	fmt.Println("Repeat Freq", Repeat(data))
}

func Result(data []int) int {
	result := 0
	for _, addend := range data {
		result += addend
	}
	return result
}

func Repeat(data []int) int {
	results := make(map[int]bool)
	sum := 0
	for {
		for _, addend := range data {
			sum += addend
			if results[sum] {
				return sum
			}
			results[sum] = true
		}
	}
}

func readFile(filename string) ([]int, error) {
	var data []int
	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		addend, _ := strconv.Atoi(scanner.Text())
		data = append(data, addend)
	}

	return data, scanner.Err()
}
