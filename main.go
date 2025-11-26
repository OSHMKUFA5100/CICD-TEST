package main

import (
	"fmt"
	jsoniter "github.com/json-iterator/go"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, CI/CD with Go!")
	})
	fmt.Println("CI/CD-TEST Server listening on port 8080...")
	fmt.Println("CI/CD-TEST Server listening on port 8080...")
	test := Test{Name: "Te"}
	result, _ := jsoniter.MarshalToString(test)
	fmt.Println(result)
	//
	http.ListenAndServe(":8080", nil)
}

type Test struct {
	Name string
}
