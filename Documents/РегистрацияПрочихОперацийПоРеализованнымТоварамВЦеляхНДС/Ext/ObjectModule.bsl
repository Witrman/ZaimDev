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
	
	ОбщегоНазначенияБК.ЗаполнитьНаборыПоОрганизацииСтурктурномуПодразделению(ЭтотОбъект, Таблица, "Организация", "СтруктурноеПодразделение");
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
    
	УчетНДСИАкциза.ОчиститьДанныеПоУчастникамСовместнойДеятельности(ЭтотОбъект, ДоговорКонтрагента);
	
	Если НЕ УчитыватьКПН Тогда
		ВидУчетаНУ = Справочники.ВидыУчетаНУ.ПустаяСсылка();
	КонецЕсли;
	
	СуммаДокумента = УчетНДСИАкциза.ПолучитьСуммуДокументаСНДС(ЭтотОбъект);
	
	СчетаУчетаВДокументах.ЗаполнитьПередЗаписью(ЭтотОбъект, РежимЗаписи);
	
	УчетНДСИАкциза.СинхронизацияПометкиНаУдалениеУСчетаФактуры(ЭтотОбъект, "СчетФактураВыданный", Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//синхронизируем данные счет-фактуры и документа основания
	УчетНДСИАкциза.СинхронизироватьДанныеДокументаИСчетаФактуры(ЭтотОбъект, Отказ, "СчетФактураВыданный"); 		
	Если Отказ Тогда
		ТекстСообщения = НСтр("ru = 'Документ не записан ...'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		Документы.РегистрацияПрочихОперацийПоРеализованнымТоварамВЦеляхНДС.ЗаполнитьДокументПоДокументуОснованию(ЭтотОбъект, ДанныеЗаполнения);
		Возврат;
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда 
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, Константы.ВалютаРегламентированногоУчета.Получить());
		
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
    
	Если Товары.Количество() > 0
		ИЛИ ОС.Количество() > 0
		ИЛИ Услуги.Количество() > 0
		ИЛИ НМА.Количество() > 0 Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары");
		МассивНепроверяемыхРеквизитов.Добавить("ОС");		
		МассивНепроверяемыхРеквизитов.Добавить("Услуги");
		МассивНепроверяемыхРеквизитов.Добавить("НМА");
				
	КонецЕсли;
	
	Если НЕ ОтражатьВБухгалтерскомУчете Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетУчетаНДСПоРеализации");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.СчетУчетаНДСПоРеализации");
		МассивНепроверяемыхРеквизитов.Добавить("ОС.СчетУчетаНДСПоРеализации");
		МассивНепроверяемыхРеквизитов.Добавить("НМА.СчетУчетаНДСПоРеализации");
	КонецЕсли; 
	
	Если НЕ УчитыватьНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СтавкаНДС");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.НДСВидОперацииРеализации");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.СтавкаНДС");
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.НДСВидОперацииРеализации");
		МассивНепроверяемыхРеквизитов.Добавить("ОС.СтавкаНДС");
		МассивНепроверяемыхРеквизитов.Добавить("ОС.НДСВидОперацииРеализации");
		МассивНепроверяемыхРеквизитов.Добавить("НМА.СтавкаНДС");
		МассивНепроверяемыхРеквизитов.Добавить("НМА.НДСВидОперацииРеализации");
	КонецЕсли;	
	
	Если НЕ УчитыватьКПН Тогда			
		МассивНепроверяемыхРеквизитов.Добавить("ВидУчетаНУ");
	КонецЕсли;

	Если ВидОперации = Перечисления.ВидыОперацийВЦеляхНДС.КорректировкаОборотаПоРеализации Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
	КонецЕсли;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	СчетаУчетаВДокументах.ПроверитьЗаполнение(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, Новый Соответствие);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.РегистрацияПрочихОперацийПоРеализованнымТоварамВЦеляхНДС.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	 		
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ (АНАЛИЗ ОСТАТКОВ И Т.П.)

	// Таблица взаиморасчетов
	ТаблицаВзаиморасчеты = УправлениеВзаиморасчетамиСервер.ПодготовитьТаблицуВзаиморасчетовЗачетАвансов(
		ПараметрыПроведения.ЗачетАвансовТаблицаДокумента, ПараметрыПроведения.ЗачетАвансовРеквизиты, Отказ);
		
	ОбщегоНазначенияБКВызовСервера.ДобавитьКолонкуВТаблицуЗначений(ТаблицаВзаиморасчеты, "НомерЖурнала", НСтр("ru = 'АВ'"));
			
	// Зачет аванса
	УправлениеВзаиморасчетамиСервер.СформироватьДвиженияЗачетАвансов(ТаблицаВзаиморасчеты,
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Движения, Отказ);
		
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
			                          	
	УчетНДСИАкциза.СформироватьДвиженияКорректировкаПрочихОпераций(ПараметрыПроведения.ТаблицаНДС, ПараметрыПроведения.ТаблицаУчастникиСовместнойДеятельности,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	// Переоценка валютных остатков - после формирования проводок всеми другими механизмами
	ТаблицаПереоценкаДвиженийДокумента = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкаВалютныхОстатковПоПроводкамДокумента(
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценкаДвиженийДокумента,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	// Отражение ПР в НУ 
	ПроцедурыНалоговогоУчета.ОтразитьПостоянныеРазницыВНУ(ПараметрыПроведения.Реквизиты, Движения, Отказ);

	УчетНДСИАкциза.СинхронизацияПризнакаПроведенияУСчетаФактуры(Ссылка, Отказ, Истина, "СчетФактураВыданный");
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	УчетНДСИАкциза.СинхронизацияПризнакаПроведенияУСчетаФактуры(Ссылка, Отказ, Ложь, "СчетФактураВыданный");

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
	
#КонецЕсли


