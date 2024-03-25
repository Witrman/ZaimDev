﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Заполнение

Процедура ЗаполнитьДокументПоПеремещениеОС(Объект, Основание) Экспорт
	
	Объект.Организация              = Основание.Организация;
	Объект.СтруктурноеПодразделение = Основание.СтруктурноеПодразделениеПолучатель;
	Объект.ДокументОснование        = Основание.Ссылка;
	
	Для Каждого ТекущаяСтрока Из Основание.ОС Цикл
		НоваяСтрока = Объект.ОС.Добавить();
		НоваяСтрока.ОсновноеСредство = ТекущаяСтрока.ОсновноеСредство;
	КонецЦикла;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Проведение

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт
	
	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	НомераТаблиц = Новый Структура;
	
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента(НомераТаблиц);
	Результат = Запрос.ВыполнитьПакет();
	ТаблицаРеквизиты = Результат[НомераТаблиц["Реквизиты"]].Выгрузить();
	ПараметрыПроведения.Вставить("Реквизиты", ТаблицаРеквизиты);
	
	Реквизиты = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРеквизиты[0]);
	
	Запрос.УстановитьПараметр("СинонимОС", НСтр("ru = 'ОС'"));
	
	НомераТаблиц = Новый Структура;
	
	Запрос.Текст = ТекстЗапросаВременныеТаблицыДокумента(НомераТаблиц)
					+ ТекстЗапросаИзменениеСпособовОтраженияРасходовПоАмортизацииОС(НомераТаблиц);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;
	
	Возврат ПараметрыПроведения;

КонецФункции

Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц)
	
	НомераТаблиц.Вставить("ВременнаяТаблицаРеквизиты", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("Реквизиты"				 , НомераТаблиц.Количество());
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	""ИзменениеСостоянияОС"" КАК ВидДокумента,
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.СтруктурноеПодразделение КАК СтруктурноеПодразделение,
	|	Реквизиты.СпособОтраженияРасходовПоАмортизации КАК СпособОтраженияРасходовПоАмортизации,
	|	Реквизиты.Номер КАК Номер,
	|	Реквизиты.СобытиеОС КАК СобытиеОС
	|ПОМЕСТИТЬ Реквизиты
	|ИЗ
	|	Документ.ИзменениеСпособовОтраженияРасходовПоАмортизацииОС КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Реквизиты.ВидДокумента,
	|	Реквизиты.Регистратор,
	|	Реквизиты.Период,
	|	Реквизиты.Организация,
	|	Реквизиты.СтруктурноеПодразделение,
	|	Реквизиты.СпособОтраженияРасходовПоАмортизации,
	|	Реквизиты.Номер,
	|	Реквизиты.СобытиеОС
	|ИЗ
	|	Реквизиты КАК Реквизиты";

	Возврат ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаВременныеТаблицыДокумента(НомераТаблиц)

	НомераТаблиц.Вставить("ВременнаяТаблицаОС", НомераТаблиц.Количество());
 	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаОС.Ссылка КАК Ссылка,
	|	ТаблицаОС.НомерСтроки,
	|	ТаблицаОС.ОсновноеСредство
	|ПОМЕСТИТЬ ТаблицаОС
	|ИЗ
	|	Документ.ИзменениеСпособовОтраженияРасходовПоАмортизацииОС.ОС КАК ТаблицаОС
	|ГДЕ
	|	ТаблицаОС.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаИзменениеСпособовОтраженияРасходовПоАмортизацииОС(НомераТаблиц)
	
	НомераТаблиц.Вставить("СобытияОСОрганизацийТаблицаОС"					 				 , НомераТаблиц.Количество());
	НомераТаблиц.Вставить("СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчетТаблицаОС", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	""СобытияОСОрганизацийТаблицаОС"" КАК ИмяСписка,
	|	&СинонимОС КАК СинонимСписка,
	|	Реквизиты.Период КАК Период,
	|	Реквизиты.Номер КАК Номер,
	|	Реквизиты.Регистратор КАК Регистратор,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.СтруктурноеПодразделение КАК СтруктурноеПодразделение,
	|	Реквизиты.ВидДокумента КАК НазваниеДокумента,
	|	Реквизиты.СобытиеОС,
	|	ТаблицаОС.ОсновноеСредство,
	|	0 КАК СуммаЗатратБУ
	|ИЗ
	|	Реквизиты КАК Реквизиты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаОС КАК ТаблицаОС
	|		ПО (ИСТИНА)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчетТаблицаОС"" КАК ИмяСписка,
	|	&СинонимОС КАК СинонимСписка,
	|	Реквизиты.Период КАК Период,
	|	Реквизиты.Номер КАК Номер,
	|	Реквизиты.Регистратор КАК Регистратор,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.СтруктурноеПодразделение КАК СтруктурноеПодразделение,
	|	Реквизиты.ВидДокумента КАК НазваниеДокумента,
	|	Реквизиты.СпособОтраженияРасходовПоАмортизации,
	|	ТаблицаОС.ОсновноеСредство
	|ИЗ
	|	Реквизиты КАК Реквизиты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаОС КАК ТаблицаОС
	|		ПО (ИСТИНА)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки
	|";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();
		
КонецФункции

#КонецЕсли
