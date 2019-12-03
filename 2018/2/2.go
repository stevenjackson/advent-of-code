package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

func main() {
	ids, err := readFile("input.txt")
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Checksum", CheckSum(ids))
	fmt.Println("SimilarId", FindTheCommonId(ids))
}

func CheckSum(ids []string) int {
	histograms := toHistograms(ids)
	twos := 0
	threes := 0
	for _, histogram := range histograms {
		if check(histogram, 2) {
			twos++
		}
		if check(histogram, 3) {
			threes++
		}
	}

	return twos * threes
}

func check(histogram map[rune]int, count int) bool {
	for _, v := range histogram {
		if v == count {
			return true
		}
	}
	return false
}

func toHistograms(ids []string) []map[rune]int {
	var histograms []map[rune]int
	for _, id := range ids {
		histogram := make(map[rune]int)
		for _, char := range id {
			histogram[char] += 1
		}
		histograms = append(histograms, histogram)
	}
	return histograms
}

func FindTheCommonId(ids []string) string {
	var matches []string
	for idx, toMatch := range ids {
		for _, id := range ids[idx+1:] {
			if within1Char(id, toMatch) {
				matches = append(matches, toMatch)
				matches = append(matches, id)
			}
		}
	}
	var common []byte
	for idx := range matches[0] {
		if matches[0][idx] == matches[1][idx] {
			common = append(common, matches[0][idx])
		}
	}
	return string(common)
}

func within1Char(id1 string, id2 string) bool {
	misses := 0
	for idx := range id1 {
		if id1[idx] != id2[idx] {
			misses++
		}
	}

	return misses <= 1
}

func readFile(filename string) ([]string, error) {
	var data []string
	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		data = append(data, scanner.Text())
	}

	return data, scanner.Err()
}
