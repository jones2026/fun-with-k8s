package handlers

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestVersionHandler(t *testing.T) {
	req, err := http.NewRequest("GET", "/api/v1/version", nil)
	if err != nil {
		t.Fatal(err)
	}
	originalBuild := build
	defer func() { build = originalBuild }()
	expectedVersion := "123456789"
	build = expectedVersion
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

func TestDefaultVersionHandler(t *testing.T) {
	req, err := http.NewRequest("GET", "/api/v1/version", nil)
	if err != nil {
		t.Fatal(err)
	}

	expectedVersion := "version_placeholder"
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
