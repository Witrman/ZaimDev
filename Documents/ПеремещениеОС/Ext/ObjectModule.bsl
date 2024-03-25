﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	УправлениеВнеоборотнымиАктивамиСервер.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", Новый Структура("ОсновноеСредство"), Отказ);

	ПроверкаОСПоОрганизации(Отказ, ЭтотОбъект);
	
	ПроверкаОСПоУчетнымДанным(Отказ, ЭтотОбъект);
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если НачальноеЗаполнениеАналитикиНаСчетахУчетаОС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОС.НовыйПодразделениеОрганизации");
		МассивНепроверяемыхРеквизитов.Добавить("ОС.НовыйМОЛОрганизации");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ПеремещениеОС.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Если вдруг не удалось получить параметры проведения и не установлен флаг Отказ, то просто выйдем из проведения
	Если ПараметрыПроведения = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ТаблицаАмортизации = УправлениеВнеоборотнымиАктивамиСервер.ПодготовитьТаблицуРаспределениеАмортизацииПоНаправлениямРегл(ПараметрыПроведения.ТаблицаОСРаспределениеАмортизацииПоНаправлениямРегл, ПараметрыПроведения.Реквизиты, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	ФормироватьПроводкиБУ = Истина;
	
	Реквизиты = ПараметрыПроведения.Реквизиты[0];
	
	Если Реквизиты.СтруктурноеПодразделениеОтправитель = Реквизиты.СтруктурноеПодразделениеПолучатель Тогда
		Если Не (Реквизиты.ВедетсяАналитическийУчетОСПоМОЛ 
			Или Реквизиты.ВедетсяАналитическийУчетОСПоПодразделениям) Тогда
			ФормироватьПроводкиБУ = Ложь;
		КонецЕсли;  
	КонецЕсли;
	
	Если ПараметрыПроведения.ПеремещениеОСГрафикиАмортизацииОСБухгалтерскийУчет.Количество() <> 0 Тогда 
		УчетОС.СформироватьДвиженияИзменениеГрафиковАмортизацииОС(ПараметрыПроведения.ПеремещениеОСГрафикиАмортизацииОСБухгалтерскийУчет,
												Движения, Отказ);
	КонецЕсли;
	
	Если ПараметрыПроведения.ПеремещениеОСМестонахождениеОСБухгалтерскийУчет.Количество() <> 0 Тогда 
		УчетОС.СформироватьДвиженияМестонахождениеОСБух(ПараметрыПроведения.ПеремещениеОСМестонахождениеОСБухгалтерскийУчет,
												Движения, Отказ);
	КонецЕсли;
	
	Если ПараметрыПроведения.ПеремещениеОСНакопленнаяАмортизацияОСБУ.Количество() <> 0 И ФормироватьПроводкиБУ Тогда 
		УчетОС.СформироватьДвиженияПеремещениеОСНакопленнаяАмортизацияОСБУ(ПараметрыПроведения.ПеремещениеОСНакопленнаяАмортизацияОСБУ,
		                                        ПараметрыПроведения.Реквизиты,
		                                        Движения, Отказ);
		
	КонецЕсли;
	
	Если ПараметрыПроведения.ПеремещениеОСНачислениеАмортизацииОСБухгалтерскийУчет.Количество() <> 0 Тогда 
		УчетОС.СформироватьДвиженияИзменениеПризнакаНачисленияАмортизацииОС(ПараметрыПроведения.ПеремещениеОСНачислениеАмортизацииОСБухгалтерскийУчет,
		                                        ПараметрыПроведения.Реквизиты,
												Движения, Отказ);
	КонецЕсли;
	
	Если ПараметрыПроведения.ПеремещениеОСОбъектыЗемельногоНалога.Количество() <> 0 Тогда 
		УчетОС.СформироватьДвиженияИзменениеЗемельногоНалога(ПараметрыПроведения.ПеремещениеОСОбъектыЗемельногоНалога,
												ПараметрыПроведения.Реквизиты,
												Движения, Отказ);
	КонецЕсли;
	
	Если ПараметрыПроведения.ПеремещениеОСОбъектыИмущественногоНалога.Количество() <> 0 Тогда 
		УчетОС.СформироватьДвиженияОбъектыИмущественногоНалога(ПараметрыПроведения.ПеремещениеОСОбъектыИмущественногоНалога,
												ПараметрыПроведения.Реквизиты,
												Движения, Отказ);
	КонецЕсли;
	
	Если ПараметрыПроведения.ПеремещениеОСОбъектыТранспортногоНалога.Количество() <> 0 Тогда 
		УчетОС.СформироватьДвиженияИзменениеТранспортногоНалога(ПараметрыПроведения.ПеремещениеОСОбъектыТранспортногоНалога,
												ПараметрыПроведения.Реквизиты,
												Движения, Отказ);
	КонецЕсли;
	
	Если ПараметрыПроведения.ПеремещениеОСОстаткиПереоценокВА.Количество() <> 0 Тогда 
		УчетОС.СформироватьДвиженияПеремещениеОСОстаткиПереоценокВА(ПараметрыПроведения.ПеремещениеОСОстаткиПереоценокВА,
		                                        ПараметрыПроведения.Реквизиты,
		                                        Движения, Отказ);
	КонецЕсли;
	
	Если ПараметрыПроведения.ПеремещениеОСПараметрыАмортизацииОСБухгалтерскийУчет.Количество() <> 0 Тогда 
		УчетОС.СформироватьДвиженияПараметрыАмортизацииОСБухгалтерскийУчет(ПараметрыПроведения.ПеремещениеОСПараметрыАмортизацииОСБухгалтерскийУчет,
												Движения, Отказ);
	КонецЕсли;
	
	Если ПараметрыПроведения.ПеремещениеОСПервоначальныеСведенияОСБухгалтерскийУчет.Количество() <> 0 Тогда 
		УчетОС.СформироватьДвиженияПервоначальныеСведенияОСБух(ПараметрыПроведения.ПеремещениеОСПервоначальныеСведенияОСБухгалтерскийУчет,
												ПараметрыПроведения.Реквизиты,
												Движения, Отказ);
	КонецЕсли;
	
	Если ПараметрыПроведения.ПеремещениеОСРезервыПоПереоценкеОС.Количество() <> 0 И ФормироватьПроводкиБУ Тогда 
		УчетОС.СформироватьДвиженияПеремещениеОСРезервыПоПереоценкеОС(ПараметрыПроведения.ПеремещениеОСРезервыПоПереоценкеОС,
		                                        ПараметрыПроведения.Реквизиты,
		                                        Движения, Отказ);
	КонецЕсли;
	
	Если ПараметрыПроведения.ПеремещениеОССобытияОСОрганизаций.Количество() <> 0 Тогда 
		УчетОС.СформироватьДвиженияРегистрацияСобытияОС(ПараметрыПроведения.ПеремещениеОССобытияОСОрганизаций,
												ПараметрыПроведения.Реквизиты,
												Движения, Отказ);
	КонецЕсли;
	
	Если ПараметрыПроведения.ПеремещениеОССостоянияОСОрганизаций.Количество() <> 0 Тогда 
		УчетОС.СформироватьДвиженияИзменениеСостоянияОС(ПараметрыПроведения.ПеремещениеОССостоянияОСОрганизаций,
												ПараметрыПроведения.Реквизиты,
												Движения, Отказ);
	КонецЕсли;
	
	Если ПараметрыПроведения.ПеремещениеОССпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет.Количество() <> 0 Тогда 
		УчетОС.СформироватьДвиженияСпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет(ПараметрыПроведения.ПеремещениеОССпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет,
		                                        ПараметрыПроведения.Реквизиты,
												Движения, Отказ);
	КонецЕсли;
	
	Если ПараметрыПроведения.ПеремещениеОССтоимостьОСБУ.Количество() <> 0 И ФормироватьПроводкиБУ Тогда 
		УчетОС.СформироватьДвиженияПеремещениеОССтоимостьОСБУ(ПараметрыПроведения.ПеремещениеОССтоимостьОСБУ,
		                                        ПараметрыПроведения.Реквизиты,
		                                        Движения, Отказ);
	КонецЕсли;
	
	Если ПараметрыПроведения.ПеремещениеОССчетаУчетаОС.Количество() <> 0 Тогда 
		УчетОС.СформироватьДвиженияСчетовУчетаОСБух(ПараметрыПроведения.ПеремещениеОССчетаУчетаОС,
												ПараметрыПроведения.Реквизиты,
												Движения, Отказ);
	КонецЕсли;
	
	Если ТаблицаАмортизации.Количество() <> 0 И ФормироватьПроводкиБУ Тогда
		
		УправлениеВнеоборотнымиАктивамиСервер.СформироватьДвиженияАмортизацииПоНаправлениямРегл(ТаблицаАмортизации,
		                                        ПараметрыПроведения.Реквизиты,
		                                        Движения, Отказ);
	КонецЕсли;


КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	КраткийСоставМОЛ 		   = УправлениеВнеоборотнымиАктивамиСервер.ЗаполнитьКраткийСоставДокументаОСМОЛПодразделения(ОС, "МОЛОрганизации", Истина);
	КраткийСоставПодразделений = УправлениеВнеоборотнымиАктивамиСервер.ЗаполнитьКраткийСоставДокументаОСМОЛПодразделения(ОС, "ПодразделениеОрганизации", Ложь);
	
	КраткийСоставНовыйМОЛОрганизации 		   = УправлениеВнеоборотнымиАктивамиСервер.ЗаполнитьКраткийСоставДокументаОСМОЛПодразделения(ОС, "НовыйМОЛОрганизации", Истина);
	КраткийСоставНовыйПодразделениеОрганизации = УправлениеВнеоборотнымиАктивамиСервер.ЗаполнитьКраткийСоставДокументаОСМОЛПодразделения(ОС, "НовыйПодразделениеОрганизации", Ложь);

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПроверкаОСПоОрганизации(Отказ, ЭтотОбъект)

	// Проверим соответствие организайий ОС и организации документа

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокОС"      , ЭтотОбъект.ОС.ВыгрузитьКолонку("ОсновноеСредство"));
	Запрос.УстановитьПараметр("ВыбОрганизация", ЭтотОбъект.Организация);
	Запрос.УстановитьПараметр("ДатаСреза"     , ЭтотОбъект.Дата);
	Запрос.Текст = "ВЫБРАТЬ
	               |	МестонахождениеОСБухгалтерскийУчет.Организация КАК Организация,
	               |	ОсновныеСредства.Код КАК Инв,
	               |	ОсновныеСредства.Ссылка КАК ОсновноеСредство,
	               |	ПРЕДСТАВЛЕНИЕ(ОсновныеСредства.Ссылка) КАК ОсновноеСредствоПредставление
	               |ИЗ
	               |	Справочник.ОсновныеСредства КАК ОсновныеСредства
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			МестонахождениеОС.Период КАК Период,
	               |			МестонахождениеОС.Регистратор КАК Регистратор,
	               |			МестонахождениеОС.НомерСтроки КАК НомерСтроки,
	               |			МестонахождениеОС.Активность КАК Активность,
	               |			МестонахождениеОС.ОсновноеСредство КАК ОсновноеСредство,
	               |			МестонахождениеОС.Организация КАК Организация,
	               |			МестонахождениеОС.МОЛ КАК МОЛ,
	               |			МестонахождениеОС.Местонахождение КАК Местонахождение,
	               |			МестонахождениеОС.СтруктурноеПодразделение КАК СтруктурноеПодразделение
	               |		ИЗ
	               |			РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(&ДатаСреза, ОсновноеСредство В (&СписокОС)) КАК МестонахождениеОС
	               |		ГДЕ
	               |			МестонахождениеОС.Организация = &ВыбОрганизация
				   |) КАК МестонахождениеОСБухгалтерскийУчет
	               |		ПО ОсновныеСредства.Ссылка = МестонахождениеОСБухгалтерскийУчет.ОсновноеСредство
	               |ГДЕ
	               |	ОсновныеСредства.Ссылка В(&СписокОС)
	               |	И (НЕ ОсновныеСредства.ЭтоГруппа)
	               |	И МестонахождениеОСБухгалтерскийУчет.Организация ЕСТЬ NULL ";
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Количество() > 0 Тогда

		Отказ = Истина;
	
		Пока Выборка.Следующий() Цикл
			
			ИмяТаблицы = "ОС";
			
			СтруктураОтбора = Новый Структура();
			СтруктураОтбора.Вставить("ОсновноеСредство", Выборка.ОсновноеСредство);
		
			СтрокаТабличнойЧасти = ОбработкаТабличныхЧастейКлиентСервер.НайтиСтрокуТабЧасти(ЭтотОбъект, ИмяТаблицы, СтруктураОтбора);
		
			ТекстСообщения = НСтр("ru='Бух.учет: Несоответствие организаций ОС <%1> код <%2> и организации указанной в документе.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СокрЛП(Выборка.ОсновноеСредствоПредставление), СокрЛП(Выборка.Инв));
			Поле = "ОС[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ОсновноеСредство";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект.Ссылка, Поле, "Объект"); 

		КонецЦикла;

	КонецЕсли;

КонецПроцедуры // ПроверкаРеквизитов()

Процедура ПроверкаОСПоУчетнымДанным(Отказ, ЭтотОбъект)

	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ *
				   |ПОМЕСТИТЬ ПеремещениеОС
				   |ИЗ &ТаблицаОС КАК ТаблицаОС
				   |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	МестонахождениеОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство,
	               |	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Организация,
	               |	МестонахождениеОСБухгалтерскийУчетСрезПоследних.СтруктурноеПодразделение,
	               |	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение,
	               |	МестонахождениеОСБухгалтерскийУчетСрезПоследних.МОЛ
	               |ПОМЕСТИТЬ МестонахождениеОС
	               |ИЗ
	               |	РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
	               |			&Дата,
	               |			Организация = &Организация
	               |				И ОсновноеСредство В (&СписокОС)
				   |				И Регистратор <> &Ссылка) КАК МестонахождениеОСБухгалтерскийУчетСрезПоследних
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ПеремещениеОС.НомерСтроки,
	               |	ПеремещениеОС.ОсновноеСредство,
	               |	ПеремещениеОС.ОсновноеСредство.Код КАК Код,
	               |	ВЫБОР
	               |		КОГДА МестонахождениеОС.СтруктурноеПодразделение <> &СтруктурноеПодразделение
	               |			ТОГДА ЛОЖЬ
	               |		ИНАЧЕ ИСТИНА
	               |	КОНЕЦ КАК СтруктурноеПодразделениеСоответствуетМестонахождению,
	               |	ВЫБОР
	               |		КОГДА МестонахождениеОС.Местонахождение <> ПеремещениеОС.ПодразделениеОрганизации
	               |			ТОГДА ЛОЖЬ
	               |		ИНАЧЕ ИСТИНА
	               |	КОНЕЦ КАК ПодразделениеСоответствуетМестонахождению,
	               |	ВЫБОР
	               |		КОГДА МестонахождениеОС.МОЛ <> ПеремещениеОС.МОЛОрганизации
	               |			ТОГДА ЛОЖЬ
	               |		ИНАЧЕ ИСТИНА
	               |	КОНЕЦ КАК МОЛСоответствуетМестонахождению
	               |ИЗ
	               |	ПеремещениеОС КАК ПеремещениеОС
	               |		ЛЕВОЕ СОЕДИНЕНИЕ МестонахождениеОС КАК МестонахождениеОС
	               |		ПО ПеремещениеОС.ОсновноеСредство = МестонахождениеОС.ОсновноеСредство";
				   
	Запрос.УстановитьПараметр("Ссылка", 				  ЭтотОбъект.Ссылка);			   
	Запрос.УстановитьПараметр("Дата", 					  ЭтотОбъект.Дата);			   
	Запрос.УстановитьПараметр("Организация", 			  ЭтотОбъект.Организация);			   
	Запрос.УстановитьПараметр("СписокОС",				  ЭтотОбъект.ОС.ВыгрузитьКолонку("ОсновноеСредство"));
    Запрос.УстановитьПараметр("СтруктурноеПодразделение", ЭтотОбъект.СтруктурноеПодразделениеОтправитель);
	Запрос.УстановитьПараметр("ТаблицаОС",				  ЭтотОбъект.ОС.Выгрузить());

	РезультатЗапросаПоОС = Запрос.Выполнить();
	ТаблицаПоОС          = РезультатЗапросаПоОС.Выгрузить();
	
	Для Каждого СтрокаОС Из ТаблицаПоОС Цикл
		
		ИмяТаблицы = "ОС";
			
		СтруктураОтбора = Новый Структура();
		СтруктураОтбора.Вставить("ОсновноеСредство", СтрокаОС.ОсновноеСредство);
		
		СтрокаТабличнойЧасти = ОбработкаТабличныхЧастейКлиентСервер.НайтиСтрокуТабЧасти(ЭтотОбъект, ИмяТаблицы, СтруктураОтбора);
		

		Если Не СтрокаОС.СтруктурноеПодразделениеСоответствуетМестонахождению Тогда
			Отказ = Истина;
			
			ТекстСообщения = НСтр("ru='Несоответствие Структурного подразделения ОС <%1> код <%2> и Структурного подразделения - отправителя, указанного в документе.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СокрЛП(СтрокаОС.ОсновноеСредство), СокрЛП(СтрокаОС.Код));
			Поле = "ОС[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ОсновноеСредство";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект.Ссылка, Поле, "Объект"); 

		КонецЕсли;
		
		Если Не СтрокаОС.ПодразделениеСоответствуетМестонахождению Тогда
			Отказ = Истина;
			
			ТекстСообщения = НСтр("ru='Несоответствие Подразделения ОС <%1> код <%2> и Подразделения (тек.), указанного в документе.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СокрЛП(СтрокаОС.ОсновноеСредство), СокрЛП(СтрокаОС.Код));
			Поле = "ОС[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ОсновноеСредство";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект.Ссылка, Поле, "Объект"); 
			
		КонецЕсли;

		Если Не СтрокаОС.МОЛСоответствуетМестонахождению Тогда
			Отказ = Истина;
			
			ТекстСообщения = НСтр("ru='Несоответствие МОЛ ОС <%1> код <%2> и МОЛ (тек.), указанного в документе.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СокрЛП(СтрокаОС.ОсновноеСредство), СокрЛП(СтрокаОС.Код));
			Поле = "ОС[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ОсновноеСредство";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект.Ссылка, Поле, "Объект"); 
			
		КонецЕсли;
		
	КонецЦикла;


КонецПроцедуры // ПроверкаРеквизитов()


#КонецЕсли

