﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры 

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт

	Элементы = Форма.Элементы;
	
	Элементы.ГруппаПериод.Видимость = Истина;
	Форма.ЕстьНачалоПериодаБК       = Истина;
	Форма.ЕстьКонецПериодаБК        = Истина;
	
	Элементы.Период.Видимость = Ложь;
	Форма.ЕстьПериодБК        = Ложь;
	
	Элементы.ГруппаДополнительные.Видимость = Ложь;
	
	Форма.ВидРегистраОтчета = "РегистрНалоговогоУчетаПоИПНиСН";
	
	Форма.ПеречислениеРазделыНалоговогоУчета        = Перечисления.РазделыНалоговогоУчета.НалогиСЗаработнойПлаты;
	Форма.РежимВыбораСтруктурныхЕдиниц              = "ПоНалогоплательщику";
	Элементы.ГруппаОрганизацияРегистрНУ.Видимость   = Истина;
	Элементы.ГруппаОрганизация.Видимость            = Ложь;
	
	Элементы.ВыводитьЗаголовок.Видимость            = Истина;
	Элементы.ВыводитьПодписи.Видимость              = Истина;
	Элементы.ВыводитьПодписиРуководителей.Видимость = Ложь;
	
	Если НЕ Форма.РежимРасшифровки Тогда
		Форма.НачалоПериода = НачалоМесяца(ОбщегоНазначения.ТекущаяДатаПользователя());
		Форма.КонецПериода  = КонецМесяца(ОбщегоНазначения.ТекущаяДатаПользователя());
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если НЕ ТипЗнч(Контекст) = Тип("ФормаКлиентскогоПриложения") Тогда
		Возврат;
	КонецЕсли;

	ИмяИсходногоВарианта = Контекст.НастройкиОтчета.ИмяИсходногоВарианта;
	
	Если ИмяИсходногоВарианта <> "РегистрНалоговогоУчетаПоИПНиСН" И ИмяИсходногоВарианта <> "АнализНачисленийУдержанийПрочихЛиц" Тогда
		ИмяИсходногоВарианта = Отчеты.РегистрНалоговогоУчетаПоИПНиСН.НайтиВариантПоКлючу(ИмяИсходногоВарианта);
	КонецЕсли;
	
	Если ИмяИсходногоВарианта <> "РегистрНалоговогоУчетаПоИПНиСН" И ИмяИсходногоВарианта <> "АнализНачисленийУдержанийПрочихЛиц"
		И НовыеПользовательскиеНастройкиКД <> Неопределено
		И НовыеПользовательскиеНастройкиКД.ДополнительныеСвойства.Свойство("ВидРегистраОтчета") Тогда
		ИмяИсходногоВарианта = НовыеПользовательскиеНастройкиКД.ДополнительныеСвойства.ВидРегистраОтчета;
	КонецЕсли;
	
	Если ИмяИсходногоВарианта = "РегистрНалоговогоУчетаПоИПНиСН" ИЛИ ИмяИсходногоВарианта = "АнализНачисленийУдержанийПрочихЛиц" Тогда
		//СхемаКомпоновкиДанных = ПолучитьМакет(ИмяИсходногоВарианта);
		//ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, ИмяИсходногоВарианта);
		Если Контекст.ИмяФормы = "ОбщаяФорма.ФормаОтчетаБК" Тогда
			Контекст.ВидРегистраОтчета = ИмяИсходногоВарианта;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ДополнительныеСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
	Если ДополнительныеСвойства.Свойство("НастройкиОтчета") И ТипЗнч(ДополнительныеСвойства.НастройкиОтчета) = Тип("Структура") Тогда
		НастройкиОтчета  = ДополнительныеСвойства.НастройкиОтчета;
		НачалоПериода    = НастройкиОтчета.НачалоПериода;
		КонецПериода     = НастройкиОтчета.КонецПериода;
		Налогоплательщик = НастройкиОтчета.Налогоплательщик;
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, Новый Структура("КорректностьПериода", Истина));
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ПользовательскиеНастройки = КомпоновщикНастроек.ПользовательскиеНастройки;
	
	ХранилищеСвойств = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "НастройкиОтчета");
	Если ХранилищеСвойств <> Неопределено И ТипЗнч(ХранилищеСвойств.Значение) = Тип("ХранилищеЗначения") Тогда
		НастройкиОтчета = ХранилищеСвойств.Значение.Получить();
	Иначе
		Возврат;
	КонецЕсли;
		
	РежимРасшифровки = КомпоновщикНастроек.ФиксированныеНастройки.ДополнительныеСвойства.Свойство("РежимРасшифровки");
	
	НастройкиОтчета.Вставить("ИспользоватьПослеВыводаРезультата", Истина);
	
	Если НастройкиОтчета.ВыводитьЗаголовок Тогда
		Отчеты.РегистрНалоговогоУчетаПоИПНиСН.ПриВыводеЗаголовка(НастройкиОтчета, ДокументРезультат);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НастройкиОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(НастройкиОтчета.НачалоПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Период"       , НачалоДня(НастройкиОтчета.НачалоПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", Дата(1, 1, 1));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Период"       , Дата(1, 1, 1));
	КонецЕсли;
	Если ЗначениеЗаполнено(НастройкиОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(НастройкиОтчета.КонецПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", Дата(3999, 11, 1));
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПроизводственныйКалендарь", КалендарныеГрафики.ПроизводственныйКалендарьРеспубликиКазахстан());
	
	ПользовательскийОтбор = ПользовательскиеНастройки.Элементы.Найти(КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки);
	Если ТипЗнч(ПользовательскийОтбор) = Тип("ОтборКомпоновкиДанных") Тогда
		СписокПолейОтбора = Новый Массив;
		СписокПолейОтбора.Добавить("Налогоплательщик");
		СписокПолейОтбора.Добавить("СтруктурнаяЕдиница");
		ПроверяемыйОтбор = БухгалтерскиеОтчетыКлиентСервер.НайтиЭлементыОтбора(ПользовательскийОтбор, СписокПолейОтбора);
		Для Каждого ЭлементОтбора Из ПроверяемыйОтбор Цикл
			ПользовательскийОтбор.Элементы.Удалить(ЭлементОтбора);
		КонецЦикла;
		Если ЗначениеЗаполнено(НастройкиОтчета.Налогоплательщик) Тогда
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскийОтбор, "Налогоплательщик", НастройкиОтчета.Налогоплательщик, ВидСравненияКомпоновкиДанных.Равно);
		КонецЕсли;
		Если НастройкиОтчета.ПоддержкаРаботыСоСтруктурнымиПодразделениями 
			И СхемаКомпоновкиДанных.НаборыДанных["НаборДанных1"].Поля.Найти("СтруктурнаяЕдиница") <> Неопределено
			И ЗначениеЗаполнено(НастройкиОтчета.СписокСтруктурныхЕдиниц) Тогда
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскийОтбор, "СтруктурнаяЕдиница", НастройкиОтчета.СписокСтруктурныхЕдиниц, ВидСравненияКомпоновкиДанных.ВСписке);
		КонецЕсли;
	КонецЕсли;
	
	НастройкиОтчета.Вставить("ВысотаШапки", 1);
	
	ПоляГруппировок = Новый Массив;
	Для Каждого ЭлементНастроек Из ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ЭлементНастроек) = Тип("СтруктураНастроекКомпоновкиДанных") Тогда
			ПолучитьПоляГруппировокСтруктуры(ЭлементНастроек, ПоляГруппировок);
		КонецЕсли;
	КонецЦикла;
	
	ВыводитьУсловныйВес = Ложь;
	
	ГруппировкаРегистратор = ПоляГруппировок.Найти("Регистратор");
	ГруппировкаРегистраторИспользование = ГруппировкаРегистратор <> Неопределено;
	
	ГруппировкаПериодВзаиморасчетов = ПоляГруппировок.Найти("ПериодВзаиморасчетов");
	ГруппировкаПериодВзаиморасчетовИспользование = ГруппировкаПериодВзаиморасчетов <> Неопределено;
	
	ВыводитьУсловныйВес = ГруппировкаРегистраторИспользование ИЛИ ГруппировкаПериодВзаиморасчетовИспользование;
	
	Если КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("КлючВарианта")  Тогда
		КлючВарианта 					= КомпоновщикНастроек.Настройки.ДополнительныеСвойства.КлючВарианта;
		РегистрНалоговогоУчетаПоИПНиСН 	= Отчеты.РегистрНалоговогоУчетаПоИПНиСН.НайтиВариантПоКлючу(КлючВарианта) = "РегистрНалоговогоУчетаПоИПНиСН";
	Иначе
		РегистрНалоговогоУчетаПоИПНиСН 	= Истина;
	КонецЕсли;	
	
	ХранилищеСвойств = Новый ХранилищеЗначения(НастройкиОтчета);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НастройкиОтчета", ХранилищеСвойств);
	
	ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("НастройкиОтчета", НастройкиОтчета);
	
	Если РежимРасшифровки Тогда
		
		// Компоновка макета
		
		СтандартнаяОбработка = Ложь;
		
		ДокументРезультат.Очистить();
		
		НастройкиДляКомпоновкиМакета = КомпоновщикНастроек.ПолучитьНастройки();
		
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		
		Попытка
			
			СхемаКомпоновкиДанных.МакетыГруппировок.Очистить();
			
			МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиДляКомпоновкиМакета, ДанныеРасшифровки);

			ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
			ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,, ДанныеРасшифровки, Истина);

			ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
			ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
			
			ПроцессорВывода.НачатьВывод();
			ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
			
		Исключение
			// Запись в журнал регистрации не требуется
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			Пока ИнформацияОбОшибке.Причина <> Неопределено Цикл
				ИнформацияОбОшибке = ИнформацияОбОшибке.Причина;
			КонецЦикла;
			ТекстСообщения = НСтр("ru = 'Отчет не сформирован!'") + Символы.ПС + ИнформацияОбОшибке.Описание;
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПолучитьПоляГруппировокСтруктуры(СтруктураНастроек, ПоляГруппировок)
	
	Если СтруктураНастроек.Структура.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементСтруктуры Из СтруктураНастроек.Структура Цикл
		Если ТипЗнч(ЭлементСтруктуры) = Тип("ГруппировкаКомпоновкиДанных") Тогда
			Для Каждого ПолеГруппировки Из ЭлементСтруктуры.ПоляГруппировки.Элементы Цикл
				Если ПолеГруппировки.Использование Тогда
					ПоляГруппировок.Добавить(Строка(ПолеГруппировки.Поле));
				КонецЕсли;
			КонецЦикла;
			ПолучитьПоляГруппировокСтруктуры(ЭлементСтруктуры, ПоляГруппировок);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры	

Процедура ВывестиПодписи(ДокументРезультат) Экспорт
	
	ДополнительныеСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
	Если ДополнительныеСвойства.Свойство("НастройкиОтчета") И ТипЗнч(ДополнительныеСвойства.НастройкиОтчета) = Тип("Структура") Тогда
		НастройкиОтчета = ДополнительныеСвойства.НастройкиОтчета;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если НастройкиОтчета.ВыводитьПодписи Тогда
		Отчеты.РегистрНалоговогоУчетаПоИПНиСН.ПриВыводеПодвала(НастройкиОтчета, ДокументРезультат);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

#КонецЕсли