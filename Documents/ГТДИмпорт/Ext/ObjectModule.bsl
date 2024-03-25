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

///////////////////////////////////////////////////////////////////////////////
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

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета(),,, ОбъектКопирования.Ссылка);
	
	Для Каждого СтрокаТовары Из ЭтотОбъект.Товары Цикл
		СтрокаТовары.НомерГТД = Неопределено;
	КонецЦикла;
	
	Для Каждого СтрокаОС Из ЭтотОбъект.ОС Цикл
		СтрокаОС.НомерГТД = Неопределено;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	ПараметрыПострочнойПроверки   = Новый Структура("ПроверятьЗаполнениеСчетаУчетаНУ", Товары.Количество() > 0);
	
	Если Разделы.Количество() > 0 Тогда
		Если НЕ УчитыватьНДС Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Разделы.СтавкаНДС");
		КонецЕсли; 
	КонецЕсли; 
	
	Если Товары.Количество() > 0 ИЛИ ОС.Количество() > 0 Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары");
		МассивНепроверяемыхРеквизитов.Добавить("ОС");		
		
		Если НЕ ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Организация, Дата) 
			ИЛИ НЕ УчитыватьКПН Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ВидУчетаНУ");
			МассивНепроверяемыхРеквизитов.Добавить("ОС.СчетУчетаНУ");
			
			ПараметрыПострочнойПроверки.Вставить("ПроверятьЗаполнениеСчетаУчетаНУ", Ложь);
			
		КонецЕсли; 
		
		Если НЕ УчитыватьНДС Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Товары.НДСВидОборота");
			МассивНепроверяемыхРеквизитов.Добавить("Товары.НДСВидПоступления");
			МассивНепроверяемыхРеквизитов.Добавить("Товары.ВидНДС");
			
			МассивНепроверяемыхРеквизитов.Добавить("ОС.НДСВидОборота");
			МассивНепроверяемыхРеквизитов.Добавить("ОС.НДСВидПоступления");
			МассивНепроверяемыхРеквизитов.Добавить("ОС.ВидНДС");
		КонецЕсли;
		
		Если НДСВключенВСтоимость ИЛИ НЕ УчитыватьНДС Тогда 
			МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетУчетаНДС");
			МассивНепроверяемыхРеквизитов.Добавить("ОС.СчетУчетаНДС");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВалютаДокумента = ВалютаВзаиморасчетов Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаРасчетовСКонтрагентомВал");
		МассивНепроверяемыхРеквизитов.Добавить("КурсВзаиморасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("КратностьВзаиморасчетов");
	КонецЕсли;
	
	Если (Товары.Найти(Перечисления.ВидыНДС.НДСМетодомЗачета, "ВидНДС") = Неопределено 
		И ОС.Найти(Перечисления.ВидыНДС.НДСМетодомЗачета, "ВидНДС") = Неопределено) И ВариантОтражения = 0 Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаНДСПоРеализации");		
	КонецЕсли;	
	
	Если НЕ УправлениеВнеоборотнымиАктивамиСервер.ВедетсяАналитическийУчетОСПоПодразделениям(Дата) Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ОС.ПодразделениеОрганизации");
		
	КонецЕсли;
	
	Если НЕ УправлениеВнеоборотнымиАктивамиСервер.ВедетсяАналитическийУчетОСПоМОЛ(Дата) Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ОС.МОЛОрганизации");
		
	КонецЕсли;
	
	Если ВариантОтражения = 0 Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("ВидНалогаТаможеннойПошлины");
		МассивНепроверяемыхРеквизитов.Добавить("ВидНалогаТаможенногоСбора");
		МассивНепроверяемыхРеквизитов.Добавить("ВидНалогаНДСПоИмпорту");
		МассивНепроверяемыхРеквизитов.Добавить("ВидНалогаСпециальнойПошлины");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если ЗначениеЗаполнено(ВалютаДокумента) И ВалютаДокумента <> ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета() Тогда 
		ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Поле", "Корректность", НСтр("ru = 'Валюта'"),
			, , 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Валюта документа (%1) отличается от валюты регламентированного учета (%2)'"), 
				ВалютаДокумента, 
				ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета())
		);
		
		ОбщегоНазначения.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			"ВалютаДокумента",
			,
			Отказ);
	КонецЕсли;
	
	Если Разделы.Количество() <> 0 Тогда 
		ПроверитьЗаполнениеТабличнойЧастиПострочно(Разделы, "Разделы", Отказ);
		ПроверитьКорректностьЗаполненияДоговоровВТабличнойЧастиРазделы(Отказ);
	КонецЕсли;
	
	Если Товары.Количество() <> 0 Тогда 
		ПроверитьЗаполнениеТабличнойЧастиПострочно(Товары, "Товары", Отказ, ПараметрыПострочнойПроверки);
	КонецЕсли;
	
	Если ОС.Количество() <> 0 Тогда 
		ПроверитьЗаполнениеТабличнойЧастиПострочно(ОС, "ОС", Отказ);
	КонецЕсли;
	
	Если Разделы.Итог("ТаможенныйСбор") <>  ТаможенныйСбор Тогда
		
		ТекстСообщения = НСтр("ru = 'Не совпадает сумма таможенного сбора по документу и суммы таможенных сборов по разделам'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, );
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,,, Отказ);
		
	КонецЕсли;
	
	СчетаУчетаВДокументах.ПроверитьЗаполнение(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, Новый Соответствие);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
    
    Если НЕ ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам") Тогда
		ДоговорКонтрагента = РаботаСДоговорамиКонтрагентов.ДоговорКонтрагентаИзОбъекта(ЭтотОбъект);
        Для Каждого ТекСтрока Из Разделы Цикл
            ТекСтрока.ДоговорВзаиморасчетовПошлина  = ДоговорКонтрагента;
            ТекСтрока.ДоговорВзаиморасчетовНДС      = ДоговорКонтрагента;
            ТекСтрока.ДоговорВзаиморасчетовСбор     = ДоговорКонтрагента;
            ТекСтрока.ДоговорВзаиморасчетовСборВал  = ДоговорКонтрагента;
        КонецЦикла;
	КонецЕсли;
    
	СуммаДокумента = 0;
	
	Для Каждого СтрокаТабличнойЧасти ИЗ Разделы Цикл
		СуммаДокумента = СуммаДокумента + СтрокаТабличнойЧасти.ТаможеннаяСтоимость;
	КонецЦикла;	
	
	Если НЕ УчитыватьКПН Тогда
		ВидУчетаНУ = Справочники.ВидыУчетаНУ.ПустаяСсылка();
	КонецЕсли;

	///////////////////////////////////////////////////////////////
	// Реквизиты входящего документа
	Если ПустаяСтрока(ВидВходящегоДокумента) Тогда 
		ВидВходящегоДокумента = НСтр("ru = 'Грузовая таможенная декларация'");
	КонецЕсли;
	
	Если ПустаяСтрока(НомерВходящегоДокумента) И ЗначениеЗаполнено(НомерГТД) Тогда 
		НомерВходящегоДокумента = СокрЛП(НомерГТД);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаВходящегоДокумента) Тогда 
		ДатаВходящегоДокумента = Дата;
	КонецЕсли;
	
	ВедетсяУчетПоТоварамОрганизацийБУ = НомераГТДСервер.ВедетсяУчетПоТоварамОрганизаций(Дата);
	
	Если НЕ Отказ И РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		// Признак происхождения
		Если ВедетсяУчетПоТоварамОрганизацийБУ Тогда
			ЗаполнитьПустыеПризнакиПроисхождения("Товары");
		КонецЕсли;
		
		НайтиСоздатьОбновитьНомераГТД(ВедетсяУчетПоТоварамОрганизацийБУ);
		
	КонецЕсли;
	
	СчетаУчетаВДокументах.ЗаполнитьПередЗаписью(ЭтотОбъект, РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.ГТДИмпорт.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ ИЛИ ПараметрыПроведения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	// Пошлина за товары
	УчетТоваров.СформироватьДвиженияГТДИмпорт(
		ПараметрыПроведения.ТаблицаТовары, ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// Пошлина за ОС
	УчетОС.СформироватьДвиженияГТДИмпорт(
		ПараметрыПроведения.ТаблицаОС, ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// Учет НДС
	УчетНДСИАкциза.СформироватьДвиженияГТДИмпорт(
		ПараметрыПроведения.ТаблицаНДС, ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// Переоценка валютных остатков - после формирования проводок всеми другими механизмами
	ТаблицаПереоценкаДвиженийДокумента = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкаВалютныхОстатковПоПроводкамДокумента(
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(
		ТаблицаПереоценкаДвиженийДокумента, ПараметрыПроведения.Реквизиты, Движения, Отказ);

	// Отражение ПР в НУ 
	ПроцедурыНалоговогоУчета.ОтразитьПостоянныеРазницыВНУ(
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	// Товары организаций
	НомераГТДСервер.СформироватьДвиженияТоварыОрганизаций(
		ПараметрыПроведения.ТаблицаТоварыПоНомерамГТД, ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗаполнитьПоДокументуОснования(ДанныеЗаполнения)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		Документы.ГТДИмпорт.ЗаполнитьПоДокументуОснования(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
		
КонецПроцедуры

Процедура ПроверитьЗаполнениеТабличнойЧастиПострочно(ПроверяемаяТабличнаячасть, ИмяТабличнойЧасти, Отказ, ПараметрыПроверки = Неопределено)
	
	ВестиУчетПоДоговорам = ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам");
	
	Для Каждого СтрокаТабличнойЧасти Из ПроверяемаяТабличнаячасть Цикл
		
		Если ИмяТабличнойЧасти = "Разделы" Тогда
			
			ШаблонСообщения = НСтр("ru = 'По разделу ""%1"" сумма %2 не совпадает с итогом по товарам раздела'");
			
			ВсегоСтоимость 	 = 0;
			ВсегоПошлина  	 = 0;
			ВсегоПошлинаСпец = 0;
			ВсегоНДС       	 = 0;
			ВсегоСбор		 = 0;
			ВсегоСборВал	 = 0;
			ВсегоНДС         = 0;
			
			ПосчитатьИтогиПоРазделу(СтрокаТабличнойЧасти.НомерСтроки, ВсегоСтоимость, ВсегоПошлина, ВсегоПошлинаСпец, ВсегоНДС, ВсегоСбор, ВсегоСборВал);
			
			Если ВсегоСтоимость <> СтрокаТабличнойЧасти.ТаможеннаяСтоимость Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонСообщения,
					Формат(СтрокаТабличнойЧасти.НомерСтроки, "ЧН=0; ЧГ="),
					НСтр("ru = 'таможенной стоимости'"));
				Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ТаможеннаяСтоимость";
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
			Если ВсегоПошлина <> СтрокаТабличнойЧасти.СуммаПошлины Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонСообщения,
					Формат(СтрокаТабличнойЧасти.НомерСтроки, "ЧН=0; ЧГ="),
					НСтр("ru = 'пошлины'"));
				Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СуммаПошлины";
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
			Если ВсегоПошлинаСпец <> СтрокаТабличнойЧасти.СуммаПошлиныСпец Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонСообщения,
					Формат(СтрокаТабличнойЧасти.НомерСтроки, "ЧН=0; ЧГ="),
					НСтр("ru = 'пошлины (спец.)'"));
				Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СуммаПошлиныСпец";
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
			Если ВсегоНДС <> СтрокаТабличнойЧасти.СуммаНДС Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонСообщения,
					Формат(СтрокаТабличнойЧасти.НомерСтроки, "ЧН=0; ЧГ="),
					НСтр("ru = 'НДС'"));
				Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СуммаНДС";
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
			Если ВсегоСбор <> СтрокаТабличнойЧасти.ТаможенныйСбор Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонСообщения,
					Формат(СтрокаТабличнойЧасти.НомерСтроки, "ЧН=0; ЧГ="),
					НСтр("ru = 'таможенных сборов'"));
				Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ТаможенныйСбор";
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
			Если ВсегоСборВал <> СтрокаТабличнойЧасти.ТаможенныйСборВал Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонСообщения,
					Формат(СтрокаТабличнойЧасти.НомерСтроки, "ЧН=0; ЧГ="),
					НСтр("ru = 'таможенных сборов в валюте'"));
				Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ТаможенныйСборВал";
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.СуммаПошлины) И (ВестиУчетПоДоговорам И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДоговорВзаиморасчетовПошлина)) Тогда
				ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Пошлина, договор расчетов'"),
					СтрокаТабличнойЧасти.НомерСтроки, НСтр("ru = 'Разделы'"));
				Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ДоговорВзаиморасчетовПошлина";
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.СуммаНДС) И (ВестиУчетПоДоговорам И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДоговорВзаиморасчетовНДС))  Тогда
				ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'НДС, договор расчетов'"),
					СтрокаТабличнойЧасти.НомерСтроки, НСтр("ru = 'Разделы'"));
				Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ДоговорВзаиморасчетовНДС";
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.ТаможенныйСбор) И (ВестиУчетПоДоговорам И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДоговорВзаиморасчетовСбор)) Тогда
				ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Сбор, договор расчетов'"),
					СтрокаТабличнойЧасти.НомерСтроки, НСтр("ru = 'Разделы'"));
				Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ДоговорВзаиморасчетовСбор";
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.ТаможенныйСборВал) И (ВестиУчетПоДоговорам И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДоговорВзаиморасчетовСборВал)) Тогда
				ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Сбор (вал), договор расчетов'"),
					СтрокаТабличнойЧасти.НомерСтроки, НСтр("ru = 'Разделы'"));
				Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ДоговорВзаиморасчетовСборВал";
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
		КонецЕсли;

		Если ПараметрыПроверки <> Неопределено
			И ПараметрыПроверки.Свойство("ПроверятьЗаполнениеСчетаУчетаНУ") И ПараметрыПроверки.ПроверятьЗаполнениеСчетаУчетаНУ
			И ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетУчетаБУ) И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетУчетаНУ) 
			И НЕ ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТабличнойЧасти.СчетУчетаБУ).Забалансовый Тогда
			
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Счет (НУ)'"),
				СтрокаТабличнойЧасти.НомерСтроки, ?(ИмяТабличнойЧасти = "Товары", "ТМЗ", ИмяТабличнойЧасти));
			Поле = ИмяТабличнойЧасти + "[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СчетУчетаНУ";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если ИмяТабличнойЧасти = "Товары" ИЛИ ИмяТабличнойЧасти = "ОС" Тогда
			
			Если СтрокаТабличнойЧасти.ВидНДС = Перечисления.ВидыНДС.НДССИзменениемСрокаУплаты 
				И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.НДССрокПлатежа) Тогда
				
				ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка",, НСтр("ru = 'Срок уплаты НДС'"),
					СтрокаТабличнойЧасти.НомерСтроки, ?(ИмяТабличнойЧасти = "Товары", НСтр("ru = 'ТМЗ'"), ИмяТабличнойЧасти));
				Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(ИмяТабличнойЧасти, СтрокаТабличнойЧасти.НомерСтроки, "НДССрокПлатежа");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьКорректностьЗаполненияДоговоровВТабличнойЧастиРазделы(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки,
	|	ТаблицаДокумента.ДоговорВзаиморасчетовПошлина,
	|	ТаблицаДокумента.ДоговорВзаиморасчетовНДС,
	|	ТаблицаДокумента.ДоговорВзаиморасчетовСбор,
	|	ТаблицаДокумента.ДоговорВзаиморасчетовСборВал
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	&ТаблицаДокумента КАК ТаблицаДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	""ДоговорВзаиморасчетовПошлина"" КАК ИмяПоля,
	|	&СинонимПошлина КАК СинонимПоля,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ДоговорВзаиморасчетовПошлина.Организация <> &Организация 
	|			ТОГДА ИСТИНА 
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОшибкаОрганизация,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ДоговорВзаиморасчетовПошлина.ВидДоговора <> &ВидДоговора
	|			ТОГДА ИСТИНА 
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОшибкаВидДоговора,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ДоговорВзаиморасчетовПошлина.ВедениеВзаиморасчетов <> &ВедениеВзаиморасчетов 
	|			ТОГДА ИСТИНА 
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОшибкаВедениеВзаиморасчетов
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.ДоговорВзаиморасчетовПошлина <> &ПустойДоговор
	|	И (ТаблицаДокумента.ДоговорВзаиморасчетовПошлина.Организация <> &Организация
	|			ИЛИ ТаблицаДокумента.ДоговорВзаиморасчетовПошлина.ВидДоговора <> &ВидДоговора
	|			ИЛИ ТаблицаДокумента.ДоговорВзаиморасчетовПошлина.ВедениеВзаиморасчетов <> &ВедениеВзаиморасчетов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки,
	|	""ДоговорВзаиморасчетовНДС"",
	|	&СинонимНДС,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ДоговорВзаиморасчетовНДС.Организация <> &Организация 
	|			ТОГДА ИСТИНА 
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОшибкаОрганизация,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ДоговорВзаиморасчетовНДС.ВидДоговора <> &ВидДоговора
	|			ТОГДА ИСТИНА 
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОшибкаВидДоговора,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ДоговорВзаиморасчетовНДС.ВедениеВзаиморасчетов <> &ВедениеВзаиморасчетов 
	|			ТОГДА ИСТИНА 
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОшибкаВедениеВзаиморасчетов
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.ДоговорВзаиморасчетовНДС <> &ПустойДоговор
	|	И (ТаблицаДокумента.ДоговорВзаиморасчетовНДС.Организация <> &Организация
	|			ИЛИ ТаблицаДокумента.ДоговорВзаиморасчетовНДС.ВидДоговора <> &ВидДоговора
	|			ИЛИ ТаблицаДокумента.ДоговорВзаиморасчетовНДС.ВедениеВзаиморасчетов <> &ВедениеВзаиморасчетов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки,
	|	""ДоговорВзаиморасчетовСбор"",
	|	&СинонимСбор,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ДоговорВзаиморасчетовСбор.Организация <> &Организация 
	|			ТОГДА ИСТИНА 
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОшибкаОрганизация,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ДоговорВзаиморасчетовСбор.ВидДоговора <> &ВидДоговора
	|			ТОГДА ИСТИНА 
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОшибкаВидДоговора,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ДоговорВзаиморасчетовСбор.ВедениеВзаиморасчетов <> &ВедениеВзаиморасчетов 
	|			ТОГДА ИСТИНА 
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОшибкаВедениеВзаиморасчетов
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.ДоговорВзаиморасчетовСбор <> &ПустойДоговор
	|	И (ТаблицаДокумента.ДоговорВзаиморасчетовСбор.Организация <> &Организация
	|			ИЛИ ТаблицаДокумента.ДоговорВзаиморасчетовСбор.ВидДоговора <> &ВидДоговора
	|			ИЛИ ТаблицаДокумента.ДоговорВзаиморасчетовСбор.ВедениеВзаиморасчетов <> &ВедениеВзаиморасчетов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки,
	|	""ДоговорВзаиморасчетовСборВал"",
	|	&СинонимСборВал,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ДоговорВзаиморасчетовСборВал.Организация <> &Организация 
	|			ТОГДА ИСТИНА 
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОшибкаОрганизация,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ДоговорВзаиморасчетовСборВал.ВидДоговора <> &ВидДоговора
	|			ТОГДА ИСТИНА 
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОшибкаВидДоговора,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ДоговорВзаиморасчетовСборВал.ВедениеВзаиморасчетов <> &ВедениеВзаиморасчетов 
	|			ТОГДА ИСТИНА 
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОшибкаВедениеВзаиморасчетов
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.ДоговорВзаиморасчетовСборВал <> &ПустойДоговор
	|	И (ТаблицаДокумента.ДоговорВзаиморасчетовСборВал.Организация <> &Организация
	|			ИЛИ ТаблицаДокумента.ДоговорВзаиморасчетовСборВал.ВидДоговора <> &ВидДоговора
	|			ИЛИ ТаблицаДокумента.ДоговорВзаиморасчетовСборВал.ВедениеВзаиморасчетов <> &ВедениеВзаиморасчетов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("ТаблицаДокумента",      Разделы);	
	Запрос.УстановитьПараметр("ВедениеВзаиморасчетов", Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом);
	Запрос.УстановитьПараметр("ВидДоговора",           Перечисления.ВидыДоговоровКонтрагентов.Прочее);
	Запрос.УстановитьПараметр("Организация",           Организация);
	Запрос.УстановитьПараметр("ПустойДоговор",         Справочники.ДоговорыКонтрагентов.ПустаяСсылка());
	Запрос.УстановитьПараметр("СинонимПошлина",        НСтр("ru = 'Пошлина, договор расчетов'"));
	Запрос.УстановитьПараметр("СинонимНДС",            НСтр("ru = 'НДС, договор расчетов'"));
	Запрос.УстановитьПараметр("СинонимСбор",           НСтр("ru = 'Сбор, договор расчетов'"));
	Запрос.УстановитьПараметр("СинонимСборВал",        НСтр("ru = 'Сбор (вал), договор расчетов'"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ТекстДополнения = "";
		Если ВыборкаДетальныеЗаписи.ОшибкаОрганизация Тогда 
			ТекстДополнения = ТекстДополнения + НСтр("ru = 'Значение Организации в договоре не соответствует Организации, указанной в документе'");
		КонецЕсли;
		
		Если ВыборкаДетальныеЗаписи.ОшибкаОрганизация Тогда 
			ТекстДополнения = ТекстДополнения + Символы.ПС + НСтр("ru = 'Договор должен иметь вид ""Прочее""'");
		КонецЕсли;
		
		Если ВыборкаДетальныеЗаписи.ОшибкаОрганизация Тогда 
			ТекстДополнения = ТекстДополнения + Символы.ПС + НСтр("ru = 'Расчеты по договору должны вестись ""По договору в целом""'");
		КонецЕсли;
		
		ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка", "Корректность", ВыборкаДетальныеЗаписи.СинонимПоля,
			Формат(ВыборкаДетальныеЗаписи.НомерСтроки, "ЧН=0; ЧГ="), НСтр("ru = 'Разделы'"), СокрЛП(ТекстДополнения));
		Поле = "Разделы[" + Формат(ВыборкаДетальныеЗаписи.НомерСтроки - 1, "ЧН=0; ЧГ=") + "]." + ВыборкаДетальныеЗаписи.ИмяПоля;
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПосчитатьИтогиПоРазделу(НомерРаздела, ВсегоСтоимость, ВсегоПошлина, ВсегоПошлинаСпец, ВсегоНДС, ВсегоСбор, ВсегоСборВал)  Экспорт
	
	ВсегоСтоимость 	 = 0;
	ВсегоПошлина   	 = 0;
	ВсегоПошлинаСпец = 0;
	ВсегоНДС       	 = 0;
	ВсегоСбор		 = 0;
	ВсегоСборВал	 = 0;
	ВсегоНДС       	 = 0;
	МассивСтрок    	 = Товары.НайтиСтроки(Новый Структура("НомерРаздела", НомерРаздела));
	ПосчитатьИтогиПоТабличнойЧасти(МассивСтрок, ВсегоСтоимость, ВсегоПошлина, ВсегоПошлинаСпец, ВсегоНДС, ВсегоСбор, ВсегоСборВал);
	
	МассивСтрок     = ОС.НайтиСтроки(Новый Структура("НомерРаздела", НомерРаздела));
	ПосчитатьИтогиПоТабличнойЧасти(МассивСтрок, ВсегоСтоимость, ВсегоПошлина, ВсегоПошлинаСпец, ВсегоНДС, ВсегоСбор, ВсегоСборВал);

КонецПроцедуры

Процедура ПосчитатьИтогиПоТабличнойЧасти(МассивСтрок, ВсегоСтоимость, ВсегоПошлина, ВсегоПошлинаСпец, ВсегоНДС, ВсегоСбор, ВсегоСборВал)	
	
	Для каждого ЭлементМассива Из МассивСтрок Цикл		
		ВсегоСтоимость 	 = ВсегоСтоимость   + ЭлементМассива.ТаможеннаяСтоимость;
		ВсегоПошлина   	 = ВсегоПошлина     + ЭлементМассива.СуммаПошлины;
		ВсегоПошлинаСпец = ВсегоПошлинаСпец + ЭлементМассива.СуммаПошлиныСпец;
		ВсегоНДС       	 = ВсегоНДС         + ЭлементМассива.СуммаНДС;
		ВсегоСбор 		 = ВсегоСбор 	    + ЭлементМассива.СуммаСбора;
		ВсегоСборВал	 = ВсегоСборВал 	+ ЭлементМассива.СуммаСбораВал;
	КонецЦикла;

КонецПроцедуры

Процедура НайтиСоздатьОбновитьНомераГТД(ВедетсяУчетПоТоварамОрганизацийБУ)
		
	ТоварыНайтиСоздатьОбновитьНомераГТД(ВедетсяУчетПоТоварамОрганизацийБУ);
	ОСНайтиСоздатьОбновитьНомераГТД(ВедетсяУчетПоТоварамОрганизацийБУ);
	
КонецПроцедуры

Процедура ТоварыНайтиСоздатьОбновитьНомераГТД(ВедетсяУчетПоТоварамОрганизацийБУ)
	
	ТаблицаНомеровГТД = Справочники.НомераГТД.ПустаяТаблицаНомеровГТД();
	ТаблицаНомеровГТД.Колонки.Добавить("НомерСтрокиГТДЧисло", Новый ОписаниеТипов("Число"));
	
	// Заполнить ТаблицаНомеровГТД, которая будет использоваться 
	// для поиска, создания, обновления номеров ГТД.
	Для Каждого СтрокаТовар Из ЭтотОбъект.Товары Цикл
		
		Если ВедетсяУчетПоТоварамОрганизацийБУ ИЛИ СтрокаТовар.ВидНДС = Перечисления.ВидыНДС.НДССИзменениемСрокаУплаты Тогда
			СтрокаНомерГТД = ТаблицаНомеровГТД.Добавить();
			
			СтрокаНомерГТД.Идентификатор = Формат(СтрокаТовар.НомерСтроки, "ЧН=0; ЧГ=");
			СтрокаНомерГТД.НомерСтроки = Формат(СтрокаТовар.НомерСтроки, "ЧН=0; ЧГ=");
			
			СтрокаНомерГТД.НомерГТД = ЭтотОбъект.НомерГТД;
			СтрокаНомерГТД.НомерСтрокиГТД = Формат(СтрокаТовар.НомерРаздела, "ЧН=0; ЧГ=");
			СтрокаНомерГТД.НомерСтрокиГТДЧисло = СтрокаТовар.НомерРаздела;
			
			СтрокаНомерГТД.КодТНВЭД = СтрокаТовар.КодТНВЭД;
			СтрокаНомерГТД.ГСВС = ЭСФСерверПереопределяемый.ПолучитьГСВС(,СтрокаТовар.КодТНВЭД);

			СтрокаНомерГТД.НаименованиеТовара = СтрокаТовар.НаименованиеТовара;
			СтрокаНомерГТД.СтранаПроисхожденияТовара = СтрокаТовар.СтранаПроисхождения;
			
			СтрокаРаздел = ЭтотОбъект.Разделы.Найти(СтрокаТовар.НомерРаздела, "НомерСтроки");
			СтрокаНомерГТД.СпособПроисхожденияТовара = СтрокаРаздел.СпособПроисхожденияТовара;
			
			СтрокаНомерГТД.РегистрационныйНомерЭСФ = "";
			
			СтрокаНомерГТД.СсылкаНомерГТД = СтрокаТовар.НомерГТД;
			СтрокаНомерГТД.ПризнакПроисхождения = СтрокаТовар.ПризнакПроисхождения;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТаблицаНомеровГТД.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	 	
	РеквизитыИзменены = (НомерГТД <> Ссылка.НомерГТД) ИЛИ ИзменилисьРеквизитыТЧТовары(ТаблицаНомеровГТД, ВедетсяУчетПоТоварамОрганизацийБУ);
	Если НЕ РеквизитыИзменены Тогда
		Возврат;
	КонецЕсли;
			
	Справочники.НомераГТД.НайтиСоздатьОбновитьНомераГТД(ТаблицаНомеровГТД, "ТМЗ", ЭтотОбъект);
	
	// Заполнить в таблице Товары ссылки на найденные и созданные элементы справочника НомераГТД. 
	Для Каждого СтрокаТовар Из ЭтотОбъект.Товары Цикл
		СтрокаНомерГТД = ТаблицаНомеровГТД.Найти(Формат(СтрокаТовар.НомерСтроки, "ЧН=0; ЧГ="), "Идентификатор");
		Если СтрокаНомерГТД = Неопределено Тогда
			Продолжить;
		КонецЕсли;		
		СтрокаТовар.НомерГТД = СтрокаНомерГТД.СсылкаНомерГТД;
	КонецЦикла;
		
КонецПроцедуры

Процедура ОСНайтиСоздатьОбновитьНомераГТД(ВедетсяУчетПоТоварамОрганизацийБУ)
	
	ТаблицаНомеровГТД = Справочники.НомераГТД.ПустаяТаблицаНомеровГТД();	
	
	// На данный момент учет по ГТД в разрезе ОС не реализован.
	// Номера ГТД для ОС нужно указывать для приложения 300.03.
	
	// Заполнить ТаблицаНомеровГТД, которая будет использоваться 
	// для поиска, создания, обновления номеров ГТД.
	Для Каждого СтрокаОС Из ЭтотОбъект.ОС Цикл
		
		Если ВедетсяУчетПоТоварамОрганизацийБУ ИЛИ СтрокаОС.ВидНДС = Перечисления.ВидыНДС.НДССИзменениемСрокаУплаты Тогда		
			СтрокаНомерГТД = ТаблицаНомеровГТД.Добавить();
			
			СтрокаНомерГТД.Идентификатор = Формат(СтрокаОС.НомерСтроки, "ЧН=0; ЧГ=");
			СтрокаНомерГТД.НомерСтроки = Формат(СтрокаОС.НомерСтроки, "ЧН=0; ЧГ=");
			
			СтрокаНомерГТД.НомерГТД = ЭтотОбъект.НомерГТД;
			СтрокаНомерГТД.НомерСтрокиГТД = "";
			СтрокаНомерГТД.КодТНВЭД = Неопределено;
			СтрокаНомерГТД.НаименованиеТовара = "";
			СтрокаНомерГТД.СтранаПроисхожденияТовара = Неопределено;
			СтрокаНомерГТД.СпособПроисхожденияТовара = Неопределено;
			СтрокаНомерГТД.РегистрационныйНомерЭСФ   = "";
			
			СтрокаНомерГТД.СсылкаНомерГТД = СтрокаОС.НомерГТД;
		КонецЕсли;  	
		
	КонецЦикла;
	
	Если ТаблицаНомеровГТД.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Справочники.НомераГТД.НайтиСоздатьОбновитьНомераГТД(ТаблицаНомеровГТД, "ОС", ЭтотОбъект.Ссылка);
			
	// Заполнить в таблице ОС ссылки на найденные и созданные элементы справочника НомераГТД. 
	Для Каждого СтрокаОС Из ЭтотОбъект.ОС Цикл
		Если СтрокаОС.НомерГТД.Пустая() Тогда
			СтрокаНомерГТД = ТаблицаНомеровГТД.Найти(Формат(СтрокаОС.НомерСтроки, "ЧН=0; ЧГ="), "Идентификатор");
			СтрокаОС.НомерГТД = СтрокаНомерГТД.СсылкаНомерГТД;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ИзменилисьРеквизитыТЧТовары(ТаблицаНомеровГТД, ВедетсяУчетПоТоварамОрганизацийБУ)
			
	Запрос = Новый Запрос;  
	Запрос.УстановитьПараметр("НомераГТД", ТаблицаНомеровГТД);
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.Текст = "ВЫБРАТЬ
	               |	НомераГТД.НомерСтрокиГТДЧисло КАК НомерСтрокиГТД,
	               |	НомераГТД.КодТНВЭД КАК КодТНВЭД,
	               |	НомераГТД.НаименованиеТовара КАК НаименованиеТовара,
	               |	НомераГТД.СтранаПроисхожденияТовара КАК СтранаПроисхожденияТовара,
	               |	НомераГТД.СпособПроисхожденияТовара КАК СпособПроисхожденияТовара,
	               |	НомераГТД.ПризнакПроисхождения КАК ПризнакПроисхождения,
	               |	НомераГТД.СсылкаНомерГТД КАК СсылкаНомерГТД,
	               |	1 КАК Счетчик
	               |ПОМЕСТИТЬ ВТ_НовыеДанныеНомераГТД
	               |ИЗ
	               |	&НомераГТД КАК НомераГТД
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Товары.СсылкаНомерГТД КАК СсылкаНомерГТД
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ТЧТовары.НомерРаздела КАК НомерСтрокиГТД,
	               |		ТЧТовары.КодТНВЭД КАК КодТНВЭД,
	               |		ТЧТовары.НаименованиеТовара КАК НаименованиеТовара,
	               |		ТЧТовары.СтранаПроисхождения КАК СтранаПроисхожденияТовара,
	               |		ТЧРазделы.СпособПроисхожденияТовара КАК СпособПроисхожденияТовара,
	               |		ТЧТовары.ПризнакПроисхождения КАК ПризнакПроисхождения,
	               |		ТЧТовары.НомерГТД КАК СсылкаНомерГТД,
	               |		-1 КАК Счетчик
	               |	ИЗ
	               |		Документ.ГТДИмпорт.Товары КАК ТЧТовары
	               |			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ГТДИмпорт.Разделы КАК ТЧРазделы
	               |			ПО (ТЧРазделы.Ссылка = ТЧТовары.Ссылка)
	               |				И ТЧТовары.НомерРаздела = ТЧРазделы.НомерСтроки
	               |	ГДЕ
	               |		ТЧТовары.Ссылка = &ДокументСсылка";
	Если Не ВедетсяУчетПоТоварамОрганизацийБУ Тогда
		Запрос.Текст = Запрос.Текст + "
	               |		И ТЧТовары.ВидНДС = Значение(Перечисление.ВидыНДС.НДССИзменениемСрокаУплаты)";
	КонецЕсли;
	Запрос.Текст = Запрос.Текст + "
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		НомераГТД.НомерСтрокиГТД,
	               |		НомераГТД.КодТНВЭД,
	               |		НомераГТД.НаименованиеТовара,
	               |		НомераГТД.СтранаПроисхожденияТовара,
	               |		НомераГТД.СпособПроисхожденияТовара,
	               |		НомераГТД.ПризнакПроисхождения,
	               |		НомераГТД.СсылкаНомерГТД,
	               |		НомераГТД.Счетчик
	               |	ИЗ
	               |		ВТ_НовыеДанныеНомераГТД КАК НомераГТД) КАК Товары
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Товары.СтранаПроисхожденияТовара,
	               |	Товары.ПризнакПроисхождения,
	               |	Товары.КодТНВЭД,
	               |	Товары.НаименованиеТовара,
	               |	Товары.СсылкаНомерГТД,
	               |	Товары.НомерСтрокиГТД,
	               |	Товары.СпособПроисхожденияТовара
	               |
	               |ИМЕЮЩИЕ
	               |	(СУММА(Товары.Счетчик) <> 0
	               |		ИЛИ Товары.СсылкаНомерГТД = ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка))";
	
	РезультатЗапрос = Запрос.Выполнить();
	
	Возврат (Не РезультатЗапрос.Пустой());

КонецФункции

//Заполнение пустых признаков происхождения по умолчанию
//
Процедура ЗаполнитьПустыеПризнакиПроисхождения(ИмяТЧ)
	
	ЭСФСервер.ЗаполнитьПустыеПризнакиПроисхождения(ЭтотОбъект, ИмяТЧ)
	
КонецПроцедуры

#КонецЕсли