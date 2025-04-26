package round

import "math"

func Round(value float64, precision int) float64 {
	if precision < 0 {
		return value
	}
	p := math.Pow(10, float64(precision))
	return math.Round(value*p) / p
}
