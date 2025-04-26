package models

import "time"

type TransactionWithExchange struct {
	Id             int       `json:"id"`
	Description    string    `json:"description"`
	Date           time.Time `json:"date"`
	OriginalValue  float64   `json:"original_value"`
	Country        string    `json:"country"`
	Currency       string    `json:"currency"`
	ExchangeRate   float64   `json:"exchange_rate"`
	ConvertedValue float64   `json:"converted_value"`
	EffectiveDate  time.Time `json:"effective_date"`
}
