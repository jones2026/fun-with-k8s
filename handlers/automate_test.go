package handlers

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestAutomateHandler(t *testing.T) {
	req, err := http.NewRequest("GET", "/automate", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(Automate)
	handler.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v",
			status, http.StatusOK)
	}

	var jsonResponse AutomateResponse
	err = json.Unmarshal(rr.Body.Bytes(), &jsonResponse)
	if err != nil {
		t.Errorf("expected response in AutomateResponse format, but received error unmarshalling %v",
			err)
	}

	actualMessage := jsonResponse.Message
	expectedMessage := "Automate all the things!"
	if actualMessage != expectedMessage {
		t.Errorf("handler returned wrong message: got %v want %v",
			actualMessage, expectedMessage)
	}
}
