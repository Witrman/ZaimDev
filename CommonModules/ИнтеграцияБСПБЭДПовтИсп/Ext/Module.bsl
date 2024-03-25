﻿
#Область СлужебныеПроцедурыИФункции

// Возвращает данные классификатора валют.
// Подлежит замене после реализации в БСП интерфейсного метода.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - имеет колонки:
//    * КодВалютыЦифровой - цифровой код по классификатору.
//    * КодВалютыБуквенный - буквенный код по классификатору.
//    * Наименование - наименование по классификатору.
//
Функция ДанныеКлассификатораВалют() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеКлассификатора = Новый ТаблицаЗначений;
	ДанныеКлассификатора.Колонки.Добавить("КодВалютыЦифровой");
	ДанныеКлассификатора.Колонки.Добавить("КодВалютыБуквенный");
	ДанныеКлассификатора.Колонки.Добавить("Наименование");
	
	КлассификаторXML = Обработки.ЗагрузкаКурсовВалют.ПолучитьМакет("ОбщероссийскийКлассификаторВалют").ПолучитьТекст(); 
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	Для Каждого ЗаписьОКВ Из КлассификаторТаблица Цикл
		НоваяСтрока = ДанныеКлассификатора.Добавить();
		НоваяСтрока.КодВалютыЦифровой         = ЗаписьОКВ.Code;
		НоваяСтрока.КодВалютыБуквенный        = ЗаписьОКВ.CodeSymbol;
		НоваяСтрока.Наименование              = ЗаписьОКВ.Name;
	КонецЦикла;
	
	Если Не ДанныеКлассификатора.Количество() Тогда
		ВызватьИсключение НСтр("ru = 'Не удалось получить классификатор валют.'");
	КонецЕсли;
	
	Возврат ДанныеКлассификатора;

КонецФункции

#КонецОбласти