package models

import (
	"time"

	_ "gorm.io/gorm"
)

type Transaction struct {
	Id          int       `json:"id" gorm:"primaryKey;autoIncrement"`
	Description string    `json:"description"`
	Date        time.Time `json:"date"`
	Amount      float64   `json:"amount"`
}

func NewTransaction(description string, date time.Time, amount float64) *Transaction {
	return &Transaction{
		Description: description,
		Date:        date,
		Amount:      amount,
	}
}
