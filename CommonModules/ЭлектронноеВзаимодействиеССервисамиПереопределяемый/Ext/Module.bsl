﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Электронное взаимодействие с сервисами".
// ОбщийМодуль.ЭлектронноеВзаимодействиеССервисамиПереопределяемый.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Функция ПолучитьИмяКонфигурации() Экспорт
	
	//ЭСФ
	Возврат "1c-esf-crypto";
	
КонецФункции

Процедура СообщитьПользователю(ТекстСообщения, ЭтоОшибка = Ложь) Экспорт
	
	//// БК
	//ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	
	// ERP
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
	//// УТ
	//ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
	//// Розница
	//ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
	//// КА
	//ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
	//запись в журнал регистрации
	Если ЭтоОшибка Тогда
		ЗаписьЖурналаРегистрации("Проверка доступа к сервису электронного взаимодействия",
		УровеньЖурналаРегистрации.Ошибка,,,ТекстСообщения);
	КонецЕсли;
КонецПроцедуры

// Записывает в журнал регистрации сообщение информации об ошибках.
//
// Параметры:
//  Сообщение - Строка - строковое представление ошибки.
//  Данные - Произвольный - данные, к которым относится сообщение об ошибке;
//  Ошибка - Булево - определяет уровень журнала регистрации.
//
Процедура ЗаписатьИнформациюВЖурналРегистрации(
		Сообщение,
		Данные = Неопределено,
		Ошибка = Истина) Экспорт
	
	УровеньЖР = ?(Ошибка, УровеньЖурналаРегистрации.Ошибка, УровеньЖурналаРегистрации.Информация);
	
	ЗаписьЖурналаРегистрации(
		ИмяСобытияЖурналаРегистрации(),
		УровеньЖР,
		,
		Данные,
		Сообщение);
	
КонецПроцедуры

// Возвращается имя события журнала регистрации для записи ошибок
// электронного взаимодействия.
//
// Возвращаемое значение:
//	Строка - имя события ошибки Интернет-поддержки.
//
Функция ИмяСобытияЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Сервис электронного взаимодействия.'");
	
КонецФункции

// Возвращает флаг необходимости вывода сообщения о состоянии срока подписки
// в зависимости от количества оставшихся дней действия подписки, включая сегодняшний день.
Функция ВыводитьСообщениеОбОкончанииСрокаПодписки(serviceNick = "", Организация = Неопределено, КоличествоОставшихсяДнейПодписки = Неопределено) Экспорт
	
	ФлагВыводаСообщения = Ложь;
	
	Если КоличествоОставшихсяДнейПодписки <> Неопределено Тогда
		
		Если КоличествоОставшихсяДнейПодписки < 1 Тогда
			// подписка закончилась
			ФлагВыводаСообщения = Истина;
		ИначеЕсли КоличествоОставшихсяДнейПодписки = 1 Тогда
			// последий день подписки
			ФлагВыводаСообщения = Истина;
		ИначеЕсли КоличествоОставшихсяДнейПодписки < 7 Тогда
			// осталось меньше недели
			ФлагВыводаСообщения = Истина;
		ИначеЕсли КоличествоОставшихсяДнейПодписки < 30 Тогда
			// осталось меньше месяца
			ФлагВыводаСообщения = Ложь;
		Иначе
			// осталось больше месяца
			ФлагВыводаСообщения = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ФлагВыводаСообщения
	
КонецФункции

// Возвращает флаг необходимости вывода сообщения о состоянии срока подписки
// в зависимости от количества оставшихся дней действия подписки, включая сегодняшний день.
Функция ВыводитьИнформациюОСрокахПодписки(serviceNick = "", Организация = Неопределено, КоличествоОставшихсяДнейПодписки = Неопределено) Экспорт
	
	ФлагВыводаСообщения = Ложь;
	
	Если КоличествоОставшихсяДнейПодписки <> Неопределено Тогда
		
		Если КоличествоОставшихсяДнейПодписки < 30 Тогда
			// осталось меньше месяца
			ФлагВыводаСообщения = Истина;
		Иначе
			// осталось больше месяца
			ФлагВыводаСообщения = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ФлагВыводаСообщения
	
КонецФункции

// Возвращает объект ИнтернетПрокси для доступа в Интернет.
//
Функция ПолучитьПрокси(URLИлиПротокол) Экспорт
	
	Возврат ПолучениеФайловИзИнтернетаКлиентСервер.ПолучитьПрокси(URLИлиПротокол);
	
КонецФункции

#Область ИСЭСФ

Функция ПолучитьРеквизитыОрганизации(Организация) Экспорт
	
	РеквизитыОрганизации = Новый Структура;
	РеквизитыОрганизации.Вставить("Идентификатор","");
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.%ОрганизацияИНН КАК Идентификатор,
	|	Организации.Ссылка
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.Ссылка = &ОрганизацияСсылка";
	
	СоответсвиеИменРеквизитов = Новый Соответствие;
	СоответсвиеИменРеквизитов.Вставить("%ОрганизацияИНН", "");
	
	ЭСФСерверПереопределяемый.ЗаполнитьСоответсвиеИменРеквизитовПолейЗапросов(СоответсвиеИменРеквизитов);
	
	ЭСФСервер.ЗаменитьИменаРеквизитовПолейЗапросов(ТекстЗапроса, СоответсвиеИменРеквизитов);
	
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("ОрганизацияСсылка", Организация);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Следующий() Тогда
		РеквизитыОрганизации.Идентификатор = РезультатЗапроса.Идентификатор;
	КонецЕсли;
	
	Возврат РеквизитыОрганизации;
	
КонецФункции

#КонецОбласти

#КонецОбласти
