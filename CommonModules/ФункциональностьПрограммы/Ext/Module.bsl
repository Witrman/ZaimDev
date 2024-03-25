﻿
#Область ПрограммныйИнтерфейс

// Возвращает текст, который выводится на баннер опции в том случае,
// если пользователь использовал максимальное количество опций в разных приложениях.
// 
// Возвращаемое значение:
//   - Строка - Тест ограничение тарифа для баннера
//
Функция ТекстОграничениеТарифа() Экспорт
	Возврат НСтр("ru = 'ЛИМИТ ТАРИФА'");
КонецФункции

// Возвращает цвет баннера, который выводится для опции в том случае,
// если пользователь использовал максимальное количество опций в разных приложениях.
// 
// Возвращаемое значение:
//   - 
//
Функция ЦветБаннераОграниченияТарифа() Экспорт
	
	Возврат ЦветаСтиля.ЦветБаннераЗеленый;
	
КонецФункции

// Возвращает текст, который выводится на баннер опции в том случае,
// если опция не доступна для пользователя по тарифу.
// 
// Возвращаемое значение:
//   - Строка - Тест ограничение тарифа для баннера
//
Функция ТекстНедоступенТариф() Экспорт
	Возврат НСтр("ru = 'ТАРИФ'");
КонецФункции

// Возвращает цвет баннера, который выводится для опции в том случае,
// если пользователь использовал максимальное количество опций в разных приложениях.
// 
// Возвращаемое значение:
//   - 
//
Функция ЦветБаннераНедоступенТариф() Экспорт
	
	Возврат ЦветаСтиля.ЦветБаннераБежевый;
	
КонецФункции

#КонецОбласти