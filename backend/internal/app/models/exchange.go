package models

import (
	"strconv"
	"time"
)

type Exchange struct {
	RecordDate          string `json:"record_date"`
	Country             string `json:"country"`
	Currency            string `json:"rate"`
	CountryCurrencyDesc string `json:"country_currency_desc"`
	ExchangeRate        string `json:"exchange_rate_type"`
	EffectiveDate       string `json:"effective_date"`
}

func (e *Exchange) EffectiveDateParsed() (time.Time, error) {
	parsed, err := time.Parse("2006-01-02", e.EffectiveDate)
	if err != nil {
		return time.Time{}, err
	}
	return parsed, nil
}

func (e *Exchange) ExchangeRateParse() (float64, error) {
	parsed, err := strconv.ParseFloat(e.ExchangeRate, 64)
	if err != nil {
		return 0, err
	}
	return parsed, nil
}
