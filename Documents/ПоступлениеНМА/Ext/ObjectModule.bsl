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

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснования(ДанныеЗаполнения);
		Возврат;
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда 
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;

	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
		
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если НЕ ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Организация, Дата)
		ИЛИ НЕ УчитыватьКПН Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВидУчетаНУ");
		МассивНепроверяемыхРеквизитов.Добавить("НМА.СчетУчетаНУ");
				
	КонецЕсли;

	Если НЕ ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНДС(Организация, Дата)
		ИЛИ НЕ УчитыватьНДС ИЛИ ОтложитьПринятиеНДСКЗачету Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("НМА.НДСВидОборота");
		МассивНепроверяемыхРеквизитов.Добавить("НМА.НДСВидПоступления");
		МассивНепроверяемыхРеквизитов.Добавить("НМА.СтавкаНДС");
		МассивНепроверяемыхРеквизитов.Добавить("НМА.СчетУчетаНДС");
		
	КонецЕсли;

    Если НЕ ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
	КонецЕсли;
    
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

	УправлениеВнеоборотнымиАктивамиСервер.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "НМА", Новый Структура("НематериальныйАктив"), Отказ);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ПоступлениеНМА.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Если вдруг не удалось получить параметры проведения и не установлен флаг Отказ, то просто выйдем из проведения
	Если ПараметрыПроведения = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	//Проверем возможность изменения состояния НМА
	УчетНМА.ПроверитьВозможностьИзмененияСостоянияНМА(ПараметрыПроведения.ТаблицаСостоянийНМА,	Отказ);

	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	
	// Таблица взаиморасчетов с учетом зачета авансов
	ТаблицаВзаиморасчеты = УправлениеВзаиморасчетамиСервер.ПодготовитьТаблицуВзаиморасчетовЗачетАвансов(
		ПараметрыПроведения.ЗачетАвансовТаблицаДокумента, ПараметрыПроведения.ЗачетАвансовРеквизиты, Отказ);
		
	// Таблицы документа с корректировкой сумм по курсу авансов
	СтруктураТаблицДокумента = УчетДоходовРасходов.ПодготовитьТаблицыПоступленияПоКурсуАвансов(ПараметрыПроведения.СтруктураТаблицДокумента,
		ТаблицаВзаиморасчеты, ПараметрыПроведения.ЗачетАвансовРеквизиты);

	ОбщегоНазначенияБКВызовСервера.ДобавитьКолонкуВТаблицуЗначений(ТаблицаВзаиморасчеты, "НомерЖурнала", НСтр("ru = 'АВ'"));	
	ОбщегоНазначенияБКВызовСервера.ДобавитьКолонкуВТаблицуЗначений(СтруктураТаблицДокумента.ТаблицаПоступление, "НомерЖурнала", НСтр("ru = 'НА'")); 	
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	// Зачет аванса
	УправлениеВзаиморасчетамиСервер.СформироватьДвиженияЗачетАвансов(ТаблицаВзаиморасчеты,
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Движения, Отказ);

	УчетНМА.СформироватьДвижениеПоступлениеНМА(СтруктураТаблицДокумента.ТаблицаПоступление, ПараметрыПроведения.Реквизиты, 
		Движения, Отказ);

	УчетНМА.СформироватьДвиженияИзменениеСостоянияНМА(ПараметрыПроведения.ТаблицаСостоянийНМА,
		 Движения, Отказ);
		 
    УчетНМА.СформироватьДвиженияСчетаУчетаНМА(ПараметрыПроведения.Реквизиты, СтруктураТаблицДокумента.ТаблицаПоступление,
		 Движения, Отказ);
		 
    // Учет НДС
	УчетНДСИАкциза.СформироватьДвиженияПоступлениеТоваров(ПараметрыПроведения.ТаблицаНДС, ПараметрыПроведения.ТаблицаУчастникиСовместнойДеятельности,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	 
	 // Переоценка валютных остатков - после формирования проводок всеми другими механизмами
	ТаблицаПереоценкаДвиженийДокумента = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкаВалютныхОстатковПоПроводкамДокумента(
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценкаДвиженийДокумента,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	ПроцедурыНалоговогоУчета.ОтразитьПостоянныеРазницыВНУ(ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// Синхронизация счетов-фактур
	УчетНДСИАкциза.СинхронизацияПризнакаПроведенияУСчетаФактуры(Ссылка, Отказ, Истина, "СчетФактураПолученный"); 	

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если НЕ УчитыватьКПН Тогда
		ВидУчетаНУ = Справочники.ВидыУчетаНУ.ПустаяСсылка();
	КонецЕсли;
    
    РаботаСДоговорамиКонтрагентов.ЗаполнитьДоговорПередЗаписью(ЭтотОбъект);
    
	УчетНДСИАкциза.ОчиститьДанныеПоУчастникамСовместнойДеятельности(ЭтотОбъект, ДоговорКонтрагента);

	СуммаДокумента = УчетНДСИАкциза.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "НМА");
	
	УчетНДСИАкциза.СинхронизацияПометкиНаУдалениеУСчетаФактуры(ЭтотОбъект, "СчетФактураПолученный", Отказ);

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

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	УчетНДСИАкциза.СинхронизацияПризнакаПроведенияУСчетаФактуры(Ссылка, Отказ, Ложь, "СчетФактураПолученный");
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗаполнитьПоДокументуОснования(Основание) Экспорт
	Документы.ПоступлениеНМА.ЗаполнитьПоДокументуОснованию(ЭтотОбъект, Основание);	
КонецПроцедуры

#КонецЕсли



