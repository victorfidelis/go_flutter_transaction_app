package mocks

import (
	"backend/internal/app/models"
	"time"

	"github.com/stretchr/testify/mock"
)

type MockExchangeClient struct {
	mock.Mock
}

func (m *MockExchangeClient) GetRate(date time.Time, country string) (models.Exchange, error) {
	args := m.Called(date, country)
	return args.Get(0).(models.Exchange), args.Error(1)
}
