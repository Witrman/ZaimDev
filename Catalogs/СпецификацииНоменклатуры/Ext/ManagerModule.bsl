﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Спецификация
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Спецификация";
	КомандаПечати.Представление = НСтр("ru = 'Спецификация'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 50;
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Печать расходной накладной
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Спецификация");
	Если НужноПечататьМакет Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"Спецификация",
			НСтр("ru = 'Спецификация'"),
			ПечатьСпецификации(МассивОбъектов, ОбъектыПечати),
			,
			"Справочник.СпецификацииНоменклатуры.ПФ_MXL_Спецификация");
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьСпецификации(МассивОбъектов, ОбъектыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Макет       = УправлениеПечатью.МакетПечатнойФормы("Справочник.СпецификацииНоменклатуры.ПФ_MXL_Спецификация");
	
	ОбластьШапка               = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапкаКомплектующих  = Макет.ПолучитьОбласть("ШапкаКомплектующих");
	ОбластьПодвал              = Макет.ПолучитьОбласть("Подвал");
	ОбластьПодписи             = Макет.ПолучитьОбласть("Подписи");
	ОбластьСтрокаКомплектующих = Макет.ПолучитьОбласть("Строка");
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ТолькоПросмотр = Истина;
	
	ТабличныйДокумент.КлючПараметровПечати = "СпецификацииНоменклатуры_Спецификация";
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СпецификацииНоменклатуры.Ссылка,
	|	СпецификацииНоменклатуры.Наименование,
	|	СпецификацииНоменклатуры.Владелец.Наименование КАК ВладелецНаименование,
	|	СпецификацииНоменклатуры.Количество,
	|	СпецификацииНоменклатуры.Владелец.БазоваяЕдиницаИзмерения КАК ВладелецБазоваяЕдиницаИзмерения
	|ИЗ
	|	Справочник.СпецификацииНоменклатуры КАК СпецификацииНоменклатуры
	|ГДЕ
	|	СпецификацииНоменклатуры.Ссылка В(&МассивОбъектов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СпецификацииНоменклатурыИсходныеКомплектующие.Ссылка КАК Ссылка,
	|	СпецификацииНоменклатурыИсходныеКомплектующие.НомерСтроки,
	|	СпецификацииНоменклатурыИсходныеКомплектующие.Номенклатура,
	|	СпецификацииНоменклатурыИсходныеКомплектующие.Количество,
	|	СпецификацииНоменклатурыИсходныеКомплектующие.Номенклатура.БазоваяЕдиницаИзмерения КАК НоменклатураБазоваяЕдиницаИзмерения
	|ИЗ
	|	Справочник.СпецификацииНоменклатуры.ИсходныеКомплектующие КАК СпецификацииНоменклатурыИсходныеКомплектующие
	|ГДЕ
	|	СпецификацииНоменклатурыИсходныеКомплектующие.Ссылка В(&МассивОбъектов)
	|ИТОГИ ПО
	|	Ссылка";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	ДанныеШапки  = МассивРезультатов[0].Выбрать();
	ВыборкаИтоги = МассивРезультатов[МассивРезультатов.ВГраница()].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ДанныеШапки.Следующий() Цикл
		
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОбластьШапка.Параметры.ТекстЗаголовка   = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Спецификация ""%1""'"), СокрЛП(ДанныеШапки.Наименование));
		ОбластьШапка.Параметры.ВыходноеИзделие  = ДанныеШапки.ВладелецНаименование;
		ОбластьШапка.Параметры.Количество       = ДанныеШапки.Количество;
		ОбластьШапка.Параметры.ЕдиницаИзмерения = ДанныеШапки.ВладелецБазоваяЕдиницаИзмерения;
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		ТабличныйДокумент.Вывести(ОбластьШапкаКомплектующих);
		
		ВыборкаИтоги.Сбросить();
		
		Если ВыборкаИтоги.НайтиСледующий(ДанныеШапки.Ссылка) Тогда
			ВыборкаКомплектующие = ВыборкаИтоги.Выбрать();
		Иначе 
			ВыборкаКомплектующие = Неопределено;
		КонецЕсли;
		
		Если ВыборкаКомплектующие <> Неопределено Тогда 
			Пока ВыборкаКомплектующие.Следующий() Цикл 
				ОбластьСтрокаКомплектующих.Параметры.НомерСтроки      = ВыборкаКомплектующие.НомерСтроки;
				ОбластьСтрокаКомплектующих.Параметры.Номенклатура     = ВыборкаКомплектующие.Номенклатура;
				ОбластьСтрокаКомплектующих.Параметры.Количество       = ВыборкаКомплектующие.Количество;
				ОбластьСтрокаКомплектующих.Параметры.ЕдиницаИзмерения = ВыборкаКомплектующие.НоменклатураБазоваяЕдиницаИзмерения;
				ТабличныйДокумент.Вывести(ОбластьСтрокаКомплектующих);
			КонецЦикла;
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		
		ОбластьПодписи.Параметры.ОтветственныйПредставление = Пользователи.ТекущийПользователь().ФизЛицо.Наименование;
		ТабличныйДокумент.Вывести(ОбластьПодписи);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеШапки.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецЕсли