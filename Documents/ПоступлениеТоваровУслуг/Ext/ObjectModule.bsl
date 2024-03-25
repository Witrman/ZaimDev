﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Область УправлениеДоступом

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	УчетТоваров.ЗаполнитьНаборыПоОрганизацииСтрутурномуПодразделениюСкладу(ЭтотОбъект, Таблица, "Организация", "СтруктурноеПодразделение", "Склад");
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснования(ДанныеЗаполнения);
		Возврат;
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Основание") И ДанныеЗаполнения.Свойство("ВводНаОсновании") Тогда
			ВыбранныйВидОперации = Неопределено;
			ДанныеЗаполнения.Свойство("ВидОперации", ВыбранныйВидОперации);
			ЗаполнитьПоДокументуОснования(ДанныеЗаполнения.Основание, ВыбранныйВидОперации);
			Возврат;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, Константы.ВалютаРегламентированногоУчета.Получить());

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПользовательУправляетСчетамиУчета = СчетаУчетаВДокументахВызовСервераПовтИсп.ПользовательУправляетСчетамиУчета();
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	ПараметрыПострочнойПроверки   = Новый Структура("ПроверятьЗаполнениеСчетаУчетаНДС, ПроверятьЗаполнениеСчетаУчетаНУ",
													УчитыватьНДС И НЕ НДСВключенВСтоимость И ПользовательУправляетСчетамиУчета,
													Товары.Количество() > 0);
	
	Если ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ВПереработку Тогда		
		МассивНепроверяемыхРеквизитов.Добавить("Услуги");
		МассивНепроверяемыхРеквизитов.Добавить("ОС");
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Импорт Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Услуги");
		
		Если Товары.Количество() > 0 
			ИЛИ ОС.Количество() > 0 Тогда
			
			МассивНепроверяемыхРеквизитов.Добавить("Товары");
			МассивНепроверяемыхРеквизитов.Добавить("ОС");
			
		КонецЕсли;
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Товары Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Услуги");
		МассивНепроверяемыхРеквизитов.Добавить("ОС");
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Услуги Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары");
		МассивНепроверяемыхРеквизитов.Добавить("ОС");
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ОсновныеСредства Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги");
		
	ИначеЕсли ЭтотОбъект.Товары.Количество() > 0 
		ИЛИ ЭтотОбъект.Услуги.Количество() > 0
			ИЛИ ЭтотОбъект.ОС.Количество() > 0 Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги");
		МассивНепроверяемыхРеквизитов.Добавить("ОС");
		
	КонецЕсли;
	
	Если ЭтотОбъект.Товары.Количество() = 0 Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Склад");
		
	КонецЕсли;
	
	// Проверка заполнения табличной части "Товары"
	Если Не УчетнаяПолитикаСервер.ПлательщикНалогаНаПрибыль(Организация, Дата)
		Или Не УчитыватьКПН
		Или ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ВПереработку Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВидУчетаНУ");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.СчетЗатратНУ");
		МассивНепроверяемыхРеквизитов.Добавить("ОС.СчетУчетаНУ");
		
		ПараметрыПострочнойПроверки.Вставить("ПроверятьЗаполнениеСчетаУчетаНУ", Ложь);
		
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ВПереработку Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаРасчетовСКонтрагентом");
		
		Если ОС.Количество() > 0 Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ОС.ОсновноеСредство");
			МассивНепроверяемыхРеквизитов.Добавить("ОС.Сумма");
			МассивНепроверяемыхРеквизитов.Добавить("ОС.СтавкаНДС");
			МассивНепроверяемыхРеквизитов.Добавить("ОС.СчетУчетаБУ");
			МассивНепроверяемыхРеквизитов.Добавить("ОС.СчетУчетаНУ");
			МассивНепроверяемыхРеквизитов.Добавить("ОС.НДСВидОборота");
			МассивНепроверяемыхРеквизитов.Добавить("ОС.НДСВидПоступления");
			МассивНепроверяемыхРеквизитов.Добавить("ОС.ПодразделениеОрганизации");
			МассивНепроверяемыхРеквизитов.Добавить("ОС.МОЛОрганизации");
		КонецЕсли;
		Если Услуги.Количество() > 0 Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Услуги.Номенклатура");
			МассивНепроверяемыхРеквизитов.Добавить("Услуги.Сумма");
			МассивНепроверяемыхРеквизитов.Добавить("Услуги.СтавкаНДС");
			МассивНепроверяемыхРеквизитов.Добавить("Услуги.СчетЗатратБУ");
			МассивНепроверяемыхРеквизитов.Добавить("Услуги.СчетЗатратНУ");
			МассивНепроверяемыхРеквизитов.Добавить("Услуги.НДСВидОборота");
			МассивНепроверяемыхРеквизитов.Добавить("Услуги.НДСВидПоступления");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Импорт Тогда
		
		Если Услуги.Количество() > 0 Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Услуги.Номенклатура");
			МассивНепроверяемыхРеквизитов.Добавить("Услуги.Сумма");
			МассивНепроверяемыхРеквизитов.Добавить("Услуги.СтавкаНДС");
			МассивНепроверяемыхРеквизитов.Добавить("Услуги.СчетЗатратБУ");
			МассивНепроверяемыхРеквизитов.Добавить("Услуги.СчетЗатратНУ");
			МассивНепроверяемыхРеквизитов.Добавить("Услуги.НДСВидОборота");
			МассивНепроверяемыхРеквизитов.Добавить("Услуги.НДСВидПоступления");
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНДС(Организация, Дата)
		ИЛИ НЕ УчитыватьНДС 
		ИЛИ ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ВПереработку 
		ИЛИ ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Импорт 
		ИЛИ ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ПоступлениеОтНерезидента 
		ИЛИ ОтложитьПринятиеНДСКЗачету Тогда
		
		ПараметрыПострочнойПроверки.Вставить("ПроверятьЗаполнениеСчетаУчетаНДС", Ложь);
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.НДСВидОборота");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.НДСВидПоступления");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СтавкаНДС");
		
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.НДСВидОборота");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.НДСВидПоступления");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.СтавкаНДС");
		
		МассивНепроверяемыхРеквизитов.Добавить("ОС.НДСВидОборота");
		МассивНепроверяемыхРеквизитов.Добавить("ОС.НДСВидПоступления");
		МассивНепроверяемыхРеквизитов.Добавить("ОС.СтавкаНДС");
		
	КонецЕсли;
	
	Если НЕ УправлениеВнеоборотнымиАктивамиСервер.ВедетсяАналитическийУчетОСПоПодразделениям(Дата) Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ОС.ПодразделениеОрганизации");
		
	КонецЕсли;
	
	Если НЕ УправлениеВнеоборотнымиАктивамиСервер.ВедетсяАналитическийУчетОСПоМОЛ(Дата) Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ОС.МОЛОрганизации");
		
	КонецЕсли;
		
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	НеобходимаПострочнаяПроверка = Ложь;
	Для Каждого КлючЗначение Из ПараметрыПострочнойПроверки Цикл
		Если КлючЗначение.Значение Тогда 
			НеобходимаПострочнаяПроверка = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НеобходимаПострочнаяПроверка Тогда 
		Если ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ВПереработку Тогда
			Если Товары.Количество() > 0 Тогда
				ПроверитьЗаполнениеТабличнойЧастиПострочно(Товары, "Товары", Отказ, ПараметрыПострочнойПроверки);
			КонецЕсли;
			
		ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Импорт Тогда
			Если Товары.Количество() > 0 Тогда
				ПроверитьЗаполнениеТабличнойЧастиПострочно(Товары, "Товары", Отказ, ПараметрыПострочнойПроверки);
			КонецЕсли;
			Если ОС.Количество() > 0 Тогда
				ПараметрыПострочнойПроверки.Вставить("ПроверятьЗаполнениеСчетаУчетаНУ", Ложь);
				ПроверитьЗаполнениеТабличнойЧастиПострочно(ОС    ,     "ОС", Отказ, ПараметрыПострочнойПроверки);
			КонецЕсли;
			
		Иначе
			Если Товары.Количество() > 0 Тогда
				ПроверитьЗаполнениеТабличнойЧастиПострочно(Товары, "Товары", Отказ, ПараметрыПострочнойПроверки);
			КонецЕсли;
			Если ОС.Количество() > 0 Тогда
				ПараметрыПострочнойПроверки.Вставить("ПроверятьЗаполнениеСчетаУчетаНУ", Ложь);
				ПроверитьЗаполнениеТабличнойЧастиПострочно(ОС    ,     "ОС", Отказ, ПараметрыПострочнойПроверки);
			КонецЕсли;
			Если Услуги.Количество() > 0 Тогда
				ПараметрыПострочнойПроверки.Вставить("ПроверятьЗаполнениеСчетаУчетаНУ", Ложь);
				ПроверитьЗаполнениеТабличнойЧастиПострочно(Услуги, "Услуги", Отказ, ПараметрыПострочнойПроверки);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	СчетаУчетаВДокументах.ПроверитьЗаполнение(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, Новый Соответствие);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ВПереработку Тогда		
		ОС.Очистить();
		Услуги.Очистить();	
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Импорт Тогда
		Услуги.Очистить();
	КонецЕсли;
	
	УчетНДСИАкциза.ОчиститьДанныеПоУчастникамСовместнойДеятельности(ЭтотОбъект, ДоговорКонтрагента);

	Если НЕ УчитыватьКПН Тогда
		ВидУчетаНУ = Справочники.ВидыУчетаНУ.ПустаяСсылка();
	КонецЕсли;
	
	СуммаДокумента = УчетНДСИАкциза.ПолучитьСуммуДокументаСНДС(ЭтотОбъект);
	
	СчетаУчетаВДокументах.ЗаполнитьПередЗаписью(ЭтотОбъект, РежимЗаписи);
	
	УчетНДСИАкциза.СинхронизацияПометкиНаУдалениеУСчетаФактуры(ЭтотОбъект, "СчетФактураПолученный", Отказ);
	
	РаботаСДоговорамиКонтрагентов.ЗаполнитьДоговорПередЗаписью(ЭтотОбъект);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//синхронизируем данные счет-фактуры и документа основания
	УчетНДСИАкциза.СинхронизироватьДанныеДокументаИСчетаФактуры(ЭтотОбъект, Отказ, "СчетФактураПолученный"); 		
	Если Отказ Тогда
		ТекстСообщения = НСтр("ru = 'Документ не записан ...'");
		ОбщегоНазначенияБК.ОшибкаПриПроведении(ТекстСообщения, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета(),,, ОбъектКопирования.Ссылка);
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект, Ложь);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.ПоступлениеТоваровУслуг.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ (АНАЛИЗ ОСТАТКОВ И Т.П.)

	// Таблица взаиморасчетов
	ТаблицаВзаиморасчеты = УправлениеВзаиморасчетамиСервер.ПодготовитьТаблицуВзаиморасчетовЗачетАвансов(
		ПараметрыПроведения.ЗачетАвансовТаблицаДокумента, ПараметрыПроведения.ЗачетАвансовРеквизиты, Отказ);

	// Таблицы документа с корректировкой сумм по курсу авансов
	СтруктураТаблицДокумента = УчетДоходовРасходов.ПодготовитьТаблицыПоступленияПоКурсуАвансов(ПараметрыПроведения.СтруктураТаблицДокумента,
		ТаблицаВзаиморасчеты, ПараметрыПроведения.ЗачетАвансовРеквизиты);
		
	ОбщегоНазначенияБКВызовСервера.ДобавитьКолонкуВТаблицуЗначений(ТаблицаВзаиморасчеты, "НомерЖурнала", НСтр("ru = 'АВ'"));
	
	УчетОС.ПроверитьВозможностьИзмененияСостоянияОС(
		ПараметрыПроведения.ТаблицаОСДляПроверки,
		ПараметрыПроведения.РеквизитыДляПроверкиОС, Отказ);

	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	// Зачет аванса
	УправлениеВзаиморасчетамиСервер.СформироватьДвиженияЗачетАвансов(ТаблицаВзаиморасчеты,
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Движения, Отказ);
		
	// Поступление ОС
	УчетОС.СформироватьДвиженияПоступлениеОС(СтруктураТаблицДокумента.ТаблицаОС,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	УчетОС.СформироватьДвиженияРегистрацияСобытияОС(ПараметрыПроведения.ТаблицаОССобытияОСОрганизаций,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	УчетОС.СформироватьДвиженияИзменениеСостоянияОС(ПараметрыПроведения.ТаблицаОССостоянияОСОрганизаций,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// Поступление товаров
	УчетТоваров.СформироватьДвиженияПоступлениеТоваров(СтруктураТаблицДокумента.ТаблицаТовары,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// Товары организаций
	НомераГТДСервер.СформироватьДвиженияТоварыОрганизаций(ПараметрыПроведения.ТаблицаТоварыОрганизаций,ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// Поступление услуг
	УчетДоходовРасходов.СформироватьДвиженияПоступлениеУслуг(СтруктураТаблицДокумента.ТаблицаУслуги,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// Учет НДС
	УчетНДСИАкциза.СформироватьДвиженияПоступлениеТоваров(ПараметрыПроведения.ТаблицаНДС, ПараметрыПроведения.ТаблицаУчастникиСовместнойДеятельности,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// Переоценка валютных остатков - после формирования проводок всеми другими механизмами
	ТаблицаПереоценкаДвиженийДокумента = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкаВалютныхОстатковПоПроводкамДокумента(
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценкаДвиженийДокумента,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	// Отражение ПР в НУ 
	ПроцедурыНалоговогоУчета.ОтразитьПостоянныеРазницыВНУ(ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	// Синхронизация счетов-фактур
	УчетНДСИАкциза.СинхронизацияПризнакаПроведенияУСчетаФактуры(Ссылка, Отказ, Истина, "СчетФактураПолученный");
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	УчетНДСИАкциза.СинхронизацияПризнакаПроведенияУСчетаФактуры(Ссылка, Отказ, Ложь, "СчетФактураПолученный");

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура выполняет заполнение документа по документу-основанию
//
Процедура ЗаполнитьПоДокументуОснования(Основание, ВыбранныйВидОперации = Неопределено) Экспорт
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.Доверенность") Тогда
		Документы.ПоступлениеТоваровУслуг.ЗаполнитьДокументПоДоверенности(ЭтотОбъект, Основание, ВыбранныйВидОперации);
		
	ИначеЕсли ТипЗнч(Основание) = Тип("СправочникСсылка.ОсновныеСредства") Тогда
		Документы.ПоступлениеТоваровУслуг.ЗаполнитьДокументПоСправочникуОС(ЭтотОбъект, Основание, ВыбранныйВидОперации);
	
	ИначеЕсли (ТипЗнч(Основание) = Тип("ДокументСсылка.РеализацияТоваровУслуг"))
			ИЛИ (ТипЗнч(Основание) = Тип("ДокументОбъект.РеализацияТоваровУслуг")) Тогда
		Документы.ПоступлениеТоваровУслуг.ЗаполнитьДокументПоРеализации(ЭтотОбъект, Основание, ВыбранныйВидОперации);
		
	ИначеЕсли (ТипЗнч(Основание) = Тип("ДокументСсылка.ПередачаОС"))
			ИЛИ (ТипЗнч(Основание) = Тип("ДокументОбъект.ПередачаОС")) Тогда
		Документы.ПоступлениеТоваровУслуг.ЗаполнитьДокументПоПередачеОС(ЭтотОбъект, Основание, ВыбранныйВидОперации);
	
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.СчетФактураПолученный") Тогда
		Документы.ПоступлениеТоваровУслуг.ЗаполнитьДокументПоСчетФактураПолученный(ЭтотОбъект, Основание, ВыбранныйВидОперации);
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ОплатаОтПокупателяПлатежнойКартой") Тогда
		Документы.ПоступлениеТоваровУслуг.ЗаполнитьДокументПоОплатаОтПокупателяПлатежнойКартой(ЭтотОбъект, Основание, ВыбранныйВидОперации);
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		Документы.ПоступлениеТоваровУслуг.ЗаполнитьДокументПоПоступлениеТоваровУслуг(ЭтотОбъект, Основание, ВыбранныйВидОперации);
		
	КонецЕсли;
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, Константы.ВалютаРегламентированногоУчета.Получить(), , , , Основание);

КонецПроцедуры // ЗаполнитьПоДокументуОснования()

Процедура ПроверитьЗаполнениеТабличнойЧастиПострочно(ПроверяемаяТабличнаячасть, ИмяТабличнойЧасти, Отказ, ПараметрыПроверки = Неопределено)
	
	Для Каждого СтрокаТабличнойЧасти Из ПроверяемаяТабличнаячасть Цикл
		
		Если ПараметрыПроверки <> Неопределено
			И ПараметрыПроверки.Свойство("ПроверятьЗаполнениеСчетаУчетаНДС") И ПараметрыПроверки.ПроверятьЗаполнениеСчетаУчетаНДС
			И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетУчетаНДС) И УчетНДСиАкцизаВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС) <> 0 Тогда
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Счет НДС'"),
				СтрокаТабличнойЧасти.НомерСтроки, ?(ИмяТабличнойЧасти = "Товары", "ТМЗ", ИмяТабличнойЧасти));
			Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СчетУчетаНДС";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если ПараметрыПроверки <> Неопределено
			И ПараметрыПроверки.Свойство("ПроверятьЗаполнениеСчетаУчетаНУ") И ПараметрыПроверки.ПроверятьЗаполнениеСчетаУчетаНУ
			И ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетУчетаБУ) И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетУчетаНУ) 
			И НЕ ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТабличнойЧасти.СчетУчетаБУ).Забалансовый Тогда
			
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Счет учета (НУ)'"),
				СтрокаТабличнойЧасти.НомерСтроки, ?(ИмяТабличнойЧасти = "Товары", "ТМЗ", ИмяТабличнойЧасти));
			Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СчетУчетаНУ";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли