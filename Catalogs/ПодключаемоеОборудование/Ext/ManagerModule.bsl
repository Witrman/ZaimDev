﻿#Область ПрограммныйИнтерфейс

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Функция возвращает по идентификатору устройства его параметры.
//
Функция ПолучитьПараметрыУстройства(Идентификатор) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ПодключаемоеОборудование.Параметры
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|	ПодключаемоеОборудование.Ссылка = &Идентификатор ИЛИ ПодключаемоеОборудование.ИдентификаторУстройства = &Идентификатор");
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Результат = Выборка.Параметры.Получить();
	Возврат Результат;
	
КонецФункции

// Функция возвращает по идентификатору устройства параметры регистрации.
//
Функция ПолучитьПараметрыРегистрацииУстройства(Идентификатор) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПодключаемоеОборудование.Ссылка КАК Ссылка,
		|	ПодключаемоеОборудованиеПараметрыРегистрации.НаименованиеПараметра КАК НаименованиеПараметра,
		|	ПодключаемоеОборудованиеПараметрыРегистрации.ЗначениеПараметра КАК ЗначениеПараметра
		|ИЗ
		|	Справочник.ПодключаемоеОборудование.ПараметрыРегистрации КАК ПодключаемоеОборудованиеПараметрыРегистрации
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО ПодключаемоеОборудованиеПараметрыРегистрации.Ссылка = ПодключаемоеОборудование.Ссылка
		|ГДЕ
		|	(ПодключаемоеОборудование.Ссылка = &Идентификатор) ИЛИ
		|	(ПодключаемоеОборудование.ИдентификаторУстройства = &Идентификатор)";

	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ЕстьДанные = Ложь;
	ДанныеХранения = Новый Структура();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
		ДанныеХранения.Вставить(ВыборкаДетальныеЗаписи.НаименованиеПараметра, ВыборкаДетальныеЗаписи.ЗначениеПараметра);
		ЕстьДанные = Истина;
	КонецЦикла;
	
	РезультатОперации = МенеджерОборудованияКлиентСервер.ПараметрыРегистрацииККТ();
	РезультатОперации.Вставить("ЕстьДанные", ЕстьДанные);
	
	Если ЕстьДанные Тогда
		РезультатОперации.РегистрационныйНомерККТ = ДанныеХранения.РегистрационныйНомерККТ;
		РезультатОперации.ОрганизацияНазвание     = ДанныеХранения.ОрганизацияНазвание;
		РезультатОперации.ОрганизацияИНН          = ДанныеХранения.ОрганизацияИНН;
		
		Если ДанныеХранения.Свойство("АдресПроведенияРасчетов") Тогда
			РезультатОперации.АдресПроведенияРасчетов = ДанныеХранения.АдресПроведенияРасчетов; 
		КонецЕсли;
		Если ДанныеХранения.Свойство("МестоПроведенияРасчетов") Тогда
			РезультатОперации.МестоПроведенияРасчетов = ДанныеХранения.МестоПроведенияРасчетов; 
		КонецЕсли;
		
		РезультатОперации.КодыСистемыНалогообложения = ДанныеХранения.КодыСистемыНалогообложения;
		
		Если ДанныеХранения.Свойство("ПризнакАвтономногоРежима") И НЕ ПустаяСтрока(ДанныеХранения.ПризнакАвтономногоРежима) Тогда
			РезультатОперации.ПризнакАвтономногоРежима = Булево(ДанныеХранения.ПризнакАвтономногоРежима); 
		КонецЕсли;
		Если ДанныеХранения.Свойство("ПризнакШифрованиеДанных") И НЕ ПустаяСтрока(ДанныеХранения.ПризнакШифрованиеДанных) Тогда
			РезультатОперации.ПризнакШифрованиеДанных = Булево(ДанныеХранения.ПризнакШифрованиеДанных); 
		КонецЕсли;
		Если ДанныеХранения.Свойство("ПризнакРасчетовЗаУслуги") И НЕ ПустаяСтрока(ДанныеХранения.ПризнакРасчетовЗаУслуги) Тогда
			РезультатОперации.ПризнакАвтономногоРежима = Булево(ДанныеХранения.ПризнакАвтономногоРежима); 
		КонецЕсли;
		Если ДанныеХранения.Свойство("ПризнакФормированияБСО") И НЕ ПустаяСтрока(ДанныеХранения.ПризнакФормированияБСО) Тогда
			РезультатОперации.ПризнакФормированияБСО = Булево(ДанныеХранения.ПризнакФормированияБСО); 
		КонецЕсли;
		Если ДанныеХранения.Свойство("ПризнакРасчетовТолькоВИнтернет") И НЕ ПустаяСтрока(ДанныеХранения.ПризнакРасчетовТолькоВИнтернет) Тогда
			РезультатОперации.ПризнакРасчетовТолькоВИнтернет = Булево(ДанныеХранения.ПризнакРасчетовТолькоВИнтернет); 
		КонецЕсли;
		Если ДанныеХранения.Свойство("ПродажаПодакцизногоТовара") И НЕ ПустаяСтрока(ДанныеХранения.ПродажаПодакцизногоТовара) Тогда
			РезультатОперации.ПродажаПодакцизногоТовара = Булево(ДанныеХранения.ПродажаПодакцизногоТовара); 
		КонецЕсли;
		Если ДанныеХранения.Свойство("ПроведенияАзартныхИгр") И НЕ ПустаяСтрока(ДанныеХранения.ПроведенияАзартныхИгр) Тогда
			РезультатОперации.ПроведенияАзартныхИгр = Булево(ДанныеХранения.ПроведенияАзартныхИгр); 
		КонецЕсли;
		Если ДанныеХранения.Свойство("ПроведенияЛотерей") И НЕ ПустаяСтрока(ДанныеХранения.ПроведенияЛотерей) Тогда
			РезультатОперации.ПроведенияЛотерей = Булево(ДанныеХранения.ПроведенияЛотерей); 
		КонецЕсли;
		Если ДанныеХранения.Свойство("УстановкаПринтераВАвтомате") И НЕ ПустаяСтрока(ДанныеХранения.УстановкаПринтераВАвтомате) Тогда
			РезультатОперации.УстановкаПринтераВАвтомате = Булево(ДанныеХранения.УстановкаПринтераВАвтомате); 
		КонецЕсли;
		
		Если ДанныеХранения.Свойство("ПризнакиАгента") Тогда
			РезультатОперации.ПризнакиАгента = ДанныеХранения.ПризнакиАгента; 
		КонецЕсли;
		
		РезультатОперации.НомерАвтоматаДляАвтоматическогоРежима = ДанныеХранения.НомерАвтоматаДляАвтоматическогоРежима;
		РезультатОперации.ОрганизацияОФДИНН      = ДанныеХранения.ОрганизацияОФДИНН;
		РезультатОперации.ОрганизацияОФДНазвание = ДанныеХранения.ОрганизацияОФДНазвание;
		РезультатОперации.ЗаводскойНомерККТ      = ДанныеХранения.ЗаводскойНомерККТ;
		РезультатОперации.ЗаводскойНомерФН       = ДанныеХранения.ЗаводскойНомерФН;
		РезультатОперации.ВерсияФФДККТ           = ДанныеХранения.ВерсияФФДККТ;
		РезультатОперации.ВерсияФФДФН            = ДанныеХранения.ВерсияФФДФН;
		Если ДанныеХранения.Свойство("ПризнакФискализации") И НЕ ПустаяСтрока(ДанныеХранения.ПризнакФискализации) Тогда
			РезультатОперации.ПризнакФискализации = Булево(ДанныеХранения.ПризнакФискализации); 
		КонецЕсли;
	КонецЕсли;
	
	Возврат РезультатОперации;
	
КонецФункции

// Процедура предназначена для сохранения параметров устройства
// в реквизит Параметры типа хранилище значения в элементе справочника.
//
Функция СохранитьПараметрыУстройства(Идентификатор, Параметры) Экспорт

	Попытка
		Запрос = Новый Запрос("
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПодключаемоеОборудование.Ссылка
		|ИЗ
		|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|ГДЕ
		|	ПодключаемоеОборудование.Ссылка = &Идентификатор ИЛИ ПодключаемоеОборудование.ИдентификаторУстройства = &Идентификатор");
		
		Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
		ТаблицаРезультатов = Запрос.Выполнить().Выбрать();
		
		Пока ТаблицаРезультатов.Следующий() Цикл
			ОбъектСправочника = ТаблицаРезультатов.Ссылка.ПолучитьОбъект();
			ОбъектСправочника.Параметры = Новый ХранилищеЗначения(Параметры);
			
			Если Параметры.Свойство("ВидТранспортаОфлайнОбмена") Тогда
				ОбъектСправочника.ВидТранспортаОфлайнОбмена = Параметры.ВидТранспортаОфлайнОбмена;
			КонецЕсли;
			
			Если Параметры.Свойство("ИдентификаторWebСервисОборудования") Тогда
				ОбъектСправочника.ИдентификаторWebСервисОборудования = Параметры.ИдентификаторWebСервисОборудования;
			КонецЕсли;
			
			ОбъектСправочника.Записать();
			Результат = Истина;
			
			ОбновитьПовторноИспользуемыеЗначения();
		КонецЦикла;
		
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;

КонецФункции

// Процедура предназначена для сохранения параметров регистрации устройства
//
Функция СохранитьПараметрыРегистрацииУстройства(Идентификатор, ПараметрыРегистрации) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		Запрос = Новый Запрос("
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПодключаемоеОборудование.Ссылка
		|ИЗ
		|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|ГДЕ
		|	ПодключаемоеОборудование.Ссылка = &Идентификатор ИЛИ ПодключаемоеОборудование.ИдентификаторУстройства = &Идентификатор");
		
		Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
		ТаблицаРезультатов = Запрос.Выполнить().Выбрать();
		
		Пока ТаблицаРезультатов.Следующий() Цикл
			ОбъектСправочника = ТаблицаРезультатов.Ссылка.ПолучитьОбъект(); // СправочникОбъект.ПодключаемоеОборудование
			ОбъектСправочника.ПараметрыРегистрации.Очистить();
			Для Каждого ПараметрРегистрации Из ПараметрыРегистрации Цикл
				НоваяСтрока = ОбъектСправочника.ПараметрыРегистрации.Добавить();
				НоваяСтрока.НаименованиеПараметра = ПараметрРегистрации.Ключ;
				НоваяСтрока.ЗначениеПараметра = ПараметрРегистрации.Значение;
			КонецЦикла;
			ОбъектСправочника.Записать();
			Результат = Истина;
		КонецЦикла;
		
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;

КонецФункции

// Функция возвращает структуру с данными устройства
// (со значениями реквизитов элемента справочника).
// Параметры:
// 	Идентификатор - СправочникСсылка.ПодключаемоеОборудование - .
// Возвращаемое значение:
// 	Структура - Описание:
// * ОбработчикДрайвераИмя - Строка -
// * ОбработчикДрайвера 
// * ИмяКомпьютера 
// * РабочееМесто 
// * Параметры 
// * ИмяФайлаДрайвера 
// * ИмяМакетаДрайвера 
// * ПоставляетсяДистрибутивом 
// * ИдентификаторОбъекта 
// * ВСоставеКонфигурации 
// * ДрайверОборудованияИмя 
// * ДрайверОборудования 
// * ТипОборудованияИмя 
// * ТипОборудования 
// * Наименование 
// * ИдентификаторУстройства 
// * Ссылка 
Функция ПолучитьДанныеУстройства(Идентификатор) Экспорт

	ДанныеУстройства = Новый Структура();

	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ПодключаемоеОборудование.Ссылка КАК Ссылка,
	|	ПодключаемоеОборудование.ИдентификаторУстройства КАК ИдентификаторУстройства,
	|	ПодключаемоеОборудование.Наименование КАК Наименование,
	|	ПодключаемоеОборудование.ТипОборудования КАК ТипОборудования,
	|	ПодключаемоеОборудование.ДрайверОборудования КАК ДрайверОборудования,
	|	ПодключаемоеОборудование.РабочееМесто КАК РабочееМесто,
	|	ПодключаемоеОборудование.Параметры КАК Параметры,
	|	РабочиеМеста.ИмяКомпьютера КАК ИмяКомпьютера
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РабочиеМеста КАК РабочиеМеста
	|		ПО ПодключаемоеОборудование.РабочееМесто = РабочиеМеста.Ссылка
	|ГДЕ
	|	(ПодключаемоеОборудование.ИдентификаторУстройства = &Идентификатор
	|			ИЛИ ПодключаемоеОборудование.Ссылка = &Идентификатор)
	|");
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		// Заполним структуру данных устройства.
		ДанныеУстройства.Вставить("Ссылка"                    , Выборка.Ссылка);
		ДанныеУстройства.Вставить("ИдентификаторУстройства"   , Выборка.ИдентификаторУстройства);
		ДанныеУстройства.Вставить("Наименование"              , Выборка.Наименование);
		ДанныеУстройства.Вставить("ТипОборудования"           , Выборка.ТипОборудования);
		ДанныеУстройства.Вставить("ТипОборудованияИмя"        , МенеджерОборудованияВызовСервера.ПолучитьИмяТипаОборудования(Выборка.ТипОборудования));
		ДанныеУстройства.Вставить("ДрайверОборудования"       , Выборка.ДрайверОборудования);
		ДанныеУстройства.Вставить("ДрайверОборудованияИмя"    , Выборка.ДрайверОборудования.ИмяПредопределенныхДанных);
		ДанныеУстройства.Вставить("ВСоставеКонфигурации"      , Выборка.ДрайверОборудования.Предопределенный);
		ДанныеУстройства.Вставить("ИдентификаторОбъекта"      , Выборка.ДрайверОборудования.ИдентификаторОбъекта);
		ДанныеУстройства.Вставить("ПоставляетсяДистрибутивом" , Выборка.ДрайверОборудования.ПоставляетсяДистрибутивом);
		ДанныеУстройства.Вставить("ИмяМакетаДрайвера"         , Выборка.ДрайверОборудования.ИмяМакетаДрайвера);
		ДанныеУстройства.Вставить("ИмяФайлаДрайвера"          , Выборка.ДрайверОборудования.ИмяФайлаДрайвера);
		ДанныеУстройства.Вставить("Параметры"                 , Выборка.Параметры.Получить());
		ДанныеУстройства.Вставить("РабочееМесто"              , Выборка.РабочееМесто);
		ДанныеУстройства.Вставить("ИмяКомпьютера"             , Выборка.ИмяКомпьютера);
		ОбработчикДрайвера = Выборка.ДрайверОборудования.ОбработчикДрайвера;
		ДанныеУстройства.Вставить("ОбработчикДрайвера"        , ОбработчикДрайвера);
		ДанныеУстройства.Вставить("ОбработчикДрайвераИмя"     , XMLСтрока(ОбработчикДрайвера));
		
		Если ТипЗнч(ДанныеУстройства.Параметры) = Тип("Структура") Тогда
			ДанныеУстройства.Параметры.Вставить("Идентификатор", Выборка.Ссылка); 
		КонецЕсли;
	КонецЕсли;
		
	Возврат ДанныеУстройства;
	
КонецФункции

// Функция возвращает список подключенного в справочнике ПО
//
// Параметры:
// 	ТипыПО - Неопределено - Описание
// 	Идентификатор - Неопределено - Описание
// 	РабочееМесто - Неопределено - Описание
//
// Возвращаемое значение:
// 	Массив Из Структура - Описание:
// 	* Наименование - Строка - .
Функция ОборудованиеПоПараметрам(ТипыПО = Неопределено, Идентификатор = Неопределено, РабочееМесто = Неопределено) Экспорт

	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПодключаемоеОборудование.Ссылка КАК Ссылка,
	|	ПодключаемоеОборудование.ИдентификаторУстройства КАК ИдентификаторУстройства,
	|	ПодключаемоеОборудование.Наименование КАК Наименование,
	|	ПодключаемоеОборудование.ТипОборудования КАК ТипОборудования,
	|	ПодключаемоеОборудование.ДрайверОборудования КАК ДрайверОборудования,
	|	ПодключаемоеОборудование.РабочееМесто КАК РабочееМесто,
	|	ПодключаемоеОборудование.Параметры КАК Параметры,
	|	ПодключаемоеОборудование.ПараметрыРегистрации КАК ПараметрыРегистрации,
	|	РабочиеМеста.ИмяКомпьютера КАК ИмяКомпьютера
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РабочиеМеста КАК РабочиеМеста
	|		ПО (РабочиеМеста.Ссылка = ПодключаемоеОборудование.РабочееМесто)
	|ГДЕ
	|	(ПодключаемоеОборудование.УстройствоИспользуется)" +
		// Добавим в текст запроса условия-фильтры переданные в параметрах вызова.
		?(Идентификатор = Неопределено,
			// Добавим в текст запроса фильтр по типам оборудования (если задан).
		?(ТипыПО <> Неопределено,
		    "
		    |	И (ПодключаемоеОборудование.РабочееМесто <> ЗНАЧЕНИЕ(Справочник.РабочиеМеста.ПустаяСсылка))
		    |	И (ПодключаемоеОборудование.ТипОборудования В (&ТипОборудования))
		    |	И (РабочиеМеста.Ссылка = &РабочееМесто)",
		    "
		    |	И РабочиеМеста.Ссылка = &РабочееМесто"),
			// Добавим в текст запроса фильтр по конкретному устройству (имеет приоритет над другими фильтрами).
		  "
		  |	И (ПодключаемоеОборудование.РабочееМесто <> ЗНАЧЕНИЕ(Справочник.РабочиеМеста.ПустаяСсылка))
		  |	И (ПодключаемоеОборудование.Ссылка = &Идентификатор ИЛИ
		  |	   ПодключаемоеОборудование.ИдентификаторУстройства = &Идентификатор)") +
	"
	|	И (НЕ ПодключаемоеОборудование.ПометкаУдаления)";
					
	// Условие для принтеров чеков
	ТекстЗапроса = ТекстЗапроса + ?(Идентификатор = Неопределено,
		"
		|	И ПодключаемоеОборудование.Ссылка НЕ В (&СписокИсключаемыхПринтеров)",
		"");
	
	// Добавим полученное условие отбора к тексту запроса.
	ТекстЗапроса = ТекстЗапроса + "
	|УПОРЯДОЧИТЬ ПО
	|	ТипОборудования,
	|	Наименование;";

	Запрос = Новый Запрос(ТекстЗапроса);
	
	// Установим параметры запроса (фильтрующие выборку значения).
	Если Идентификатор = Неопределено Тогда
		// То используется фильтр по рабочему месту.
		Если НЕ ЗначениеЗаполнено(РабочееМесто) Тогда
			// Если РМ не задано в параметрах, то всегда текущее из параметров сеанса.
			РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
		КонецЕсли;

		Запрос.УстановитьПараметр("РабочееМесто", РабочееМесто);
		// И возможно фильтр по типам оборудования.
		Если ТипыПО <> Неопределено Тогда
			// Подготовка перечислений типов ТО для запроса.
			МассивТиповПО = Новый Массив();
			Если ТипЗнч(ТипыПО) = Тип("Структура") Тогда
				Для Каждого ТипПО Из ТипыПО Цикл
					МассивТиповПО.Добавить(Перечисления.ТипыПодключаемогоОборудования[ТипПО.Ключ]);
				КонецЦикла;
				
			ИначеЕсли ТипЗнч(ТипыПО) = Тип("Массив") Тогда
				Для Каждого ТипПО Из ТипыПО Цикл
					МассивТиповПО.Добавить(Перечисления.ТипыПодключаемогоОборудования[ТипПО]);
				КонецЦикла;
				
			Иначе
				МассивТиповПО.Добавить(Перечисления.ТипыПодключаемогоОборудования[ТипыПО]);
			КонецЕсли;
			
			Запрос.УстановитьПараметр("ТипОборудования", МассивТиповПО);
		КонецЕсли;
		// Фильтр для принтеров чеков
		ИсключаемыеПринтерыЧеков = ИнтеграцияWebKassaВызовСервераПереопределяемый.ПолучитьИспользуемыеПринтерыЧеков();
		Запрос.УстановитьПараметр("СписокИсключаемыхПринтеров", ИсключаемыеПринтерыЧеков);
	Иначе // Фильтр по конкретному устройству.
		Если ТипЗнч(Идентификатор) = Тип("Структура") И Идентификатор.Свойство("ИдентификаторУстройства") Тогда
			Запрос.УстановитьПараметр("Идентификатор", Идентификатор.ИдентификаторУстройства);
		Иначе
			Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
		КонецЕсли;
	КонецЕсли;

	Выборка = Запрос.Выполнить().Выбрать();
	
	// Перебирая выборку составляем список устройств.
	СписокОборудования = Новый Массив();
	Пока Выборка.Следующий() Цикл
		// Заполним структуру данных устройства.
		ДанныеУстройства = Новый Структура();
		ДанныеУстройства.Вставить("Ссылка"                    , Выборка.Ссылка);
		
		ДанныеУстройства.Вставить("ИдентификаторУстройства"   , Выборка.ИдентификаторУстройства);
		ДанныеУстройства.Вставить("Наименование"              , Выборка.Наименование);
		ДанныеУстройства.Вставить("ТипОборудования"           , Выборка.ТипОборудования);
		ДанныеУстройства.Вставить("ТипОборудованияИмя"        , МенеджерОборудованияВызовСервера.ПолучитьИмяТипаОборудования(Выборка.ТипОборудования));
		ДанныеУстройства.Вставить("ДрайверОборудования"       , Выборка.ДрайверОборудования);
		ДанныеУстройства.Вставить("ДрайверОборудованияИмя"    , Выборка.ДрайверОборудования.ИмяПредопределенныхДанных);
		ДанныеУстройства.Вставить("ВСоставеКонфигурации"      , Выборка.ДрайверОборудования.Предопределенный);
		ДанныеУстройства.Вставить("ИдентификаторОбъекта"      , Выборка.ДрайверОборудования.ИдентификаторОбъекта);
		ДанныеУстройства.Вставить("ПоставляетсяДистрибутивом" , Выборка.ДрайверОборудования.ПоставляетсяДистрибутивом);
		ДанныеУстройства.Вставить("ИмяМакетаДрайвера"         , Выборка.ДрайверОборудования.ИмяМакетаДрайвера);
		ДанныеУстройства.Вставить("ИмяФайлаДрайвера"          , Выборка.ДрайверОборудования.ИмяФайлаДрайвера);
		ДанныеУстройства.Вставить("Параметры"                 , Выборка.Параметры.Получить());
		ДанныеУстройства.Вставить("РабочееМесто"              , Выборка.РабочееМесто);
		ДанныеУстройства.Вставить("ИмяКомпьютера"             , Выборка.ИмяКомпьютера);
		ОбработчикДрайвера = Выборка.ДрайверОборудования.ОбработчикДрайвера;
		ДанныеУстройства.Вставить("ОбработчикДрайвера"        , ОбработчикДрайвера);
		ДанныеУстройства.Вставить("ОбработчикДрайвераИмя"     , XMLСтрока(ОбработчикДрайвера));
		
		Если Выборка.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККТ Тогда
			ПараметрыРегистрации = ПолучитьПараметрыРегистрацииУстройства(Выборка.Ссылка);
		Иначе
			ПараметрыРегистрации = Новый Структура();
		КонецЕсли;
		ДанныеУстройства.Вставить("ПараметрыРегистрации", ПараметрыРегистрации);
		
		Если ТипЗнч(ДанныеУстройства.Параметры) = Тип("Структура") Тогда
			ДанныеУстройства.Параметры.Вставить("Идентификатор", Выборка.Ссылка);
		КонецЕсли;
		СписокОборудования.Добавить(ДанныеУстройства);
	КонецЦикла;
	
	// Возвращаем полученный список с данными всех найденных устройств.
	Возврат СписокОборудования;
	
КонецФункции

// СтандартныеПодсистемы.УправлениеДоступом
// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Менеджер = "Справочник.ПодключаемоеОборудование";
	МенеджерОборудованияВызовСервераПереопределяемый.ПриЗаполненииОграниченияДоступа(Менеджер, Ограничение);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецЕсли

#КонецОбласти