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

Процедура ЗаполнитьПоДокументуОснования(Объект, Основание) Экспорт
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеНМА") Тогда
		
		Объект.НМА.Очистить();
		
		Объект.Организация 			    = Основание.Организация;
		Объект.СтруктурноеПодразделение = Основание.СтруктурноеПодразделение;
		Объект.СпособПоступления 		= Перечисления.СпособыПоступленияАктивов.ПриобретениеЗаПлату; 
		
		Для Каждого ТекСтрокаНМА Из Основание.НМА Цикл
			НоваяСтрока = Объект.НМА.Добавить();
			НоваяСтрока.НематериальныйАктив = ТекСтрокаНМА.НематериальныйАктив;
			НоваяСтрока.СчетУчетаБУ		 	= ТекСтрокаНМА.СчетУчетаБУ;
		
			Сумма = Окр((ТекСтрокаНМА.Сумма * Основание.КурсВзаиморасчетов / ?(Основание.КратностьВзаиморасчетов = 0, 1, Основание.КратностьВзаиморасчетов)),2);
			СуммаНДС = Окр((ТекСтрокаНМА.СуммаНДС * Основание.КурсВзаиморасчетов / ?(Основание.КратностьВзаиморасчетов = 0, 1, Основание.КратностьВзаиморасчетов)),2);
			
			НоваяСтрока.СтоимостьБУ = Сумма;
			
			Если Основание.НДСВключенВСтоимость И НЕ Основание.СуммаВключаетНДС Тогда 			
				НоваяСтрока.СтоимостьБУ = Сумма + СуммаНДС;				
			ИначеЕсли НЕ Основание.НДСВключенВСтоимость И Основание.СуммаВключаетНДС Тогда 			
				НоваяСтрока.СтоимостьБУ = Сумма - СуммаНДС;
			КонецЕсли;
 
		КонецЦикла;
		
		Объект.ДокументОснование = Основание; 
		ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(Объект, Основание);
	
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗаполнитьСчетаУчетаВСтрокеТабЧасти(Организация, Дата, СтрокаТЧ) Экспорт

	СчетаУчета = УправлениеВнеоборотнымиАктивамиСервер.ПолучитьСчетаУчетаНМА(Организация, СтрокаТЧ.НематериальныйАктив, Дата);
	
	Если СчетаУчета.СчетУчетаБУ = ПланыСчетов.Типовой.ПустаяСсылка() Тогда 
		Если СтрокаТЧ.НематериальныйАктив.ВидНМА = Перечисления.ВидыНМА.Гудвилл Тогда
			СчетаУчета.СчетУчетаБУ = ПланыСчетов.Типовой.Гудвилл;
		Иначе
			СчетаУчета.СчетУчетаБУ = ПланыСчетов.Типовой.ПрочиеНематериальныеАктивы;	
		КонецЕсли;
	КонецЕсли;
	
	Если СчетаУчета.СчетНачисленияАмортизацииБУ = ПланыСчетов.Типовой.ПустаяСсылка() Тогда 
		Если СтрокаТЧ.НематериальныйАктив.ВидНМА = Перечисления.ВидыНМА.Гудвилл Тогда
			СчетаУчета.СчетНачисленияАмортизацииБУ = ПланыСчетов.Типовой.ОбесценениеГудвилла ;
		Иначе
			СчетаУчета.СчетНачисленияАмортизацииБУ = ПланыСчетов.Типовой.АмортизацияПрочихНематериальныхАктивов;	
		КонецЕсли;
	КонецЕсли;
	
	СтрокаТЧ.СчетУчетаБУ  				  = СчетаУчета.СчетУчетаБУ;
	СтрокаТЧ.СчетНачисленияАмортизацииБУ  = СчетаУчета.СчетНачисленияАмортизацииБУ;

КонецПроцедуры 

Процедура ЗаполнитьСчетаУчетаВТабЧасти(Организация, Дата, ТабличнаяЧасть)Экспорт 
	
	Для каждого СтрокаТабЧасти Из ТабличнаяЧасть Цикл
		ЗаполнитьСчетаУчетаВСтрокеТабЧасти(Организация, Дата, СтрокаТабЧасти);
	КонецЦикла;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Проведение

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт
	
	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка"						  , ДокументСсылка);
		
	НомераТаблиц = Новый Структура;
	
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента(НомераТаблиц);
	Результат = Запрос.ВыполнитьПакет();
	
	ТаблицаРеквизиты = Результат[НомераТаблиц["Реквизиты"]].Выгрузить();
	ПараметрыПроведения.Вставить("Реквизиты", ТаблицаРеквизиты);
	
	Реквизиты = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРеквизиты[0]);
	
	Если НЕ УчетнаяПолитикаСервер.Существует(Реквизиты.Организация, Реквизиты.Период, "БУ", Истина, ДокументСсылка) 
		ИЛИ НЕ УчетнаяПолитикаСервер.Существует(Реквизиты.Организация, Реквизиты.Период, "НУ", Истина, ДокументСсылка) Тогда
		Отказ = Истина;
	КонецЕсли;
			
	Если Отказ Тогда
		Возврат ПараметрыПроведения;
	КонецЕсли;           	
			
	Налогоплательщик       = Реквизиты.Организация;
	СтруктурнаяЕдиница     = Реквизиты.Организация;
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	
	Запрос.УстановитьПараметр("ПоддержкаРаботыСоСтруктурнымиПодразделениями",          ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	Запрос.УстановитьПараметр("НачалоПериода", Реквизиты.Период); 	
	Запрос.УстановитьПараметр("Организация", Реквизиты.Организация); 	
	
				
	НомераТаблиц = Новый Структура;
	Запрос.Текст = 	ТекстЗапросаПринятиеКУчетуНМАТаблица(НомераТаблиц)
					+ ТекстЗапросаОбъектыНалоговогоУчетаФА(НомераТаблиц)
					+ ТекстЗапросаСостоянияНМА(НомераТаблиц)
					+ ТекстЗапросаФАУчитываемыеОтдельно(НомераТаблиц)
					+ ТекстЗапросаОбъектыИмущественногоНалога(НомераТаблиц); 								
	         	
	Результат = Запрос.ВыполнитьПакет();
	
	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;
	
	Возврат ПараметрыПроведения;

КонецФункции

Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц)
	
	НомераТаблиц.Вставить("ВременнаяТаблицаРеквизиты", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("Реквизиты", НомераТаблиц.Количество());
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	""ПринятиеКУчетуНМА"" КАК ВидДокумента,
	|	Реквизиты.Ссылка КАК Ссылка,
	|	Реквизиты.Дата КАК Дата,
	|	Реквизиты.Организация,
	|	Реквизиты.СтруктурноеПодразделение,
	|	Реквизиты.СпособПоступления
	|ПОМЕСТИТЬ Реквизиты
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Реквизиты.ВидДокумента,
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация,
	|	Реквизиты.СтруктурноеПодразделение,
	|	Реквизиты.СпособПоступления
	|ИЗ
	|	Реквизиты КАК Реквизиты";

	Возврат ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаПринятиеКУчетуНМАТаблица(НомераТаблиц)

	НомераТаблиц.Вставить("ВременнаяТаблицаНМА", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ТаблицаНМА", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.ПринятКУчету) КАК Состояние,
	|	ТаблицаНМА.НомерСтроки,
	|	ТаблицаНМА.ГруппаНУ,
	|	ТаблицаНМА.НачислятьАмортизациюБУ КАК НачислятьАмортизацию,
	|	ТаблицаНМА.НематериальныйАктив,
	|	ТаблицаНМА.ОбъектИмущественногоНалога,
	|	ТаблицаНМА.ОбъемПродукцииРаботДляВычисленияАмортизацииБУ КАК ОбъемПродукцииРаботДляВычисленияАмортизации,
	|	ТаблицаНМА.ПорядокПогашенияСтоимостиНУ,
	|	ТаблицаНМА.ПризнакФиксированногоАктива,
	|	ТаблицаНМА.СпособНачисленияАмортизацииБУ КАК СпособНачисленияАмортизации,
	|	ТаблицаНМА.СпособОтраженияРасходовПоАмортизацииБУ КАК СпособОтраженияРасходовПоАмортизации,
	|	ТаблицаНМА.СрокПолезногоИспользованияБУ КАК СрокПолезногоИспользования,
	|	ТаблицаНМА.СтоимостьБУ КАК ПервоначальнаяСтоимость,
	|	ТаблицаНМА.СчетНачисленияАмортизацииБУ,
	|	ТаблицаНМА.СчетУчетаБУ
	|ПОМЕСТИТЬ ТаблицаНМА
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА.НМА КАК ТаблицаНМА
	|ГДЕ
	|	ТаблицаНМА.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.ПринятКУчету) КАК Состояние,
	|	ТАблицаНМА.НомерСтроки,
	|	ТАблицаНМА.ГруппаНУ,
	|	ТАблицаНМА.НачислятьАмортизацию,
	|	ТАблицаНМА.НематериальныйАктив,
	|	ТАблицаНМА.ОбъектИмущественногоНалога,
	|	ТАблицаНМА.ОбъемПродукцииРаботДляВычисленияАмортизации,
	|	ТАблицаНМА.ПорядокПогашенияСтоимостиНУ,
	|	ТАблицаНМА.ПризнакФиксированногоАктива,
	|	ТАблицаНМА.СпособНачисленияАмортизации,
	|	ТАблицаНМА.СпособОтраженияРасходовПоАмортизации,
	|	ТАблицаНМА.СрокПолезногоИспользования,
	|	ТАблицаНМА.ПервоначальнаяСтоимость,
	|	ТАблицаНМА.СчетНачисленияАмортизацииБУ,
	|	ТАблицаНМА.СчетУчетаБУ,
	|	ТАблицаНМА.ПервоначальнаяСтоимость КАК СтоимостьДляВычисленияАмортизации,
	|	Реквизиты.Способпоступления КАК СпособПоступления
	|ИЗ
	|	ТаблицаНМА КАК ТАблицаНМА
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Реквизиты КАК реквизиты
	|		ПО (ИСТИНА)"
	+ ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();

	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапросаОбъектыНалоговогоУчетаФА(НомераТаблиц)

	ТекстЗапроса = "";
	
	НомераТаблиц.Вставить("ТаблицаОбъектыНалоговогоУчетаФА", НомераТаблиц.Количество());		
	
	ТекстЗапроса = 	"ВЫБРАТЬ
	               	|	ТаблицаНМА.НематериальныйАктив КАК ФиксированныйАктив,
	               	|	ТаблицаНМА.ГруппаНУ,
	               	|	ТаблицаНМА.ПорядокПогашенияСтоимостиНУ,
	               	|	ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийФА.ПринятКУчету) КАК СостояниеФиксированногоАктива
	               	|ИЗ
	               	|	ТаблицаНМА КАК ТаблицаНМА
	               	|ГДЕ
	               	|	ТаблицаНМА.ПризнакФиксированногоАктива
	               	|
	               	|УПОРЯДОЧИТЬ ПО
	               	|	ТаблицаНМА.НомерСтроки"
		+ ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();  
		
	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапросаФАУчитываемыеОтдельно(НомераТаблиц)
	                             	
	НомераТаблиц.Вставить("ТаблицаФАУчитываемыеОтдельно", НомераТаблиц.Количество());		
		
	ТекстЗапроса = 	"ВЫБРАТЬ
	               	|	ТаблицаНМА.НематериальныйАктив КАК ФиксированныйАктив,
	               	|	ВЫБОР
	               	|		КОГДА ТаблицаНМА.ПорядокПогашенияСтоимостиНУ = ЗНАЧЕНИЕ(Перечисление.ПорядокПогашенияСтоимостиФА.НачислениеАмортизацииПоДвойнойНорме)
	               	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыФАУчитываемыхОтдельно.ДвойнаяНормаАмортизации)
	               	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыФАУчитываемыхОтдельно.ОбъектыПреференций)
	               	|	КОНЕЦ КАК ВидЛьготыФА,
	               	|	ЗНАЧЕНИЕ(Перечисление.СобытияФАУчитываемыхОтдельно.ПринятиеКУчету) КАК Событие
	               	|ИЗ
	               	|	ТаблицаНМА КАК ТаблицаНМА
	               	|ГДЕ
	               	|	ТаблицаНМА.ПризнакФиксированногоАктива
	               	|	И ТаблицаНМА.ПорядокПогашенияСтоимостиНУ <> ЗНАЧЕНИЕ(Перечисление.ПорядокПогашенияСтоимостиФА.НачислениеАмортизации)
	               	|
	               	|УПОРЯДОЧИТЬ ПО
	               	|	ТаблицаНМА.НомерСтроки"
					
		+ ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();
		
		
	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапросаСостоянияНМА(НомераТаблиц)

	НомераТаблиц.Вставить("ТаблицаСостоянийНМА", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.Ссылка КАК Регистратор,
	|	ТаблицаНМА.Состояние КАК Состояние,
	|	ТаблицаНМА.НематериальныйАктив КАК НематериальныйАктив
	|ИЗ
	|	ТаблицаНМА КАК ТаблицаНМА
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Реквизиты КАК Реквизиты
	|		ПО (ИСТИНА)" ;
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаОбъектыИмущественногоНалога(НомераТаблиц)
	
	НомераТаблиц.Вставить("РеквизитыОбъектыИмущественногоНалога", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ТаблицаОбъектыИмущественногоНалога", НомераТаблиц.Количество());
	ТекстЗапроса = 	
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация,
	|	Реквизиты.СтруктурноеПодразделение,
	|	&ПоддержкаРаботыСоСтруктурнымиПодразделениями
	|ИЗ
	|	Реквизиты КАК Реквизиты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаНМА.НематериальныйАктив КАК ОбъектНалогообложения,
	|	ИСТИНА КАК НачислятьНалог,
	|	Реквизиты.СтруктурноеПодразделение КАК Местонахождение,
	|	Реквизиты.СтруктурноеПодразделение КАК СтруктурнаяЕдиницаИмущественногоНалога
	|ИЗ
	|	ТаблицаНМА КАК ТаблицаНМА
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Реквизиты КАК Реквизиты
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ТаблицаНМА.ОбъектИмущественногоНалога = ИСТИНА
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаНМА.НомерСтроки"	
	
	+ ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();
	
	Возврат ТекстЗапроса;	      	

КонецФункции

Процедура ДобавитьКолонкуСодержание(ТаблицаЗначений, ТекстСодержания = "") Экспорт
	
	Если ТаблицаЗначений = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТаблицаЗначений.Колонки.Найти("Содержание") = Неопределено Тогда
		ТаблицаЗначений.Колонки.Добавить("Содержание", ОбщегоНазначенияБККлиентСервер.ПолучитьОписаниеТиповСтроки(150));
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекстСодержания) Тогда 
		ТекстСодержания = НСтр("ru='Выручка от реализации НМА'");
	КонецЕсли;
	
	Для каждого СтрокаТаблицы Из ТаблицаЗначений Цикл
		
		СтрокаТаблицы.Содержание = ТекстСодержания;
		
	КонецЦикла;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// ДА-1 (Акт премки-передачи)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПечатьДА1";
	КомандаПечати.Представление = НСтр("ru = 'ДА-1 (Акт приемки-передачи)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.ПроверкаПроведенияПередПечатью = НЕ ПользователиБКВызовСервераПовтИсп.РазрешитьПечатьНепроведенныхДокументов();
	КомандаПечати.Порядок = 50;
	
	// Настраиваемый комплект документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПечатьДА1";
	КомандаПечати.Представление = НСтр("ru = 'Настраиваемый комплект документов'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = НЕ ПользователиБКВызовСервераПовтИсп.РазрешитьПечатьНепроведенныхДокументов();
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Настраиваемый комплект'");
	КомандаПечати.ДополнитьКомплектВнешнимиПечатнымиФормами = Истина;
	КомандаПечати.Порядок = 75;
	
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
	
	// Печать ДА-1 (Акт премки-передачи)
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПечатьДА1");
	Если НужноПечататьМакет Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ПечатьДА1",
			НСтр("ru = 'ДА-1 (Акт приемки-передачи)'"),
			ПечатьДА1(МассивОбъектов, ОбъектыПечати),
			,
			"ОбщийМакет.ПФ_MXL_ДА1");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Подготовка табличных печатных документов.

// Функция формирует табличный документ с печатной формой накладной,
// разработанной методистами
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьДА1(МассивОбъектов, ОбъектыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_ДА1");
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	// Зададим параметры макета по умолчанию
	ТабДокумент.ПолеСверху              = 10;
	ТабДокумент.ПолеСлева               = 0;
	ТабДокумент.ПолеСнизу               = 0;
	ТабДокумент.ПолеСправа              = 0;
	ТабДокумент.РазмерКолонтитулаСверху = 10;
	ТабДокумент.ОриентацияСтраницы      = ОриентацияСтраницы.Ландшафт;
	
	// Загрузим настройки пользователя
	ТабДокумент.КлючПараметровПечати = "ПринятиеКУчетуНМА_ДА1";
	
	// Варианты заголовков разделов с подписями печатной формы	
	ЗаголовокРазделаКомиссии = Новый Структура();
	ЗаголовокРазделаКомиссии.Вставить("ПредседательКомиссии", "Председатель комиссии");
	ЗаголовокРазделаКомиссии.Вставить("ЧленыКомиссии",        "Члены комиссии");
	
	// запрос для реквизитов шапки 
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка", МассивОбъектов);
	Запрос.Текст = "ВЫБРАТЬ
	|	ПринятиеКУчетуНМА.Дата,
	|	ПринятиеКУчетуНМА.Ссылка,
	|	ПринятиеКУчетуНМА.Номер,
	|	ПринятиеКУчетуНМА.Организация,
	|	ПринятиеКУчетуНМА.СтруктурноеПодразделение КАК ПодразделениеОрганизации,
	|	ПринятиеКУчетуНМА.ДокументОснование,
	|	ПринятиеКУчетуНМА.Ответственный,
	|	ПринятиеКУчетуНМА.НМА.(
	|		НомерСтроки,
	|		ВЫРАЗИТЬ(ПринятиеКУчетуНМА.НМА.НематериальныйАктив.НаименованиеПолное КАК СТРОКА(1000)) КАК НематериальныйАктивНаименованиеПолное,
	|		НематериальныйАктив КАК НематериальныйАктивНаименование,
	|		НематериальныйАктив.Код КАК ИнвентарныйНомер,
	|		СтоимостьБУ,
	|		СрокПолезногоИспользованияБУ,
	|		СчетУчетаБУ
	|	)
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК ПринятиеКУчетуНМА
	|ГДЕ
	|	ПринятиеКУчетуНМА.Ссылка В(&Ссылка)";	
	
	Док = Запрос.Выполнить().Выбрать();
	Пока Док.Следующий() Цикл
		
		Если ТабДокумент.ВысотаТаблицы > 0 Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		ТаблицаНМА = Док.НМА.Выгрузить();
		
		СтруктурнаяЕдиницаОрганизация = ОбщегоНазначенияБК.ПолучитьСтруктурнуюЕдиницу(Док.Организация, Док.ПодразделениеОрганизации);
				
		// Получаем области макета для вывода в табличный документ
		Шапка            		  = Макет.ПолучитьОбласть("Шапка");
		Таблица1		 		  = Макет.ПолучитьОбласть("Таблица1");
		СтрокаТаблицы1			  = Макет.ПолучитьОбласть("СтрокаТаблицы1");
		ЗаголовокТаблицы2		  = Макет.ПолучитьОбласть("ЗаголовокТаблицы2");
		СтрокаТаблицы2   		  = Макет.ПолучитьОбласть("СтрокаТаблицы2");
		ИтогоСтрокаТаблицы2		  = Макет.ПолучитьОбласть("ИтогоСтрокаТаблицы2");
		Приказ			 		  = Макет.ПолучитьОбласть("Приказ");
		Подвал           		  = Макет.ПолучитьОбласть("Подвал");	
		ШапкаОборотнойСтороны	  = Макет.ПолучитьОбласть("ШапкаОборотнойСтороны");	
		ОССдал			 		  = Макет.ПолучитьОбласть("ОССдал|Сдал");
		ПодвалВерх	     		  = Макет.ПолучитьОбласть("ПодвалВерх");
		ПодвалНиз	     		  = Макет.ПолучитьОбласть("ПодвалНиз");
		ПодвалДатаСдал   		  = Макет.ПолучитьОбласть("ПодвалДата|Сдал");
		ПодвалДатаПринял 		  = Макет.ПолучитьОбласть("ПодвалДата|Принял");
		ОСПринял		 		  = Макет.ПолучитьОбласть("ОССдал|Принял");
		Комиссия         		  = Макет.ПолучитьОбласть("Комиссия");	
		ПодписьГлавногоБухгалтера = Макет.ПолучитьОбласть("ПодписьГлавногоБухгалтера");
		ПустаяСекцияСдал 		  = Макет.ПолучитьОбласть("ПодвалПустаяСекция|Сдал");
		ПустаяСекцияПринял		  = Макет.ПолучитьОбласть("ПодвалПустаяСекция|Принял");
				
		////////////////////////////////////////////////////////////////////////
		// 1-я страница формы
		
		// Выведем шапку документа
		СведенияОбОрганизации = ОбщегоНазначенияБКВызовСервера.СведенияОЮрФизЛице(СтруктурнаяЕдиницаОрганизация, Док.Дата);
		Руководители 		  = ОбщегоНазначенияБКВызовСервера.ОтветственныеЛицаОрганизаций(СтруктурнаяЕдиницаОрганизация, Док.Дата);
		
		// Организация-сдатчик
		Сдатчик = "";
		СчетКт  = "";
		Если Док.ДокументОснование <> Неопределено И ЗначениеЗаполнено(Док.ДокументОснование) Тогда
			СведенияОбОрганизацииСдатчике					= ОбщегоНазначенияБКВызовСервера.СведенияОЮрФизЛице(Док.ДокументОснование.Контрагент, Док.Дата);
			Сдатчик											= ОбщегоНазначенияБКВызовСервера.ОписаниеОрганизации(СведенияОбОрганизацииСдатчике, "ПолноеНаименование,");
			СчетКт 											= Док.ДокументОснование.СчетУчетаРасчетовСКонтрагентом;
			Шапка.Параметры.ПредставлениеОрганизацииСдатчик = Сдатчик;
			Шапка.Параметры.ОрганизацияРНН_БИН_Сдатчик		= ОбщегоНазначенияБКВызовСервера.ОписаниеОрганизации(СведенияОбОрганизацииСдатчике, "БИН_ИИН,", Ложь, Док.Дата, "ru");
		КонецЕсли;
		
		// Организация-получатель
		ПредставлениеОрганизацииПолучатель				   = ОбщегоНазначенияБКВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,");
		Шапка.Параметры.ПредставлениеОрганизацииПолучатель = ПредставлениеОрганизацииПолучатель;
		Шапка.Параметры.ОрганизацияРНН_БИН_Получатель	   = ОбщегоНазначенияБКВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "БИН_ИИН,", Ложь, Док.Дата, "ru");
		
		Шапка.Параметры.НомерДок          		 = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Док.Номер, Док.Ссылка);
		Шапка.Параметры.ДатаДок           		 = Формат(Док.Дата,"ДЛФ=Д");
		Шапка.Параметры.РасшифровкаПодписиПринял = Руководители.Руководитель;
		Шапка.Параметры.ДолжностьПринял          = Руководители.РуководительДолжность;
		
		ТабДокумент.Вывести(Шапка);
				
		ТабДокумент.Вывести(Таблица1);  		
		
		//Заполняем раздел "Основание"
		Если Док.ДокументОснование <> Неопределено И ЗначениеЗаполнено(Док.ДокументОснование) Тогда 
			СтрокаТаблицы1.Параметры.НаимДокОсн	 = Док.ДокументОснование.Метаданные().Синоним;
			СтрокаТаблицы1.Параметры.НомерДокОсн = Док.ДокументОснование.Номер;
			СтрокаТаблицы1.Параметры.ДатаДокОсн	 = Док.ДокументОснование.Дата;
		КонецЕсли;	
		
		Для Каждого СтрокаНМА Из ТаблицаНМА Цикл
					
			СтрокаТаблицы1.Параметры.Заполнить(СтрокаНМА);
			
			СтрокаТаблицы1.Параметры.НаименованиеОС 		 = ?(ЗначениеЗаполнено(СтрокаНМА.НематериальныйАктивНаименованиеПолное), СокрЛП(СтрокаНМА.НематериальныйАктивНаименованиеПолное), СтрокаНМА.НематериальныйАктивНаименование);
			СтрокаТаблицы1.Параметры.ПервоначальнаяСтоимость = СтрокаНМА.СтоимостьБУ;
			
			ТабДокумент.Вывести(СтрокаТаблицы1);
			
		КонецЦикла;       		
		
		// выводим вторую часть таблицы
		ЗаголовокТаблицы2.Параметры.Валюта = ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		ТабДокумент.Вывести(ЗаголовокТаблицы2);
		
		ДокументПринятияКУчетуБУ = Неопределено;
		ДатаПринятияКУчету 	 	 = '00010101';
		ИтогоБалансоваяСтоимость = 0;
		
		// Выведем строки таблицы
		Для Каждого СтрокаНМА Из ТаблицаНМА Цикл
					
			СтрокаТаблицы2.Параметры.Заполнить(СтрокаНМА);
					
			СтрокаТаблицы2.Параметры.СчетКт 			 = СчетКт;
			СтрокаТаблицы2.Параметры.СчетДт 			 = СтрокаНМА.СчетУчетаБУ;
			СтрокаТаблицы2.Параметры.БалансоваяСтоимость = СтрокаНМА.СтоимостьБУ;
			СтрокаТаблицы2.Параметры.СрокСлужбыПолезной  = СтрокаНМА.СрокПолезногоИспользованияБУ;
			
			ИтогоБалансоваяСтоимость							   = ИтогоБалансоваяСтоимость + СтрокаТаблицы2.Параметры.БалансоваяСтоимость;
			ИтогоСтрокаТаблицы2.Параметры.ИтогоБалансоваяСтоимость = ИтогоБалансоваяСтоимость;
			ТабДокумент.Вывести(СтрокаТаблицы2);
			
		КонецЦикла;
		
		ТабДокумент.Вывести(ИтогоСтрокаТаблицы2);
		
		//формируем список основных средств через запятую
		СписокНМА = "";
		СписокНаименованийНМА = ТаблицаНМА.Скопировать();
		СписокНаименованийНМА.Свернуть("НематериальныйАктивНаименованиеПолное");
		Для Каждого СтрокаНМА ИЗ СписокНаименованийНМА Цикл
			Если СписокНМА = "" Тогда
				СписокНМА = СокрЛП(СтрокаНМА.НематериальныйАктивНаименованиеПолное);
			Иначе
				СписокНМА = СписокНМА + ", " + СокрЛП(СтрокаНМА.НематериальныйАктивНаименованиеПолное);
			КонецЕсли;	
		КонецЦикла;	
		
		Приказ.Параметры.ДокументОснованиеВид	= НСтр("ru = 'приказа (распоряжения)'");
		Приказ.Параметры.ДокументОснованиеДата	= """_____"""+ НСтр("ru = '________________________ 20_____года'");
		Приказ.Параметры.ДокументОснованиеНомер = "__________ ";
		Приказ.Параметры.НаименованиеОбъекта	= СписокНМА;
		ТабДокумент.Вывести(Приказ);
		
		ТабДокумент.Вывести(Подвал);
		
		//выводим комиссию
		
		//сначала председатель 
		Комиссия.Параметры.ЗаголовокРазделаКомиссии = ЗаголовокРазделаКомиссии.ПредседательКомиссии;
		Комиссия.Параметры.Должность                = "";
		Комиссия.Параметры.РасшифровкаПодписи       = "";
		
		ТабДокумент.Вывести(Комиссия);
		
		// Выведем подписи членов комиссии
		ВыводитьЗаголовок = Истина;
		
		Для Итератор = 1 По 3 Цикл
						
			Комиссия.Параметры.ЗаголовокРазделаКомиссии = ?(ВыводитьЗаголовок, ЗаголовокРазделаКомиссии.ЧленыКомиссии, "");
			Комиссия.Параметры.Должность          = "";
			Комиссия.Параметры.РасшифровкаПодписи = "";
			
			ТабДокумент.Вывести(Комиссия);
			
			ВыводитьЗаголовок = Ложь; // в следующей итерации вывод заголовка не нужен
			
		КонецЦикла;
		
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		ТабДокумент.Вывести(ШапкаОборотнойСтороны);
		
		ОССдал.Параметры.ОбъектОсновныхСредств = НСтр("ru = 'Долгосрочный актив'");
		ОССдал.Параметры.Сдал				   = НСтр("ru = 'Сдал'");
		ТабДокумент.Вывести(ОССдал);
		
		ОСПринял.Параметры.Принял = НСтр("ru = 'Принял'");
		
		Если ЗначениеЗаполнено(Док.Ответственный.ФизЛицо) Тогда 
			ДанныеОФизЛице						  = ПроцедурыУправленияПерсоналомВызовСервера.ДанныеФизЛица(Док.Организация, Док.Ответственный.ФизЛицо, Док.Дата);
			ОСПринял.Параметры.Должность          = ДанныеОФизЛице.Должность;
			ОСПринял.Параметры.РасшифровкаПодписи = ДанныеОФизЛице.Представление;
		Иначе
			ОСПринял.Параметры.РасшифровкаПодписи = Док.Ответственный;
		КонецЕсли;
		
		ТабДокумент.Присоединить(ОСПринял);
		
		ТабДокумент.Вывести(ПодвалДатаСдал);
		ТабДокумент.Присоединить(ПодвалДатаПринял);
		
		ПодвалВерх.Параметры.Доверенность = НСтр("ru = '№_____________ от ""____""___________________ 20___ года'");
		
		ТабДокумент.Вывести(ПодвалВерх);
		ТабДокумент.Вывести(ПодвалНиз);
		
		// Выведем подпись бухгалтера
		ПодписьГлавногоБухгалтера.Параметры.РасшифровкаПодписиПринял = Руководители.ГлавныйБухгалтер;
		
		ТабДокумент.Вывести(ПодписьГлавногоБухгалтера);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, Док.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДокумент;

КонецФункции

#КонецЕсли
