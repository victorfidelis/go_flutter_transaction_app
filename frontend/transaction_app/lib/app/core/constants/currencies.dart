enum Currency { euro, real, kwanza}

// Convertendo para o texto adequado para requisição
const Map<Currency, String> currencyToParam = {
  Currency.euro: 'Euro',
  Currency.real: 'Real',
  Currency.kwanza: 'Kwanza',
};

// Convertendo para o texto adequado para apresentação
const Map<Currency, String> currencyToText = {
  Currency.euro: 'Euro',
  Currency.real: 'Real',
  Currency.kwanza: 'Kwanza',
};