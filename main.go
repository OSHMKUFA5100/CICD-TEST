package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, CI/CD with Go!")
	})
	fmt.Println("CI/CD-TEST Server listening on port 8080...")
	fmt.Println("CI/CD-TEST Server listening on port 8080...")
	http.ListenAndServe(":8080", nil)
}
