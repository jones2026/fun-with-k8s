package handlers

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestVersionHandler(t *testing.T) {
	req, err := http.NewRequest("GET", "/version", nil)
	if err != nil {
		t.Fatal(err)
	}

	expectedVersion := "123456789"
	BuildVersion = expectedVersion
	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(Version)

	handler.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v",
			status, http.StatusOK)
	}

	actualVersion := rr.Body.String()
	if actualVersion != expectedVersion {
		t.Errorf("handler returned wrong status code: got %v want %v",
			actualVersion, expectedVersion)
	}
}
