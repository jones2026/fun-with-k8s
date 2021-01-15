package handlers

import (
	"encoding/json"
	"log"
	"net/http"
	"time"
)

//AutomateResponse contains a message and the current unix timestamp
type AutomateResponse struct {
	Message   string `json:"message"`
	Timestamp int64  `json:"timestamp"`
}

//Automate returns an AutomateResponse in json
func Automate(w http.ResponseWriter, r *http.Request) {
	response := AutomateResponse{
		Message:   "Automate all the things!",
		Timestamp: time.Now().Unix(),
	}

	w.Header().Set("Content-Type", "application/json")
	enc := json.NewEncoder(w)
	enc.SetIndent("", "  ")
	err := enc.Encode(response)
	if err != nil {
		log.Println(err.Error())
	}
}
