package main

import (
	"log"
	"net/http"

	"github.com/go-chi/chi"
	"github.com/go-chi/chi/middleware"
	"github.com/jones2026/fun-with-k8s/handlers"
)

func main() {
	log.Println("Starting app...")
	r := chi.NewRouter()

	r.Use(middleware.RequestID)
	r.Use(middleware.RealIP)
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)

	r.Route("/api/v1", func(r chi.Router) {
		r.Get("/automate", handlers.Automate)
		r.Get("/healthz", handlers.Health)
		r.Get("/version", handlers.Version)
	})

	port := ":8080"
	log.Println("Listening on port:", port)
	log.Fatalln(http.ListenAndServe(port, r))
}
