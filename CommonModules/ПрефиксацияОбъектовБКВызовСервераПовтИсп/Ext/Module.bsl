﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Префиксация объектов"
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// см. ПрефиксацияОбъектовБКВызовСервера.СписокПрефиксовУзлов()
//
Функция СписокПрефиксовУзлов() Экспорт
	
	Возврат ПрефиксацияОбъектовБКВызовСервера.СписокПрефиксовУзлов();
	
КонецФункции

Функция ПредставлениеНомеровОбъектов(ИмяКонстанты = "") Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ ПустаяСтрока(ИмяКонстанты) И Метаданные.Константы.Найти(ИмяКонстанты) <> Неопределено Тогда 
		Возврат Константы[ИмяКонстанты].Получить();
	КонецЕсли;
	
	Возврат Константы.ПредставлениеНомераДокументов.Получить();
	
КонецФункции

// Проверяет включенность объекта переданной ссылки в указанную подписку на событие.
// Работает только для тех ссылок, для которых возможно получение объекта
// 
// Параметры:
//  СсылкаНаОбъект       - ЛюбаяСсылка - ссылка на объект информационной базы
//  ИмяПодпискиНаСобытие - Строка      - имя подписки на событие, для которой необходимо проверить вхождение ссылки
//
Функция ОбъектВключенВПодпискуНаСобытие(СсылкаНаОбъект, ИмяПодпискиНаСобытие) Экспорт
	
	ИмяТаблицыПоСсылке = ОбщегоНазначения.ИмяТаблицыПоСсылке(СсылкаНаОбъект);
	МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяТаблицыПоСсылке, ".");
	Если МассивПодстрок.Количество() < 2 Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	МассивПодстрок[0] = МассивПодстрок[0] + "Объект";
	СтрокаТипаОбъекта = СтрСоединить(МассивПодстрок, ".");
	
	Попытка
		ОбъектТип = Тип(СтрокаТипаОбъекта);
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	МассивТиповПодписки = Метаданные.ПодпискиНаСобытия[ИмяПодпискиНаСобытие].Источник.Типы();
	
	Если МассивТиповПодписки.Найти(ОбъектТип) <> Неопределено Тогда 
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// см. ПрефиксацияОбъектовБКСлужебный.РеквизитДоступен(Объект, ИмяРеквизита)
// 
Функция РеквизитДоступен(СсылкаНаОбъект, ИмяРеквизита) Экспорт
	
	// возвращаемое значение функции
	Результат = Истина;
	
	МетаданныеОбъекта = СсылкаНаОбъект.Метаданные();
	
	Если   (ОбщегоНазначения.ЭтоСправочник(МетаданныеОбъекта)
		ИЛИ ОбщегоНазначения.ЭтоПланВидовХарактеристик(МетаданныеОбъекта))
		И МетаданныеОбъекта.Иерархический Тогда
		
		Реквизит = МетаданныеОбъекта.Реквизиты.Найти(ИмяРеквизита);
		
		Если Реквизит = Неопределено Тогда
			
			Если ОбщегоНазначения.ЭтоСтандартныйРеквизит(МетаданныеОбъекта.СтандартныеРеквизиты, ИмяРеквизита) Тогда
				
				// Стандартный реквизит всегда доступен и для элемента и для группы.
				Возврат Истина;
				
			КонецЕсли;
			
			Возврат Ложь;
			
		КонецЕсли;
		
		Если Реквизит.Использование = Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляГруппы И Не СсылкаНаОбъект.ЭтоГруппа Тогда
			
			Результат = Ложь;
			
		ИначеЕсли Реквизит.Использование = Метаданные.СвойстваОбъектов.ИспользованиеРеквизита.ДляЭлемента И СсылкаНаОбъект.ЭтоГруппа Тогда
			
			Результат = Ложь;
			
		КонецЕсли;
		
	ИначеЕсли ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъекта) Тогда 
		
		Результат = МетаданныеОбъекта.Реквизиты.Найти(ИмяРеквизита) <> Неопределено;
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции
