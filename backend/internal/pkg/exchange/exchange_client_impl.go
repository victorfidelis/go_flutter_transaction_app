package exchange

import (
	"backend/internal/app/models"
	"encoding/json"
	"errors"
	"net/http"
	"time"
)

const baseUrl = "https://api.fiscaldata.treasury.gov/services/api/fiscal_service/v1"
const ratesEndpoint = "/accounting/od/rates_of_exchange"

const pageNumber = "page[number]=1"
const pageSize = "page[size]=1"
const fields = "fields=record_date,country,currency,country_currency_desc,exchange_rate,effective_date"
const sort = "sort=-effective_date"

type bodyRatesRespose struct {
	Data []models.Exchange `json:"data"`
}

type ExchangeClientImpl struct{}

func NewExchangeClientImpl() *ExchangeClientImpl {
	return &ExchangeClientImpl{}
}

func (e *ExchangeClientImpl) GetRate(
	date time.Time,
	currency string,
) (models.Exchange, error) {
	filter := buildFilter(date, currency)
	url := baseUrl + ratesEndpoint + "?" + pageNumber + "&" + pageSize + "&" +
		fields + "&" + sort + "&" + filter

	client := &http.Client{}

	resp, err := client.Get(url)
	if err != nil {
		return models.Exchange{}, err
	}

	var body bodyRatesRespose
	if err := json.NewDecoder(resp.Body).Decode(&body); err != nil {
		return models.Exchange{}, err
	}

	if len(body.Data) == 0 {
		return models.Exchange{}, errors.New("no data found")
	}

	return body.Data[0], nil
}

func buildFilter(date time.Time, currency string) string {
	startDate := date.AddDate(0, -6, 0)
	layout := "2006-01-02"
	startDateStr := startDate.Format(layout)
	endDateStr := date.Format(layout)
	return "filter=currency:eq:" + currency + ",effective_date:gte:" + startDateStr + ",effective_date:lte:" + endDateStr
}
