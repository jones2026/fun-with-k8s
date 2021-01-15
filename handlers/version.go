package handlers

import (
	"log"
	"net/http"
)

var build string

//Version returns an current build sha
func Version(w http.ResponseWriter, r *http.Request) {
	_, err := w.Write([]byte(build))
	if err != nil {
		log.Fatalf(err.Error())
	}
}
