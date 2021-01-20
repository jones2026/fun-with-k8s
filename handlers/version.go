package handlers

import (
	"log"
	"net/http"
)

var build string

//Version returns an current build sha
func Version(w http.ResponseWriter, r *http.Request) {
	version := build
	if version == "" {
		version = "version_placeholder"
	}

	_, err := w.Write([]byte(version))
	if err != nil {
		log.Fatalf(err.Error())
	}
}
