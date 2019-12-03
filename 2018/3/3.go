package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
)

func main() {
	input, err := readFile("input.txt")
	if err != nil {
		log.Fatal(err)
	}
	claims, err := toClaims(input)
	if err != nil {
		log.Fatal(err)
	}
	fabric := populateFabric(claims)

	fmt.Println("Overlap", ClaimOverlap(fabric))
	fmt.Println("IndependentClaim", IndependentClaimId(fabric))
}

type Claim struct {
	Id     string
	Left   int
	Top    int
	Width  int
	Height int
}

type Fabric [1000][1000][]string

func ClaimOverlap(fabric Fabric) int {
	overlap := 0
	for col := range fabric {
		for row := range fabric[col] {
			if len(fabric[col][row]) > 1 {
				overlap++
			}
		}
	}
	return overlap
}

func IndependentClaimId(fabric Fabric) string {
	possibilities := make(map[string]bool)
	for col := range fabric {
		for row := range fabric[col] {
			claimIds := fabric[col][row]
			claimCount := len(claimIds)
			if claimCount == 1 {
				_, ok := possibilities[claimIds[0]]
				if !ok && claimCount == 1 {
					possibilities[claimIds[0]] = true
				}
			} else {
				for _, claimId := range claimIds {
					possibilities[claimId] = false
				}
			}
		}
	}
	for claimId, solo := range possibilities {
		if solo {
			return claimId
		}
	}
	return ""
}

func populateFabric(claims []Claim) Fabric {
	var fabric Fabric
	for _, c := range claims {
		for col := c.Left; col < c.Left+c.Width; col++ {
			for row := c.Top; row < c.Top+c.Height; row++ {
				position := fabric[col][row]
				fabric[col][row] = append(position, c.Id)
			}
		}
	}
	return fabric
}

func toClaims(input []string) ([]Claim, error) {
	var claims []Claim
	for _, line := range input {
		c, err := toClaim(line)
		if err != nil {
			return nil, err
		}
		claims = append(claims, c)
	}
	return claims, nil
}

func toClaim(input string) (Claim, error) {
	r, _ := regexp.Compile(`#(\d+) @ (\d+),(\d+): (\d+)x(\d+)`)
	match := r.FindStringSubmatch(input)
	id := match[1]
	left, err := strconv.Atoi(match[2])
	top, err := strconv.Atoi(match[3])
	width, err := strconv.Atoi(match[4])
	height, err := strconv.Atoi(match[5])

	if err != nil {
		return Claim{}, err
	}

	return Claim{id, left, top, width, height}, nil
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
