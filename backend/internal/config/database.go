package config

import "os"

type DatabaseConfig struct {
	Host     string
	User     string
	Password string
	Name     string
	Port     string
}

var DbConfig DatabaseConfig = DatabaseConfig{
	Host:     os.Getenv("DB_HOST"),
	User:     os.Getenv("DB_USER"),
	Password: os.Getenv("DB_PASSWORD"),
	Name:     os.Getenv("DB_NAME"),
	Port:     os.Getenv("DB_PORT"),
}
