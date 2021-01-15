package handlers

import (
	"log"
	"net/http"
)

//Health returns 200 status code
func Health(w http.ResponseWriter, r *http.Request) {
	_, err := w.Write([]byte("healthy"))
	if err != nil {
		log.Fatalf(err.Error())
	}
}
