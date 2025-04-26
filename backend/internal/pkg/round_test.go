package round

import (
	"math"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestRound(t *testing.T) {
	tests := []struct {
		name      string
		value     float64
		precision int
		expected  float64
	}{
		// Casos básicos de arredondamento
		{"Arredondar para inteiro (positivo)", 3.14, 0, 3},
		{"Arredondar para inteiro (negativo)", -3.14, 0, -3},
		{"Arredondar para 1 casa decimal", 3.1415, 1, 3.1},
		{"Arredondar para 2 casas decimais", 3.1415, 2, 3.14},
		{"Arredondar para 3 casas decimais", 3.1415, 3, 3.142},
		{"Arredondar para 4 casas decimais", 3.1415926535, 4, 3.1416},

		// Casos com valores exatos
		{"Arredondar para 0 casas decimais", 2.5, 0, 3},
		{"Valor exato sem necessidade de arredondamento", 1.23, 2, 1.23},

		// Casos de borda com precisão
		{"Precisão negativa (deve retornar valor original)", 3.1415, -1, 3.1415},
		{"Precisão zero", 3.99, 0, 4},
		{"Alta precisão", 1.23456789, 6, 1.234568},

		// Casos com valores extremos
		{"Zero", 0, 2, 0},
		{"Valor muito pequeno", 0.0000001, 3, 0},
		{"Valor muito grande", 123456789.987654321, 2, 123456789.99},

		// Casos com .5 (testando regra de arredondamento do math.Round)
		{"Arredondamento .5 para cima (positivo)", 2.5, 0, 3},
		{"Arredondamento .5 para cima (negativo)", -2.5, 0, -3},
		{"Arredondamento .5 para cima com decimais", 1.235, 2, 1.24},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := Round(tt.value, tt.precision)
			assert.Equal(
				t,
				tt.expected,
				got,
				"Round(%v, %d) = %v, esperado %v",
				tt.value, tt.precision, got, tt.expected,
			)
		})
	}
}

func TestRoundPrecisionEdgeCases(t *testing.T) {
	// Testes adicionais para verificar comportamento com alta precisão
	value := 1.23456789

	t.Run("Precisão máxima razoável", func(t *testing.T) {
		got := Round(value, 15) // Próximo ao limite do float64
		expected := value       // Deve retornar o mesmo valor
		assert.Equal(t, expected, got, "Round(%v, 15) = %v, esperado %v", value, got, expected)
	})

	t.Run("Precisão muito alta", func(t *testing.T) {
		got := Round(value, 300) // Além do limite do float64
		expected := value        // Deve retornar o mesmo valor
		assert.Equal(t, expected, got, "Round(%v, 300) = %v, esperado %v", value, got, expected)
	})
}

func TestRoundSpecialFloatValues(t *testing.T) {
	t.Run("NaN", func(t *testing.T) {
		got := Round(math.NaN(), 2)
		assert.True(t, math.IsNaN(got), "Deveria retornar NaN")
	})

	t.Run("+Inf", func(t *testing.T) {
		got := Round(math.Inf(1), 2)
		assert.Equal(t, math.Inf(1), got, "Deveria manter +Inf")
	})

	t.Run("-Inf", func(t *testing.T) {
		got := Round(math.Inf(-1), 2)
		assert.Equal(t, math.Inf(-1), got, "Deveria manter -Inf")
	})
}
