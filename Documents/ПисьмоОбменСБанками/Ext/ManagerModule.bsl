﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Письмо
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.ПисьмоОбменСБанками";
	КомандаПечати.Идентификатор = "ПисьмоОбменСБанками";
	КомандаПечати.Представление = НСтр("ru = 'Письмо'");
	
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

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПисьмоОбменСБанками") Тогда
		ТабличныйДокумент = СформироватьПисьмо(МассивОбъектов, ОбъектыПечати);
		КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
		НазваниеМакета = СтрШаблон("Документ.ПисьмоОбменСБанками.ПФ_MXL_Письмо_%1", КодОсновногоЯзыка);
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПисьмоОбменСБанками",
			НСтр("ru='Письмо'"), ТабличныйДокумент, , НазваниеМакета);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Если Данные.Направление = ПредопределенноеЗначение("Перечисление.НаправленияЭД.Входящий") Тогда
		Шаблон = НСтр("ru = 'Входящее письмо из банка №%1 от %2'");
		Номер = Данные.ВходящийНомер;
	Иначе
		Шаблон = НСтр("ru = 'Исходящее письмо в банк №%1 от %2'");
		Номер = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Данные.Номер);
	КонецЕсли;
	
	Представление = СтрШаблон(Шаблон, Номер, Данные.Дата);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("Направление");
	Поля.Добавить("Дата");
	Поля.Добавить("Номер");
	Поля.Добавить("ВходящийНомер");
	
КонецПроцедуры

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы <> "ФормаОбъекта" Тогда
		Возврат;
	КонецЕсли;
	
	СсылкаНаДокумент = Неопределено;
	Если Параметры.Свойство("Ключ", СсылкаНаДокумент) Тогда
		Направление = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаДокумент, "Направление");
		Если Направление = Перечисления.НаправленияЭД.Входящий Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "ПисьмоИзБанка";
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецЕсли

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция СформироватьПисьмо(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПисьмоОбменСБанками";
	КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	НазваниеМакета = СтрШаблон("Документ.ПисьмоОбменСБанками.ПФ_MXL_Письмо_%1", КодОсновногоЯзыка);
	Макет = УправлениеПечатью.МакетПечатнойФормы(НазваниеМакета);

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПисьмоОбменСБанками.Номер КАК Номер,
	               |	ПисьмоОбменСБанками.Дата КАК Дата,
	               |	ПисьмоОбменСБанками.Организация КАК Организация,
	               |	ПисьмоОбменСБанками.Банк КАК Банк,
	               |	ПисьмоОбменСБанками.Тема КАК Тема,
	               |	ПисьмоОбменСБанками.ТипПисьма КАК ТипПисьма,
	               |	ПисьмоОбменСБанками.Текст КАК Сообщение,
	               |	ПисьмоОбменСБанками.Направление КАК Направление,
	               |	ПисьмоОбменСБанками.ВходящийНомер КАК ВходящийНомер,
	               |	ПисьмоОбменСБанками.ВходящаяДата КАК ВходящаяДата,
	               |	ПисьмоОбменСБанками.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.ПисьмоОбменСБанками КАК ПисьмоОбменСБанками
	               |ГДЕ
	               |	ПисьмоОбменСБанками.Ссылка В(&МассивДокументов)";
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
		
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		ОбластьМакета = Макет.ПолучитьОбласть("Письмо");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		
		Если Выборка.Направление = Перечисления.НаправленияЭД.Входящий Тогда
			ОбластьМакета.Параметры.Дата = Выборка.ВходящаяДата;
			ОбластьМакета.Параметры.Номер = Выборка.ВходящийНомер;
			ОбластьМакета.Параметры.Отправитель = Выборка.Банк;
			ОбластьМакета.Параметры.Получатель = Выборка.Организация;
		Иначе
			ОбластьМакета.Параметры.Номер = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Выборка.Номер);
			ОбластьМакета.Параметры.Отправитель = Выборка.Организация;
			ОбластьМакета.Параметры.Получатель = Выборка.Банк;
		КонецЕсли;
	
		ТабличныйДокумент.Вывести(ОбластьМакета);
			
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(
			ТабличныйДокумент,
			НомерСтрокиНачало,
			ОбъектыПечати,
			Выборка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецЕсли