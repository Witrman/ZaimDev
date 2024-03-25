﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)

	СтандартнаяОбработка = Истина;

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

	ТипСтруктура     = Тип("Структура");
	ТипЛентаНовостей = Тип("СправочникСсылка.ЛентыНовостей");

	Если ТипЗнч(Параметры) = ТипСтруктура Тогда
		Если Параметры.Свойство("ЛентаНовостей") Тогда
			ЛокальнаяЛентаНовостей = Неопределено;
			Параметры.Свойство("ЛентаНовостей", ЛокальнаяЛентаНовостей);
			Если ТипЗнч(ЛокальнаяЛентаНовостей) = ТипЛентаНовостей
					И (НЕ ЛокальнаяЛентаНовостей.Пустая()) Тогда
				МассивДоступныхКатегорий = ЛокальнаяЛентаНовостей.ДоступныеКатегорииНовостей.ВыгрузитьКолонку("КатегорияНовостей");
				Если МассивДоступныхКатегорий.Количество() > 0 Тогда
					ДанныеВыбора = Новый СписокЗначений;
					ДанныеВыбора.ЗагрузитьЗначения(МассивДоступныхКатегорий);
					СтандартнаяОбработка = Ложь;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

#КонецЕсли

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура загружает стандартные значения из макета с именем "СтандартныеЗначения".
// Имеет смысл заполнять значения из макета:
//  - при обновлении конфигурации (когда подключение к интернету может занять много времени);
//  - при первоначальном заполнении пустой базы, когда не заполнены параметры,
//      логины и пароли для доступа к веб-сервисам обновлений.
//
// Параметры:
//  КонтекстВыполнения - Структура, Неопределено - структура контекста выполнения.
//
Процедура ЗагрузитьСтандартныеЗначения(КонтекстВыполнения = Неопределено) Экспорт

	ОбъектМетаданных = ПланыВидовХарактеристик.КатегорииНовостей; // Переопределение
	ИмяОбъектаМетаданных = "ПланыВидовХарактеристик.КатегорииНовостей"; // Переопределение
	ИмяСвойства = "ChartOfCharacteristicTypesObject_КатегорииНовостей"; // Переопределение
	ИдентификаторШага = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Новости. Сервис и регламент. Загрузка стандартных значений. %1. Начало'",
			ОбщегоНазначения.КодОсновногоЯзыка()),
		ИмяСвойства);

	НаименованиеПроцедурыФункции = ИмяОбъектаМетаданных + ".ЗагрузитьСтандартныеЗначения"; // Идентификатор.
	ЗаписыватьВЖурналРегистрации = Ложь;
	Если КонтекстВыполнения = Неопределено Тогда
		КонтекстВыполнения = ОбработкаНовостейКлиентСервер.НоваяЗаписьРезультатовВыполненияОпераций(); // Этот контекст.
		ЗаписыватьВЖурналРегистрации = Истина;
	КонецЕсли;
	КодРезультата = 0;
	ОписаниеРезультата = "";
	КонтекстВыполненияВложенный = ОбработкаНовостейКлиентСервер.НоваяЗаписьРезультатовВыполненияОпераций(); // Контекст "по шагам".
	ОбработкаНовостейКлиентСервер.НачатьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		НаименованиеПроцедурыФункции, // Идентификатор.
		НСтр("ru='Загрузка стандартных значений'"));

		ТипСоответствие = Тип("Соответствие");
		ТипСтрока = Тип("Строка");

		СодержимоеМакета = ОбъектМетаданных.ПолучитьМакет("СтандартныеЗначения").ПолучитьТекст();
		ПоставляемыеДанныеОбъекта = Новый Соответствие;
		ПоставляемыеДанныеОбъекта.Вставить(
			"" + ИмяОбъектаМетаданных + ":СтандартныеЗначения", // Идентификатор.
			СодержимоеМакета);
		ОбработкаНовостей.ПолучитьДополнительныеСтандартныеЗначенияКлассификаторов(
			ИмяОбъектаМетаданных,
			ПоставляемыеДанныеОбъекта);
		Если ТипЗнч(ПоставляемыеДанныеОбъекта) = ТипСоответствие Тогда
			Для Каждого СтрокаСтандартныхЗначений Из ПоставляемыеДанныеОбъекта Цикл
				Если (ТипЗнч(СтрокаСтандартныхЗначений.Значение) = ТипСтрока)
						И (НЕ ПустаяСтрока(СтрокаСтандартныхЗначений.Значение)) Тогда
					ЕстьОшибки = Ложь;
					Попытка
						ОписаниеРезультата = ОписаниеРезультата
							+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru='Попытка загрузки стандартных значений из строки (первые 2000 символов):
									|%1'")
									+ Символы.ПС,
								Лев(СтрокаСтандартныхЗначений.Значение, 2000));
						ЧтениеХМЛ = Новый ЧтениеXML;
						ЧтениеХМЛ.УстановитьСтроку(СтрокаСтандартныхЗначений.Значение);
						ЧтениеХМЛ.Прочитать();
					Исключение
						ИнформацияОбОшибке = ИнформацияОбОшибке();
						ОписаниеРезультата = ОписаниеРезультата
							+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru='Ошибка загрузки стандартных значений из строки по причине:
									|%1'"),
								ПодробноеПредставлениеОшибки(ИнформацияОбОшибке))
							+ Символы.ПС;
						ЕстьОшибки = Истина;
					КонецПопытки;
					Если ЕстьОшибки <> Истина Тогда
						ХМЛТип = ПолучитьXMLТип(ЧтениеХМЛ);
						Если (НРег(ХМЛТип.ИмяТипа) = НРег("DefaultData")) Тогда
							// ... И (ВРег(ХМЛТип.URIПространстваИмен)=ВРег("http://v8.1c.ru/8.1/data/enterprise/current-config"))
							ОбъектХДТО = ФабрикаXDTO.ПрочитатьXML(ЧтениеХМЛ);
							СвойствоОбъект = ОбъектХДТО.Свойства().Получить(ИмяСвойства);
							Если ТипЗнч(СвойствоОбъект) = Тип("СвойствоXDTO") Тогда
								Если (СвойствоОбъект.ВерхняяГраница = -1) ИЛИ (СвойствоОбъект.ВерхняяГраница > 1) Тогда
									СписокХДТО = ОбъектХДТО.ПолучитьСписок(СвойствоОбъект);
									Для каждого ЛокальныйТекущийОбъект Из СписокХДТО Цикл
										ЗагрузитьСтандартноеЗначение(
											ЛокальныйТекущийОбъект,
											ОбъектМетаданных,
											ИмяСвойства,
											ОписаниеРезультата);
									КонецЦикла;
								ИначеЕсли (СвойствоОбъект.НижняяГраница = 1) И (СвойствоОбъект.ВерхняяГраница = 1) Тогда
									ЗагрузитьСтандартноеЗначение(
										ОбъектХДТО.Получить(СвойствоОбъект),
										ОбъектМетаданных,
										ИмяСвойства,
										ОписаниеРезультата);
								КонецЕсли;
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;

	ШагВыполнения = ОбработкаНовостейКлиентСервер.ЗавершитьРегистрациюРезультатаВыполненияОперации(
		КонтекстВыполнения,
		КодРезультата, // Много действий, всегда установлено в 0, надо читать данные по каждому шагу.
		ОписаниеРезультата,
		КонтекстВыполненияВложенный);

	Если ЗаписыватьВЖурналРегистрации = Истина Тогда

		ОбработкаНовостей.ЗаписатьСообщениеВЖурналРегистрации(
			НСтр("ru='БИП:Новости.Сервис и регламент'", ОбщегоНазначения.КодОсновногоЯзыка()), // ИмяСобытия.
			ИдентификаторШага, // ИдентификаторШага.
			?(КодРезультата > 0,
				УровеньЖурналаРегистрации.Ошибка,
				УровеньЖурналаРегистрации.Информация), // УровеньЖурналаРегистрации.*
			, // ОбъектМетаданных
			(ШагВыполнения.ВремяОкончания - ШагВыполнения.ВремяНачала), // Данные
			ОбработкаНовостей.КомментарийДляЖурналаРегистрации(
				НаименованиеПроцедурыФункции,
				ШагВыполнения,
				КонтекстВыполнения,
				"Простой"), // Комментарий
			ОбработкаНовостейПовтИсп.ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации

	КонецЕсли;

КонецПроцедуры

// Процедура загружает стандартное значение из макета с именем "СтандартныеЗначения".
//
// Параметры:
//  ОбъектХДТО       - Объект ХДТО - загружаемый объект;
//  ОбъектМетаданных - Объект метаданных;
//  ИмяСвойства      - Строка - имя свойства;
//  ЛогЗагрузки      - Строка - сюда будет писаться состояние загрузки данных.
//
Процедура ЗагрузитьСтандартноеЗначение(ОбъектХДТО, ОбъектМетаданных, ИмяСвойства, ЛогЗагрузки)

	СтрокаЛогаЗагрузки = "";

	Попытка
		Записывать = Истина;
		// Если в макете явно указан какой-то элемент, то найти его по УИН, а не по коду.
		НайденныйЭлемент = ОбъектХДТО.Ref;
		Если ПустаяСтрока(НайденныйЭлемент.ВерсияДанных) Тогда // Новый объект
			// Если в макете прописано помеченное на удаление значение, то не загружать его.
			Если ОбъектХДТО.DeletionMark = Истина Тогда
				// Заполнено помеченное на удаление значение - пропустить.
				СтрокаЛогаЗагрузки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Пропуск (не найден помеченный на удаление): %1'"),
					СокрЛП(ОбъектХДТО.Code));
				Записывать = Ложь;
			Иначе
				// Нет ранее созданных элементов с таким же кодом - оставить как есть.
				СтрокаЛогаЗагрузки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Создание: %1'"),
					СокрЛП(ОбъектХДТО.Code));
			КонецЕсли;
		Иначе // Объект есть в базе данных
			// Записываем как указано в макете
			// Подменить на ранее созданный элемент с таким же кодом.
			СтрокаЛогаЗагрузки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Изменение (по УИН): %1, %2'"),
				СокрЛП(НайденныйЭлемент.Код),
				СокрЛП(НайденныйЭлемент.Наименование));
		КонецЕсли;
		Если Записывать = Истина Тогда
			ТекущийОбъект = СериализаторXDTO.ПрочитатьXDTO(ОбъектХДТО);
			ТекущийОбъект.ОбменДанными.Загрузка = Истина;
			ТекущийОбъект.Записать();
			// После записи классификатора можно провести дополнительные обработки.
			ОбработкаНовостей.ДополнительноОбработатьКлассификаторПослеПолученияПослеЗаписи(ТекущийОбъект.Ссылка);
		КонецЕсли;
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ИдентификаторШага = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Новости. Сервис и регламент. Загрузка стандартных значений. %1. Ошибка'",
				ОбщегоНазначения.КодОсновногоЯзыка()),
			ИмяСвойства);
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Не удалось записать объект метаданных по причине:
				|%1'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		ОбработкаНовостейВызовСервера.ЗаписатьСообщениеВЖурналРегистрации(
			НСтр("ru='БИП:Новости.Сервис и регламент'", ОбщегоНазначения.КодОсновногоЯзыка()), // ИмяСобытия.
			ИдентификаторШага, // ИдентификаторШага.
			УровеньЖурналаРегистрации.Ошибка, // УровеньЖурналаРегистрации.*
			ОбъектМетаданных, // ОбъектМетаданных
			, // Данные
			ТекстСообщения, // Комментарий
			ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации
		СтрокаЛогаЗагрузки = СтрокаЛогаЗагрузки + ". "
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Произошла ошибка записи: %1'"),
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецПопытки;

	ЛогЗагрузки = ЛогЗагрузки + СтрокаЛогаЗагрузки + Символы.ПС;

КонецПроцедуры

// Возвращает реквизиты справочника, которые образуют естественный ключ для элементов справочника.
// Используется для сопоставления элементов механизмом "Выгрузка/загрузка областей данных".
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Массив(Строка) - массив имен реквизитов, образующих естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт

	Результат = Новый Массив;

	Результат.Добавить("Код");

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецЕсли
