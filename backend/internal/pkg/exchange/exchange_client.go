package exchange

import (
	"backend/internal/app/models"
	"time"
)

type ExchangeClient interface {
	GetRate(date time.Time, country string) (models.Exchange, error)
}
