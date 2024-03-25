﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьПередКомпоновкойМакета,
							|ИспользоватьПослеВыводаРезультата,
							|ИспользоватьДанныеРасшифровки",
							Истина, Истина, Истина);
							
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт
	
	ЗаголовокОтчета = НСтр("ru = 'Отчет по наличию счетов-фактур полученных %1'");
	ЗаголовокОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ЗаголовокОтчета, БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода));
	
	Возврат ЗаголовокОтчета;
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода",  НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода",   КонецДня(ПараметрыОтчета.КонецПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ПараметрыОтчета.КонецПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ТекущаяДатаСеанса()));
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВалютаРегламентированногоУчета", Константы.ВалютаРегламентированногоУчета.Получить());
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СрокВыписки", 15); // для электронных
	
	СписокВидовДокументов = ПолучитьСписокВидовДокументовОснованияСФ();
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ТипЗначенияРегистратора", СписокВидовДокументов);
	
	МассивСостоянийПриема = Новый Массив;	
	МассивСостоянийПриема.Добавить(Перечисления.СостоянияЭСФ.ДоставленПолучателю);
	МассивСостоянийПриема.Добавить(Перечисления.СостоянияЭСФ.ПринятСервером);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СостоянияПриема", МассивСостоянийПриема); // для электронных
	
	Структура = КомпоновщикНастроек.Настройки;	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(КомпоновщикНастроек, "РасположениеРеквизитов", РасположениеРеквизитовКомпоновкиДанных.Отдельно); 
	ЕстьДетальныеЗаписи = Ложь;		
	Для Каждого ДополнительноеПоле Из ПараметрыОтчета.ДополнительныеПоля Цикл 
		Если ДополнительноеПоле.Использование Тогда
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(КомпоновщикНастроек, ДополнительноеПоле.Поле);			
			ЕстьДетальныеЗаписи = Истина;
		КонецЕсли;
	КонецЦикла;
	
	// Добавляем группу ошибок по операции
	ГруппаОшибок = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаОшибок.Заголовок     = НСтр("ru = 'Ошибки'");
	ГруппаОшибок.Использование = Истина;
	ГруппаОшибок.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОшибок, "Ошибка1", "Ошибка");					
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОшибок, "Ошибка2", "Ошибка");			

	Структура = КомпоновщикНастроек.Настройки;
	Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
			Если ПолеВыбраннойГруппировки.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Иерархия Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
			ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.ТолькоИерархия Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
			Иначе
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			КонецЕсли;
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		КонецЕсли;
	КонецЦикла;
	
	ГруппаДанныеДокумента = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаДанныеДокумента.Заголовок     = "Данные документа отгрузки";
	ГруппаДанныеДокумента.Использование = Истина;
	
	ГруппаСчетаФактуры = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСчетаФактуры.Заголовок     = "Данные счета-фактуры";
	ГруппаСчетаФактуры.Использование = Истина;
	
	ГруппаДанныеЭСФ = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаДанныеЭСФ.Заголовок     = "Данные ЭСФ";
	ГруппаДанныеЭСФ.Использование = Истина;
	
	Для Каждого Показатель Из ПараметрыОтчета.Показатели Цикл
		Если Показатель.Использование Тогда
			Если Показатель.Поле = "СФСуммаНДСРеглОборот" ИЛИ Показатель.Поле = "СФОборотПоРеализацииРеглОборот" Тогда
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСчетаФактуры, Показатель.Поле);
			ИначеЕсли Показатель.Поле = "ЭСФСуммаНДС" ИЛИ Показатель.Поле = "ЭСФОборотПоРеализации" Тогда
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДанныеЭСФ, Показатель.Поле);
			Иначе
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДанныеДокумента, Показатель.Поле);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	КомпоновщикНастроек.Настройки.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	Если ЕстьДетальныеЗаписи Тогда
		Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	КонецЕсли;
	
	БухгалтерскиеОтчеты.ДобавитьОтборПоОрганизациямИПодразделениям(КомпоновщикНастроек, ПараметрыОтчета,,, "СтруктурноеПодразделение");
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьСписокВидовДокументовОснованияСФ(ВидСчетФактуры = "СчетФактураПолученный")
	
	СписокТиповДокументов = Новый СписокЗначений;
	МетаданныеДокумента = Документы[ВидСчетФактуры].ПустаяСсылка().Метаданные();
	Для Каждого Документ Из МетаданныеДокумента.ТабличныеЧасти["ДокументыОснования"].Реквизиты["ДокументОснование"].Тип.Типы() Цикл		
		СписокТиповДокументов.Добавить(Документ);
	КонецЦикла;
	
    Возврат СписокТиповДокументов;
	
КонецФункции

#КонецЕсли