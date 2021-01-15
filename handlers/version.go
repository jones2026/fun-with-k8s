package handlers

import (
	"log"
	"net/http"
)

//BuildVersion is the current build sha
var BuildVersion string

//Version returns an current build sha
func Version(w http.ResponseWriter, r *http.Request) {
	_, err := w.Write([]byte(BuildVersion))
	if err != nil {
		log.Fatalf(err.Error())
	}
}
