﻿////////////////////////////////////////////////////////////////////////////////
// СтандартныеПодсистемыБКГлобальный:
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Вызывается из обработчика ожидания, открывает окно Стартового помощника.
Процедура ПоказатьСтартовыйПомощник() Экспорт
	ОткрытьФорму("Обработка.НачалоРаботы.Форма.БыстрыйСтарт");
КонецПроцедуры

// Вызывается из обработчика ожидания, открывает окно Свертки базы.
Процедура ОткрытьСверткуБазы() Экспорт
	ОткрытьФорму("Обработка.СверткаИнформационнойБазы.Форма.Форма");
КонецПроцедуры

#КонецОбласти
